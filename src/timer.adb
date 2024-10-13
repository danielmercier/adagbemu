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

         Current_TAC := Mem (GB.CPU, TAC_Addr);

         if (Current_TAC and 16#04#) = 16#04#
            and then Cycles >= Timer_Periods (Current_TAC and 16#03#)
         then
            --  Increment TIMA once
            Cycles := 0;
            New_TIMA := Mem (GB.CPU, TIMA_Addr) + 1;

            if New_TIMA = 0 then
               --  Load the TMA value int TIMA
               Set_Mem (GB.CPU, TIMA_Addr, Mem (GB.CPU, TMA_Addr));

               --  Overflows, generate an interrupt
               Interrupt_Timer_Overflow (GB.CPU);
            else
               Set_Mem (GB.CPU, TIMA_Addr, New_TIMA);
            end if;
         end if;
      end loop;

      Set_Mem (GB.CPU, DIV_Addr, Mem (GB.CPU, DIV_Addr) + 1);
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

   procedure Update_Div (GB : in out GB_T; Cycles : Clock_T) is
      Current_Cycles : Clock_T renames GB.Div_Current_Cycles;
   begin
      Current_Cycles := Current_Cycles + Cycles;

      loop
         --  This loop is usefull in case the cycles to execute is very
         --  big for some reason

         if Current_Cycles >= Div_Period then
            Current_Cycles := Current_Cycles - Div_Period;
            --  Increment the Div register
            GB.Memory.Set (DIV_Addr, Mem (GB.CPU, DIV_Addr) + 1);
         else
            exit;
         end if;
      end loop;
   end Update_Div;

   procedure Update_Tima (GB : in out GB_T; Cycles : Clock_T) is
      Current_Cycles : Clock_T renames GB.Tima_Current_Cycles;
      Current_TAC : constant Uint8 := Mem (GB.CPU, TAC_Addr);
      Cur_Tima : constant Uint8 := Mem (GB.CPU, TIMA_Addr);
      Tima_Period : constant Clock_T := Timer_Periods (Current_TAC and 16#03#);
   begin
      Current_Cycles := Current_Cycles + Cycles;

      loop
         --  This loop is usefull in case the cycles to execute is very
         --  big for some reason

         if Current_Cycles >= Tima_Period then
            Current_Cycles := Current_Cycles - Tima_Period;

            --  Check if we need to increment TIMA
            if (Current_TAC and 16#04#) = 16#04# then
               --  Increment the Tima register sending an interrupt if necessary
               if Cur_Tima = 16#FF# then
                  --  Overflow, send interrupt
                  Interrupt_Timer_Overflow (GB.CPU);

                  --  Set to TMA
                  Set_Mem (GB.CPU, TIMA_Addr, Mem (GB.CPU, TMA_Addr));
               else
                  --  Increment TIMA
                  Set_Mem (GB.CPU, TIMA_Addr, Cur_Tima + 1);
               end if;
            end if;
         else
            exit;
         end if;
      end loop;
   end Update_Tima;

   procedure Update (GB : in out GB_T; Cycles : Clock_T) is
   begin
      Update_Div (GB, Cycles);
      Update_Tima (GB, Cycles);
   end Update;
end Timer;
