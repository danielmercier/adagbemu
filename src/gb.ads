with HAL; use HAL;
with MMU; use MMU;
with CPU; use CPU;
with PPU; use PPU;

package GB is
   protected type Clock_Waiter_T is
      procedure Increment (Amount : Clock_T);

      --  Set this to never wait when calling Wait
      procedure Set_Never_Wait (B : Boolean);

      procedure Will_Wait (Amount : Clock_T);
      entry Wait;
   private
      Clock : Clock_T := 0;
      Waiting_Amount : Clock_T;
      Is_Ok : Boolean := True;
      Never_Wait : Boolean := False;
   end Clock_Waiter_T;

   type Clock_Waiter_Enum is (CW_PPU, CW_Timers);
   type Clock_Waiters_T is array (Clock_Waiter_Enum) of Clock_Waiter_T;

   type GB_T is limited record
      Memory : Memory_T;
      CPU : CPU_T;

      --  For the task version
      Clock_Waiters : Clock_Waiters_T;

      PPU_State : PPU.State;

      --  For the non task version
      Div_Current_Cycles : Clock_T := 0;
      Tima_Current_Cycles : Clock_T := 0;

      Screen : Screen_T;
   end record;

   type GB_P is access all GB_T;

   procedure Set_Never_Wait (GB : in out GB_T);
   procedure Increment_Clocks (GB : in out GB_T; Amount : Clock_T := 1);

   procedure Init (GB : out GB_T);
   procedure Load (GB : in out GB_T; Filename : String);
   procedure Finalize (GB : in out GB_T);
end GB;
