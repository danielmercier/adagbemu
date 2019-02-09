package body Instructions is
   function Check_Half_Carry (Left, Right : Uint16) return Boolean is
   begin
      return (((Left and 16#00FF#) + (Right and 16#00FF#)) and 16#10#)
             = 16#10#;
   end Check_Half_Carry;

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
   begin
      --  TODO: Don't know how to implement this, opcode is: 0x08
      raise Program_Error;
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
end Instructions;
