with SDL.Video.Windows;
with SDL.Video.Renderers;
with SDL.Events; use SDL.Events;
with SDL.Events.Events; use SDL.Events.Events;

with SDL_Renderer;

with Ada.Real_Time; use Ada.Real_Time;

with GPU.Render;
with GB; use GB;
with Decoder; use Decoder;

procedure Main is
   Next    : Time;
   Period  : constant Time_Span := Nanoseconds (1);

   --  reference to the application window
   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event : SDL.Events.Events.Events;

   Finish : Boolean := False;

   GB : GB_T;

   task GPU_Renderer;

   task body GPU_Renderer is
   begin
      while not Finish loop
         GPU.Render.Render (GB);
      end loop;
   end GPU_Renderer;

   procedure Finalize is
   begin
      Finalize (GB);
      Window.Finalize;
      SDL.Finalise;
   end Finalize;
begin
   Init (GB);

   if not SDL_Renderer.Init (Window, Renderer) then
      Finalize;

      return;
   end if;

   Next := Clock + Period;

   while not Finish loop
      SDL_Renderer.Render (Renderer, GB);

      Window.Update_Surface;

      while SDL.Events.Events.Poll (Event) loop
         if Event.Common.Event_Type = SDL.Events.Quit then
            Finish := True;
         end if;
      end loop;

      Emulate_Cycle (GB);

      --delay until Next;
      Next := Next + Period;
   end loop;

   GB.Main_Clock.Set_Never_Wait (True);

   Finalize;
end Main;
