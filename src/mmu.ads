with HAL; use HAL;

package MMU is
   type Memory_Array is limited private;

   function Init return Memory_Array;

   protected type Memory_P is
      function Get (A : Addr16) return Uint8;
      procedure Set (A : Addr16; V : Uint8);
   private
      Memory : Memory_Array := Init;
   end Memory_P;

   type Memory_T is access Memory_P;
private
   type Memory_Array is array (Addr16) of Uint8;
end MMU;
