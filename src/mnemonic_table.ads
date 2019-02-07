with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with HAL; use HAL;

package Mnemonic_Table is
   type Table_T is array (OPCode_T) of Unbounded_String;

   Unprefixed : constant Table_T;
   CBprefixed : constant Table_T;
end Mnemonic_Table;
