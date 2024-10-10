with HAL; use HAL;
with CPU; use CPU;
with GB; use GB;

package Decoder is
   procedure Emulate_Cycle (GB : in out GB_T);
   function Emulate_Cycle (GB : in out GB_T) return Clock_T;
private
   function Fetch (CPU : CPU_T) return OPCode_T;
   function Decode (GB : in out GB_T; OPCode : OPCode_T) return Clock_T;
   procedure Handle_Cycles (GB : in out GB_T; Cycles : Clock_T);
end Decoder;
