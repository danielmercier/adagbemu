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

   procedure Interrupt (CPU : in out CPU_T; Int : Interrupt_Enum) is
      IE : constant Interrupt_Array := MMU.Registers.IE (CPU.Memory);
   begin
      if IE (Int) then
         Set_IF (CPU.Memory, Int,  True);
      end if;
   end Interrupt;

   procedure Interrupt_STAT_VBlank (CPU : in out CPU_T) is
      IE : constant Interrupt_Array := MMU.Registers.IE (CPU.Memory);
      STAT : constant STAT_T := MMU.Registers.STAT (CPU.Memory);
   begin
      if IE (LCDC_Status) then
         if STAT.VBlank_Interrupt then
            Set_IF (CPU.Memory, LCDC_Status, True);
         end if;
      end if;
   end Interrupt_STAT_VBlank;

   procedure Interrupt_STAT_HBlank (CPU : in out CPU_T) is
      IE : constant Interrupt_Array := MMU.Registers.IE (CPU.Memory);
      STAT : constant STAT_T := MMU.Registers.STAT (CPU.Memory);
   begin
      if IE (LCDC_Status) then
         if STAT.HBlank_Interrupt then
            Set_IF (CPU.Memory, LCDC_Status, True);
         end if;
      end if;
   end Interrupt_STAT_HBlank;

   procedure Interrupt_STAT_LY_Coincidence (CPU : in out CPU_T) is
      IE : constant Interrupt_Array := MMU.Registers.IE (CPU.Memory);
      STAT : constant STAT_T := MMU.Registers.STAT (CPU.Memory);
   begin
      if IE (LCDC_Status) then
         if STAT.Coincidence_Interrupt then
            Set_IF (CPU.Memory, LCDC_Status, True);
         end if;
      end if;
   end Interrupt_STAT_LY_Coincidence;

   procedure Interrupt_STAT_OAM (CPU : in out CPU_T) is
      IE : constant Interrupt_Array := MMU.Registers.IE (CPU.Memory);
      STAT : constant STAT_T := MMU.Registers.STAT (CPU.Memory);
   begin
      if IE (LCDC_Status) then
         if STAT.OAM_Interrupt then
            Set_IF (CPU.Memory, LCDC_Status, True);
         end if;
      end if;
   end Interrupt_STAT_OAM;
end CPU.Interrupts;
