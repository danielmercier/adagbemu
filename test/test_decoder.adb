with Ada.Real_Time; use Ada.Real_Time;

with Loader; use Loader;
with GB; use GB;
with Decoder; use Decoder;

procedure Test_Decoder is
   GB : GB_T;
begin
   Init (GB);
   Load ("mem/rom", GB, 16#0000#);

   loop
      Emulate_Cycle (GB);
   end loop;
end Test_Decoder;
