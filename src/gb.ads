with HAL; use HAL;
with MMU; use MMU;
with CPU; use CPU;
with GPU; use GPU;

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
      Memory : Memory_T;
      CPU : CPU_T;

      Main_Clock : Clock_Waiter_T;
   
      Screen : Screen_T;
   end record;

   procedure Init (GB : out GB_T);
end GB;
