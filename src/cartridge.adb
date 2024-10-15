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

      Rom : Memory_Array (0 .. Natural (Last_Rom_Addr));

      File : File_Type;
      Input_Stream : Stream_Access;
      Read_Byte : Uint8;
   begin
      Open (File, In_File, Filename);
      Input_Stream := Stream (File);

      for Addr in Rom'Range loop
         Uint8'Read (Input_Stream, Read_Byte);
         Rom (Addr) := Read_Byte;
      end loop;

      if not End_Of_File (File) then
         raise Program_Error;
      end if;

      Close (File);

      declare
         Ram_Size : constant Natural :=
            (case Rom (16#149#) is
               when 16#00# | 16#01# =>
                  0,
               when 16#02# =>
                  16#2000#, --  1 bank
               when 16#03# =>
                  4 * 16#2000#, --  4 banks
               when 16#04# =>
                  16 * 16#2000#, --  16 banks
               when 16#05# =>
                  8 * 16#2000#,
               when others =>
                  16#0000#); --  8 banks

         Result : constant Cartridge_P :=
            new Cartridge_T'(
               Last_Rom_Addr => Rom'Last,
               Last_Ram_Addr => Ram_Size - 1,
               Rom => Rom,
               others => <>
            );
      begin
         Result.Is_MBC3 := Rom (16#147#) in 16#0F# .. 16#13#;
         Result.Is_MBC5 := Rom (16#147#) in 16#19# .. 16#1E#;

         return Result;
      end;
   end Load;

   --  Having a rom extension or not depends on the cartridge's rom size
   function ROM_Extension (C : Cartridge_T) return Boolean is
   begin
      return not C.Is_MBC3
         and then not C.Is_MBC5
         and then C.Last_Rom_Addr > 16#7FFFF#;
   end ROM_Extension;

   function Compute_RAM_Addr
      (C : Cartridge_T; Addr : Addr16)
      return Natural
   is
      Actual_Ram_Bank : constant Natural :=
         (if C.Is_MBC5 or else
             C.Is_MBC3 or else
             (C.Advanced_Bank and then not ROM_Extension (C))
          then
             Natural (C.Ram_Bank)
          else
             0);
      Bank_Start : constant Natural :=
         16#2000# * Actual_Ram_Bank;
      Offset_In_Bank : constant Natural :=
         Natural (Addr) - 16#A000#;
   begin
      return Bank_Start + Offset_In_Bank;
   end Compute_RAM_Addr;

   function Read_RTC (RTC_Mode : RTC_Mode_T) return Uint8 is
      pragma Unreferenced (RTC_Mode);
   begin
      --  TODO: really implement the clock
      return 0;
   end Read_RTC;

   function Read (C : Cartridge_T; Addr : Addr16) return Uint8 is
   begin
      case Addr is
         when 16#0000# .. 16#3FFF# =>
            --  Read-only bank X0
            if ROM_Extension (C) and then C.Advanced_Bank then
                  --  Advanced banking mode selection
               declare
                  Bank_Start : constant Natural :=
                     16#4000# * Natural (C.Rom_Bank - 1);
               begin
                  return C.Rom (Bank_Start + Natural (Addr));
               end;
            else
               return C.Rom (Natural (Addr));
            end if;
         when 16#4000# .. 16#7FFF# =>
            --  ROM Bank 01-7F read-only
            declare
               Bank_Start : constant Natural :=
                  16#4000# * Natural (C.Rom_Bank);
               Offset_In_Bank : constant Natural :=
                  Natural (Addr) - 16#4000#;
            begin
               return C.Rom (Bank_Start + Offset_In_Bank);
            end;
         when 16#A000# .. 16#BFFF# =>
            --  Cartridges ram
            if C.RTC_Mode = None then
               return C.Ram (Compute_RAM_Addr (C, Addr));
            else
               return Read_RTC (RTC_Mode_T (C.RTC_Mode));
            end if;
         when others =>
            raise Program_Error with "Unexpected read of cartridge";
      end case;
   end Read;

   procedure Compute_Upper_Two_Bits (C : in out Cartridge_T) is
   begin
      if ROM_Extension (C) then
         C.Rom_Bank := (C.Rom_Bank and 16#1F#) + Shift_Left (C.Ram_Bank, 5);
      end if;
   end Compute_Upper_Two_Bits;

   procedure Compute_ROM_Bank (C : in out Cartridge_T; Val : Uint8) is
      Bank_Mask : constant Uint16 :=
         (if C.Is_MBC3 then 16#7F# else 16#1F#);
      Bank_Selection : constant Uint16 :=
         Uint16 (Val) and Bank_Mask;
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

   procedure Write_RTC
      (C : in out Cartridge_T;
       RTC_Mode : RTC_Mode_T;
       Val : Uint8)
   is
      pragma Unreferenced (C);
      pragma Unreferenced (RTC_Mode);
      pragma Unreferenced (Val);
   begin
      --  TODO: really implement the clock
      null;
   end Write_RTC;

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
            if C.Is_MBC3 and then Val in RTC_Mode_T then
               C.RTC_Mode := Val;
            elsif C.Is_MBC5 then
               C.Ram_Bank := Uint16 (Val and 16#0F#);
            else
               C.Ram_Bank := Uint16 (Val and 16#03#);
               Compute_Upper_Two_Bits (C);
            end if;
         when 16#6000# .. 16#7FFF# =>
            if C.Is_MBC3 then
               --  TODO: Latch Clock Data
               null;
            elsif C.Is_MBC5 then
               --  Nothing
               null;
            else
               C.Advanced_Bank := (if (Val and 16#01#) /= 0 then True else False);
               Compute_Upper_Two_Bits (C);
            end if;
         when 16#A000# .. 16#BFFF# =>
            --  Cartridges ram
            if C.RTC_Mode = None then
               C.Ram (Compute_RAM_Addr (C, Addr)) := Val;
            else
               Write_RTC (C, RTC_Mode_T (C.RTC_Mode), Val);
            end if;
         when others =>
            raise Program_Error with "Unexpected write on cartridge";
      end case;
   end Write;
end Cartridge;
