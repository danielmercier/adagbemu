with Ada.Text_IO; use Ada.Text_IO;

package CPU.Logger is
   package Uint8_IO is new Modular_IO (Uint8);
   use Uint8_IO;
   package Uint16_IO is new Modular_IO (Uint16);
   use Uint16_IO;
   package Int8_IO is new Integer_IO (Int8);
   use Int8_IO;
   package Int16_IO is new Integer_IO (Int16);
   use Int16_IO;
   package Addr16_IO is new Integer_IO (Addr16);
   use Addr16_IO;
   package Addr8_IO is new Integer_IO (Addr8);
   use Addr8_IO;
   package OPCode_IO is new Integer_IO (OPCode_T);
   use OPCode_IO;

   procedure Log_Not_Implemented (CPU : CPU_T);
   procedure Log_CPU_Info (CPU : CPU_T);
end CPU.Logger;
