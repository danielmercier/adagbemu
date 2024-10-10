with Ada.Unchecked_Conversion;

package HAL is
   --  8 bit unsigned
   type Uint8 is mod 2 ** 8 with Size => 8;
   --  16 bit unsigned
   type Uint16 is mod 2 ** 16 with Size => 16;

   --  8 bit signed
   type Int8 is range -2 ** 7 .. 2 ** 7 - 1 with Size => 8;
   --  16 bit signed
   type Int16 is range -2 ** 15 .. 2 ** 15 - 1 with Size => 16;

   --  8 bit type used for address
   type Addr8 is new Uint8;
   --  16 bit type used for address
   type Addr16 is new Uint16;

   type OPCode_T is new Addr16;

   type Clock_T is mod 2 ** 32;

   type Byte_Pos is (Lo, Hi);
   type Word is array (Byte_Pos) of Uint8 with Pack;

   function To_Word is new Ada.Unchecked_Conversion (Uint16, Word);
   function From_Word is new Ada.Unchecked_Conversion (Word, Uint16);

   subtype Bit_Index is Uint8 range 0 .. 7;
   type Bitset is array (Bit_Index) of Boolean with Pack;

   function To_Bitset is new Ada.Unchecked_Conversion (Uint8, Bitset);
   function From_Bitset is new Ada.Unchecked_Conversion (Bitset, Uint8);
end HAL;
