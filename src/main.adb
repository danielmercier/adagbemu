with SDL.Video.Windows;
with SDL.Video.Renderers;
with SDL.Events; use SDL.Events;
with SDL.Events.Events; use SDL.Events.Events;

with SDL_Renderer;

with Ada.Real_Time; use Ada.Real_Time;

with HAL; use HAL;

with PPU.Render;
with Timer;
with Loader; use Loader;
with GB; use GB;
with Decoder; use Decoder;

procedure Main is
   Next    : Time;
   Period  : constant Time_Span := Milliseconds (16);

   --  reference to the application window
   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event : SDL.Events.Events.Events;

   Finish : Boolean := False;

   GB : aliased GB_T;
   PPU_Renderer : PPU.Render.PPU_Renderer_T;
   --  Timer_Task : Timer.Timer_T;

   procedure Finalize is
   begin
      Set_Never_Wait (GB);
      PPU_Renderer.Quit;
      --  Timer_Task.Quit;
      Window.Finalize;
      SDL.Finalise;
      Finalize (GB);
   end Finalize;
begin
   Init (GB);
   Load ("mem/cpu_instrs.gb", GB, 16#0000#);

   if not SDL_Renderer.Init (Window, Renderer) then
      Finalize;

      return;
   end if;

   PPU_Renderer.Start (GB'Unchecked_Access);
   --  Timer_Task.Start (GB'Unchecked_Access);
   Next := Clock + Period;

   while not Finish loop
      SDL_Renderer.Render (Renderer, GB);

      Window.Update_Surface;

      while SDL.Events.Events.Poll (Event) loop
         if Event.Common.Event_Type = SDL.Events.Quit then
            Finish := True;
         end if;
      end loop;

      while Clock < Next loop
         declare
            Cycle_Start : constant Time := Clock;
            Cycles : constant Clock_T := Emulate_Cycle (GB);
            Cycle_Next : constant Time :=
               Cycle_Start + Nanoseconds (50) * Integer (Cycles);
         begin
            delay until Cycle_Next;
         end;
      end loop;

      delay until Next;
      Next := Next + Period;
   end loop;

   Finalize;
end Main;
