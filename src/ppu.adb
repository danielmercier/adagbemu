with Ada.Unchecked_Conversion;

package body PPU is
   function To_Signed_Tile_Pattern (U : Uint8) return Signed_Tile_Pattern is
      function Convert is new Ada.Unchecked_Conversion
         (Uint8, Signed_Tile_Pattern);
   begin
      return Convert (U);
   end To_Signed_Tile_Pattern;

   function To_Unsigned_Tile_Pattern (U : Uint8) return Unsigned_Tile_Pattern
   is
   begin
      return Unsigned_Tile_Pattern (U);
   end To_Unsigned_Tile_Pattern;

   function Get_Start_Address
      (X : Tile_Grid_X;
       Y : Tile_Grid_Y;
       Tiles_Start_Addr : Addr16)
      return Addr16 is
   begin
      return Tiles_Start_Addr + (Addr16 (Y) * Tile_Number_X) + Addr16 (X);
   end Get_Start_Address;

   function Get_Pixel_Color
      (Mem : Memory_T;
       X : Tile_Pixel_X;
       Y : Tile_Pixel_Y;
       Tile_Addr : Addr16)
      return Pixel_Color
   is
      type Bit_Array is array (Tile_Pixel_X) of Boolean with Pack;
      function Convert is new Ada.Unchecked_Conversion (Uint8, Bit_Array);

      Start_Addr : constant Addr16 :=
         Tile_Addr + (Addr16 (Y) * One_Pixel_Size);

      Low_Bit : constant Bit_Array := Convert (Mem.Get (Start_Addr));
      High_Bit : constant Bit_Array := Convert (Mem.Get (Start_Addr + 1));

      --  We need to reverse the X coordinate cause the most significant bit
      --  is the first pixel
      X_To_Use : constant Tile_Pixel_X := Tile_Pixel_X'Last - X;
   begin
      case High_Bit (X_To_Use) is
         when False =>
            case Low_Bit (X_To_Use) is
               when False => return 0;
               when True => return  1;
            end case;
         when True =>
            case Low_Bit (X_To_Use) is
               when False => return 2;
               when True => return 3;
            end case;
      end case;
   end Get_Pixel_Color;

   function Get_Tile_Address (N : Signed_Tile_Pattern) return Tile_Data_0 is
      Address : constant Integer :=
         Integer (Tile_Data_0_Start)
         + (Integer (N) * Tile_Size_X * One_Pixel_Size);
   begin
      return Addr16 (Address);
   end Get_Tile_Address;

   function Get_Tile_Address (N : Unsigned_Tile_Pattern) return Tile_Data_1 is
   begin
      return Tile_Data_1_Start + (Addr16 (N) * Tile_Size_X * One_Pixel_Size);
   end Get_Tile_Address;

   function Palette (Pixel_Col : Pixel_Color) return Color_T is
   begin
      case Pixel_Col is
         when 0 => return (255, 255, 255, 255);
         when 1 => return (168, 168, 168, 255);
         when 2 => return (85, 85, 85, 255);
         when 3 => return (0, 0, 0, 255);
      end case;
   end Palette;

   procedure Renderscan
      (Screen : in out Screen_T;
       Mem : Memory_T;
       Line : Screen_Y;
       LCDC : LCDC_T;
       Scroll_X : Screen_Background_X;
       Scroll_Y : Screen_Background_Y)
   is
      Tile_Map_Start : constant Addr16 := BG_Tile_Map (LCDC);

      Pixel_X : Screen_Background_X := Scroll_X;
      Pixel_Y : constant Screen_Background_Y := Line + Scroll_Y;

      X_In_Grid : Tile_Grid_X := Tile_Grid_X (Pixel_X / Tile_Size_X);
      Y_In_Grid : constant Tile_Grid_Y := Tile_Grid_Y (Pixel_Y / Tile_Size_Y);

      X_In_Tile : Tile_Pixel_X := Tile_Pixel_X (Pixel_X mod Tile_Size_X);
      Y_In_Tile : constant Tile_Pixel_Y :=
         Tile_Pixel_Y (Pixel_Y mod Tile_Size_Y);
   begin
      for X in Screen_X loop
         declare
            Tile_Map : constant Addr16 :=
               Get_Start_Address (X_In_Grid, Y_In_Grid, Tile_Map_Start);
            Pattern_Number : constant Uint8 := Mem.Get (Tile_Map);
            Tile_Data : constant Addr16 :=
               (if LCDC (Select_Tile_Data_1) then
                   Get_Tile_Address
                      (To_Unsigned_Tile_Pattern (Pattern_Number))
                else
                   Get_Tile_Address
                      (To_Signed_Tile_Pattern (Pattern_Number)));
         begin
            Screen (X, Line) :=
               Palette
                  (Get_Pixel_Color (Mem, X_In_Tile, Y_In_Tile, Tile_Data));
         end;

         X_In_Tile := X_In_Tile + 1;
         Pixel_X := Pixel_X + 1;
         X_In_Grid := Tile_Grid_X (Pixel_X / Tile_Size_X);
      end loop;
   end Renderscan;
end PPU;
