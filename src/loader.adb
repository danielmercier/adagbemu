with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

with CPU; use CPU;

package body Loader is
   procedure Load (Filename : String; GB : in out GB_T; Start : Addr16) is
      File : File_Type;
      Input_Stream : Stream_Access;

      Current_Addr : Addr16 := Start;
      Read_Byte : Uint8;
   begin
      Open (File, In_File, Filename);
      Input_Stream := Stream (File);

      while not End_Of_File (File) loop
         Uint8'Read (Input_Stream, Read_Byte);
         GB.Memory.Set (Current_Addr, Read_Byte);

         exit when End_Of_File (File);
         Current_Addr := Current_Addr + 1;
      end loop;

      Close (File);
   end Load;
end Loader;
