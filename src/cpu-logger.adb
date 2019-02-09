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
begin
   OPCode_IO.Default_Base := 16;
end CPU.Logger;
