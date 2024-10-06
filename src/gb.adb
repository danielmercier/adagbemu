with Ada.Unchecked_Deallocation;

with Loader; use Loader;

package body GB is
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
         if not Never_Wait then
            Is_Ok := False;
         end if;
         Waiting_Amount := Amount;
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
         null;
      end Wait;
   end Clock_Waiter_T;
end GB;
