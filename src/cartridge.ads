with HAL; use HAL;
with Interfaces; use Interfaces;

package Cartridge is
   type Cartridge_T
      (Last_Rom_Addr : Unsigned_32; Last_Ram_Addr : Unsigned_32) is private;

   type Cartridge_P is access Cartridge_T;

   procedure Free (C : in out Cartridge_P);

   function Load (Filename : String) return Cartridge_P;

   function Read (C : Cartridge_T; Addr : Addr16) return Uint8;
   procedure Write (C : in out Cartridge_T; Addr : Addr16; Val : Uint8);
private
   type Memory_Array is array (Unsigned_32 range <>) of Uint8;

   type Cartridge_T
      (Last_Rom_Addr : Unsigned_32;
       Last_Ram_Addr : Unsigned_32)
   is record
      Rom : Memory_Array (0 .. Last_Rom_Addr) := [others => 0];
      Ram : Memory_Array (0 .. Last_Ram_Addr) := [others => 0];
      Is_MBC5 : Boolean := False;
      Rom_Bank : Uint16 := 1;
      Ram_Bank : Uint16 := 0;
      Ram_Enabled : Boolean := False;
      Advanced_Bank : Boolean := False;
      Rom_Bank_Upper_Two : Uint16 := 0; --  For advance bank selection
   end record;
end Cartridge;
