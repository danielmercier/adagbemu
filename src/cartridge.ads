with HAL; use HAL;

package Cartridge is
   type Cartridge_T
      (Last_Rom_Addr : Integer; Last_Ram_Addr : Integer) is private;

   type Cartridge_P is access Cartridge_T;

   procedure Free (C : in out Cartridge_P);

   function Load (Filename : String) return Cartridge_P;

   function Read (C : Cartridge_T; Addr : Addr16) return Uint8;
   procedure Write (C : in out Cartridge_T; Addr : Addr16; Val : Uint8);
private
   type Memory_Array is array (Natural range <>) of Uint8;

   subtype RTC_Mode_T is Uint8 range 16#08# .. 16#0C#;

   subtype RTC_Mode_Opt is Uint8 range RTC_Mode_T'First - 1 .. RTC_Mode_T'Last;
   --  7 means unset, the rest means set

   None : constant RTC_Mode_Opt := RTC_Mode_Opt'First;

   type Cartridge_T
      (Last_Rom_Addr : Integer;
       Last_Ram_Addr : Integer)
   is record
      Rom : Memory_Array (0 .. Last_Rom_Addr) := [others => 0];
      Ram : Memory_Array (0 .. Last_Ram_Addr) := [others => 0];
      Is_MBC3 : Boolean := False;
      RTC_Mode : RTC_Mode_Opt := 16#07#;
      Is_MBC5 : Boolean := False;
      Rom_Bank : Uint16 := 1;
      Ram_Bank : Uint16 := 0;
      Ram_Enabled : Boolean := False;
      Advanced_Bank : Boolean := False;
      Rom_Bank_Upper_Two : Uint16 := 0; --  For advance bank selection
   end record;
end Cartridge;
