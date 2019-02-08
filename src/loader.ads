with HAL; use HAL;
with GB; use GB;

package Loader is
   --  Load into memory from filename
   procedure Load (Filename : String; GB : in out GB_T; Start : Addr16);
end Loader;
