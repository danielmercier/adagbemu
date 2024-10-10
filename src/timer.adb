with CPU; use CPU;
with CPU.Interrupts; use CPU.Interrupts;
with MMU.Registers; use MMU.Registers;

package body Timer is
   procedure Update (GB : in out GB_T) is
      Increments : constant := 4;

      Cycles : Clock_T := 0;
      Current_TAC : Uint8;
      New_TIMA : Uint8;
   begin
      --  We simulate a DIV tick here. One DIV tick can cause multiple TIMA
      --  ticks depending on the selected frequency

      for I in 1 .. Div_Period / Increments loop
         GB.Clock_Waiters (CW_Timers).Will_Wait (Increments);
         GB.Clock_Waiters (CW_Timers).Wait;
         Cycles := Cycles + Increments;

         Current_TAC := Mem (GB.CPU, TAC);

         if (Current_TAC and 16#04#) = 16#04#
            and then Cycles >= Timer_Periods (Current_TAC and 16#03#)
         then
            --  Increment TIMA once
            Cycles := 0;
            New_TIMA := Mem (GB.CPU, TIMA) + 1;

            if New_TIMA = 0 then
               --  Load the TMA value int TIMA
               Set_Mem (GB.CPU, TIMA, Mem (GB.CPU, TMA));

               --  Overflows, generate an interrupt
               Interrupt_Timer_Overflow (GB.CPU);
            else
               Set_Mem (GB.CPU, TIMA, New_TIMA);
            end if;
         end if;
      end loop;

      Set_Mem (GB.CPU, DIV, Mem (GB.CPU, DIV) + 1);
   end Update;

   task body Timer_T is
      GB : GB_P;
      Finish : Boolean := False;
   begin
      accept Start (GB_In : GB_P) do
         GB := GB_In;
      end Start;

      while not Finish loop
         select
            accept Quit do
               Finish := True;
            end Quit;
         else
            Update (GB.all);
         end select;
      end loop;
   end Timer_T;
end Timer;
