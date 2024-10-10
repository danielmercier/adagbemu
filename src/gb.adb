with Ada.Unchecked_Deallocation;

with Loader; use Loader;

package body GB is
   procedure Set_Never_Wait (GB : in out GB_T) is
   begin
      for C of GB.Clock_Waiters loop
         C.Set_Never_Wait (True);
      end loop;
   end Set_Never_Wait;

   procedure Increment_Clocks (GB : in out GB_T; Amount : Clock_T := 1) is
   begin
      for C of GB.Clock_Waiters loop
         C.Increment (Amount);
      end loop;
   end Increment_Clocks;

   procedure Init (GB : out GB_T) is
   begin
      GB.Memory := new Memory_P;
      Init (GB.CPU, GB.Memory);

      Load ("mem/mem.dump", GB, 16#8000#);
   end Init;

   procedure Finalize (GB : in out GB_T) is
      procedure Free is new Ada.Unchecked_Deallocation (Memory_P, Memory_T);
   begin
      Free (GB.Memory);
   end Finalize;

   protected body Clock_Waiter_T is
      procedure Increment (Amount : Clock_T) is
      begin
         Clock := Clock + Amount;
         if Clock >= Waiting_Amount then
            Is_Ok := True;
         end if;
      end Increment;

      procedure Will_Wait (Amount : Clock_T) is
      begin
         Waiting_Amount := Amount;

         if not Never_Wait then
            if Clock >= Waiting_Amount then
               Is_Ok := True;
            else
               Is_Ok := False;
            end if;
         end if;
      end Will_Wait;

      procedure Set_Never_Wait (B : Boolean) is
      begin
         Never_Wait := B;
         if B then
            Is_Ok := True;
         end if;
      end Set_Never_Wait;

      entry Wait when Is_Ok is
      begin
            --  Some additional cycles might remain, don't set to 0
         Clock := Clock - Waiting_Amount;
      end Wait;
   end Clock_Waiter_T;
end GB;
