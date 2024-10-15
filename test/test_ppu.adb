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
   Event : SDL.Events.Events.Events;
   Render : SDL_Renderer.Render_T;

   GB : aliased GB_T;
   PPU_Renderer : PPU.Render.PPU_Renderer_T;

   procedure Finalize is
   begin
      Set_Never_Wait (GB);
      PPU_Renderer.Quit;
      SDL_Renderer.Finalize (Render);
      Finalize (GB);
   end Finalize;

   Finish : Boolean := False;
begin
   if not SDL_Renderer.Init (Render) then
      return;
   end if;

   Init (GB);
   PPU_Renderer.Start (GB'Unchecked_Access);

   Next := Clock + Period;

   while not Finish loop
      SDL_Renderer.Render (Render, GB);

      while SDL.Events.Events.Poll (Event) loop
         if Event.Common.Event_Type = SDL.Events.Quit then
            Finish := True;
         end if;
      end loop;

      Increment_Clocks (GB, 168067);

      delay until Next;
      Next := Next + Period;
   end loop;

   Finalize;
end Test_PPU;
