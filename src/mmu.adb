with Ada.Unchecked_Conversion;

package body MMU is
   protected body Memory_P is
      function Get (A : Addr16) return Uint8 is
      begin
         return Memory (A);
      end Get;

      procedure Set (A : Addr16; V : Uint8) is
      begin
         Memory (A) := V;
      end Set;

      procedure Increment_LY is
      begin
         Memory (LY_Addr) := Memory (LY_Addr) + 1;
      end Increment_LY;

      procedure Reset_LY is
      begin
         Memory (LY_Addr) := 0;
      end Reset_LY;
   end Memory_P;

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

   function SCX (Mem : Memory_T) return Uint8 is
   begin
      return Mem.Get (SCX_Addr);
   end SCX;

   function SCY (Mem : Memory_T) return Uint8 is
   begin
      return Mem.Get (SCY_Addr);
   end SCY;
end MMU;
