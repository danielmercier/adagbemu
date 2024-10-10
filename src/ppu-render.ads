with GB; use GB;

package PPU.Render is
   Read_OAM : constant Clock_T := 80;
   Read_VRAM : constant Clock_T := 172;
   HBlank : constant Clock_T := 204;
   VBlank : constant Clock_T := 456;
   --  Number of lines for the full vertical blank
   VBlank_Line_Number : constant := 10;

   --  Use timings to render the screen. Also update
   procedure Render (GB : in out GB_T);

   type GB_Access is access all GB_T;

   task type PPU_Renderer_T is
      entry Start (GB_In : GB_Access);
      entry Quit;
   end PPU_Renderer_T;

end PPU.Render;
