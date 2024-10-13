with HAL; use HAL;
with GB; use GB;
with MMU.Registers; use MMU.Registers;

with Interfaces; use Interfaces;

with Ada.Text_IO; use Ada.Text_IO;

procedure Test_Sprite is
   GB : GB_T;

   function To_String (S : Sprite) return String is
   begin
      return "(Y_Position =>" & S.Y_Position'Image & ", "
           &  "X_Position =>" & S.X_Position'Image & ", "
           &  "Tile_Index =>" & S.Tile_Index'Image & ", "
           &  "CGB_Palette => " & S.CGB_Palette'Image & ", "
           &  "Bank => " & S.Bank'Image & ", "
           &  "DMG_Palette => " & S.DMG_Palette'Image & ", "
           &  "X_Flip => " & S.X_Flip'Image & ", "
           &  "Y_Flip => " & S.Y_Flip'Image & ", "
           &  "BG_Over_OBJ => " & S.BG_Over_OBJ'Image & ")";
   end To_String;

   Expected : constant Sprite :=
      (Y_Position => 1,
       X_Position => 2,
       Tile_Index => 3,
       CGB_Palette => OBP3,
       Bank => True,
       DMG_Palette => OBP1,
       X_Flip => False,
       Y_Flip => True,
       BG_Over_OBJ => False);
   Actual_Sprites : Sprite_Array (1 .. Sprite_Count);

   Attributes : Uint8;
begin
   Init (GB);

   for I in 0 .. Sprite_Count - 1 loop
      --  Manually set one sprite with:
      GB.Memory.Set (OAM_Addr'First + I * Sprite_Size, Expected.Y_Position);
      GB.Memory.Set (OAM_Addr'First + I * Sprite_Size + 1, Expected.X_Position);
      GB.Memory.Set (OAM_Addr'First + I * Sprite_Size + 2, Expected.Tile_Index);

      Attributes := CGB_OBP_Palette'Pos (Expected.CGB_Palette);

      if Expected.Bank then
         Attributes := Attributes or 2#00001000#;
      end if;

      Attributes :=
         Attributes
         or Uint8 (Shift_Left
            (Unsigned_8 (DMG_OBP_Palette'Pos (Expected.DMG_Palette)), 4));

      if Expected.X_Flip then
         Attributes := Attributes or 2#00100000#;
      end if;

      if Expected.Y_Flip then
         Attributes := Attributes or 2#01000000#;
      end if;

      if Expected.BG_Over_OBJ then
         Attributes := Attributes or 2#10000000#;
      end if;

      GB.Memory.Set (OAM_Addr'First + I * Sprite_Size + 3, Attributes);
   end loop;

   Actual_Sprites := Get_Sprites (GB.Memory);

   for I in 1 .. Sprite_Count loop
      if Actual_Sprites (I) /= Expected then
         Put_Line ("Expected: " & To_String (Expected));
         Put_Line ("Got     : " & To_String (Actual_Sprites (I)));

         raise Program_Error;
      end if;
   end loop;

   Finalize (GB);
end Test_Sprite;
