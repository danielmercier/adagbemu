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

   function Last_Branch_Taken (CPU : CPU_T) return Boolean is
   begin
      return CPU.Last_Branch_Taken;
   end Last_Branch_Taken;

   procedure Set_Last_Branch_Taken (CPU : in out CPU_T; B : Boolean) is
   begin
      CPU.Last_Branch_Taken := B;
   end Set_Last_Branch_Taken;

   function Read_Next (CPU : in out CPU_T) return Uint8 is
      Result : Uint8;
   begin
      Result := Mem (CPU, Get_PC (CPU));
      Increment_PC (CPU);
      return Result;
   end Read_Next;

   function Read_Next (CPU : in out CPU_T) return Uint16 is
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
   end Read_Next;

   function Read_Next (CPU : in out CPU_T) return Addr16 is
      Next : Uint16 renames Read_Next (CPU);
   begin
      return Addr16 (Next);
   end Read_Next;
end CPU;
