with SDL.Video.Windows;
with SDL.Video.Renderers;
with SDL.Events; use SDL.Events;
with SDL.Events.Events; use SDL.Events.Events;
with SDL.Events.Keyboards; use SDL.Events.Keyboards;

with SDL_Renderer;

with Ada.Real_Time; use Ada.Real_Time;

with HAL; use HAL;

with PPU.Render;
with Timer;
with Loader; use Loader;
with CPU; use CPU;
with GB; use GB;
with Decoder; use Decoder;
with Input; use Input;

with Ada.Command_Line; use Ada.Command_Line;

procedure Main is
   --  reference to the application window
   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event : SDL.Events.Events.Events;

   Period : constant Time_Span := Milliseconds (16);
   Next : Time;

   Finish : Boolean := False;

   GB : aliased GB_T;

   procedure Finalize is
   begin
      Window.Finalize;
      SDL.Finalise;
      Finalize (GB);
   end Finalize;

   Left : Boolean := False;
   Right : Boolean := False;
   Up : Boolean := False;
   Down : Boolean := False;
   A : Boolean := False;
   B : Boolean := False;
   Start : Boolean := False;
   Selectt : Boolean := False;
begin
   Init (GB);

   if Argument_Count >= 1 then
      Load (Argument (1), GB, 16#0000#);
   end if;

   if not SDL_Renderer.Init (Window, Renderer) then
      Finalize;

      return;
   end if;

   Next := Clock + Period;

   while not Finish loop
      SDL_Renderer.Render (Renderer, GB);

      Window.Update_Surface;

      while SDL.Events.Events.Poll (Event) loop
         case Event.Common.Event_Type is
            when SDL.Events.Quit =>
               Finish := True;
            when SDL.Events.Keyboards.Key_Up | SDL.Events.Keyboards.Key_Down =>
               declare
                  Set : constant Boolean :=
                     (if Event.Common.Event_Type = SDL.Events.Keyboards.Key_Up
                     then
                        False
                     else
                        True);
               begin
                  case Event.Keyboard.Key_Sym.Key_Code is
                     when SDL.Events.Keyboards.Code_Return =>
                        Start := Set;
                     when SDL.Events.Keyboards.Code_Backspace =>
                        Selectt := Set;
                     when SDL.Events.Keyboards.Code_Left =>
                        Left := Set;
                     when SDL.Events.Keyboards.Code_Right =>
                        Right := Set;
                     when SDL.Events.Keyboards.Code_Up =>
                        Up := Set;
                     when SDL.Events.Keyboards.Code_Down =>
                        Down := Set;
                     when SDL.Events.Keyboards.Code_A =>
                        A := Set;
                     when SDL.Events.Keyboards.Code_O =>
                        B := Set;
                     when others =>
                        null;
                  end case;
               end;
            when others =>
               null;
         end case;
      end loop;

      loop
         Update (GB, Left, Right, Up, Down, A, B, Start, Selectt);

         declare
            Cycles : constant Clock_T := Emulate_Cycle (GB);
         begin
            Timer.Update (GB, Cycles);
            DMA_Update (GB.CPU, Cycles);

            exit when PPU.Render.Render (GB, Cycles);
         end;
      end loop;

      delay until Next;
      Next := Next + Period;
   end loop;

   Finalize;
end Main;
