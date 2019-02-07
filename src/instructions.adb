package body Instructions is
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
end Instructions;
