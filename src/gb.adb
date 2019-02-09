with Loader; use Loader;

package body GB is
   procedure Init (GB : out GB_T) is
   begin
      GB.Memory := new Memory_P;
      Init (GB.CPU, GB.Memory);

      Load ("mem/mem.dump", GB, 16#8000#);
   end Init;

   protected body Clock_Waiter_T is
      procedure Add (Amount : Clock_T) is
      begin
         Clock := Clock + Amount;
         if Clock > Waiting_Amount then
            Is_Ok := True;
         end if;
      end Add;

      procedure Increment is
      begin
         Add (1);
      end Increment;

      procedure Will_Wait (Amount : Clock_T) is
      begin
         Is_Ok := False;
         Waiting_Amount := Amount;
      end Will_Wait;

      entry Wait when Is_Ok is
      begin
         null;
      end Wait;
   end Clock_Waiter_T;
end GB;
