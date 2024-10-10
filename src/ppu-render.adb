package body PPU.Render is
   procedure Render (GB : in out GB_T) is
   begin
      for Y in Screen_Y loop
         --  Emulate reading of OAM
         GB.Clock_Waiters (CW_PPU).Will_Wait (Read_OAM);
         GB.Clock_Waiters (CW_PPU).Wait;

         --  Emulate reading of VRAM
         GB.Clock_Waiters (CW_PPU).Will_Wait (Read_VRAM);
         --  render a line just after that
         Renderscan
            (Screen => GB.Screen,
             Mem => GB.Memory,
             Line => Screen_Y (LY (GB.Memory)),
             LCDC => LCDC (GB.Memory),
             Scroll_X => Screen_Background_X (SCX (GB.Memory)),
             Scroll_Y => Screen_Background_Y (SCY (GB.Memory)));
         GB.Clock_Waiters (CW_PPU).Wait;

         GB.Clock_Waiters (CW_PPU).Will_Wait (HBlank);
         Increment_LY (GB.Memory);
         GB.Clock_Waiters (CW_PPU).Wait;
      end loop;

      for Y in 1 .. VBlank_Line_Number loop
         GB.Clock_Waiters (CW_PPU).Will_Wait (VBlank);
         Increment_LY (GB.Memory);
         GB.Clock_Waiters (CW_PPU).Wait;
      end loop;

      --  Vertical blank finished, can reset ly
      Reset_LY (GB.Memory);
   end Render;

   task body PPU_Renderer_T is
      GB : GB_P;
      Finish : Boolean := False;
   begin
      accept Start (GB_In : GB_P) do
         GB := GB_In;
      end Start;

      while not Finish loop
         select
            accept Quit do
               Finish := True;
            end Quit;
         else
            PPU.Render.Render (GB.all);
         end select;
      end loop;
   end PPU_Renderer_T;
end PPU.Render;
