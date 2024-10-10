with HAL; use HAL;
with MMU; use MMU;

package CPU is
   type CPU_T is limited private;

   type Reg8_T is (F, A, C, B, E, D, L, H);
   type Reg16_T is (AF, BC, DE, HL, SP);
   type Flag_T is (C, H, N, Z);

   --  used for typing, to see a register as a pointer
   type Ptr8_T is private;
   type Ptr16_T is private;

   function "+" (R : Reg8_T) return Ptr8_T;
   function "+" (R : Reg16_T) return Ptr16_T;

   --  Initialize the given CPU with given memory
   --  Also set registers to intial values
   procedure Init (CPU : out CPU_T; Mem : Memory_T);

   --  Registers getters
   function Reg (CPU : CPU_T; R : Reg8_T) return Uint8;
   function Reg (CPU : CPU_T; R : Reg16_T) return Uint16;
   function Reg (CPU : CPU_T; P : Ptr16_T) return Addr16;
   function Reg (CPU : CPU_T; P : Ptr8_T) return Addr16;
   function Flag (CPU : CPU_T; F : Flag_T) return Boolean;

   --  Registers setters
   procedure Set_Reg (CPU : in out CPU_T; R : Reg8_T; V : Uint8);
   procedure Set_Reg (CPU : in out CPU_T; R : Reg16_T; V : Uint16);
   procedure Set_Reg (CPU : in out CPU_T; R : Ptr16_T; V : Addr16);
   procedure Set_Flag (CPU : in out CPU_T; F : Flag_T; B : Boolean);

   --  Memory getters
   function Mem (CPU : CPU_T; A : Addr16) return Uint8;
   function Mem (CPU : CPU_T; P : Ptr16_T) return Uint8;
   function Mem (CPU : CPU_T; P : Ptr8_T) return Uint8;

   --  Memory setters
   procedure Set_Mem (CPU : in out CPU_T; A : Addr16; V : Uint8);
   procedure Set_Mem (CPU : in out CPU_T; P : Ptr16_T; V : Uint8);
   procedure Set_Mem (CPU : in out CPU_T; P : Ptr8_T; V : Uint8);

   --  Useful for testing as it sets another memory to read/write
   type Getter_T is access function (A : Addr16) return Uint8;
   type Setter_T is access procedure (A : Addr16; V : Uint8);

   procedure Change_Accessors
      (CPU : in out CPU_T;
       Getter : Getter_T;
       Setter : Setter_T);

   --  return the current program counter
   function Get_PC (CPU : CPU_T) return Addr16;
   --  increment the current program counter
   procedure Increment_PC (CPU : in out CPU_T);
   --  set the current program counter
   procedure Set_PC (CPU : in out CPU_T; PC : Addr16);

   --  Return the state of the master interrupts flag
   function Interrupt_Master_Enable (CPU : CPU_T) return Boolean;
   --  Master disable interrupts
   procedure Disable_Interrupts (CPU : in out CPU_T);
   --  Master enable interrupts
   procedure Enable_Interrupts (CPU : in out CPU_T);
   procedure Set_Should_Enable_Interrupts (CPU : in out CPU_T);
   procedure Unset_Should_Enable_Interrupts (CPU : in out CPU_T);
   function Should_Enable_Interrupts (CPU : CPU_T) return Boolean;

   function Pending_Interrupt (CPU : CPU_T) return Boolean;

   function Halt_Mode (CPU : CPU_T) return Boolean;
   procedure Set_Halt_Mode (CPU : in out CPU_T);
   procedure Unset_Halt_Mode (CPU : in out CPU_T);

   --  Return true if the last instruction made a conditional jump
   function Last_Branch_Taken (CPU : CPU_T) return Boolean;
   --  Set to B if the last instruction made a condition jump
   procedure Set_Last_Branch_Taken (CPU : in out CPU_T; B : Boolean);

   --  Push given value on the stack. Stack is defined by stack pointer.
   --  The stack pointer is decremented before the push
   procedure Push (CPU : in out CPU_T; Value : Uint16);
   procedure Push (CPU : in out CPU_T; Value : Addr16);
   --  Pop value and return it, Stack_Pointer points to the top of the stack.
   --  It is incremented after.
   function Pop (CPU : in out CPU_T) return Uint16;
   function Pop (CPU : in out CPU_T) return Addr16;

   --  Functions that read the next value at location program counter and
   --  increments program counter to point to the new location
   function Read_D8 (CPU : in out CPU_T) return Uint8;
   function Read_R8 (CPU : in out CPU_T) return Int8;
   function Read_A8 (CPU : in out CPU_T) return Addr8;
   function Read_D16 (CPU : in out CPU_T) return Uint16;
   function Read_A16 (CPU : in out CPU_T) return Addr16;

   function CB_Prefixed (CPU : CPU_T) return Boolean;
   procedure Set_CB_Prefixed (CPU : in out CPU_T);
   procedure Unset_CB_Prefixed (CPU : in out CPU_T);
private
   type Ptr8_T is new Reg8_T;
   type Ptr16_T is new Reg16_T;

   type Reg8_Array is array (Reg8_T) of Uint8;
   type Reg16_Array is array (Reg16_T) of Uint16;
   type Flag_Array is array (Flag_T) of Boolean with Pack;

   type Dummy_T is range 1 .. 3;
   type Registers_T (Dummy : Dummy_T := 1) is record
      case Dummy is
         when 1 =>
            Regs16 : Reg16_Array;
         when 2 =>
            Regs8 : Reg8_Array;
         when 3 =>
            Flags : Flag_Array;
      end case;
   end record with Unchecked_Union;

   for Registers_T use record
      Regs16 at 0 range 0 .. 79;
      Regs8 at 0 range 0 .. 63;
      Flags at 0 range 4 .. 7;
   end record;

   type CPU_T is tagged limited record
      Registers : Registers_T;
      Program_Counter : Addr16;

      Memory : Memory_T;

      --  Next instruction is CB prefixed
      CB_Prefixed : Boolean := False;

      --  Flag to say if interrupts are enabled or not
      Interrupt_Master_Enable : Boolean := False;

      --  Flag to say that interrupts should be enabled after the next
      --  instruction
      Should_Enable_Interrupts : Boolean := False;

      --  The cpu is in a halt mode state and is waiting for an interrupt
      Halt_Mode : Boolean := False;

      --  Used to signal that the last instruction made a conditional jump
      Last_Branch_Taken : Boolean := False;

      --  Some info useful for testing
      Mem_Setter : Setter_T;
      Mem_Getter : Getter_T;
   end record;
end CPU;
