with SDL.Video.Windows.Makers; use SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers; use SDL.Video.Renderers.Makers;
with SDL.Video.Palettes; use SDL.Video.Palettes;
with SDL.Video.Rectangles; use SDL.Video.Rectangles;

with HAL; use HAL;
with CPU; use CPU;
with MMU.Registers; use MMU.Registers;

use type SDL.Coordinate;

package body SDL_Renderer is
   use type Windows.Window_Flags;

   function To_SDL_Colour (C : Color_T) return Colour is
   begin
      return Colour'(
         Colour_Component (C.R),
         Colour_Component (C.G),
         Colour_Component (C.B),
         Colour_Component (C.A)
      );
   end To_SDL_Colour;

   Tiles_Per_Line : constant := 16#10#;
   Tiles_Count : constant := 16#180#;

   function Init
      (R : out Render_T; Render_VRAM : Boolean := False) return Boolean is
   begin
      if not SDL.Initialise (Flags => SDL.Enable_Screen) then
         return False;
      end if;

      Create (Win      => R.Main_Window,
              Title    => "GameBoy Emulator",
              Position => SDL.Video.Windows.Centered_Window_Position,
              Size     => SDL.Positive_Sizes'(Width, Height),
              Flags    => Windows.Windowed or Windows.OpenGL);

      Create (R.Main_Renderer, R.Main_Window.Get_Surface);

      R.Render_VRAM := Render_VRAM;

      if Render_VRAM then
         Create (Win      => R.VRAM_Window,
                 Title    => "GameBoy Emulator",
                 Position => SDL.Video.Windows.Centered_Window_Position,
                 Size     =>
                    SDL.Positive_Sizes'(Tiles_Per_Line * Pixel_Size * 8,
                                        (Tiles_Count / Tiles_Per_Line)
                                        * Pixel_Size * 8),
                 Flags    => Windows.Windowed or Windows.OpenGL);

         Create (R.VRAM_Renderer, R.VRAM_Window.Get_Surface);
      end if;

      return True;
   end Init;

   procedure Finalize (R : in out Render_T) is
   begin
      R.Main_Window.Finalize;
      SDL.Finalise;
   end Finalize;

   function Palette (Color : Pixel_Color) return Colour is
   begin
      case Color is
         when 0 => return (255, 255, 255, 255);
         when 1 => return (168, 168, 168, 255);
         when 2 => return (85, 85, 85, 255);
         when 3 => return (0, 0, 0, 255);
      end case;
   end Palette;

   procedure VRAM_Render
      (Renderer : in out SDL.Video.Renderers.Renderer;
       GB : GB_T)
   is
      Addr : Addr16 := 16#8000#;

      type Tile_T is array (0 .. 15) of Bitset;
      Tile : Tile_T;
      Pixel : Rectangle := (0, 0, Pixel_Size, Pixel_Size);
      NTile : Natural := 0;
   begin
      while Addr < 16#A000# loop
         for I in 0 .. 15 loop
            Tile (I) := To_Bitset (Mem (GB.CPU, Addr + Addr16 (I)));
         end loop;

         --  Render the 8x8 tile
         for X in 0 .. 7 loop
            for Y in 0 .. 7 loop
               declare
                  Color : constant Pixel_Color :=
                       Boolean'Pos (Tile (Y * 2) (Uint8 (7 - X))) * 2
                     + Boolean'Pos (Tile (Y * 2 + 1) (Uint8 (7 - X)));
               begin
                  Renderer.Set_Draw_Colour (Palette (Color));

                  Pixel.X := SDL.Coordinate ((NTile mod Tiles_Per_Line) * 8 * Pixel_Size + X * Pixel_Size);
                  Pixel.Y := SDL.Coordinate ((NTile / Tiles_Per_Line) * 8 * Pixel_Size + Y * Pixel_Size);

                  Renderer.Fill (Pixel);
               end;
            end loop;
         end loop;

         Addr := Addr + 16; --  Each tile have 16 bytes
         NTile := NTile + 1;
      end loop;
   end VRAM_Render;

   procedure Render
      (R : in out Render_T; GB : GB_T)
   is
      Pixel : Rectangle := (0, 0, Pixel_Size, Pixel_Size);
      Background : constant Rectangle := (0, 0, Width, Height);
   begin
      R.Main_Renderer.Set_Draw_Colour ((0, 0, 0, 255));
      R.Main_Renderer.Fill (Background);

      for X in GB.Screen'Range (1) loop
         for Y in GB.Screen'Range (2) loop
            R.Main_Renderer.Set_Draw_Colour (To_SDL_Colour (GB.Screen (X, Y)));

            Pixel.X := SDL.Coordinate (X) * Pixel_Size;
            Pixel.Y := SDL.Coordinate (Y) * Pixel_Size;
            R.Main_Renderer.Fill (Pixel);
         end loop;
      end loop;

      R.Main_Window.Update_Surface;

      if R.Render_VRAM then
         VRAM_Render (R.VRAM_Renderer, GB);
         R.VRAM_Window.Update_Surface;
      end if;
   end Render;
end SDL_Renderer;
