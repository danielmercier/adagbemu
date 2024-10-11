with GB; use GB;

package PPU.Render is
   Dot_Timing : constant Clock_T := 4;

   type Timings_T is array (Video_Mode) of Clock_T;
   Timings : constant Timings_T :=
      [HBlank => 204 / Dot_Timing,
       VBlank => 456 / Dot_Timing,
       Data_Transfer => 172 / Dot_Timing,
       OAM => 80 / Dot_Timing];

   --  Number of lines for the full vertical blank
   VBlank_Line_Number : constant := 10;

   --  Use timings to render the screen. Also update
   procedure Render (GB : in out GB_T);

   task type PPU_Renderer_T is
      entry Start (GB_In : GB_P);
      entry Quit;
   end PPU_Renderer_T;

   --  Single process update taking the number of cycles to execute
   --  Return true when video mode enters vblank
   function Render (GB : in out GB_T; Cycles : Clock_T) return Boolean;
   procedure Render (GB : in out GB_T; Cycles : Clock_T);
end PPU.Render;
