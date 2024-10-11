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
   IE_Addr : constant Addr16 := 16#FFFF#;

   function LCDC (Mem : Memory_T) return LCDC_T;
   function SCY (Mem : Memory_T) return Uint8;
   function SCX (Mem : Memory_T) return Uint8;
   function LY (Mem : Memory_T) return Uint8;
   function IFF (Mem : Memory_T) return Interrupt_Array;
   function IE (Mem : Memory_T) return Interrupt_Array;
   function STAT (Mem : Memory_T) return STAT_T;

   procedure Set_Video_Mode (Mem : Memory_T; Mode : Video_Mode);

   procedure Increment_LY (Mem : Memory_T);
   procedure Reset_LY (Mem : Memory_T);
   procedure Set_IF (Mem : Memory_T; F : Interrupt_Enum; B : Boolean);
end MMU.Registers;
