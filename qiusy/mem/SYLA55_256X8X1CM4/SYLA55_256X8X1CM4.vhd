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
--        Bit                :  8                                                        
--        Byte               :  1                                                        
--        Mux                :  4                                                        
--        Output Loading     :  0.01                                                     
--        Clock Input Slew   :  0.008                                                    
--        Data Input Slew    :  0.008                                                    
--        Ring Type          :  Ring Shape Model                                         
--        Ring Layer         :  2233                                                     
--        Ring Width         :  2                                                        
--        Bus Format         :  1                                                        
--        Memaker Path       :  /workspace/technology/umc/55nm_201908/memlib_GDS/memlib  
--        GUI Version        :  m20130120                                                
--        Date               :  2020/07/14 14:53:58                                      
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
entity SYLA55_256X8X1CM4 is
   generic(
      SYN_CS:          integer  := 1;
      NO_SER_TOH:      integer  := 1;
      AddressSize:     integer  := 8;
      DVSize:          integer  := 4;
      Bits:            integer  := 8;
      Words:           integer  := 256;
      Bytes:           integer  := 1;
      AspectRatio:     integer  := 4;
      TOH:             time     := 0.620 ns;
      TWDX:            time     := 0.756 ns;

      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := True;
      MsgOn: Boolean := True;

      tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge : VitalDelayArrayType01(0 to 7) :=  (others => (0.951 ns, 0.951 ns));

      tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge : VitalDelayArrayType01(0 to 7) :=  (others => (0.951 ns, 0.951 ns));

      tsetup_A_CK_posedge_posedge    :  VitalDelayArrayType(0 to 7) :=  (others => (0.122 ns));
      tsetup_A_CK_negedge_posedge    :  VitalDelayArrayType(0 to 7) :=  (others => (0.122 ns));
      thold_A_CK_posedge_posedge     :  VitalDelayArrayType(0 to 7) :=  (others => (0.017 ns));
      thold_A_CK_negedge_posedge     :  VitalDelayArrayType(0 to 7) :=  (others => (0.017 ns));   
         
      tsetup_DI_CK_posedge_posedge    :  VitalDelayArrayType(0 to 7) :=  (others => (0.128 ns));
      tsetup_DI_CK_negedge_posedge    :  VitalDelayArrayType(0 to 7) :=  (others => (0.128 ns));
      thold_DI_CK_posedge_posedge     :  VitalDelayArrayType(0 to 7) :=  (others => (0.044 ns));
      thold_DI_CK_negedge_posedge     :  VitalDelayArrayType(0 to 7) :=  (others => (0.044 ns));


      tsetup_WEB_CK_posedge_posedge   :  VitalDelayType := 0.070 ns;
      tsetup_WEB_CK_negedge_posedge   :  VitalDelayType := 0.070 ns;
      thold_WEB_CK_posedge_posedge    :  VitalDelayType := 0.094 ns;
      thold_WEB_CK_negedge_posedge    :  VitalDelayType := 0.094 ns;

      tsetup_CSB_CK_posedge_posedge    :  VitalDelayType := 0.231 ns;
      tsetup_CSB_CK_negedge_posedge    :  VitalDelayType := 0.231 ns;
      thold_CSB_CK_posedge_posedge     :  VitalDelayType := 0.106 ns;
      thold_CSB_CK_negedge_posedge     :  VitalDelayType := 0.106 ns;


      tperiod_CK                        :  VitalDelayType := 1.112 ns;
      tpw_CK_posedge                 :  VitalDelayType := 0.202 ns;
      tpw_CK_negedge                 :  VitalDelayType := 0.202 ns;
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
      tipd_WEB                       :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CSB                       :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CK                        :  VitalDelayType01 := (0.000 ns, 0.000 ns)
      );

   port(
      DO                            :   OUT  std_logic_vector (7 downto 0); 
      A                             :   IN   std_logic_vector (7 downto 0); 
      DI                            :   IN   std_logic_vector (7 downto 0);
      WEB                           :   IN   std_logic;
      DVSE                          :   IN   std_logic;
      DVS                           :   IN   std_logic_vector (3 downto 0);
      CK                            :   IN   std_logic;
      CSB                           :   IN   std_logic             
      );

attribute VITAL_LEVEL0 of SYLA55_256X8X1CM4 : entity is TRUE;

end SYLA55_256X8X1CM4;

-- architecture body --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

architecture behavior of SYLA55_256X8X1CM4 is
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
   SIGNAL WEB_ipd       : std_logic := 'X';
   SIGNAL DI_ipd        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   SIGNAL DO_int        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   
begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (CK_ipd, CK, tipd_CK);
   VitalWireDelay (CSB_ipd, CSB, tipd_CSB);
   VitalWireDelay (WEB_ipd, WEB, tipd_WEB);
   VitalWireDelay (A_ipd(0), A(0), tipd_A0);
   VitalWireDelay (A_ipd(1), A(1), tipd_A1);
   VitalWireDelay (A_ipd(2), A(2), tipd_A2);
   VitalWireDelay (A_ipd(3), A(3), tipd_A3);
   VitalWireDelay (A_ipd(4), A(4), tipd_A4);
   VitalWireDelay (A_ipd(5), A(5), tipd_A5);
   VitalWireDelay (A_ipd(6), A(6), tipd_A6);
   VitalWireDelay (A_ipd(7), A(7), tipd_A7);
   VitalWireDelay (DI_ipd(0), DI(0), tipd_DI0);
   VitalWireDelay (DI_ipd(1), DI(1), tipd_DI1);
   VitalWireDelay (DI_ipd(2), DI(2), tipd_DI2);
   VitalWireDelay (DI_ipd(3), DI(3), tipd_DI3);
   VitalWireDelay (DI_ipd(4), DI(4), tipd_DI4);
   VitalWireDelay (DI_ipd(5), DI(5), tipd_DI5);
   VitalWireDelay (DI_ipd(6), DI(6), tipd_DI6);
   VitalWireDelay (DI_ipd(7), DI(7), tipd_DI7);


   end block;

   VitalBUF (DO(0), DO_int(0));
   VitalBUF (DO(1), DO_int(1));
   VitalBUF (DO(2), DO_int(2));
   VitalBUF (DO(3), DO_int(3));
   VitalBUF (DO(4), DO_int(4));
   VitalBUF (DO(5), DO_int(5));
   VitalBUF (DO(6), DO_int(6));
   VitalBUF (DO(7), DO_int(7));

   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : PROCESS (CSB_ipd, 
                            A_ipd,
                            WEB_ipd,
                            DI_ipd,
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
   VARIABLE Tviol_WEB_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI0_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI1_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI2_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI3_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI4_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI5_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI6_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI7_CK_posedge  : STD_ULOGIC := '0';
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
   VARIABLE Tmkr_WEB_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI0_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI1_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI2_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI3_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI4_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI5_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI6_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI7_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_CSB_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;



   VARIABLE DO_zd : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE memoryCore  : memoryArray;

   VARIABLE ck_change   : std_logic_vector(1 downto 0);
   VARIABLE web_cs      : std_logic_vector(1 downto 0);

   -- previous latch data
   VARIABLE Latch_A        : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE Latch_DI       : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE Latch_WEB      : std_logic := 'X';
   VARIABLE Latch_CSB       : std_logic := 'X';

   -- internal latch data
   VARIABLE A_i            : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE DI_i           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE WEB_i          : std_logic := 'X';
   VARIABLE CSB_i           : std_logic := 'X';



   VARIABLE last_A         : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE last_DI           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE last_WEB       : std_logic := 'X';

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
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
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
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
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
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
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
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
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
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
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
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
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
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
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
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalSetupHoldCheck (
          Violation               => Tviol_WEB_CK_posedge,
          TimingData              => Tmkr_WEB_CK_posedge,
          TestSignal              => WEB_ipd,
          TestSignalName          => "WEB",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_WEB_CK_posedge_posedge,
          SetupLow                => tsetup_WEB_CK_negedge_posedge,
          HoldHigh                => thold_WEB_CK_negedge_posedge,
          HoldLow                 => thold_WEB_CK_posedge_posedge,
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '0',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalSetupHoldCheck (
          Violation               => Tviol_DI0_CK_posedge,
          TimingData              => Tmkr_DI0_CK_posedge,
          TestSignal              => DI_ipd(0),
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
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI1_CK_posedge,
          TimingData              => Tmkr_DI1_CK_posedge,
          TestSignal              => DI_ipd(1),
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
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI2_CK_posedge,
          TimingData              => Tmkr_DI2_CK_posedge,
          TestSignal              => DI_ipd(2),
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
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI3_CK_posedge,
          TimingData              => Tmkr_DI3_CK_posedge,
          TestSignal              => DI_ipd(3),
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
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI4_CK_posedge,
          TimingData              => Tmkr_DI4_CK_posedge,
          TestSignal              => DI_ipd(4),
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
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI5_CK_posedge,
          TimingData              => Tmkr_DI5_CK_posedge,
          TestSignal              => DI_ipd(5),
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
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI6_CK_posedge,
          TimingData              => Tmkr_DI6_CK_posedge,
          TestSignal              => DI_ipd(6),
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
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DI7_CK_posedge,
          TimingData              => Tmkr_DI7_CK_posedge,
          TestSignal              => DI_ipd(7),
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
                           NOW /= 0 ns AND CSB_ipd = '0' AND WEB_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
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
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
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
          HeaderMsg               => InstancePath & "/SYLA55_256X8X1CM4",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);


	  
   end if;

   -------------------------
   --  Functionality Section
   -------------------------


       if (CSB_ipd = '1' and CSB_ipd'event) then
          if (SYN_CS = 0) then
             DO_zd := (OTHERS => 'X');
             DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
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
                Latch_DI  := DI_ipd;
                Latch_WEB := WEB_ipd;

                -- memory_function
                A_i    := Latch_A;
                CSB_i   := Latch_CSB;
                DI_i  := Latch_DI;
                WEB_i := Latch_WEB;


                web_cs    := WEB_i&CSB_i;
                case web_cs is
                   when "10" => 
                       -------- Reduce error message --------------------------
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           DO_zd := memoryCore(to_integer(A_i));		   
                           ScheduleOutputDelayTOH(DO_int(0), DO_zd(0),
                              tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(0),
                              last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                           ScheduleOutputDelayTOH(DO_int(1), DO_zd(1),
                              tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(1),
                              last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                           ScheduleOutputDelayTOH(DO_int(2), DO_zd(2),
                              tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(2),
                              last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                           ScheduleOutputDelayTOH(DO_int(3), DO_zd(3),
                              tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(3),
                              last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                           ScheduleOutputDelayTOH(DO_int(4), DO_zd(4),
                              tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(4),
                              last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                           ScheduleOutputDelayTOH(DO_int(5), DO_zd(5),
                              tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(5),
                              last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                           ScheduleOutputDelayTOH(DO_int(6), DO_zd(6),
                              tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(6),
                              last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                           ScheduleOutputDelayTOH(DO_int(7), DO_zd(7),
                              tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(7),
                              last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO_zd := (OTHERS => 'X');
                           DO_int <= TRANSPORT (OTHERS => 'X');
                       end if;

                   when "00" => 
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           memoryCore(to_integer(A_i)) := DI_i;
                           DO_zd := memoryCore(to_integer(A_i));
                           ScheduleOutputDelayTWDX(DO_int(0), DO_zd(0),
                              tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(0),
                              last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                           ScheduleOutputDelayTWDX(DO_int(1), DO_zd(1),
                              tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(1),
                              last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                           ScheduleOutputDelayTWDX(DO_int(2), DO_zd(2),
                              tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(2),
                              last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                           ScheduleOutputDelayTWDX(DO_int(3), DO_zd(3),
                              tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(3),
                              last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                           ScheduleOutputDelayTWDX(DO_int(4), DO_zd(4),
                              tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(4),
                              last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                           ScheduleOutputDelayTWDX(DO_int(5), DO_zd(5),
                              tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(5),
                              last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                           ScheduleOutputDelayTWDX(DO_int(6), DO_zd(6),
                              tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(6),
                              last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                           ScheduleOutputDelayTWDX(DO_int(7), DO_zd(7),
                              tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(7),
                              last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO_zd := (OTHERS => 'X');
                           DO_int <= TRANSPORT (OTHERS => 'X');
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO_zd := (OTHERS => 'X');
                           DO_int <= TRANSPORT (OTHERS => 'X') AFTER TWDX;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;

                   when "1X" |
                        "1U" |
                        "1Z" => DO_zd := (OTHERS => 'X');
                                DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH; 
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
                                   memoryCore(to_integer(A_i)) := (OTHERS => 'X');
                                   DO_zd := (OTHERS => 'X');
                                   DO_int <= TRANSPORT (OTHERS => 'X');
                                elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                                    -- Reduce error message --
                                    flag_A := False_flg;
                                    --------------------------
                                    DO_zd := (OTHERS => 'X');
                                    DO_int <= TRANSPORT (OTHERS => 'X');
                                else
                                   -- Reduce error message --
                                   flag_A := False_flg;
                                   --------------------------
                                   DO_zd := (OTHERS => 'X');
                                   DO_int <= TRANSPORT (OTHERS => 'X');
                                   FOR i IN Words-1 downto 0 LOOP
                                      memoryCore(i) := (OTHERS => 'X');
                                   END LOOP;
                                end if;
                end case;


                -- end memory_function
                last_A := A_ipd;
                last_DI := DI_ipd;
                last_WEB := WEB_ipd;
            when "10"   => -- do nothing
            when others => if (NOW /= 0 ns) then
                              assert FALSE report "** MEM_Error: Abnormal transition occurred." severity WARNING;
                           end if;
                           if (CSB_ipd /= '1') then
                              DO_zd := (OTHERS => 'X');
                              DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                              if (WEB_ipd /= '1') then
                                 FOR i IN Words-1 downto 0 LOOP
                                 memoryCore(i) := (OTHERS => 'X');
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
           Tviol_WEB_CK_posedge  = 'X' or
           Tviol_DI0_CK_posedge   = 'X' or  
           Tviol_DI1_CK_posedge   = 'X' or  
           Tviol_DI2_CK_posedge   = 'X' or  
           Tviol_DI3_CK_posedge   = 'X' or  
           Tviol_DI4_CK_posedge   = 'X' or  
           Tviol_DI5_CK_posedge   = 'X' or  
           Tviol_DI6_CK_posedge   = 'X' or  
           Tviol_DI7_CK_posedge   = 'X' or  
           Tviol_CSB_CK_posedge    = 'X' or
           Pviol_CK               = 'X'
          ) then

         if (Pviol_CK = 'X') then
            if (CSB_ipd /= '1') then
               DO_zd := (OTHERS => 'X');
               DO_int <= TRANSPORT (OTHERS => 'X');
               if (WEB_ipd /= '1') then
                  FOR i IN Words-1 downto 0 LOOP
                     memoryCore(i) := (OTHERS => 'X');
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

              if (Tviol_DI0_CK_posedge = 'X') then
                 Latch_DI(0) := 'X';
              else
                 Latch_DI(0) := Latch_DI(0);
              end if; 
              if (Tviol_DI1_CK_posedge = 'X') then
                 Latch_DI(1) := 'X';
              else
                 Latch_DI(1) := Latch_DI(1);
              end if; 
              if (Tviol_DI2_CK_posedge = 'X') then
                 Latch_DI(2) := 'X';
              else
                 Latch_DI(2) := Latch_DI(2);
              end if; 
              if (Tviol_DI3_CK_posedge = 'X') then
                 Latch_DI(3) := 'X';
              else
                 Latch_DI(3) := Latch_DI(3);
              end if; 
              if (Tviol_DI4_CK_posedge = 'X') then
                 Latch_DI(4) := 'X';
              else
                 Latch_DI(4) := Latch_DI(4);
              end if; 
              if (Tviol_DI5_CK_posedge = 'X') then
                 Latch_DI(5) := 'X';
              else
                 Latch_DI(5) := Latch_DI(5);
              end if; 
              if (Tviol_DI6_CK_posedge = 'X') then
                 Latch_DI(6) := 'X';
              else
                 Latch_DI(6) := Latch_DI(6);
              end if; 
              if (Tviol_DI7_CK_posedge = 'X') then
                 Latch_DI(7) := 'X';
              else
                 Latch_DI(7) := Latch_DI(7);
              end if; 

	    
            if (Tviol_WEB_CK_posedge = 'X') then
               Latch_WEB := 'X';
            else
               Latch_WEB := Latch_WEB;
            end if;
            if (Tviol_CSB_CK_posedge = 'X') then
               Latch_CSB := 'X';
            else
               Latch_CSB := Latch_CSB;
            end if;


                -- memory_function
                A_i    := Latch_A;
                CSB_i   := Latch_CSB;
                DI_i  := Latch_DI;
                WEB_i := Latch_WEB;


                web_cs    := WEB_i&CSB_i;
                case web_cs is
                   when "10" => 
                       -------- Reduce error message --------------------------
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           DO_zd := memoryCore(to_integer(A_i));
                             ScheduleOutputDelayTOH(DO_int(0), DO_zd(0),
                                tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(0),
                                last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO_int(1), DO_zd(1),
                                tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(1),
                                last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO_int(2), DO_zd(2),
                                tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(2),
                                last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO_int(3), DO_zd(3),
                                tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(3),
                                last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO_int(4), DO_zd(4),
                                tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(4),
                                last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO_int(5), DO_zd(5),
                                tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(5),
                                last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO_int(6), DO_zd(6),
                                tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(6),
                                last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                             ScheduleOutputDelayTOH(DO_int(7), DO_zd(7),
                                tpd_CK_DO_NODELAY_EQ_0_AN_read_posedge(7),
                                last_A,A_i,last_WEB,WEB_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO_zd := (OTHERS => 'X');
                           DO_int <= TRANSPORT (OTHERS => 'X');
                       end if;

                   when "00" => 
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           memoryCore(to_integer(A_i)) := DI_i;
                           DO_zd := memoryCore(to_integer(A_i));
                             ScheduleOutputDelayTWDX(DO_int(0), DO_zd(0),
                                tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(0),
                                last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO_int(1), DO_zd(1),
                                tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(1),
                                last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO_int(2), DO_zd(2),
                                tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(2),
                                last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO_int(3), DO_zd(3),
                                tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(3),
                                last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO_int(4), DO_zd(4),
                                tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(4),
                                last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO_int(5), DO_zd(5),
                                tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(5),
                                last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO_int(6), DO_zd(6),
                                tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(6),
                                last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                             ScheduleOutputDelayTWDX(DO_int(7), DO_zd(7),
                                tpd_CK_DO_NODELAY_EQ_0_AN_write_posedge(7),
                                last_A,A_i,last_WEB,WEB_i,last_DI,DI_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO_zd := (OTHERS => 'X');
                           DO_int <= TRANSPORT (OTHERS => 'X');

                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO_zd := (OTHERS => 'X');
                           DO_int <= TRANSPORT (OTHERS => 'X') AFTER TWDX;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;

                   when "1X" |
                        "1U" |
                        "1Z" => DO_zd := (OTHERS => 'X');
                                DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH; 
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
                                   memoryCore(to_integer(A_i)) := (OTHERS => 'X');
                                   DO_zd := (OTHERS => 'X');
                                   DO_int <= TRANSPORT (OTHERS => 'X');
                                elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                                    -- Reduce error message --
                                    flag_A := False_flg;
                                    --------------------------
                                    DO_zd := (OTHERS => 'X');
                                    DO_int <= TRANSPORT (OTHERS => 'X');
                                else
                                   -- Reduce error message --
                                   flag_A := False_flg;
                                   --------------------------
                                   DO_zd := (OTHERS => 'X');
                                   DO_int <= TRANSPORT (OTHERS => 'X');
                                   FOR i IN Words-1 downto 0 LOOP
                                      memoryCore(i) := (OTHERS => 'X');
                                   END LOOP;
                                end if;
                end case;
                -- end memory_function

         end if;
       end if;

   end PROCESS;


end behavior;
