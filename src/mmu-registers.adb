with Ada.Unchecked_Conversion;

package body MMU.Registers is
   function BG_Tile_Map (LCDC : LCDC_T) return Addr16 is
   begin
      if LCDC (Select_BG_Tile_Map_1) then
         return Tile_Map_1'First;
      else
         return Tile_Map_0'First;
      end if;
   end BG_Tile_Map;

   function LCDC (Mem : Memory_T) return LCDC_T is
      function Convert is new Ada.Unchecked_Conversion (Uint8, LCDC_T);
   begin
      return Convert (Mem.Get (LCDC_Addr));
   end LCDC;

   function LY (Mem : Memory_T) return Uint8 is
   begin
      return Mem.Get (LY_Addr);
   end LY;

   function LYC (Mem : Memory_T) return Uint8 is
   begin
      return Mem.Get (LYC_Addr);
   end LYC;

   function SCX (Mem : Memory_T) return Uint8 is
   begin
      return Mem.Get (SCX_Addr);
   end SCX;

   function SCY (Mem : Memory_T) return Uint8 is
   begin
      return Mem.Get (SCY_Addr);
   end SCY;

   function BGP (Mem : Memory_T) return Palette_T is
      function To_Palette is new Ada.Unchecked_Conversion (Uint8, Palette_T);
   begin
      return To_Palette (Mem.Get (BGP_Addr));
   end BGP;

   function IFF (Mem : Memory_T) return Interrupt_Array is
      function Convert is new Ada.Unchecked_Conversion
         (Uint8, Interrupt_Array);
   begin
      return Convert (Mem.Get (IF_Addr));
   end IFF;

   function IE (Mem : Memory_T) return Interrupt_Array is
      function Convert is new Ada.Unchecked_Conversion
         (Uint8, Interrupt_Array);
   begin
      return Convert (Mem.Get (IE_Addr));
   end IE;

   function To_STAT is new Ada.Unchecked_Conversion (Uint8, STAT_T);
   function From_STAT is new Ada.Unchecked_Conversion (STAT_T, Uint8);

   function STAT (Mem : Memory_T) return STAT_T is
   begin
      return To_STAT (Mem.Get (STAT_Addr));
   end STAT;

   procedure Set_Video_Mode (Mem : Memory_T; Mode : Video_Mode) is
      S : STAT_T := STAT (Mem);
   begin
      S.Mode := Mode;

      Mem.Set (STAT_Addr, From_STAT (S));
   end Set_Video_Mode;

   procedure Increment_LY (Mem : Memory_T) is
   begin
      Mem.Set (LY_Addr, Mem.Get (LY_Addr) + 1);
   end Increment_LY;

   procedure Reset_LY (Mem : Memory_T) is
   begin
      Mem.Set (LY_Addr, 0);
   end Reset_LY;

   procedure Set_IF (Mem : Memory_T; F : Interrupt_Enum; B : Boolean) is
      function Convert is new Ada.Unchecked_Conversion
         (Interrupt_Array, Uint8);

      Interrupt_Flag : Interrupt_Array := IFF (Mem);
      New_Val : Uint8;
   begin
      Interrupt_Flag (F) := B;
      New_Val := Convert (Interrupt_Flag);
      --  And it with 16#2F# to be sure that first 3 bit are zero
      Mem.Set (IF_Addr, New_Val and 16#2F#);
   end Set_IF;

   procedure Set_STAT (Mem : Memory_T; S : STAT_T) is
   begin
      Mem.Set (STAT_Addr, From_STAT (S));
   end Set_STAT;
end MMU.Registers;
