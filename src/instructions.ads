with HAL; use HAL;
with CPU; use CPU;

package Instructions is
   type Cond is (Z, NZ, C, NC);

   --  8 bit load instructions
   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Uint8);
   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Reg8_T);
   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Ptr16_T);
   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Addr16);
   procedure LD (CPU : in out CPU_T; Dest : Reg8_T; Src : Ptr8_T);
   procedure LD (CPU : in out CPU_T; Dest : Ptr16_T; Src : Uint8);
   procedure LD (CPU : in out CPU_T; Dest : Ptr16_T; Src : Reg8_T);
   procedure LD (CPU : in out CPU_T; Dest : Addr16; Src : Uint8);
   procedure LD (CPU : in out CPU_T; Dest : Addr16; Src : Reg8_T);
   procedure LD (CPU : in out CPU_T; Dest : Ptr8_T; Src : Uint8);
   procedure LD (CPU : in out CPU_T; Dest : Ptr8_T; Src : Reg8_T);
   --  Return given pointer and decrement it
   function Decr (CPU : in out CPU_T; P : Ptr16_T) return Addr16;
   --  Return given pointer and increment it
   function Incr (CPU : in out CPU_T; P : Ptr16_T) return Addr16;
   --  Load from/to 16#FF00# + src/dest
   procedure LDH (CPU : in out CPU_T; Dest : Addr8; Src : Reg8_T);
   procedure LDH (CPU : in out CPU_T; Dest : Reg8_T; Src : Addr8);

   --  16 bit load instructions
   procedure LD (CPU : in out CPU_T; Dest : Reg16_T; Src : Uint16);
   procedure LD (CPU : in out CPU_T; Dest : Addr16; Src : Reg16_T);
   procedure LD (CPU : in out CPU_T; Dest : Reg16_T; Src : Reg16_T);
   procedure LDHL (CPU : in out CPU_T; I : Int8);
   procedure PUSH (CPU : in out CPU_T; R : Reg16_T);
   procedure POP (CPU : in out CPU_T; R : Reg16_T);

   --  Jumps and Subroutines
   procedure CALL (CPU : in out CPU_T; Loc : Addr16);
   procedure CALL (CPU : in out CPU_T; Flag_Cond : Cond; Loc : Addr16);
   procedure JP (CPU : in out CPU_T; Loc : Addr16);
   procedure JP (CPU : in out CPU_T; P : Ptr16_T);
   procedure JP (CPU : in out CPU_T; Flag_Cond : Cond; Loc : Addr16);
   procedure JR (CPU : in out CPU_T; Offs : Int8);
   procedure JR (CPU : in out CPU_T; Flag_Cond : Cond; Offs : Int8);
   procedure RET (CPU : in out CPU_T; Flag_Cond : Cond);
   procedure RET (CPU : in out CPU_T);
   procedure RETI (CPU : in out CPU_T);
   procedure RST (CPU : in out CPU_T; Loc : Addr16);

   --  8 bit arithmetic instructions
   procedure ADD (CPU : in out CPU_T; Left : Reg8_T; Right : Uint8);
   procedure ADD (CPU : in out CPU_T; Left : Reg8_T; Right : Reg8_T);
   procedure ADD (CPU : in out CPU_T; Left : Reg8_T; Right : Ptr16_T);

   procedure ADC (CPU : in out CPU_T; Left : Reg8_T; Right : Uint8);
   procedure ADC (CPU : in out CPU_T; Left : Reg8_T; Right : Reg8_T);
   procedure ADC (CPU : in out CPU_T; Left : Reg8_T; Right : Ptr16_T);

   procedure SUB (CPU : in out CPU_T; I : Uint8);
   procedure SUB (CPU : in out CPU_T; R : Reg8_T);
   procedure SUB (CPU : in out CPU_T; P : Ptr16_T);

   procedure SBC (CPU : in out CPU_T; Left : Reg8_T; Right : Uint8);
   procedure SBC (CPU : in out CPU_T; Left : Reg8_T; Right : Reg8_T);
   procedure SBC (CPU : in out CPU_T; Left : Reg8_T; Right : Ptr16_T);

   procedure ANDD (CPU : in out CPU_T; V : Uint8);
   procedure ANDD (CPU : in out CPU_T; R : Reg8_T);
   procedure ANDD (CPU : in out CPU_T; P : Ptr16_T);

   procedure ORR (CPU : in out CPU_T; V : Uint8);
   procedure ORR (CPU : in out CPU_T; R : Reg8_T);
   procedure ORR (CPU : in out CPU_T; P : Ptr16_T);

   procedure XORR (CPU : in out CPU_T; V : Uint8);
   procedure XORR (CPU : in out CPU_T; R : Reg8_T);
   procedure XORR (CPU : in out CPU_T; P : Ptr16_T);

   procedure CP (CPU : in out CPU_T; V : Uint8);
   procedure CP (CPU : in out CPU_T; R : Reg8_T);
   procedure CP (CPU : in out CPU_T; P : Ptr16_T);

   procedure INC (CPU : in out CPU_T; R : Reg8_T);
   procedure INC (CPU : in out CPU_T; P : Ptr16_T);

   procedure DEC (CPU : in out CPU_T; R : Reg8_T);
   procedure DEC (CPU : in out CPU_T; P : Ptr16_T);

   --  16 bit arithmetic instructions
   procedure ADD (CPU : in out CPU_T; Left : Reg16_T; Right : Uint16);
   procedure ADD (CPU : in out CPU_T; Left : Reg16_T; Right : Reg16_T);
   procedure ADD (CPU : in out CPU_T; Left : Reg16_T; Right : Int8);

   procedure INC (CPU : in out CPU_T; R : Reg16_T);

   procedure DEC (CPU : in out CPU_T; R : Reg16_T);

   --  Bit Operations instructions
   procedure BIT (CPU : in out CPU_T; U : Bit_Index; R : Reg8_T);
   procedure BIT (CPU : in out CPU_T; U : Bit_Index; P : Ptr16_T);
   procedure RES (CPU : in out CPU_T; U : Bit_Index; R : Reg8_T);
   procedure RES (CPU : in out CPU_T; U : Bit_Index; P : Ptr16_T);
   procedure SET (CPU : in out CPU_T; U : Bit_Index; R : Reg8_T);
   procedure SET (CPU : in out CPU_T; U : Bit_Index; P : Ptr16_T);
   procedure SWAP (CPU : in out CPU_T; R : Reg8_T);
   procedure SWAP (CPU : in out CPU_T; P : Ptr16_T);

   --  Bit Shift instructions
   procedure RLC (CPU : in out CPU_T; R : Reg8_T);
   procedure RLC (CPU : in out CPU_T; P : Ptr16_T);
   procedure RLCA (CPU : in out CPU_T);
   procedure RRC (CPU : in out CPU_T; R : Reg8_T);
   procedure RRC (CPU : in out CPU_T; P : Ptr16_T);
   procedure RRCA (CPU : in out CPU_T);
   procedure RL (CPU : in out CPU_T; R : Reg8_T);
   procedure RL (CPU : in out CPU_T; P : Ptr16_T);
   procedure RLA (CPU : in out CPU_T);
   procedure RR (CPU : in out CPU_T; R : Reg8_T);
   procedure RR (CPU : in out CPU_T; P : Ptr16_T);
   procedure RRA (CPU : in out CPU_T);
   procedure SLA (CPU : in out CPU_T; R : Reg8_T);
   procedure SLA (CPU : in out CPU_T; P : Ptr16_T);
   procedure SRA (CPU : in out CPU_T; R : Reg8_T);
   procedure SRA (CPU : in out CPU_T; P : Ptr16_T);
   procedure SRL (CPU : in out CPU_T; R : Reg8_T);
   procedure SRL (CPU : in out CPU_T; P : Ptr16_T);

   --  Miscellaneous instructions
   procedure CCF (CPU : in out CPU_T);
   procedure CPL (CPU : in out CPU_T);
   procedure DAA (CPU : in out CPU_T);
   procedure DI (CPU : in out CPU_T);
   procedure EI (CPU : in out CPU_T);
   procedure HALT (CPU : in out CPU_T);
   procedure NOP (CPU : in out CPU_T);
   procedure SCF (CPU : in out CPU_T);
   procedure STOP (CPU : in out CPU_T; I : Uint8);
   procedure PREFIX (CPU : in out CPU_T);

private
   function Check_Half_Carry (Left, Right : Uint16) return Boolean;
   function Check_Half_Carry (Left, Right : Uint8) return Boolean;
   function Check_Sub_Half_Carry (Left, Right : Uint16) return Boolean;
   function Check_Sub_Half_Carry (Left, Right : Uint8) return Boolean;
end Instructions;
