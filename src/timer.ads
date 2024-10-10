with HAL; use HAL;
with GB; use GB;

package Timer is
   task type Timer_T is
      entry Start (GB_In : GB_P);
      entry Quit;
   end Timer_T;
private
   procedure Update (GB : in out GB_T);
   --  Blocking update

   type Periods is array (Uint8 range 0 .. 3) of Clock_T;
   Timer_Periods : constant Periods := [256, 4, 16, 64];

   Div_Period : constant Clock_T := 256;
end Timer;
