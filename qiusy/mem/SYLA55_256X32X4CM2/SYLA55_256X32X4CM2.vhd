-- |-----------------------------------------------------------------------|
-- ________________________________________________________________________________________________
-- 
-- 
--             Synchronous RVT Periphery One-Port Register File Compiler
-- 
--                 UMC 55nm Low K Low Power Logic Process
-- 
-- ________________________________________________________________________________________________
-- 
--               
--         Copyright (C) 2020 Faraday Technology Corporation. All Rights Reserved.       
--                
--         This source code is an unpublished work belongs to Faraday Technology Corporation       
--         It is considered a trade secret and is not to be divulged or       
--         used by parties who have not received written authorization from       
--         Faraday Technology Corporation       
--                
--         Faraday's home page can be found at: http://www.faraday-tech.com/       
--                
-- ________________________________________________________________________________________________
-- 
--        IP Name            :  FSF0L_A_SY                                               
--        IP Version         :  1.5.0                                                    
--        IP Release Status  :  Active                                                   
--        Word               :  256                                                      
--        Bit                :  32                                                       
--        Byte               :  4                                                        
--        Mux                :  2                                                        
--        Output Loading     :  0.01                                                     
--        Clock Input Slew   :  0.008                                                    
--        Data Input Slew    :  0.008                                                    
--        Ring Type          :  Ring Shape Model                                         
--        Ring Layer         :  2233                                                     
--        Ring Width         :  2                                                        
--        Bus Format         :  1                                                        
--        Memaker Path       :  /workspace/technology/umc/55nm_201908/memlib_GDS/memlib  
--        GUI Version        :  m20130120                                                
--        Date               :  2020/07/14 14:48:57                                      
-- ________________________________________________________________________________________________
-- 
--
-- Notice on usage: Fixed delay or timing data are given in this model.
--                  It supports SDF back-annotation, please generate SDF file
--                  by EDA tools to get the accurate timing.
--
-- |-----------------------------------------------------------------------|
--
-- Warning : 
--   If customer's design viloate the set-up time or hold time criteria of 
--   synchronous SRAM, it's possible to hit the meta-stable point of 
--   latch circuit in the decoder and cause the data loss in the memory 
--   bitcell. So please follow the memory IP's spec to design your 
--   product.
--
-- |-----------------------------------------------------------------------|

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

-- entity declaration --
entity SYLA55_256X32X4CM2 is
   generic(
      SYN_CS:          integer  := 1;
      NO_SER_TOH:      integer  := 1;
      AddressSize:     integer  := 8;
      DVSize:          integer  := 4;
      Bits:            integer  := 32;
      Words:           integer  := 256;
      Bytes:           integer  := 4;
      AspectRatio:     integer  := 2;
      TOH:             time     := 0.810 ns;
      TWDX:            time     := 1.063 ns;

      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := True;
      MsgOn: Boolean := True;

      tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge : VitalDelayArrayType01(0 to 127) :=  (others => (1.267 ns, 1.267 ns));
      tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge : VitalDelayArrayType01(0 to 127) :=  (others => (1.267 ns, 1.267 ns));
      tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge : VitalDelayArrayType01(0 to 127) :=  (others => (1.267 ns, 1.267 ns));
      tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge : VitalDelayArrayType01(0 to 127) :=  (others => (1.267 ns, 1.267 ns));

      tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge : VitalDelayArrayType01(0 to 127) :=  (others => (1.267 ns, 1.267 ns));
      tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge : VitalDelayArrayType01(0 to 127) :=  (others => (1.267 ns, 1.267 ns));
      tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge : VitalDelayArrayType01(0 to 127) :=  (others => (1.267 ns, 1.267 ns));
      tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge : VitalDelayArrayType01(0 to 127) :=  (others => (1.267 ns, 1.267 ns));

      tsetup_A_CK_posedge_posedge    :  VitalDelayArrayType(0 to 7) :=  (others => (0.123 ns));
      tsetup_A_CK_negedge_posedge    :  VitalDelayArrayType(0 to 7) :=  (others => (0.123 ns));
      thold_A_CK_posedge_posedge     :  VitalDelayArrayType(0 to 7) :=  (others => (0.017 ns));
      thold_A_CK_negedge_posedge     :  VitalDelayArrayType(0 to 7) :=  (others => (0.017 ns));   
         
      tsetup_DI_CK_posedge_posedge    :  VitalDelayArrayType(0 to 127) :=  (others => (0.085 ns));
      tsetup_DI_CK_negedge_posedge    :  VitalDelayArrayType(0 to 127) :=  (others => (0.085 ns));
      thold_DI_CK_posedge_posedge     :  VitalDelayArrayType(0 to 127) :=  (others => (0.106 ns));
      thold_DI_CK_negedge_posedge     :  VitalDelayArrayType(0 to 127) :=  (others => (0.106 ns));


      tsetup_WEB_CK_posedge_posedge  :  VitalDelayArrayType(0 to 3) :=  (others => (0.062 ns));
      tsetup_WEB_CK_negedge_posedge  :  VitalDelayArrayType(0 to 3) :=  (others => (0.062 ns));
      thold_WEB_CK_posedge_posedge   :  VitalDelayArrayType(0 to 3) :=  (others => (0.130 ns));
      thold_WEB_CK_negedge_posedge   :  VitalDelayArrayType(0 to 3) :=  (others => (0.130 ns));

      tsetup_CSB_CK_posedge_posedge    :  VitalDelayType := 0.231 ns;
      tsetup_CSB_CK_negedge_posedge    :  VitalDelayType := 0.231 ns;
      thold_CSB_CK_posedge_posedge     :  VitalDelayType := 0.063 ns;
      thold_CSB_CK_negedge_posedge     :  VitalDelayType := 0.063 ns;


      tperiod_CK                        :  VitalDelayType := 1.486 ns;
      tpw_CK_posedge                 :  VitalDelayType := 0.197 ns;
      tpw_CK_negedge                 :  VitalDelayType := 0.197 ns;
      tipd_A0                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A1                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A2                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A3                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A4                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A5                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A6                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A7                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI0                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI1                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI2                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI3                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI4                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI5                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI6                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI7                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI8                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI9                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI10                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI11                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI12                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI13                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI14                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI15                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI16                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI17                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI18                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI19                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI20                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI21                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI22                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI23                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI24                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI25                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI26                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI27                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI28                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI29                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI30                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI31                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI32                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI33                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI34                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI35                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI36                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI37                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI38                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI39                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI40                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI41                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI42                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI43                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI44                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI45                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI46                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI47                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI48                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI49                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI50                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI51                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI52                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI53                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI54                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI55                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI56                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI57                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI58                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI59                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI60                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI61                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI62                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI63                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI64                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI65                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI66                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI67                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI68                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI69                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI70                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI71                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI72                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI73                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI74                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI75                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI76                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI77                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI78                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI79                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI80                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI81                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI82                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI83                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI84                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI85                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI86                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI87                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI88                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI89                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI90                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI91                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI92                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI93                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI94                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI95                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI96                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI97                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI98                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI99                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI100                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI101                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI102                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI103                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI104                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI105                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI106                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI107                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI108                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI109                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI110                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI111                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI112                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI113                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI114                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI115                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI116                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI117                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI118                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI119                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI120                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI121                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI122                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI123                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI124                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI125                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI126                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI127                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_WEB0                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_WEB1                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_WEB2                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_WEB3                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CSB                       :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CK                        :  VitalDelayType01 := (0.000 ns, 0.000 ns)
      );

   port(
      DO                            :   OUT  std_logic_vector (127 downto 0); 
      A                             :   IN   std_logic_vector (7 downto 0); 
      DI                            :   IN   std_logic_vector (127 downto 0);
      WEB                           :   IN   std_logic_vector (3 downto 0);
      DVSE                          :   IN   std_logic;
      DVS                           :   IN   std_logic_vector (3 downto 0);
      CK                            :   IN   std_logic;
      CSB                           :   IN   std_logic             
      );

attribute VITAL_LEVEL0 of SYLA55_256X32X4CM2 : entity is TRUE;

end SYLA55_256X32X4CM2;

-- architecture body --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

architecture behavior of SYLA55_256X32X4CM2 is
   -- attribute VITALMEMORY_LEVEL1 of behavior : architecture is TRUE;

   CONSTANT True_flg:       integer := 0;
   CONSTANT False_flg:      integer := 1;
   CONSTANT Range_flg:      integer := 2;

   FUNCTION Minimum ( CONSTANT t1, t2 : IN TIME ) RETURN TIME IS
   BEGIN
      IF (t1 < t2) THEN RETURN (t1); ELSE RETURN (t2); END IF;
   END Minimum;

   FUNCTION Maximum ( CONSTANT t1, t2 : IN TIME ) RETURN TIME IS
   BEGIN
      IF (t1 < t2) THEN RETURN (t2); ELSE RETURN (t1); END IF;
   END Maximum;

   FUNCTION BVtoI(bin: std_logic_vector) RETURN integer IS
      variable result: integer;
   BEGIN
      result := 0;
      for i in bin'range loop
         if bin(i) = '1' then
            result := result + 2**i;
         end if;
      end loop;
      return result;
   END; -- BVtoI

   PROCEDURE ScheduleOutputDelayTOH (
       SIGNAL   OutSignal        : OUT std_logic;
       VARIABLE Data             : IN  std_logic;
       CONSTANT Delay            : IN  VitalDelayType01 := VitalDefDelay01;
       VARIABLE Previous_A       : IN  std_logic_vector(AddressSize-1 downto 0);
       VARIABLE Current_A        : IN  std_logic_vector(AddressSize-1 downto 0);
       VARIABLE Previous_WEB       : IN  std_logic;
       VARIABLE Current_WEB        : IN  std_logic;
       CONSTANT NO_SER_TOH       : IN  integer
   ) IS
   BEGIN
      if (NO_SER_TOH /= 1) then
         OutSignal <= TRANSPORT 'X' AFTER TOH;
         OutSignal <= TRANSPORT Data AFTER Maximum(Delay(tr10), Delay(tr01));
      else
         if (Current_A /= Previous_A) then
            OutSignal <= TRANSPORT 'X' AFTER TOH;
            OutSignal <= TRANSPORT Data AFTER Maximum(Delay(tr10), Delay(tr01));
         else
	   if (Current_WEB /= Previous_WEB) then
             OutSignal <= TRANSPORT 'X' AFTER TOH;
             OutSignal <= TRANSPORT Data AFTER Maximum(Delay(tr10), Delay(tr01));
	   else
             OutSignal <= TRANSPORT Data AFTER Maximum(Delay(tr10), Delay(tr01));
           end if;
         end if;
      end if;
   END ScheduleOutputDelayTOH;

   PROCEDURE ScheduleOutputDelayTWDX (
       SIGNAL   OutSignal        : OUT std_logic;
       VARIABLE Data             : IN  std_logic;
       CONSTANT Delay            : IN  VitalDelayType01 := VitalDefDelay01;
       VARIABLE Previous_A       : IN  std_logic_vector(AddressSize-1 downto 0);
       VARIABLE Current_A        : IN  std_logic_vector(AddressSize-1 downto 0);
       VARIABLE Previous_WEB     : IN  std_logic;
       VARIABLE Current_WEB      : IN  std_logic;
       VARIABLE Previous_DI      : IN  std_logic_vector(Bits-1 downto 0) := (others => 'X');
       VARIABLE Current_DI       : IN  std_logic_vector(Bits-1 downto 0) := (others => 'X');
       CONSTANT NO_SER_TOH       : IN  integer
   ) IS
   BEGIN
      if (NO_SER_TOH /= 1) then
         OutSignal <= TRANSPORT 'X' AFTER TWDX;
         OutSignal <= TRANSPORT Data AFTER Maximum(Delay(tr10), Delay(tr01));
      else
         if (Current_A /= Previous_A) then
            OutSignal <= TRANSPORT 'X' AFTER TWDX;
            OutSignal <= TRANSPORT Data AFTER Maximum(Delay(tr10), Delay(tr01));
         else
	   if (Current_WEB /= Previous_WEB) then
             OutSignal <= TRANSPORT 'X' AFTER TWDX;
             OutSignal <= TRANSPORT Data AFTER Maximum(Delay(tr10), Delay(tr01));
	   else
	     if (Current_DI /= Previous_DI) then
               OutSignal <= TRANSPORT 'X' AFTER TWDX;
               OutSignal <= TRANSPORT Data AFTER Maximum(Delay(tr10), Delay(tr01));
	     else
               OutSignal <= TRANSPORT Data AFTER Maximum(Delay(tr10), Delay(tr01));
             end if;
           end if;
         end if;
      end if;
   END ScheduleOutputDelayTWDX;

   FUNCTION TO_INTEGER (
     a: std_logic_vector
   ) RETURN INTEGER IS
     VARIABLE y: INTEGER := 0;
   BEGIN
        y := 0;
        FOR i IN a'RANGE LOOP
            y := y * 2;
            IF a(i) /= '1' AND a(i) /= '0' THEN
                y := 0;
                EXIT;
            ELSIF a(i) = '1' THEN
                y := y + 1;
            END IF;
        END LOOP;
        RETURN y;
   END TO_INTEGER;

   function AddressRangeCheck(AddressItem: std_logic_vector; flag_Address: integer) return integer is
     variable Uresult : std_logic;
     variable status  : integer := 0;

   begin
      if (Bits /= 1) then
         Uresult := AddressItem(0) xor AddressItem(1);
         for i in 2 to AddressItem'length-1 loop
            Uresult := Uresult xor AddressItem(i);
         end loop;
      else
         Uresult := AddressItem(0);
      end if;

      if (Uresult = 'U') then
         status := False_flg;
      elsif (Uresult = 'X') then
         status := False_flg;
      elsif (Uresult = 'Z') then
         status := False_flg;
      else
         status := True_flg;
      end if;

      if (status=False_flg) then
        if (flag_Address = True_flg) then
           -- Generate Error Messae --
           assert FALSE report "** MEM_Error: Unknown value occurred in Address." severity WARNING;
        end if;
      end if;

      if (status=True_flg) then
         if ((BVtoI(AddressItem)) >= Words) then
             assert FALSE report "** MEM_Error: Out of range occurred in Address." severity WARNING; 
             status := Range_flg;
         else
             status := True_flg;
         end if;
      end if;

      return status;
   end AddressRangeCheck;

   function CS_monitor(CSItem: std_logic; flag_CS: integer) return integer is
     variable status  : integer := 0;

   begin
      if (CSItem = 'U') then
         status := False_flg;
      elsif (CSItem = 'X') then
         status := False_flg;
      elsif (CSItem = 'Z') then
         status := False_flg;
      else
         status := True_flg;
      end if;

      if (status=False_flg) then
        if (flag_CS = True_flg) then
           -- Generate Error Messae --
           assert FALSE report "** MEM_Error: Unknown value occurred in ChipSelect." severity WARNING;
        end if;
      end if;

      return status;
   end CS_monitor;

   Type memoryArray Is array (Words-1 downto 0) Of std_logic_vector (Bits-1 downto 0);

   SIGNAL CSB_ipd         : std_logic := 'X';
   SIGNAL CK_ipd         : std_logic := 'X';
   SIGNAL A_ipd          : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   SIGNAL WEB0_ipd       : std_logic := 'X';
   SIGNAL DI0_ipd        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   SIGNAL DO0_int        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   SIGNAL WEB1_ipd       : std_logic := 'X';
   SIGNAL DI1_ipd        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   SIGNAL DO1_int        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   SIGNAL WEB2_ipd       : std_logic := 'X';
   SIGNAL DI2_ipd        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   SIGNAL DO2_int        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   SIGNAL WEB3_ipd       : std_logic := 'X';
   SIGNAL DI3_ipd        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   SIGNAL DO3_int        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   
begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (CK_ipd, CK, tipd_CK);
   VitalWireDelay (CSB_ipd, CSB, tipd_CSB);
   VitalWireDelay (WEB0_ipd, WEB(0), tipd_WEB0);
   VitalWireDelay (WEB1_ipd, WEB(1), tipd_WEB1);
   VitalWireDelay (WEB2_ipd, WEB(2), tipd_WEB2);
   VitalWireDelay (WEB3_ipd, WEB(3), tipd_WEB3);
   VitalWireDelay (A_ipd(0), A(0), tipd_A0);
   VitalWireDelay (A_ipd(1), A(1), tipd_A1);
   VitalWireDelay (A_ipd(2), A(2), tipd_A2);
   VitalWireDelay (A_ipd(3), A(3), tipd_A3);
   VitalWireDelay (A_ipd(4), A(4), tipd_A4);
   VitalWireDelay (A_ipd(5), A(5), tipd_A5);
   VitalWireDelay (A_ipd(6), A(6), tipd_A6);
   VitalWireDelay (A_ipd(7), A(7), tipd_A7);
   VitalWireDelay (DI0_ipd(0), DI(0), tipd_DI0);
   VitalWireDelay (DI0_ipd(1), DI(1), tipd_DI1);
   VitalWireDelay (DI0_ipd(2), DI(2), tipd_DI2);
   VitalWireDelay (DI0_ipd(3), DI(3), tipd_DI3);
   VitalWireDelay (DI0_ipd(4), DI(4), tipd_DI4);
   VitalWireDelay (DI0_ipd(5), DI(5), tipd_DI5);
   VitalWireDelay (DI0_ipd(6), DI(6), tipd_DI6);
   VitalWireDelay (DI0_ipd(7), DI(7), tipd_DI7);
   VitalWireDelay (DI0_ipd(8), DI(8), tipd_DI8);
   VitalWireDelay (DI0_ipd(9), DI(9), tipd_DI9);
   VitalWireDelay (DI0_ipd(10), DI(10), tipd_DI10);
   VitalWireDelay (DI0_ipd(11), DI(11), tipd_DI11);
   VitalWireDelay (DI0_ipd(12), DI(12), tipd_DI12);
   VitalWireDelay (DI0_ipd(13), DI(13), tipd_DI13);
   VitalWireDelay (DI0_ipd(14), DI(14), tipd_DI14);
   VitalWireDelay (DI0_ipd(15), DI(15), tipd_DI15);
   VitalWireDelay (DI0_ipd(16), DI(16), tipd_DI16);
   VitalWireDelay (DI0_ipd(17), DI(17), tipd_DI17);
   VitalWireDelay (DI0_ipd(18), DI(18), tipd_DI18);
   VitalWireDelay (DI0_ipd(19), DI(19), tipd_DI19);
   VitalWireDelay (DI0_ipd(20), DI(20), tipd_DI20);
   VitalWireDelay (DI0_ipd(21), DI(21), tipd_DI21);
   VitalWireDelay (DI0_ipd(22), DI(22), tipd_DI22);
   VitalWireDelay (DI0_ipd(23), DI(23), tipd_DI23);
   VitalWireDelay (DI0_ipd(24), DI(24), tipd_DI24);
   VitalWireDelay (DI0_ipd(25), DI(25), tipd_DI25);
   VitalWireDelay (DI0_ipd(26), DI(26), tipd_DI26);
   VitalWireDelay (DI0_ipd(27), DI(27), tipd_DI27);
   VitalWireDelay (DI0_ipd(28), DI(28), tipd_DI28);
   VitalWireDelay (DI0_ipd(29), DI(29), tipd_DI29);
   VitalWireDelay (DI0_ipd(30), DI(30), tipd_DI30);
   VitalWireDelay (DI0_ipd(31), DI(31), tipd_DI31);
   VitalWireDelay (DI1_ipd(0), DI(32), tipd_DI32);
   VitalWireDelay (DI1_ipd(1), DI(33), tipd_DI33);
   VitalWireDelay (DI1_ipd(2), DI(34), tipd_DI34);
   VitalWireDelay (DI1_ipd(3), DI(35), tipd_DI35);
   VitalWireDelay (DI1_ipd(4), DI(36), tipd_DI36);
   VitalWireDelay (DI1_ipd(5), DI(37), tipd_DI37);
   VitalWireDelay (DI1_ipd(6), DI(38), tipd_DI38);
   VitalWireDelay (DI1_ipd(7), DI(39), tipd_DI39);
   VitalWireDelay (DI1_ipd(8), DI(40), tipd_DI40);
   VitalWireDelay (DI1_ipd(9), DI(41), tipd_DI41);
   VitalWireDelay (DI1_ipd(10), DI(42), tipd_DI42);
   VitalWireDelay (DI1_ipd(11), DI(43), tipd_DI43);
   VitalWireDelay (DI1_ipd(12), DI(44), tipd_DI44);
   VitalWireDelay (DI1_ipd(13), DI(45), tipd_DI45);
   VitalWireDelay (DI1_ipd(14), DI(46), tipd_DI46);
   VitalWireDelay (DI1_ipd(15), DI(47), tipd_DI47);
   VitalWireDelay (DI1_ipd(16), DI(48), tipd_DI48);
   VitalWireDelay (DI1_ipd(17), DI(49), tipd_DI49);
   VitalWireDelay (DI1_ipd(18), DI(50), tipd_DI50);
   VitalWireDelay (DI1_ipd(19), DI(51), tipd_DI51);
   VitalWireDelay (DI1_ipd(20), DI(52), tipd_DI52);
   VitalWireDelay (DI1_ipd(21), DI(53), tipd_DI53);
   VitalWireDelay (DI1_ipd(22), DI(54), tipd_DI54);
   VitalWireDelay (DI1_ipd(23), DI(55), tipd_DI55);
   VitalWireDelay (DI1_ipd(24), DI(56), tipd_DI56);
   VitalWireDelay (DI1_ipd(25), DI(57), tipd_DI57);
   VitalWireDelay (DI1_ipd(26), DI(58), tipd_DI58);
   VitalWireDelay (DI1_ipd(27), DI(59), tipd_DI59);
   VitalWireDelay (DI1_ipd(28), DI(60), tipd_DI60);
   VitalWireDelay (DI1_ipd(29), DI(61), tipd_DI61);
   VitalWireDelay (DI1_ipd(30), DI(62), tipd_DI62);
   VitalWireDelay (DI1_ipd(31), DI(63), tipd_DI63);
   VitalWireDelay (DI2_ipd(0), DI(64), tipd_DI64);
   VitalWireDelay (DI2_ipd(1), DI(65), tipd_DI65);
   VitalWireDelay (DI2_ipd(2), DI(66), tipd_DI66);
   VitalWireDelay (DI2_ipd(3), DI(67), tipd_DI67);
   VitalWireDelay (DI2_ipd(4), DI(68), tipd_DI68);
   VitalWireDelay (DI2_ipd(5), DI(69), tipd_DI69);
   VitalWireDelay (DI2_ipd(6), DI(70), tipd_DI70);
   VitalWireDelay (DI2_ipd(7), DI(71), tipd_DI71);
   VitalWireDelay (DI2_ipd(8), DI(72), tipd_DI72);
   VitalWireDelay (DI2_ipd(9), DI(73), tipd_DI73);
   VitalWireDelay (DI2_ipd(10), DI(74), tipd_DI74);
   VitalWireDelay (DI2_ipd(11), DI(75), tipd_DI75);
   VitalWireDelay (DI2_ipd(12), DI(76), tipd_DI76);
   VitalWireDelay (DI2_ipd(13), DI(77), tipd_DI77);
   VitalWireDelay (DI2_ipd(14), DI(78), tipd_DI78);
   VitalWireDelay (DI2_ipd(15), DI(79), tipd_DI79);
   VitalWireDelay (DI2_ipd(16), DI(80), tipd_DI80);
   VitalWireDelay (DI2_ipd(17), DI(81), tipd_DI81);
   VitalWireDelay (DI2_ipd(18), DI(82), tipd_DI82);
   VitalWireDelay (DI2_ipd(19), DI(83), tipd_DI83);
   VitalWireDelay (DI2_ipd(20), DI(84), tipd_DI84);
   VitalWireDelay (DI2_ipd(21), DI(85), tipd_DI85);
   VitalWireDelay (DI2_ipd(22), DI(86), tipd_DI86);
   VitalWireDelay (DI2_ipd(23), DI(87), tipd_DI87);
   VitalWireDelay (DI2_ipd(24), DI(88), tipd_DI88);
   VitalWireDelay (DI2_ipd(25), DI(89), tipd_DI89);
   VitalWireDelay (DI2_ipd(26), DI(90), tipd_DI90);
   VitalWireDelay (DI2_ipd(27), DI(91), tipd_DI91);
   VitalWireDelay (DI2_ipd(28), DI(92), tipd_DI92);
   VitalWireDelay (DI2_ipd(29), DI(93), tipd_DI93);
   VitalWireDelay (DI2_ipd(30), DI(94), tipd_DI94);
   VitalWireDelay (DI2_ipd(31), DI(95), tipd_DI95);
   VitalWireDelay (DI3_ipd(0), DI(96), tipd_DI96);
   VitalWireDelay (DI3_ipd(1), DI(97), tipd_DI97);
   VitalWireDelay (DI3_ipd(2), DI(98), tipd_DI98);
   VitalWireDelay (DI3_ipd(3), DI(99), tipd_DI99);
   VitalWireDelay (DI3_ipd(4), DI(100), tipd_DI100);
   VitalWireDelay (DI3_ipd(5), DI(101), tipd_DI101);
   VitalWireDelay (DI3_ipd(6), DI(102), tipd_DI102);
   VitalWireDelay (DI3_ipd(7), DI(103), tipd_DI103);
   VitalWireDelay (DI3_ipd(8), DI(104), tipd_DI104);
   VitalWireDelay (DI3_ipd(9), DI(105), tipd_DI105);
   VitalWireDelay (DI3_ipd(10), DI(106), tipd_DI106);
   VitalWireDelay (DI3_ipd(11), DI(107), tipd_DI107);
   VitalWireDelay (DI3_ipd(12), DI(108), tipd_DI108);
   VitalWireDelay (DI3_ipd(13), DI(109), tipd_DI109);
   VitalWireDelay (DI3_ipd(14), DI(110), tipd_DI110);
   VitalWireDelay (DI3_ipd(15), DI(111), tipd_DI111);
   VitalWireDelay (DI3_ipd(16), DI(112), tipd_DI112);
   VitalWireDelay (DI3_ipd(17), DI(113), tipd_DI113);
   VitalWireDelay (DI3_ipd(18), DI(114), tipd_DI114);
   VitalWireDelay (DI3_ipd(19), DI(115), tipd_DI115);
   VitalWireDelay (DI3_ipd(20), DI(116), tipd_DI116);
   VitalWireDelay (DI3_ipd(21), DI(117), tipd_DI117);
   VitalWireDelay (DI3_ipd(22), DI(118), tipd_DI118);
   VitalWireDelay (DI3_ipd(23), DI(119), tipd_DI119);
   VitalWireDelay (DI3_ipd(24), DI(120), tipd_DI120);
   VitalWireDelay (DI3_ipd(25), DI(121), tipd_DI121);
   VitalWireDelay (DI3_ipd(26), DI(122), tipd_DI122);
   VitalWireDelay (DI3_ipd(27), DI(123), tipd_DI123);
   VitalWireDelay (DI3_ipd(28), DI(124), tipd_DI124);
   VitalWireDelay (DI3_ipd(29), DI(125), tipd_DI125);
   VitalWireDelay (DI3_ipd(30), DI(126), tipd_DI126);
   VitalWireDelay (DI3_ipd(31), DI(127), tipd_DI127);


   end block;

   VitalBUF (DO(0), DO0_int(0));
   VitalBUF (DO(1), DO0_int(1));
   VitalBUF (DO(2), DO0_int(2));
   VitalBUF (DO(3), DO0_int(3));
   VitalBUF (DO(4), DO0_int(4));
   VitalBUF (DO(5), DO0_int(5));
   VitalBUF (DO(6), DO0_int(6));
   VitalBUF (DO(7), DO0_int(7));
   VitalBUF (DO(8), DO0_int(8));
   VitalBUF (DO(9), DO0_int(9));
   VitalBUF (DO(10), DO0_int(10));
   VitalBUF (DO(11), DO0_int(11));
   VitalBUF (DO(12), DO0_int(12));
   VitalBUF (DO(13), DO0_int(13));
   VitalBUF (DO(14), DO0_int(14));
   VitalBUF (DO(15), DO0_int(15));
   VitalBUF (DO(16), DO0_int(16));
   VitalBUF (DO(17), DO0_int(17));
   VitalBUF (DO(18), DO0_int(18));
   VitalBUF (DO(19), DO0_int(19));
   VitalBUF (DO(20), DO0_int(20));
   VitalBUF (DO(21), DO0_int(21));
   VitalBUF (DO(22), DO0_int(22));
   VitalBUF (DO(23), DO0_int(23));
   VitalBUF (DO(24), DO0_int(24));
   VitalBUF (DO(25), DO0_int(25));
   VitalBUF (DO(26), DO0_int(26));
   VitalBUF (DO(27), DO0_int(27));
   VitalBUF (DO(28), DO0_int(28));
   VitalBUF (DO(29), DO0_int(29));
   VitalBUF (DO(30), DO0_int(30));
   VitalBUF (DO(31), DO0_int(31));
   VitalBUF (DO(32), DO1_int(0));
   VitalBUF (DO(33), DO1_int(1));
   VitalBUF (DO(34), DO1_int(2));
   VitalBUF (DO(35), DO1_int(3));
   VitalBUF (DO(36), DO1_int(4));
   VitalBUF (DO(37), DO1_int(5));
   VitalBUF (DO(38), DO1_int(6));
   VitalBUF (DO(39), DO1_int(7));
   VitalBUF (DO(40), DO1_int(8));
   VitalBUF (DO(41), DO1_int(9));
   VitalBUF (DO(42), DO1_int(10));
   VitalBUF (DO(43), DO1_int(11));
   VitalBUF (DO(44), DO1_int(12));
   VitalBUF (DO(45), DO1_int(13));
   VitalBUF (DO(46), DO1_int(14));
   VitalBUF (DO(47), DO1_int(15));
   VitalBUF (DO(48), DO1_int(16));
   VitalBUF (DO(49), DO1_int(17));
   VitalBUF (DO(50), DO1_int(18));
   VitalBUF (DO(51), DO1_int(19));
   VitalBUF (DO(52), DO1_int(20));
   VitalBUF (DO(53), DO1_int(21));
   VitalBUF (DO(54), DO1_int(22));
   VitalBUF (DO(55), DO1_int(23));
   VitalBUF (DO(56), DO1_int(24));
   VitalBUF (DO(57), DO1_int(25));
   VitalBUF (DO(58), DO1_int(26));
   VitalBUF (DO(59), DO1_int(27));
   VitalBUF (DO(60), DO1_int(28));
   VitalBUF (DO(61), DO1_int(29));
   VitalBUF (DO(62), DO1_int(30));
   VitalBUF (DO(63), DO1_int(31));
   VitalBUF (DO(64), DO2_int(0));
   VitalBUF (DO(65), DO2_int(1));
   VitalBUF (DO(66), DO2_int(2));
   VitalBUF (DO(67), DO2_int(3));
   VitalBUF (DO(68), DO2_int(4));
   VitalBUF (DO(69), DO2_int(5));
   VitalBUF (DO(70), DO2_int(6));
   VitalBUF (DO(71), DO2_int(7));
   VitalBUF (DO(72), DO2_int(8));
   VitalBUF (DO(73), DO2_int(9));
   VitalBUF (DO(74), DO2_int(10));
   VitalBUF (DO(75), DO2_int(11));
   VitalBUF (DO(76), DO2_int(12));
   VitalBUF (DO(77), DO2_int(13));
   VitalBUF (DO(78), DO2_int(14));
   VitalBUF (DO(79), DO2_int(15));
   VitalBUF (DO(80), DO2_int(16));
   VitalBUF (DO(81), DO2_int(17));
   VitalBUF (DO(82), DO2_int(18));
   VitalBUF (DO(83), DO2_int(19));
   VitalBUF (DO(84), DO2_int(20));
   VitalBUF (DO(85), DO2_int(21));
   VitalBUF (DO(86), DO2_int(22));
   VitalBUF (DO(87), DO2_int(23));
   VitalBUF (DO(88), DO2_int(24));
   VitalBUF (DO(89), DO2_int(25));
   VitalBUF (DO(90), DO2_int(26));
   VitalBUF (DO(91), DO2_int(27));
   VitalBUF (DO(92), DO2_int(28));
   VitalBUF (DO(93), DO2_int(29));
   VitalBUF (DO(94), DO2_int(30));
   VitalBUF (DO(95), DO2_int(31));
   VitalBUF (DO(96), DO3_int(0));
   VitalBUF (DO(97), DO3_int(1));
   VitalBUF (DO(98), DO3_int(2));
   VitalBUF (DO(99), DO3_int(3));
   VitalBUF (DO(100), DO3_int(4));
   VitalBUF (DO(101), DO3_int(5));
   VitalBUF (DO(102), DO3_int(6));
   VitalBUF (DO(103), DO3_int(7));
   VitalBUF (DO(104), DO3_int(8));
   VitalBUF (DO(105), DO3_int(9));
   VitalBUF (DO(106), DO3_int(10));
   VitalBUF (DO(107), DO3_int(11));
   VitalBUF (DO(108), DO3_int(12));
   VitalBUF (DO(109), DO3_int(13));
   VitalBUF (DO(110), DO3_int(14));
   VitalBUF (DO(111), DO3_int(15));
   VitalBUF (DO(112), DO3_int(16));
   VitalBUF (DO(113), DO3_int(17));
   VitalBUF (DO(114), DO3_int(18));
   VitalBUF (DO(115), DO3_int(19));
   VitalBUF (DO(116), DO3_int(20));
   VitalBUF (DO(117), DO3_int(21));
   VitalBUF (DO(118), DO3_int(22));
   VitalBUF (DO(119), DO3_int(23));
   VitalBUF (DO(120), DO3_int(24));
   VitalBUF (DO(121), DO3_int(25));
   VitalBUF (DO(122), DO3_int(26));
   VitalBUF (DO(123), DO3_int(27));
   VitalBUF (DO(124), DO3_int(28));
   VitalBUF (DO(125), DO3_int(29));
   VitalBUF (DO(126), DO3_int(30));
   VitalBUF (DO(127), DO3_int(31));

   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : PROCESS (CSB_ipd, 
                            A_ipd,
                            WEB0_ipd,
                            DI0_ipd,
                            WEB1_ipd,
                            DI1_ipd,
                            WEB2_ipd,
                            DI2_ipd,
                            WEB3_ipd,
                            DI3_ipd,
                            CK_ipd)

   -- timing check results
   VARIABLE Tviol_A0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_A1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_A2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_A3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_A4_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_A5_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_A6_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_A7_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_WEB0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_WEB1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_WEB2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_WEB3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI0_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI1_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI2_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI3_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI4_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI5_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI6_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI7_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI8_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI9_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI10_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI11_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI12_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI13_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI14_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI15_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI16_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI17_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI18_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI19_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI20_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI21_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI22_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI23_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI24_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI25_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI26_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI27_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI28_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI29_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI30_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI31_0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI0_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI1_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI2_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI3_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI4_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI5_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI6_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI7_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI8_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI9_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI10_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI11_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI12_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI13_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI14_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI15_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI16_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI17_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI18_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI19_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI20_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI21_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI22_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI23_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI24_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI25_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI26_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI27_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI28_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI29_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI30_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI31_1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI0_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI1_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI2_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI3_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI4_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI5_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI6_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI7_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI8_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI9_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI10_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI11_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI12_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI13_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI14_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI15_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI16_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI17_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI18_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI19_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI20_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI21_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI22_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI23_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI24_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI25_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI26_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI27_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI28_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI29_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI30_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI31_2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI0_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI1_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI2_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI3_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI4_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI5_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI6_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI7_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI8_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI9_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI10_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI11_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI12_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI13_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI14_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI15_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI16_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI17_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI18_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI19_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI20_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI21_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI22_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI23_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI24_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI25_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI26_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI27_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI28_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI29_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI30_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI31_3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_CSB_CK_posedge  : STD_ULOGIC := '0';



   VARIABLE Pviol_CK    : STD_ULOGIC := '0';
   VARIABLE Pdata_CK    : VitalPeriodDataType := VitalPeriodDataInit;

   VARIABLE Tmkr_A0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_A1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_A2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_A3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_A4_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_A5_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_A6_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_A7_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_WEB0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_WEB1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_WEB2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_WEB3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI0_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI1_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI2_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI3_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI4_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI5_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI6_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI7_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI8_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI9_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI10_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI11_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI12_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI13_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI14_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI15_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI16_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI17_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI18_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI19_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI20_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI21_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI22_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI23_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI24_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI25_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI26_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI27_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI28_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI29_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI30_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI31_0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI0_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI1_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI2_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI3_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI4_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI5_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI6_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI7_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI8_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI9_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI10_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI11_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI12_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI13_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI14_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI15_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI16_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI17_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI18_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI19_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI20_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI21_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI22_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI23_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI24_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI25_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI26_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI27_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI28_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI29_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI30_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI31_1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI0_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI1_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI2_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI3_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI4_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI5_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI6_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI7_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI8_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI9_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI10_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI11_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI12_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI13_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI14_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI15_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI16_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI17_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI18_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI19_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI20_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI21_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI22_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI23_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI24_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI25_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI26_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI27_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI28_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI29_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI30_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI31_2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI0_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI1_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI2_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI3_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI4_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI5_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI6_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI7_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI8_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI9_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI10_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI11_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI12_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI13_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI14_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI15_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI16_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI17_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI18_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI19_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI20_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI21_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI22_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI23_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI24_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI25_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI26_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI27_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI28_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI29_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI30_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI31_3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_CSB_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;



   VARIABLE DO0_zd : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE memoryCore0  : memoryArray;
   VARIABLE DO1_zd : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE memoryCore1  : memoryArray;
   VARIABLE DO2_zd : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE memoryCore2  : memoryArray;
   VARIABLE DO3_zd : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE memoryCore3  : memoryArray;

   VARIABLE ck_change   : std_logic_vector(1 downto 0);
   VARIABLE web0_cs      : std_logic_vector(1 downto 0);
   VARIABLE web1_cs      : std_logic_vector(1 downto 0);
   VARIABLE web2_cs      : std_logic_vector(1 downto 0);
   VARIABLE web3_cs      : std_logic_vector(1 downto 0);

   -- previous latch data
   VARIABLE Latch_A        : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE Latch_DI0       : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE Latch_WEB0      : std_logic := 'X';
   VARIABLE Latch_DI1       : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE Latch_WEB1      : std_logic := 'X';
   VARIABLE Latch_DI2       : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE Latch_WEB2      : std_logic := 'X';
   VARIABLE Latch_DI3       : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE Latch_WEB3      : std_logic := 'X';
   VARIABLE Latch_CSB       : std_logic := 'X';

   -- internal latch data
   VARIABLE A_i            : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE DI0_i           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE WEB0_i          : std_logic := 'X';
   VARIABLE DI1_i           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE WEB1_i          : std_logic := 'X';
   VARIABLE DI2_i           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE WEB2_i          : std_logic := 'X';
   VARIABLE DI3_i           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE WEB3_i          : std_logic := 'X';
   VARIABLE CSB_i           : std_logic := 'X';



   VARIABLE last_A         : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE last_DI0           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE last_WEB0   : std_logic := 'X';
   VARIABLE last_DI1           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE last_WEB1   : std_logic := 'X';
   VARIABLE last_DI2           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE last_WEB2   : std_logic := 'X';
   VARIABLE last_DI3           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE last_WEB3   : std_logic := 'X';

   VARIABLE LastClkEdge    : std_logic := 'X';

   VARIABLE flag_A: integer   := True_flg;
   VARIABLE flag_CSB: integer   := True_flg;

   
   begin

   ------------------------
   --  Timing Check Section
   ------------------------

   if (TimingChecksOn) then
         VitalSetupHoldCheck (
          Violation               => Tviol_A0_CK_posedge,
          TimingData              => Tmkr_A0_CK_posedge,
          TestSignal              => A_ipd(0),
          TestSignalName          => "A(0)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_A_CK_posedge_posedge(0),
          SetupLow                => tsetup_A_CK_negedge_posedge(0),
          HoldHigh                => thold_A_CK_negedge_posedge(0),
          HoldLow                 => thold_A_CK_posedge_posedge(0),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_A1_CK_posedge,
          TimingData              => Tmkr_A1_CK_posedge,
          TestSignal              => A_ipd(1),
          TestSignalName          => "A(1)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_A_CK_posedge_posedge(1),
          SetupLow                => tsetup_A_CK_negedge_posedge(1),
          HoldHigh                => thold_A_CK_negedge_posedge(1),
          HoldLow                 => thold_A_CK_posedge_posedge(1),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_A2_CK_posedge,
          TimingData              => Tmkr_A2_CK_posedge,
          TestSignal              => A_ipd(2),
          TestSignalName          => "A(2)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_A_CK_posedge_posedge(2),
          SetupLow                => tsetup_A_CK_negedge_posedge(2),
          HoldHigh                => thold_A_CK_negedge_posedge(2),
          HoldLow                 => thold_A_CK_posedge_posedge(2),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_A3_CK_posedge,
          TimingData              => Tmkr_A3_CK_posedge,
          TestSignal              => A_ipd(3),
          TestSignalName          => "A(3)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_A_CK_posedge_posedge(3),
          SetupLow                => tsetup_A_CK_negedge_posedge(3),
          HoldHigh                => thold_A_CK_negedge_posedge(3),
          HoldLow                 => thold_A_CK_posedge_posedge(3),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_A4_CK_posedge,
          TimingData              => Tmkr_A4_CK_posedge,
          TestSignal              => A_ipd(4),
          TestSignalName          => "A(4)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_A_CK_posedge_posedge(4),
          SetupLow                => tsetup_A_CK_negedge_posedge(4),
          HoldHigh                => thold_A_CK_negedge_posedge(4),
          HoldLow                 => thold_A_CK_posedge_posedge(4),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_A5_CK_posedge,
          TimingData              => Tmkr_A5_CK_posedge,
          TestSignal              => A_ipd(5),
          TestSignalName          => "A(5)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_A_CK_posedge_posedge(5),
          SetupLow                => tsetup_A_CK_negedge_posedge(5),
          HoldHigh                => thold_A_CK_negedge_posedge(5),
          HoldLow                 => thold_A_CK_posedge_posedge(5),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_A6_CK_posedge,
          TimingData              => Tmkr_A6_CK_posedge,
          TestSignal              => A_ipd(6),
          TestSignalName          => "A(6)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_A_CK_posedge_posedge(6),
          SetupLow                => tsetup_A_CK_negedge_posedge(6),
          HoldHigh                => thold_A_CK_negedge_posedge(6),
          HoldLow                 => thold_A_CK_posedge_posedge(6),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_A7_CK_posedge,
          TimingData              => Tmkr_A7_CK_posedge,
          TestSignal              => A_ipd(7),
          TestSignalName          => "A(7)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_A_CK_posedge_posedge(7),
          SetupLow                => tsetup_A_CK_negedge_posedge(7),
          HoldHigh                => thold_A_CK_negedge_posedge(7),
          HoldLow                 => thold_A_CK_posedge_posedge(7),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalSetupHoldCheck (
          Violation               => Tviol_WEB0_CK_posedge,
          TimingData              => Tmkr_WEB0_CK_posedge,
          TestSignal              => WEB0_ipd,
          TestSignalName          => "WEB(0)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_WEB_CK_posedge_posedge(0),
          SetupLow                => tsetup_WEB_CK_negedge_posedge(0),
          HoldHigh                => thold_WEB_CK_negedge_posedge(0),
          HoldLow                 => thold_WEB_CK_posedge_posedge(0),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_WEB1_CK_posedge,
          TimingData              => Tmkr_WEB1_CK_posedge,
          TestSignal              => WEB1_ipd,
          TestSignalName          => "WEB(1)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_WEB_CK_posedge_posedge(1),
          SetupLow                => tsetup_WEB_CK_negedge_posedge(1),
          HoldHigh                => thold_WEB_CK_negedge_posedge(1),
          HoldLow                 => thold_WEB_CK_posedge_posedge(1),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_WEB2_CK_posedge,
          TimingData              => Tmkr_WEB2_CK_posedge,
          TestSignal              => WEB2_ipd,
          TestSignalName          => "WEB(2)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_WEB_CK_posedge_posedge(2),
          SetupLow                => tsetup_WEB_CK_negedge_posedge(2),
          HoldHigh                => thold_WEB_CK_negedge_posedge(2),
          HoldLow                 => thold_WEB_CK_posedge_posedge(2),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_WEB3_CK_posedge,
          TimingData              => Tmkr_WEB3_CK_posedge,
          TestSignal              => WEB3_ipd,
          TestSignalName          => "WEB(3)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_WEB_CK_posedge_posedge(3),
          SetupLow                => tsetup_WEB_CK_negedge_posedge(3),
          HoldHigh                => thold_WEB_CK_negedge_posedge(3),
          HoldLow                 => thold_WEB_CK_posedge_posedge(3),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalSetupHoldCheck (
          Violation               => Tviol_DI0_0_CK_posedge,
          TimingData              => Tmkr_DI0_0_CK_posedge,
          TestSignal              => DI0_ipd(0),
          TestSignalName          => "DI(0)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(0),
          SetupLow                => tsetup_DI_CK_negedge_posedge(0),
          HoldHigh                => thold_DI_CK_negedge_posedge(0),
          HoldLow                 => thold_DI_CK_posedge_posedge(0),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI1_0_CK_posedge,
          TimingData              => Tmkr_DI1_0_CK_posedge,
          TestSignal              => DI0_ipd(1),
          TestSignalName          => "DI(1)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(1),
          SetupLow                => tsetup_DI_CK_negedge_posedge(1),
          HoldHigh                => thold_DI_CK_negedge_posedge(1),
          HoldLow                 => thold_DI_CK_posedge_posedge(1),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI2_0_CK_posedge,
          TimingData              => Tmkr_DI2_0_CK_posedge,
          TestSignal              => DI0_ipd(2),
          TestSignalName          => "DI(2)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(2),
          SetupLow                => tsetup_DI_CK_negedge_posedge(2),
          HoldHigh                => thold_DI_CK_negedge_posedge(2),
          HoldLow                 => thold_DI_CK_posedge_posedge(2),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI3_0_CK_posedge,
          TimingData              => Tmkr_DI3_0_CK_posedge,
          TestSignal              => DI0_ipd(3),
          TestSignalName          => "DI(3)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(3),
          SetupLow                => tsetup_DI_CK_negedge_posedge(3),
          HoldHigh                => thold_DI_CK_negedge_posedge(3),
          HoldLow                 => thold_DI_CK_posedge_posedge(3),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI4_0_CK_posedge,
          TimingData              => Tmkr_DI4_0_CK_posedge,
          TestSignal              => DI0_ipd(4),
          TestSignalName          => "DI(4)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(4),
          SetupLow                => tsetup_DI_CK_negedge_posedge(4),
          HoldHigh                => thold_DI_CK_negedge_posedge(4),
          HoldLow                 => thold_DI_CK_posedge_posedge(4),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI5_0_CK_posedge,
          TimingData              => Tmkr_DI5_0_CK_posedge,
          TestSignal              => DI0_ipd(5),
          TestSignalName          => "DI(5)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(5),
          SetupLow                => tsetup_DI_CK_negedge_posedge(5),
          HoldHigh                => thold_DI_CK_negedge_posedge(5),
          HoldLow                 => thold_DI_CK_posedge_posedge(5),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI6_0_CK_posedge,
          TimingData              => Tmkr_DI6_0_CK_posedge,
          TestSignal              => DI0_ipd(6),
          TestSignalName          => "DI(6)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(6),
          SetupLow                => tsetup_DI_CK_negedge_posedge(6),
          HoldHigh                => thold_DI_CK_negedge_posedge(6),
          HoldLow                 => thold_DI_CK_posedge_posedge(6),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI7_0_CK_posedge,
          TimingData              => Tmkr_DI7_0_CK_posedge,
          TestSignal              => DI0_ipd(7),
          TestSignalName          => "DI(7)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(7),
          SetupLow                => tsetup_DI_CK_negedge_posedge(7),
          HoldHigh                => thold_DI_CK_negedge_posedge(7),
          HoldLow                 => thold_DI_CK_posedge_posedge(7),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI8_0_CK_posedge,
          TimingData              => Tmkr_DI8_0_CK_posedge,
          TestSignal              => DI0_ipd(8),
          TestSignalName          => "DI(8)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(8),
          SetupLow                => tsetup_DI_CK_negedge_posedge(8),
          HoldHigh                => thold_DI_CK_negedge_posedge(8),
          HoldLow                 => thold_DI_CK_posedge_posedge(8),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI9_0_CK_posedge,
          TimingData              => Tmkr_DI9_0_CK_posedge,
          TestSignal              => DI0_ipd(9),
          TestSignalName          => "DI(9)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(9),
          SetupLow                => tsetup_DI_CK_negedge_posedge(9),
          HoldHigh                => thold_DI_CK_negedge_posedge(9),
          HoldLow                 => thold_DI_CK_posedge_posedge(9),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI10_0_CK_posedge,
          TimingData              => Tmkr_DI10_0_CK_posedge,
          TestSignal              => DI0_ipd(10),
          TestSignalName          => "DI(10)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(10),
          SetupLow                => tsetup_DI_CK_negedge_posedge(10),
          HoldHigh                => thold_DI_CK_negedge_posedge(10),
          HoldLow                 => thold_DI_CK_posedge_posedge(10),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI11_0_CK_posedge,
          TimingData              => Tmkr_DI11_0_CK_posedge,
          TestSignal              => DI0_ipd(11),
          TestSignalName          => "DI(11)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(11),
          SetupLow                => tsetup_DI_CK_negedge_posedge(11),
          HoldHigh                => thold_DI_CK_negedge_posedge(11),
          HoldLow                 => thold_DI_CK_posedge_posedge(11),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI12_0_CK_posedge,
          TimingData              => Tmkr_DI12_0_CK_posedge,
          TestSignal              => DI0_ipd(12),
          TestSignalName          => "DI(12)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(12),
          SetupLow                => tsetup_DI_CK_negedge_posedge(12),
          HoldHigh                => thold_DI_CK_negedge_posedge(12),
          HoldLow                 => thold_DI_CK_posedge_posedge(12),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI13_0_CK_posedge,
          TimingData              => Tmkr_DI13_0_CK_posedge,
          TestSignal              => DI0_ipd(13),
          TestSignalName          => "DI(13)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(13),
          SetupLow                => tsetup_DI_CK_negedge_posedge(13),
          HoldHigh                => thold_DI_CK_negedge_posedge(13),
          HoldLow                 => thold_DI_CK_posedge_posedge(13),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI14_0_CK_posedge,
          TimingData              => Tmkr_DI14_0_CK_posedge,
          TestSignal              => DI0_ipd(14),
          TestSignalName          => "DI(14)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(14),
          SetupLow                => tsetup_DI_CK_negedge_posedge(14),
          HoldHigh                => thold_DI_CK_negedge_posedge(14),
          HoldLow                 => thold_DI_CK_posedge_posedge(14),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI15_0_CK_posedge,
          TimingData              => Tmkr_DI15_0_CK_posedge,
          TestSignal              => DI0_ipd(15),
          TestSignalName          => "DI(15)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(15),
          SetupLow                => tsetup_DI_CK_negedge_posedge(15),
          HoldHigh                => thold_DI_CK_negedge_posedge(15),
          HoldLow                 => thold_DI_CK_posedge_posedge(15),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI16_0_CK_posedge,
          TimingData              => Tmkr_DI16_0_CK_posedge,
          TestSignal              => DI0_ipd(16),
          TestSignalName          => "DI(16)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(16),
          SetupLow                => tsetup_DI_CK_negedge_posedge(16),
          HoldHigh                => thold_DI_CK_negedge_posedge(16),
          HoldLow                 => thold_DI_CK_posedge_posedge(16),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI17_0_CK_posedge,
          TimingData              => Tmkr_DI17_0_CK_posedge,
          TestSignal              => DI0_ipd(17),
          TestSignalName          => "DI(17)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(17),
          SetupLow                => tsetup_DI_CK_negedge_posedge(17),
          HoldHigh                => thold_DI_CK_negedge_posedge(17),
          HoldLow                 => thold_DI_CK_posedge_posedge(17),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI18_0_CK_posedge,
          TimingData              => Tmkr_DI18_0_CK_posedge,
          TestSignal              => DI0_ipd(18),
          TestSignalName          => "DI(18)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(18),
          SetupLow                => tsetup_DI_CK_negedge_posedge(18),
          HoldHigh                => thold_DI_CK_negedge_posedge(18),
          HoldLow                 => thold_DI_CK_posedge_posedge(18),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI19_0_CK_posedge,
          TimingData              => Tmkr_DI19_0_CK_posedge,
          TestSignal              => DI0_ipd(19),
          TestSignalName          => "DI(19)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(19),
          SetupLow                => tsetup_DI_CK_negedge_posedge(19),
          HoldHigh                => thold_DI_CK_negedge_posedge(19),
          HoldLow                 => thold_DI_CK_posedge_posedge(19),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI20_0_CK_posedge,
          TimingData              => Tmkr_DI20_0_CK_posedge,
          TestSignal              => DI0_ipd(20),
          TestSignalName          => "DI(20)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(20),
          SetupLow                => tsetup_DI_CK_negedge_posedge(20),
          HoldHigh                => thold_DI_CK_negedge_posedge(20),
          HoldLow                 => thold_DI_CK_posedge_posedge(20),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI21_0_CK_posedge,
          TimingData              => Tmkr_DI21_0_CK_posedge,
          TestSignal              => DI0_ipd(21),
          TestSignalName          => "DI(21)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(21),
          SetupLow                => tsetup_DI_CK_negedge_posedge(21),
          HoldHigh                => thold_DI_CK_negedge_posedge(21),
          HoldLow                 => thold_DI_CK_posedge_posedge(21),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI22_0_CK_posedge,
          TimingData              => Tmkr_DI22_0_CK_posedge,
          TestSignal              => DI0_ipd(22),
          TestSignalName          => "DI(22)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(22),
          SetupLow                => tsetup_DI_CK_negedge_posedge(22),
          HoldHigh                => thold_DI_CK_negedge_posedge(22),
          HoldLow                 => thold_DI_CK_posedge_posedge(22),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI23_0_CK_posedge,
          TimingData              => Tmkr_DI23_0_CK_posedge,
          TestSignal              => DI0_ipd(23),
          TestSignalName          => "DI(23)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(23),
          SetupLow                => tsetup_DI_CK_negedge_posedge(23),
          HoldHigh                => thold_DI_CK_negedge_posedge(23),
          HoldLow                 => thold_DI_CK_posedge_posedge(23),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI24_0_CK_posedge,
          TimingData              => Tmkr_DI24_0_CK_posedge,
          TestSignal              => DI0_ipd(24),
          TestSignalName          => "DI(24)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(24),
          SetupLow                => tsetup_DI_CK_negedge_posedge(24),
          HoldHigh                => thold_DI_CK_negedge_posedge(24),
          HoldLow                 => thold_DI_CK_posedge_posedge(24),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI25_0_CK_posedge,
          TimingData              => Tmkr_DI25_0_CK_posedge,
          TestSignal              => DI0_ipd(25),
          TestSignalName          => "DI(25)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(25),
          SetupLow                => tsetup_DI_CK_negedge_posedge(25),
          HoldHigh                => thold_DI_CK_negedge_posedge(25),
          HoldLow                 => thold_DI_CK_posedge_posedge(25),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI26_0_CK_posedge,
          TimingData              => Tmkr_DI26_0_CK_posedge,
          TestSignal              => DI0_ipd(26),
          TestSignalName          => "DI(26)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(26),
          SetupLow                => tsetup_DI_CK_negedge_posedge(26),
          HoldHigh                => thold_DI_CK_negedge_posedge(26),
          HoldLow                 => thold_DI_CK_posedge_posedge(26),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI27_0_CK_posedge,
          TimingData              => Tmkr_DI27_0_CK_posedge,
          TestSignal              => DI0_ipd(27),
          TestSignalName          => "DI(27)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(27),
          SetupLow                => tsetup_DI_CK_negedge_posedge(27),
          HoldHigh                => thold_DI_CK_negedge_posedge(27),
          HoldLow                 => thold_DI_CK_posedge_posedge(27),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI28_0_CK_posedge,
          TimingData              => Tmkr_DI28_0_CK_posedge,
          TestSignal              => DI0_ipd(28),
          TestSignalName          => "DI(28)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(28),
          SetupLow                => tsetup_DI_CK_negedge_posedge(28),
          HoldHigh                => thold_DI_CK_negedge_posedge(28),
          HoldLow                 => thold_DI_CK_posedge_posedge(28),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI29_0_CK_posedge,
          TimingData              => Tmkr_DI29_0_CK_posedge,
          TestSignal              => DI0_ipd(29),
          TestSignalName          => "DI(29)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(29),
          SetupLow                => tsetup_DI_CK_negedge_posedge(29),
          HoldHigh                => thold_DI_CK_negedge_posedge(29),
          HoldLow                 => thold_DI_CK_posedge_posedge(29),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI30_0_CK_posedge,
          TimingData              => Tmkr_DI30_0_CK_posedge,
          TestSignal              => DI0_ipd(30),
          TestSignalName          => "DI(30)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(30),
          SetupLow                => tsetup_DI_CK_negedge_posedge(30),
          HoldHigh                => thold_DI_CK_negedge_posedge(30),
          HoldLow                 => thold_DI_CK_posedge_posedge(30),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI31_0_CK_posedge,
          TimingData              => Tmkr_DI31_0_CK_posedge,
          TestSignal              => DI0_ipd(31),
          TestSignalName          => "DI(31)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(31),
          SetupLow                => tsetup_DI_CK_negedge_posedge(31),
          HoldHigh                => thold_DI_CK_negedge_posedge(31),
          HoldLow                 => thold_DI_CK_posedge_posedge(31),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB0_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI0_1_CK_posedge,
          TimingData              => Tmkr_DI0_1_CK_posedge,
          TestSignal              => DI1_ipd(0),
          TestSignalName          => "DI(32)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(32),
          SetupLow                => tsetup_DI_CK_negedge_posedge(32),
          HoldHigh                => thold_DI_CK_negedge_posedge(32),
          HoldLow                 => thold_DI_CK_posedge_posedge(32),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI1_1_CK_posedge,
          TimingData              => Tmkr_DI1_1_CK_posedge,
          TestSignal              => DI1_ipd(1),
          TestSignalName          => "DI(33)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(33),
          SetupLow                => tsetup_DI_CK_negedge_posedge(33),
          HoldHigh                => thold_DI_CK_negedge_posedge(33),
          HoldLow                 => thold_DI_CK_posedge_posedge(33),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI2_1_CK_posedge,
          TimingData              => Tmkr_DI2_1_CK_posedge,
          TestSignal              => DI1_ipd(2),
          TestSignalName          => "DI(34)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(34),
          SetupLow                => tsetup_DI_CK_negedge_posedge(34),
          HoldHigh                => thold_DI_CK_negedge_posedge(34),
          HoldLow                 => thold_DI_CK_posedge_posedge(34),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI3_1_CK_posedge,
          TimingData              => Tmkr_DI3_1_CK_posedge,
          TestSignal              => DI1_ipd(3),
          TestSignalName          => "DI(35)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(35),
          SetupLow                => tsetup_DI_CK_negedge_posedge(35),
          HoldHigh                => thold_DI_CK_negedge_posedge(35),
          HoldLow                 => thold_DI_CK_posedge_posedge(35),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI4_1_CK_posedge,
          TimingData              => Tmkr_DI4_1_CK_posedge,
          TestSignal              => DI1_ipd(4),
          TestSignalName          => "DI(36)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(36),
          SetupLow                => tsetup_DI_CK_negedge_posedge(36),
          HoldHigh                => thold_DI_CK_negedge_posedge(36),
          HoldLow                 => thold_DI_CK_posedge_posedge(36),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI5_1_CK_posedge,
          TimingData              => Tmkr_DI5_1_CK_posedge,
          TestSignal              => DI1_ipd(5),
          TestSignalName          => "DI(37)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(37),
          SetupLow                => tsetup_DI_CK_negedge_posedge(37),
          HoldHigh                => thold_DI_CK_negedge_posedge(37),
          HoldLow                 => thold_DI_CK_posedge_posedge(37),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI6_1_CK_posedge,
          TimingData              => Tmkr_DI6_1_CK_posedge,
          TestSignal              => DI1_ipd(6),
          TestSignalName          => "DI(38)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(38),
          SetupLow                => tsetup_DI_CK_negedge_posedge(38),
          HoldHigh                => thold_DI_CK_negedge_posedge(38),
          HoldLow                 => thold_DI_CK_posedge_posedge(38),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI7_1_CK_posedge,
          TimingData              => Tmkr_DI7_1_CK_posedge,
          TestSignal              => DI1_ipd(7),
          TestSignalName          => "DI(39)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(39),
          SetupLow                => tsetup_DI_CK_negedge_posedge(39),
          HoldHigh                => thold_DI_CK_negedge_posedge(39),
          HoldLow                 => thold_DI_CK_posedge_posedge(39),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI8_1_CK_posedge,
          TimingData              => Tmkr_DI8_1_CK_posedge,
          TestSignal              => DI1_ipd(8),
          TestSignalName          => "DI(40)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(40),
          SetupLow                => tsetup_DI_CK_negedge_posedge(40),
          HoldHigh                => thold_DI_CK_negedge_posedge(40),
          HoldLow                 => thold_DI_CK_posedge_posedge(40),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI9_1_CK_posedge,
          TimingData              => Tmkr_DI9_1_CK_posedge,
          TestSignal              => DI1_ipd(9),
          TestSignalName          => "DI(41)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(41),
          SetupLow                => tsetup_DI_CK_negedge_posedge(41),
          HoldHigh                => thold_DI_CK_negedge_posedge(41),
          HoldLow                 => thold_DI_CK_posedge_posedge(41),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI10_1_CK_posedge,
          TimingData              => Tmkr_DI10_1_CK_posedge,
          TestSignal              => DI1_ipd(10),
          TestSignalName          => "DI(42)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(42),
          SetupLow                => tsetup_DI_CK_negedge_posedge(42),
          HoldHigh                => thold_DI_CK_negedge_posedge(42),
          HoldLow                 => thold_DI_CK_posedge_posedge(42),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI11_1_CK_posedge,
          TimingData              => Tmkr_DI11_1_CK_posedge,
          TestSignal              => DI1_ipd(11),
          TestSignalName          => "DI(43)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(43),
          SetupLow                => tsetup_DI_CK_negedge_posedge(43),
          HoldHigh                => thold_DI_CK_negedge_posedge(43),
          HoldLow                 => thold_DI_CK_posedge_posedge(43),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI12_1_CK_posedge,
          TimingData              => Tmkr_DI12_1_CK_posedge,
          TestSignal              => DI1_ipd(12),
          TestSignalName          => "DI(44)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(44),
          SetupLow                => tsetup_DI_CK_negedge_posedge(44),
          HoldHigh                => thold_DI_CK_negedge_posedge(44),
          HoldLow                 => thold_DI_CK_posedge_posedge(44),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI13_1_CK_posedge,
          TimingData              => Tmkr_DI13_1_CK_posedge,
          TestSignal              => DI1_ipd(13),
          TestSignalName          => "DI(45)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(45),
          SetupLow                => tsetup_DI_CK_negedge_posedge(45),
          HoldHigh                => thold_DI_CK_negedge_posedge(45),
          HoldLow                 => thold_DI_CK_posedge_posedge(45),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI14_1_CK_posedge,
          TimingData              => Tmkr_DI14_1_CK_posedge,
          TestSignal              => DI1_ipd(14),
          TestSignalName          => "DI(46)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(46),
          SetupLow                => tsetup_DI_CK_negedge_posedge(46),
          HoldHigh                => thold_DI_CK_negedge_posedge(46),
          HoldLow                 => thold_DI_CK_posedge_posedge(46),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI15_1_CK_posedge,
          TimingData              => Tmkr_DI15_1_CK_posedge,
          TestSignal              => DI1_ipd(15),
          TestSignalName          => "DI(47)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(47),
          SetupLow                => tsetup_DI_CK_negedge_posedge(47),
          HoldHigh                => thold_DI_CK_negedge_posedge(47),
          HoldLow                 => thold_DI_CK_posedge_posedge(47),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI16_1_CK_posedge,
          TimingData              => Tmkr_DI16_1_CK_posedge,
          TestSignal              => DI1_ipd(16),
          TestSignalName          => "DI(48)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(48),
          SetupLow                => tsetup_DI_CK_negedge_posedge(48),
          HoldHigh                => thold_DI_CK_negedge_posedge(48),
          HoldLow                 => thold_DI_CK_posedge_posedge(48),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI17_1_CK_posedge,
          TimingData              => Tmkr_DI17_1_CK_posedge,
          TestSignal              => DI1_ipd(17),
          TestSignalName          => "DI(49)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(49),
          SetupLow                => tsetup_DI_CK_negedge_posedge(49),
          HoldHigh                => thold_DI_CK_negedge_posedge(49),
          HoldLow                 => thold_DI_CK_posedge_posedge(49),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI18_1_CK_posedge,
          TimingData              => Tmkr_DI18_1_CK_posedge,
          TestSignal              => DI1_ipd(18),
          TestSignalName          => "DI(50)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(50),
          SetupLow                => tsetup_DI_CK_negedge_posedge(50),
          HoldHigh                => thold_DI_CK_negedge_posedge(50),
          HoldLow                 => thold_DI_CK_posedge_posedge(50),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI19_1_CK_posedge,
          TimingData              => Tmkr_DI19_1_CK_posedge,
          TestSignal              => DI1_ipd(19),
          TestSignalName          => "DI(51)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(51),
          SetupLow                => tsetup_DI_CK_negedge_posedge(51),
          HoldHigh                => thold_DI_CK_negedge_posedge(51),
          HoldLow                 => thold_DI_CK_posedge_posedge(51),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI20_1_CK_posedge,
          TimingData              => Tmkr_DI20_1_CK_posedge,
          TestSignal              => DI1_ipd(20),
          TestSignalName          => "DI(52)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(52),
          SetupLow                => tsetup_DI_CK_negedge_posedge(52),
          HoldHigh                => thold_DI_CK_negedge_posedge(52),
          HoldLow                 => thold_DI_CK_posedge_posedge(52),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI21_1_CK_posedge,
          TimingData              => Tmkr_DI21_1_CK_posedge,
          TestSignal              => DI1_ipd(21),
          TestSignalName          => "DI(53)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(53),
          SetupLow                => tsetup_DI_CK_negedge_posedge(53),
          HoldHigh                => thold_DI_CK_negedge_posedge(53),
          HoldLow                 => thold_DI_CK_posedge_posedge(53),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI22_1_CK_posedge,
          TimingData              => Tmkr_DI22_1_CK_posedge,
          TestSignal              => DI1_ipd(22),
          TestSignalName          => "DI(54)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(54),
          SetupLow                => tsetup_DI_CK_negedge_posedge(54),
          HoldHigh                => thold_DI_CK_negedge_posedge(54),
          HoldLow                 => thold_DI_CK_posedge_posedge(54),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI23_1_CK_posedge,
          TimingData              => Tmkr_DI23_1_CK_posedge,
          TestSignal              => DI1_ipd(23),
          TestSignalName          => "DI(55)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(55),
          SetupLow                => tsetup_DI_CK_negedge_posedge(55),
          HoldHigh                => thold_DI_CK_negedge_posedge(55),
          HoldLow                 => thold_DI_CK_posedge_posedge(55),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI24_1_CK_posedge,
          TimingData              => Tmkr_DI24_1_CK_posedge,
          TestSignal              => DI1_ipd(24),
          TestSignalName          => "DI(56)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(56),
          SetupLow                => tsetup_DI_CK_negedge_posedge(56),
          HoldHigh                => thold_DI_CK_negedge_posedge(56),
          HoldLow                 => thold_DI_CK_posedge_posedge(56),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI25_1_CK_posedge,
          TimingData              => Tmkr_DI25_1_CK_posedge,
          TestSignal              => DI1_ipd(25),
          TestSignalName          => "DI(57)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(57),
          SetupLow                => tsetup_DI_CK_negedge_posedge(57),
          HoldHigh                => thold_DI_CK_negedge_posedge(57),
          HoldLow                 => thold_DI_CK_posedge_posedge(57),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI26_1_CK_posedge,
          TimingData              => Tmkr_DI26_1_CK_posedge,
          TestSignal              => DI1_ipd(26),
          TestSignalName          => "DI(58)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(58),
          SetupLow                => tsetup_DI_CK_negedge_posedge(58),
          HoldHigh                => thold_DI_CK_negedge_posedge(58),
          HoldLow                 => thold_DI_CK_posedge_posedge(58),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI27_1_CK_posedge,
          TimingData              => Tmkr_DI27_1_CK_posedge,
          TestSignal              => DI1_ipd(27),
          TestSignalName          => "DI(59)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(59),
          SetupLow                => tsetup_DI_CK_negedge_posedge(59),
          HoldHigh                => thold_DI_CK_negedge_posedge(59),
          HoldLow                 => thold_DI_CK_posedge_posedge(59),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI28_1_CK_posedge,
          TimingData              => Tmkr_DI28_1_CK_posedge,
          TestSignal              => DI1_ipd(28),
          TestSignalName          => "DI(60)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(60),
          SetupLow                => tsetup_DI_CK_negedge_posedge(60),
          HoldHigh                => thold_DI_CK_negedge_posedge(60),
          HoldLow                 => thold_DI_CK_posedge_posedge(60),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI29_1_CK_posedge,
          TimingData              => Tmkr_DI29_1_CK_posedge,
          TestSignal              => DI1_ipd(29),
          TestSignalName          => "DI(61)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(61),
          SetupLow                => tsetup_DI_CK_negedge_posedge(61),
          HoldHigh                => thold_DI_CK_negedge_posedge(61),
          HoldLow                 => thold_DI_CK_posedge_posedge(61),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI30_1_CK_posedge,
          TimingData              => Tmkr_DI30_1_CK_posedge,
          TestSignal              => DI1_ipd(30),
          TestSignalName          => "DI(62)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(62),
          SetupLow                => tsetup_DI_CK_negedge_posedge(62),
          HoldHigh                => thold_DI_CK_negedge_posedge(62),
          HoldLow                 => thold_DI_CK_posedge_posedge(62),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI31_1_CK_posedge,
          TimingData              => Tmkr_DI31_1_CK_posedge,
          TestSignal              => DI1_ipd(31),
          TestSignalName          => "DI(63)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(63),
          SetupLow                => tsetup_DI_CK_negedge_posedge(63),
          HoldHigh                => thold_DI_CK_negedge_posedge(63),
          HoldLow                 => thold_DI_CK_posedge_posedge(63),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB1_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI0_2_CK_posedge,
          TimingData              => Tmkr_DI0_2_CK_posedge,
          TestSignal              => DI2_ipd(0),
          TestSignalName          => "DI(64)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(64),
          SetupLow                => tsetup_DI_CK_negedge_posedge(64),
          HoldHigh                => thold_DI_CK_negedge_posedge(64),
          HoldLow                 => thold_DI_CK_posedge_posedge(64),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI1_2_CK_posedge,
          TimingData              => Tmkr_DI1_2_CK_posedge,
          TestSignal              => DI2_ipd(1),
          TestSignalName          => "DI(65)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(65),
          SetupLow                => tsetup_DI_CK_negedge_posedge(65),
          HoldHigh                => thold_DI_CK_negedge_posedge(65),
          HoldLow                 => thold_DI_CK_posedge_posedge(65),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI2_2_CK_posedge,
          TimingData              => Tmkr_DI2_2_CK_posedge,
          TestSignal              => DI2_ipd(2),
          TestSignalName          => "DI(66)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(66),
          SetupLow                => tsetup_DI_CK_negedge_posedge(66),
          HoldHigh                => thold_DI_CK_negedge_posedge(66),
          HoldLow                 => thold_DI_CK_posedge_posedge(66),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI3_2_CK_posedge,
          TimingData              => Tmkr_DI3_2_CK_posedge,
          TestSignal              => DI2_ipd(3),
          TestSignalName          => "DI(67)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(67),
          SetupLow                => tsetup_DI_CK_negedge_posedge(67),
          HoldHigh                => thold_DI_CK_negedge_posedge(67),
          HoldLow                 => thold_DI_CK_posedge_posedge(67),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI4_2_CK_posedge,
          TimingData              => Tmkr_DI4_2_CK_posedge,
          TestSignal              => DI2_ipd(4),
          TestSignalName          => "DI(68)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(68),
          SetupLow                => tsetup_DI_CK_negedge_posedge(68),
          HoldHigh                => thold_DI_CK_negedge_posedge(68),
          HoldLow                 => thold_DI_CK_posedge_posedge(68),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI5_2_CK_posedge,
          TimingData              => Tmkr_DI5_2_CK_posedge,
          TestSignal              => DI2_ipd(5),
          TestSignalName          => "DI(69)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(69),
          SetupLow                => tsetup_DI_CK_negedge_posedge(69),
          HoldHigh                => thold_DI_CK_negedge_posedge(69),
          HoldLow                 => thold_DI_CK_posedge_posedge(69),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI6_2_CK_posedge,
          TimingData              => Tmkr_DI6_2_CK_posedge,
          TestSignal              => DI2_ipd(6),
          TestSignalName          => "DI(70)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(70),
          SetupLow                => tsetup_DI_CK_negedge_posedge(70),
          HoldHigh                => thold_DI_CK_negedge_posedge(70),
          HoldLow                 => thold_DI_CK_posedge_posedge(70),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI7_2_CK_posedge,
          TimingData              => Tmkr_DI7_2_CK_posedge,
          TestSignal              => DI2_ipd(7),
          TestSignalName          => "DI(71)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(71),
          SetupLow                => tsetup_DI_CK_negedge_posedge(71),
          HoldHigh                => thold_DI_CK_negedge_posedge(71),
          HoldLow                 => thold_DI_CK_posedge_posedge(71),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI8_2_CK_posedge,
          TimingData              => Tmkr_DI8_2_CK_posedge,
          TestSignal              => DI2_ipd(8),
          TestSignalName          => "DI(72)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(72),
          SetupLow                => tsetup_DI_CK_negedge_posedge(72),
          HoldHigh                => thold_DI_CK_negedge_posedge(72),
          HoldLow                 => thold_DI_CK_posedge_posedge(72),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI9_2_CK_posedge,
          TimingData              => Tmkr_DI9_2_CK_posedge,
          TestSignal              => DI2_ipd(9),
          TestSignalName          => "DI(73)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(73),
          SetupLow                => tsetup_DI_CK_negedge_posedge(73),
          HoldHigh                => thold_DI_CK_negedge_posedge(73),
          HoldLow                 => thold_DI_CK_posedge_posedge(73),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI10_2_CK_posedge,
          TimingData              => Tmkr_DI10_2_CK_posedge,
          TestSignal              => DI2_ipd(10),
          TestSignalName          => "DI(74)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(74),
          SetupLow                => tsetup_DI_CK_negedge_posedge(74),
          HoldHigh                => thold_DI_CK_negedge_posedge(74),
          HoldLow                 => thold_DI_CK_posedge_posedge(74),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI11_2_CK_posedge,
          TimingData              => Tmkr_DI11_2_CK_posedge,
          TestSignal              => DI2_ipd(11),
          TestSignalName          => "DI(75)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(75),
          SetupLow                => tsetup_DI_CK_negedge_posedge(75),
          HoldHigh                => thold_DI_CK_negedge_posedge(75),
          HoldLow                 => thold_DI_CK_posedge_posedge(75),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI12_2_CK_posedge,
          TimingData              => Tmkr_DI12_2_CK_posedge,
          TestSignal              => DI2_ipd(12),
          TestSignalName          => "DI(76)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(76),
          SetupLow                => tsetup_DI_CK_negedge_posedge(76),
          HoldHigh                => thold_DI_CK_negedge_posedge(76),
          HoldLow                 => thold_DI_CK_posedge_posedge(76),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI13_2_CK_posedge,
          TimingData              => Tmkr_DI13_2_CK_posedge,
          TestSignal              => DI2_ipd(13),
          TestSignalName          => "DI(77)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(77),
          SetupLow                => tsetup_DI_CK_negedge_posedge(77),
          HoldHigh                => thold_DI_CK_negedge_posedge(77),
          HoldLow                 => thold_DI_CK_posedge_posedge(77),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI14_2_CK_posedge,
          TimingData              => Tmkr_DI14_2_CK_posedge,
          TestSignal              => DI2_ipd(14),
          TestSignalName          => "DI(78)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(78),
          SetupLow                => tsetup_DI_CK_negedge_posedge(78),
          HoldHigh                => thold_DI_CK_negedge_posedge(78),
          HoldLow                 => thold_DI_CK_posedge_posedge(78),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI15_2_CK_posedge,
          TimingData              => Tmkr_DI15_2_CK_posedge,
          TestSignal              => DI2_ipd(15),
          TestSignalName          => "DI(79)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(79),
          SetupLow                => tsetup_DI_CK_negedge_posedge(79),
          HoldHigh                => thold_DI_CK_negedge_posedge(79),
          HoldLow                 => thold_DI_CK_posedge_posedge(79),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI16_2_CK_posedge,
          TimingData              => Tmkr_DI16_2_CK_posedge,
          TestSignal              => DI2_ipd(16),
          TestSignalName          => "DI(80)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(80),
          SetupLow                => tsetup_DI_CK_negedge_posedge(80),
          HoldHigh                => thold_DI_CK_negedge_posedge(80),
          HoldLow                 => thold_DI_CK_posedge_posedge(80),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI17_2_CK_posedge,
          TimingData              => Tmkr_DI17_2_CK_posedge,
          TestSignal              => DI2_ipd(17),
          TestSignalName          => "DI(81)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(81),
          SetupLow                => tsetup_DI_CK_negedge_posedge(81),
          HoldHigh                => thold_DI_CK_negedge_posedge(81),
          HoldLow                 => thold_DI_CK_posedge_posedge(81),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI18_2_CK_posedge,
          TimingData              => Tmkr_DI18_2_CK_posedge,
          TestSignal              => DI2_ipd(18),
          TestSignalName          => "DI(82)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(82),
          SetupLow                => tsetup_DI_CK_negedge_posedge(82),
          HoldHigh                => thold_DI_CK_negedge_posedge(82),
          HoldLow                 => thold_DI_CK_posedge_posedge(82),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI19_2_CK_posedge,
          TimingData              => Tmkr_DI19_2_CK_posedge,
          TestSignal              => DI2_ipd(19),
          TestSignalName          => "DI(83)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(83),
          SetupLow                => tsetup_DI_CK_negedge_posedge(83),
          HoldHigh                => thold_DI_CK_negedge_posedge(83),
          HoldLow                 => thold_DI_CK_posedge_posedge(83),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI20_2_CK_posedge,
          TimingData              => Tmkr_DI20_2_CK_posedge,
          TestSignal              => DI2_ipd(20),
          TestSignalName          => "DI(84)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(84),
          SetupLow                => tsetup_DI_CK_negedge_posedge(84),
          HoldHigh                => thold_DI_CK_negedge_posedge(84),
          HoldLow                 => thold_DI_CK_posedge_posedge(84),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI21_2_CK_posedge,
          TimingData              => Tmkr_DI21_2_CK_posedge,
          TestSignal              => DI2_ipd(21),
          TestSignalName          => "DI(85)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(85),
          SetupLow                => tsetup_DI_CK_negedge_posedge(85),
          HoldHigh                => thold_DI_CK_negedge_posedge(85),
          HoldLow                 => thold_DI_CK_posedge_posedge(85),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI22_2_CK_posedge,
          TimingData              => Tmkr_DI22_2_CK_posedge,
          TestSignal              => DI2_ipd(22),
          TestSignalName          => "DI(86)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(86),
          SetupLow                => tsetup_DI_CK_negedge_posedge(86),
          HoldHigh                => thold_DI_CK_negedge_posedge(86),
          HoldLow                 => thold_DI_CK_posedge_posedge(86),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI23_2_CK_posedge,
          TimingData              => Tmkr_DI23_2_CK_posedge,
          TestSignal              => DI2_ipd(23),
          TestSignalName          => "DI(87)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(87),
          SetupLow                => tsetup_DI_CK_negedge_posedge(87),
          HoldHigh                => thold_DI_CK_negedge_posedge(87),
          HoldLow                 => thold_DI_CK_posedge_posedge(87),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI24_2_CK_posedge,
          TimingData              => Tmkr_DI24_2_CK_posedge,
          TestSignal              => DI2_ipd(24),
          TestSignalName          => "DI(88)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(88),
          SetupLow                => tsetup_DI_CK_negedge_posedge(88),
          HoldHigh                => thold_DI_CK_negedge_posedge(88),
          HoldLow                 => thold_DI_CK_posedge_posedge(88),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI25_2_CK_posedge,
          TimingData              => Tmkr_DI25_2_CK_posedge,
          TestSignal              => DI2_ipd(25),
          TestSignalName          => "DI(89)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(89),
          SetupLow                => tsetup_DI_CK_negedge_posedge(89),
          HoldHigh                => thold_DI_CK_negedge_posedge(89),
          HoldLow                 => thold_DI_CK_posedge_posedge(89),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI26_2_CK_posedge,
          TimingData              => Tmkr_DI26_2_CK_posedge,
          TestSignal              => DI2_ipd(26),
          TestSignalName          => "DI(90)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(90),
          SetupLow                => tsetup_DI_CK_negedge_posedge(90),
          HoldHigh                => thold_DI_CK_negedge_posedge(90),
          HoldLow                 => thold_DI_CK_posedge_posedge(90),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI27_2_CK_posedge,
          TimingData              => Tmkr_DI27_2_CK_posedge,
          TestSignal              => DI2_ipd(27),
          TestSignalName          => "DI(91)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(91),
          SetupLow                => tsetup_DI_CK_negedge_posedge(91),
          HoldHigh                => thold_DI_CK_negedge_posedge(91),
          HoldLow                 => thold_DI_CK_posedge_posedge(91),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI28_2_CK_posedge,
          TimingData              => Tmkr_DI28_2_CK_posedge,
          TestSignal              => DI2_ipd(28),
          TestSignalName          => "DI(92)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(92),
          SetupLow                => tsetup_DI_CK_negedge_posedge(92),
          HoldHigh                => thold_DI_CK_negedge_posedge(92),
          HoldLow                 => thold_DI_CK_posedge_posedge(92),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI29_2_CK_posedge,
          TimingData              => Tmkr_DI29_2_CK_posedge,
          TestSignal              => DI2_ipd(29),
          TestSignalName          => "DI(93)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(93),
          SetupLow                => tsetup_DI_CK_negedge_posedge(93),
          HoldHigh                => thold_DI_CK_negedge_posedge(93),
          HoldLow                 => thold_DI_CK_posedge_posedge(93),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI30_2_CK_posedge,
          TimingData              => Tmkr_DI30_2_CK_posedge,
          TestSignal              => DI2_ipd(30),
          TestSignalName          => "DI(94)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(94),
          SetupLow                => tsetup_DI_CK_negedge_posedge(94),
          HoldHigh                => thold_DI_CK_negedge_posedge(94),
          HoldLow                 => thold_DI_CK_posedge_posedge(94),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI31_2_CK_posedge,
          TimingData              => Tmkr_DI31_2_CK_posedge,
          TestSignal              => DI2_ipd(31),
          TestSignalName          => "DI(95)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(95),
          SetupLow                => tsetup_DI_CK_negedge_posedge(95),
          HoldHigh                => thold_DI_CK_negedge_posedge(95),
          HoldLow                 => thold_DI_CK_posedge_posedge(95),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB2_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI0_3_CK_posedge,
          TimingData              => Tmkr_DI0_3_CK_posedge,
          TestSignal              => DI3_ipd(0),
          TestSignalName          => "DI(96)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(96),
          SetupLow                => tsetup_DI_CK_negedge_posedge(96),
          HoldHigh                => thold_DI_CK_negedge_posedge(96),
          HoldLow                 => thold_DI_CK_posedge_posedge(96),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI1_3_CK_posedge,
          TimingData              => Tmkr_DI1_3_CK_posedge,
          TestSignal              => DI3_ipd(1),
          TestSignalName          => "DI(97)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(97),
          SetupLow                => tsetup_DI_CK_negedge_posedge(97),
          HoldHigh                => thold_DI_CK_negedge_posedge(97),
          HoldLow                 => thold_DI_CK_posedge_posedge(97),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI2_3_CK_posedge,
          TimingData              => Tmkr_DI2_3_CK_posedge,
          TestSignal              => DI3_ipd(2),
          TestSignalName          => "DI(98)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(98),
          SetupLow                => tsetup_DI_CK_negedge_posedge(98),
          HoldHigh                => thold_DI_CK_negedge_posedge(98),
          HoldLow                 => thold_DI_CK_posedge_posedge(98),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI3_3_CK_posedge,
          TimingData              => Tmkr_DI3_3_CK_posedge,
          TestSignal              => DI3_ipd(3),
          TestSignalName          => "DI(99)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(99),
          SetupLow                => tsetup_DI_CK_negedge_posedge(99),
          HoldHigh                => thold_DI_CK_negedge_posedge(99),
          HoldLow                 => thold_DI_CK_posedge_posedge(99),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI4_3_CK_posedge,
          TimingData              => Tmkr_DI4_3_CK_posedge,
          TestSignal              => DI3_ipd(4),
          TestSignalName          => "DI(100)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(100),
          SetupLow                => tsetup_DI_CK_negedge_posedge(100),
          HoldHigh                => thold_DI_CK_negedge_posedge(100),
          HoldLow                 => thold_DI_CK_posedge_posedge(100),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI5_3_CK_posedge,
          TimingData              => Tmkr_DI5_3_CK_posedge,
          TestSignal              => DI3_ipd(5),
          TestSignalName          => "DI(101)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(101),
          SetupLow                => tsetup_DI_CK_negedge_posedge(101),
          HoldHigh                => thold_DI_CK_negedge_posedge(101),
          HoldLow                 => thold_DI_CK_posedge_posedge(101),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI6_3_CK_posedge,
          TimingData              => Tmkr_DI6_3_CK_posedge,
          TestSignal              => DI3_ipd(6),
          TestSignalName          => "DI(102)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(102),
          SetupLow                => tsetup_DI_CK_negedge_posedge(102),
          HoldHigh                => thold_DI_CK_negedge_posedge(102),
          HoldLow                 => thold_DI_CK_posedge_posedge(102),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI7_3_CK_posedge,
          TimingData              => Tmkr_DI7_3_CK_posedge,
          TestSignal              => DI3_ipd(7),
          TestSignalName          => "DI(103)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(103),
          SetupLow                => tsetup_DI_CK_negedge_posedge(103),
          HoldHigh                => thold_DI_CK_negedge_posedge(103),
          HoldLow                 => thold_DI_CK_posedge_posedge(103),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI8_3_CK_posedge,
          TimingData              => Tmkr_DI8_3_CK_posedge,
          TestSignal              => DI3_ipd(8),
          TestSignalName          => "DI(104)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(104),
          SetupLow                => tsetup_DI_CK_negedge_posedge(104),
          HoldHigh                => thold_DI_CK_negedge_posedge(104),
          HoldLow                 => thold_DI_CK_posedge_posedge(104),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI9_3_CK_posedge,
          TimingData              => Tmkr_DI9_3_CK_posedge,
          TestSignal              => DI3_ipd(9),
          TestSignalName          => "DI(105)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(105),
          SetupLow                => tsetup_DI_CK_negedge_posedge(105),
          HoldHigh                => thold_DI_CK_negedge_posedge(105),
          HoldLow                 => thold_DI_CK_posedge_posedge(105),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI10_3_CK_posedge,
          TimingData              => Tmkr_DI10_3_CK_posedge,
          TestSignal              => DI3_ipd(10),
          TestSignalName          => "DI(106)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(106),
          SetupLow                => tsetup_DI_CK_negedge_posedge(106),
          HoldHigh                => thold_DI_CK_negedge_posedge(106),
          HoldLow                 => thold_DI_CK_posedge_posedge(106),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI11_3_CK_posedge,
          TimingData              => Tmkr_DI11_3_CK_posedge,
          TestSignal              => DI3_ipd(11),
          TestSignalName          => "DI(107)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(107),
          SetupLow                => tsetup_DI_CK_negedge_posedge(107),
          HoldHigh                => thold_DI_CK_negedge_posedge(107),
          HoldLow                 => thold_DI_CK_posedge_posedge(107),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI12_3_CK_posedge,
          TimingData              => Tmkr_DI12_3_CK_posedge,
          TestSignal              => DI3_ipd(12),
          TestSignalName          => "DI(108)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(108),
          SetupLow                => tsetup_DI_CK_negedge_posedge(108),
          HoldHigh                => thold_DI_CK_negedge_posedge(108),
          HoldLow                 => thold_DI_CK_posedge_posedge(108),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI13_3_CK_posedge,
          TimingData              => Tmkr_DI13_3_CK_posedge,
          TestSignal              => DI3_ipd(13),
          TestSignalName          => "DI(109)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(109),
          SetupLow                => tsetup_DI_CK_negedge_posedge(109),
          HoldHigh                => thold_DI_CK_negedge_posedge(109),
          HoldLow                 => thold_DI_CK_posedge_posedge(109),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI14_3_CK_posedge,
          TimingData              => Tmkr_DI14_3_CK_posedge,
          TestSignal              => DI3_ipd(14),
          TestSignalName          => "DI(110)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(110),
          SetupLow                => tsetup_DI_CK_negedge_posedge(110),
          HoldHigh                => thold_DI_CK_negedge_posedge(110),
          HoldLow                 => thold_DI_CK_posedge_posedge(110),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI15_3_CK_posedge,
          TimingData              => Tmkr_DI15_3_CK_posedge,
          TestSignal              => DI3_ipd(15),
          TestSignalName          => "DI(111)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(111),
          SetupLow                => tsetup_DI_CK_negedge_posedge(111),
          HoldHigh                => thold_DI_CK_negedge_posedge(111),
          HoldLow                 => thold_DI_CK_posedge_posedge(111),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI16_3_CK_posedge,
          TimingData              => Tmkr_DI16_3_CK_posedge,
          TestSignal              => DI3_ipd(16),
          TestSignalName          => "DI(112)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(112),
          SetupLow                => tsetup_DI_CK_negedge_posedge(112),
          HoldHigh                => thold_DI_CK_negedge_posedge(112),
          HoldLow                 => thold_DI_CK_posedge_posedge(112),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI17_3_CK_posedge,
          TimingData              => Tmkr_DI17_3_CK_posedge,
          TestSignal              => DI3_ipd(17),
          TestSignalName          => "DI(113)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(113),
          SetupLow                => tsetup_DI_CK_negedge_posedge(113),
          HoldHigh                => thold_DI_CK_negedge_posedge(113),
          HoldLow                 => thold_DI_CK_posedge_posedge(113),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI18_3_CK_posedge,
          TimingData              => Tmkr_DI18_3_CK_posedge,
          TestSignal              => DI3_ipd(18),
          TestSignalName          => "DI(114)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(114),
          SetupLow                => tsetup_DI_CK_negedge_posedge(114),
          HoldHigh                => thold_DI_CK_negedge_posedge(114),
          HoldLow                 => thold_DI_CK_posedge_posedge(114),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI19_3_CK_posedge,
          TimingData              => Tmkr_DI19_3_CK_posedge,
          TestSignal              => DI3_ipd(19),
          TestSignalName          => "DI(115)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(115),
          SetupLow                => tsetup_DI_CK_negedge_posedge(115),
          HoldHigh                => thold_DI_CK_negedge_posedge(115),
          HoldLow                 => thold_DI_CK_posedge_posedge(115),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI20_3_CK_posedge,
          TimingData              => Tmkr_DI20_3_CK_posedge,
          TestSignal              => DI3_ipd(20),
          TestSignalName          => "DI(116)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(116),
          SetupLow                => tsetup_DI_CK_negedge_posedge(116),
          HoldHigh                => thold_DI_CK_negedge_posedge(116),
          HoldLow                 => thold_DI_CK_posedge_posedge(116),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI21_3_CK_posedge,
          TimingData              => Tmkr_DI21_3_CK_posedge,
          TestSignal              => DI3_ipd(21),
          TestSignalName          => "DI(117)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(117),
          SetupLow                => tsetup_DI_CK_negedge_posedge(117),
          HoldHigh                => thold_DI_CK_negedge_posedge(117),
          HoldLow                 => thold_DI_CK_posedge_posedge(117),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI22_3_CK_posedge,
          TimingData              => Tmkr_DI22_3_CK_posedge,
          TestSignal              => DI3_ipd(22),
          TestSignalName          => "DI(118)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(118),
          SetupLow                => tsetup_DI_CK_negedge_posedge(118),
          HoldHigh                => thold_DI_CK_negedge_posedge(118),
          HoldLow                 => thold_DI_CK_posedge_posedge(118),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI23_3_CK_posedge,
          TimingData              => Tmkr_DI23_3_CK_posedge,
          TestSignal              => DI3_ipd(23),
          TestSignalName          => "DI(119)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(119),
          SetupLow                => tsetup_DI_CK_negedge_posedge(119),
          HoldHigh                => thold_DI_CK_negedge_posedge(119),
          HoldLow                 => thold_DI_CK_posedge_posedge(119),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI24_3_CK_posedge,
          TimingData              => Tmkr_DI24_3_CK_posedge,
          TestSignal              => DI3_ipd(24),
          TestSignalName          => "DI(120)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(120),
          SetupLow                => tsetup_DI_CK_negedge_posedge(120),
          HoldHigh                => thold_DI_CK_negedge_posedge(120),
          HoldLow                 => thold_DI_CK_posedge_posedge(120),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI25_3_CK_posedge,
          TimingData              => Tmkr_DI25_3_CK_posedge,
          TestSignal              => DI3_ipd(25),
          TestSignalName          => "DI(121)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(121),
          SetupLow                => tsetup_DI_CK_negedge_posedge(121),
          HoldHigh                => thold_DI_CK_negedge_posedge(121),
          HoldLow                 => thold_DI_CK_posedge_posedge(121),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI26_3_CK_posedge,
          TimingData              => Tmkr_DI26_3_CK_posedge,
          TestSignal              => DI3_ipd(26),
          TestSignalName          => "DI(122)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(122),
          SetupLow                => tsetup_DI_CK_negedge_posedge(122),
          HoldHigh                => thold_DI_CK_negedge_posedge(122),
          HoldLow                 => thold_DI_CK_posedge_posedge(122),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI27_3_CK_posedge,
          TimingData              => Tmkr_DI27_3_CK_posedge,
          TestSignal              => DI3_ipd(27),
          TestSignalName          => "DI(123)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(123),
          SetupLow                => tsetup_DI_CK_negedge_posedge(123),
          HoldHigh                => thold_DI_CK_negedge_posedge(123),
          HoldLow                 => thold_DI_CK_posedge_posedge(123),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI28_3_CK_posedge,
          TimingData              => Tmkr_DI28_3_CK_posedge,
          TestSignal              => DI3_ipd(28),
          TestSignalName          => "DI(124)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(124),
          SetupLow                => tsetup_DI_CK_negedge_posedge(124),
          HoldHigh                => thold_DI_CK_negedge_posedge(124),
          HoldLow                 => thold_DI_CK_posedge_posedge(124),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI29_3_CK_posedge,
          TimingData              => Tmkr_DI29_3_CK_posedge,
          TestSignal              => DI3_ipd(29),
          TestSignalName          => "DI(125)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(125),
          SetupLow                => tsetup_DI_CK_negedge_posedge(125),
          HoldHigh                => thold_DI_CK_negedge_posedge(125),
          HoldLow                 => thold_DI_CK_posedge_posedge(125),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI30_3_CK_posedge,
          TimingData              => Tmkr_DI30_3_CK_posedge,
          TestSignal              => DI3_ipd(30),
          TestSignalName          => "DI(126)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(126),
          SetupLow                => tsetup_DI_CK_negedge_posedge(126),
          HoldHigh                => thold_DI_CK_negedge_posedge(126),
          HoldLow                 => thold_DI_CK_posedge_posedge(126),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI31_3_CK_posedge,
          TimingData              => Tmkr_DI31_3_CK_posedge,
          TestSignal              => DI3_ipd(31),
          TestSignalName          => "DI(127)",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI_CK_posedge_posedge(127),
          SetupLow                => tsetup_DI_CK_negedge_posedge(127),
          HoldHigh                => thold_DI_CK_negedge_posedge(127),
          HoldLow                 => thold_DI_CK_posedge_posedge(127),
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB3_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);


         VitalSetupHoldCheck (
          Violation               => Tviol_CSB_CK_posedge,
          TimingData              => Tmkr_CSB_CK_posedge,
          TestSignal              => CSB_ipd,
          TestSignalName          => "CSB",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_CSB_CK_posedge_posedge,
          SetupLow                => tsetup_CSB_CK_negedge_posedge,
          HoldHigh                => thold_CSB_CK_negedge_posedge,
          HoldLow                 => thold_CSB_CK_posedge_posedge,
          CheckEnabled            => NOW /= 0 ns,
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);


         VitalPeriodPulseCheck (
          Violation               => Pviol_CK,
          PeriodData              => Pdata_CK,
          TestSignal              => CK_ipd,
          TestSignalName          => "CK",
          TestDelay               => 0 ns,
          Period                  => tperiod_CK,
          PulseWidthHigh          => tpw_CK_posedge,
          PulseWidthLow           => tpw_CK_negedge,
          CheckEnabled            => 
                           NOW /= 0 ns AND CSB_ipd = '0',
          HeaderMsg               => InstancePath & "/SYLA55_256X32X4CM2",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);


	  
   end if;

   -------------------------
   --  Functionality Section
   -------------------------


       if (CSB_ipd = '1' and CSB_ipd'event) then
          if (SYN_CS = 0) then
             DO0_zd := (OTHERS => 'X');
             DO0_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
             DO1_zd := (OTHERS => 'X');
             DO1_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
             DO2_zd := (OTHERS => 'X');
             DO2_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
             DO3_zd := (OTHERS => 'X');
             DO3_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
          end if;
       end if;

       if (CK_ipd'event) then
         ck_change := LastClkEdge&CK_ipd;
         case ck_change is
            when "01"   =>
                if (CS_monitor(CSB_ipd,flag_CSB) = True_flg) then
                   -- Reduce error message --
                   flag_CSB := True_flg;
                else
                   flag_CSB := False_flg;
                end if;

                Latch_A    := A_ipd;
                Latch_CSB   := CSB_ipd;
                Latch_DI0  := DI0_ipd;
                Latch_WEB0 := WEB0_ipd;
                Latch_DI1  := DI1_ipd;
                Latch_WEB1 := WEB1_ipd;
                Latch_DI2  := DI2_ipd;
                Latch_WEB2 := WEB2_ipd;
                Latch_DI3  := DI3_ipd;
                Latch_WEB3 := WEB3_ipd;

                -- memory_function
                A_i    := Latch_A;
                CSB_i   := Latch_CSB;
                DI0_i  := Latch_DI0;
                WEB0_i := Latch_WEB0;
                DI1_i  := Latch_DI1;
                WEB1_i := Latch_WEB1;
                DI2_i  := Latch_DI2;
                WEB2_i := Latch_WEB2;
                DI3_i  := Latch_DI3;
                WEB3_i := Latch_WEB3;



                web0_cs    := WEB0_i&CSB_i;
                case web0_cs is
                   when "10" => 
                       -------- Reduce error message --------------------------
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           DO0_zd := memoryCore0(to_integer(A_i));
                             ScheduleOutputDelayTOH(DO0_int(0), DO0_zd(0),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(96),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(1), DO0_zd(1),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(97),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(2), DO0_zd(2),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(98),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(3), DO0_zd(3),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(99),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(4), DO0_zd(4),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(100),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(5), DO0_zd(5),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(101),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(6), DO0_zd(6),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(102),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(7), DO0_zd(7),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(103),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(8), DO0_zd(8),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(104),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(9), DO0_zd(9),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(105),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(10), DO0_zd(10),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(106),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(11), DO0_zd(11),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(107),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(12), DO0_zd(12),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(108),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(13), DO0_zd(13),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(109),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(14), DO0_zd(14),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(110),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(15), DO0_zd(15),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(111),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(16), DO0_zd(16),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(112),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(17), DO0_zd(17),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(113),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(18), DO0_zd(18),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(114),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(19), DO0_zd(19),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(115),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(20), DO0_zd(20),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(116),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(21), DO0_zd(21),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(117),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(22), DO0_zd(22),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(118),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(23), DO0_zd(23),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(119),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(24), DO0_zd(24),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(120),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(25), DO0_zd(25),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(121),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(26), DO0_zd(26),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(122),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(27), DO0_zd(27),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(123),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(28), DO0_zd(28),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(124),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(29), DO0_zd(29),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(125),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(30), DO0_zd(30),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(126),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(31), DO0_zd(31),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(127),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO0_zd := (OTHERS => 'X');
                           DO0_int <= TRANSPORT (OTHERS => 'X');
                       end if;

                   when "00" => 
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           memoryCore0(to_integer(A_i)) := DI0_i;
                           DO0_zd := memoryCore0(to_integer(A_i));
                             ScheduleOutputDelayTWDX(DO0_int(0), DO0_zd(0),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(96),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(1), DO0_zd(1),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(97),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(2), DO0_zd(2),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(98),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(3), DO0_zd(3),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(99),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(4), DO0_zd(4),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(100),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(5), DO0_zd(5),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(101),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(6), DO0_zd(6),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(102),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(7), DO0_zd(7),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(103),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(8), DO0_zd(8),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(104),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(9), DO0_zd(9),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(105),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(10), DO0_zd(10),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(106),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(11), DO0_zd(11),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(107),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(12), DO0_zd(12),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(108),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(13), DO0_zd(13),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(109),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(14), DO0_zd(14),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(110),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(15), DO0_zd(15),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(111),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(16), DO0_zd(16),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(112),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(17), DO0_zd(17),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(113),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(18), DO0_zd(18),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(114),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(19), DO0_zd(19),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(115),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(20), DO0_zd(20),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(116),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(21), DO0_zd(21),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(117),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(22), DO0_zd(22),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(118),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(23), DO0_zd(23),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(119),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(24), DO0_zd(24),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(120),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(25), DO0_zd(25),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(121),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(26), DO0_zd(26),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(122),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(27), DO0_zd(27),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(123),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(28), DO0_zd(28),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(124),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(29), DO0_zd(29),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(125),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(30), DO0_zd(30),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(126),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(31), DO0_zd(31),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(127),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO0_zd := (OTHERS => 'X');
                           DO0_int <= TRANSPORT (OTHERS => 'X');
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO0_zd := (OTHERS => 'X');
                           DO0_int <= TRANSPORT (OTHERS => 'X') AFTER TWDX;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore0(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;

                   when "1X" |
                        "1U" |
                        "1Z" => DO0_zd := (OTHERS => 'X');
                                DO0_int <= TRANSPORT (OTHERS => 'X') AFTER TOH; 
                   when "11" |
                        "01" |
                        "X1" |
                        "U1" |
                        "Z1"   => -- do nothing
                   when others =>
                                if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                                   -- Reduce error message --
                                   flag_A := True_flg;
                                   --------------------------
                                   memoryCore0(to_integer(A_i)) := (OTHERS => 'X');
                                   DO0_zd := (OTHERS => 'X');
                                   DO0_int <= TRANSPORT (OTHERS => 'X');
                                elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                                    -- Reduce error message --
                                    flag_A := False_flg;
                                    --------------------------
                                    DO0_zd := (OTHERS => 'X');
                                    DO0_int <= TRANSPORT (OTHERS => 'X');
                                else
                                   -- Reduce error message --
                                   flag_A := False_flg;
                                   --------------------------
                                   DO0_zd := (OTHERS => 'X');
                                   DO0_int <= TRANSPORT (OTHERS => 'X');
                                   FOR i IN Words-1 downto 0 LOOP
                                      memoryCore0(i) := (OTHERS => 'X');
                                   END LOOP;
                                end if;
                end case;


                web1_cs    := WEB1_i&CSB_i;
                case web1_cs is
                   when "10" => 
                       -------- Reduce error message --------------------------
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           DO1_zd := memoryCore1(to_integer(A_i));
                             ScheduleOutputDelayTOH(DO1_int(0), DO1_zd(0),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(64),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(1), DO1_zd(1),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(65),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(2), DO1_zd(2),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(66),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(3), DO1_zd(3),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(67),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(4), DO1_zd(4),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(68),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(5), DO1_zd(5),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(69),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(6), DO1_zd(6),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(70),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(7), DO1_zd(7),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(71),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(8), DO1_zd(8),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(72),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(9), DO1_zd(9),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(73),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(10), DO1_zd(10),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(74),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(11), DO1_zd(11),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(75),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(12), DO1_zd(12),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(76),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(13), DO1_zd(13),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(77),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(14), DO1_zd(14),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(78),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(15), DO1_zd(15),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(79),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(16), DO1_zd(16),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(80),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(17), DO1_zd(17),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(81),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(18), DO1_zd(18),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(82),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(19), DO1_zd(19),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(83),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(20), DO1_zd(20),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(84),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(21), DO1_zd(21),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(85),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(22), DO1_zd(22),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(86),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(23), DO1_zd(23),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(87),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(24), DO1_zd(24),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(88),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(25), DO1_zd(25),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(89),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(26), DO1_zd(26),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(90),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(27), DO1_zd(27),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(91),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(28), DO1_zd(28),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(92),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(29), DO1_zd(29),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(93),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(30), DO1_zd(30),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(94),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(31), DO1_zd(31),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(95),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO1_zd := (OTHERS => 'X');
                           DO1_int <= TRANSPORT (OTHERS => 'X');
                       end if;

                   when "00" => 
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           memoryCore1(to_integer(A_i)) := DI1_i;
                           DO1_zd := memoryCore1(to_integer(A_i));
                             ScheduleOutputDelayTWDX(DO1_int(0), DO1_zd(0),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(64),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(1), DO1_zd(1),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(65),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(2), DO1_zd(2),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(66),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(3), DO1_zd(3),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(67),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(4), DO1_zd(4),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(68),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(5), DO1_zd(5),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(69),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(6), DO1_zd(6),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(70),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(7), DO1_zd(7),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(71),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(8), DO1_zd(8),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(72),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(9), DO1_zd(9),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(73),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(10), DO1_zd(10),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(74),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(11), DO1_zd(11),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(75),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(12), DO1_zd(12),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(76),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(13), DO1_zd(13),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(77),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(14), DO1_zd(14),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(78),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(15), DO1_zd(15),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(79),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(16), DO1_zd(16),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(80),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(17), DO1_zd(17),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(81),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(18), DO1_zd(18),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(82),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(19), DO1_zd(19),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(83),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(20), DO1_zd(20),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(84),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(21), DO1_zd(21),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(85),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(22), DO1_zd(22),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(86),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(23), DO1_zd(23),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(87),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(24), DO1_zd(24),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(88),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(25), DO1_zd(25),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(89),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(26), DO1_zd(26),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(90),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(27), DO1_zd(27),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(91),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(28), DO1_zd(28),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(92),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(29), DO1_zd(29),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(93),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(30), DO1_zd(30),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(94),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(31), DO1_zd(31),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(95),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO1_zd := (OTHERS => 'X');
                           DO1_int <= TRANSPORT (OTHERS => 'X');
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO1_zd := (OTHERS => 'X');
                           DO1_int <= TRANSPORT (OTHERS => 'X') AFTER TWDX;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore1(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;

                   when "1X" |
                        "1U" |
                        "1Z" => DO1_zd := (OTHERS => 'X');
                                DO1_int <= TRANSPORT (OTHERS => 'X') AFTER TOH; 
                   when "11" |
                        "01" |
                        "X1" |
                        "U1" |
                        "Z1"   => -- do nothing
                   when others =>
                                if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                                   -- Reduce error message --
                                   flag_A := True_flg;
                                   --------------------------
                                   memoryCore1(to_integer(A_i)) := (OTHERS => 'X');
                                   DO1_zd := (OTHERS => 'X');
                                   DO1_int <= TRANSPORT (OTHERS => 'X');
                                elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                                    -- Reduce error message --
                                    flag_A := False_flg;
                                    --------------------------
                                    DO1_zd := (OTHERS => 'X');
                                    DO1_int <= TRANSPORT (OTHERS => 'X');
                                else
                                   -- Reduce error message --
                                   flag_A := False_flg;
                                   --------------------------
                                   DO1_zd := (OTHERS => 'X');
                                   DO1_int <= TRANSPORT (OTHERS => 'X');
                                   FOR i IN Words-1 downto 0 LOOP
                                      memoryCore1(i) := (OTHERS => 'X');
                                   END LOOP;
                                end if;
                end case;


                web2_cs    := WEB2_i&CSB_i;
                case web2_cs is
                   when "10" => 
                       -------- Reduce error message --------------------------
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           DO2_zd := memoryCore2(to_integer(A_i));
                             ScheduleOutputDelayTOH(DO2_int(0), DO2_zd(0),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(32),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(1), DO2_zd(1),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(33),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(2), DO2_zd(2),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(34),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(3), DO2_zd(3),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(35),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(4), DO2_zd(4),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(36),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(5), DO2_zd(5),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(37),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(6), DO2_zd(6),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(38),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(7), DO2_zd(7),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(39),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(8), DO2_zd(8),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(40),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(9), DO2_zd(9),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(41),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(10), DO2_zd(10),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(42),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(11), DO2_zd(11),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(43),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(12), DO2_zd(12),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(44),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(13), DO2_zd(13),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(45),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(14), DO2_zd(14),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(46),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(15), DO2_zd(15),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(47),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(16), DO2_zd(16),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(48),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(17), DO2_zd(17),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(49),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(18), DO2_zd(18),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(50),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(19), DO2_zd(19),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(51),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(20), DO2_zd(20),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(52),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(21), DO2_zd(21),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(53),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(22), DO2_zd(22),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(54),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(23), DO2_zd(23),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(55),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(24), DO2_zd(24),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(56),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(25), DO2_zd(25),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(57),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(26), DO2_zd(26),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(58),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(27), DO2_zd(27),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(59),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(28), DO2_zd(28),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(60),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(29), DO2_zd(29),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(61),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(30), DO2_zd(30),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(62),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(31), DO2_zd(31),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(63),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO2_zd := (OTHERS => 'X');
                           DO2_int <= TRANSPORT (OTHERS => 'X');
                       end if;

                   when "00" => 
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           memoryCore2(to_integer(A_i)) := DI2_i;
                           DO2_zd := memoryCore2(to_integer(A_i));
                             ScheduleOutputDelayTWDX(DO2_int(0), DO2_zd(0),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(32),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(1), DO2_zd(1),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(33),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(2), DO2_zd(2),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(34),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(3), DO2_zd(3),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(35),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(4), DO2_zd(4),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(36),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(5), DO2_zd(5),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(37),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(6), DO2_zd(6),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(38),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(7), DO2_zd(7),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(39),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(8), DO2_zd(8),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(40),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(9), DO2_zd(9),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(41),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(10), DO2_zd(10),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(42),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(11), DO2_zd(11),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(43),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(12), DO2_zd(12),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(44),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(13), DO2_zd(13),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(45),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(14), DO2_zd(14),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(46),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(15), DO2_zd(15),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(47),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(16), DO2_zd(16),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(48),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(17), DO2_zd(17),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(49),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(18), DO2_zd(18),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(50),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(19), DO2_zd(19),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(51),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(20), DO2_zd(20),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(52),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(21), DO2_zd(21),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(53),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(22), DO2_zd(22),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(54),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(23), DO2_zd(23),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(55),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(24), DO2_zd(24),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(56),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(25), DO2_zd(25),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(57),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(26), DO2_zd(26),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(58),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(27), DO2_zd(27),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(59),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(28), DO2_zd(28),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(60),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(29), DO2_zd(29),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(61),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(30), DO2_zd(30),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(62),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(31), DO2_zd(31),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(63),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO2_zd := (OTHERS => 'X');
                           DO2_int <= TRANSPORT (OTHERS => 'X');
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO2_zd := (OTHERS => 'X');
                           DO2_int <= TRANSPORT (OTHERS => 'X') AFTER TWDX;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore2(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;

                   when "1X" |
                        "1U" |
                        "1Z" => DO2_zd := (OTHERS => 'X');
                                DO2_int <= TRANSPORT (OTHERS => 'X') AFTER TOH; 
                   when "11" |
                        "01" |
                        "X1" |
                        "U1" |
                        "Z1"   => -- do nothing
                   when others =>
                                if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                                   -- Reduce error message --
                                   flag_A := True_flg;
                                   --------------------------
                                   memoryCore2(to_integer(A_i)) := (OTHERS => 'X');
                                   DO2_zd := (OTHERS => 'X');
                                   DO2_int <= TRANSPORT (OTHERS => 'X');
                                elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                                    -- Reduce error message --
                                    flag_A := False_flg;
                                    --------------------------
                                    DO2_zd := (OTHERS => 'X');
                                    DO2_int <= TRANSPORT (OTHERS => 'X');
                                else
                                   -- Reduce error message --
                                   flag_A := False_flg;
                                   --------------------------
                                   DO2_zd := (OTHERS => 'X');
                                   DO2_int <= TRANSPORT (OTHERS => 'X');
                                   FOR i IN Words-1 downto 0 LOOP
                                      memoryCore2(i) := (OTHERS => 'X');
                                   END LOOP;
                                end if;
                end case;


                web3_cs    := WEB3_i&CSB_i;
                case web3_cs is
                   when "10" => 
                       -------- Reduce error message --------------------------
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           DO3_zd := memoryCore3(to_integer(A_i));
                             ScheduleOutputDelayTOH(DO3_int(0), DO3_zd(0),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(0),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(1), DO3_zd(1),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(1),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(2), DO3_zd(2),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(2),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(3), DO3_zd(3),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(3),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(4), DO3_zd(4),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(4),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(5), DO3_zd(5),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(5),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(6), DO3_zd(6),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(6),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(7), DO3_zd(7),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(7),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(8), DO3_zd(8),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(8),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(9), DO3_zd(9),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(9),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(10), DO3_zd(10),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(10),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(11), DO3_zd(11),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(11),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(12), DO3_zd(12),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(12),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(13), DO3_zd(13),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(13),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(14), DO3_zd(14),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(14),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(15), DO3_zd(15),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(15),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(16), DO3_zd(16),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(16),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(17), DO3_zd(17),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(17),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(18), DO3_zd(18),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(18),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(19), DO3_zd(19),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(19),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(20), DO3_zd(20),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(20),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(21), DO3_zd(21),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(21),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(22), DO3_zd(22),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(22),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(23), DO3_zd(23),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(23),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(24), DO3_zd(24),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(24),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(25), DO3_zd(25),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(25),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(26), DO3_zd(26),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(26),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(27), DO3_zd(27),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(27),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(28), DO3_zd(28),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(28),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(29), DO3_zd(29),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(29),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(30), DO3_zd(30),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(30),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(31), DO3_zd(31),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(31),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO3_zd := (OTHERS => 'X');
                           DO3_int <= TRANSPORT (OTHERS => 'X');
                       end if;

                   when "00" => 
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           memoryCore3(to_integer(A_i)) := DI3_i;
                           DO3_zd := memoryCore3(to_integer(A_i));
                             ScheduleOutputDelayTWDX(DO3_int(0), DO3_zd(0),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(0),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(1), DO3_zd(1),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(1),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(2), DO3_zd(2),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(2),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(3), DO3_zd(3),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(3),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(4), DO3_zd(4),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(4),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(5), DO3_zd(5),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(5),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(6), DO3_zd(6),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(6),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(7), DO3_zd(7),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(7),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(8), DO3_zd(8),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(8),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(9), DO3_zd(9),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(9),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(10), DO3_zd(10),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(10),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(11), DO3_zd(11),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(11),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(12), DO3_zd(12),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(12),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(13), DO3_zd(13),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(13),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(14), DO3_zd(14),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(14),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(15), DO3_zd(15),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(15),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(16), DO3_zd(16),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(16),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(17), DO3_zd(17),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(17),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(18), DO3_zd(18),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(18),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(19), DO3_zd(19),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(19),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(20), DO3_zd(20),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(20),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(21), DO3_zd(21),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(21),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(22), DO3_zd(22),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(22),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(23), DO3_zd(23),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(23),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(24), DO3_zd(24),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(24),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(25), DO3_zd(25),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(25),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(26), DO3_zd(26),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(26),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(27), DO3_zd(27),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(27),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(28), DO3_zd(28),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(28),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(29), DO3_zd(29),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(29),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(30), DO3_zd(30),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(30),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(31), DO3_zd(31),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(31),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO3_zd := (OTHERS => 'X');
                           DO3_int <= TRANSPORT (OTHERS => 'X');
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO3_zd := (OTHERS => 'X');
                           DO3_int <= TRANSPORT (OTHERS => 'X') AFTER TWDX;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore3(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;

                   when "1X" |
                        "1U" |
                        "1Z" => DO3_zd := (OTHERS => 'X');
                                DO3_int <= TRANSPORT (OTHERS => 'X') AFTER TOH; 
                   when "11" |
                        "01" |
                        "X1" |
                        "U1" |
                        "Z1"   => -- do nothing
                   when others =>
                                if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                                   -- Reduce error message --
                                   flag_A := True_flg;
                                   --------------------------
                                   memoryCore3(to_integer(A_i)) := (OTHERS => 'X');
                                   DO3_zd := (OTHERS => 'X');
                                   DO3_int <= TRANSPORT (OTHERS => 'X');
                                elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                                    -- Reduce error message --
                                    flag_A := False_flg;
                                    --------------------------
                                    DO3_zd := (OTHERS => 'X');
                                    DO3_int <= TRANSPORT (OTHERS => 'X');
                                else
                                   -- Reduce error message --
                                   flag_A := False_flg;
                                   --------------------------
                                   DO3_zd := (OTHERS => 'X');
                                   DO3_int <= TRANSPORT (OTHERS => 'X');
                                   FOR i IN Words-1 downto 0 LOOP
                                      memoryCore3(i) := (OTHERS => 'X');
                                   END LOOP;
                                end if;
                end case;



                -- end memory_function
                last_A := A_ipd;
                last_DI0 := DI0_ipd;
                last_WEB0 := WEB0_ipd;
                last_DI1 := DI1_ipd;
                last_WEB1 := WEB1_ipd;
                last_DI2 := DI2_ipd;
                last_WEB2 := WEB2_ipd;
                last_DI3 := DI3_ipd;
                last_WEB3 := WEB3_ipd;
            when "10"   => -- do nothing
            when others => if (NOW /= 0 ns) then
                              assert FALSE report "** MEM_Error: Abnormal transition occurred." severity WARNING;
                           end if;
                           if (CSB_ipd /= '1') then
                              DO0_zd := (OTHERS => 'X');
                              DO0_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                              if (WEB0_ipd /= '1') then
                                 FOR i IN Words-1 downto 0 LOOP
                                    memoryCore0(i) := (OTHERS => 'X');
                                 END LOOP;
                              end if;
                              DO1_zd := (OTHERS => 'X');
                              DO1_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                              if (WEB1_ipd /= '1') then
                                 FOR i IN Words-1 downto 0 LOOP
                                    memoryCore1(i) := (OTHERS => 'X');
                                 END LOOP;
                              end if;
                              DO2_zd := (OTHERS => 'X');
                              DO2_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                              if (WEB2_ipd /= '1') then
                                 FOR i IN Words-1 downto 0 LOOP
                                    memoryCore2(i) := (OTHERS => 'X');
                                 END LOOP;
                              end if;
                              DO3_zd := (OTHERS => 'X');
                              DO3_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                              if (WEB3_ipd /= '1') then
                                 FOR i IN Words-1 downto 0 LOOP
                                    memoryCore3(i) := (OTHERS => 'X');
                                 END LOOP;
                              end if;
                           end if;
         end case;

         LastClkEdge := CK_ipd;
       end if;

   
       if (
           Tviol_A0_CK_posedge     = 'X' or
           Tviol_A1_CK_posedge     = 'X' or
           Tviol_A2_CK_posedge     = 'X' or
           Tviol_A3_CK_posedge     = 'X' or
           Tviol_A4_CK_posedge     = 'X' or
           Tviol_A5_CK_posedge     = 'X' or
           Tviol_A6_CK_posedge     = 'X' or
           Tviol_A7_CK_posedge     = 'X' or
           Tviol_WEB0_CK_posedge  = 'X' or
           Tviol_WEB1_CK_posedge  = 'X' or
           Tviol_WEB2_CK_posedge  = 'X' or
           Tviol_WEB3_CK_posedge  = 'X' or
           Tviol_DI0_0_CK_posedge   = 'X' or 
           Tviol_DI1_0_CK_posedge   = 'X' or 
           Tviol_DI2_0_CK_posedge   = 'X' or 
           Tviol_DI3_0_CK_posedge   = 'X' or 
           Tviol_DI4_0_CK_posedge   = 'X' or 
           Tviol_DI5_0_CK_posedge   = 'X' or 
           Tviol_DI6_0_CK_posedge   = 'X' or 
           Tviol_DI7_0_CK_posedge   = 'X' or 
           Tviol_DI8_0_CK_posedge   = 'X' or 
           Tviol_DI9_0_CK_posedge   = 'X' or 
           Tviol_DI10_0_CK_posedge   = 'X' or 
           Tviol_DI11_0_CK_posedge   = 'X' or 
           Tviol_DI12_0_CK_posedge   = 'X' or 
           Tviol_DI13_0_CK_posedge   = 'X' or 
           Tviol_DI14_0_CK_posedge   = 'X' or 
           Tviol_DI15_0_CK_posedge   = 'X' or 
           Tviol_DI16_0_CK_posedge   = 'X' or 
           Tviol_DI17_0_CK_posedge   = 'X' or 
           Tviol_DI18_0_CK_posedge   = 'X' or 
           Tviol_DI19_0_CK_posedge   = 'X' or 
           Tviol_DI20_0_CK_posedge   = 'X' or 
           Tviol_DI21_0_CK_posedge   = 'X' or 
           Tviol_DI22_0_CK_posedge   = 'X' or 
           Tviol_DI23_0_CK_posedge   = 'X' or 
           Tviol_DI24_0_CK_posedge   = 'X' or 
           Tviol_DI25_0_CK_posedge   = 'X' or 
           Tviol_DI26_0_CK_posedge   = 'X' or 
           Tviol_DI27_0_CK_posedge   = 'X' or 
           Tviol_DI28_0_CK_posedge   = 'X' or 
           Tviol_DI29_0_CK_posedge   = 'X' or 
           Tviol_DI30_0_CK_posedge   = 'X' or 
           Tviol_DI31_0_CK_posedge   = 'X' or 
           Tviol_DI0_1_CK_posedge   = 'X' or 
           Tviol_DI1_1_CK_posedge   = 'X' or 
           Tviol_DI2_1_CK_posedge   = 'X' or 
           Tviol_DI3_1_CK_posedge   = 'X' or 
           Tviol_DI4_1_CK_posedge   = 'X' or 
           Tviol_DI5_1_CK_posedge   = 'X' or 
           Tviol_DI6_1_CK_posedge   = 'X' or 
           Tviol_DI7_1_CK_posedge   = 'X' or 
           Tviol_DI8_1_CK_posedge   = 'X' or 
           Tviol_DI9_1_CK_posedge   = 'X' or 
           Tviol_DI10_1_CK_posedge   = 'X' or 
           Tviol_DI11_1_CK_posedge   = 'X' or 
           Tviol_DI12_1_CK_posedge   = 'X' or 
           Tviol_DI13_1_CK_posedge   = 'X' or 
           Tviol_DI14_1_CK_posedge   = 'X' or 
           Tviol_DI15_1_CK_posedge   = 'X' or 
           Tviol_DI16_1_CK_posedge   = 'X' or 
           Tviol_DI17_1_CK_posedge   = 'X' or 
           Tviol_DI18_1_CK_posedge   = 'X' or 
           Tviol_DI19_1_CK_posedge   = 'X' or 
           Tviol_DI20_1_CK_posedge   = 'X' or 
           Tviol_DI21_1_CK_posedge   = 'X' or 
           Tviol_DI22_1_CK_posedge   = 'X' or 
           Tviol_DI23_1_CK_posedge   = 'X' or 
           Tviol_DI24_1_CK_posedge   = 'X' or 
           Tviol_DI25_1_CK_posedge   = 'X' or 
           Tviol_DI26_1_CK_posedge   = 'X' or 
           Tviol_DI27_1_CK_posedge   = 'X' or 
           Tviol_DI28_1_CK_posedge   = 'X' or 
           Tviol_DI29_1_CK_posedge   = 'X' or 
           Tviol_DI30_1_CK_posedge   = 'X' or 
           Tviol_DI31_1_CK_posedge   = 'X' or 
           Tviol_DI0_2_CK_posedge   = 'X' or 
           Tviol_DI1_2_CK_posedge   = 'X' or 
           Tviol_DI2_2_CK_posedge   = 'X' or 
           Tviol_DI3_2_CK_posedge   = 'X' or 
           Tviol_DI4_2_CK_posedge   = 'X' or 
           Tviol_DI5_2_CK_posedge   = 'X' or 
           Tviol_DI6_2_CK_posedge   = 'X' or 
           Tviol_DI7_2_CK_posedge   = 'X' or 
           Tviol_DI8_2_CK_posedge   = 'X' or 
           Tviol_DI9_2_CK_posedge   = 'X' or 
           Tviol_DI10_2_CK_posedge   = 'X' or 
           Tviol_DI11_2_CK_posedge   = 'X' or 
           Tviol_DI12_2_CK_posedge   = 'X' or 
           Tviol_DI13_2_CK_posedge   = 'X' or 
           Tviol_DI14_2_CK_posedge   = 'X' or 
           Tviol_DI15_2_CK_posedge   = 'X' or 
           Tviol_DI16_2_CK_posedge   = 'X' or 
           Tviol_DI17_2_CK_posedge   = 'X' or 
           Tviol_DI18_2_CK_posedge   = 'X' or 
           Tviol_DI19_2_CK_posedge   = 'X' or 
           Tviol_DI20_2_CK_posedge   = 'X' or 
           Tviol_DI21_2_CK_posedge   = 'X' or 
           Tviol_DI22_2_CK_posedge   = 'X' or 
           Tviol_DI23_2_CK_posedge   = 'X' or 
           Tviol_DI24_2_CK_posedge   = 'X' or 
           Tviol_DI25_2_CK_posedge   = 'X' or 
           Tviol_DI26_2_CK_posedge   = 'X' or 
           Tviol_DI27_2_CK_posedge   = 'X' or 
           Tviol_DI28_2_CK_posedge   = 'X' or 
           Tviol_DI29_2_CK_posedge   = 'X' or 
           Tviol_DI30_2_CK_posedge   = 'X' or 
           Tviol_DI31_2_CK_posedge   = 'X' or 
           Tviol_DI0_3_CK_posedge   = 'X' or 
           Tviol_DI1_3_CK_posedge   = 'X' or 
           Tviol_DI2_3_CK_posedge   = 'X' or 
           Tviol_DI3_3_CK_posedge   = 'X' or 
           Tviol_DI4_3_CK_posedge   = 'X' or 
           Tviol_DI5_3_CK_posedge   = 'X' or 
           Tviol_DI6_3_CK_posedge   = 'X' or 
           Tviol_DI7_3_CK_posedge   = 'X' or 
           Tviol_DI8_3_CK_posedge   = 'X' or 
           Tviol_DI9_3_CK_posedge   = 'X' or 
           Tviol_DI10_3_CK_posedge   = 'X' or 
           Tviol_DI11_3_CK_posedge   = 'X' or 
           Tviol_DI12_3_CK_posedge   = 'X' or 
           Tviol_DI13_3_CK_posedge   = 'X' or 
           Tviol_DI14_3_CK_posedge   = 'X' or 
           Tviol_DI15_3_CK_posedge   = 'X' or 
           Tviol_DI16_3_CK_posedge   = 'X' or 
           Tviol_DI17_3_CK_posedge   = 'X' or 
           Tviol_DI18_3_CK_posedge   = 'X' or 
           Tviol_DI19_3_CK_posedge   = 'X' or 
           Tviol_DI20_3_CK_posedge   = 'X' or 
           Tviol_DI21_3_CK_posedge   = 'X' or 
           Tviol_DI22_3_CK_posedge   = 'X' or 
           Tviol_DI23_3_CK_posedge   = 'X' or 
           Tviol_DI24_3_CK_posedge   = 'X' or 
           Tviol_DI25_3_CK_posedge   = 'X' or 
           Tviol_DI26_3_CK_posedge   = 'X' or 
           Tviol_DI27_3_CK_posedge   = 'X' or 
           Tviol_DI28_3_CK_posedge   = 'X' or 
           Tviol_DI29_3_CK_posedge   = 'X' or 
           Tviol_DI30_3_CK_posedge   = 'X' or 
           Tviol_DI31_3_CK_posedge   = 'X' or 
           Tviol_CSB_CK_posedge    = 'X' or
           Pviol_CK               = 'X'
          ) then

         if (Pviol_CK = 'X') then
            if (CSB_ipd /= '1') then
               DO0_zd := (OTHERS => 'X');
               DO0_int <= TRANSPORT (OTHERS => 'X');
               if (WEB0_ipd /= '1') then
                  FOR i IN Words-1 downto 0 LOOP
                     memoryCore0(i) := (OTHERS => 'X');
                  END LOOP;
               end if;
               DO1_zd := (OTHERS => 'X');
               DO1_int <= TRANSPORT (OTHERS => 'X');
               if (WEB1_ipd /= '1') then
                  FOR i IN Words-1 downto 0 LOOP
                     memoryCore1(i) := (OTHERS => 'X');
                  END LOOP;
               end if;
               DO2_zd := (OTHERS => 'X');
               DO2_int <= TRANSPORT (OTHERS => 'X');
               if (WEB2_ipd /= '1') then
                  FOR i IN Words-1 downto 0 LOOP
                     memoryCore2(i) := (OTHERS => 'X');
                  END LOOP;
               end if;
               DO3_zd := (OTHERS => 'X');
               DO3_int <= TRANSPORT (OTHERS => 'X');
               if (WEB3_ipd /= '1') then
                  FOR i IN Words-1 downto 0 LOOP
                     memoryCore3(i) := (OTHERS => 'X');
                  END LOOP;
               end if;
            end if;
         else
              if (Tviol_A0_CK_posedge = 'X') then
                 Latch_A(0) := 'X';
              else
                 Latch_A(0) := Latch_A(0);
              end if;
              if (Tviol_A1_CK_posedge = 'X') then
                 Latch_A(1) := 'X';
              else
                 Latch_A(1) := Latch_A(1);
              end if;
              if (Tviol_A2_CK_posedge = 'X') then
                 Latch_A(2) := 'X';
              else
                 Latch_A(2) := Latch_A(2);
              end if;
              if (Tviol_A3_CK_posedge = 'X') then
                 Latch_A(3) := 'X';
              else
                 Latch_A(3) := Latch_A(3);
              end if;
              if (Tviol_A4_CK_posedge = 'X') then
                 Latch_A(4) := 'X';
              else
                 Latch_A(4) := Latch_A(4);
              end if;
              if (Tviol_A5_CK_posedge = 'X') then
                 Latch_A(5) := 'X';
              else
                 Latch_A(5) := Latch_A(5);
              end if;
              if (Tviol_A6_CK_posedge = 'X') then
                 Latch_A(6) := 'X';
              else
                 Latch_A(6) := Latch_A(6);
              end if;
              if (Tviol_A7_CK_posedge = 'X') then
                 Latch_A(7) := 'X';
              else
                 Latch_A(7) := Latch_A(7);
              end if;

              if (Tviol_DI0_0_CK_posedge = 'X') then
                 Latch_DI0(0) := 'X';
              else
                 Latch_DI0(0) := Latch_DI0(0);
              end if;
              if (Tviol_DI1_0_CK_posedge = 'X') then
                 Latch_DI0(1) := 'X';
              else
                 Latch_DI0(1) := Latch_DI0(1);
              end if;
              if (Tviol_DI2_0_CK_posedge = 'X') then
                 Latch_DI0(2) := 'X';
              else
                 Latch_DI0(2) := Latch_DI0(2);
              end if;
              if (Tviol_DI3_0_CK_posedge = 'X') then
                 Latch_DI0(3) := 'X';
              else
                 Latch_DI0(3) := Latch_DI0(3);
              end if;
              if (Tviol_DI4_0_CK_posedge = 'X') then
                 Latch_DI0(4) := 'X';
              else
                 Latch_DI0(4) := Latch_DI0(4);
              end if;
              if (Tviol_DI5_0_CK_posedge = 'X') then
                 Latch_DI0(5) := 'X';
              else
                 Latch_DI0(5) := Latch_DI0(5);
              end if;
              if (Tviol_DI6_0_CK_posedge = 'X') then
                 Latch_DI0(6) := 'X';
              else
                 Latch_DI0(6) := Latch_DI0(6);
              end if;
              if (Tviol_DI7_0_CK_posedge = 'X') then
                 Latch_DI0(7) := 'X';
              else
                 Latch_DI0(7) := Latch_DI0(7);
              end if;
              if (Tviol_DI8_0_CK_posedge = 'X') then
                 Latch_DI0(8) := 'X';
              else
                 Latch_DI0(8) := Latch_DI0(8);
              end if;
              if (Tviol_DI9_0_CK_posedge = 'X') then
                 Latch_DI0(9) := 'X';
              else
                 Latch_DI0(9) := Latch_DI0(9);
              end if;
              if (Tviol_DI10_0_CK_posedge = 'X') then
                 Latch_DI0(10) := 'X';
              else
                 Latch_DI0(10) := Latch_DI0(10);
              end if;
              if (Tviol_DI11_0_CK_posedge = 'X') then
                 Latch_DI0(11) := 'X';
              else
                 Latch_DI0(11) := Latch_DI0(11);
              end if;
              if (Tviol_DI12_0_CK_posedge = 'X') then
                 Latch_DI0(12) := 'X';
              else
                 Latch_DI0(12) := Latch_DI0(12);
              end if;
              if (Tviol_DI13_0_CK_posedge = 'X') then
                 Latch_DI0(13) := 'X';
              else
                 Latch_DI0(13) := Latch_DI0(13);
              end if;
              if (Tviol_DI14_0_CK_posedge = 'X') then
                 Latch_DI0(14) := 'X';
              else
                 Latch_DI0(14) := Latch_DI0(14);
              end if;
              if (Tviol_DI15_0_CK_posedge = 'X') then
                 Latch_DI0(15) := 'X';
              else
                 Latch_DI0(15) := Latch_DI0(15);
              end if;
              if (Tviol_DI16_0_CK_posedge = 'X') then
                 Latch_DI0(16) := 'X';
              else
                 Latch_DI0(16) := Latch_DI0(16);
              end if;
              if (Tviol_DI17_0_CK_posedge = 'X') then
                 Latch_DI0(17) := 'X';
              else
                 Latch_DI0(17) := Latch_DI0(17);
              end if;
              if (Tviol_DI18_0_CK_posedge = 'X') then
                 Latch_DI0(18) := 'X';
              else
                 Latch_DI0(18) := Latch_DI0(18);
              end if;
              if (Tviol_DI19_0_CK_posedge = 'X') then
                 Latch_DI0(19) := 'X';
              else
                 Latch_DI0(19) := Latch_DI0(19);
              end if;
              if (Tviol_DI20_0_CK_posedge = 'X') then
                 Latch_DI0(20) := 'X';
              else
                 Latch_DI0(20) := Latch_DI0(20);
              end if;
              if (Tviol_DI21_0_CK_posedge = 'X') then
                 Latch_DI0(21) := 'X';
              else
                 Latch_DI0(21) := Latch_DI0(21);
              end if;
              if (Tviol_DI22_0_CK_posedge = 'X') then
                 Latch_DI0(22) := 'X';
              else
                 Latch_DI0(22) := Latch_DI0(22);
              end if;
              if (Tviol_DI23_0_CK_posedge = 'X') then
                 Latch_DI0(23) := 'X';
              else
                 Latch_DI0(23) := Latch_DI0(23);
              end if;
              if (Tviol_DI24_0_CK_posedge = 'X') then
                 Latch_DI0(24) := 'X';
              else
                 Latch_DI0(24) := Latch_DI0(24);
              end if;
              if (Tviol_DI25_0_CK_posedge = 'X') then
                 Latch_DI0(25) := 'X';
              else
                 Latch_DI0(25) := Latch_DI0(25);
              end if;
              if (Tviol_DI26_0_CK_posedge = 'X') then
                 Latch_DI0(26) := 'X';
              else
                 Latch_DI0(26) := Latch_DI0(26);
              end if;
              if (Tviol_DI27_0_CK_posedge = 'X') then
                 Latch_DI0(27) := 'X';
              else
                 Latch_DI0(27) := Latch_DI0(27);
              end if;
              if (Tviol_DI28_0_CK_posedge = 'X') then
                 Latch_DI0(28) := 'X';
              else
                 Latch_DI0(28) := Latch_DI0(28);
              end if;
              if (Tviol_DI29_0_CK_posedge = 'X') then
                 Latch_DI0(29) := 'X';
              else
                 Latch_DI0(29) := Latch_DI0(29);
              end if;
              if (Tviol_DI30_0_CK_posedge = 'X') then
                 Latch_DI0(30) := 'X';
              else
                 Latch_DI0(30) := Latch_DI0(30);
              end if;
              if (Tviol_DI31_0_CK_posedge = 'X') then
                 Latch_DI0(31) := 'X';
              else
                 Latch_DI0(31) := Latch_DI0(31);
              end if;
              if (Tviol_DI0_1_CK_posedge = 'X') then
                 Latch_DI1(0) := 'X';
              else
                 Latch_DI1(0) := Latch_DI1(0);
              end if;
              if (Tviol_DI1_1_CK_posedge = 'X') then
                 Latch_DI1(1) := 'X';
              else
                 Latch_DI1(1) := Latch_DI1(1);
              end if;
              if (Tviol_DI2_1_CK_posedge = 'X') then
                 Latch_DI1(2) := 'X';
              else
                 Latch_DI1(2) := Latch_DI1(2);
              end if;
              if (Tviol_DI3_1_CK_posedge = 'X') then
                 Latch_DI1(3) := 'X';
              else
                 Latch_DI1(3) := Latch_DI1(3);
              end if;
              if (Tviol_DI4_1_CK_posedge = 'X') then
                 Latch_DI1(4) := 'X';
              else
                 Latch_DI1(4) := Latch_DI1(4);
              end if;
              if (Tviol_DI5_1_CK_posedge = 'X') then
                 Latch_DI1(5) := 'X';
              else
                 Latch_DI1(5) := Latch_DI1(5);
              end if;
              if (Tviol_DI6_1_CK_posedge = 'X') then
                 Latch_DI1(6) := 'X';
              else
                 Latch_DI1(6) := Latch_DI1(6);
              end if;
              if (Tviol_DI7_1_CK_posedge = 'X') then
                 Latch_DI1(7) := 'X';
              else
                 Latch_DI1(7) := Latch_DI1(7);
              end if;
              if (Tviol_DI8_1_CK_posedge = 'X') then
                 Latch_DI1(8) := 'X';
              else
                 Latch_DI1(8) := Latch_DI1(8);
              end if;
              if (Tviol_DI9_1_CK_posedge = 'X') then
                 Latch_DI1(9) := 'X';
              else
                 Latch_DI1(9) := Latch_DI1(9);
              end if;
              if (Tviol_DI10_1_CK_posedge = 'X') then
                 Latch_DI1(10) := 'X';
              else
                 Latch_DI1(10) := Latch_DI1(10);
              end if;
              if (Tviol_DI11_1_CK_posedge = 'X') then
                 Latch_DI1(11) := 'X';
              else
                 Latch_DI1(11) := Latch_DI1(11);
              end if;
              if (Tviol_DI12_1_CK_posedge = 'X') then
                 Latch_DI1(12) := 'X';
              else
                 Latch_DI1(12) := Latch_DI1(12);
              end if;
              if (Tviol_DI13_1_CK_posedge = 'X') then
                 Latch_DI1(13) := 'X';
              else
                 Latch_DI1(13) := Latch_DI1(13);
              end if;
              if (Tviol_DI14_1_CK_posedge = 'X') then
                 Latch_DI1(14) := 'X';
              else
                 Latch_DI1(14) := Latch_DI1(14);
              end if;
              if (Tviol_DI15_1_CK_posedge = 'X') then
                 Latch_DI1(15) := 'X';
              else
                 Latch_DI1(15) := Latch_DI1(15);
              end if;
              if (Tviol_DI16_1_CK_posedge = 'X') then
                 Latch_DI1(16) := 'X';
              else
                 Latch_DI1(16) := Latch_DI1(16);
              end if;
              if (Tviol_DI17_1_CK_posedge = 'X') then
                 Latch_DI1(17) := 'X';
              else
                 Latch_DI1(17) := Latch_DI1(17);
              end if;
              if (Tviol_DI18_1_CK_posedge = 'X') then
                 Latch_DI1(18) := 'X';
              else
                 Latch_DI1(18) := Latch_DI1(18);
              end if;
              if (Tviol_DI19_1_CK_posedge = 'X') then
                 Latch_DI1(19) := 'X';
              else
                 Latch_DI1(19) := Latch_DI1(19);
              end if;
              if (Tviol_DI20_1_CK_posedge = 'X') then
                 Latch_DI1(20) := 'X';
              else
                 Latch_DI1(20) := Latch_DI1(20);
              end if;
              if (Tviol_DI21_1_CK_posedge = 'X') then
                 Latch_DI1(21) := 'X';
              else
                 Latch_DI1(21) := Latch_DI1(21);
              end if;
              if (Tviol_DI22_1_CK_posedge = 'X') then
                 Latch_DI1(22) := 'X';
              else
                 Latch_DI1(22) := Latch_DI1(22);
              end if;
              if (Tviol_DI23_1_CK_posedge = 'X') then
                 Latch_DI1(23) := 'X';
              else
                 Latch_DI1(23) := Latch_DI1(23);
              end if;
              if (Tviol_DI24_1_CK_posedge = 'X') then
                 Latch_DI1(24) := 'X';
              else
                 Latch_DI1(24) := Latch_DI1(24);
              end if;
              if (Tviol_DI25_1_CK_posedge = 'X') then
                 Latch_DI1(25) := 'X';
              else
                 Latch_DI1(25) := Latch_DI1(25);
              end if;
              if (Tviol_DI26_1_CK_posedge = 'X') then
                 Latch_DI1(26) := 'X';
              else
                 Latch_DI1(26) := Latch_DI1(26);
              end if;
              if (Tviol_DI27_1_CK_posedge = 'X') then
                 Latch_DI1(27) := 'X';
              else
                 Latch_DI1(27) := Latch_DI1(27);
              end if;
              if (Tviol_DI28_1_CK_posedge = 'X') then
                 Latch_DI1(28) := 'X';
              else
                 Latch_DI1(28) := Latch_DI1(28);
              end if;
              if (Tviol_DI29_1_CK_posedge = 'X') then
                 Latch_DI1(29) := 'X';
              else
                 Latch_DI1(29) := Latch_DI1(29);
              end if;
              if (Tviol_DI30_1_CK_posedge = 'X') then
                 Latch_DI1(30) := 'X';
              else
                 Latch_DI1(30) := Latch_DI1(30);
              end if;
              if (Tviol_DI31_1_CK_posedge = 'X') then
                 Latch_DI1(31) := 'X';
              else
                 Latch_DI1(31) := Latch_DI1(31);
              end if;
              if (Tviol_DI0_2_CK_posedge = 'X') then
                 Latch_DI2(0) := 'X';
              else
                 Latch_DI2(0) := Latch_DI2(0);
              end if;
              if (Tviol_DI1_2_CK_posedge = 'X') then
                 Latch_DI2(1) := 'X';
              else
                 Latch_DI2(1) := Latch_DI2(1);
              end if;
              if (Tviol_DI2_2_CK_posedge = 'X') then
                 Latch_DI2(2) := 'X';
              else
                 Latch_DI2(2) := Latch_DI2(2);
              end if;
              if (Tviol_DI3_2_CK_posedge = 'X') then
                 Latch_DI2(3) := 'X';
              else
                 Latch_DI2(3) := Latch_DI2(3);
              end if;
              if (Tviol_DI4_2_CK_posedge = 'X') then
                 Latch_DI2(4) := 'X';
              else
                 Latch_DI2(4) := Latch_DI2(4);
              end if;
              if (Tviol_DI5_2_CK_posedge = 'X') then
                 Latch_DI2(5) := 'X';
              else
                 Latch_DI2(5) := Latch_DI2(5);
              end if;
              if (Tviol_DI6_2_CK_posedge = 'X') then
                 Latch_DI2(6) := 'X';
              else
                 Latch_DI2(6) := Latch_DI2(6);
              end if;
              if (Tviol_DI7_2_CK_posedge = 'X') then
                 Latch_DI2(7) := 'X';
              else
                 Latch_DI2(7) := Latch_DI2(7);
              end if;
              if (Tviol_DI8_2_CK_posedge = 'X') then
                 Latch_DI2(8) := 'X';
              else
                 Latch_DI2(8) := Latch_DI2(8);
              end if;
              if (Tviol_DI9_2_CK_posedge = 'X') then
                 Latch_DI2(9) := 'X';
              else
                 Latch_DI2(9) := Latch_DI2(9);
              end if;
              if (Tviol_DI10_2_CK_posedge = 'X') then
                 Latch_DI2(10) := 'X';
              else
                 Latch_DI2(10) := Latch_DI2(10);
              end if;
              if (Tviol_DI11_2_CK_posedge = 'X') then
                 Latch_DI2(11) := 'X';
              else
                 Latch_DI2(11) := Latch_DI2(11);
              end if;
              if (Tviol_DI12_2_CK_posedge = 'X') then
                 Latch_DI2(12) := 'X';
              else
                 Latch_DI2(12) := Latch_DI2(12);
              end if;
              if (Tviol_DI13_2_CK_posedge = 'X') then
                 Latch_DI2(13) := 'X';
              else
                 Latch_DI2(13) := Latch_DI2(13);
              end if;
              if (Tviol_DI14_2_CK_posedge = 'X') then
                 Latch_DI2(14) := 'X';
              else
                 Latch_DI2(14) := Latch_DI2(14);
              end if;
              if (Tviol_DI15_2_CK_posedge = 'X') then
                 Latch_DI2(15) := 'X';
              else
                 Latch_DI2(15) := Latch_DI2(15);
              end if;
              if (Tviol_DI16_2_CK_posedge = 'X') then
                 Latch_DI2(16) := 'X';
              else
                 Latch_DI2(16) := Latch_DI2(16);
              end if;
              if (Tviol_DI17_2_CK_posedge = 'X') then
                 Latch_DI2(17) := 'X';
              else
                 Latch_DI2(17) := Latch_DI2(17);
              end if;
              if (Tviol_DI18_2_CK_posedge = 'X') then
                 Latch_DI2(18) := 'X';
              else
                 Latch_DI2(18) := Latch_DI2(18);
              end if;
              if (Tviol_DI19_2_CK_posedge = 'X') then
                 Latch_DI2(19) := 'X';
              else
                 Latch_DI2(19) := Latch_DI2(19);
              end if;
              if (Tviol_DI20_2_CK_posedge = 'X') then
                 Latch_DI2(20) := 'X';
              else
                 Latch_DI2(20) := Latch_DI2(20);
              end if;
              if (Tviol_DI21_2_CK_posedge = 'X') then
                 Latch_DI2(21) := 'X';
              else
                 Latch_DI2(21) := Latch_DI2(21);
              end if;
              if (Tviol_DI22_2_CK_posedge = 'X') then
                 Latch_DI2(22) := 'X';
              else
                 Latch_DI2(22) := Latch_DI2(22);
              end if;
              if (Tviol_DI23_2_CK_posedge = 'X') then
                 Latch_DI2(23) := 'X';
              else
                 Latch_DI2(23) := Latch_DI2(23);
              end if;
              if (Tviol_DI24_2_CK_posedge = 'X') then
                 Latch_DI2(24) := 'X';
              else
                 Latch_DI2(24) := Latch_DI2(24);
              end if;
              if (Tviol_DI25_2_CK_posedge = 'X') then
                 Latch_DI2(25) := 'X';
              else
                 Latch_DI2(25) := Latch_DI2(25);
              end if;
              if (Tviol_DI26_2_CK_posedge = 'X') then
                 Latch_DI2(26) := 'X';
              else
                 Latch_DI2(26) := Latch_DI2(26);
              end if;
              if (Tviol_DI27_2_CK_posedge = 'X') then
                 Latch_DI2(27) := 'X';
              else
                 Latch_DI2(27) := Latch_DI2(27);
              end if;
              if (Tviol_DI28_2_CK_posedge = 'X') then
                 Latch_DI2(28) := 'X';
              else
                 Latch_DI2(28) := Latch_DI2(28);
              end if;
              if (Tviol_DI29_2_CK_posedge = 'X') then
                 Latch_DI2(29) := 'X';
              else
                 Latch_DI2(29) := Latch_DI2(29);
              end if;
              if (Tviol_DI30_2_CK_posedge = 'X') then
                 Latch_DI2(30) := 'X';
              else
                 Latch_DI2(30) := Latch_DI2(30);
              end if;
              if (Tviol_DI31_2_CK_posedge = 'X') then
                 Latch_DI2(31) := 'X';
              else
                 Latch_DI2(31) := Latch_DI2(31);
              end if;
              if (Tviol_DI0_3_CK_posedge = 'X') then
                 Latch_DI3(0) := 'X';
              else
                 Latch_DI3(0) := Latch_DI3(0);
              end if;
              if (Tviol_DI1_3_CK_posedge = 'X') then
                 Latch_DI3(1) := 'X';
              else
                 Latch_DI3(1) := Latch_DI3(1);
              end if;
              if (Tviol_DI2_3_CK_posedge = 'X') then
                 Latch_DI3(2) := 'X';
              else
                 Latch_DI3(2) := Latch_DI3(2);
              end if;
              if (Tviol_DI3_3_CK_posedge = 'X') then
                 Latch_DI3(3) := 'X';
              else
                 Latch_DI3(3) := Latch_DI3(3);
              end if;
              if (Tviol_DI4_3_CK_posedge = 'X') then
                 Latch_DI3(4) := 'X';
              else
                 Latch_DI3(4) := Latch_DI3(4);
              end if;
              if (Tviol_DI5_3_CK_posedge = 'X') then
                 Latch_DI3(5) := 'X';
              else
                 Latch_DI3(5) := Latch_DI3(5);
              end if;
              if (Tviol_DI6_3_CK_posedge = 'X') then
                 Latch_DI3(6) := 'X';
              else
                 Latch_DI3(6) := Latch_DI3(6);
              end if;
              if (Tviol_DI7_3_CK_posedge = 'X') then
                 Latch_DI3(7) := 'X';
              else
                 Latch_DI3(7) := Latch_DI3(7);
              end if;
              if (Tviol_DI8_3_CK_posedge = 'X') then
                 Latch_DI3(8) := 'X';
              else
                 Latch_DI3(8) := Latch_DI3(8);
              end if;
              if (Tviol_DI9_3_CK_posedge = 'X') then
                 Latch_DI3(9) := 'X';
              else
                 Latch_DI3(9) := Latch_DI3(9);
              end if;
              if (Tviol_DI10_3_CK_posedge = 'X') then
                 Latch_DI3(10) := 'X';
              else
                 Latch_DI3(10) := Latch_DI3(10);
              end if;
              if (Tviol_DI11_3_CK_posedge = 'X') then
                 Latch_DI3(11) := 'X';
              else
                 Latch_DI3(11) := Latch_DI3(11);
              end if;
              if (Tviol_DI12_3_CK_posedge = 'X') then
                 Latch_DI3(12) := 'X';
              else
                 Latch_DI3(12) := Latch_DI3(12);
              end if;
              if (Tviol_DI13_3_CK_posedge = 'X') then
                 Latch_DI3(13) := 'X';
              else
                 Latch_DI3(13) := Latch_DI3(13);
              end if;
              if (Tviol_DI14_3_CK_posedge = 'X') then
                 Latch_DI3(14) := 'X';
              else
                 Latch_DI3(14) := Latch_DI3(14);
              end if;
              if (Tviol_DI15_3_CK_posedge = 'X') then
                 Latch_DI3(15) := 'X';
              else
                 Latch_DI3(15) := Latch_DI3(15);
              end if;
              if (Tviol_DI16_3_CK_posedge = 'X') then
                 Latch_DI3(16) := 'X';
              else
                 Latch_DI3(16) := Latch_DI3(16);
              end if;
              if (Tviol_DI17_3_CK_posedge = 'X') then
                 Latch_DI3(17) := 'X';
              else
                 Latch_DI3(17) := Latch_DI3(17);
              end if;
              if (Tviol_DI18_3_CK_posedge = 'X') then
                 Latch_DI3(18) := 'X';
              else
                 Latch_DI3(18) := Latch_DI3(18);
              end if;
              if (Tviol_DI19_3_CK_posedge = 'X') then
                 Latch_DI3(19) := 'X';
              else
                 Latch_DI3(19) := Latch_DI3(19);
              end if;
              if (Tviol_DI20_3_CK_posedge = 'X') then
                 Latch_DI3(20) := 'X';
              else
                 Latch_DI3(20) := Latch_DI3(20);
              end if;
              if (Tviol_DI21_3_CK_posedge = 'X') then
                 Latch_DI3(21) := 'X';
              else
                 Latch_DI3(21) := Latch_DI3(21);
              end if;
              if (Tviol_DI22_3_CK_posedge = 'X') then
                 Latch_DI3(22) := 'X';
              else
                 Latch_DI3(22) := Latch_DI3(22);
              end if;
              if (Tviol_DI23_3_CK_posedge = 'X') then
                 Latch_DI3(23) := 'X';
              else
                 Latch_DI3(23) := Latch_DI3(23);
              end if;
              if (Tviol_DI24_3_CK_posedge = 'X') then
                 Latch_DI3(24) := 'X';
              else
                 Latch_DI3(24) := Latch_DI3(24);
              end if;
              if (Tviol_DI25_3_CK_posedge = 'X') then
                 Latch_DI3(25) := 'X';
              else
                 Latch_DI3(25) := Latch_DI3(25);
              end if;
              if (Tviol_DI26_3_CK_posedge = 'X') then
                 Latch_DI3(26) := 'X';
              else
                 Latch_DI3(26) := Latch_DI3(26);
              end if;
              if (Tviol_DI27_3_CK_posedge = 'X') then
                 Latch_DI3(27) := 'X';
              else
                 Latch_DI3(27) := Latch_DI3(27);
              end if;
              if (Tviol_DI28_3_CK_posedge = 'X') then
                 Latch_DI3(28) := 'X';
              else
                 Latch_DI3(28) := Latch_DI3(28);
              end if;
              if (Tviol_DI29_3_CK_posedge = 'X') then
                 Latch_DI3(29) := 'X';
              else
                 Latch_DI3(29) := Latch_DI3(29);
              end if;
              if (Tviol_DI30_3_CK_posedge = 'X') then
                 Latch_DI3(30) := 'X';
              else
                 Latch_DI3(30) := Latch_DI3(30);
              end if;
              if (Tviol_DI31_3_CK_posedge = 'X') then
                 Latch_DI3(31) := 'X';
              else
                 Latch_DI3(31) := Latch_DI3(31);
              end if;

	    
            if (Tviol_WEB0_CK_posedge = 'X') then
               Latch_WEB0 := 'X';
            else
               Latch_WEB0 := Latch_WEB0;
            end if;
            if (Tviol_WEB0_CK_posedge = 'X') then
               Latch_WEB1 := 'X';
            else
               Latch_WEB1 := Latch_WEB1;
            end if;
            if (Tviol_WEB0_CK_posedge = 'X') then
               Latch_WEB2 := 'X';
            else
               Latch_WEB2 := Latch_WEB2;
            end if;
            if (Tviol_WEB0_CK_posedge = 'X') then
               Latch_WEB3 := 'X';
            else
               Latch_WEB3 := Latch_WEB3;
            end if;
            if (Tviol_CSB_CK_posedge = 'X') then
               Latch_CSB := 'X';
            else
               Latch_CSB := Latch_CSB;
            end if;


                -- memory_function
                A_i    := Latch_A;
                CSB_i   := Latch_CSB;
                DI0_i  := Latch_DI0;
                WEB0_i := Latch_WEB0;
                DI1_i  := Latch_DI1;
                WEB1_i := Latch_WEB1;
                DI2_i  := Latch_DI2;
                WEB2_i := Latch_WEB2;
                DI3_i  := Latch_DI3;
                WEB3_i := Latch_WEB3;



                web0_cs    := WEB0_i&CSB_i;
                case web0_cs is
                   when "10" => 
                       -------- Reduce error message --------------------------
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           DO0_zd := memoryCore0(to_integer(A_i));
                             ScheduleOutputDelayTOH(DO0_int(0), DO0_zd(0),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(96),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(1), DO0_zd(1),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(97),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(2), DO0_zd(2),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(98),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(3), DO0_zd(3),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(99),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(4), DO0_zd(4),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(100),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(5), DO0_zd(5),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(101),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(6), DO0_zd(6),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(102),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(7), DO0_zd(7),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(103),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(8), DO0_zd(8),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(104),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(9), DO0_zd(9),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(105),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(10), DO0_zd(10),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(106),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(11), DO0_zd(11),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(107),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(12), DO0_zd(12),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(108),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(13), DO0_zd(13),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(109),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(14), DO0_zd(14),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(110),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(15), DO0_zd(15),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(111),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(16), DO0_zd(16),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(112),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(17), DO0_zd(17),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(113),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(18), DO0_zd(18),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(114),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(19), DO0_zd(19),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(115),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(20), DO0_zd(20),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(116),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(21), DO0_zd(21),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(117),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(22), DO0_zd(22),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(118),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(23), DO0_zd(23),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(119),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(24), DO0_zd(24),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(120),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(25), DO0_zd(25),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(121),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(26), DO0_zd(26),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(122),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(27), DO0_zd(27),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(123),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(28), DO0_zd(28),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(124),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(29), DO0_zd(29),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(125),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(30), DO0_zd(30),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(126),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO0_int(31), DO0_zd(31),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_read0_posedge(127),
                                last_A,A_i,last_WEB0,WEB0_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO0_zd := (OTHERS => 'X');
                           DO0_int <= TRANSPORT (OTHERS => 'X');
                       end if;

                   when "00" => 
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           memoryCore0(to_integer(A_i)) := DI0_i;
                           DO0_zd := memoryCore0(to_integer(A_i));
                             ScheduleOutputDelayTWDX(DO0_int(0), DO0_zd(0),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(96),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(1), DO0_zd(1),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(97),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(2), DO0_zd(2),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(98),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(3), DO0_zd(3),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(99),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(4), DO0_zd(4),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(100),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(5), DO0_zd(5),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(101),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(6), DO0_zd(6),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(102),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(7), DO0_zd(7),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(103),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(8), DO0_zd(8),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(104),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(9), DO0_zd(9),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(105),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(10), DO0_zd(10),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(106),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(11), DO0_zd(11),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(107),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(12), DO0_zd(12),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(108),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(13), DO0_zd(13),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(109),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(14), DO0_zd(14),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(110),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(15), DO0_zd(15),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(111),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(16), DO0_zd(16),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(112),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(17), DO0_zd(17),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(113),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(18), DO0_zd(18),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(114),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(19), DO0_zd(19),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(115),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(20), DO0_zd(20),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(116),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(21), DO0_zd(21),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(117),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(22), DO0_zd(22),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(118),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(23), DO0_zd(23),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(119),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(24), DO0_zd(24),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(120),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(25), DO0_zd(25),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(121),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(26), DO0_zd(26),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(122),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(27), DO0_zd(27),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(123),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(28), DO0_zd(28),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(124),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(29), DO0_zd(29),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(125),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(30), DO0_zd(30),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(126),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO0_int(31), DO0_zd(31),
                                tpd_CK_DO_NODELAY0_EQ_0_AN_write0_posedge(127),
                                last_A,A_i,last_WEB0,WEB0_i,last_DI0,DI0_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO0_zd := (OTHERS => 'X');
                           DO0_int <= TRANSPORT (OTHERS => 'X');
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO0_zd := (OTHERS => 'X');
                           DO0_int <= TRANSPORT (OTHERS => 'X') AFTER TWDX;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore0(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;

                   when "1X" |
                        "1U" |
                        "1Z" => DO0_zd := (OTHERS => 'X');
                                DO0_int <= TRANSPORT (OTHERS => 'X') AFTER TOH; 
                   when "11" |
                        "01" |
                        "X1" |
                        "U1" |
                        "Z1"   => -- do nothing
                   when others =>
                                if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                                   -- Reduce error message --
                                   flag_A := True_flg;
                                   --------------------------
                                   memoryCore0(to_integer(A_i)) := (OTHERS => 'X');
                                   DO0_zd := (OTHERS => 'X');
                                   DO0_int <= TRANSPORT (OTHERS => 'X');
                                elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                                    -- Reduce error message --
                                    flag_A := False_flg;
                                    --------------------------
                                    DO0_zd := (OTHERS => 'X');
                                    DO0_int <= TRANSPORT (OTHERS => 'X');
                                else
                                   -- Reduce error message --
                                   flag_A := False_flg;
                                   --------------------------
                                   DO0_zd := (OTHERS => 'X');
                                   DO0_int <= TRANSPORT (OTHERS => 'X');
                                   FOR i IN Words-1 downto 0 LOOP
                                      memoryCore0(i) := (OTHERS => 'X');
                                   END LOOP;
                                end if;
                end case;


                web1_cs    := WEB1_i&CSB_i;
                case web1_cs is
                   when "10" => 
                       -------- Reduce error message --------------------------
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           DO1_zd := memoryCore1(to_integer(A_i));
                             ScheduleOutputDelayTOH(DO1_int(0), DO1_zd(0),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(64),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(1), DO1_zd(1),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(65),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(2), DO1_zd(2),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(66),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(3), DO1_zd(3),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(67),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(4), DO1_zd(4),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(68),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(5), DO1_zd(5),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(69),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(6), DO1_zd(6),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(70),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(7), DO1_zd(7),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(71),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(8), DO1_zd(8),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(72),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(9), DO1_zd(9),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(73),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(10), DO1_zd(10),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(74),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(11), DO1_zd(11),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(75),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(12), DO1_zd(12),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(76),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(13), DO1_zd(13),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(77),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(14), DO1_zd(14),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(78),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(15), DO1_zd(15),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(79),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(16), DO1_zd(16),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(80),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(17), DO1_zd(17),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(81),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(18), DO1_zd(18),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(82),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(19), DO1_zd(19),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(83),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(20), DO1_zd(20),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(84),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(21), DO1_zd(21),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(85),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(22), DO1_zd(22),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(86),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(23), DO1_zd(23),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(87),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(24), DO1_zd(24),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(88),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(25), DO1_zd(25),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(89),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(26), DO1_zd(26),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(90),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(27), DO1_zd(27),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(91),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(28), DO1_zd(28),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(92),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(29), DO1_zd(29),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(93),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(30), DO1_zd(30),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(94),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO1_int(31), DO1_zd(31),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_read1_posedge(95),
                                last_A,A_i,last_WEB1,WEB1_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO1_zd := (OTHERS => 'X');
                           DO1_int <= TRANSPORT (OTHERS => 'X');
                       end if;

                   when "00" => 
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           memoryCore1(to_integer(A_i)) := DI1_i;
                           DO1_zd := memoryCore1(to_integer(A_i));
                             ScheduleOutputDelayTWDX(DO1_int(0), DO1_zd(0),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(64),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(1), DO1_zd(1),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(65),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(2), DO1_zd(2),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(66),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(3), DO1_zd(3),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(67),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(4), DO1_zd(4),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(68),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(5), DO1_zd(5),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(69),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(6), DO1_zd(6),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(70),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(7), DO1_zd(7),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(71),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(8), DO1_zd(8),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(72),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(9), DO1_zd(9),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(73),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(10), DO1_zd(10),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(74),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(11), DO1_zd(11),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(75),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(12), DO1_zd(12),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(76),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(13), DO1_zd(13),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(77),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(14), DO1_zd(14),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(78),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(15), DO1_zd(15),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(79),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(16), DO1_zd(16),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(80),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(17), DO1_zd(17),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(81),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(18), DO1_zd(18),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(82),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(19), DO1_zd(19),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(83),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(20), DO1_zd(20),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(84),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(21), DO1_zd(21),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(85),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(22), DO1_zd(22),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(86),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(23), DO1_zd(23),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(87),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(24), DO1_zd(24),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(88),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(25), DO1_zd(25),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(89),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(26), DO1_zd(26),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(90),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(27), DO1_zd(27),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(91),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(28), DO1_zd(28),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(92),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(29), DO1_zd(29),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(93),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(30), DO1_zd(30),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(94),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO1_int(31), DO1_zd(31),
                                tpd_CK_DO_NODELAY1_EQ_0_AN_write1_posedge(95),
                                last_A,A_i,last_WEB1,WEB1_i,last_DI1,DI1_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO1_zd := (OTHERS => 'X');
                           DO1_int <= TRANSPORT (OTHERS => 'X');
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO1_zd := (OTHERS => 'X');
                           DO1_int <= TRANSPORT (OTHERS => 'X') AFTER TWDX;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore1(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;

                   when "1X" |
                        "1U" |
                        "1Z" => DO1_zd := (OTHERS => 'X');
                                DO1_int <= TRANSPORT (OTHERS => 'X') AFTER TOH; 
                   when "11" |
                        "01" |
                        "X1" |
                        "U1" |
                        "Z1"   => -- do nothing
                   when others =>
                                if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                                   -- Reduce error message --
                                   flag_A := True_flg;
                                   --------------------------
                                   memoryCore1(to_integer(A_i)) := (OTHERS => 'X');
                                   DO1_zd := (OTHERS => 'X');
                                   DO1_int <= TRANSPORT (OTHERS => 'X');
                                elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                                    -- Reduce error message --
                                    flag_A := False_flg;
                                    --------------------------
                                    DO1_zd := (OTHERS => 'X');
                                    DO1_int <= TRANSPORT (OTHERS => 'X');
                                else
                                   -- Reduce error message --
                                   flag_A := False_flg;
                                   --------------------------
                                   DO1_zd := (OTHERS => 'X');
                                   DO1_int <= TRANSPORT (OTHERS => 'X');
                                   FOR i IN Words-1 downto 0 LOOP
                                      memoryCore1(i) := (OTHERS => 'X');
                                   END LOOP;
                                end if;
                end case;


                web2_cs    := WEB2_i&CSB_i;
                case web2_cs is
                   when "10" => 
                       -------- Reduce error message --------------------------
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           DO2_zd := memoryCore2(to_integer(A_i));
                             ScheduleOutputDelayTOH(DO2_int(0), DO2_zd(0),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(32),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(1), DO2_zd(1),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(33),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(2), DO2_zd(2),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(34),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(3), DO2_zd(3),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(35),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(4), DO2_zd(4),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(36),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(5), DO2_zd(5),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(37),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(6), DO2_zd(6),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(38),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(7), DO2_zd(7),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(39),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(8), DO2_zd(8),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(40),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(9), DO2_zd(9),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(41),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(10), DO2_zd(10),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(42),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(11), DO2_zd(11),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(43),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(12), DO2_zd(12),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(44),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(13), DO2_zd(13),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(45),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(14), DO2_zd(14),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(46),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(15), DO2_zd(15),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(47),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(16), DO2_zd(16),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(48),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(17), DO2_zd(17),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(49),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(18), DO2_zd(18),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(50),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(19), DO2_zd(19),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(51),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(20), DO2_zd(20),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(52),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(21), DO2_zd(21),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(53),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(22), DO2_zd(22),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(54),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(23), DO2_zd(23),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(55),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(24), DO2_zd(24),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(56),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(25), DO2_zd(25),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(57),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(26), DO2_zd(26),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(58),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(27), DO2_zd(27),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(59),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(28), DO2_zd(28),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(60),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(29), DO2_zd(29),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(61),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(30), DO2_zd(30),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(62),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO2_int(31), DO2_zd(31),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_read2_posedge(63),
                                last_A,A_i,last_WEB2,WEB2_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO2_zd := (OTHERS => 'X');
                           DO2_int <= TRANSPORT (OTHERS => 'X');
                       end if;

                   when "00" => 
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           memoryCore2(to_integer(A_i)) := DI2_i;
                           DO2_zd := memoryCore2(to_integer(A_i));
                             ScheduleOutputDelayTWDX(DO2_int(0), DO2_zd(0),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(32),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(1), DO2_zd(1),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(33),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(2), DO2_zd(2),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(34),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(3), DO2_zd(3),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(35),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(4), DO2_zd(4),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(36),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(5), DO2_zd(5),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(37),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(6), DO2_zd(6),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(38),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(7), DO2_zd(7),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(39),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(8), DO2_zd(8),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(40),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(9), DO2_zd(9),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(41),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(10), DO2_zd(10),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(42),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(11), DO2_zd(11),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(43),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(12), DO2_zd(12),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(44),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(13), DO2_zd(13),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(45),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(14), DO2_zd(14),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(46),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(15), DO2_zd(15),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(47),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(16), DO2_zd(16),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(48),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(17), DO2_zd(17),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(49),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(18), DO2_zd(18),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(50),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(19), DO2_zd(19),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(51),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(20), DO2_zd(20),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(52),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(21), DO2_zd(21),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(53),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(22), DO2_zd(22),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(54),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(23), DO2_zd(23),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(55),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(24), DO2_zd(24),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(56),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(25), DO2_zd(25),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(57),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(26), DO2_zd(26),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(58),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(27), DO2_zd(27),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(59),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(28), DO2_zd(28),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(60),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(29), DO2_zd(29),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(61),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(30), DO2_zd(30),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(62),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO2_int(31), DO2_zd(31),
                                tpd_CK_DO_NODELAY2_EQ_0_AN_write2_posedge(63),
                                last_A,A_i,last_WEB2,WEB2_i,last_DI2,DI2_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO2_zd := (OTHERS => 'X');
                           DO2_int <= TRANSPORT (OTHERS => 'X');
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO2_zd := (OTHERS => 'X');
                           DO2_int <= TRANSPORT (OTHERS => 'X') AFTER TWDX;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore2(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;

                   when "1X" |
                        "1U" |
                        "1Z" => DO2_zd := (OTHERS => 'X');
                                DO2_int <= TRANSPORT (OTHERS => 'X') AFTER TOH; 
                   when "11" |
                        "01" |
                        "X1" |
                        "U1" |
                        "Z1"   => -- do nothing
                   when others =>
                                if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                                   -- Reduce error message --
                                   flag_A := True_flg;
                                   --------------------------
                                   memoryCore2(to_integer(A_i)) := (OTHERS => 'X');
                                   DO2_zd := (OTHERS => 'X');
                                   DO2_int <= TRANSPORT (OTHERS => 'X');
                                elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                                    -- Reduce error message --
                                    flag_A := False_flg;
                                    --------------------------
                                    DO2_zd := (OTHERS => 'X');
                                    DO2_int <= TRANSPORT (OTHERS => 'X');
                                else
                                   -- Reduce error message --
                                   flag_A := False_flg;
                                   --------------------------
                                   DO2_zd := (OTHERS => 'X');
                                   DO2_int <= TRANSPORT (OTHERS => 'X');
                                   FOR i IN Words-1 downto 0 LOOP
                                      memoryCore2(i) := (OTHERS => 'X');
                                   END LOOP;
                                end if;
                end case;


                web3_cs    := WEB3_i&CSB_i;
                case web3_cs is
                   when "10" => 
                       -------- Reduce error message --------------------------
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           DO3_zd := memoryCore3(to_integer(A_i));
                             ScheduleOutputDelayTOH(DO3_int(0), DO3_zd(0),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(0),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(1), DO3_zd(1),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(1),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(2), DO3_zd(2),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(2),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(3), DO3_zd(3),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(3),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(4), DO3_zd(4),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(4),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(5), DO3_zd(5),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(5),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(6), DO3_zd(6),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(6),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(7), DO3_zd(7),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(7),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(8), DO3_zd(8),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(8),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(9), DO3_zd(9),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(9),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(10), DO3_zd(10),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(10),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(11), DO3_zd(11),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(11),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(12), DO3_zd(12),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(12),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(13), DO3_zd(13),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(13),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(14), DO3_zd(14),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(14),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(15), DO3_zd(15),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(15),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(16), DO3_zd(16),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(16),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(17), DO3_zd(17),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(17),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(18), DO3_zd(18),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(18),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(19), DO3_zd(19),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(19),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(20), DO3_zd(20),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(20),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(21), DO3_zd(21),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(21),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(22), DO3_zd(22),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(22),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(23), DO3_zd(23),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(23),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(24), DO3_zd(24),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(24),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(25), DO3_zd(25),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(25),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(26), DO3_zd(26),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(26),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(27), DO3_zd(27),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(27),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(28), DO3_zd(28),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(28),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(29), DO3_zd(29),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(29),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(30), DO3_zd(30),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(30),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO3_int(31), DO3_zd(31),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_read3_posedge(31),
                                last_A,A_i,last_WEB3,WEB3_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO3_zd := (OTHERS => 'X');
                           DO3_int <= TRANSPORT (OTHERS => 'X');
                       end if;

                   when "00" => 
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           memoryCore3(to_integer(A_i)) := DI3_i;
                           DO3_zd := memoryCore3(to_integer(A_i));
                             ScheduleOutputDelayTWDX(DO3_int(0), DO3_zd(0),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(0),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(1), DO3_zd(1),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(1),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(2), DO3_zd(2),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(2),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(3), DO3_zd(3),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(3),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(4), DO3_zd(4),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(4),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(5), DO3_zd(5),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(5),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(6), DO3_zd(6),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(6),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(7), DO3_zd(7),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(7),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(8), DO3_zd(8),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(8),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(9), DO3_zd(9),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(9),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(10), DO3_zd(10),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(10),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(11), DO3_zd(11),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(11),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(12), DO3_zd(12),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(12),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(13), DO3_zd(13),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(13),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(14), DO3_zd(14),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(14),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(15), DO3_zd(15),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(15),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(16), DO3_zd(16),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(16),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(17), DO3_zd(17),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(17),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(18), DO3_zd(18),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(18),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(19), DO3_zd(19),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(19),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(20), DO3_zd(20),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(20),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(21), DO3_zd(21),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(21),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(22), DO3_zd(22),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(22),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(23), DO3_zd(23),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(23),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(24), DO3_zd(24),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(24),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(25), DO3_zd(25),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(25),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(26), DO3_zd(26),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(26),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(27), DO3_zd(27),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(27),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(28), DO3_zd(28),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(28),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(29), DO3_zd(29),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(29),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(30), DO3_zd(30),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(30),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO3_int(31), DO3_zd(31),
                                tpd_CK_DO_NODELAY3_EQ_0_AN_write3_posedge(31),
                                last_A,A_i,last_WEB3,WEB3_i,last_DI3,DI3_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO3_zd := (OTHERS => 'X');
                           DO3_int <= TRANSPORT (OTHERS => 'X');
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO3_zd := (OTHERS => 'X');
                           DO3_int <= TRANSPORT (OTHERS => 'X') AFTER TWDX;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore3(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;

                   when "1X" |
                        "1U" |
                        "1Z" => DO3_zd := (OTHERS => 'X');
                                DO3_int <= TRANSPORT (OTHERS => 'X') AFTER TOH; 
                   when "11" |
                        "01" |
                        "X1" |
                        "U1" |
                        "Z1"   => -- do nothing
                   when others =>
                                if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                                   -- Reduce error message --
                                   flag_A := True_flg;
                                   --------------------------
                                   memoryCore3(to_integer(A_i)) := (OTHERS => 'X');
                                   DO3_zd := (OTHERS => 'X');
                                   DO3_int <= TRANSPORT (OTHERS => 'X');
                                elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                                    -- Reduce error message --
                                    flag_A := False_flg;
                                    --------------------------
                                    DO3_zd := (OTHERS => 'X');
                                    DO3_int <= TRANSPORT (OTHERS => 'X');
                                else
                                   -- Reduce error message --
                                   flag_A := False_flg;
                                   --------------------------
                                   DO3_zd := (OTHERS => 'X');
                                   DO3_int <= TRANSPORT (OTHERS => 'X');
                                   FOR i IN Words-1 downto 0 LOOP
                                      memoryCore3(i) := (OTHERS => 'X');
                                   END LOOP;
                                end if;
                end case;

                -- end memory_function

         end if;
       end if;

   end PROCESS;


end behavior;
