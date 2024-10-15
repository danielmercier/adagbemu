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
   begin
      if N >= 0 then
         return Tile_Data_0_Start + Addr16 (N) * Tile_Size_X * One_Pixel_Size;
      else
         return Tile_Data_0_Start - Addr16 (-N) * Tile_Size_X * One_Pixel_Size;
      end if;
   end Get_Tile_Address;

   function Get_Tile_Address (N : Unsigned_Tile_Pattern) return Tile_Data_1 is
   begin
      return Tile_Data_1_Start + Addr16 (N) * Tile_Size_X * One_Pixel_Size;
   end Get_Tile_Address;

   function Get_Tile_Address
      (N : Unsigned_Tile_Pattern; Tile_Size : Uint8)
      return Tile_Data_1
   is
   begin
      return Tile_Data_1_Start
         + Addr16 (N) * Addr16 (Tile_Size) * One_Pixel_Size;
   end Get_Tile_Address;

   function Palette (Palette : Palette_T; Color : Pixel_Color) return Color_T
   is
   begin
      case Palette (Color) is
         when 0 => return (255, 255, 255, 255);
         when 1 => return (168, 168, 168, 255);
         when 2 => return (85, 85, 85, 255);
         when 3 => return (0, 0, 0, 255);
      end case;
   end Palette;

   function Select_OAM_Objects
      (Sprites : Sprite_Array; LCDC : LCDC_T; Line : Screen_X)
      return Sprite_Array
   is
      Max_In_Line : constant := 10;
      Result : Sprite_Array (1 .. Max_In_Line); --  Max number of sprites
      Horizontal_Count : Addr16 := 0;
   begin
      for Sprite of Sprites loop
         declare
            Tile_A_Y : constant Integer :=
               Integer (Line) - Integer (Sprite.Y_Position) + 16;
            Large : constant Boolean := LCDC (Obj_Size_8x16);
            Size : constant Uint8 :=
               (if Large then 2 * Tile_Size_Y else Tile_Size_Y);
         begin
            if Tile_A_Y in 0 .. Integer (Size) - 1 then
               Horizontal_Count := Horizontal_Count + 1;
               Result (Horizontal_Count) := Sprite;
            end if;
         end;

         exit when Horizontal_Count >= Max_In_Line;
      end loop;

      return Result (1 .. Horizontal_Count); -- Return actual size
   end Select_OAM_Objects;

   procedure Draw_Window
      (Screen : in out Screen_T;
       Mem : Memory_T;
       LCDC : LCDC_T;
       Tiles_Win_Start : Addr16;
       X : Screen_X;
       Y : Screen_Y;
       WX : Uint8;
       WY : Uint8)
   is
      --  Absolute position for the windows tile
      Tile_A_X : constant Integer := Integer (X) - Integer (WX) + 7;
      Tile_A_Y : constant Integer := Integer (Y) - Integer (WY);
   begin
      if Tile_A_X < 0 or else Tile_A_Y < 0 then
         return;
      end if;

      declare
         --  Which tile in the grid of tiles we need to take for the X and Y
         --  coordinates
         Tile_X : constant Tile_Grid_X :=
            Tile_Grid_X (Tile_A_X / Tile_Size_X);
         Tile_Y : constant Tile_Grid_Y :=
            Tile_Grid_Y (Tile_A_Y / Tile_Size_Y);

         --  Which pixel in the tile
         Tile_P_X : constant Tile_Pixel_X :=
            Tile_Pixel_X (Tile_A_X mod Tile_Size_X);
         Tile_P_Y : constant Tile_Pixel_Y :=
            Tile_Pixel_Y (Tile_A_Y mod Tile_Size_Y);

         --  Final index of the tile
         Tile_Address : constant Addr16 :=
            Get_Start_Address (Tile_X, Tile_Y, Tiles_Win_Start);

         Pattern_Number : constant Uint8 := Mem.Get (Tile_Address);

         Tile_Data : constant Addr16 :=
            (if LCDC (Select_Tile_Data_1) then
                Get_Tile_Address
                   (To_Unsigned_Tile_Pattern (Pattern_Number))
             else
                Get_Tile_Address
                   (To_Signed_Tile_Pattern (Pattern_Number)));

         W_Color : constant Pixel_Color :=
            Get_Pixel_Color (Mem, Tile_P_X, Tile_P_Y, Tile_Data);
      begin
         Screen (X, Y) := Palette (BGP (Mem), W_Color);
      end;
   end Draw_Window;

   procedure Renderscan
      (Screen : in out Screen_T;
       Mem : Memory_T;
       Line : Screen_Y;
       LCDC : LCDC_T;
       Scroll_X : Screen_Background_X;
       Scroll_Y : Screen_Background_Y;
       Sprites : Sprite_Array)
   is
      WX : constant Uint8 := MMU.Registers.WX (Mem);
      WY : constant Uint8 := MMU.Registers.WY (Mem);

      Display_Window : constant Boolean :=
         LCDC (Window_Display)
         and then WX <= 166
         and then WY <= 143;

      Tiles_BG_Start : constant Addr16 := BG_Tile_Map (LCDC);
      Tiles_Win_Start : constant Addr16 := Win_Tile_Map (LCDC);
   begin
      for X in Screen_X loop
         declare
            --  Index of the pixel in the full background
            Scrolled_X : constant Screen_Background_X := X + Scroll_X;
            Scrolled_Y : constant Screen_Background_Y := Line + Scroll_Y;

            --  Which tile in the grid of tiles we need to take for the X and Y
            --  coordinates
            Tile_X : constant Tile_Grid_X :=
               Tile_Grid_X (Scrolled_X / Tile_Size_X);
            Tile_Y : constant Tile_Grid_Y :=
               Tile_Grid_Y (Scrolled_Y / Tile_Size_Y);

            --  Which pixel in the tile
            Tile_P_X : constant Tile_Pixel_X :=
               Tile_Pixel_X (Scrolled_X mod Tile_Size_X);
            Tile_P_Y : constant Tile_Pixel_Y :=
               Tile_Pixel_Y (Scrolled_Y mod Tile_Size_Y);

            --  Final index of the tile
            Tile_Address : constant Addr16 :=
               Get_Start_Address (Tile_X, Tile_Y, Tiles_BG_Start);

            Pattern_Number : constant Uint8 := Mem.Get (Tile_Address);

            Tile_Data : constant Addr16 :=
               (if LCDC (Select_Tile_Data_1) then
                   Get_Tile_Address
                      (To_Unsigned_Tile_Pattern (Pattern_Number))
                else
                   Get_Tile_Address
                      (To_Signed_Tile_Pattern (Pattern_Number)));

            Selected_Sprite : Sprite :=
               (X_Position => Uint8'Last, others => <>);
            OBJ_Color : Pixel_Color := 0; --  Can initialize to transparent
            BG_Color : constant Pixel_Color :=
               Get_Pixel_Color (Mem, Tile_P_X, Tile_P_Y, Tile_Data);
         begin
            --  Iterate over all sprites
            for Sprite of Sprites loop
               if Sprite.X_Position < Selected_Sprite.X_Position then
                  --  This object has higher priority
                  declare
                     Tile_A_X : constant Integer :=
                        Integer (X) - Integer (Sprite.X_Position) + 8;
                     Tile_A_Y : constant Integer :=
                        Integer (Line) - Integer (Sprite.Y_Position) + 16;

                     Large : constant Boolean := LCDC (Obj_Size_8x16);
                     Tile_Size_Y : constant Uint8 :=
                        (if Large then Tile_Size_X * 2 else Tile_Size_X);
                  begin
                     --  check if X and Y are on the tile
                     if Tile_A_Y in 0 .. Integer (Tile_Size_Y) - 1
                        and then Tile_A_X in 0 .. Integer (Tile_Size_X) - 1
                     then
                        --  Check the color of the sprite
                        declare
                           Tile_P_X : constant Tile_Pixel_X :=
                              (if Sprite.X_Flip then
                                 Tile_Pixel_X ((Tile_Size_X - 1) - Tile_A_X)
                              else
                                 Tile_Pixel_X (Tile_A_X));

                           --  Y coordinate can exceed the size of the tile.
                           --  modulo it with that size so it doesn't exceed
                           --  it.
                           --  Y in 8 .. 15 has an incidence on the
                           --  tile_data_start
                           Tile_P_Y : constant Tile_Pixel_Y :=
                              (if Sprite.Y_Flip then
                                 Tile_Pixel_Y (
                                    (Integer (Tile_Size_Y - 1) - Tile_A_Y)
                                    mod Tile_Size_X
                                 )
                              else
                                 Tile_Pixel_Y (Tile_A_Y mod Tile_Size_X));

                           Pattern_Number : constant Uint8 :=
                              (if Large then
                                 Sprite.Tile_Index and 16#FE#
                               else
                                 Sprite.Tile_Index);

                           Tile_Data : constant Addr16 :=
                               Get_Tile_Address
                                  (To_Unsigned_Tile_Pattern (Pattern_Number),
                                   Tile_Size_Y);

                           Tile_Data_Start : constant Addr16 :=
                              (if Tile_A_Y >= Tile_Size_X then
                                 Tile_Data + 1
                              else
                                 Tile_Data);

                           Color : constant Pixel_Color :=
                              Get_Pixel_Color
                                 (Mem, Tile_P_X, Tile_P_Y, Tile_Data_Start);
                        begin
                           if Color > 0 then
                              --  Found a suitable sprite with higher priority
                              Selected_Sprite := Sprite;
                              OBJ_Color := Color;
                           end if;
                        end;
                     end if;
                  end;
               end if;
            end loop;

            if OBJ_Color > 0
               and then (not Selected_Sprite.BG_Over_OBJ or else BG_Color = 0)
            then
               --  Object with color 0 are transparent
               --    don't draw the object if BG_Over_OBJ is set and BG_Color
               --    is not 0
               Screen (X, Line) :=
                  Palette (OBP (Mem, Selected_Sprite.DMG_Palette), OBJ_Color);
            else
               --  Draw the background otherwise
               Screen (X, Line) := Palette (BGP (Mem), BG_Color);
            end if;

            if Display_Window then
               --  Draw windows on top
               Draw_Window
                  (Screen, Mem, LCDC, Tiles_Win_Start, X, Line, WX, WY);
            end if;
         end;
      end loop;
   end Renderscan;
end PPU;
