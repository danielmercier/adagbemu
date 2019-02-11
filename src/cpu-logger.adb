with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Mnemonic_Table; use Mnemonic_Table;

package body CPU.Logger is
   procedure Log_Not_Implemented (CPU : CPU_T) is
      CB : Boolean := False;
      OPCode : constant OPCode_T := OPCode_T (Mem (CPU, Get_PC (CPU) - 1));
   begin
      if Mem (CPU, Get_PC (CPU) - 2) = 16#CB# then
         CB := True;
      end if;

      Put ("Not Implemented: ");
      Put (OPCode);
      Put (": ");
      if CB then
         Put_Line (To_String (CBprefixed (OPCode)));
      else
         Put_Line (To_String (Unprefixed (OPCode)));
      end if;
   end Log_Not_Implemented;

   procedure Log_CPU_Info (CPU : CPU_T) is
   begin
      for R in Reg16_T loop
         Put (R'Image & ": ");
         Put (Reg (CPU, R));
         New_Line;
      end loop;

      Put ("PC: ");
      Put (Get_PC (CPU));
      New_Line;
   end Log_CPU_Info;
begin
   OPCode_IO.Default_Base := 16;
   Uint8_IO.Default_Base := 16;
   Uint16_IO.Default_Base := 16;
   Int8_IO.Default_Base := 16;
   Int16_IO.Default_Base := 16;
   Addr8_IO.Default_Base := 16;
   Addr16_IO.Default_Base := 16;
end CPU.Logger;
