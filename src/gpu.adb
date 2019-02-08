with Ada.Unchecked_Conversion;

package body GPU is
   function Get_Start_Address
      (X : Tile_Grid_X;
       Y : Tile_Grid_Y;
       Tiles_Start_Addr : Addr16)
      return Addr16 is
   begin
      return Tiles_Start_Addr + (Addr16 (Y) * Tile_Number_X * One_Pixel_Size);
   end Get_Start_Address;

   function Get_Pixel_Color
      (Memory : Memory_T;
       X : Tile_Pixel_X;
       Y : Tile_Pixel_Y;
       Tile_Addr : Addr16)
      return Pixel_Color
   is
      type Bit_Array is array (Tile_Pixel_X) of Boolean with Pack;
      function Convert is new Ada.Unchecked_Conversion (Uint8, Bit_Array);

      Start_Addr : constant Addr16 :=
         Tile_Addr + (Addr16 (Y) * Tile_Size_X * One_Pixel_Size);

      Low_Bit : Bit_Array := Convert (Memory.Get (Start_Addr));
      High_Bit : Bit_Array := Convert (Memory.Get (Start_Addr + 1));

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
      Address : Integer :=
         Integer (Tile_Data_0_Start)
         + (Integer (N) * Tile_Size_X * One_Pixel_Size);
   begin
      return Addr16 (Address);
   end Get_Tile_Address;

   function Get_Tile_Address (N : Unsigned_Tile_Pattern) return Tile_Data_1 is
   begin
      return Tile_Data_1_Start + (Addr16 (N) * Tile_Size_X * One_Pixel_Size);
   end Get_Tile_Address;
end GPU;
