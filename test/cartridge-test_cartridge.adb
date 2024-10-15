with Interfaces; use Interfaces;

package body Cartridge.Test_Cartridge is
   --  Fill the ROM with /= data
   procedure Init_ROM (C : in out Cartridge_T) is
   begin
      for I in 0 .. C.Last_Rom_Addr loop
         --  7 first bits contain the bank number and last one depends on I
         declare
            Bank_Number : constant Unsigned_32 := Unsigned_32 (I) / 16#4000#;
         begin
            C.Rom (I) := Uint8 (
               (Shift_Left (Unsigned_32 (I) mod 16#02#, 7) or Bank_Number)
               and 16#FF#);
         end;
      end loop;
   end Init_ROM;

   procedure Test_Cartridge_ROM is
      C : Cartridge_T (16#3FFF#, 0);
   begin
      Init_ROM (C);

      for I in 16#0000# .. 16#3FFF# loop
         declare
            Actual : constant Uint8 := Read (C, Addr16 (I));
            Expected : constant Uint8 := C.Rom (I);
         begin
            if Actual /= Expected then
               declare
                  Exn : constant String :=
                     "Address:" & I'Image & ", " & "Actual:" & Actual'Image &
                     ", Expected:" & Expected'Image;
               begin
                  raise Program_Error with Exn;
               end;
            end if;
         end;
      end loop;
   end Test_Cartridge_ROM;

   procedure Test_ROM (Bank_Size : Natural) is
      C : Cartridge_T ((Bank_Size + 1) * 16#4000# - 1, 0);
   begin
      Init_ROM (C);

      --  For each bank
      for I in 0 .. Bank_Size - 1 loop
         --  Write the bank we want to read from
         Write (C, 16#2000#, Uint8 (I));

         for J in 16#4000# .. 16#7FFF# loop
            --  For each address in the cartridge
            declare
               Actual : constant Uint8 := Read (C, Addr16 (J));
               Expected : constant Uint8 :=
                  (if I = 0 then
                     C.Rom (J)
                   else
                     C.Rom (Natural (I * 16#4000# + (J - 16#4000#))));
            begin
               if Actual /= Expected then
                  declare
                     Exn : constant String :=
                        "Bank:" & I'Image & ", Address:" & J'Image & ", " &
                        "Actual:" & Actual'Image & ", Expected:" &
                        Expected'Image;
                  begin
                     raise Program_Error with Exn;
                  end;
               end if;
            end;
         end loop;
      end loop;
   end Test_ROM;

   procedure Test_RAM is
      Bank_Size : constant := 3;
      --  Use max rom size
      C : Cartridge_T (16#7FFFF#, (Bank_Size + 1) * 16#2000# - 1);
   begin
      Write (C, 16#0000#, 16#A#); --  Enable RAM
      Write (C, 16#6000#, 16#1#); --  Enable Advanced banking

      --  Fill the RAM with /= data with Write
      for Bank in 16#00# .. 16#03# loop
         Write (C, 16#4000#, Uint8 (Bank));

         for I in 16#A000# .. 16#BFFF# loop
            Write (C, Addr16 (I),
               Uint8 ((Shift_Left (Unsigned_32 (I) mod 16#40#, 16#02#)
                        or Unsigned_32 (Bank))
                      and 16#FF#));
         end loop;
      end loop;

      for Bank in 16#00# .. 16#03# loop
         Write (C, 16#4000#, Uint8 (Bank));

         for I in 16#A000# .. 16#BFFF# loop
            declare
               Actual : constant Uint8 := Read (C, Addr16 (I));
               Expected : constant Uint8 :=
                  Uint8 ((Shift_Left (Unsigned_32 (I) mod 16#40#, 16#02#)
                           or Unsigned_32 (Bank))
                         and 16#FF#);
            begin
               if Actual /= Expected then
                  declare
                     Exn : constant String :=
                        "Bank:" & Bank'Image & ", Address:" & I'Image & ", " &
                        "Actual:" & Actual'Image & ", Expected:" &
                        Expected'Image;
                  begin
                     raise Program_Error with Exn;
                  end;
               end if;
            end;
         end loop;
      end loop;

      Write (C, 16#6000#, 16#0#); --  Disable Advanced banking

      for Bank in 16#00# .. 16#03# loop
         --  Any bank always resolves to 16#A000# .. 16#BFFF# in non advanced
         --  banking mode

         Write (C, 16#4000#, Uint8 (Bank));

         for I in 16#A000# .. 16#BFFF# loop
            declare
               Actual : constant Uint8 := Read (C, Addr16 (I));

               --  Manually use the same expression as the one we wrote to
               --  really test that writing to the RAM works
               Expected : constant Uint8 :=
                  Uint8 ((Shift_Left (Unsigned_32 (I) mod 16#40#, 16#02#))
                         and 16#FF#);
            begin
               if Actual /= Expected then
                  declare
                     Exn : constant String :=
                        "Bank:" & Bank'Image & ", Address:" & I'Image & ", " &
                        "Actual:" & Actual'Image & ", Expected:" &
                        Expected'Image;
                  begin
                     raise Program_Error with Exn;
                  end;
               end if;
            end;
         end loop;
      end loop;
   end Test_RAM;

   procedure Test_Extended_ROM is
      --   Test a huge ROM here. RAM can only be 8KiB
      C : Cartridge_T (16#80# * 16#4000# - 1, 16#1FFF#);
   begin
      Init_ROM (C); --  Can still use init rom as it uses 7 bits for bank number

      Write (C, 16#6000#, 16#1#); --  Enable Advanced banking

      for Bank in 0 .. 16#7F# loop
         --  Use 5 bits and write the bank
         Write (C, 16#2000#, Uint8 (Bank) and 16#1F#);

         --  Move 2 bits in 4000
         Write (C, 16#4000#, Shift_Right (Uint8 (Bank) and 16#60#, 5));

         for I in 16#0000# .. 16#3FFF# loop
            declare
               Actual_Addr : constant Unsigned_32 :=
                  (case Bank is
                     when 16#00# | 16#20# | 16#40# | 16#60# =>
                        Unsigned_32 (I),
                     when others =>
                        Unsigned_32 (I + 16#4000#));
               Actual : constant Uint8 := Read (C, Addr16 (Actual_Addr));
               Expected : constant Uint8 :=
                     C.Rom (Natural (Bank * 16#4000# + I));
            begin
               if Actual /= Expected then
                  declare
                     Exn : constant String :=
                        "Bank:" & Bank'Image & ", Address:" & I'Image & ", " &
                        "Actual:" & Actual'Image & ", Expected:" &
                        Expected'Image;
                  begin
                     raise Program_Error with Exn;
                  end;
               end if;
            end;
         end loop;
      end loop;

      Write (C, 16#6000#, 16#0#); --  Disable Advanced banking
   end Test_Extended_ROM;

   procedure Test_MBC5 is
      C : constant Cartridge_P := new Cartridge_T'(16#200# * 16#4000# - 1, 16#10# * 16#2000# - 1, others => <>);
   begin
      C.Is_MBC5 := True;

      Init_ROM (C.all); --  doesn't really work for very high bank numbers but still good enough for testing

      --  test rom fist
      for Bank in 0 .. Unsigned_32 (16#1FF#) loop
         --  Set 8 least significant bits
         Write (C.all, 16#2000#, Uint8 (Bank and 16#FF#));

         --  Set 9nth bit
         Write (C.all, 16#3000#, Uint8 (Shift_Right (Bank and 16#100#, 8)));

         for I in 16#0000# .. 16#3FFF# loop
            declare
               Actual_Addr : constant Natural := I + 16#4000#;
               Actual : constant Uint8 := Read (C.all, Addr16 (Actual_Addr));
               Expected : constant Uint8 :=
                  C.Rom (Natural (Bank) * 16#4000# + I);
            begin
               if Actual /= Expected then
                  declare
                     Exn : constant String :=
                        "Bank:" & Bank'Image & ", Address:" & I'Image & ", " &
                        "Actual:" & Actual'Image & ", Expected:" &
                        Expected'Image;
                  begin
                     raise Program_Error with Exn;
                  end;
               end if;
            end;
         end loop;
      end loop;

      --  Fill the RAM with /= data with Write
      for Bank in 16#00# .. Unsigned_32 (16#0F#) loop
         --  Set 4 least significant bits
         Write (C.all, 16#4000#, Uint8 (Bank));

         for I in 16#0000# .. Unsigned_32 (16#1FFF#) loop
            Write (C.all, Addr16 (I + 16#A000#),
               Uint8 ((Shift_Left (I mod 16#10#, 16#04#) or Bank)
                      and 16#FF#));
         end loop;
      end loop;

      --  test ram fist
      for Bank in 0 .. Unsigned_32 (16#0F#) loop
         --  Set 4 least significant bits
         Write (C.all, 16#4000#, Uint8 (Bank));

         for I in 16#0000# .. Unsigned_32 (16#1FFF#) loop
            declare
               Actual : constant Uint8 :=
                  Read (C.all, Addr16 (I + 16#A000#));
               Expected : constant Uint8 :=
                  Uint8 ((Shift_Left (I mod 16#10#, 16#04#) or Bank)
                         and 16#FF#);
            begin
               if Actual /= Expected then
                  declare
                     Exn : constant String :=
                        "Bank:" & Bank'Image & ", Address:" & I'Image & ", " &
                        "Actual:" & Actual'Image & ", Expected:" &
                        Expected'Image;
                  begin
                     raise Program_Error with Exn;
                  end;
               end if;
            end;
         end loop;
      end loop;
   end Test_MBC5;

   procedure Test_MBC3 is
      C : Cartridge_T (16#80# * 16#4000# - 1, 16#04# * 16#2000# - 1);
   begin
      C.Is_MBC3 := True;

      Init_ROM (C);

      for Bank in 0 .. Unsigned_32 (16#1F#) loop
         --  Set 7 bits
         Write (C, 16#2000#, Uint8 (Bank));

         for I in 16#0000# .. 16#3FFF# loop
            declare
               Actual_Addr : constant Natural :=
                  (if Bank = 0 then I else I + 16#4000#);
               Actual : constant Uint8 := Read (C, Addr16 (Actual_Addr));
               Expected : constant Uint8 :=
                  C.Rom (Natural (Bank) * 16#4000# + I);
            begin
               if Actual /= Expected then
                  declare
                     Exn : constant String :=
                        "Bank:" & Bank'Image & ", Address:" & I'Image & ", " &
                        "Actual:" & Actual'Image & ", Expected:" &
                        Expected'Image;
                  begin
                     raise Program_Error with Exn;
                  end;
               end if;
            end;
         end loop;
      end loop;

      --  Fill the RAM with /= data with Write
      for Bank in 16#00# .. 16#03# loop
         Write (C, 16#4000#, Uint8 (Bank));

         for I in 16#A000# .. 16#BFFF# loop
            Write (C, Addr16 (I),
               Uint8 ((Shift_Left (Unsigned_32 (I) mod 16#40#, 16#02#)
                        or Unsigned_32 (Bank))
                      and 16#FF#));
         end loop;
      end loop;

      for Bank in 16#00# .. 16#03# loop
         --  Any bank always resolves to 16#A000# .. 16#BFFF# in non advanced
         --  banking mode

         Write (C, 16#4000#, Uint8 (Bank));

         for I in 16#A000# .. 16#BFFF# loop
            declare
               Actual : constant Uint8 := Read (C, Addr16 (I));

               --  Manually use the same expression as the one we wrote to
               --  really test that writing to the RAM works
               Expected : constant Uint8 :=
                  Uint8 ((Shift_Left (Unsigned_32 (I) mod 16#40#, 16#02#)
                           or Unsigned_32 (Bank))
                         and 16#FF#);
            begin
               if Actual /= Expected then
                  declare
                     Exn : constant String :=
                        "Bank:" & Bank'Image & ", Address:" & I'Image & ", " &
                        "Actual:" & Actual'Image & ", Expected:" &
                        Expected'Image;
                  begin
                     raise Program_Error with Exn;
                  end;
               end if;
            end;
         end loop;
      end loop;
   end Test_MBC3;

   procedure Run is
   begin
      Test_Cartridge_ROM;

      Test_Extended_ROM;

      --  Test all bank sizes
      for Bank_Size in 16#01# .. 16#20# loop
         Test_ROM (Bank_Size);
      end loop;

      Test_RAM;

      Test_MBC3;

      Test_MBC5;
   end Run;
end Cartridge.Test_Cartridge;
