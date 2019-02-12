with Display;       use Display;
with Display.Basic; use Display.Basic;
with Ada.Real_Time; use Ada.Real_Time;
--with Last_Chance_Handler; pragma Unreferenced (Last_Chance_Handler);
with HAL; use HAL;
with GB; use GB;
with MMU; use MMU;
with MMU.Registers; use MMU.Registers;
with GPU; use GPU;
with GPU.Render;

procedure Test_Scroll is
   Pixel_Size : constant := 2;

   Width       : constant := 160.0 * Float (Pixel_Size);
   Height      : constant := 144.0 * Float (Pixel_Size);

   Next    : Time;
   Period  : constant Time_Span := Milliseconds (1);

   --  reference to the application window
   Window : Window_Id;

   --  reference to the graphical canvas associated with the application window
   Canvas : Canvas_Id;

   GB : GB_T;

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

      while not Is_Killed loop
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
begin
   Init (GB);

   Window :=
     Create_Window
       (Width  => Integer (Width),
        Height => Integer (Height),
        Name   => "Emulator Test Scrolling");
   Canvas := Get_Canvas (Window);

   GB.Main_Clock.Set_Never_Wait (True);

   Scroll.Start;

   Next := Clock + Period;

   while not Is_Killed loop
      for X in GB.Screen'Range (1) loop
         for Y in GB.Screen'Range (2) loop
            declare
               Color : constant Color_T := GB.Screen (X, Y);
               RGBA : constant RGBA_T :=
                  (R => Color_Component_T (Color.R),
                   G => Color_Component_T (Color.G),
                   B => Color_Component_T (Color.B),
                   A => Color_Component_T (Color.A));
            begin
               Draw_Fill_Rect
                  (Canvas => Canvas,
                   Position => (Integer (X) * Pixel_Size,
                                Integer (Y) * Pixel_Size),
                   Width => Pixel_Size,
                   Height => Pixel_Size,
                   Color => RGBA);
            end;
         end loop;
      end loop;

      Swap_Buffers (Window);

      GPU.Render.Render (GB);

      delay until Next;
      Next := Next + Period;
   end loop;
end Test_Scroll;
