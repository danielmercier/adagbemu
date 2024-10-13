with GB; use GB;

package Input is
   procedure Update
      (GB : in out GB_T;
       Left : Boolean;
       Right : Boolean;
       Up : Boolean;
       Down : Boolean;
       A : Boolean;
       B : Boolean;
       Start : Boolean;
       Selectt : Boolean);
end Input;
