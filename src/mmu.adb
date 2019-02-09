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
   end Memory_P;

   function BG_Tile_Map (LCDC : LCDC_T) return Addr16 is
   begin
      if LCDC (Select_BG_Tile_Map_1) then
         return Tile_Map_1'First;
      else
         return Tile_Map_0'First;
      end if;
   end BG_Tile_Map;
end MMU;
