package MMU.Registers is
   --  The color of a pixel (the palette will decide the real color)
   type Pixel_Color is range 0 .. 3;

   --  Id inside the palette
   type ID_T is mod 4 with Size => 2;

   --  The actual palette
   type Palette_T is array (Pixel_Color) of ID_T with Pack;

   type CGB_OBP_Palette is (OBP0, OBP1, OBP2, OBP3, OBP4, OBP5, OBP6, OBP7)
      with Size => 3;
   type DMG_OBP_Palette is (OBP0, OBP1) with Size => 1;

   --  Background tile map locations
   subtype Tile_Map_0 is Addr16 range 16#9800# .. 16#9BFF#;
   subtype Tile_Map_1 is Addr16 range 16#9C00# .. 16#9FFF#;

   --  Tile data (same for background and window) locations
   subtype Tile_Data_0 is Addr16 range 16#8800# .. 16#97FF#;
   subtype Tile_Data_1 is Addr16 range 16#8000# .. 16#8FFF#;

   --  Start of tile data is different from 'First
   Tile_Data_0_Start : constant Tile_Data_0 := 16#9000#;
   Tile_Data_1_Start : constant Tile_Data_1 := Tile_Data_1'First;

   --  Object Attribute Memory
   type Sprite is record
      Y_Position : Uint8;
      X_Position : Uint8;
      Tile_Index : Uint8;
      CGB_Palette : CGB_OBP_Palette;
      Bank : Boolean;
      DMG_Palette : DMG_OBP_Palette;
      X_Flip : Boolean;
      Y_Flip : Boolean;
      BG_Over_OBJ : Boolean;
   end record with Size => 32;

   for Sprite use record
      Y_Position at 0 range 0 .. 7;
      X_Position at 1 range 0 .. 7;
      Tile_Index at 2 range 0 .. 7;
      CGB_Palette at 3 range 0 .. 2;
      Bank at 3 range 3 .. 3;
      DMG_Palette at 3 range 4 .. 4;
      X_Flip at 3 range 5 .. 5;
      Y_Flip at 3 range 6 .. 6;
      BG_Over_OBJ at 3 range 7 .. 7;
   end record;

   Sprite_Size : constant Addr16 := Sprite'Size / 8;

   subtype OAM_Addr is Addr16 range 16#FE00# .. 16#FE9F#;
   Sprite_Count : constant Addr16 :=
      (OAM_Addr'Last - OAM_Addr'First + 1) / Sprite_Size;

   type Sprite_Array is array (Addr16 range <>) of Sprite;

   function Get_Sprites (Mem : Memory_T) return Sprite_Array;

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

   type Interrupt_Enum is
      (VBlank,
       LCDC_Status,
       Timer_Overflow,
       Serial_Transfer_Completion,
       KeyPad);
   type Interrupt_Array is array (Interrupt_Enum) of Boolean
      with Pack, Size => 8;

   type Video_Mode is (HBlank, VBlank, OAM, Data_Transfer) with Size => 2;

   type STAT_T is record
      --  Current mode
      Mode : Video_Mode;

      --  True if LYC = LY
      --  False otherwise
      Coincidence_Flag : Boolean;

      HBlank_Interrupt : Boolean;
      VBlank_Interrupt : Boolean;
      OAM_Interrupt : Boolean;
      Coincidence_Interrupt : Boolean;
   end record with Size => 8;

   for STAT_T use record
      Mode at 0 range 0 .. 1;
      Coincidence_Flag at 0 range 2 .. 2;

      HBlank_Interrupt at 0 range 3 .. 3;
      VBlank_Interrupt at 0 range 4 .. 4;
      OAM_Interrupt at 0 range 5 .. 5;
      Coincidence_Interrupt at 0 range 6 .. 6;
   end record;

   function BG_Tile_Map (LCDC : LCDC_T) return Addr16;
   function Win_Tile_Map (LCDC : LCDC_T) return Addr16;

   subtype IO_Addr_Range is Addr16 range 16#FF00# .. 16#FF50#;

   type Flags is (A_Right, B_Left, Select_Up, Start_Down, Select_Dpad,
                  Select_Buttons, Void1, Void2);

   --  Everything in JOYP_Array is inversed
   --    0 means set
   --    1 means unset
   type JOYP_Array is array (Flags) of Boolean with Pack;

   JOYP_Addr : constant Addr16 := 16#FF00#;

   function JOYP (Mem : Memory_T) return JOYP_Array;
   procedure Set_JOYP (Mem : Memory_T; J : JOYP_Array);

   SB_Addr : constant Addr16 := 16#FF01#;
   SC_Addr : constant Addr16 := 16#FF02#;

   DIV_Addr : constant Addr16 := 16#FF04#;
   TIMA_Addr : constant Addr16 := 16#FF05#;
   TMA_Addr : constant Addr16 := 16#FF06#;
   TAC_Addr : constant Addr16 := 16#FF07#;

   IF_Addr : constant Addr16 := 16#FF0F#;
   LCDC_Addr : constant Addr16 := 16#FF40#;
   STAT_Addr : constant Addr16 := 16#FF41#;
   SCY_Addr : constant Addr16 := 16#FF42#;
   SCX_Addr : constant Addr16 := 16#FF43#;
   LY_Addr : constant Addr16 := 16#FF44#;
   LYC_Addr : constant Addr16 := 16#FF45#;
   DMA_Addr : constant Addr16 := 16#FF46#;
   BGP_Addr : constant Addr16 := 16#FF47#;
   OBP0_Addr : constant Addr16 := 16#FF48#;
   OBP1_Addr : constant Addr16 := 16#FF49#;
   WY_Addr : constant Addr16 := 16#FF4A#;
   WX_Addr : constant Addr16 := 16#FF4B#;
   IE_Addr : constant Addr16 := 16#FFFF#;

   function LCDC (Mem : Memory_T) return LCDC_T;
   function SCY (Mem : Memory_T) return Uint8;
   function SCX (Mem : Memory_T) return Uint8;
   function LY (Mem : Memory_T) return Uint8;
   function LYC (Mem : Memory_T) return Uint8;
   function BGP (Mem : Memory_T) return Palette_T;
   function OBP (Mem : Memory_T; P : DMG_OBP_Palette) return Palette_T;
   function WY (Mem : Memory_T) return Uint8;
   function WX (Mem : Memory_T) return Uint8;
   function IFF (Mem : Memory_T) return Interrupt_Array;
   function IE (Mem : Memory_T) return Interrupt_Array;
   function STAT (Mem : Memory_T) return STAT_T;

   procedure Set_Video_Mode (Mem : Memory_T; Mode : Video_Mode);

   procedure Increment_LY (Mem : Memory_T);
   procedure Reset_LY (Mem : Memory_T);
   procedure Set_IF (Mem : Memory_T; F : Interrupt_Enum; B : Boolean);
   procedure Set_STAT (Mem : Memory_T; S : STAT_T);

end MMU.Registers;
