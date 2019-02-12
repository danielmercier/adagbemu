package body CPU.Interrupts is
   procedure Handle_Interrupts (CPU : in out CPU_T) is
      Interrupt_Flag : constant Interrupt_Array := IFF (CPU.Memory);
   begin
      for Interrupt in Interrupt_Enum loop
         if Interrupt_Flag (Interrupt) then
            Set_IF (CPU.Memory, Interrupt, False);
            Push (CPU, Get_PC (CPU));
            Set_PC (CPU, Jump_Address (Interrupt));
            Disable_Interrupts (CPU);
            exit;
         end if;
      end loop;
   end Handle_Interrupts;
end CPU.Interrupts;
