with Ada.Unchecked_Conversion;
with Interfaces; use Interfaces;

package body Instructions is
   function Check_Half_Carry (Left, Right : Uint16) return Boolean is
   begin
      return (((Left and 16#0FFF#) + (Right and 16#0FFF#)) and 16#1000#)
             = 16#1000#;
   end Check_Half_Carry;

   function Check_Half_Carry (Left, Right : Uint8) return Boolean is
   begin
      return (((Left and 16#0F#) + (Right and 16#0F#)) and 16#10#) = 16#10#;
   end Check_Half_Carry;

   function Check_Sub_Half_Carry (Left, Right : Uint16) return Boolean is
   begin
      return (((Left and 16#0FFF#) - (Right and 16#0FFF#)) and 16#1000#)
             = 16#1000#;
   end Check_Sub_Half_Carry;

   function Check_Sub_Half_Carry (Left, Right : Uint8) return Boolean is
   begin
      return (((Left and 16#0F#) - (Right and 16#0F#)) and 16#10#) = 16#10#;
   end Check_Sub_Half_Carry;

   function Rotate_Left (I : Uint8; Amount : Natural := 1) return Uint8 is
   begin
      return Uint8 (Rotate_Left (Unsigned_8 (I), Amount));
   end Rotate_Left;

   function Rotate_Right (I : Uint8) return Uint8 is
   begin
      return Uint8 (Rotate_Right (Unsigned_8 (I), 1));
   end Rotate_Right;

   function Shift_Left (I : Uint8) return Uint8 is
   begin
      return Uint8 (Shift_Left (Unsigned_8 (I), 1));
   end Shift_Left;

   function Shift_Right (I : Uint8) return Uint8 is
   begin
      return Uint8 (Shift_Right (Unsigned_8 (I), 1));
   end Shift_Right;

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

   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Addr16) is
   begin
      Set_Reg (CPU, Dest, Mem (CPU, Src));
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Ptr16_T; Src : Uint8) is
   begin
      Set_Mem (CPU, Dest, Src);
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Ptr16_T; Src : Reg8_T) is
   begin
      Set_Mem (CPU, Dest, Reg (CPU, Src));
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Addr16; Src : Uint8) is
   begin
      Set_Mem (CPU, Dest, Src);
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Addr16; Src : Reg8_T) is
   begin
      Set_Mem (CPU, Dest, Reg (CPU, Src));
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Ptr8_T; Src : Uint8) is
   begin
      Set_Mem (CPU, Dest, Src);
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Ptr8_T; Src : Reg8_T) is
   begin
      Set_Mem (CPU, Dest, Reg (CPU, Src));
   end LD;

   function Decr (CPU : in out CPU_T; P : Ptr16_T) return Addr16 is
      Result : constant Addr16 := Reg (CPU, P);
   begin
      Set_Reg (CPU, P, Reg (CPU, P) - 1);

      return Result;
   end Decr;

   function Incr (CPU : in out CPU_T; P : Ptr16_T) return Addr16 is
      Result : constant Addr16 := Reg (CPU, P);
   begin
      Set_Reg (CPU, P, Reg (CPU, P) + 1);

      return Result;
   end Incr;

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
      Value : constant Word := To_Word (Reg (CPU, Src));
   begin
      Set_Mem (CPU, Dest, Value (Lo));
      Set_Mem (CPU, Dest + 1, Value (Hi));
   end LD;

   procedure LD (CPU : in out CPU_T; Dest : Reg16_T; Src : Reg16_T) is
   begin
      Set_Reg (CPU, Dest, Reg (CPU, Src));
   end LD;

   procedure LDHL (CPU : in out CPU_T; I : Int8) is
      function To_Uint8 is new Ada.Unchecked_Conversion (Int8, Uint8);

      Operand : constant Uint16 := Reg (CPU, SP);
      Result : constant Uint16 :=
         (if I >= 0 then Operand + Uint16 (I) else Operand - Uint16 (-I));
      UI : constant Uint16 := Uint16 (To_Uint8 (I));
      HF : constant Boolean :=
         (Operand and 16#F#) + (UI and 16#F#) > 16#F#;
      CF : constant Boolean :=
         (Operand and 16#FF#) + (UI and 16#FF#) > 16#FF#;
   begin
      Set_Reg (CPU, HL, Result);

      Set_Flag (CPU, Z, False);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, HF);
      Set_Flag (CPU, C, CF);
   end LDHL;

   procedure PUSH (CPU : in out CPU_T; R : Reg16_T) is
   begin
      Push (CPU, Reg (CPU, R));
   end PUSH;

   procedure POP (CPU : in out CPU_T; R : Reg16_T) is
   begin
      Set_Reg (CPU, R, Pop (CPU));
   end POP;

   --  Execute the given function with the given value if the condition
   --  that depends on the flag is true
   generic
      type T is private;
      with procedure Action (CPU : in out CPU_T; V : T);
   procedure Call_If (CPU : in out CPU_T; Flag_Cond : Cond; V : T);

   procedure Call_If (CPU : in out CPU_T; Flag_Cond : Cond; V : T) is
      Condition : Boolean;
   begin
      case Flag_Cond is
         when Z =>
            Condition := Flag (CPU, Z);
         when NZ =>
            Condition := not Flag (CPU, Z);
         when C =>
            Condition := Flag (CPU, C);
         when NC =>
            Condition := not Flag (CPU, C);
      end case;

      if Condition then
         Action (CPU, V);
         Set_Last_Branch_Taken (CPU, True);
      else
         Set_Last_Branch_Taken (CPU, False);
      end if;
   end Call_If;

   procedure CALL (CPU : in out CPU_T; Loc : Addr16) is
      Ret : constant Addr16 := Get_PC (CPU);
   begin
      --  Push return address on top of the stack
      Push (CPU, Ret);

      --  Jump to the instruction
      Set_PC (CPU, Loc);
   end CALL;

   procedure CALL (CPU : in out CPU_T; Flag_Cond : Cond; Loc : Addr16) is
      procedure Aux is new Call_If (Addr16, CALL);
   begin
      Aux (CPU, Flag_Cond, Loc);
   end CALL;

   procedure JP (CPU : in out CPU_T; Loc : Addr16) is
   begin
      Set_PC (CPU, Loc);
   end JP;

   procedure JP (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      Set_PC (CPU, Reg (CPU, P));
   end JP;

   procedure JP (CPU : in out CPU_T; Flag_Cond : Cond; Loc : Addr16) is
      procedure Aux is new Call_If (Addr16, JP);
   begin
      Aux (CPU, Flag_Cond, Loc);
   end JP;

   procedure JR (CPU : in out CPU_T; Offs : Int8) is
      New_Loc : Addr16 := Get_PC (CPU);
   begin
      if Offs >= 0 then
         New_Loc := New_Loc + Addr16 (Offs);
      else
         New_Loc := New_Loc - Addr16 (-Offs);
      end if;

      JP (CPU, New_Loc);
   end JR;

   procedure JR (CPU : in out CPU_T; Flag_Cond : Cond; Offs : Int8) is
      procedure Aux is new Call_If (Int8, JR);
   begin
      Aux (CPU, Flag_Cond, Offs);
   end JR;

   procedure RET (CPU : in out CPU_T) is
   begin
      Set_PC (CPU, Pop (CPU));
   end RET;

   procedure RET (CPU : in out CPU_T; Flag_Cond : Cond) is
      procedure Action (CPU : in out CPU_T; Dummy : Uint8) is
      begin
         RET (CPU);
      end Action;

      procedure Aux is new Call_If (Uint8, Action);
   begin
      Aux (CPU, Flag_Cond, 0);
   end RET;

   procedure RETI (CPU : in out CPU_T) is
   begin
      RET (CPU);
      Enable_Interrupts (CPU);
   end RETI;

   procedure RST (CPU : in out CPU_T; Loc : Addr16) is
   begin
      CALL (CPU, Loc);
   end RST;

   procedure ADD (CPU : in out CPU_T; Left : Reg8_T; Right : Uint8) is
      LVal : constant Uint8 := Reg (CPU, Left);
      RVal : constant Uint8 := Right;
   begin
      Set_Reg (CPU, Left, LVal + RVal);
      Set_Flag (CPU, Z, Reg (CPU, Left) = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, Check_Half_Carry (LVal, RVal));
      Set_Flag (CPU, C, LVal > Uint8'Last - RVal);
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

         Set_Flag (CPU, C, Right = Uint8'Last or else Flag (CPU, C));
         Set_Flag (CPU, H, Check_Half_Carry (Right, 1) or else Flag (CPU, H));
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
      Result : constant Uint8 := LVal - RVal;
   begin
      Set_Reg (CPU, Left, Result);
      Set_Flag (CPU, Z, Result = 0);
      Set_Flag (CPU, N, True);
      Set_Flag (CPU, H, Check_Sub_Half_Carry (LVal, RVal));
      Set_Flag (CPU, C, LVal < RVal);
   end SUB;

   procedure SUB (CPU : in out CPU_T; I : Uint8) is
   begin
      SUB (CPU, A, I);
   end SUB;

   procedure SUB (CPU : in out CPU_T; R : Reg8_T) is
   begin
      SUB (CPU, Reg (CPU, R));
   end SUB;

   procedure SUB (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      SUB (CPU, Mem (CPU, P));
   end SUB;

   procedure SBC (CPU : in out CPU_T; Left : Reg8_T; Right : Uint8) is
   begin
      if Flag (CPU, C) then
         SUB (CPU, Left, Right + 1);

         Set_Flag (CPU, C, Right = Uint8'Last or else Flag (CPU, C));
         Set_Flag (CPU, H, Check_Half_Carry (Right, 1)
                           or else Flag (CPU, H));
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
      Result : constant Uint8 := Val + 1;
   begin
      Set_Reg (CPU, R, Result);
      Set_Flag (CPU, Z, Result = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, Check_Half_Carry (Val, 1));
   end INC;

   procedure INC (CPU : in out CPU_T; P : Ptr16_T) is
      Val : constant Uint8 := Mem (CPU, P);
      Result : constant Uint8 := Val + 1;
   begin
      Set_Mem (CPU, P, Result);
      Set_Flag (CPU, Z, Result = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, Check_Half_Carry (Val, 1));
   end INC;

   procedure DEC (CPU : in out CPU_T; R : Reg8_T) is
      Val : constant Uint8 := Reg (CPU, R);
      Result : constant Uint8 := Val - 1;
   begin
      Set_Reg (CPU, R, Result);
      Set_Flag (CPU, Z, Result = 0);
      Set_Flag (CPU, N, True);
      Set_Flag (CPU, H, Check_Sub_Half_Carry (Val, 1));
   end DEC;

   procedure DEC (CPU : in out CPU_T; P : Ptr16_T) is
      Val : constant Uint8 := Mem (CPU, P);
      Result : constant Uint8 := Val - 1;
   begin
      Set_Mem (CPU, P, Result);
      Set_Flag (CPU, Z, Result = 0);
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
      Set_Flag (CPU, C, LVal > Uint16'Last - RVal);
   end ADD;

   procedure ADD (CPU : in out CPU_T; Left : Reg16_T; Right : Reg16_T) is
   begin
      ADD (CPU, Left, Reg (CPU, Right));
   end ADD;

   procedure ADD (CPU : in out CPU_T; Left : Reg16_T; Right : Int8) is
      function To_Uint8 is new Ada.Unchecked_Conversion (Int8, Uint8);

      LVal : constant Uint16 := Reg (CPU, Left);
      URight : constant Uint16 := Uint16 (To_Uint8 (Right));
      Result : constant Uint16 :=
         (if Right >= 0 then
            LVal + Uint16 (Right)
          else
            LVal - Uint16 (-Right));
      HF : constant Boolean :=
         (LVal and 16#F#) + (URight and 16#F#) > 16#F#;
      CF : constant Boolean :=
         (LVal and 16#FF#) + (URight and 16#FF#) > 16#FF#;
   begin
      Set_Reg (CPU, Left, Result);

      Set_Flag (CPU, Z, False);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, HF);
      Set_Flag (CPU, C, CF);
   end ADD;

   procedure INC (CPU : in out CPU_T; R : Reg16_T) is
   begin
      Set_Reg (CPU, R, Reg (CPU, R) + 1);
   end INC;

   procedure DEC (CPU : in out CPU_T; R : Reg16_T) is
   begin
      Set_Reg (CPU, R, Reg (CPU, R) - 1);
   end DEC;

   --  Bit Operations instructions
   procedure BIT (CPU : in out CPU_T; U : Bit_Index; I : Uint8) is
      A : constant Bitset := To_Bitset (I);
   begin
      Set_Flag (CPU, Z, not A (U));
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, True);
   end BIT;

   procedure BIT (CPU : in out CPU_T; U : Bit_Index; R : Reg8_T) is
   begin
      BIT (CPU, U, Reg (CPU, R));
   end BIT;

   procedure BIT (CPU : in out CPU_T; U : Bit_Index; P : Ptr16_T) is
   begin
      BIT (CPU, U, Mem (CPU, P));
   end BIT;

   function Set (U : Bit_Index; I : Uint8; B : Boolean) return Uint8 is
      A : Bitset := To_Bitset (I);
   begin
      A (U) := B;
      return From_Bitset (A);
   end Set;

   procedure RES (CPU : in out CPU_T; U : Bit_Index; R : Reg8_T) is
   begin
      Set_Reg (CPU, R, Set (U, Reg (CPU, R), False));
   end RES;

   procedure RES (CPU : in out CPU_T; U : Bit_Index; P : Ptr16_T) is
   begin
      Set_Mem (CPU, P, Set (U, Mem (CPU, P), False));
   end RES;

   procedure SET (CPU : in out CPU_T; U : Bit_Index; R : Reg8_T) is
   begin
      Set_Reg (CPU, R, Set (U, Reg (CPU, R), True));
   end SET;

   procedure SET (CPU : in out CPU_T; U : Bit_Index; P : Ptr16_T) is
   begin
      Set_Mem (CPU, P, Set (U, Mem (CPU, P), True));
   end SET;

   function Swap (CPU : in out CPU_T; X : Uint8) return Uint8 is
      Result : constant Uint8 := Rotate_Left (X, 4);
   begin
      Set_Flag (CPU, Z, Result = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, False);

      return Result;
   end Swap;

   procedure SWAP (CPU : in out CPU_T; R : Reg8_T) is
   begin
      Set_Reg (CPU, R, Swap (CPU, Reg (CPU, R)));
   end SWAP;

   procedure SWAP (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      Set_Mem (CPU, P, Swap (CPU, Mem (CPU, P)));
   end SWAP;

   --  Bit Shift instructions
   function RLC (CPU : in out CPU_T; I : Uint8) return Uint8 is
      A : constant Bitset := To_Bitset (I);
      Result : constant Uint8 := Rotate_Left (I);
   begin
      Set_Flag (CPU, Z, Result = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, A (7));

      return Result;
   end RLC;

   procedure RLC (CPU : in out CPU_T; R : Reg8_T) is
   begin
      Set_Reg (CPU, R, RLC (CPU, Reg (CPU, R)));
   end RLC;

   procedure RLC (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      Set_Mem (CPU, P, RLC (CPU, Mem (CPU, P)));
   end RLC;

   procedure RLCA (CPU : in out CPU_T) is
   begin
      RLC (CPU, A);

      Set_Flag (CPU, Z, False);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
   end RLCA;

   function RRC (CPU : in out CPU_T; I : Uint8) return Uint8 is
      A : constant Bitset := To_Bitset (I);
      Result : constant Uint8 := Rotate_Right (I);
   begin
      Set_Flag (CPU, Z, Result = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, A (0));

      return Result;
   end RRC;

   procedure RRC (CPU : in out CPU_T; R : Reg8_T) is
   begin
      Set_Reg (CPU, R, RRC (CPU, Reg (CPU, R)));
   end RRC;

   procedure RRC (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      Set_Mem (CPU, P, RRC (CPU, Mem (CPU, P)));
   end RRC;

   procedure RRCA (CPU : in out CPU_T) is
   begin
      RRC (CPU, A);

      Set_Flag (CPU, Z, False);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
   end RRCA;

   function RL (CPU : in out CPU_T; I : Uint8) return Uint8 is
      A : constant Bitset := To_Bitset (I);
      Result : Uint8;
      AResult : Bitset := To_Bitset (Shift_Left (I));
   begin
      AResult (0) := Flag (CPU, C);

      Result := From_Bitset (AResult);

      Set_Flag (CPU, Z, Result = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, A (7));

      return Result;
   end RL;

   procedure RL (CPU : in out CPU_T; R : Reg8_T) is
   begin
      Set_Reg (CPU, R, RL (CPU, Reg (CPU, R)));
   end RL;

   procedure RL (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      Set_Mem (CPU, P, RL (CPU, Mem (CPU, P)));
   end RL;

   procedure RLA (CPU : in out CPU_T) is
   begin
      RL (CPU, A);

      Set_Flag (CPU, Z, False);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
   end RLA;

   function RR (CPU : in out CPU_T; I : Uint8) return Uint8 is
      A : constant Bitset := To_Bitset (I);
      Result : Uint8;
      AResult : Bitset := To_Bitset (Shift_Right (I));
   begin
      AResult (7) := Flag (CPU, C);

      Result := From_Bitset (AResult);

      Set_Flag (CPU, Z, Result = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, A (0));

      return Result;
   end RR;

   procedure RR (CPU : in out CPU_T; R : Reg8_T) is
   begin
      Set_Reg (CPU, R, RR (CPU, Reg (CPU, R)));
   end RR;

   procedure RR (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      Set_Mem (CPU, P, RR (CPU, Mem (CPU, P)));
   end RR;

   procedure RRA (CPU : in out CPU_T) is
   begin
      RR (CPU, A);

      Set_Flag (CPU, Z, False);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
   end RRA;

   function SLA (CPU : in out CPU_T; I : Uint8) return Uint8 is
      A : constant Bitset := To_Bitset (I);
      Result : constant Uint8 := Shift_Left (I);
   begin
      Set_Flag (CPU, Z, Result = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, A (7));

      return Result;
   end SLA;

   procedure SLA (CPU : in out CPU_T; R : Reg8_T) is
   begin
      Set_Reg (CPU, R, SLA (CPU, Reg (CPU, R)));
   end SLA;

   procedure SLA (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      Set_Mem (CPU, P, SLA (CPU, Mem (CPU, P)));
   end SLA;

   function SRA (CPU : in out CPU_T; I : Uint8) return Uint8 is
      A : constant Bitset := To_Bitset (I);
      Result : Uint8;
      AResult : Bitset := To_Bitset (Shift_Right (I));
   begin
      AResult (7) := A (7); --  bit 7 is unchanged
      Result := From_Bitset (AResult);

      Set_Flag (CPU, Z, Result = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, A (0));

      return Result;
   end SRA;

   procedure SRA (CPU : in out CPU_T; R : Reg8_T) is
   begin
      Set_Reg (CPU, R, SRA (CPU, Reg (CPU, R)));
   end SRA;

   procedure SRA (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      Set_Mem (CPU, P, SRA (CPU, Mem (CPU, P)));
   end SRA;

   function SRL (CPU : in out CPU_T; I : Uint8) return Uint8 is
      A : constant Bitset := To_Bitset (I);
      Result : constant Uint8 := Shift_Right (I);
   begin
      Set_Flag (CPU, Z, Result = 0);
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, A (0));

      return Result;
   end SRL;

   procedure SRL (CPU : in out CPU_T; R : Reg8_T) is
   begin
      Set_Reg (CPU, R, SRL (CPU, Reg (CPU, R)));
   end SRL;

   procedure SRL (CPU : in out CPU_T; P : Ptr16_T) is
   begin
      Set_Mem (CPU, P, SRL (CPU, Mem (CPU, P)));
   end SRL;

   --  Miscellaneous instructions
   procedure CCF (CPU : in out CPU_T) is
   begin
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, not Flag (CPU, C));
   end CCF;

   procedure CPL (CPU : in out CPU_T) is
   begin
      Set_Reg (CPU, A, not Reg (CPU, A));

      Set_Flag (CPU, N, True);
      Set_Flag (CPU, H, True);
   end CPL;

   procedure DAA (CPU : in out CPU_T) is
      Val : Uint8 := Reg (CPU, A);
      Correction : Uint8 := 0;
      Carry : Boolean := False;
   begin
      if Flag (CPU, H)
         or else (not Flag (CPU, N) and then (Val and 16#F#) > 9)
      then
         Correction := Correction or 16#06#;
      end if;

      if Flag (CPU, C)
         or else (not Flag (CPU, N) and then (Val > 16#99#))
      then
         Correction := Correction or 16#60#;
         Carry := True;
      end if;

      if Flag (CPU, N) then
         Val := Val - Correction;
      else
         Val := Val + Correction;
      end if;

      Set_Reg (CPU, A, Val);

      Set_Flag (CPU, Z, Val = 0);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, Carry);
   end DAA;

   procedure DI (CPU : in out CPU_T) is
   begin
      --  This directly disables interrupts
      Disable_Interrupts (CPU);
   end DI;

   procedure EI (CPU : in out CPU_T) is
   begin
      --  Set_Should_Enable_Interrupts (CPU);
      Enable_Interrupts (CPU);
   end EI;

   procedure HALT (CPU : in out CPU_T) is
   begin
      Set_Halt_Mode (CPU);
   end HALT;

   procedure NOP (CPU : in out CPU_T) is
      pragma Unreferenced (CPU);
   begin
      null;
   end NOP;

   procedure SCF (CPU : in out CPU_T) is
   begin
      Set_Flag (CPU, N, False);
      Set_Flag (CPU, H, False);
      Set_Flag (CPU, C, True);
   end SCF;

   procedure STOP (CPU : in out CPU_T; I : Uint8) is
      pragma Unreferenced (I);
   begin
      --  HALT (CPU);
      null;
   end STOP;

   procedure PREFIX (CPU : in out CPU_T) is
   begin
      Set_CB_Prefixed (CPU);
   end PREFIX;
end Instructions;
