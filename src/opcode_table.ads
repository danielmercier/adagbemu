with HAL; use HAL;
with CPU; use CPU;
with OPCodes; use OPCodes;

package OPCode_Table is
   type Instruction_T is access procedure (CPU : in out CPU_T);

   type Cycles_Rec (Branch : Boolean) is record
      case Branch is
         when True =>
            Taken : Clock_T;
            Not_Taken : Clock_T;
         when False =>
            Value : Clock_T;
      end case;
   end record;

   type Cycles_T is access Cycles_Rec;

   type Instruction_Info_T is record
      Cycles : Cycles_T;
      Instruction : Instruction_T;
   end record;

   type Table_T is array (OPCode_T) of Instruction_Info_T;

   Unprefixed : constant Table_T :=
      [16#00# => (new Cycles_Rec'(False, 4000), OPCode_00'Access),
       16#01# => (new Cycles_Rec'(False, 12), OPCode_01'Access),
       16#02# => (new Cycles_Rec'(False, 8), OPCode_02'Access),
       16#03# => (new Cycles_Rec'(False, 8), OPCode_03'Access),
       16#04# => (new Cycles_Rec'(False, 4), OPCode_04'Access),
       16#05# => (new Cycles_Rec'(False, 4), OPCode_05'Access),
       16#06# => (new Cycles_Rec'(False, 8), OPCode_06'Access),
       16#07# => (new Cycles_Rec'(False, 4), OPCode_07'Access),
       16#08# => (new Cycles_Rec'(False, 20), OPCode_08'Access),
       16#09# => (new Cycles_Rec'(False, 8), OPCode_09'Access),
       16#0A# => (new Cycles_Rec'(False, 8), OPCode_0A'Access),
       16#0B# => (new Cycles_Rec'(False, 8), OPCode_0B'Access),
       16#0C# => (new Cycles_Rec'(False, 4), OPCode_0C'Access),
       16#0D# => (new Cycles_Rec'(False, 4), OPCode_0D'Access),
       16#0E# => (new Cycles_Rec'(False, 8), OPCode_0E'Access),
       16#0F# => (new Cycles_Rec'(False, 4), OPCode_0F'Access),
       16#10# => (new Cycles_Rec'(False, 4), OPCode_10'Access),
       16#11# => (new Cycles_Rec'(False, 12), OPCode_11'Access),
       16#12# => (new Cycles_Rec'(False, 8), OPCode_12'Access),
       16#13# => (new Cycles_Rec'(False, 8), OPCode_13'Access),
       16#14# => (new Cycles_Rec'(False, 4), OPCode_14'Access),
       16#15# => (new Cycles_Rec'(False, 4), OPCode_15'Access),
       16#16# => (new Cycles_Rec'(False, 8), OPCode_16'Access),
       16#17# => (new Cycles_Rec'(False, 4), OPCode_17'Access),
       16#18# => (new Cycles_Rec'(False, 12), OPCode_18'Access),
       16#19# => (new Cycles_Rec'(False, 8), OPCode_19'Access),
       16#1A# => (new Cycles_Rec'(False, 8), OPCode_1A'Access),
       16#1B# => (new Cycles_Rec'(False, 8), OPCode_1B'Access),
       16#1C# => (new Cycles_Rec'(False, 4), OPCode_1C'Access),
       16#1D# => (new Cycles_Rec'(False, 4), OPCode_1D'Access),
       16#1E# => (new Cycles_Rec'(False, 8), OPCode_1E'Access),
       16#1F# => (new Cycles_Rec'(False, 4), OPCode_1F'Access),
       16#20# => (new Cycles_Rec'(True, 12, 8), OPCode_20'Access),
       16#21# => (new Cycles_Rec'(False, 12), OPCode_21'Access),
       16#22# => (new Cycles_Rec'(False, 8), OPCode_22'Access),
       16#23# => (new Cycles_Rec'(False, 8), OPCode_23'Access),
       16#24# => (new Cycles_Rec'(False, 4), OPCode_24'Access),
       16#25# => (new Cycles_Rec'(False, 4), OPCode_25'Access),
       16#26# => (new Cycles_Rec'(False, 8), OPCode_26'Access),
       16#27# => (new Cycles_Rec'(False, 4), OPCode_27'Access),
       16#28# => (new Cycles_Rec'(True, 12, 8), OPCode_28'Access),
       16#29# => (new Cycles_Rec'(False, 8), OPCode_29'Access),
       16#2A# => (new Cycles_Rec'(False, 8), OPCode_2A'Access),
       16#2B# => (new Cycles_Rec'(False, 8), OPCode_2B'Access),
       16#2C# => (new Cycles_Rec'(False, 4), OPCode_2C'Access),
       16#2D# => (new Cycles_Rec'(False, 4), OPCode_2D'Access),
       16#2E# => (new Cycles_Rec'(False, 8), OPCode_2E'Access),
       16#2F# => (new Cycles_Rec'(False, 4), OPCode_2F'Access),
       16#30# => (new Cycles_Rec'(True, 12, 8), OPCode_30'Access),
       16#31# => (new Cycles_Rec'(False, 12), OPCode_31'Access),
       16#32# => (new Cycles_Rec'(False, 8), OPCode_32'Access),
       16#33# => (new Cycles_Rec'(False, 8), OPCode_33'Access),
       16#34# => (new Cycles_Rec'(False, 12), OPCode_34'Access),
       16#35# => (new Cycles_Rec'(False, 12), OPCode_35'Access),
       16#36# => (new Cycles_Rec'(False, 12), OPCode_36'Access),
       16#37# => (new Cycles_Rec'(False, 4), OPCode_37'Access),
       16#38# => (new Cycles_Rec'(True, 12, 8), OPCode_38'Access),
       16#39# => (new Cycles_Rec'(False, 8), OPCode_39'Access),
       16#3A# => (new Cycles_Rec'(False, 8), OPCode_3A'Access),
       16#3B# => (new Cycles_Rec'(False, 8), OPCode_3B'Access),
       16#3C# => (new Cycles_Rec'(False, 4), OPCode_3C'Access),
       16#3D# => (new Cycles_Rec'(False, 4), OPCode_3D'Access),
       16#3E# => (new Cycles_Rec'(False, 8), OPCode_3E'Access),
       16#3F# => (new Cycles_Rec'(False, 4), OPCode_3F'Access),
       16#40# => (new Cycles_Rec'(False, 4), OPCode_40'Access),
       16#41# => (new Cycles_Rec'(False, 4), OPCode_41'Access),
       16#42# => (new Cycles_Rec'(False, 4), OPCode_42'Access),
       16#43# => (new Cycles_Rec'(False, 4), OPCode_43'Access),
       16#44# => (new Cycles_Rec'(False, 4), OPCode_44'Access),
       16#45# => (new Cycles_Rec'(False, 4), OPCode_45'Access),
       16#46# => (new Cycles_Rec'(False, 8), OPCode_46'Access),
       16#47# => (new Cycles_Rec'(False, 4), OPCode_47'Access),
       16#48# => (new Cycles_Rec'(False, 4), OPCode_48'Access),
       16#49# => (new Cycles_Rec'(False, 4), OPCode_49'Access),
       16#4A# => (new Cycles_Rec'(False, 4), OPCode_4A'Access),
       16#4B# => (new Cycles_Rec'(False, 4), OPCode_4B'Access),
       16#4C# => (new Cycles_Rec'(False, 4), OPCode_4C'Access),
       16#4D# => (new Cycles_Rec'(False, 4), OPCode_4D'Access),
       16#4E# => (new Cycles_Rec'(False, 8), OPCode_4E'Access),
       16#4F# => (new Cycles_Rec'(False, 4), OPCode_4F'Access),
       16#50# => (new Cycles_Rec'(False, 4), OPCode_50'Access),
       16#51# => (new Cycles_Rec'(False, 4), OPCode_51'Access),
       16#52# => (new Cycles_Rec'(False, 4), OPCode_52'Access),
       16#53# => (new Cycles_Rec'(False, 4), OPCode_53'Access),
       16#54# => (new Cycles_Rec'(False, 4), OPCode_54'Access),
       16#55# => (new Cycles_Rec'(False, 4), OPCode_55'Access),
       16#56# => (new Cycles_Rec'(False, 8), OPCode_56'Access),
       16#57# => (new Cycles_Rec'(False, 4), OPCode_57'Access),
       16#58# => (new Cycles_Rec'(False, 4), OPCode_58'Access),
       16#59# => (new Cycles_Rec'(False, 4), OPCode_59'Access),
       16#5A# => (new Cycles_Rec'(False, 4), OPCode_5A'Access),
       16#5B# => (new Cycles_Rec'(False, 4), OPCode_5B'Access),
       16#5C# => (new Cycles_Rec'(False, 4), OPCode_5C'Access),
       16#5D# => (new Cycles_Rec'(False, 4), OPCode_5D'Access),
       16#5E# => (new Cycles_Rec'(False, 8), OPCode_5E'Access),
       16#5F# => (new Cycles_Rec'(False, 4), OPCode_5F'Access),
       16#60# => (new Cycles_Rec'(False, 4), OPCode_60'Access),
       16#61# => (new Cycles_Rec'(False, 4), OPCode_61'Access),
       16#62# => (new Cycles_Rec'(False, 4), OPCode_62'Access),
       16#63# => (new Cycles_Rec'(False, 4), OPCode_63'Access),
       16#64# => (new Cycles_Rec'(False, 4), OPCode_64'Access),
       16#65# => (new Cycles_Rec'(False, 4), OPCode_65'Access),
       16#66# => (new Cycles_Rec'(False, 8), OPCode_66'Access),
       16#67# => (new Cycles_Rec'(False, 4), OPCode_67'Access),
       16#68# => (new Cycles_Rec'(False, 4), OPCode_68'Access),
       16#69# => (new Cycles_Rec'(False, 4), OPCode_69'Access),
       16#6A# => (new Cycles_Rec'(False, 4), OPCode_6A'Access),
       16#6B# => (new Cycles_Rec'(False, 4), OPCode_6B'Access),
       16#6C# => (new Cycles_Rec'(False, 4), OPCode_6C'Access),
       16#6D# => (new Cycles_Rec'(False, 4), OPCode_6D'Access),
       16#6E# => (new Cycles_Rec'(False, 8), OPCode_6E'Access),
       16#6F# => (new Cycles_Rec'(False, 4), OPCode_6F'Access),
       16#70# => (new Cycles_Rec'(False, 8), OPCode_70'Access),
       16#71# => (new Cycles_Rec'(False, 8), OPCode_71'Access),
       16#72# => (new Cycles_Rec'(False, 8), OPCode_72'Access),
       16#73# => (new Cycles_Rec'(False, 8), OPCode_73'Access),
       16#74# => (new Cycles_Rec'(False, 8), OPCode_74'Access),
       16#75# => (new Cycles_Rec'(False, 8), OPCode_75'Access),
       16#76# => (new Cycles_Rec'(False, 4), OPCode_76'Access),
       16#77# => (new Cycles_Rec'(False, 8), OPCode_77'Access),
       16#78# => (new Cycles_Rec'(False, 4), OPCode_78'Access),
       16#79# => (new Cycles_Rec'(False, 4), OPCode_79'Access),
       16#7A# => (new Cycles_Rec'(False, 4), OPCode_7A'Access),
       16#7B# => (new Cycles_Rec'(False, 4), OPCode_7B'Access),
       16#7C# => (new Cycles_Rec'(False, 4), OPCode_7C'Access),
       16#7D# => (new Cycles_Rec'(False, 4), OPCode_7D'Access),
       16#7E# => (new Cycles_Rec'(False, 8), OPCode_7E'Access),
       16#7F# => (new Cycles_Rec'(False, 4), OPCode_7F'Access),
       16#80# => (new Cycles_Rec'(False, 4), OPCode_80'Access),
       16#81# => (new Cycles_Rec'(False, 4), OPCode_81'Access),
       16#82# => (new Cycles_Rec'(False, 4), OPCode_82'Access),
       16#83# => (new Cycles_Rec'(False, 4), OPCode_83'Access),
       16#84# => (new Cycles_Rec'(False, 4), OPCode_84'Access),
       16#85# => (new Cycles_Rec'(False, 4), OPCode_85'Access),
       16#86# => (new Cycles_Rec'(False, 8), OPCode_86'Access),
       16#87# => (new Cycles_Rec'(False, 4), OPCode_87'Access),
       16#88# => (new Cycles_Rec'(False, 4), OPCode_88'Access),
       16#89# => (new Cycles_Rec'(False, 4), OPCode_89'Access),
       16#8A# => (new Cycles_Rec'(False, 4), OPCode_8A'Access),
       16#8B# => (new Cycles_Rec'(False, 4), OPCode_8B'Access),
       16#8C# => (new Cycles_Rec'(False, 4), OPCode_8C'Access),
       16#8D# => (new Cycles_Rec'(False, 4), OPCode_8D'Access),
       16#8E# => (new Cycles_Rec'(False, 8), OPCode_8E'Access),
       16#8F# => (new Cycles_Rec'(False, 4), OPCode_8F'Access),
       16#90# => (new Cycles_Rec'(False, 4), OPCode_90'Access),
       16#91# => (new Cycles_Rec'(False, 4), OPCode_91'Access),
       16#92# => (new Cycles_Rec'(False, 4), OPCode_92'Access),
       16#93# => (new Cycles_Rec'(False, 4), OPCode_93'Access),
       16#94# => (new Cycles_Rec'(False, 4), OPCode_94'Access),
       16#95# => (new Cycles_Rec'(False, 4), OPCode_95'Access),
       16#96# => (new Cycles_Rec'(False, 8), OPCode_96'Access),
       16#97# => (new Cycles_Rec'(False, 4), OPCode_97'Access),
       16#98# => (new Cycles_Rec'(False, 4), OPCode_98'Access),
       16#99# => (new Cycles_Rec'(False, 4), OPCode_99'Access),
       16#9A# => (new Cycles_Rec'(False, 4), OPCode_9A'Access),
       16#9B# => (new Cycles_Rec'(False, 4), OPCode_9B'Access),
       16#9C# => (new Cycles_Rec'(False, 4), OPCode_9C'Access),
       16#9D# => (new Cycles_Rec'(False, 4), OPCode_9D'Access),
       16#9E# => (new Cycles_Rec'(False, 8), OPCode_9E'Access),
       16#9F# => (new Cycles_Rec'(False, 4), OPCode_9F'Access),
       16#A0# => (new Cycles_Rec'(False, 4), OPCode_A0'Access),
       16#A1# => (new Cycles_Rec'(False, 4), OPCode_A1'Access),
       16#A2# => (new Cycles_Rec'(False, 4), OPCode_A2'Access),
       16#A3# => (new Cycles_Rec'(False, 4), OPCode_A3'Access),
       16#A4# => (new Cycles_Rec'(False, 4), OPCode_A4'Access),
       16#A5# => (new Cycles_Rec'(False, 4), OPCode_A5'Access),
       16#A6# => (new Cycles_Rec'(False, 8), OPCode_A6'Access),
       16#A7# => (new Cycles_Rec'(False, 4), OPCode_A7'Access),
       16#A8# => (new Cycles_Rec'(False, 4), OPCode_A8'Access),
       16#A9# => (new Cycles_Rec'(False, 4), OPCode_A9'Access),
       16#AA# => (new Cycles_Rec'(False, 4), OPCode_AA'Access),
       16#AB# => (new Cycles_Rec'(False, 4), OPCode_AB'Access),
       16#AC# => (new Cycles_Rec'(False, 4), OPCode_AC'Access),
       16#AD# => (new Cycles_Rec'(False, 4), OPCode_AD'Access),
       16#AE# => (new Cycles_Rec'(False, 8), OPCode_AE'Access),
       16#AF# => (new Cycles_Rec'(False, 4), OPCode_AF'Access),
       16#B0# => (new Cycles_Rec'(False, 4), OPCode_B0'Access),
       16#B1# => (new Cycles_Rec'(False, 4), OPCode_B1'Access),
       16#B2# => (new Cycles_Rec'(False, 4), OPCode_B2'Access),
       16#B3# => (new Cycles_Rec'(False, 4), OPCode_B3'Access),
       16#B4# => (new Cycles_Rec'(False, 4), OPCode_B4'Access),
       16#B5# => (new Cycles_Rec'(False, 4), OPCode_B5'Access),
       16#B6# => (new Cycles_Rec'(False, 8), OPCode_B6'Access),
       16#B7# => (new Cycles_Rec'(False, 4), OPCode_B7'Access),
       16#B8# => (new Cycles_Rec'(False, 4), OPCode_B8'Access),
       16#B9# => (new Cycles_Rec'(False, 4), OPCode_B9'Access),
       16#BA# => (new Cycles_Rec'(False, 4), OPCode_BA'Access),
       16#BB# => (new Cycles_Rec'(False, 4), OPCode_BB'Access),
       16#BC# => (new Cycles_Rec'(False, 4), OPCode_BC'Access),
       16#BD# => (new Cycles_Rec'(False, 4), OPCode_BD'Access),
       16#BE# => (new Cycles_Rec'(False, 8), OPCode_BE'Access),
       16#BF# => (new Cycles_Rec'(False, 4), OPCode_BF'Access),
       16#C0# => (new Cycles_Rec'(True, 20, 8), OPCode_C0'Access),
       16#C1# => (new Cycles_Rec'(False, 12), OPCode_C1'Access),
       16#C2# => (new Cycles_Rec'(True, 16, 12), OPCode_C2'Access),
       16#C3# => (new Cycles_Rec'(False, 16), OPCode_C3'Access),
       16#C4# => (new Cycles_Rec'(True, 24, 12), OPCode_C4'Access),
       16#C5# => (new Cycles_Rec'(False, 16), OPCode_C5'Access),
       16#C6# => (new Cycles_Rec'(False, 8), OPCode_C6'Access),
       16#C7# => (new Cycles_Rec'(False, 16), OPCode_C7'Access),
       16#C8# => (new Cycles_Rec'(True, 20, 8), OPCode_C8'Access),
       16#C9# => (new Cycles_Rec'(False, 16), OPCode_C9'Access),
       16#CA# => (new Cycles_Rec'(True, 16, 12), OPCode_CA'Access),
       16#CB# => (new Cycles_Rec'(False, 4), OPCode_CB'Access),
       16#CC# => (new Cycles_Rec'(True, 24, 12), OPCode_CC'Access),
       16#CD# => (new Cycles_Rec'(False, 24), OPCode_CD'Access),
       16#CE# => (new Cycles_Rec'(False, 8), OPCode_CE'Access),
       16#CF# => (new Cycles_Rec'(False, 16), OPCode_CF'Access),
       16#D0# => (new Cycles_Rec'(True, 20, 8), OPCode_D0'Access),
       16#D1# => (new Cycles_Rec'(False, 12), OPCode_D1'Access),
       16#D2# => (new Cycles_Rec'(True, 16, 12), OPCode_D2'Access),
       16#D4# => (new Cycles_Rec'(True, 24, 12), OPCode_D4'Access),
       16#D5# => (new Cycles_Rec'(False, 16), OPCode_D5'Access),
       16#D6# => (new Cycles_Rec'(False, 8), OPCode_D6'Access),
       16#D7# => (new Cycles_Rec'(False, 16), OPCode_D7'Access),
       16#D8# => (new Cycles_Rec'(True, 20, 8), OPCode_D8'Access),
       16#D9# => (new Cycles_Rec'(False, 16), OPCode_D9'Access),
       16#DA# => (new Cycles_Rec'(True, 16, 12), OPCode_DA'Access),
       16#DC# => (new Cycles_Rec'(True, 24, 12), OPCode_DC'Access),
       16#DE# => (new Cycles_Rec'(False, 8), OPCode_DE'Access),
       16#DF# => (new Cycles_Rec'(False, 16), OPCode_DF'Access),
       16#E0# => (new Cycles_Rec'(False, 12), OPCode_E0'Access),
       16#E1# => (new Cycles_Rec'(False, 12), OPCode_E1'Access),
       16#E2# => (new Cycles_Rec'(False, 8), OPCode_E2'Access),
       16#E5# => (new Cycles_Rec'(False, 16), OPCode_E5'Access),
       16#E6# => (new Cycles_Rec'(False, 8), OPCode_E6'Access),
       16#E7# => (new Cycles_Rec'(False, 16), OPCode_E7'Access),
       16#E8# => (new Cycles_Rec'(False, 16), OPCode_E8'Access),
       16#E9# => (new Cycles_Rec'(False, 4), OPCode_E9'Access),
       16#EA# => (new Cycles_Rec'(False, 16), OPCode_EA'Access),
       16#EE# => (new Cycles_Rec'(False, 8), OPCode_EE'Access),
       16#EF# => (new Cycles_Rec'(False, 16), OPCode_EF'Access),
       16#F0# => (new Cycles_Rec'(False, 12), OPCode_F0'Access),
       16#F1# => (new Cycles_Rec'(False, 12), OPCode_F1'Access),
       16#F2# => (new Cycles_Rec'(False, 8), OPCode_F2'Access),
       16#F3# => (new Cycles_Rec'(False, 4), OPCode_F3'Access),
       16#F5# => (new Cycles_Rec'(False, 16), OPCode_F5'Access),
       16#F6# => (new Cycles_Rec'(False, 8), OPCode_F6'Access),
       16#F7# => (new Cycles_Rec'(False, 16), OPCode_F7'Access),
       16#F8# => (new Cycles_Rec'(False, 12), OPCode_F8'Access),
       16#F9# => (new Cycles_Rec'(False, 8), OPCode_F9'Access),
       16#FA# => (new Cycles_Rec'(False, 16), OPCode_FA'Access),
       16#FB# => (new Cycles_Rec'(False, 4), OPCode_FB'Access),
       16#FE# => (new Cycles_Rec'(False, 8), OPCode_FE'Access),
       16#FF# => (new Cycles_Rec'(False, 16), OPCode_FF'Access),
       others => (null, null)];

   CBprefixed : constant Table_T :=
      [16#00# => (new Cycles_Rec'(False, 8), CB_OPCode_00'Access),
       16#01# => (new Cycles_Rec'(False, 8), CB_OPCode_01'Access),
       16#02# => (new Cycles_Rec'(False, 8), CB_OPCode_02'Access),
       16#03# => (new Cycles_Rec'(False, 8), CB_OPCode_03'Access),
       16#04# => (new Cycles_Rec'(False, 8), CB_OPCode_04'Access),
       16#05# => (new Cycles_Rec'(False, 8), CB_OPCode_05'Access),
       16#06# => (new Cycles_Rec'(False, 16), CB_OPCode_06'Access),
       16#07# => (new Cycles_Rec'(False, 8), CB_OPCode_07'Access),
       16#08# => (new Cycles_Rec'(False, 8), CB_OPCode_08'Access),
       16#09# => (new Cycles_Rec'(False, 8), CB_OPCode_09'Access),
       16#0A# => (new Cycles_Rec'(False, 8), CB_OPCode_0A'Access),
       16#0B# => (new Cycles_Rec'(False, 8), CB_OPCode_0B'Access),
       16#0C# => (new Cycles_Rec'(False, 8), CB_OPCode_0C'Access),
       16#0D# => (new Cycles_Rec'(False, 8), CB_OPCode_0D'Access),
       16#0E# => (new Cycles_Rec'(False, 16), CB_OPCode_0E'Access),
       16#0F# => (new Cycles_Rec'(False, 8), CB_OPCode_0F'Access),
       16#10# => (new Cycles_Rec'(False, 8), CB_OPCode_10'Access),
       16#11# => (new Cycles_Rec'(False, 8), CB_OPCode_11'Access),
       16#12# => (new Cycles_Rec'(False, 8), CB_OPCode_12'Access),
       16#13# => (new Cycles_Rec'(False, 8), CB_OPCode_13'Access),
       16#14# => (new Cycles_Rec'(False, 8), CB_OPCode_14'Access),
       16#15# => (new Cycles_Rec'(False, 8), CB_OPCode_15'Access),
       16#16# => (new Cycles_Rec'(False, 16), CB_OPCode_16'Access),
       16#17# => (new Cycles_Rec'(False, 8), CB_OPCode_17'Access),
       16#18# => (new Cycles_Rec'(False, 8), CB_OPCode_18'Access),
       16#19# => (new Cycles_Rec'(False, 8), CB_OPCode_19'Access),
       16#1A# => (new Cycles_Rec'(False, 8), CB_OPCode_1A'Access),
       16#1B# => (new Cycles_Rec'(False, 8), CB_OPCode_1B'Access),
       16#1C# => (new Cycles_Rec'(False, 8), CB_OPCode_1C'Access),
       16#1D# => (new Cycles_Rec'(False, 8), CB_OPCode_1D'Access),
       16#1E# => (new Cycles_Rec'(False, 16), CB_OPCode_1E'Access),
       16#1F# => (new Cycles_Rec'(False, 8), CB_OPCode_1F'Access),
       16#20# => (new Cycles_Rec'(False, 8), CB_OPCode_20'Access),
       16#21# => (new Cycles_Rec'(False, 8), CB_OPCode_21'Access),
       16#22# => (new Cycles_Rec'(False, 8), CB_OPCode_22'Access),
       16#23# => (new Cycles_Rec'(False, 8), CB_OPCode_23'Access),
       16#24# => (new Cycles_Rec'(False, 8), CB_OPCode_24'Access),
       16#25# => (new Cycles_Rec'(False, 8), CB_OPCode_25'Access),
       16#26# => (new Cycles_Rec'(False, 16), CB_OPCode_26'Access),
       16#27# => (new Cycles_Rec'(False, 8), CB_OPCode_27'Access),
       16#28# => (new Cycles_Rec'(False, 8), CB_OPCode_28'Access),
       16#29# => (new Cycles_Rec'(False, 8), CB_OPCode_29'Access),
       16#2A# => (new Cycles_Rec'(False, 8), CB_OPCode_2A'Access),
       16#2B# => (new Cycles_Rec'(False, 8), CB_OPCode_2B'Access),
       16#2C# => (new Cycles_Rec'(False, 8), CB_OPCode_2C'Access),
       16#2D# => (new Cycles_Rec'(False, 8), CB_OPCode_2D'Access),
       16#2E# => (new Cycles_Rec'(False, 16), CB_OPCode_2E'Access),
       16#2F# => (new Cycles_Rec'(False, 8), CB_OPCode_2F'Access),
       16#30# => (new Cycles_Rec'(False, 8), CB_OPCode_30'Access),
       16#31# => (new Cycles_Rec'(False, 8), CB_OPCode_31'Access),
       16#32# => (new Cycles_Rec'(False, 8), CB_OPCode_32'Access),
       16#33# => (new Cycles_Rec'(False, 8), CB_OPCode_33'Access),
       16#34# => (new Cycles_Rec'(False, 8), CB_OPCode_34'Access),
       16#35# => (new Cycles_Rec'(False, 8), CB_OPCode_35'Access),
       16#36# => (new Cycles_Rec'(False, 16), CB_OPCode_36'Access),
       16#37# => (new Cycles_Rec'(False, 8), CB_OPCode_37'Access),
       16#38# => (new Cycles_Rec'(False, 8), CB_OPCode_38'Access),
       16#39# => (new Cycles_Rec'(False, 8), CB_OPCode_39'Access),
       16#3A# => (new Cycles_Rec'(False, 8), CB_OPCode_3A'Access),
       16#3B# => (new Cycles_Rec'(False, 8), CB_OPCode_3B'Access),
       16#3C# => (new Cycles_Rec'(False, 8), CB_OPCode_3C'Access),
       16#3D# => (new Cycles_Rec'(False, 8), CB_OPCode_3D'Access),
       16#3E# => (new Cycles_Rec'(False, 16), CB_OPCode_3E'Access),
       16#3F# => (new Cycles_Rec'(False, 8), CB_OPCode_3F'Access),
       16#40# => (new Cycles_Rec'(False, 8), CB_OPCode_40'Access),
       16#41# => (new Cycles_Rec'(False, 8), CB_OPCode_41'Access),
       16#42# => (new Cycles_Rec'(False, 8), CB_OPCode_42'Access),
       16#43# => (new Cycles_Rec'(False, 8), CB_OPCode_43'Access),
       16#44# => (new Cycles_Rec'(False, 8), CB_OPCode_44'Access),
       16#45# => (new Cycles_Rec'(False, 8), CB_OPCode_45'Access),
       16#46# => (new Cycles_Rec'(False, 16), CB_OPCode_46'Access),
       16#47# => (new Cycles_Rec'(False, 8), CB_OPCode_47'Access),
       16#48# => (new Cycles_Rec'(False, 8), CB_OPCode_48'Access),
       16#49# => (new Cycles_Rec'(False, 8), CB_OPCode_49'Access),
       16#4A# => (new Cycles_Rec'(False, 8), CB_OPCode_4A'Access),
       16#4B# => (new Cycles_Rec'(False, 8), CB_OPCode_4B'Access),
       16#4C# => (new Cycles_Rec'(False, 8), CB_OPCode_4C'Access),
       16#4D# => (new Cycles_Rec'(False, 8), CB_OPCode_4D'Access),
       16#4E# => (new Cycles_Rec'(False, 16), CB_OPCode_4E'Access),
       16#4F# => (new Cycles_Rec'(False, 8), CB_OPCode_4F'Access),
       16#50# => (new Cycles_Rec'(False, 8), CB_OPCode_50'Access),
       16#51# => (new Cycles_Rec'(False, 8), CB_OPCode_51'Access),
       16#52# => (new Cycles_Rec'(False, 8), CB_OPCode_52'Access),
       16#53# => (new Cycles_Rec'(False, 8), CB_OPCode_53'Access),
       16#54# => (new Cycles_Rec'(False, 8), CB_OPCode_54'Access),
       16#55# => (new Cycles_Rec'(False, 8), CB_OPCode_55'Access),
       16#56# => (new Cycles_Rec'(False, 16), CB_OPCode_56'Access),
       16#57# => (new Cycles_Rec'(False, 8), CB_OPCode_57'Access),
       16#58# => (new Cycles_Rec'(False, 8), CB_OPCode_58'Access),
       16#59# => (new Cycles_Rec'(False, 8), CB_OPCode_59'Access),
       16#5A# => (new Cycles_Rec'(False, 8), CB_OPCode_5A'Access),
       16#5B# => (new Cycles_Rec'(False, 8), CB_OPCode_5B'Access),
       16#5C# => (new Cycles_Rec'(False, 8), CB_OPCode_5C'Access),
       16#5D# => (new Cycles_Rec'(False, 8), CB_OPCode_5D'Access),
       16#5E# => (new Cycles_Rec'(False, 16), CB_OPCode_5E'Access),
       16#5F# => (new Cycles_Rec'(False, 8), CB_OPCode_5F'Access),
       16#60# => (new Cycles_Rec'(False, 8), CB_OPCode_60'Access),
       16#61# => (new Cycles_Rec'(False, 8), CB_OPCode_61'Access),
       16#62# => (new Cycles_Rec'(False, 8), CB_OPCode_62'Access),
       16#63# => (new Cycles_Rec'(False, 8), CB_OPCode_63'Access),
       16#64# => (new Cycles_Rec'(False, 8), CB_OPCode_64'Access),
       16#65# => (new Cycles_Rec'(False, 8), CB_OPCode_65'Access),
       16#66# => (new Cycles_Rec'(False, 16), CB_OPCode_66'Access),
       16#67# => (new Cycles_Rec'(False, 8), CB_OPCode_67'Access),
       16#68# => (new Cycles_Rec'(False, 8), CB_OPCode_68'Access),
       16#69# => (new Cycles_Rec'(False, 8), CB_OPCode_69'Access),
       16#6A# => (new Cycles_Rec'(False, 8), CB_OPCode_6A'Access),
       16#6B# => (new Cycles_Rec'(False, 8), CB_OPCode_6B'Access),
       16#6C# => (new Cycles_Rec'(False, 8), CB_OPCode_6C'Access),
       16#6D# => (new Cycles_Rec'(False, 8), CB_OPCode_6D'Access),
       16#6E# => (new Cycles_Rec'(False, 16), CB_OPCode_6E'Access),
       16#6F# => (new Cycles_Rec'(False, 8), CB_OPCode_6F'Access),
       16#70# => (new Cycles_Rec'(False, 8), CB_OPCode_70'Access),
       16#71# => (new Cycles_Rec'(False, 8), CB_OPCode_71'Access),
       16#72# => (new Cycles_Rec'(False, 8), CB_OPCode_72'Access),
       16#73# => (new Cycles_Rec'(False, 8), CB_OPCode_73'Access),
       16#74# => (new Cycles_Rec'(False, 8), CB_OPCode_74'Access),
       16#75# => (new Cycles_Rec'(False, 8), CB_OPCode_75'Access),
       16#76# => (new Cycles_Rec'(False, 16), CB_OPCode_76'Access),
       16#77# => (new Cycles_Rec'(False, 8), CB_OPCode_77'Access),
       16#78# => (new Cycles_Rec'(False, 8), CB_OPCode_78'Access),
       16#79# => (new Cycles_Rec'(False, 8), CB_OPCode_79'Access),
       16#7A# => (new Cycles_Rec'(False, 8), CB_OPCode_7A'Access),
       16#7B# => (new Cycles_Rec'(False, 8), CB_OPCode_7B'Access),
       16#7C# => (new Cycles_Rec'(False, 8), CB_OPCode_7C'Access),
       16#7D# => (new Cycles_Rec'(False, 8), CB_OPCode_7D'Access),
       16#7E# => (new Cycles_Rec'(False, 16), CB_OPCode_7E'Access),
       16#7F# => (new Cycles_Rec'(False, 8), CB_OPCode_7F'Access),
       16#80# => (new Cycles_Rec'(False, 8), CB_OPCode_80'Access),
       16#81# => (new Cycles_Rec'(False, 8), CB_OPCode_81'Access),
       16#82# => (new Cycles_Rec'(False, 8), CB_OPCode_82'Access),
       16#83# => (new Cycles_Rec'(False, 8), CB_OPCode_83'Access),
       16#84# => (new Cycles_Rec'(False, 8), CB_OPCode_84'Access),
       16#85# => (new Cycles_Rec'(False, 8), CB_OPCode_85'Access),
       16#86# => (new Cycles_Rec'(False, 16), CB_OPCode_86'Access),
       16#87# => (new Cycles_Rec'(False, 8), CB_OPCode_87'Access),
       16#88# => (new Cycles_Rec'(False, 8), CB_OPCode_88'Access),
       16#89# => (new Cycles_Rec'(False, 8), CB_OPCode_89'Access),
       16#8A# => (new Cycles_Rec'(False, 8), CB_OPCode_8A'Access),
       16#8B# => (new Cycles_Rec'(False, 8), CB_OPCode_8B'Access),
       16#8C# => (new Cycles_Rec'(False, 8), CB_OPCode_8C'Access),
       16#8D# => (new Cycles_Rec'(False, 8), CB_OPCode_8D'Access),
       16#8E# => (new Cycles_Rec'(False, 16), CB_OPCode_8E'Access),
       16#8F# => (new Cycles_Rec'(False, 8), CB_OPCode_8F'Access),
       16#90# => (new Cycles_Rec'(False, 8), CB_OPCode_90'Access),
       16#91# => (new Cycles_Rec'(False, 8), CB_OPCode_91'Access),
       16#92# => (new Cycles_Rec'(False, 8), CB_OPCode_92'Access),
       16#93# => (new Cycles_Rec'(False, 8), CB_OPCode_93'Access),
       16#94# => (new Cycles_Rec'(False, 8), CB_OPCode_94'Access),
       16#95# => (new Cycles_Rec'(False, 8), CB_OPCode_95'Access),
       16#96# => (new Cycles_Rec'(False, 16), CB_OPCode_96'Access),
       16#97# => (new Cycles_Rec'(False, 8), CB_OPCode_97'Access),
       16#98# => (new Cycles_Rec'(False, 8), CB_OPCode_98'Access),
       16#99# => (new Cycles_Rec'(False, 8), CB_OPCode_99'Access),
       16#9A# => (new Cycles_Rec'(False, 8), CB_OPCode_9A'Access),
       16#9B# => (new Cycles_Rec'(False, 8), CB_OPCode_9B'Access),
       16#9C# => (new Cycles_Rec'(False, 8), CB_OPCode_9C'Access),
       16#9D# => (new Cycles_Rec'(False, 8), CB_OPCode_9D'Access),
       16#9E# => (new Cycles_Rec'(False, 16), CB_OPCode_9E'Access),
       16#9F# => (new Cycles_Rec'(False, 8), CB_OPCode_9F'Access),
       16#A0# => (new Cycles_Rec'(False, 8), CB_OPCode_A0'Access),
       16#A1# => (new Cycles_Rec'(False, 8), CB_OPCode_A1'Access),
       16#A2# => (new Cycles_Rec'(False, 8), CB_OPCode_A2'Access),
       16#A3# => (new Cycles_Rec'(False, 8), CB_OPCode_A3'Access),
       16#A4# => (new Cycles_Rec'(False, 8), CB_OPCode_A4'Access),
       16#A5# => (new Cycles_Rec'(False, 8), CB_OPCode_A5'Access),
       16#A6# => (new Cycles_Rec'(False, 16), CB_OPCode_A6'Access),
       16#A7# => (new Cycles_Rec'(False, 8), CB_OPCode_A7'Access),
       16#A8# => (new Cycles_Rec'(False, 8), CB_OPCode_A8'Access),
       16#A9# => (new Cycles_Rec'(False, 8), CB_OPCode_A9'Access),
       16#AA# => (new Cycles_Rec'(False, 8), CB_OPCode_AA'Access),
       16#AB# => (new Cycles_Rec'(False, 8), CB_OPCode_AB'Access),
       16#AC# => (new Cycles_Rec'(False, 8), CB_OPCode_AC'Access),
       16#AD# => (new Cycles_Rec'(False, 8), CB_OPCode_AD'Access),
       16#AE# => (new Cycles_Rec'(False, 16), CB_OPCode_AE'Access),
       16#AF# => (new Cycles_Rec'(False, 8), CB_OPCode_AF'Access),
       16#B0# => (new Cycles_Rec'(False, 8), CB_OPCode_B0'Access),
       16#B1# => (new Cycles_Rec'(False, 8), CB_OPCode_B1'Access),
       16#B2# => (new Cycles_Rec'(False, 8), CB_OPCode_B2'Access),
       16#B3# => (new Cycles_Rec'(False, 8), CB_OPCode_B3'Access),
       16#B4# => (new Cycles_Rec'(False, 8), CB_OPCode_B4'Access),
       16#B5# => (new Cycles_Rec'(False, 8), CB_OPCode_B5'Access),
       16#B6# => (new Cycles_Rec'(False, 16), CB_OPCode_B6'Access),
       16#B7# => (new Cycles_Rec'(False, 8), CB_OPCode_B7'Access),
       16#B8# => (new Cycles_Rec'(False, 8), CB_OPCode_B8'Access),
       16#B9# => (new Cycles_Rec'(False, 8), CB_OPCode_B9'Access),
       16#BA# => (new Cycles_Rec'(False, 8), CB_OPCode_BA'Access),
       16#BB# => (new Cycles_Rec'(False, 8), CB_OPCode_BB'Access),
       16#BC# => (new Cycles_Rec'(False, 8), CB_OPCode_BC'Access),
       16#BD# => (new Cycles_Rec'(False, 8), CB_OPCode_BD'Access),
       16#BE# => (new Cycles_Rec'(False, 16), CB_OPCode_BE'Access),
       16#BF# => (new Cycles_Rec'(False, 8), CB_OPCode_BF'Access),
       16#C0# => (new Cycles_Rec'(False, 8), CB_OPCode_C0'Access),
       16#C1# => (new Cycles_Rec'(False, 8), CB_OPCode_C1'Access),
       16#C2# => (new Cycles_Rec'(False, 8), CB_OPCode_C2'Access),
       16#C3# => (new Cycles_Rec'(False, 8), CB_OPCode_C3'Access),
       16#C4# => (new Cycles_Rec'(False, 8), CB_OPCode_C4'Access),
       16#C5# => (new Cycles_Rec'(False, 8), CB_OPCode_C5'Access),
       16#C6# => (new Cycles_Rec'(False, 16), CB_OPCode_C6'Access),
       16#C7# => (new Cycles_Rec'(False, 8), CB_OPCode_C7'Access),
       16#C8# => (new Cycles_Rec'(False, 8), CB_OPCode_C8'Access),
       16#C9# => (new Cycles_Rec'(False, 8), CB_OPCode_C9'Access),
       16#CA# => (new Cycles_Rec'(False, 8), CB_OPCode_CA'Access),
       16#CB# => (new Cycles_Rec'(False, 8), CB_OPCode_CB'Access),
       16#CC# => (new Cycles_Rec'(False, 8), CB_OPCode_CC'Access),
       16#CD# => (new Cycles_Rec'(False, 8), CB_OPCode_CD'Access),
       16#CE# => (new Cycles_Rec'(False, 16), CB_OPCode_CE'Access),
       16#CF# => (new Cycles_Rec'(False, 8), CB_OPCode_CF'Access),
       16#D0# => (new Cycles_Rec'(False, 8), CB_OPCode_D0'Access),
       16#D1# => (new Cycles_Rec'(False, 8), CB_OPCode_D1'Access),
       16#D2# => (new Cycles_Rec'(False, 8), CB_OPCode_D2'Access),
       16#D3# => (new Cycles_Rec'(False, 8), CB_OPCode_D3'Access),
       16#D4# => (new Cycles_Rec'(False, 8), CB_OPCode_D4'Access),
       16#D5# => (new Cycles_Rec'(False, 8), CB_OPCode_D5'Access),
       16#D6# => (new Cycles_Rec'(False, 16), CB_OPCode_D6'Access),
       16#D7# => (new Cycles_Rec'(False, 8), CB_OPCode_D7'Access),
       16#D8# => (new Cycles_Rec'(False, 8), CB_OPCode_D8'Access),
       16#D9# => (new Cycles_Rec'(False, 8), CB_OPCode_D9'Access),
       16#DA# => (new Cycles_Rec'(False, 8), CB_OPCode_DA'Access),
       16#DB# => (new Cycles_Rec'(False, 8), CB_OPCode_DB'Access),
       16#DC# => (new Cycles_Rec'(False, 8), CB_OPCode_DC'Access),
       16#DD# => (new Cycles_Rec'(False, 8), CB_OPCode_DD'Access),
       16#DE# => (new Cycles_Rec'(False, 16), CB_OPCode_DE'Access),
       16#DF# => (new Cycles_Rec'(False, 8), CB_OPCode_DF'Access),
       16#E0# => (new Cycles_Rec'(False, 8), CB_OPCode_E0'Access),
       16#E1# => (new Cycles_Rec'(False, 8), CB_OPCode_E1'Access),
       16#E2# => (new Cycles_Rec'(False, 8), CB_OPCode_E2'Access),
       16#E3# => (new Cycles_Rec'(False, 8), CB_OPCode_E3'Access),
       16#E4# => (new Cycles_Rec'(False, 8), CB_OPCode_E4'Access),
       16#E5# => (new Cycles_Rec'(False, 8), CB_OPCode_E5'Access),
       16#E6# => (new Cycles_Rec'(False, 16), CB_OPCode_E6'Access),
       16#E7# => (new Cycles_Rec'(False, 8), CB_OPCode_E7'Access),
       16#E8# => (new Cycles_Rec'(False, 8), CB_OPCode_E8'Access),
       16#E9# => (new Cycles_Rec'(False, 8), CB_OPCode_E9'Access),
       16#EA# => (new Cycles_Rec'(False, 8), CB_OPCode_EA'Access),
       16#EB# => (new Cycles_Rec'(False, 8), CB_OPCode_EB'Access),
       16#EC# => (new Cycles_Rec'(False, 8), CB_OPCode_EC'Access),
       16#ED# => (new Cycles_Rec'(False, 8), CB_OPCode_ED'Access),
       16#EE# => (new Cycles_Rec'(False, 16), CB_OPCode_EE'Access),
       16#EF# => (new Cycles_Rec'(False, 8), CB_OPCode_EF'Access),
       16#F0# => (new Cycles_Rec'(False, 8), CB_OPCode_F0'Access),
       16#F1# => (new Cycles_Rec'(False, 8), CB_OPCode_F1'Access),
       16#F2# => (new Cycles_Rec'(False, 8), CB_OPCode_F2'Access),
       16#F3# => (new Cycles_Rec'(False, 8), CB_OPCode_F3'Access),
       16#F4# => (new Cycles_Rec'(False, 8), CB_OPCode_F4'Access),
       16#F5# => (new Cycles_Rec'(False, 8), CB_OPCode_F5'Access),
       16#F6# => (new Cycles_Rec'(False, 16), CB_OPCode_F6'Access),
       16#F7# => (new Cycles_Rec'(False, 8), CB_OPCode_F7'Access),
       16#F8# => (new Cycles_Rec'(False, 8), CB_OPCode_F8'Access),
       16#F9# => (new Cycles_Rec'(False, 8), CB_OPCode_F9'Access),
       16#FA# => (new Cycles_Rec'(False, 8), CB_OPCode_FA'Access),
       16#FB# => (new Cycles_Rec'(False, 8), CB_OPCode_FB'Access),
       16#FC# => (new Cycles_Rec'(False, 8), CB_OPCode_FC'Access),
       16#FD# => (new Cycles_Rec'(False, 8), CB_OPCode_FD'Access),
       16#FE# => (new Cycles_Rec'(False, 16), CB_OPCode_FE'Access),
       16#FF# => (new Cycles_Rec'(False, 8), CB_OPCode_FF'Access),
       others => (null, null)];
end OPCode_Table;
