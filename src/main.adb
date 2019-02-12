with Display;       use Display;
with Display.Basic; use Display.Basic;
with Ada.Real_Time; use Ada.Real_Time;
--with Last_Chance_Handler; pragma Unreferenced (Last_Chance_Handler);

with GPU; use GPU;
with GB; use GB;

procedure Main is
   Width       : constant := 240.0;
   Height      : constant := 320.0;

   Next    : Time;
   Period  : constant Time_Span := Milliseconds (40);

   --  reference to the application window
   Window : Window_Id;

   --  reference to the graphical canvas associated with the application window
   Canvas : Canvas_Id;

   Pixel_Size : constant := 2;

   GB : GB_T;
begin
   Init (GB);

   Window :=
     Create_Window
       (Width  => Integer (Width),
        Height => Integer (Height),
        Name   => "GameBoy Emulator");
   Canvas := Get_Canvas (Window);

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

      delay until Next;
      Next := Next + Period;
   end loop;
end Main;
