with HAL; use HAL;
with MMU; use MMU;

package GPU is
   --  The color of a piex
   type Pixel_Color is range 0 .. 3;

   --  The size of the screen background, only a part of it is really
   --  displayed
   type Screen_Background_X is mod 256;
   type Screen_Background_Y is mod 256;

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

   --  Given the X coord in grid and Y coord in grid, return the address of
   --  the first pixel of this grid
   function Get_Start_Address
      (X : Tile_Grid_X;
       Y : Tile_Grid_Y;
       Tiles_Start_Addr : Addr16)
      return Addr16;

   --  Given the X and Y pixel of a tile, and the start address of the tile,
   --  return the color of the pixel
   function Get_Pixel_Color
      (Memory : Memory_T;
       X : Tile_Pixel_X;
       Y : Tile_Pixel_Y;
       Tile_Addr : Addr16)
      return Pixel_Color;

   --  Return Address of the tile data for the given pattern
   function Get_Tile_Address (N : Signed_Tile_Pattern) return Tile_Data_0;
   function Get_Tile_Address (N : Unsigned_Tile_Pattern) return Tile_Data_1;
end GPU;
