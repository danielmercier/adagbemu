with Ada.Unchecked_Deallocation;

with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Directories; use Ada.Directories;

package body Cartridge is
   procedure Free (C : in out Cartridge_P) is
      procedure Dealloc is new
         Ada.Unchecked_Deallocation (Cartridge_T, Cartridge_P);
   begin
      Dealloc (C);
   end Free;

   function Load (Filename : String) return Cartridge_P is
      Last_Rom_Addr : constant File_Size := Size (Filename) - 1;

      Result : constant Cartridge_P :=
         new Cartridge_T'(
            Last_Rom_Addr => Unsigned_32 (Last_Rom_Addr),
            Last_Ram_Addr => 16#1FFF#,
            others => <>
         );

      File : File_Type;
      Input_Stream : Stream_Access;
      Read_Byte : Uint8;
   begin
      Open (File, In_File, Filename);
      Input_Stream := Stream (File);

      for Addr in 0 .. Result.Last_Rom_Addr loop
         Uint8'Read (Input_Stream, Read_Byte);
         Result.Rom (Addr) := Read_Byte;
      end loop;

      if not End_Of_File (File) then
         raise Program_Error;
      end if;

      Close (File);

      Result.Is_MBC5 := Result.Rom (16#147#) in 16#11# .. 16#1E#;

      return Result;
   end Load;

   --  Having a rom extension or not depends on the cartridge's rom size
   function ROM_Extension (C : Cartridge_T) return Boolean is
   begin
      return C.Last_Rom_Addr > 16#7FFFF#;
   end ROM_Extension;

   function Compute_RAM_Addr
      (C : Cartridge_T; Addr : Addr16)
      return Unsigned_32
   is
      Actual_Ram_Bank : constant Unsigned_32 :=
         (if C.Is_MBC5 or else
             (C.Advanced_Bank and then not ROM_Extension (C))
          then
             Unsigned_32 (C.Ram_Bank)
          else
             0);
      Bank_Start : constant Unsigned_32 :=
         16#2000# * Actual_Ram_Bank;
      Offset_In_Bank : constant Unsigned_32 :=
         Unsigned_32 (Addr) - 16#A000#;
   begin
      return Bank_Start + Offset_In_Bank;
   end Compute_RAM_Addr;

   function Read (C : Cartridge_T; Addr : Addr16) return Uint8 is
   begin
      case Addr is
         when 16#0000# .. 16#3FFF# =>
            --  Read-only bank X0
            if ROM_Extension (C) and then C.Advanced_Bank then
                  --  Advanced banking mode selection
               declare
                  Bank_Start : constant Unsigned_32 :=
                     16#4000# * Unsigned_32 (C.Rom_Bank - 1);
               begin
                  return C.Rom (Bank_Start + Unsigned_32 (Addr));
               end;
            else
               return C.Rom (Unsigned_32 (Addr));
            end if;
         when 16#4000# .. 16#7FFF# =>
            --  ROM Bank 01-7F read-only
            declare
               Bank_Start : constant Unsigned_32 :=
                  16#4000# * Unsigned_32 (C.Rom_Bank);
               Offset_In_Bank : constant Unsigned_32 :=
                  Unsigned_32 (Addr) - 16#4000#;
            begin
               return C.Rom (Bank_Start + Offset_In_Bank);
            end;
         when 16#A000# .. 16#BFFF# =>
            --  Cartridges ram
            return C.Ram (Compute_RAM_Addr (C, Addr));
         when others =>
            raise Program_Error with "Unexpected read of cartridge";
      end case;
   end Read;

   procedure Compute_Upper_Two_Bits (C : in out Cartridge_T) is
   begin
      if not C.Is_MBC5 and then ROM_Extension (C) then
         C.Rom_Bank := (C.Rom_Bank and 16#1F#) + Shift_Left (C.Ram_Bank, 5);
      end if;
   end Compute_Upper_Two_Bits;

   procedure Compute_ROM_Bank (C : in out Cartridge_T; Val : Uint8) is
      Bank_Selection : constant Uint16 :=
         Uint16 (Val) and 16#1F#;
      Bank_In_Cart : constant Uint16 :=
         Uint16 ((C.Last_Rom_Addr + 1) / 16#4000#);
   begin
      if Bank_Selection = 0 then
         C.Rom_Bank := 16#01#;
      else
            --  Check number of banks in the cart
         C.Rom_Bank := Bank_Selection mod Bank_In_Cart;
      end if;

      --  Also check upper two bits
      Compute_Upper_Two_Bits (C);
   end Compute_ROM_Bank;

   procedure Compute_MBC5_ROM_Bank
      (C : in out Cartridge_T;
       Addr : Addr16;
       Val : Uint8)
   is
   begin
      case Addr is
         when 16#2000# .. 16#2FFF# =>
            --  8 least significant bits of ROM bank
            C.Rom_Bank := Uint16 (Val);
         when 16#3000# .. 16#3FFF# =>
            --  9th bit
            C.Rom_Bank :=
               (C.Rom_Bank and 16#FF#)
               + Shift_Left (Uint16 (Val and 16#01#), 8);
         when others =>
            raise Program_Error; --  Not possible in calling context
      end case;
   end Compute_MBC5_ROM_Bank;

   procedure Write (C : in out Cartridge_T; Addr : Addr16; Val : Uint8) is
   begin
      case Addr is
         when 16#0000# .. 16#1FFF# =>
            if not C.Is_MBC5 and then (Val and 16#80#) /= 0 then
               --  MBC2 behaviour, switch bank
               Compute_ROM_Bank (C, Val);
            else
               C.Ram_Enabled := (Val and 16#0A#) /= 0;
            end if;
         when 16#2000# .. 16#3FFF# =>
            if C.Is_MBC5 then
               --  Behaviour of MBC5 is slightly different here
               Compute_MBC5_ROM_Bank (C, Addr, Val);
            else
               Compute_ROM_Bank (C, Val);
            end if;
         when 16#4000# .. 16#5FFF# =>
            if C.Is_MBC5 then
               C.Ram_Bank := Uint16 (Val and 16#0F#);
            else
               C.Ram_Bank := Uint16 (Val and 16#03#);
               Compute_Upper_Two_Bits (C);
            end if;
         when 16#6000# .. 16#7FFF# =>
            C.Advanced_Bank := (if (Val and 16#01#) /= 0 then True else False);
            Compute_Upper_Two_Bits (C);
         when 16#A000# .. 16#BFFF# =>
            --  Cartridges ram
            C.Ram (Compute_RAM_Addr (C, Addr)) := Val;
         when others =>
            raise Program_Error with "Unexpected write on cartridge";
      end case;
   end Write;
end Cartridge;
