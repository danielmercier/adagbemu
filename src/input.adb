with MMU.Registers; use MMU.Registers;
with CPU.Interrupts; use CPU.Interrupts;

with Ada.Unchecked_Conversion;

package body Input is

   procedure Update
      (GB : in out GB_T;
       Left : Boolean;
       Right : Boolean;
       Up : Boolean;
       Down : Boolean;
       A : Boolean;
       B : Boolean;
       Start : Boolean;
       Selectt : Boolean)
   is
      Prev_J : constant JOYP_Array := JOYP (GB.Memory);
      J : JOYP_Array := Prev_J;
   begin
      J (A_Right) := True;
      J (B_Left) := True;
      J (Select_Up) := True;
      J (Start_Down) := True;
      J (Void1) := True;
      J (Void2) := True;

      if not J (Select_Dpad) then
         J (A_Right) := not Right;
         J (B_Left) := not Left;
         J (Select_Up) := not Up;
         J (Start_Down) := not Down;
      end if;

      if not J (Select_Buttons) then
         J (A_Right) := J (A_Right) and then not A;
         J (B_Left) := J (B_Left) and then not B;
         J (Select_Up) := J (Select_Up) and then not Selectt;
         J (Start_Down) := J (Start_Down) and then not Start;
      end if;

      if (Prev_J (A_Right) and then not J (A_Right))
         or else (Prev_J (B_Left) and then not J (B_Left))
         or else (Prev_J (Select_Up) and then not J (Select_Up))
         or else (Prev_J (Start_Down) and then not J (Start_Down))
      then
         --  High to low interrupt
         Interrupt_KeyPad (GB.CPU);
      end if;

      Set_JOYP (GB.Memory, J);
   end Update;
end Input;
