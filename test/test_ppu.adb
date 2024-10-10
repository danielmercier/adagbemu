with SDL.Video.Windows;
with SDL.Video.Renderers;
with SDL.Events; use SDL.Events;
with SDL.Events.Events; use SDL.Events.Events;

with SDL_Renderer;

with Ada.Real_Time; use Ada.Real_Time;

with GB; use GB;
with PPU.Render;

procedure Test_PPU is
   Next    : Time;
   Period  : constant Time_Span := Milliseconds (40);

   --  reference to the application window
   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event : SDL.Events.Events.Events;

   GB : GB_T;

   Finish : Boolean := False;
begin
   if not SDL_Renderer.Init (Window, Renderer) then
      return;
   end if;

   Init (GB);

   GB.Main_Clock.Set_Never_Wait (True);

   Next := Clock + Period;

   while not Finish loop
      SDL_Renderer.Render (Renderer, GB);

      Window.Update_Surface;

      while SDL.Events.Events.Poll (Event) loop
         if Event.Common.Event_Type = SDL.Events.Quit then
            Finish := True;
         end if;
      end loop;

      PPU.Render.Render (GB);

      delay until Next;
      Next := Next + Period;
   end loop;
end Test_PPU;
