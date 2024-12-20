with SDL.Events; use SDL.Events;
with SDL.Events.Events; use SDL.Events.Events;

with SDL_Renderer;

with Ada.Real_Time; use Ada.Real_Time;

with HAL; use HAL;
with GB; use GB;
with MMU; use MMU;
with MMU.Registers; use MMU.Registers;
with PPU.Render;

procedure Test_Scroll is
   Next    : Time;
   Period  : constant Time_Span := Milliseconds (1);

   --  reference to the application window
   Event : SDL.Events.Events.Events;
   Render : SDL_Renderer.Render_T;

   GB : aliased GB_T;

   Finish : Boolean := False;

   task Scroll is
      entry Start;
   end Scroll;

   task body Scroll is
      type Direction is (Up, Up_Right, Right, Down_Right, Down, Down_Left,
                         Left, Up_Left);
      Next    : Time;
      Period  : constant Time_Span := Milliseconds (10);

      Turn_Delay : constant := 20;
      Current_Turn : Integer := Turn_Delay;
      Current_Dir : Direction := Up;
   begin
      accept Start;

      Next := Clock + Period;

      while not Finish loop
         case Current_Dir is
            when Up =>
               GB.Memory.Set (SCY_Addr, GB.Memory.Get (SCY_Addr) + 1);
            when Right =>
               GB.Memory.Set (SCX_Addr, GB.Memory.Get (SCX_Addr) - 1);
            when Down =>
               GB.Memory.Set (SCY_Addr, GB.Memory.Get (SCY_Addr) - 1);
            when Left =>
               GB.Memory.Set (SCX_Addr, GB.Memory.Get (SCX_Addr) + 1);
            when Up_Left =>
               GB.Memory.Set (SCY_Addr, GB.Memory.Get (SCY_Addr) + 1);
               GB.Memory.Set (SCX_Addr, GB.Memory.Get (SCX_Addr) + 1);
            when Up_Right =>
               GB.Memory.Set (SCY_Addr, GB.Memory.Get (SCY_Addr) + 1);
               GB.Memory.Set (SCX_Addr, GB.Memory.Get (SCX_Addr) - 1);
            when Down_Right =>
               GB.Memory.Set (SCY_Addr, GB.Memory.Get (SCY_Addr) - 1);
               GB.Memory.Set (SCX_Addr, GB.Memory.Get (SCX_Addr) - 1);
            when Down_Left =>
               GB.Memory.Set (SCY_Addr, GB.Memory.Get (SCY_Addr) - 1);
               GB.Memory.Set (SCX_Addr, GB.Memory.Get (SCX_Addr) + 1);
         end case;

         delay until Next;
         Next := Next + Period;

         Current_Turn := Current_Turn - 1;

         if Current_Turn = 0 then
            Current_Turn := Turn_Delay;

            if Current_Dir = Direction'Last then
               Current_Dir := Direction'First;
            else
               Current_Dir := Direction'Succ (Current_Dir);
            end if;
         end if;
      end loop;
   end Scroll;

   procedure Finalize is
   begin
      SDL_Renderer.Finalize (Render);
      Finalize (GB);
   end Finalize;
begin
   Init (GB);
   if not SDL_Renderer.Init (Render) then
      return;
   end if;

   Scroll.Start;

   Next := Clock + Period;

   while not Finish loop
      SDL_Renderer.Render (Render, GB);

      while SDL.Events.Events.Poll (Event) loop
         if Event.Common.Event_Type = SDL.Events.Quit then
            Finish := True;
         end if;
      end loop;

      PPU.Render.Render (GB, 168067);

      delay until Next;
      Next := Next + Period;
   end loop;

   Finalize;
end Test_Scroll;
