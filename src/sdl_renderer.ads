with SDL.Video.Renderers;
with SDL.Video.Windows;

with GB; use GB;
with PPU; use PPU;

package SDL_Renderer is
   package Windows renames SDL.Video.Windows;
   package Renderers renames SDL.Video.Renderers;

   Pixel_Size : constant := 4;
   Width  : constant := Integer (Screen_X'Last + 1) * Pixel_Size;
   Height : constant := Integer (Screen_Y'Last + 1) * Pixel_Size;

   type Render_T is limited private;

   function Init
      (R : out Render_T; Render_VRAM : Boolean := False) return Boolean;
   procedure Finalize (R : in out Render_T);

   procedure Render
      (R : in out Render_T; GB : GB_T);
private
   type Render_T is limited record
      Main_Window : Windows.Window;
      Main_Renderer : Renderers.Renderer;

      Render_VRAM : Boolean := False;
      VRAM_Window : Windows.Window;
      VRAM_Renderer : Renderers.Renderer;
   end record;
end SDL_Renderer;
