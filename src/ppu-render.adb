package body PPU.Render is
   procedure Drawing_Process (GB : in out GB_T) is
   begin
      Renderscan
         (Screen => GB.Screen,
          Mem => GB.Memory,
          Line => Screen_Y (LY (GB.Memory)),
          LCDC => LCDC (GB.Memory),
          Scroll_X => Screen_Background_X (SCX (GB.Memory)),
          Scroll_Y => Screen_Background_Y (SCY (GB.Memory)));
   end Drawing_Process;

   procedure OAM_Process (GB : in out GB_T) is null;

   procedure HBlank_Process (GB : in out GB_T) is
   begin
      Increment_LY (GB.Memory);
   end HBlank_Process;

   procedure VBlank_Process (GB : in out GB_T) is
   begin
      Increment_LY (GB.Memory);
   end VBlank_Process;

   procedure Render (GB : in out GB_T) is
   begin
      for Y in Screen_Y loop
         --  Emulate reading of OAM
         GB.Clock_Waiters (CW_PPU).Will_Wait (Timings (OAM));
         OAM_Process (GB);
         GB.Clock_Waiters (CW_PPU).Wait;

         --  Emulate reading of VRAM
         GB.Clock_Waiters (CW_PPU).Will_Wait (Timings (Data_Transfer));
         --  render a line just after that
         Drawing_Process (GB);
         GB.Clock_Waiters (CW_PPU).Wait;

         GB.Clock_Waiters (CW_PPU).Will_Wait (Timings (HBlank));
         HBlank_Process (GB);
         GB.Clock_Waiters (CW_PPU).Wait;
      end loop;

      for Y in 1 .. VBlank_Line_Number loop
         GB.Clock_Waiters (CW_PPU).Will_Wait (Timings (VBlank));
         VBlank_Process (GB);
         GB.Clock_Waiters (CW_PPU).Wait;
      end loop;

      --  Vertical blank finished, can reset ly
      VBlank_Process (GB);
   end Render;

   procedure Process (GB : in out GB_T; M : Video_Mode) is
   begin
      case M is
         when HBlank =>
            HBlank_Process (GB);
         when VBlank =>
            VBlank_Process (GB);
         when OAM =>
            OAM_Process (GB);
         when Data_Transfer =>
            Drawing_Process (GB);
      end case;
   end Process;

   --  Compute next mode
   function Next_Mode (GB : GB_T; Mode : Video_Mode) return Video_Mode is
   begin
      case Mode is
         when HBlank =>
            if LY (GB.Memory) >= Uint8 (Screen_Y'Last + 1) then
               --  Finished drawing pixels, entering VBlank
               return VBlank;
            else
               --  Going back to OAM Scan
               return OAM;
            end if;
         when VBlank =>
            if LY (GB.Memory) >= Uint8 (Screen_Y'Last + VBlank_Line_Number) then
               --  Finished VBlank, going back to OAM scan
               Reset_LY (GB.Memory);
               return OAM;
            else
               --  Still in VBlank
               return VBlank;
            end if;
         when OAM =>
            return Data_Transfer;
         when Data_Transfer =>
            return HBlank;
      end case;
   end Next_Mode;

   procedure Render (GB : in out GB_T; Cycles : Clock_T) is
      Current_Cycles : Clock_T renames GB.PPU_Current_Cycles;
   begin
      Current_Cycles := Current_Cycles + Cycles;

      loop
         --  This loop is usefull in case the cycles to execute is very
         --  big for some reason

         declare
            Mode : constant Video_Mode := STAT (GB.Memory).Mode;
            Timing : constant Clock_T := Timings (Mode);
         begin
            if Current_Cycles >= Timing then
               --  Reduce the current cycles by the timing it takes to finish this
               --  state
               Current_Cycles := Current_Cycles - Timing;

               --  Process this state to the end
               Process (GB, Mode);

               --  Set to next state
               Set_Video_Mode (GB.Memory, Next_Mode (GB, Mode));
            else
               exit;
            end if;
         end;
      end loop;
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
