with Ada.Unchecked_Conversion;
with Interfaces; use Interfaces;

package body CPU is
   function "+" (R : Reg8_T) return Ptr8_T is
   begin
      return Ptr8_T (R);
   end "+";

   function "+" (R : Reg16_T) return Ptr16_T is
   begin
      return Ptr16_T (R);
   end "+";

   procedure Init (CPU : out CPU_T; Mem : Memory_T) is
   begin
      CPU.Memory := Mem;

      CPU.Registers.Regs16 :=
         (AF => 16#01B0#,
          BC => 16#0013#,
          DE => 16#00D8#,
          HL => 16#014D#,
          SP => 16#FFFE#);

      CPU.Program_Counter := 16#0100#;
   end Init;

   function Reg (CPU : CPU_T; R : Reg8_T) return Uint8 is
   begin
      return CPU.Registers.Regs8 (R);
   end Reg;

   function Reg (CPU : CPU_T; R : Reg16_T) return Uint16 is
   begin
      return CPU.Registers.Regs16 (R);
   end Reg;

   function Reg (CPU : CPU_T; P : Ptr16_T) return Addr16 is
   begin
      return Addr16 (Reg (CPU, Reg16_T (P)));
   end Reg;

   function Reg (CPU : CPU_T; P : Ptr8_T) return Addr16 is
   begin
      return 16#FF00# + Addr16 (Reg (CPU, Reg8_T (P)));
   end Reg;

   function Flag (CPU : CPU_T; F : Flag_T) return Boolean is
   begin
      return CPU.Registers.Flags (F);
   end Flag;

   procedure Set_Reg (CPU : in out CPU_T; R : Reg8_T; V : Uint8) is
   begin
      CPU.Registers.Regs8 (R) := V;
   end Set_Reg;

   procedure Set_Reg (CPU : in out CPU_T; R : Reg16_T; V : Uint16) is
   begin
      CPU.Registers.Regs16 (R) := V;
   end Set_Reg;

   procedure Set_Reg (CPU : in out CPU_T; R : Ptr16_T; V : Addr16) is
   begin
      Set_Reg (CPU, Reg16_T (R), Uint16 (V));
   end Set_Reg;

   procedure Set_Flag (CPU : in out CPU_T; F : Flag_T; B : Boolean) is
   begin
      CPU.Registers.Flags (F) := B;
   end Set_Flag;

   function Mem (CPU : CPU_T; A : Addr16) return Uint8 is
   begin
      return CPU.Memory.Get (A);
   end Mem;

   function Mem (CPU : CPU_T; P : Ptr16_T) return Uint8 is
   begin
      return Mem (CPU, Reg (CPU, P));
   end Mem;

   function Mem (CPU : CPU_T; P : Ptr8_T) return Uint8 is
   begin
      return Mem (CPU, Reg (CPU, P));
   end Mem;

   procedure Set_Mem (CPU : in out CPU_T; A : Addr16; V : Uint8) is
   begin
      CPU.Memory.Set (A, V);
   end Set_Mem;

   procedure Set_Mem (CPU : in out CPU_T; P : Ptr16_T; V : Uint8) is
   begin
      Set_Mem (CPU, Reg (CPU, P), V);
   end Set_Mem;

   procedure Set_Mem (CPU : in out CPU_T; P : Ptr8_T; V : Uint8) is
   begin
      Set_Mem (CPU, Reg (CPU, P), V);
   end Set_Mem;

   function Get_PC (CPU : CPU_T) return Addr16 is
   begin
      return CPU.Program_Counter;
   end Get_PC;

   procedure Increment_PC (CPU : in out CPU_T) is
   begin
      CPU.Program_Counter := CPU.Program_Counter + 1;
   end Increment_PC;

   procedure Set_PC (CPU : in out CPU_T; PC : Addr16) is
   begin
      CPU.Program_Counter := PC;
   end Set_PC;

   function Interrupt_Master_Enable (CPU : CPU_T) return Boolean is
   begin
      return CPU.Interrupt_Master_Enable;
   end Interrupt_Master_Enable;

   procedure Disable_Interrupts (CPU : in out CPU_T) is
   begin
      CPU.Interrupt_Master_Enable := False;
   end Disable_Interrupts;

   procedure Enable_Interrupts (CPU : in out CPU_T) is
   begin
      CPU.Interrupt_Master_Enable := True;
   end Enable_Interrupts;

   function Last_Branch_Taken (CPU : CPU_T) return Boolean is
   begin
      return CPU.Last_Branch_Taken;
   end Last_Branch_Taken;

   procedure Set_Last_Branch_Taken (CPU : in out CPU_T; B : Boolean) is
   begin
      CPU.Last_Branch_Taken := B;
   end Set_Last_Branch_Taken;

   procedure Push (CPU : in out CPU_T; Value : Uint16) is
      To_Push : constant Word := To_Word (Value);
      Stack_Pointer : constant Addr16 := Reg (CPU, SP);
   begin
      Set_Mem (CPU, Stack_Pointer - 1, To_Push (Hi));
      Set_Mem (CPU, Stack_Pointer - 2, To_Push (Lo));
      Set_Reg (CPU, SP, Stack_Pointer - 2);
   end Push;

   procedure Push (CPU : in out CPU_T; Value : Addr16) is
   begin
      Push (CPU, Uint16 (Value));
   end Push;

   function Pop (CPU : in out CPU_T) return Uint16 is
      Result : Word;
      Stack_Pointer : constant Addr16 := Reg (CPU, SP);
   begin
      Result (Lo) := Mem (CPU, Stack_Pointer);
      Result (Hi) := Mem (CPU, Stack_Pointer + 1);
      Set_Reg (CPU, SP, Stack_Pointer + 2);
      return From_Word (Result);
   end Pop;

   function Pop (CPU : in out CPU_T) return Addr16 is
      Result : constant Uint16 := Pop (CPU);
   begin
      return Addr16 (Result);
   end Pop;

   function Read_D8 (CPU : in out CPU_T) return Uint8 is
      Result : Uint8;
   begin
      Result := Mem (CPU, Get_PC (CPU));
      Increment_PC (CPU);
      return Result;
   end Read_D8;

   function Read_R8 (CPU : in out CPU_T) return Int8 is
      function Convert is new Ada.Unchecked_Conversion (Uint8, Int8);
   begin
      return Convert (Read_D8 (CPU));
   end Read_R8;

   function Read_A8 (CPU : in out CPU_T) return Addr8 is
   begin
      return Addr8 (Read_D8 (CPU));
   end Read_A8;

   function Read_D16 (CPU : in out CPU_T) return Uint16 is
      Low : Uint8;
      High : Uint8;
      Result : Uint16;
   begin
      Low := Mem (CPU, Get_PC (CPU));
      Increment_PC (CPU);
      High := Mem (CPU, Get_PC (CPU));
      Increment_PC (CPU);

      Result := Uint16 (Shift_Left (Unsigned_16 (High), 8)
                        or Unsigned_16 (Low));

      return Result;
   end Read_D16;

   function Read_A16 (CPU : in out CPU_T) return Addr16 is
   begin
      return Addr16 (Read_D16 (CPU));
   end Read_A16;
end CPU;
