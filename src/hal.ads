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
   type Addr8 is range 0 .. 2 ** 8 - 1 with Size => 8;
   --  16 bit type used for address
   type Addr16 is range 0 .. 2 ** 16 - 1 with Size => 16;

   type OPCode_T is new Addr16;

   type Clock_T is mod 2 ** 32;

   type Byte_Pos is (Lo, Hi);
   type Word is array (Byte_Pos) of Uint8 with Pack;

   function To_Word is new Ada.Unchecked_Conversion (Uint16, Word);
   function From_Word is new Ada.Unchecked_Conversion (Word, Uint16);
end HAL;
