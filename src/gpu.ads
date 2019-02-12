with HAL; use HAL;
with MMU; use MMU;
with MMU.Registers; use MMU.Registers;

package GPU is
   --  The color of a pixel (the palette will decide the real color)
   type Pixel_Color is range 0 .. 3;

   type Color_T is record
      R : Uint8;
      G : Uint8;
      B : Uint8;
      A : Uint8;
   end record;

   --  The size of the screen background, only a part of it is really
   --  displayed
   type Screen_Background_X is mod 256;
   type Screen_Background_Y is mod 256;

   --  Actual coordinates really displayed
   subtype Screen_X is Screen_Background_X range 0 .. 159;
   subtype Screen_Y is Screen_Background_Y range 0 .. 143;

   --  The type representing the screen
   type Screen_T is array (Screen_X, Screen_Y) of Color_T;

   --  The size of a tile is 8x8 bits
   Tile_Size_X : constant := 8;
   Tile_Size_Y : constant := 8;

   --  Type for the X and Y of a pixel in one tile
   type Tile_Pixel_X is mod Tile_Size_X;
   type Tile_Pixel_Y is mod Tile_Size_Y;

   --  The number of tiles in the screen in x/y
   Tile_Number_X : constant := 32;
   Tile_Number_Y : constant := 32;

   --  The type for a coordinate in the grid of tiles representing the
   --  background
   type Tile_Grid_X is mod Tile_Number_X;
   type Tile_Grid_Y is mod Tile_Number_Y;

   --  Size in byte of one pixel
   One_Pixel_Size : constant := 2;

   type Signed_Tile_Pattern is range -128 .. 127;
   type Unsigned_Tile_Pattern is range 0 .. 255;

   --  function to convert a uint8 to a signed or unsigned tile pattern
   function To_Signed_Tile_Pattern (U : Uint8) return Signed_Tile_Pattern;
   function To_Unsigned_Tile_Pattern (U : Uint8) return Unsigned_Tile_Pattern;

   --  Given the X coord in grid and Y coord in grid, return the address of
   --  the first pattern number of this grid
   function Get_Start_Address
      (X : Tile_Grid_X;
       Y : Tile_Grid_Y;
       Tiles_Start_Addr : Addr16)
      return Addr16;

   --  Given the X and Y pixel of a tile, and the start address of the tile,
   --  return the color of the pixel
   function Get_Pixel_Color
      (Mem : Memory_T;
       X : Tile_Pixel_X;
       Y : Tile_Pixel_Y;
       Tile_Addr : Addr16)
      return Pixel_Color;

   --  Return Address of the tile data for the given pattern
   function Get_Tile_Address (N : Signed_Tile_Pattern) return Tile_Data_0;
   function Get_Tile_Address (N : Unsigned_Tile_Pattern) return Tile_Data_1;

   --  Use palette to get a real color from a pixel color
   function Palette (Pixel_Col : Pixel_Color) return Color_T;

   --  Render a line by modifying given screen
   procedure Renderscan
      (Screen : in out Screen_T;
       Mem : Memory_T;
       Line : Screen_Y;
       LCDC : LCDC_T;
       Scroll_X : Screen_Background_X;
       Scroll_Y : Screen_Background_Y);
end GPU;
