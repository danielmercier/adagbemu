with Instructions; use Instructions;

package body OPCodes is
   procedure OPCode_00 (CPU : in out CPU_T) is
   begin
      NOP (CPU);
   end OPCode_00;

   procedure OPCode_01 (CPU : in out CPU_T) is
   begin
      LD (CPU, BC, Read_D16 (CPU));
   end OPCode_01;

   procedure OPCode_02 (CPU : in out CPU_T) is
   begin
      LD (CPU, +BC, A);
   end OPCode_02;

   procedure OPCode_03 (CPU : in out CPU_T) is
   begin
      INC (CPU, BC);
   end OPCode_03;

   procedure OPCode_04 (CPU : in out CPU_T) is
   begin
      INC (CPU, B);
   end OPCode_04;

   procedure OPCode_05 (CPU : in out CPU_T) is
   begin
      DEC (CPU, B);
   end OPCode_05;

   procedure OPCode_06 (CPU : in out CPU_T) is
   begin
      LD (CPU, B, Read_D8 (CPU));
   end OPCode_06;

   procedure OPCode_07 (CPU : in out CPU_T) is
   begin
      RLCA (CPU);
   end OPCode_07;

   procedure OPCode_08 (CPU : in out CPU_T) is
   begin
      LD (CPU, Read_A16 (CPU), SP);
   end OPCode_08;

   procedure OPCode_09 (CPU : in out CPU_T) is
   begin
      ADD (CPU, HL, BC);
   end OPCode_09;

   procedure OPCode_0A (CPU : in out CPU_T) is
   begin
      LD (CPU, A, +BC);
   end OPCode_0A;

   procedure OPCode_0B (CPU : in out CPU_T) is
   begin
      DEC (CPU, BC);
   end OPCode_0B;

   procedure OPCode_0C (CPU : in out CPU_T) is
   begin
      INC (CPU, C);
   end OPCode_0C;

   procedure OPCode_0D (CPU : in out CPU_T) is
   begin
      DEC (CPU, C);
   end OPCode_0D;

   procedure OPCode_0E (CPU : in out CPU_T) is
   begin
      LD (CPU, C, Read_D8 (CPU));
   end OPCode_0E;

   procedure OPCode_0F (CPU : in out CPU_T) is
   begin
      RRCA (CPU);
   end OPCode_0F;

   procedure OPCode_10 (CPU : in out CPU_T) is
   begin
      STOP (CPU, 0);
   end OPCode_10;

   procedure OPCode_11 (CPU : in out CPU_T) is
   begin
      LD (CPU, DE, Read_D16 (CPU));
   end OPCode_11;

   procedure OPCode_12 (CPU : in out CPU_T) is
   begin
      LD (CPU, +DE, A);
   end OPCode_12;

   procedure OPCode_13 (CPU : in out CPU_T) is
   begin
      INC (CPU, DE);
   end OPCode_13;

   procedure OPCode_14 (CPU : in out CPU_T) is
   begin
      INC (CPU, D);
   end OPCode_14;

   procedure OPCode_15 (CPU : in out CPU_T) is
   begin
      DEC (CPU, D);
   end OPCode_15;

   procedure OPCode_16 (CPU : in out CPU_T) is
   begin
      LD (CPU, D, Read_D8 (CPU));
   end OPCode_16;

   procedure OPCode_17 (CPU : in out CPU_T) is
   begin
      RLA (CPU);
   end OPCode_17;

   procedure OPCode_18 (CPU : in out CPU_T) is
   begin
      JR (CPU, Read_R8 (CPU));
   end OPCode_18;

   procedure OPCode_19 (CPU : in out CPU_T) is
   begin
      ADD (CPU, HL, DE);
   end OPCode_19;

   procedure OPCode_1A (CPU : in out CPU_T) is
   begin
      LD (CPU, A, +DE);
   end OPCode_1A;

   procedure OPCode_1B (CPU : in out CPU_T) is
   begin
      DEC (CPU, DE);
   end OPCode_1B;

   procedure OPCode_1C (CPU : in out CPU_T) is
   begin
      INC (CPU, E);
   end OPCode_1C;

   procedure OPCode_1D (CPU : in out CPU_T) is
   begin
      DEC (CPU, E);
   end OPCode_1D;

   procedure OPCode_1E (CPU : in out CPU_T) is
   begin
      LD (CPU, E, Read_D8 (CPU));
   end OPCode_1E;

   procedure OPCode_1F (CPU : in out CPU_T) is
   begin
      RRA (CPU);
   end OPCode_1F;

   procedure OPCode_20 (CPU : in out CPU_T) is
   begin
      JR (CPU, NZ, Read_R8 (CPU));
   end OPCode_20;

   procedure OPCode_21 (CPU : in out CPU_T) is
   begin
      LD (CPU, HL, Read_D16 (CPU));
   end OPCode_21;

   procedure OPCode_22 (CPU : in out CPU_T) is
   begin
      LD (CPU, Incr (CPU, +HL), A);
   end OPCode_22;

   procedure OPCode_23 (CPU : in out CPU_T) is
   begin
      INC (CPU, HL);
   end OPCode_23;

   procedure OPCode_24 (CPU : in out CPU_T) is
   begin
      INC (CPU, H);
   end OPCode_24;

   procedure OPCode_25 (CPU : in out CPU_T) is
   begin
      DEC (CPU, H);
   end OPCode_25;

   procedure OPCode_26 (CPU : in out CPU_T) is
   begin
      LD (CPU, H, Read_D8 (CPU));
   end OPCode_26;

   procedure OPCode_27 (CPU : in out CPU_T) is
   begin
      DAA (CPU);
   end OPCode_27;

   procedure OPCode_28 (CPU : in out CPU_T) is
   begin
      JR (CPU, Z, Read_R8 (CPU));
   end OPCode_28;

   procedure OPCode_29 (CPU : in out CPU_T) is
   begin
      ADD (CPU, HL, HL);
   end OPCode_29;

   procedure OPCode_2A (CPU : in out CPU_T) is
   begin
      LD (CPU, A, Incr (CPU, +HL));
   end OPCode_2A;

   procedure OPCode_2B (CPU : in out CPU_T) is
   begin
      DEC (CPU, HL);
   end OPCode_2B;

   procedure OPCode_2C (CPU : in out CPU_T) is
   begin
      INC (CPU, L);
   end OPCode_2C;

   procedure OPCode_2D (CPU : in out CPU_T) is
   begin
      DEC (CPU, L);
   end OPCode_2D;

   procedure OPCode_2E (CPU : in out CPU_T) is
   begin
      LD (CPU, L, Read_D8 (CPU));
   end OPCode_2E;

   procedure OPCode_2F (CPU : in out CPU_T) is
   begin
      CPL (CPU);
   end OPCode_2F;

   procedure OPCode_30 (CPU : in out CPU_T) is
   begin
      JR (CPU, NC, Read_R8 (CPU));
   end OPCode_30;

   procedure OPCode_31 (CPU : in out CPU_T) is
   begin
      LD (CPU, SP, Read_D16 (CPU));
   end OPCode_31;

   procedure OPCode_32 (CPU : in out CPU_T) is
   begin
      LD (CPU, Decr (CPU, +HL), A);
   end OPCode_32;

   procedure OPCode_33 (CPU : in out CPU_T) is
   begin
      INC (CPU, SP);
   end OPCode_33;

   procedure OPCode_34 (CPU : in out CPU_T) is
   begin
      INC (CPU, +HL);
   end OPCode_34;

   procedure OPCode_35 (CPU : in out CPU_T) is
   begin
      DEC (CPU, +HL);
   end OPCode_35;

   procedure OPCode_36 (CPU : in out CPU_T) is
   begin
      LD (CPU, +HL, Read_D8 (CPU));
   end OPCode_36;

   procedure OPCode_37 (CPU : in out CPU_T) is
   begin
      SCF (CPU);
   end OPCode_37;

   procedure OPCode_38 (CPU : in out CPU_T) is
   begin
      JR (CPU, C, Read_R8 (CPU));
   end OPCode_38;

   procedure OPCode_39 (CPU : in out CPU_T) is
   begin
      ADD (CPU, HL, SP);
   end OPCode_39;

   procedure OPCode_3A (CPU : in out CPU_T) is
   begin
      LD (CPU, A, Decr (CPU, +HL));
   end OPCode_3A;

   procedure OPCode_3B (CPU : in out CPU_T) is
   begin
      DEC (CPU, SP);
   end OPCode_3B;

   procedure OPCode_3C (CPU : in out CPU_T) is
   begin
      INC (CPU, A);
   end OPCode_3C;

   procedure OPCode_3D (CPU : in out CPU_T) is
   begin
      DEC (CPU, A);
   end OPCode_3D;

   procedure OPCode_3E (CPU : in out CPU_T) is
   begin
      LD (CPU, A, Read_D8 (CPU));
   end OPCode_3E;

   procedure OPCode_3F (CPU : in out CPU_T) is
   begin
      CCF (CPU);
   end OPCode_3F;

   procedure OPCode_40 (CPU : in out CPU_T) is
   begin
      LD (CPU, B, B);
   end OPCode_40;

   procedure OPCode_41 (CPU : in out CPU_T) is
   begin
      LD (CPU, B, C);
   end OPCode_41;

   procedure OPCode_42 (CPU : in out CPU_T) is
   begin
      LD (CPU, B, D);
   end OPCode_42;

   procedure OPCode_43 (CPU : in out CPU_T) is
   begin
      LD (CPU, B, E);
   end OPCode_43;

   procedure OPCode_44 (CPU : in out CPU_T) is
   begin
      LD (CPU, B, H);
   end OPCode_44;

   procedure OPCode_45 (CPU : in out CPU_T) is
   begin
      LD (CPU, B, L);
   end OPCode_45;

   procedure OPCode_46 (CPU : in out CPU_T) is
   begin
      LD (CPU, B, +HL);
   end OPCode_46;

   procedure OPCode_47 (CPU : in out CPU_T) is
   begin
      LD (CPU, B, A);
   end OPCode_47;

   procedure OPCode_48 (CPU : in out CPU_T) is
   begin
      LD (CPU, C, B);
   end OPCode_48;

   procedure OPCode_49 (CPU : in out CPU_T) is
   begin
      LD (CPU, C, C);
   end OPCode_49;

   procedure OPCode_4A (CPU : in out CPU_T) is
   begin
      LD (CPU, C, D);
   end OPCode_4A;

   procedure OPCode_4B (CPU : in out CPU_T) is
   begin
      LD (CPU, C, E);
   end OPCode_4B;

   procedure OPCode_4C (CPU : in out CPU_T) is
   begin
      LD (CPU, C, H);
   end OPCode_4C;

   procedure OPCode_4D (CPU : in out CPU_T) is
   begin
      LD (CPU, C, L);
   end OPCode_4D;

   procedure OPCode_4E (CPU : in out CPU_T) is
   begin
      LD (CPU, C, +HL);
   end OPCode_4E;

   procedure OPCode_4F (CPU : in out CPU_T) is
   begin
      LD (CPU, C, A);
   end OPCode_4F;

   procedure OPCode_50 (CPU : in out CPU_T) is
   begin
      LD (CPU, D, B);
   end OPCode_50;

   procedure OPCode_51 (CPU : in out CPU_T) is
   begin
      LD (CPU, D, C);
   end OPCode_51;

   procedure OPCode_52 (CPU : in out CPU_T) is
   begin
      LD (CPU, D, D);
   end OPCode_52;

   procedure OPCode_53 (CPU : in out CPU_T) is
   begin
      LD (CPU, D, E);
   end OPCode_53;

   procedure OPCode_54 (CPU : in out CPU_T) is
   begin
      LD (CPU, D, H);
   end OPCode_54;

   procedure OPCode_55 (CPU : in out CPU_T) is
   begin
      LD (CPU, D, L);
   end OPCode_55;

   procedure OPCode_56 (CPU : in out CPU_T) is
   begin
      LD (CPU, D, +HL);
   end OPCode_56;

   procedure OPCode_57 (CPU : in out CPU_T) is
   begin
      LD (CPU, D, A);
   end OPCode_57;

   procedure OPCode_58 (CPU : in out CPU_T) is
   begin
      LD (CPU, E, B);
   end OPCode_58;

   procedure OPCode_59 (CPU : in out CPU_T) is
   begin
      LD (CPU, E, C);
   end OPCode_59;

   procedure OPCode_5A (CPU : in out CPU_T) is
   begin
      LD (CPU, E, D);
   end OPCode_5A;

   procedure OPCode_5B (CPU : in out CPU_T) is
   begin
      LD (CPU, E, E);
   end OPCode_5B;

   procedure OPCode_5C (CPU : in out CPU_T) is
   begin
      LD (CPU, E, H);
   end OPCode_5C;

   procedure OPCode_5D (CPU : in out CPU_T) is
   begin
      LD (CPU, E, L);
   end OPCode_5D;

   procedure OPCode_5E (CPU : in out CPU_T) is
   begin
      LD (CPU, E, +HL);
   end OPCode_5E;

   procedure OPCode_5F (CPU : in out CPU_T) is
   begin
      LD (CPU, E, A);
   end OPCode_5F;

   procedure OPCode_60 (CPU : in out CPU_T) is
   begin
      LD (CPU, H, B);
   end OPCode_60;

   procedure OPCode_61 (CPU : in out CPU_T) is
   begin
      LD (CPU, H, C);
   end OPCode_61;

   procedure OPCode_62 (CPU : in out CPU_T) is
   begin
      LD (CPU, H, D);
   end OPCode_62;

   procedure OPCode_63 (CPU : in out CPU_T) is
   begin
      LD (CPU, H, E);
   end OPCode_63;

   procedure OPCode_64 (CPU : in out CPU_T) is
   begin
      LD (CPU, H, H);
   end OPCode_64;

   procedure OPCode_65 (CPU : in out CPU_T) is
   begin
      LD (CPU, H, L);
   end OPCode_65;

   procedure OPCode_66 (CPU : in out CPU_T) is
   begin
      LD (CPU, H, +HL);
   end OPCode_66;

   procedure OPCode_67 (CPU : in out CPU_T) is
   begin
      LD (CPU, H, A);
   end OPCode_67;

   procedure OPCode_68 (CPU : in out CPU_T) is
   begin
      LD (CPU, L, B);
   end OPCode_68;

   procedure OPCode_69 (CPU : in out CPU_T) is
   begin
      LD (CPU, L, C);
   end OPCode_69;

   procedure OPCode_6A (CPU : in out CPU_T) is
   begin
      LD (CPU, L, D);
   end OPCode_6A;

   procedure OPCode_6B (CPU : in out CPU_T) is
   begin
      LD (CPU, L, E);
   end OPCode_6B;

   procedure OPCode_6C (CPU : in out CPU_T) is
   begin
      LD (CPU, L, H);
   end OPCode_6C;

   procedure OPCode_6D (CPU : in out CPU_T) is
   begin
      LD (CPU, L, L);
   end OPCode_6D;

   procedure OPCode_6E (CPU : in out CPU_T) is
   begin
      LD (CPU, L, +HL);
   end OPCode_6E;

   procedure OPCode_6F (CPU : in out CPU_T) is
   begin
      LD (CPU, L, A);
   end OPCode_6F;

   procedure OPCode_70 (CPU : in out CPU_T) is
   begin
      LD (CPU, +HL, B);
   end OPCode_70;

   procedure OPCode_71 (CPU : in out CPU_T) is
   begin
      LD (CPU, +HL, C);
   end OPCode_71;

   procedure OPCode_72 (CPU : in out CPU_T) is
   begin
      LD (CPU, +HL, D);
   end OPCode_72;

   procedure OPCode_73 (CPU : in out CPU_T) is
   begin
      LD (CPU, +HL, E);
   end OPCode_73;

   procedure OPCode_74 (CPU : in out CPU_T) is
   begin
      LD (CPU, +HL, H);
   end OPCode_74;

   procedure OPCode_75 (CPU : in out CPU_T) is
   begin
      LD (CPU, +HL, L);
   end OPCode_75;

   procedure OPCode_76 (CPU : in out CPU_T) is
   begin
      HALT (CPU);
   end OPCode_76;

   procedure OPCode_77 (CPU : in out CPU_T) is
   begin
      LD (CPU, +HL, A);
   end OPCode_77;

   procedure OPCode_78 (CPU : in out CPU_T) is
   begin
      LD (CPU, A, B);
   end OPCode_78;

   procedure OPCode_79 (CPU : in out CPU_T) is
   begin
      LD (CPU, A, C);
   end OPCode_79;

   procedure OPCode_7A (CPU : in out CPU_T) is
   begin
      LD (CPU, A, D);
   end OPCode_7A;

   procedure OPCode_7B (CPU : in out CPU_T) is
   begin
      LD (CPU, A, E);
   end OPCode_7B;

   procedure OPCode_7C (CPU : in out CPU_T) is
   begin
      LD (CPU, A, H);
   end OPCode_7C;

   procedure OPCode_7D (CPU : in out CPU_T) is
   begin
      LD (CPU, A, L);
   end OPCode_7D;

   procedure OPCode_7E (CPU : in out CPU_T) is
   begin
      LD (CPU, A, +HL);
   end OPCode_7E;

   procedure OPCode_7F (CPU : in out CPU_T) is
   begin
      LD (CPU, A, A);
   end OPCode_7F;

   procedure OPCode_80 (CPU : in out CPU_T) is
   begin
      ADD (CPU, A, B);
   end OPCode_80;

   procedure OPCode_81 (CPU : in out CPU_T) is
   begin
      ADD (CPU, A, C);
   end OPCode_81;

   procedure OPCode_82 (CPU : in out CPU_T) is
   begin
      ADD (CPU, A, D);
   end OPCode_82;

   procedure OPCode_83 (CPU : in out CPU_T) is
   begin
      ADD (CPU, A, E);
   end OPCode_83;

   procedure OPCode_84 (CPU : in out CPU_T) is
   begin
      ADD (CPU, A, H);
   end OPCode_84;

   procedure OPCode_85 (CPU : in out CPU_T) is
   begin
      ADD (CPU, A, L);
   end OPCode_85;

   procedure OPCode_86 (CPU : in out CPU_T) is
   begin
      ADD (CPU, A, +HL);
   end OPCode_86;

   procedure OPCode_87 (CPU : in out CPU_T) is
   begin
      ADD (CPU, A, A);
   end OPCode_87;

   procedure OPCode_88 (CPU : in out CPU_T) is
   begin
      ADC (CPU, A, B);
   end OPCode_88;

   procedure OPCode_89 (CPU : in out CPU_T) is
   begin
      ADC (CPU, A, C);
   end OPCode_89;

   procedure OPCode_8A (CPU : in out CPU_T) is
   begin
      ADC (CPU, A, D);
   end OPCode_8A;

   procedure OPCode_8B (CPU : in out CPU_T) is
   begin
      ADC (CPU, A, E);
   end OPCode_8B;

   procedure OPCode_8C (CPU : in out CPU_T) is
   begin
      ADC (CPU, A, H);
   end OPCode_8C;

   procedure OPCode_8D (CPU : in out CPU_T) is
   begin
      ADC (CPU, A, L);
   end OPCode_8D;

   procedure OPCode_8E (CPU : in out CPU_T) is
   begin
      ADC (CPU, A, +HL);
   end OPCode_8E;

   procedure OPCode_8F (CPU : in out CPU_T) is
   begin
      ADC (CPU, A, A);
   end OPCode_8F;

   procedure OPCode_90 (CPU : in out CPU_T) is
   begin
      SUB (CPU, B);
   end OPCode_90;

   procedure OPCode_91 (CPU : in out CPU_T) is
   begin
      SUB (CPU, C);
   end OPCode_91;

   procedure OPCode_92 (CPU : in out CPU_T) is
   begin
      SUB (CPU, D);
   end OPCode_92;

   procedure OPCode_93 (CPU : in out CPU_T) is
   begin
      SUB (CPU, E);
   end OPCode_93;

   procedure OPCode_94 (CPU : in out CPU_T) is
   begin
      SUB (CPU, H);
   end OPCode_94;

   procedure OPCode_95 (CPU : in out CPU_T) is
   begin
      SUB (CPU, L);
   end OPCode_95;

   procedure OPCode_96 (CPU : in out CPU_T) is
   begin
      SUB (CPU, +HL);
   end OPCode_96;

   procedure OPCode_97 (CPU : in out CPU_T) is
   begin
      SUB (CPU, A);
   end OPCode_97;

   procedure OPCode_98 (CPU : in out CPU_T) is
   begin
      SBC (CPU, A, B);
   end OPCode_98;

   procedure OPCode_99 (CPU : in out CPU_T) is
   begin
      SBC (CPU, A, C);
   end OPCode_99;

   procedure OPCode_9A (CPU : in out CPU_T) is
   begin
      SBC (CPU, A, D);
   end OPCode_9A;

   procedure OPCode_9B (CPU : in out CPU_T) is
   begin
      SBC (CPU, A, E);
   end OPCode_9B;

   procedure OPCode_9C (CPU : in out CPU_T) is
   begin
      SBC (CPU, A, H);
   end OPCode_9C;

   procedure OPCode_9D (CPU : in out CPU_T) is
   begin
      SBC (CPU, A, L);
   end OPCode_9D;

   procedure OPCode_9E (CPU : in out CPU_T) is
   begin
      SBC (CPU, A, +HL);
   end OPCode_9E;

   procedure OPCode_9F (CPU : in out CPU_T) is
   begin
      SBC (CPU, A, A);
   end OPCode_9F;

   procedure OPCode_A0 (CPU : in out CPU_T) is
   begin
      ANDD (CPU, B);
   end OPCode_A0;

   procedure OPCode_A1 (CPU : in out CPU_T) is
   begin
      ANDD (CPU, C);
   end OPCode_A1;

   procedure OPCode_A2 (CPU : in out CPU_T) is
   begin
      ANDD (CPU, D);
   end OPCode_A2;

   procedure OPCode_A3 (CPU : in out CPU_T) is
   begin
      ANDD (CPU, E);
   end OPCode_A3;

   procedure OPCode_A4 (CPU : in out CPU_T) is
   begin
      ANDD (CPU, H);
   end OPCode_A4;

   procedure OPCode_A5 (CPU : in out CPU_T) is
   begin
      ANDD (CPU, L);
   end OPCode_A5;

   procedure OPCode_A6 (CPU : in out CPU_T) is
   begin
      ANDD (CPU, +HL);
   end OPCode_A6;

   procedure OPCode_A7 (CPU : in out CPU_T) is
   begin
      ANDD (CPU, A);
   end OPCode_A7;

   procedure OPCode_A8 (CPU : in out CPU_T) is
   begin
      XORR (CPU, B);
   end OPCode_A8;

   procedure OPCode_A9 (CPU : in out CPU_T) is
   begin
      XORR (CPU, C);
   end OPCode_A9;

   procedure OPCode_AA (CPU : in out CPU_T) is
   begin
      XORR (CPU, D);
   end OPCode_AA;

   procedure OPCode_AB (CPU : in out CPU_T) is
   begin
      XORR (CPU, E);
   end OPCode_AB;

   procedure OPCode_AC (CPU : in out CPU_T) is
   begin
      XORR (CPU, H);
   end OPCode_AC;

   procedure OPCode_AD (CPU : in out CPU_T) is
   begin
      XORR (CPU, L);
   end OPCode_AD;

   procedure OPCode_AE (CPU : in out CPU_T) is
   begin
      XORR (CPU, +HL);
   end OPCode_AE;

   procedure OPCode_AF (CPU : in out CPU_T) is
   begin
      XORR (CPU, A);
   end OPCode_AF;

   procedure OPCode_B0 (CPU : in out CPU_T) is
   begin
      ORR (CPU, B);
   end OPCode_B0;

   procedure OPCode_B1 (CPU : in out CPU_T) is
   begin
      ORR (CPU, C);
   end OPCode_B1;

   procedure OPCode_B2 (CPU : in out CPU_T) is
   begin
      ORR (CPU, D);
   end OPCode_B2;

   procedure OPCode_B3 (CPU : in out CPU_T) is
   begin
      ORR (CPU, E);
   end OPCode_B3;

   procedure OPCode_B4 (CPU : in out CPU_T) is
   begin
      ORR (CPU, H);
   end OPCode_B4;

   procedure OPCode_B5 (CPU : in out CPU_T) is
   begin
      ORR (CPU, L);
   end OPCode_B5;

   procedure OPCode_B6 (CPU : in out CPU_T) is
   begin
      ORR (CPU, +HL);
   end OPCode_B6;

   procedure OPCode_B7 (CPU : in out CPU_T) is
   begin
      ORR (CPU, A);
   end OPCode_B7;

   procedure OPCode_B8 (CPU : in out CPU_T) is
   begin
      CP (CPU, B);
   end OPCode_B8;

   procedure OPCode_B9 (CPU : in out CPU_T) is
   begin
      CP (CPU, C);
   end OPCode_B9;

   procedure OPCode_BA (CPU : in out CPU_T) is
   begin
      CP (CPU, D);
   end OPCode_BA;

   procedure OPCode_BB (CPU : in out CPU_T) is
   begin
      CP (CPU, E);
   end OPCode_BB;

   procedure OPCode_BC (CPU : in out CPU_T) is
   begin
      CP (CPU, H);
   end OPCode_BC;

   procedure OPCode_BD (CPU : in out CPU_T) is
   begin
      CP (CPU, L);
   end OPCode_BD;

   procedure OPCode_BE (CPU : in out CPU_T) is
   begin
      CP (CPU, +HL);
   end OPCode_BE;

   procedure OPCode_BF (CPU : in out CPU_T) is
   begin
      CP (CPU, A);
   end OPCode_BF;

   procedure OPCode_C0 (CPU : in out CPU_T) is
   begin
      RET (CPU, NZ);
   end OPCode_C0;

   procedure OPCode_C1 (CPU : in out CPU_T) is
   begin
      POP (CPU, BC);
   end OPCode_C1;

   procedure OPCode_C2 (CPU : in out CPU_T) is
   begin
      JP (CPU, NZ, Read_A16 (CPU));
   end OPCode_C2;

   procedure OPCode_C3 (CPU : in out CPU_T) is
   begin
      JP (CPU, Read_A16 (CPU));
   end OPCode_C3;

   procedure OPCode_C4 (CPU : in out CPU_T) is
   begin
      CALL (CPU, NZ, Read_A16 (CPU));
   end OPCode_C4;

   procedure OPCode_C5 (CPU : in out CPU_T) is
   begin
      PUSH (CPU, BC);
   end OPCode_C5;

   procedure OPCode_C6 (CPU : in out CPU_T) is
   begin
      ADD (CPU, A, Read_D8 (CPU));
   end OPCode_C6;

   procedure OPCode_C7 (CPU : in out CPU_T) is
   begin
      RST (CPU, 16#00#);
   end OPCode_C7;

   procedure OPCode_C8 (CPU : in out CPU_T) is
   begin
      RET (CPU, Z);
   end OPCode_C8;

   procedure OPCode_C9 (CPU : in out CPU_T) is
   begin
      RET (CPU);
   end OPCode_C9;

   procedure OPCode_CA (CPU : in out CPU_T) is
   begin
      JP (CPU, Z, Read_A16 (CPU));
   end OPCode_CA;

   procedure OPCode_CB (CPU : in out CPU_T) is
   begin
      PREFIX (CPU);
   end OPCode_CB;

   procedure OPCode_CC (CPU : in out CPU_T) is
   begin
      CALL (CPU, Z, Read_A16 (CPU));
   end OPCode_CC;

   procedure OPCode_CD (CPU : in out CPU_T) is
   begin
      CALL (CPU, Read_A16 (CPU));
   end OPCode_CD;

   procedure OPCode_CE (CPU : in out CPU_T) is
   begin
      ADC (CPU, A, Read_D8 (CPU));
   end OPCode_CE;

   procedure OPCode_CF (CPU : in out CPU_T) is
   begin
      RST (CPU, 16#08#);
   end OPCode_CF;

   procedure OPCode_D0 (CPU : in out CPU_T) is
   begin
      RET (CPU, NC);
   end OPCode_D0;

   procedure OPCode_D1 (CPU : in out CPU_T) is
   begin
      POP (CPU, DE);
   end OPCode_D1;

   procedure OPCode_D2 (CPU : in out CPU_T) is
   begin
      JP (CPU, NC, Read_A16 (CPU));
   end OPCode_D2;

   procedure OPCode_D4 (CPU : in out CPU_T) is
   begin
      CALL (CPU, NC, Read_A16 (CPU));
   end OPCode_D4;

   procedure OPCode_D5 (CPU : in out CPU_T) is
   begin
      PUSH (CPU, DE);
   end OPCode_D5;

   procedure OPCode_D6 (CPU : in out CPU_T) is
   begin
      SUB (CPU, Read_D8 (CPU));
   end OPCode_D6;

   procedure OPCode_D7 (CPU : in out CPU_T) is
   begin
      RST (CPU, 16#10#);
   end OPCode_D7;

   procedure OPCode_D8 (CPU : in out CPU_T) is
   begin
      RET (CPU, C);
   end OPCode_D8;

   procedure OPCode_D9 (CPU : in out CPU_T) is
   begin
      RETI (CPU);
   end OPCode_D9;

   procedure OPCode_DA (CPU : in out CPU_T) is
   begin
      JP (CPU, C, Read_A16 (CPU));
   end OPCode_DA;

   procedure OPCode_DC (CPU : in out CPU_T) is
   begin
      CALL (CPU, C, Read_A16 (CPU));
   end OPCode_DC;

   procedure OPCode_DE (CPU : in out CPU_T) is
   begin
      SBC (CPU, A, Read_D8 (CPU));
   end OPCode_DE;

   procedure OPCode_DF (CPU : in out CPU_T) is
   begin
      RST (CPU, 16#18#);
   end OPCode_DF;

   procedure OPCode_E0 (CPU : in out CPU_T) is
   begin
      LDH (CPU, Read_A8 (CPU), A);
   end OPCode_E0;

   procedure OPCode_E1 (CPU : in out CPU_T) is
   begin
      POP (CPU, HL);
   end OPCode_E1;

   procedure OPCode_E2 (CPU : in out CPU_T) is
   begin
      LD (CPU, +C, A);
   end OPCode_E2;

   procedure OPCode_E5 (CPU : in out CPU_T) is
   begin
      PUSH (CPU, HL);
   end OPCode_E5;

   procedure OPCode_E6 (CPU : in out CPU_T) is
   begin
      ANDD (CPU, Read_D8 (CPU));
   end OPCode_E6;

   procedure OPCode_E7 (CPU : in out CPU_T) is
   begin
      RST (CPU, 16#20#);
   end OPCode_E7;

   procedure OPCode_E8 (CPU : in out CPU_T) is
   begin
      ADD (CPU, SP, Read_R8 (CPU));
   end OPCode_E8;

   procedure OPCode_E9 (CPU : in out CPU_T) is
   begin
      JP (CPU, +HL);
   end OPCode_E9;

   procedure OPCode_EA (CPU : in out CPU_T) is
   begin
      LD (CPU, Read_A16 (CPU), A);
   end OPCode_EA;

   procedure OPCode_EE (CPU : in out CPU_T) is
   begin
      XORR (CPU, Read_D8 (CPU));
   end OPCode_EE;

   procedure OPCode_EF (CPU : in out CPU_T) is
   begin
      RST (CPU, 16#28#);
   end OPCode_EF;

   procedure OPCode_F0 (CPU : in out CPU_T) is
   begin
      LDH (CPU, A, Read_A8 (CPU));
   end OPCode_F0;

   procedure OPCode_F1 (CPU : in out CPU_T) is
   begin
      POP (CPU, AF);
   end OPCode_F1;

   procedure OPCode_F2 (CPU : in out CPU_T) is
   begin
      LD (CPU, A, +C);
   end OPCode_F2;

   procedure OPCode_F3 (CPU : in out CPU_T) is
   begin
      DI (CPU);
   end OPCode_F3;

   procedure OPCode_F5 (CPU : in out CPU_T) is
   begin
      PUSH (CPU, AF);
   end OPCode_F5;

   procedure OPCode_F6 (CPU : in out CPU_T) is
   begin
      ORR (CPU, Read_D8 (CPU));
   end OPCode_F6;

   procedure OPCode_F7 (CPU : in out CPU_T) is
   begin
      RST (CPU, 16#30#);
   end OPCode_F7;

   procedure OPCode_F8 (CPU : in out CPU_T) is
   begin
      LDHL (CPU, Read_R8 (CPU));
   end OPCode_F8;

   procedure OPCode_F9 (CPU : in out CPU_T) is
   begin
      LD (CPU, SP, HL);
   end OPCode_F9;

   procedure OPCode_FA (CPU : in out CPU_T) is
   begin
      LD (CPU, A, Read_A16 (CPU));
   end OPCode_FA;

   procedure OPCode_FB (CPU : in out CPU_T) is
   begin
      EI (CPU);
   end OPCode_FB;

   procedure OPCode_FE (CPU : in out CPU_T) is
   begin
      CP (CPU, Read_D8 (CPU));
   end OPCode_FE;

   procedure OPCode_FF (CPU : in out CPU_T) is
   begin
      RST (CPU, 16#38#);
   end OPCode_FF;

   procedure CB_OPCode_00 (CPU : in out CPU_T) is
   begin
      RLC (CPU, B);
   end CB_OPCode_00;

   procedure CB_OPCode_01 (CPU : in out CPU_T) is
   begin
      RLC (CPU, C);
   end CB_OPCode_01;

   procedure CB_OPCode_02 (CPU : in out CPU_T) is
   begin
      RLC (CPU, D);
   end CB_OPCode_02;

   procedure CB_OPCode_03 (CPU : in out CPU_T) is
   begin
      RLC (CPU, E);
   end CB_OPCode_03;

   procedure CB_OPCode_04 (CPU : in out CPU_T) is
   begin
      RLC (CPU, H);
   end CB_OPCode_04;

   procedure CB_OPCode_05 (CPU : in out CPU_T) is
   begin
      RLC (CPU, L);
   end CB_OPCode_05;

   procedure CB_OPCode_06 (CPU : in out CPU_T) is
   begin
      RLC (CPU, +HL);
   end CB_OPCode_06;

   procedure CB_OPCode_07 (CPU : in out CPU_T) is
   begin
      RLC (CPU, A);
   end CB_OPCode_07;

   procedure CB_OPCode_08 (CPU : in out CPU_T) is
   begin
      RRC (CPU, B);
   end CB_OPCode_08;

   procedure CB_OPCode_09 (CPU : in out CPU_T) is
   begin
      RRC (CPU, C);
   end CB_OPCode_09;

   procedure CB_OPCode_0A (CPU : in out CPU_T) is
   begin
      RRC (CPU, D);
   end CB_OPCode_0A;

   procedure CB_OPCode_0B (CPU : in out CPU_T) is
   begin
      RRC (CPU, E);
   end CB_OPCode_0B;

   procedure CB_OPCode_0C (CPU : in out CPU_T) is
   begin
      RRC (CPU, H);
   end CB_OPCode_0C;

   procedure CB_OPCode_0D (CPU : in out CPU_T) is
   begin
      RRC (CPU, L);
   end CB_OPCode_0D;

   procedure CB_OPCode_0E (CPU : in out CPU_T) is
   begin
      RRC (CPU, +HL);
   end CB_OPCode_0E;

   procedure CB_OPCode_0F (CPU : in out CPU_T) is
   begin
      RRC (CPU, A);
   end CB_OPCode_0F;

   procedure CB_OPCode_10 (CPU : in out CPU_T) is
   begin
      RL (CPU, B);
   end CB_OPCode_10;

   procedure CB_OPCode_11 (CPU : in out CPU_T) is
   begin
      RL (CPU, C);
   end CB_OPCode_11;

   procedure CB_OPCode_12 (CPU : in out CPU_T) is
   begin
      RL (CPU, D);
   end CB_OPCode_12;

   procedure CB_OPCode_13 (CPU : in out CPU_T) is
   begin
      RL (CPU, E);
   end CB_OPCode_13;

   procedure CB_OPCode_14 (CPU : in out CPU_T) is
   begin
      RL (CPU, H);
   end CB_OPCode_14;

   procedure CB_OPCode_15 (CPU : in out CPU_T) is
   begin
      RL (CPU, L);
   end CB_OPCode_15;

   procedure CB_OPCode_16 (CPU : in out CPU_T) is
   begin
      RL (CPU, +HL);
   end CB_OPCode_16;

   procedure CB_OPCode_17 (CPU : in out CPU_T) is
   begin
      RL (CPU, A);
   end CB_OPCode_17;

   procedure CB_OPCode_18 (CPU : in out CPU_T) is
   begin
      RR (CPU, B);
   end CB_OPCode_18;

   procedure CB_OPCode_19 (CPU : in out CPU_T) is
   begin
      RR (CPU, C);
   end CB_OPCode_19;

   procedure CB_OPCode_1A (CPU : in out CPU_T) is
   begin
      RR (CPU, D);
   end CB_OPCode_1A;

   procedure CB_OPCode_1B (CPU : in out CPU_T) is
   begin
      RR (CPU, E);
   end CB_OPCode_1B;

   procedure CB_OPCode_1C (CPU : in out CPU_T) is
   begin
      RR (CPU, H);
   end CB_OPCode_1C;

   procedure CB_OPCode_1D (CPU : in out CPU_T) is
   begin
      RR (CPU, L);
   end CB_OPCode_1D;

   procedure CB_OPCode_1E (CPU : in out CPU_T) is
   begin
      RR (CPU, +HL);
   end CB_OPCode_1E;

   procedure CB_OPCode_1F (CPU : in out CPU_T) is
   begin
      RR (CPU, A);
   end CB_OPCode_1F;

   procedure CB_OPCode_20 (CPU : in out CPU_T) is
   begin
      SLA (CPU, B);
   end CB_OPCode_20;

   procedure CB_OPCode_21 (CPU : in out CPU_T) is
   begin
      SLA (CPU, C);
   end CB_OPCode_21;

   procedure CB_OPCode_22 (CPU : in out CPU_T) is
   begin
      SLA (CPU, D);
   end CB_OPCode_22;

   procedure CB_OPCode_23 (CPU : in out CPU_T) is
   begin
      SLA (CPU, E);
   end CB_OPCode_23;

   procedure CB_OPCode_24 (CPU : in out CPU_T) is
   begin
      SLA (CPU, H);
   end CB_OPCode_24;

   procedure CB_OPCode_25 (CPU : in out CPU_T) is
   begin
      SLA (CPU, L);
   end CB_OPCode_25;

   procedure CB_OPCode_26 (CPU : in out CPU_T) is
   begin
      SLA (CPU, +HL);
   end CB_OPCode_26;

   procedure CB_OPCode_27 (CPU : in out CPU_T) is
   begin
      SLA (CPU, A);
   end CB_OPCode_27;

   procedure CB_OPCode_28 (CPU : in out CPU_T) is
   begin
      SRA (CPU, B);
   end CB_OPCode_28;

   procedure CB_OPCode_29 (CPU : in out CPU_T) is
   begin
      SRA (CPU, C);
   end CB_OPCode_29;

   procedure CB_OPCode_2A (CPU : in out CPU_T) is
   begin
      SRA (CPU, D);
   end CB_OPCode_2A;

   procedure CB_OPCode_2B (CPU : in out CPU_T) is
   begin
      SRA (CPU, E);
   end CB_OPCode_2B;

   procedure CB_OPCode_2C (CPU : in out CPU_T) is
   begin
      SRA (CPU, H);
   end CB_OPCode_2C;

   procedure CB_OPCode_2D (CPU : in out CPU_T) is
   begin
      SRA (CPU, L);
   end CB_OPCode_2D;

   procedure CB_OPCode_2E (CPU : in out CPU_T) is
   begin
      SRA (CPU, +HL);
   end CB_OPCode_2E;

   procedure CB_OPCode_2F (CPU : in out CPU_T) is
   begin
      SRA (CPU, A);
   end CB_OPCode_2F;

   procedure CB_OPCode_30 (CPU : in out CPU_T) is
   begin
      SWAP (CPU, B);
   end CB_OPCode_30;

   procedure CB_OPCode_31 (CPU : in out CPU_T) is
   begin
      SWAP (CPU, C);
   end CB_OPCode_31;

   procedure CB_OPCode_32 (CPU : in out CPU_T) is
   begin
      SWAP (CPU, D);
   end CB_OPCode_32;

   procedure CB_OPCode_33 (CPU : in out CPU_T) is
   begin
      SWAP (CPU, E);
   end CB_OPCode_33;

   procedure CB_OPCode_34 (CPU : in out CPU_T) is
   begin
      SWAP (CPU, H);
   end CB_OPCode_34;

   procedure CB_OPCode_35 (CPU : in out CPU_T) is
   begin
      SWAP (CPU, L);
   end CB_OPCode_35;

   procedure CB_OPCode_36 (CPU : in out CPU_T) is
   begin
      SWAP (CPU, +HL);
   end CB_OPCode_36;

   procedure CB_OPCode_37 (CPU : in out CPU_T) is
   begin
      SWAP (CPU, A);
   end CB_OPCode_37;

   procedure CB_OPCode_38 (CPU : in out CPU_T) is
   begin
      SRL (CPU, B);
   end CB_OPCode_38;

   procedure CB_OPCode_39 (CPU : in out CPU_T) is
   begin
      SRL (CPU, C);
   end CB_OPCode_39;

   procedure CB_OPCode_3A (CPU : in out CPU_T) is
   begin
      SRL (CPU, D);
   end CB_OPCode_3A;

   procedure CB_OPCode_3B (CPU : in out CPU_T) is
   begin
      SRL (CPU, E);
   end CB_OPCode_3B;

   procedure CB_OPCode_3C (CPU : in out CPU_T) is
   begin
      SRL (CPU, H);
   end CB_OPCode_3C;

   procedure CB_OPCode_3D (CPU : in out CPU_T) is
   begin
      SRL (CPU, L);
   end CB_OPCode_3D;

   procedure CB_OPCode_3E (CPU : in out CPU_T) is
   begin
      SRL (CPU, +HL);
   end CB_OPCode_3E;

   procedure CB_OPCode_3F (CPU : in out CPU_T) is
   begin
      SRL (CPU, A);
   end CB_OPCode_3F;

   procedure CB_OPCode_40 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 0, B);
   end CB_OPCode_40;

   procedure CB_OPCode_41 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 0, C);
   end CB_OPCode_41;

   procedure CB_OPCode_42 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 0, D);
   end CB_OPCode_42;

   procedure CB_OPCode_43 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 0, E);
   end CB_OPCode_43;

   procedure CB_OPCode_44 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 0, H);
   end CB_OPCode_44;

   procedure CB_OPCode_45 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 0, L);
   end CB_OPCode_45;

   procedure CB_OPCode_46 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 0, +HL);
   end CB_OPCode_46;

   procedure CB_OPCode_47 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 0, A);
   end CB_OPCode_47;

   procedure CB_OPCode_48 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 1, B);
   end CB_OPCode_48;

   procedure CB_OPCode_49 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 1, C);
   end CB_OPCode_49;

   procedure CB_OPCode_4A (CPU : in out CPU_T) is
   begin
      BIT (CPU, 1, D);
   end CB_OPCode_4A;

   procedure CB_OPCode_4B (CPU : in out CPU_T) is
   begin
      BIT (CPU, 1, E);
   end CB_OPCode_4B;

   procedure CB_OPCode_4C (CPU : in out CPU_T) is
   begin
      BIT (CPU, 1, H);
   end CB_OPCode_4C;

   procedure CB_OPCode_4D (CPU : in out CPU_T) is
   begin
      BIT (CPU, 1, L);
   end CB_OPCode_4D;

   procedure CB_OPCode_4E (CPU : in out CPU_T) is
   begin
      BIT (CPU, 1, +HL);
   end CB_OPCode_4E;

   procedure CB_OPCode_4F (CPU : in out CPU_T) is
   begin
      BIT (CPU, 1, A);
   end CB_OPCode_4F;

   procedure CB_OPCode_50 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 2, B);
   end CB_OPCode_50;

   procedure CB_OPCode_51 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 2, C);
   end CB_OPCode_51;

   procedure CB_OPCode_52 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 2, D);
   end CB_OPCode_52;

   procedure CB_OPCode_53 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 2, E);
   end CB_OPCode_53;

   procedure CB_OPCode_54 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 2, H);
   end CB_OPCode_54;

   procedure CB_OPCode_55 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 2, L);
   end CB_OPCode_55;

   procedure CB_OPCode_56 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 2, +HL);
   end CB_OPCode_56;

   procedure CB_OPCode_57 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 2, A);
   end CB_OPCode_57;

   procedure CB_OPCode_58 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 3, B);
   end CB_OPCode_58;

   procedure CB_OPCode_59 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 3, C);
   end CB_OPCode_59;

   procedure CB_OPCode_5A (CPU : in out CPU_T) is
   begin
      BIT (CPU, 3, D);
   end CB_OPCode_5A;

   procedure CB_OPCode_5B (CPU : in out CPU_T) is
   begin
      BIT (CPU, 3, E);
   end CB_OPCode_5B;

   procedure CB_OPCode_5C (CPU : in out CPU_T) is
   begin
      BIT (CPU, 3, H);
   end CB_OPCode_5C;

   procedure CB_OPCode_5D (CPU : in out CPU_T) is
   begin
      BIT (CPU, 3, L);
   end CB_OPCode_5D;

   procedure CB_OPCode_5E (CPU : in out CPU_T) is
   begin
      BIT (CPU, 3, +HL);
   end CB_OPCode_5E;

   procedure CB_OPCode_5F (CPU : in out CPU_T) is
   begin
      BIT (CPU, 3, A);
   end CB_OPCode_5F;

   procedure CB_OPCode_60 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 4, B);
   end CB_OPCode_60;

   procedure CB_OPCode_61 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 4, C);
   end CB_OPCode_61;

   procedure CB_OPCode_62 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 4, D);
   end CB_OPCode_62;

   procedure CB_OPCode_63 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 4, E);
   end CB_OPCode_63;

   procedure CB_OPCode_64 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 4, H);
   end CB_OPCode_64;

   procedure CB_OPCode_65 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 4, L);
   end CB_OPCode_65;

   procedure CB_OPCode_66 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 4, +HL);
   end CB_OPCode_66;

   procedure CB_OPCode_67 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 4, A);
   end CB_OPCode_67;

   procedure CB_OPCode_68 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 5, B);
   end CB_OPCode_68;

   procedure CB_OPCode_69 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 5, C);
   end CB_OPCode_69;

   procedure CB_OPCode_6A (CPU : in out CPU_T) is
   begin
      BIT (CPU, 5, D);
   end CB_OPCode_6A;

   procedure CB_OPCode_6B (CPU : in out CPU_T) is
   begin
      BIT (CPU, 5, E);
   end CB_OPCode_6B;

   procedure CB_OPCode_6C (CPU : in out CPU_T) is
   begin
      BIT (CPU, 5, H);
   end CB_OPCode_6C;

   procedure CB_OPCode_6D (CPU : in out CPU_T) is
   begin
      BIT (CPU, 5, L);
   end CB_OPCode_6D;

   procedure CB_OPCode_6E (CPU : in out CPU_T) is
   begin
      BIT (CPU, 5, +HL);
   end CB_OPCode_6E;

   procedure CB_OPCode_6F (CPU : in out CPU_T) is
   begin
      BIT (CPU, 5, A);
   end CB_OPCode_6F;

   procedure CB_OPCode_70 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 6, B);
   end CB_OPCode_70;

   procedure CB_OPCode_71 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 6, C);
   end CB_OPCode_71;

   procedure CB_OPCode_72 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 6, D);
   end CB_OPCode_72;

   procedure CB_OPCode_73 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 6, E);
   end CB_OPCode_73;

   procedure CB_OPCode_74 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 6, H);
   end CB_OPCode_74;

   procedure CB_OPCode_75 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 6, L);
   end CB_OPCode_75;

   procedure CB_OPCode_76 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 6, +HL);
   end CB_OPCode_76;

   procedure CB_OPCode_77 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 6, A);
   end CB_OPCode_77;

   procedure CB_OPCode_78 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 7, B);
   end CB_OPCode_78;

   procedure CB_OPCode_79 (CPU : in out CPU_T) is
   begin
      BIT (CPU, 7, C);
   end CB_OPCode_79;

   procedure CB_OPCode_7A (CPU : in out CPU_T) is
   begin
      BIT (CPU, 7, D);
   end CB_OPCode_7A;

   procedure CB_OPCode_7B (CPU : in out CPU_T) is
   begin
      BIT (CPU, 7, E);
   end CB_OPCode_7B;

   procedure CB_OPCode_7C (CPU : in out CPU_T) is
   begin
      BIT (CPU, 7, H);
   end CB_OPCode_7C;

   procedure CB_OPCode_7D (CPU : in out CPU_T) is
   begin
      BIT (CPU, 7, L);
   end CB_OPCode_7D;

   procedure CB_OPCode_7E (CPU : in out CPU_T) is
   begin
      BIT (CPU, 7, +HL);
   end CB_OPCode_7E;

   procedure CB_OPCode_7F (CPU : in out CPU_T) is
   begin
      BIT (CPU, 7, A);
   end CB_OPCode_7F;

   procedure CB_OPCode_80 (CPU : in out CPU_T) is
   begin
      RES (CPU, 0, B);
   end CB_OPCode_80;

   procedure CB_OPCode_81 (CPU : in out CPU_T) is
   begin
      RES (CPU, 0, C);
   end CB_OPCode_81;

   procedure CB_OPCode_82 (CPU : in out CPU_T) is
   begin
      RES (CPU, 0, D);
   end CB_OPCode_82;

   procedure CB_OPCode_83 (CPU : in out CPU_T) is
   begin
      RES (CPU, 0, E);
   end CB_OPCode_83;

   procedure CB_OPCode_84 (CPU : in out CPU_T) is
   begin
      RES (CPU, 0, H);
   end CB_OPCode_84;

   procedure CB_OPCode_85 (CPU : in out CPU_T) is
   begin
      RES (CPU, 0, L);
   end CB_OPCode_85;

   procedure CB_OPCode_86 (CPU : in out CPU_T) is
   begin
      RES (CPU, 0, +HL);
   end CB_OPCode_86;

   procedure CB_OPCode_87 (CPU : in out CPU_T) is
   begin
      RES (CPU, 0, A);
   end CB_OPCode_87;

   procedure CB_OPCode_88 (CPU : in out CPU_T) is
   begin
      RES (CPU, 1, B);
   end CB_OPCode_88;

   procedure CB_OPCode_89 (CPU : in out CPU_T) is
   begin
      RES (CPU, 1, C);
   end CB_OPCode_89;

   procedure CB_OPCode_8A (CPU : in out CPU_T) is
   begin
      RES (CPU, 1, D);
   end CB_OPCode_8A;

   procedure CB_OPCode_8B (CPU : in out CPU_T) is
   begin
      RES (CPU, 1, E);
   end CB_OPCode_8B;

   procedure CB_OPCode_8C (CPU : in out CPU_T) is
   begin
      RES (CPU, 1, H);
   end CB_OPCode_8C;

   procedure CB_OPCode_8D (CPU : in out CPU_T) is
   begin
      RES (CPU, 1, L);
   end CB_OPCode_8D;

   procedure CB_OPCode_8E (CPU : in out CPU_T) is
   begin
      RES (CPU, 1, +HL);
   end CB_OPCode_8E;

   procedure CB_OPCode_8F (CPU : in out CPU_T) is
   begin
      RES (CPU, 1, A);
   end CB_OPCode_8F;

   procedure CB_OPCode_90 (CPU : in out CPU_T) is
   begin
      RES (CPU, 2, B);
   end CB_OPCode_90;

   procedure CB_OPCode_91 (CPU : in out CPU_T) is
   begin
      RES (CPU, 2, C);
   end CB_OPCode_91;

   procedure CB_OPCode_92 (CPU : in out CPU_T) is
   begin
      RES (CPU, 2, D);
   end CB_OPCode_92;

   procedure CB_OPCode_93 (CPU : in out CPU_T) is
   begin
      RES (CPU, 2, E);
   end CB_OPCode_93;

   procedure CB_OPCode_94 (CPU : in out CPU_T) is
   begin
      RES (CPU, 2, H);
   end CB_OPCode_94;

   procedure CB_OPCode_95 (CPU : in out CPU_T) is
   begin
      RES (CPU, 2, L);
   end CB_OPCode_95;

   procedure CB_OPCode_96 (CPU : in out CPU_T) is
   begin
      RES (CPU, 2, +HL);
   end CB_OPCode_96;

   procedure CB_OPCode_97 (CPU : in out CPU_T) is
   begin
      RES (CPU, 2, A);
   end CB_OPCode_97;

   procedure CB_OPCode_98 (CPU : in out CPU_T) is
   begin
      RES (CPU, 3, B);
   end CB_OPCode_98;

   procedure CB_OPCode_99 (CPU : in out CPU_T) is
   begin
      RES (CPU, 3, C);
   end CB_OPCode_99;

   procedure CB_OPCode_9A (CPU : in out CPU_T) is
   begin
      RES (CPU, 3, D);
   end CB_OPCode_9A;

   procedure CB_OPCode_9B (CPU : in out CPU_T) is
   begin
      RES (CPU, 3, E);
   end CB_OPCode_9B;

   procedure CB_OPCode_9C (CPU : in out CPU_T) is
   begin
      RES (CPU, 3, H);
   end CB_OPCode_9C;

   procedure CB_OPCode_9D (CPU : in out CPU_T) is
   begin
      RES (CPU, 3, L);
   end CB_OPCode_9D;

   procedure CB_OPCode_9E (CPU : in out CPU_T) is
   begin
      RES (CPU, 3, +HL);
   end CB_OPCode_9E;

   procedure CB_OPCode_9F (CPU : in out CPU_T) is
   begin
      RES (CPU, 3, A);
   end CB_OPCode_9F;

   procedure CB_OPCode_A0 (CPU : in out CPU_T) is
   begin
      RES (CPU, 4, B);
   end CB_OPCode_A0;

   procedure CB_OPCode_A1 (CPU : in out CPU_T) is
   begin
      RES (CPU, 4, C);
   end CB_OPCode_A1;

   procedure CB_OPCode_A2 (CPU : in out CPU_T) is
   begin
      RES (CPU, 4, D);
   end CB_OPCode_A2;

   procedure CB_OPCode_A3 (CPU : in out CPU_T) is
   begin
      RES (CPU, 4, E);
   end CB_OPCode_A3;

   procedure CB_OPCode_A4 (CPU : in out CPU_T) is
   begin
      RES (CPU, 4, H);
   end CB_OPCode_A4;

   procedure CB_OPCode_A5 (CPU : in out CPU_T) is
   begin
      RES (CPU, 4, L);
   end CB_OPCode_A5;

   procedure CB_OPCode_A6 (CPU : in out CPU_T) is
   begin
      RES (CPU, 4, +HL);
   end CB_OPCode_A6;

   procedure CB_OPCode_A7 (CPU : in out CPU_T) is
   begin
      RES (CPU, 4, A);
   end CB_OPCode_A7;

   procedure CB_OPCode_A8 (CPU : in out CPU_T) is
   begin
      RES (CPU, 5, B);
   end CB_OPCode_A8;

   procedure CB_OPCode_A9 (CPU : in out CPU_T) is
   begin
      RES (CPU, 5, C);
   end CB_OPCode_A9;

   procedure CB_OPCode_AA (CPU : in out CPU_T) is
   begin
      RES (CPU, 5, D);
   end CB_OPCode_AA;

   procedure CB_OPCode_AB (CPU : in out CPU_T) is
   begin
      RES (CPU, 5, E);
   end CB_OPCode_AB;

   procedure CB_OPCode_AC (CPU : in out CPU_T) is
   begin
      RES (CPU, 5, H);
   end CB_OPCode_AC;

   procedure CB_OPCode_AD (CPU : in out CPU_T) is
   begin
      RES (CPU, 5, L);
   end CB_OPCode_AD;

   procedure CB_OPCode_AE (CPU : in out CPU_T) is
   begin
      RES (CPU, 5, +HL);
   end CB_OPCode_AE;

   procedure CB_OPCode_AF (CPU : in out CPU_T) is
   begin
      RES (CPU, 5, A);
   end CB_OPCode_AF;

   procedure CB_OPCode_B0 (CPU : in out CPU_T) is
   begin
      RES (CPU, 6, B);
   end CB_OPCode_B0;

   procedure CB_OPCode_B1 (CPU : in out CPU_T) is
   begin
      RES (CPU, 6, C);
   end CB_OPCode_B1;

   procedure CB_OPCode_B2 (CPU : in out CPU_T) is
   begin
      RES (CPU, 6, D);
   end CB_OPCode_B2;

   procedure CB_OPCode_B3 (CPU : in out CPU_T) is
   begin
      RES (CPU, 6, E);
   end CB_OPCode_B3;

   procedure CB_OPCode_B4 (CPU : in out CPU_T) is
   begin
      RES (CPU, 6, H);
   end CB_OPCode_B4;

   procedure CB_OPCode_B5 (CPU : in out CPU_T) is
   begin
      RES (CPU, 6, L);
   end CB_OPCode_B5;

   procedure CB_OPCode_B6 (CPU : in out CPU_T) is
   begin
      RES (CPU, 6, +HL);
   end CB_OPCode_B6;

   procedure CB_OPCode_B7 (CPU : in out CPU_T) is
   begin
      RES (CPU, 6, A);
   end CB_OPCode_B7;

   procedure CB_OPCode_B8 (CPU : in out CPU_T) is
   begin
      RES (CPU, 7, B);
   end CB_OPCode_B8;

   procedure CB_OPCode_B9 (CPU : in out CPU_T) is
   begin
      RES (CPU, 7, C);
   end CB_OPCode_B9;

   procedure CB_OPCode_BA (CPU : in out CPU_T) is
   begin
      RES (CPU, 7, D);
   end CB_OPCode_BA;

   procedure CB_OPCode_BB (CPU : in out CPU_T) is
   begin
      RES (CPU, 7, E);
   end CB_OPCode_BB;

   procedure CB_OPCode_BC (CPU : in out CPU_T) is
   begin
      RES (CPU, 7, H);
   end CB_OPCode_BC;

   procedure CB_OPCode_BD (CPU : in out CPU_T) is
   begin
      RES (CPU, 7, L);
   end CB_OPCode_BD;

   procedure CB_OPCode_BE (CPU : in out CPU_T) is
   begin
      RES (CPU, 7, +HL);
   end CB_OPCode_BE;

   procedure CB_OPCode_BF (CPU : in out CPU_T) is
   begin
      RES (CPU, 7, A);
   end CB_OPCode_BF;

   procedure CB_OPCode_C0 (CPU : in out CPU_T) is
   begin
      SET (CPU, 0, B);
   end CB_OPCode_C0;

   procedure CB_OPCode_C1 (CPU : in out CPU_T) is
   begin
      SET (CPU, 0, C);
   end CB_OPCode_C1;

   procedure CB_OPCode_C2 (CPU : in out CPU_T) is
   begin
      SET (CPU, 0, D);
   end CB_OPCode_C2;

   procedure CB_OPCode_C3 (CPU : in out CPU_T) is
   begin
      SET (CPU, 0, E);
   end CB_OPCode_C3;

   procedure CB_OPCode_C4 (CPU : in out CPU_T) is
   begin
      SET (CPU, 0, H);
   end CB_OPCode_C4;

   procedure CB_OPCode_C5 (CPU : in out CPU_T) is
   begin
      SET (CPU, 0, L);
   end CB_OPCode_C5;

   procedure CB_OPCode_C6 (CPU : in out CPU_T) is
   begin
      SET (CPU, 0, +HL);
   end CB_OPCode_C6;

   procedure CB_OPCode_C7 (CPU : in out CPU_T) is
   begin
      SET (CPU, 0, A);
   end CB_OPCode_C7;

   procedure CB_OPCode_C8 (CPU : in out CPU_T) is
   begin
      SET (CPU, 1, B);
   end CB_OPCode_C8;

   procedure CB_OPCode_C9 (CPU : in out CPU_T) is
   begin
      SET (CPU, 1, C);
   end CB_OPCode_C9;

   procedure CB_OPCode_CA (CPU : in out CPU_T) is
   begin
      SET (CPU, 1, D);
   end CB_OPCode_CA;

   procedure CB_OPCode_CB (CPU : in out CPU_T) is
   begin
      SET (CPU, 1, E);
   end CB_OPCode_CB;

   procedure CB_OPCode_CC (CPU : in out CPU_T) is
   begin
      SET (CPU, 1, H);
   end CB_OPCode_CC;

   procedure CB_OPCode_CD (CPU : in out CPU_T) is
   begin
      SET (CPU, 1, L);
   end CB_OPCode_CD;

   procedure CB_OPCode_CE (CPU : in out CPU_T) is
   begin
      SET (CPU, 1, +HL);
   end CB_OPCode_CE;

   procedure CB_OPCode_CF (CPU : in out CPU_T) is
   begin
      SET (CPU, 1, A);
   end CB_OPCode_CF;

   procedure CB_OPCode_D0 (CPU : in out CPU_T) is
   begin
      SET (CPU, 2, B);
   end CB_OPCode_D0;

   procedure CB_OPCode_D1 (CPU : in out CPU_T) is
   begin
      SET (CPU, 2, C);
   end CB_OPCode_D1;

   procedure CB_OPCode_D2 (CPU : in out CPU_T) is
   begin
      SET (CPU, 2, D);
   end CB_OPCode_D2;

   procedure CB_OPCode_D3 (CPU : in out CPU_T) is
   begin
      SET (CPU, 2, E);
   end CB_OPCode_D3;

   procedure CB_OPCode_D4 (CPU : in out CPU_T) is
   begin
      SET (CPU, 2, H);
   end CB_OPCode_D4;

   procedure CB_OPCode_D5 (CPU : in out CPU_T) is
   begin
      SET (CPU, 2, L);
   end CB_OPCode_D5;

   procedure CB_OPCode_D6 (CPU : in out CPU_T) is
   begin
      SET (CPU, 2, +HL);
   end CB_OPCode_D6;

   procedure CB_OPCode_D7 (CPU : in out CPU_T) is
   begin
      SET (CPU, 2, A);
   end CB_OPCode_D7;

   procedure CB_OPCode_D8 (CPU : in out CPU_T) is
   begin
      SET (CPU, 3, B);
   end CB_OPCode_D8;

   procedure CB_OPCode_D9 (CPU : in out CPU_T) is
   begin
      SET (CPU, 3, C);
   end CB_OPCode_D9;

   procedure CB_OPCode_DA (CPU : in out CPU_T) is
   begin
      SET (CPU, 3, D);
   end CB_OPCode_DA;

   procedure CB_OPCode_DB (CPU : in out CPU_T) is
   begin
      SET (CPU, 3, E);
   end CB_OPCode_DB;

   procedure CB_OPCode_DC (CPU : in out CPU_T) is
   begin
      SET (CPU, 3, H);
   end CB_OPCode_DC;

   procedure CB_OPCode_DD (CPU : in out CPU_T) is
   begin
      SET (CPU, 3, L);
   end CB_OPCode_DD;

   procedure CB_OPCode_DE (CPU : in out CPU_T) is
   begin
      SET (CPU, 3, +HL);
   end CB_OPCode_DE;

   procedure CB_OPCode_DF (CPU : in out CPU_T) is
   begin
      SET (CPU, 3, A);
   end CB_OPCode_DF;

   procedure CB_OPCode_E0 (CPU : in out CPU_T) is
   begin
      SET (CPU, 4, B);
   end CB_OPCode_E0;

   procedure CB_OPCode_E1 (CPU : in out CPU_T) is
   begin
      SET (CPU, 4, C);
   end CB_OPCode_E1;

   procedure CB_OPCode_E2 (CPU : in out CPU_T) is
   begin
      SET (CPU, 4, D);
   end CB_OPCode_E2;

   procedure CB_OPCode_E3 (CPU : in out CPU_T) is
   begin
      SET (CPU, 4, E);
   end CB_OPCode_E3;

   procedure CB_OPCode_E4 (CPU : in out CPU_T) is
   begin
      SET (CPU, 4, H);
   end CB_OPCode_E4;

   procedure CB_OPCode_E5 (CPU : in out CPU_T) is
   begin
      SET (CPU, 4, L);
   end CB_OPCode_E5;

   procedure CB_OPCode_E6 (CPU : in out CPU_T) is
   begin
      SET (CPU, 4, +HL);
   end CB_OPCode_E6;

   procedure CB_OPCode_E7 (CPU : in out CPU_T) is
   begin
      SET (CPU, 4, A);
   end CB_OPCode_E7;

   procedure CB_OPCode_E8 (CPU : in out CPU_T) is
   begin
      SET (CPU, 5, B);
   end CB_OPCode_E8;

   procedure CB_OPCode_E9 (CPU : in out CPU_T) is
   begin
      SET (CPU, 5, C);
   end CB_OPCode_E9;

   procedure CB_OPCode_EA (CPU : in out CPU_T) is
   begin
      SET (CPU, 5, D);
   end CB_OPCode_EA;

   procedure CB_OPCode_EB (CPU : in out CPU_T) is
   begin
      SET (CPU, 5, E);
   end CB_OPCode_EB;

   procedure CB_OPCode_EC (CPU : in out CPU_T) is
   begin
      SET (CPU, 5, H);
   end CB_OPCode_EC;

   procedure CB_OPCode_ED (CPU : in out CPU_T) is
   begin
      SET (CPU, 5, L);
   end CB_OPCode_ED;

   procedure CB_OPCode_EE (CPU : in out CPU_T) is
   begin
      SET (CPU, 5, +HL);
   end CB_OPCode_EE;

   procedure CB_OPCode_EF (CPU : in out CPU_T) is
   begin
      SET (CPU, 5, A);
   end CB_OPCode_EF;

   procedure CB_OPCode_F0 (CPU : in out CPU_T) is
   begin
      SET (CPU, 6, B);
   end CB_OPCode_F0;

   procedure CB_OPCode_F1 (CPU : in out CPU_T) is
   begin
      SET (CPU, 6, C);
   end CB_OPCode_F1;

   procedure CB_OPCode_F2 (CPU : in out CPU_T) is
   begin
      SET (CPU, 6, D);
   end CB_OPCode_F2;

   procedure CB_OPCode_F3 (CPU : in out CPU_T) is
   begin
      SET (CPU, 6, E);
   end CB_OPCode_F3;

   procedure CB_OPCode_F4 (CPU : in out CPU_T) is
   begin
      SET (CPU, 6, H);
   end CB_OPCode_F4;

   procedure CB_OPCode_F5 (CPU : in out CPU_T) is
   begin
      SET (CPU, 6, L);
   end CB_OPCode_F5;

   procedure CB_OPCode_F6 (CPU : in out CPU_T) is
   begin
      SET (CPU, 6, +HL);
   end CB_OPCode_F6;

   procedure CB_OPCode_F7 (CPU : in out CPU_T) is
   begin
      SET (CPU, 6, A);
   end CB_OPCode_F7;

   procedure CB_OPCode_F8 (CPU : in out CPU_T) is
   begin
      SET (CPU, 7, B);
   end CB_OPCode_F8;

   procedure CB_OPCode_F9 (CPU : in out CPU_T) is
   begin
      SET (CPU, 7, C);
   end CB_OPCode_F9;

   procedure CB_OPCode_FA (CPU : in out CPU_T) is
   begin
      SET (CPU, 7, D);
   end CB_OPCode_FA;

   procedure CB_OPCode_FB (CPU : in out CPU_T) is
   begin
      SET (CPU, 7, E);
   end CB_OPCode_FB;

   procedure CB_OPCode_FC (CPU : in out CPU_T) is
   begin
      SET (CPU, 7, H);
   end CB_OPCode_FC;

   procedure CB_OPCode_FD (CPU : in out CPU_T) is
   begin
      SET (CPU, 7, L);
   end CB_OPCode_FD;

   procedure CB_OPCode_FE (CPU : in out CPU_T) is
   begin
      SET (CPU, 7, +HL);
   end CB_OPCode_FE;

   procedure CB_OPCode_FF (CPU : in out CPU_T) is
   begin
      SET (CPU, 7, A);
   end CB_OPCode_FF;
end OPCodes;
