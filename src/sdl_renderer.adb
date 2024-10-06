with SDL.Video.Windows.Makers; use SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers; use SDL.Video.Renderers.Makers;
with SDL.Video.Palettes; use SDL.Video.Palettes;
with SDL.Video.Rectangles; use SDL.Video.Rectangles;

with GPU; use GPU;

package body SDL_Renderer is
   function To_SDL_Colour (C : Color_T) return Colour is
   begin
      return Colour'(
         Colour_Component (C.R),
         Colour_Component (C.G),
         Colour_Component (C.B),
         Colour_Component (C.A)
      );
   end To_SDL_Colour;

   function Init
      (Window   : out SDL.Video.Windows.Window;
       Renderer : out SDL.Video.Renderers.Renderer)
      return Boolean
   is
   begin
      if not SDL.Initialise (Flags => SDL.Enable_Screen) then
         return False;
      end if;

      Create (Win      => Window,
              Title    => "GameBoy Emulator",
              Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
              Size     => SDL.Positive_Sizes'(Width, Height),
              Flags    => 0);
      Create (Renderer, Window.Get_Surface);

      return True;
   end Init;

   procedure Render
      (Renderer : in out SDL.Video.Renderers.Renderer;
       GB : GB_T)
   is
      Pixel : constant Rectangle := (0, 0, 2, 2);
      Background : constant Rectangle := (0, 0, Width, Height);
   begin
      Renderer.Set_Draw_Colour ((0, 0, 0, 255));
      Renderer.Fill (Background);

      for X in GB.Screen'Range (1) loop
         for Y in GB.Screen'Range (2) loop
            Renderer.Set_Draw_Colour (To_SDL_Colour (GB.Screen (X, Y)));
            Renderer.Fill (Pixel);
         end loop;
      end loop;
   end Render;
end SDL_Renderer;
