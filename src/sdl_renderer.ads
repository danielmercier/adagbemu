with SDL.Video.Renderers;
with SDL.Video.Windows;

with GB; use GB;
with PPU; use PPU;

package SDL_Renderer is
   Pixel_Size : constant := 4;
   Width  : constant := Integer (Screen_X'Last + 1) * Pixel_Size;
   Height : constant := Integer (Screen_Y'Last + 1) * Pixel_Size;

   function Init
      (Window   : out SDL.Video.Windows.Window;
       Renderer : out SDL.Video.Renderers.Renderer)
      return Boolean;
   procedure Render
      (Renderer : in out SDL.Video.Renderers.Renderer;
       GB : GB_T);
end SDL_Renderer;
