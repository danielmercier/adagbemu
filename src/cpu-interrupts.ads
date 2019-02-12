with MMU.Registers; use MMU.Registers;

package CPU.Interrupts is
   procedure Handle_Interrupts (CPU : in out CPU_T);

private
   type Jump_Address_T is array (Interrupt_Enum) of Addr16;
   Jump_Address : constant Jump_Address_T :=
      (VBlank => 16#0040#,
       LCDC_Status => 16#0048#,
       Timer_Overflow => 16#0050#,
       Serial_Transfer_Completion => 16#0058#,
       KeyPad => 16#0060#);
end CPU.Interrupts;
