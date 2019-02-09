with Ada.Text_IO; use Ada.Text_IO;

with HAL; use HAL;
with CPU; use CPU;

package CPU.Logger is
   package OPCode_IO is new Integer_IO (OPCode_T);
   use OPCode_IO;

   procedure Log_Not_Implemented (CPU : CPU_T);
end CPU.Logger;
