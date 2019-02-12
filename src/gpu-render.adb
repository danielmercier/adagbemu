package body GPU.Render is
   procedure Render (GB : in out GB_T) is
   begin
      --  Emulate reading of OAM
      GB.Main_Clock.Will_Wait (Read_OAM);
      GB.Main_Clock.Wait;

      --  Emulate reading of VRAM
      GB.Main_Clock.Will_Wait (Read_VRAM);
      GB.Main_Clock.Wait;

      for Y in Screen_Y loop
         GB.Main_Clock.Will_Wait (HBlank);
         --  render a line just after that
         Renderscan
            (Screen => GB.Screen,
             Mem => GB.Memory,
             Line => Screen_Y (LY (GB.Memory)),
             LCDC => LCDC (GB.Memory),
             Scroll_X => Screen_Background_X (SCX (GB.Memory)),
             Scroll_Y => Screen_Background_Y (SCY (GB.Memory)));
         Increment_LY (GB.Memory);
         GB.Main_Clock.Wait;
      end loop;

      for Y in 1 .. VBlank_Line_Number loop
         GB.Main_Clock.Will_Wait (VBlank);
         Increment_LY (GB.Memory);
         GB.Main_Clock.Wait;
      end loop;

      --  Vertical blank finished, can reset ly
      Reset_LY (GB.Memory);
   end Render;
end GPU.Render;
