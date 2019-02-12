package MMU.Registers is
   --  Background tile map locations
   subtype Tile_Map_0 is Addr16 range 16#9800# .. 16#9BFF#;
   subtype Tile_Map_1 is Addr16 range 16#9C00# .. 16#9FFF#;

   --  Tile data (same for background and window) locations
   subtype Tile_Data_0 is Addr16 range 16#8800# .. 16#97FF#;
   subtype Tile_Data_1 is Addr16 range 16#8000# .. 16#8FFF#;

   --  Start of tile data is different from 'First
   Tile_Data_0_Start : constant Tile_Data_0 := 16#9000#;
   Tile_Data_1_Start : constant Tile_Data_1 := Tile_Data_1'First;

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

   --  TODO: The size of this type is not 1 byte, check this
   type Interrupt_Enum is
      (VBlank,
       LCDC_Status,
       Timer_Overflow,
       Serial_Transfer_Completion,
       KeyPad);
   type Interrupt_Array is array (Interrupt_Enum) of Boolean with Pack;

   function BG_Tile_Map (LCDC : LCDC_T) return Addr16;

   IF_Addr : constant Addr16 := 16#FF0F#;
   LCDC_Addr : constant Addr16 := 16#FF40#;
   SCY_Addr : constant Addr16 := 16#FF42#;
   SCX_Addr : constant Addr16 := 16#FF43#;
   LY_Addr : constant Addr16 := 16#FF44#;

   function LCDC (Mem : Memory_T) return LCDC_T;
   function SCY (Mem : Memory_T) return Uint8;
   function SCX (Mem : Memory_T) return Uint8;
   function LY (Mem : Memory_T) return Uint8;
   function IFF (Mem : Memory_T) return Interrupt_Array;

   procedure Increment_LY (Mem : Memory_T);
   procedure Reset_LY (Mem : Memory_T);
   procedure Set_IF (Mem : Memory_T; F : Interrupt_Enum; B : Boolean);
end MMU.Registers;
