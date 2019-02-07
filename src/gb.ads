with HAL; use HAL;
with CPU; use CPU;

package GB is
   protected type Clock_Waiter_T is
      procedure Add (Amount : Clock_T);
      procedure Increment;

      procedure Will_Wait (Amount : Clock_T);
      entry Wait;
   private
      Clock : Clock_T;
      Waiting_Amount : Clock_T;
      Is_Ok : Boolean := True;
   end Clock_Waiter_T;

   type GB_T is limited record
      CPU : CPU_T;
      Main_Clock : Clock_Waiter_T;
   end record;
end GB;
