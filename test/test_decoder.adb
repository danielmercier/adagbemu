with Ada.Real_Time; use Ada.Real_Time;

with Loader; use Loader;
with GB; use GB;
with Decoder; use Decoder;

procedure Test_Decoder is
   Next    : Time;
   Period  : constant Time_Span := Milliseconds (1);

   GB : GB_T;
begin
   Init (GB);
   Load ("mem/rom", GB, 16#0000#);

   Next := Clock + Period;

   loop
      Emulate_Cycle (GB);

      delay until Next;
      Next := Next + Period;
   end loop;
end Test_Decoder;
