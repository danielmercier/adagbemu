with HAL; use HAL;

package MMU is
   type Memory_Array is limited private;

   --  Background tile map locations
   subtype Tile_Map_0 is Addr16 range 16#9800# .. 16#9BFF#;
   subtype Tile_Map_1 is Addr16 range 16#9C00# .. 16#9FFF#;

   --  Tile data (same for background and window) locations
   subtype Tile_Data_0 is Addr16 range 16#8800# .. 16#97FF#;
   subtype Tile_Data_1 is Addr16 range 16#8000# .. 16#8FFF#;

   --  Start of tile data is different from 'First
   Tile_Data_0_Start : constant Tile_Data_0 := 16#9000#;
   Tile_Data_1_Start : constant Tile_Data_1 := Tile_Data_1'First;

   LCDC_Addr : constant Addr16 := 16#FF40#;
   type LCDC_Enum is
      (BG_Window_Display,
       Obj_Display,
       Obj_Size_8x16, --  otherwise it's 8x8
       Select_BG_Tile_Map_1,
       Select_Tile_Data_1,
       Window_Display,
       Select_Window_Tile_Map_1,
       Control_Operation);
   type LCDC_T is array (LCDC_Enum) of Boolean with Pack;

   function BG_Tile_Map (LCDC : LCDC_T) return Addr16;

   protected type Memory_P is
      function Get (A : Addr16) return Uint8;
      procedure Set (A : Addr16; V : Uint8);
   private
      Memory : Memory_Array;
   end Memory_P;

   type Memory_T is access Memory_P;

private
   type Memory_Array is array (Addr16) of Uint8;
end MMU;
