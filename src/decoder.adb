with CPU.Interrupts; use CPU.Interrupts;
with OPCode_Table; use OPCode_Table;
with Mnemonic_Table;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Ada.Text_IO; use Ada.Text_IO;

package body Decoder is
   function Emulate_Cycle (GB : in out GB_T) return Clock_T is
      OPCode : OPCode_T;
      Cycles : Clock_T;
   begin
      if Halt_Mode (GB.CPU) and then Pending_Interrupt (GB.CPU) then
         --  Resume execution as an interrupt is pending
         Unset_Halt_Mode (GB.CPU);
      end if;

      if Interrupt_Master_Enable (GB.CPU) then
         --  Check here for any inerrupt before fetching
         Handle_Interrupts (GB.CPU);
      end if;

      if Halt_Mode (GB.CPU) then
         Cycles := 1;
      else
         OPCode := Fetch (GB.CPU);
         Increment_PC (GB.CPU);
         Cycles := Decode (GB, OPCode) / 4; --  4 T-Cycle in 1 M-Cycle

         if Cycles = 0 then
            raise Program_Error;
         end if;
      end if;

      Handle_Cycles (GB, Cycles);
      return Cycles;
   end Emulate_Cycle;

   procedure Emulate_Cycle (GB : in out GB_T) is
      Dummy : constant Clock_T := Emulate_Cycle (GB);
   begin
      null;
   end Emulate_Cycle;

   function Fetch (CPU : CPU_T) return OPCode_T is
   begin
      return OPCode_T (Mem (CPU, Get_PC (CPU)));
   end Fetch;

   function Decode (GB : in out GB_T; OPCode : OPCode_T) return Clock_T is
      Instruction_Info : Instruction_Info_T;
      Mnemonic : Unbounded_String;
   begin
      if Should_Enable_Interrupts (GB.CPU) then
         --  This happens after emulating iterrupts thus we can directly
         --  re-enable it and the next instruction is before any interrupt
         Unset_Should_Enable_Interrupts (GB.CPU);
         Enable_Interrupts (GB.CPU);
      end if;

      if CB_Prefixed (GB.CPU) then
         Instruction_Info := CBprefixed (OPCode);
         Mnemonic := Mnemonic_Table.CBprefixed (OPCode);

         --  Prefix is only applied once, unset cb prefixed
         Unset_CB_Prefixed (GB.CPU);
      else
         Instruction_Info := Unprefixed (OPCode);
         Mnemonic := Mnemonic_Table.Unprefixed (OPCode);
      end if;

      if False then
         Put_Line (To_String (Mnemonic));
      end if;

      --  Call the instruction to modifiy the CPU
      Instruction_Info.Instruction (GB.CPU);

      if Instruction_Info.Cycles.Branch then
         if Last_Branch_Taken (GB.CPU) then
            return Instruction_Info.Cycles.Taken;
         else
            return Instruction_Info.Cycles.Not_Taken;
         end if;
      else
         return Instruction_Info.Cycles.Value;
      end if;
   end Decode;

   procedure Handle_Cycles (GB : in out GB_T; Cycles : Clock_T) is
   begin
      Increment_Clocks (GB, Cycles);
   end Handle_Cycles;
end Decoder;
