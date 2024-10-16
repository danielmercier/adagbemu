with Ada.Unchecked_Conversion;

package body MMU.Registers is
   function Get_Sprites (Mem : Memory_T) return Sprite_Array is
      type Uint8_Array is array (0 .. Sprite_Size - 1) of Uint8;
      function Convert is new Ada.Unchecked_Conversion (Uint8_Array, Sprite);

      Result : Sprite_Array (1 .. Sprite_Count);
   begin
      for Sprite_N in 0 .. Sprite_Count - 1 loop
         declare
            Raw_Sprite : Uint8_Array;
         begin
            for I in Uint8_Array'Range loop
               Raw_Sprite (I) :=
                  Mem.Get (OAM_Addr'First + Sprite_N * Sprite_Size + I);
            end loop;

            Result (Sprite_N + 1) := Convert (Raw_Sprite);
         end;
      end loop;

      return Result;
   end Get_Sprites;

   function BG_Tile_Map (LCDC : LCDC_T) return Addr16 is
   begin
      if LCDC (Select_BG_Tile_Map_1) then
         return Tile_Map_1'First;
      else
         return Tile_Map_0'First;
      end if;
   end BG_Tile_Map;

   function Win_Tile_Map (LCDC : LCDC_T) return Addr16 is
   begin
      if LCDC (Select_Window_Tile_Map_1) then
         return Tile_Map_1'First;
      else
         return Tile_Map_0'First;
      end if;
   end Win_Tile_Map;

   function To_JOYP_Array is new Ada.Unchecked_Conversion (Uint8, JOYP_Array);
   function From_JOYP_Array is
      new Ada.Unchecked_Conversion (JOYP_Array, Uint8);

   function JOYP (Mem : Memory_T) return JOYP_Array is
   begin
      return To_JOYP_Array (Mem.Get (JOYP_Addr));
   end JOYP;

   procedure Set_JOYP (Mem : Memory_T; J : JOYP_Array) is
   begin
      Mem.Set (JOYP_Addr, From_JOYP_Array (J));
   end Set_JOYP;

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

   function To_Palette is new Ada.Unchecked_Conversion (Uint8, Palette_T);

   function BGP (Mem : Memory_T) return Palette_T is
   begin
      return To_Palette (Mem.Get (BGP_Addr));
   end BGP;

   function OBP (Mem : Memory_T; P : DMG_OBP_Palette) return Palette_T is
   begin
      case P is
         when OBP0 =>
            return To_Palette (Mem.Get (OBP0_Addr));
         when OBP1 =>
            return To_Palette (Mem.Get (OBP1_Addr));
      end case;
   end OBP;

   function WY (Mem : Memory_T) return Uint8 is (Mem.Get (WY_Addr));

   function WX (Mem : Memory_T) return Uint8 is (Mem.Get (WX_Addr));

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
