with SDL.Video.Windows;
with SDL.Video.Renderers;
with SDL.Events; use SDL.Events;
with SDL.Events.Events; use SDL.Events.Events;

with SDL_Renderer;

with HAL; use HAL;

with PPU.Render;
with Timer;
with Loader; use Loader;
with GB; use GB;
with Decoder; use Decoder;

procedure Main is
   --  reference to the application window
   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event : SDL.Events.Events.Events;

   Finish : Boolean := False;

   GB : aliased GB_T;

   procedure Finalize is
   begin
      Window.Finalize;
      SDL.Finalise;
      Finalize (GB);
   end Finalize;
begin
   Init (GB);
   Load ("mem/instr_timing.gb", GB, 16#0000#);

   if not SDL_Renderer.Init (Window, Renderer) then
      Finalize;

      return;
   end if;

   while not Finish loop
      SDL_Renderer.Render (Renderer, GB);

      Window.Update_Surface;

      while SDL.Events.Events.Poll (Event) loop
         if Event.Common.Event_Type = SDL.Events.Quit then
            Finish := True;
         end if;
      end loop;

      loop
         declare
            Cycles : constant Clock_T := Emulate_Cycle (GB);
         begin
            Timer.Update (GB, Cycles);
            exit when PPU.Render.Render (GB, Cycles);
         end;
      end loop;
   end loop;

   Finalize;
end Main;
