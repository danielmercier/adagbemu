with CPU.Interrupts; use CPU.Interrupts;
with OPCode_Table; use OPCode_Table;

with Ada.Text_IO; use Ada.Text_IO;

package body Decoder is
   procedure Emulate_Cycle (GB : in out GB_T) is
      OPCode : constant OPCode_T := Fetch (GB.CPU);
   begin
      if Halt_Mode (GB.CPU) and then Pending_Interrupt (GB.CPU) then
         --  Resume execution as an interrupt is pending
         Unset_Halt_Mode (GB.CPU);
      end if;

      if Interrupt_Master_Enable (GB.CPU) then
         --  Check here for any inerrupt before fetching
         Handle_Interrupts (GB.CPU);
      end if;

      if (Halt_Mode (GB.CPU)) then
         GB.Main_Clock.Increment;
      else
         Increment_PC (GB.CPU);
         Decode (GB, OPCode);
      end if;
   end Emulate_Cycle;

   function Fetch (CPU : CPU_T) return OPCode_T is
   begin
      return OPCode_T (Mem (CPU, Get_PC (CPU)));
   end Fetch;

   procedure Decode (GB : in out GB_T; OPCode : OPCode_T) is
      Instruction_Info : Instruction_Info_T;
   begin
      if Should_Enable_Interrupts (GB.CPU) then
         --  This happens after emulating iterrupts thus we can directly
         --  re-enable it and the next instruction is before any interrupt
         Unset_Should_Enable_Interrupts (GB.CPU);
         Enable_Interrupts (GB.CPU);
      end if;

      if CB_Prefixed (GB.CPU) then
         Instruction_Info := CBprefixed (OPCode);

         --  Prefix is only applied once, unset cb prefixed
         Unset_CB_Prefixed (GB.CPU);
      else
         Instruction_Info := Unprefixed (OPCode);
      end if;

      --  Call the instruction to modifiy the CPU
      Instruction_Info.Instruction (GB.CPU);

      if Instruction_Info.Cycles.Branch then
         if Last_Branch_Taken (GB.CPU) then
            Handle_Cycles (GB, Instruction_Info.Cycles.Taken);
         else
            Handle_Cycles (GB, Instruction_Info.Cycles.Not_Taken);
         end if;
      else
         Handle_Cycles (GB, Instruction_Info.Cycles.Value);
      end if;
   end Decode;

   procedure Handle_Cycles (GB : in out GB_T; Cycles : Clock_T) is
   begin
      GB.Main_Clock.Add (Cycles);
   end Handle_Cycles;
end Decoder;
