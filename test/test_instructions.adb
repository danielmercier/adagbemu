with HAL; use HAL;
with GB; use GB;
with CPU; use CPU;
with Instructions; use Instructions;

procedure Test_Instructions is
   GB : GB_T;

   procedure Test_Push (GB : in out GB_T) is
      Val : constant Uint16 := 16#4578#;
   begin
      Set_Reg (GB.CPU, HL, Val);
      PUSH (GB.CPU, HL);
      Set_Reg (GB.CPU, HL, Val + 10);
      PUSH (GB.CPU, HL);
      Set_Reg (GB.CPU, HL, Val + 20);
      PUSH (GB.CPU, HL);

      POP (GB.CPU, BC);
      pragma Assert (Reg (GB.CPU, BC) = Val + 20);
      POP (GB.CPU, BC);
      pragma Assert (Reg (GB.CPU, BC) = Val + 10);
      POP (GB.CPU, BC);
      pragma Assert (Reg (GB.CPU, BC) = Val);
   end Test_Push;
begin
   Init (GB);

   Test_Push (GB);

   Finalize (GB);
end Test_Instructions;
