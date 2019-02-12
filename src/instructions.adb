with Ada.Unchecked_Conversion;
with Interfaces; use Interfaces;

package body Instructions is
   function Check_Half_Carry (Left, Right : Uint16) return Boolean is
   begin
      return (((Left and 16#00FF#) + (Right and 16#00FF#)) and 16#0100#)
             = 16#0100#;
   end Check_Half_Carry;

   function Check_Half_Carry (Left, Right : Uint8) return Boolean is
   begin
      return (((Left and 16#0F#) + (Right and 16#0F#)) and 16#10#) = 16#10#;
   end Check_Half_Carry;

   function Check_Sub_Half_Carry (Left, Right : Uint16) return Boolean is
   begin
      return (((Left and 16#00FF#) - (Right and 16#00FF#)) and 16#0100#)
             = 16#0100#;
   end Check_Sub_Half_Carry;

   function Check_Sub_Half_Carry (Left, Right : Uint8) return Boolean is
   begin
      return (((Left and 16#0F#) - (Right and 16#0F#)) and 16#10#) = 16#10#;
   end Check_Sub_Half_Carry;

   --  8 bit load instructions
   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Uint8) is
   begin
      Set_Reg (CPU, Dest, Src);
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Reg8_T) is
   begin
      Set_Reg (CPU, Dest, Reg (CPU, Src));
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Ptr16_T) is
   begin
      Set_Reg (CPU, Dest, Mem (CPU, Src));
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Ptr8_T) is
   begin
      Set_Reg (CPU, Dest, Mem (CPU, Src));
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Ptr16_T; Src : Uint8) is
   begin
      Set_Mem (CPU, Dest, Src);
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Ptr8_T; Src : Uint8) is
   begin
      Set_Mem (CPU, Dest, Src);
   end LD;

   procedure LDD (CPU : in out CPU_T; Dest : Ptr16_T; Src : Reg8_T) is
   begin
      Set_Mem (CPU, Dest, Reg (CPU, Src));
      Set_Reg (CPU, Dest, Reg (CPU, Dest) - 1);
   end LDD;

   procedure LDD (CPU : in out CPU_T; Dest : Reg8_T; Src : Ptr16_T) is
   begin
      Set_Reg (CPU, Dest, Mem (CPU, Src));
      Set_Reg (CPU, Src, Reg (CPU, Src) - 1);
   end LDD;

   procedure LDI (CPU : in out CPU_T; Dest : Ptr16_T; Src : Reg8_T) is
   begin
      Set_Mem (CPU, Dest, Reg (CPU, Src));
      Set_Reg (CPU, Dest, Reg (CPU, Dest) + 1);
   end LDI;

   procedure LDI (CPU : in out CPU_T; Dest : Reg8_T; Src : Ptr16_T) is
   begin
      Set_Reg (CPU, Dest, Mem (CPU, Src));
      Set_Reg (CPU, Src, Reg (CPU, Src) + 1);
   end LDI;

   procedure LDH (CPU : in out CPU_T; Dest : Addr8; Src : Reg8_T) is
      Actual_Addr : constant Addr16 := 16#FF00# + Addr16 (Dest);
   begin
      Set_Mem (CPU, Actual_Addr, Reg (CPU, Src));
   end LDH;

   procedure LDH (CPU : in out CPU_T; Dest : Reg8_T; Src : Addr8) is
      Actual_Addr : constant Addr16 := 16#FF00# + Addr16 (Src);
   begin
      Set_Reg (CPU, Dest, Mem (CPU, Actual_Addr));
   end LDH;

   procedure LD (CPU : in out CPU_T; Dest : Reg16_T; Src : Uint16) is
   begin
      Set_Reg (CPU, Dest, Src);
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Addr16; Src : Reg16_T) is
      Value : constant Word := To_Word (Reg (CPU, SRC));
   begin
      Set_Mem (CPU, Dest, Value (Lo));
      Set_Mem (CPU, Dest + 1, Value (Hi));
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Reg16_T; Src : Reg16_T) is
   begin
      Set_Reg (CPU, Dest, Reg (CPU, Src));
   end;

   procedure LDHL (CPU : in out CPU_T; R : Reg16_T; Offset : Uint8) is
      Left : constant Uint16 := Reg (CPU, R);
      Right : constant Uint16 := Uint16 (Offset);
   begin
      --  TODO: check this instruction, not sure it should be implemented this
      --  way
      Set_Reg (CPU, HL, Left + Right);
      Set_Flag (CPU, Z, False);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, Check_Half_Carry (Left, Right));
      Set_Flag (CPU, C, Left > Uint16'Last - Right);
   end LDHL;

   procedure PUSH (CPU : in out CPU_T; R : Reg16_T) is
   begin
      Push (CPU, Reg (CPU, R));
   end PUSH;

   procedure POP (CPU : in out CPU_T; R : Reg16_T) is
   begin
      Set_Reg (CPU, R, Pop (CPU));
   end POP;

   procedure JP (CPU : in out CPU_T; Loc : Addr16) is
   begin
      Set_PC (CPU, Loc);
   end JP;

   procedure JP (CPU : in out CPU_T; Flag_Cond : Cond; Loc : Addr16) is
      procedure Jump_If
         (CPU : in out CPU_T;
          Condition : Boolean;
          Loc : Addr16)
      is
      begin
         if Condition then
            JP (CPU, Loc);
            Set_Last_Branch_Taken (CPU, True);
         else
            Set_Last_Branch_Taken (CPU, False);
         end if;
      end Jump_If;
   begin
      case Flag_Cond is
         when Z =>
            Jump_If (CPU, Flag (CPU, Z), Loc);
         when NZ =>
            Jump_If (CPU, not Flag (CPU, Z), Loc);
         when C =>
            Jump_If (CPU, Flag (CPU, C), Loc);
         when NC =>
            Jump_If (CPU, not Flag (CPU, C), Loc);
      end case;
   end JP;

   procedure JR (CPU : in out CPU_T; Offs : Int8) is
      New_Loc : constant Addr16 :=
         Addr16 (Integer (Get_PC (CPU)) + Integer (Offs));
   begin
      JP (CPU, New_Loc);
   end JR;

   procedure JR (CPU : in out CPU_T; Flag_Cond : Cond; Offs : Int8)
   is
      procedure Jump_If
         (CPU : in out CPU_T;
          Condition : Boolean;
          Offs : Int8)
      is
      begin
         if Condition then
            JR (CPU, Offs);
            Set_Last_Branch_Taken (CPU, True);
         else
            Set_Last_Branch_Taken (CPU, False);
         end if;
      end Jump_If;
   begin
      case Flag_Cond is
         when Z =>
            Jump_If (CPU, Flag (CPU, Z), Offs);
         when NZ =>
            Jump_If (CPU, not Flag (CPU, Z), Offs);
         when C =>
            Jump_If (CPU, Flag (CPU, C), Offs);
         when NC =>
            Jump_If (CPU, not Flag (CPU, C), Offs);
      end case;
   end JR;

   procedure ADD (CPU : in out CPU_T; Left : Reg8_T; Right : Uint8) is
      LVal : constant Uint8 := Reg (CPU, Left);
      RVal : constant Uint8 := Right;
   begin
      Set_Reg (CPU, Left, LVal + RVal);
      Set_Flag (CPU, Z, Reg (CPU, Left) = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, Check_Half_Carry (LVal, RVal));
      Set_Flag (CPU, C, LVal > RVal - Uint8'Last);
   end ADD;

   procedure ADD (CPU : in out CPU_T; Left : Reg8_T; Right : Reg8_T) is
   begin
      ADD (CPU, Left, Reg (CPU, Right));
   end ADD;

   procedure ADD (CPU : in out CPU_T; Left : Reg8_T; Right : Ptr16_T) is
   begin
      ADD (CPU, Left, Mem (CPU, Right));
   end ADD;

   procedure ADC (CPU : in out CPU_T; Left : Reg8_T; Right : Uint8) is
   begin
      if Flag (CPU, C) then
         ADD (CPU, Left, Right + 1);
      else
         ADD (CPU, Left, Right);
      end if;
   end ADC;

   procedure ADC (CPU : in out CPU_T; Left : Reg8_T; Right : Reg8_T) is
   begin
      ADC (CPU, Left, Reg (CPU, Right));
   end ADC;

   procedure ADC (CPU : in out CPU_T; Left : Reg8_T; Right : Ptr16_T) is
   begin
      ADC (CPU, Left, Mem (CPU, Right));
   end ADC;

   procedure SUB (CPU : in out CPU_T; Left : Reg8_T; Right : Uint8) is
      LVal : constant Uint8 := Reg (CPU, Left);
      RVal : constant Uint8 := Right;
   begin
      Set_Reg (CPU, Left, LVal + RVal);
      Set_Flag (CPU, Z, Reg (CPU, Left) = 0);
      Set_Flag (CPU, N, True);
      Set_Flag (CPU, H, Check_Sub_Half_Carry (LVal, RVal));
      Set_Flag (CPU, C, Lval < Rval);
   end SUB;

   procedure SUB (CPU : in out CPU_T; Left : Reg8_T; Right : Reg8_T) is
   begin
      SUB (CPU, Left, Reg (CPU, Right));
   end SUB;

   procedure SUB (CPU : in out CPU_T; Left : Reg8_T; Right : Ptr16_T) is
   begin
      SUB (CPU, Left, Mem (CPU, Right));
   end SUB;

   procedure SBC (CPU : in out CPU_T; Left : Reg8_T; Right : Uint8) is
   begin
      if Flag (CPU, C) then
         SUB (CPU, Left, Right - 1);
      else
         SUB (CPU, Left, Right);
      end if;
   end SBC;

   procedure SBC (CPU : in out CPU_T; Left : Reg8_T; Right : Reg8_T) is
   begin
      SBC (CPU, Left, Reg (CPU, Right));
   end SBC;

   procedure SBC (CPU : in out CPU_T; Left : Reg8_T; Right : Ptr16_T) is
   begin
      SBC (CPU, Left, Mem (CPU, Right));
   end SBC;

   procedure ANDD (CPU : in out CPU_T; V : Uint8) is
   begin
      Set_Reg (CPU, A, Reg (CPU, A) and V);
      Set_Flag (CPU, Z, Reg (CPU, A) = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, True);
      Set_Flag (CPU, C, False);
   end ANDD;

   procedure ANDD (CPU : in out CPU_T; R : Reg8_T) is
   begin
      ANDD (CPU, Reg (CPU, R));
   end ANDD;

   procedure ANDD (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      ANDD (CPU, Mem (CPU, P));
   end ANDD;

   procedure ORR (CPU : in out CPU_T; V : Uint8) is
   begin
      Set_Reg (CPU, A, Reg (CPU, A) or V);
      Set_Flag (CPU, Z, Reg (CPU, A) = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, False);
   end ORR;

   procedure ORR (CPU : in out CPU_T; R : Reg8_T) is
   begin
      ORR (CPU, Reg (CPU, R));
   end ORR;

   procedure ORR (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      ORR (CPU, Mem (CPU, P));
   end ORR;

   procedure XORR (CPU : in out CPU_T; V : Uint8) is
   begin
      Set_Reg (CPU, A, Reg (CPU, A) xor V);
      Set_Flag (CPU, Z, Reg (CPU, A) = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, False);
   end XORR;

   procedure XORR (CPU : in out CPU_T; R : Reg8_T) is
   begin
      XORR (CPU, Reg (CPU, R));
   end XORR;

   procedure XORR (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      XORR (CPU, Mem (CPU, P));
   end XORR;

   procedure CP (CPU : in out CPU_T; V : Uint8) is
      LVal : constant Uint8 := Reg (CPU, A);
      RVal : constant Uint8 := V;
   begin
      Set_Flag (CPU, Z, LVal = RVal);
      Set_Flag (CPU, N, True);
      Set_Flag (CPU, H, Check_Sub_Half_Carry (LVal, RVal));
      Set_Flag (CPU, C, LVal < RVal);
   end CP;

   procedure CP (CPU : in out CPU_T; R : Reg8_T) is
   begin
      CP (CPU, Reg (CPU, R));
   end CP;

   procedure CP (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      CP (CPU, Mem (CPU, P));
   end CP;

   procedure INC (CPU : in out CPU_T; R : Reg8_T) is
      Val : constant Uint8 := Reg (CPU, R);
   begin
      Set_Reg (CPU, R, Val + 1);
      Set_Flag (CPU, Z, Reg (CPU, R) = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, Check_Half_Carry (Val, 1));
   end INC;

   procedure INC (CPU : in out CPU_T; P : Ptr16_T) is
      Val : constant Uint8 := Mem (CPU, P);
   begin
      Set_Mem (CPU, P, Val + 1);
      Set_Flag (CPU, Z, Mem (CPU, P) = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, Check_Half_Carry (Val, 1));
   end INC;

   procedure DEC (CPU : in out CPU_T; R : Reg8_T) is
      Val : constant Uint8 := Reg (CPU, R);
   begin
      Set_Reg (CPU, R, Val - 1);
      Set_Flag (CPU, Z, Reg (CPU, R) = 0);
      Set_Flag (CPU, N, True);
      Set_Flag (CPU, H, Check_Sub_Half_Carry (Val, 1));
   end DEC;

   procedure DEC (CPU : in out CPU_T; P : Ptr16_T) is
      Val : constant Uint8 := Mem (CPU, P);
   begin
      Set_Mem (CPU, P, Val - 1);
      Set_Flag (CPU, Z, Mem (CPU, P) = 0);
      Set_Flag (CPU, N, True);
      Set_Flag (CPU, H, Check_Sub_Half_Carry (Val, 1));
   end DEC;

   procedure ADD (CPU : in out CPU_T; Left : Reg16_T; Right : Uint16) is
      LVal : constant Uint16 := Reg (CPU, Left);
      RVal : constant Uint16 := Right;
   begin
      Set_Reg (CPU, Left, LVal + RVal);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, Check_Half_Carry (LVal, RVal));
      Set_Flag (CPU, C, LVal > RVal - Uint16'Last);
   end ADD;

   procedure ADD (CPU : in out CPU_T; Left : Reg16_T; Right : Reg16_T) is
   begin
      ADD (CPU, Left, Reg (CPU, Right));
   end ADD;

   procedure ADD (CPU : in out CPU_T; Left : Reg16_T; Right : Int8) is
      function Convert is new Ada.Unchecked_Conversion (Int16, Uint16);
      function Convert is new Ada.Unchecked_Conversion (Integer, Unsigned_32);

      LVal : constant Uint16 := Reg (CPU, Left);
      RVal : constant Int16 := Int16 (Right);
      Result : constant Integer := Integer (LVal) + Integer (RVal);
      U32 : constant Unsigned_32 := Convert (Result);
   begin
      Set_Reg (CPU, Left, Uint16 (U32 and 16#FFFF#));
      Set_Flag (CPU, Z, False);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, Check_Half_Carry (LVal, Convert (RVal)));
      --  TODO: not sure about what should be the carry for this one
      Set_Flag (CPU, C, Result > Integer (Uint16'Last));
   end ADD;

   procedure INC (CPU : in out CPU_T; R : Reg16_T) is
      Val : constant Uint16 := Reg (CPU, R);
   begin
      Set_Reg (CPU, R, Val + 1);
      Set_Flag (CPU, Z, Reg (CPU, R) = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, Check_Half_Carry (Val, 1));
   end INC;

   procedure DEC (CPU : in out CPU_T; R : Reg16_T) is
      Val : constant Uint16 := Reg (CPU, R);
   begin
      Set_Reg (CPU, R, Val - 1);
      Set_Flag (CPU, Z, Reg (CPU, R) = 0);
      Set_Flag (CPU, N, True);
      Set_Flag (CPU, H, Check_Sub_Half_Carry (Val, 1));
   end DEC;
end Instructions;
