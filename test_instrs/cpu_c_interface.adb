with GB; use GB;
with CPU; use CPU;
with Decoder; use Decoder;

with System; use System;
with Ada.Unchecked_Conversion;

package body CPU_C_Interface is
   GB : GB_T;

   Mem : Address;
   Size : Addr16;
   Num_Accesses : Natural;
   Mem_Accesses : Mem_Accesses_T;

   function Mem_Getter (Addr : Addr16) return Uint8 is
      type Uint8_Array is array (0 .. Size - 1) of Uint8;
      type Uint8_Array_Access is access Uint8_Array;
      function Convert is new Ada.Unchecked_Conversion (Address, Uint8_Array_Access);

      Ada_Mem : constant Uint8_Array_Access := Convert (Mem);
   begin
      if Addr >= Size then
         return 16#AA#;
      else
         return Ada_Mem (Addr);
      end if;
   end Mem_Getter;

   procedure Mem_Setter (Addr : Addr16; Val : Uint8) is
      Acc : Mem_Access renames Mem_Accesses (Num_Accesses);
   begin
      Acc.Typ := 1; --  MEM_ACCESS_WRITE
      Acc.Addr := Addr;
      Acc.Val := Val;
      Num_Accesses := Num_Accesses + 1;
   end Mem_Setter;

   procedure Init (Mem_Size : size_t; Mem_Access : access Uint8) is
   begin
      Debug_Test_Mode := True;

      Init (GB);

      Change_Accessors (GB.CPU, Mem_Getter'Access, Mem_Setter'Access);

      Mem := Mem_Access.all'Address;
      Size := Addr16 (Mem_Size);
      Num_Accesses := 0;
   end Init;

   procedure Get_State (State : access State_T) is
   begin
      State.AF := Reg (GB.CPU, AF);
      State.BC := Reg (GB.CPU, BC);
      State.DE := Reg (GB.CPU, DE);
      State.HL := Reg (GB.CPU, HL);

      State.SP := Reg (GB.CPU, SP);
      State.PC := Get_PC (GB.CPU);

      State.Halted := Halt_Mode (GB.CPU);
      State.Interrupts_Master_Enabled :=
         Interrupt_Master_Enable (GB.CPU)
         or else Should_Enable_Interrupts (GB.CPU);

      State.Num_Mem_Accesses := Num_Accesses;
      State.Mem_Accesses := Mem_Accesses;
   end Get_State;

   procedure Set_State (State : access State_T) is
   begin
      Set_Reg (GB.CPU, AF, State.AF);
      Set_Reg (GB.CPU, BC, State.BC);
      Set_Reg (GB.CPU, DE, State.DE);
      Set_Reg (GB.CPU, HL, State.HL);

      Set_Reg (GB.CPU, SP, State.SP);
      Set_PC (GB.CPU, State.PC);

      if State.Halted then
         Set_Halt_Mode (GB.CPU);
      else
         Unset_Halt_Mode (GB.CPU);
      end if;

      if State.Interrupts_Master_Enabled then
         Enable_Interrupts (GB.CPU);
      else
         Disable_Interrupts (GB.CPU);
         Unset_Should_Enable_Interrupts (GB.CPU);
      end if;

      Num_Accesses := 0;
   end Set_State;

   function Step return int is
   begin
      return int (Emulate_Cycle (GB));
   end Step;
end CPU_C_Interface;
