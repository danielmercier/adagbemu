with CPU.Interrupts; use CPU.Interrupts;

package body Decoder is
   procedure Emulate_Cycle (GB : in out GB_T) is
      OPCode : OPCode_T := Fetch (GB.CPU);
   begin
      if Interrupt_Master_Enable (GB.CPU) then
         --  Check here for any inerrupt before fetching
         Handle_Interrupts (GB.CPU);
      end if;

      OPCode := Fetch (GB.CPU);
      Increment_PC (GB.CPU);
      Decode (GB, OPCode);
   end Emulate_Cycle;

   function Fetch (CPU : CPU_T) return OPCode_T is
   begin
      return OPCode_T (Mem (CPU, Get_PC (CPU)));
   end Fetch;

   procedure Decode (GB : in out GB_T; OPCode : OPCode_T) is
      Instruction_Info : Instruction_Info_T;
   begin
      case OPCode is
         when 16#CB# =>
            Instruction_Info := CBprefixed (Fetch (GB.CPU));
            --  We fetch the next opcode, so we need to increment the pc
            Increment_PC (GB.CPU);
         when others =>
            Instruction_Info := Unprefixed (OPCode);
      end case;

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
