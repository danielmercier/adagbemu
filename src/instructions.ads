with HAL; use HAL;
with CPU; use CPU;

package Instructions is
   --  8 bit load instructions
   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Uint8);
   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Reg8_T);
   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Ptr16_T);
   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Ptr8_T);
   procedure LD (CPU : in out CPU_T; Dest : Ptr16_T; Src : Uint8);
   procedure LD (CPU : in out CPU_T; Dest : Ptr8_T; Src : Uint8);
   --  Load from mem and decrement address
   procedure LDD (CPU : in out CPU_T; Dest : Ptr16_T; Src : Reg8_T);
   procedure LDD (CPU : in out CPU_T; Dest : Reg8_T; Src : Ptr16_T);
   --  Load from mem and increment address
   procedure LDI (CPU : in out CPU_T; Dest : Ptr16_T; Src : Reg8_T);
   procedure LDI (CPU : in out CPU_T; Dest : Reg8_T; Src : Ptr16_T);
   --  Load from/to 16#FF00# + src/dest
   procedure LDH (CPU : in out CPU_T; Dest : Addr8; Src : Reg8_T);
   procedure LDH (CPU : in out CPU_T; Dest : Reg8_T; Src : Addr8);

   --  16 bit load instructions
   procedure LD (CPU : in out CPU_T; Dest : Reg16_T; Src : Uint16);
   procedure LD (CPU : in out CPU_T; Dest : Addr16; Src : Reg16_T);
   procedure LD (CPU : in out CPU_T; Dest : Reg16_T; Src : Reg16_T);
   procedure LDHL (CPU : in out CPU_T; R : Reg16_T; Offset : Uint8);
private
   function Check_Half_Carry (Left, Right : Uint16) return Boolean;
end Instructions;
