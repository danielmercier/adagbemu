with HAL; use HAL;

with Interfaces.C; use Interfaces.C;

package CPU_C_Interface is
   type Mem_Access is record
      Typ : int;
      Addr : Addr16;
      Val : Uint8;
   end record with Convention => C;

   type Mem_Accesses_T is array (0 .. 15) of Mem_Access;

   type State_T is record
      AF, BC, DE, HL : Uint16;

      SP : Uint16;
      PC : Addr16;

      Halted : Boolean;
      Interrupts_Master_Enabled : Boolean;

      Num_Mem_Accesses : Integer;
      Mem_Accesses : Mem_Accesses_T;
   end record with Convention => C;

   procedure Init (Mem_Size : size_t; Mem_Access : access Uint8)
      with Export, Convention => C, External_Name => "init";
   procedure Get_State (State : access State_T)
      with Export, Convention => C, External_Name => "get_state";
   procedure Set_State (State : access State_T)
      with Export, Convention => C, External_Name => "set_state";
   function Step return int
      with Export, Convention => C, External_Name => "step";
end CPU_C_Interface;
