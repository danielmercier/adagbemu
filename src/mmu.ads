with HAL; use HAL;

package MMU is
   type Memory_Array is limited private;

   protected type Memory_T is
      function Get (A : Addr16) return Uint8;
      procedure Set (A : Addr16; V : Uint8);
   private
      Memory : Memory_Array;
   end Memory_T;

private
   type Memory_Array is array (Addr16) of Uint8;
end MMU;
