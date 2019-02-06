with Display;       use Display;
with Display.Basic; use Display.Basic;
with Ada.Real_Time; use Ada.Real_Time;
--with Last_Chance_Handler; pragma Unreferenced (Last_Chance_Handler);

procedure Main is
   Width       : constant := 240.0;
   Height      : constant := 320.0;

   Next    : Time;
   Period  : constant Time_Span := Milliseconds (40);

   --  reference to the application window
   Window : Window_Id;

   --  reference to the graphical canvas associated with the application window
   Canvas : Canvas_Id;

begin
   Window :=
     Create_Window
       (Width  => Integer (Width),
        Height => Integer (Height),
        Name   => "GameBoy Emulator");
   Canvas := Get_Canvas (Window);

   Next := Clock + Period;

   while not Is_Killed loop
      Swap_Buffers (Window);

      delay until Next;
      Next := Next + Period;
   end loop;
end Main;
