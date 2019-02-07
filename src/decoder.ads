with HAL; use HAL;
with CPU; use CPU;
with GB; use GB;
with OPCode_Table; use OPCode_Table;

package Decoder is
   procedure Emulate_Cycle (GB : in out GB_T);
private
   function Fetch (CPU : CPU_T) return OPCode_T;
   procedure Decode (GB : in out GB_T; OPCode : OPCode_T);
   procedure Handle_Cycles (GB : in out GB_T; Cycles : Clock_T);
end Decoder;
