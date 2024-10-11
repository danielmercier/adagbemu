package body CPU.Interrupts is
   function Pending_Interrupt (CPU : CPU_T) return Boolean is
   begin
      return (Mem (CPU, IF_Addr) and Mem (CPU, IE_Addr)) /= 16#00#;
   end Pending_Interrupt;

   procedure Handle_Interrupts (CPU : in out CPU_T) is
      Interrupt_Flag : constant Interrupt_Array := IFF (CPU.Memory);
   begin
      if not Debug_Interrupts_Enabled then
         return;
      end if;

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

   procedure Interrupt (CPU : in out CPU_T; Int : Interrupt_Enum) is
      IE : constant Interrupt_Array := MMU.Registers.IE (CPU.Memory);
   begin
      if IE (Int) then
         Set_IF (CPU.Memory, Int,  True);
      end if;
   end Interrupt;

   procedure Interrupt_VBlank (CPU : in out CPU_T) is
      STAT : constant STAT_T := MMU.Registers.STAT (CPU.Memory);
   begin
      --  Two possible interrupts for VBlank, one directly called VBlank
      --  and the second one from the LCDC_Status

      Interrupt (CPU, VBlank);

      if STAT.VBlank_Interrupt then
         Interrupt (CPU, LCDC_Status);
      end if;
   end Interrupt_VBlank;

   procedure Interrupt_Timer_Overflow (CPU : in out CPU_T) is
   begin
      Interrupt (CPU, Timer_Overflow);
   end Interrupt_Timer_Overflow;

   procedure Interrupt_Serial_Transfer_Completion (CPU : in out CPU_T) is
   begin
      Interrupt (CPU, Serial_Transfer_Completion);
   end Interrupt_Serial_Transfer_Completion;

   procedure Interrupt_KeyPad (CPU : in out CPU_T) is
   begin
      Interrupt (CPU, KeyPad);
   end Interrupt_KeyPad;

   procedure Interrupt_HBlank (CPU : in out CPU_T) is
      STAT : constant STAT_T := MMU.Registers.STAT (CPU.Memory);
   begin
      if STAT.HBlank_Interrupt then
         Interrupt (CPU, LCDC_Status);
      end if;
   end Interrupt_HBlank;

   procedure Interrupt_LY_Coincidence (CPU : in out CPU_T) is
      STAT : constant STAT_T := MMU.Registers.STAT (CPU.Memory);
   begin
      if STAT.Coincidence_Interrupt then
         Interrupt (CPU, LCDC_Status);
      end if;
   end Interrupt_LY_Coincidence;

   procedure Interrupt_OAM (CPU : in out CPU_T) is
      STAT : constant STAT_T := MMU.Registers.STAT (CPU.Memory);
   begin
      if STAT.OAM_Interrupt then
         Interrupt (CPU, LCDC_Status);
      end if;
   end Interrupt_OAM;
end CPU.Interrupts;
