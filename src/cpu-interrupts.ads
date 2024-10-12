with MMU.Registers; use MMU.Registers;

package CPU.Interrupts is
   function Pending_Interrupt (CPU : CPU_T) return Boolean;
   procedure Handle_Interrupts (CPU : in out CPU_T);

   --  Following procedure should be called whenever the given interrupt
   --  happens. The procedure will check if the given interrupt is enabled
   --  and will set the IF register accordingly
   procedure Interrupt_VBlank (CPU : in out CPU_T);
   procedure Interrupt_Timer_Overflow (CPU : in out CPU_T);
   procedure Interrupt_Serial_Transfer_Completion (CPU : in out CPU_T);
   procedure Interrupt_KeyPad (CPU : in out CPU_T);

   --  Following procedures should be called whenever the given interrupt
   --  happens. The procedure check if the ie flag for LCDC_Status is enable
   --  and check if the interrupt is selected in the STAT register
   procedure Interrupt_HBlank (CPU : in out CPU_T);
   procedure Interrupt_LY_Coincidence (CPU : in out CPU_T);
private
   type Jump_Address_T is array (Interrupt_Enum) of Addr16;
   Jump_Address : constant Jump_Address_T :=
      [VBlank => 16#0040#,
       LCDC_Status => 16#0048#,
       Timer_Overflow => 16#0050#,
       Serial_Transfer_Completion => 16#0058#,
       KeyPad => 16#0060#];
   procedure Interrupt (CPU : in out CPU_T; Int : Interrupt_Enum);
end CPU.Interrupts;
