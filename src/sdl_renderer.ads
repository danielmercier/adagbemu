with SDL.Video.Renderers;
with SDL.Video.Windows;

with GB; use GB;

package SDL_Renderer is
   Width  : constant := 240;
   Height : constant := 320;

   function Init
      (Window   : out SDL.Video.Windows.Window;
       Renderer : out SDL.Video.Renderers.Renderer)
      return Boolean;
   procedure Render
      (Renderer : in out SDL.Video.Renderers.Renderer;
       GB : GB_T);
end SDL_Renderer;
