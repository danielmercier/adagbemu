with HAL; use HAL;
with CPU; use CPU;

procedure Test_Registers is
   CPU : CPU_T;
begin
   Set_Reg (CPU, AF, 16#42A2#);
   pragma Assert (Reg (CPU, AF) = 16#42A2#);
   pragma Assert (Reg (CPU, A) = 16#42#);
   pragma Assert (Reg (CPU, F) = 16#A2#);
   pragma Assert (Flag (CPU, Z));
   pragma Assert (not Flag (CPU, N));
   pragma Assert (Flag (CPU, H));
   pragma Assert (not Flag (CPU, C));

   Set_Reg (CPU, BC, 16#68AE#);
   pragma Assert (Reg (CPU, BC) = 16#68AE#);
   pragma Assert (Reg (CPU, B) = 16#68#);
   pragma Assert (Reg (CPU, C) = 16#AE#);
end Test_Registers;
