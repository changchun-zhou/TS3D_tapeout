//======================================================
// Copyright (C) 2020 By 
// All Rights Reserved
//======================================================
// Module : 
// Author : 
// Contact : 
// Date : 
//=======================================================
// Description :
//========================================================
`ifndef DATA_IF
  `define DATA_IF

`include "../source/include/dw_params_presim.vh"
interface DATA_IF(input bit clk);

  logic [`REGACT_WR_WIDTH -1:0] GBACT_Data; // input
  logic [`REGACT_WR_WIDTH -1:0] ACTPEB_data; // input
  logic [`REGFLGACT_WR_WIDTH -1:0] GBFLGACT_data;
  logic [`REGFLGACT_WR_WIDTH -1:0] FLGACTPEB_data;
  logic [`SRAMWEI_WR_WIDTH+`C_LOG_2(`MAC_NUM) -1:0] GBWEI_Data;
  logic [`REGFLGWEI_WR_WIDTH -1:0] GBFLGWEI_Data;

  logic [`PSUM_WIDTH*`LENROW-1 : 0] GBPSUM_data0;
  logic [`PSUM_WIDTH*`LENROW-1 : 0] GBPSUM_data1;
  logic [`PSUM_WIDTH*`LENROW-1 : 0] GBPSUM_data2;

  logic [`PSUM_WIDTH*`LENROW-1 : 0] PSUMGB_data0;
  logic [`PSUM_WIDTH*`LENROW-1 : 0] PSUMGB_data1;
  logic [`PSUM_WIDTH*`LENROW-1 : 0] PSUMGB_data2;




  logic                             GBPSUM_val0;
  logic                             GBPSUM_val1;
  logic                             GBPSUM_val2;
  logic                             PSUMGB_rdy0;
  logic                             PSUMGB_rdy1;
  logic                             PSUMGB_rdy2;

  logic                             PSUMGB_val0;
  logic                             PSUMGB_val1;
  logic                             PSUMGB_val2;
  logic                             GBPSUM_rdy0;
  logic                             GBPSUM_rdy1;
  logic                             GBPSUM_rdy2;


  logic [`DATA_WIDTH         -1 : 0] WEIGB_Instr_Data;

  logic ACTGB_Rdy,GBACT_Val;
  logic PEBACT_rdy,ACTPEB_val;
  logic GBFLGACT_rdy,GBFLGACT_val;
  logic PEBFLGACT_rdy,FLGACTPEB_val;
  logic WEIGB_Rdy,GBWEI_Val;
  logic FLGWEIGB_Rdy,GBFLGWEI_Val;

  logic GBWEI_Instr_Rdy, WEIGB_Instr_Val;
  clocking rxcb_GBACT_Data @(posedge clk);
    output GBACT_Val,GBACT_Data;
    input  ACTGB_Rdy;
  endclocking:rxcb_GBACT_Data

  clocking rxcb_GBFLGACT_data @(posedge clk);
    output GBFLGACT_val,GBFLGACT_data;
    input  GBFLGACT_rdy;
  endclocking:rxcb_GBFLGACT_data

  clocking rxcb_GBWEI_Data@(posedge clk);
    output GBWEI_Val,GBWEI_Data;
    input  WEIGB_Rdy;
  endclocking:rxcb_GBWEI_Data

  clocking rxcb_GBFLGWEI_Data@(posedge clk);
    output GBFLGWEI_Val,GBFLGWEI_Data;
    input  FLGWEIGB_Rdy;
  endclocking:rxcb_GBFLGWEI_Data

  clocking txcb_WEIGB_Instr_Data @(posedge clk);
    output GBWEI_Instr_Rdy;
    input  WEIGB_Instr_Val,WEIGB_Instr_Data;
  endclocking:txcb_WEIGB_Instr_Data

  clocking rxcb_GBPSUM_data0@(posedge clk);
    output GBPSUM_val0,GBPSUM_data0;
    input  PSUMGB_rdy0;
  endclocking:rxcb_GBPSUM_data0

  clocking rxcb_GBPSUM_data1@(posedge clk);
    output GBPSUM_val1,GBPSUM_data1;
    input  PSUMGB_rdy1;
  endclocking:rxcb_GBPSUM_data1

  clocking rxcb_GBPSUM_data2@(posedge clk);
    output GBPSUM_val2,GBPSUM_data2;
    input  PSUMGB_rdy2;
  endclocking:rxcb_GBPSUM_data2

  // clocking rxcb_PSUMGB@(posedge clk);
  //   output GBFLGWEI_Val,GBFLGWEI_Data;
  //   input  FLGWEIGB_Rdy;
  // endclocking:rxcb_PSUMGB
  clocking txcb_ACTPEB_data @(posedge clk);
    output PEBACT_rdy;
    input  ACTPEB_val,ACTPEB_data;
  endclocking:txcb_ACTPEB_data

  clocking txcb_FLGACTPEB_data @(posedge clk);
    output PEBFLGACT_rdy;
    input  FLGACTPEB_val,FLGACTPEB_data;
  endclocking:txcb_FLGACTPEB_data

  clocking txcb_PSUMGB_data0 @(posedge clk);
    output GBPSUM_rdy0;
    input  PSUMGB_val0,PSUMGB_data0;
  endclocking:txcb_PSUMGB_data0

  clocking txcb_PSUMGB_data1 @(posedge clk);
    output GBPSUM_rdy1;
    input  PSUMGB_val1,PSUMGB_data1;
  endclocking:txcb_PSUMGB_data1

  clocking txcb_PSUMGB_data2 @(posedge clk);
    output GBPSUM_rdy2;
    input  PSUMGB_val2,PSUMGB_data2;
  endclocking:txcb_PSUMGB_data2
  
  // DUT interface group
  modport DUT( output ACTGB_Rdy,GBFLGACT_rdy,WEIGB_Rdy,FLGWEIGB_Rdy,WEIGB_Instr_Val,WEIGB_Instr_Data,
                        PSUMGB_rdy0, PSUMGB_rdy1, PSUMGB_rdy2,
                        ACTPEB_val,ACTPEB_data, FLGACTPEB_val,FLGACTPEB_data, 
                        PSUMGB_val0,PSUMGB_data0, PSUMGB_val1,PSUMGB_data1, PSUMGB_val2,PSUMGB_data2,
                input GBACT_Val,GBACT_Data,GBFLGACT_val,GBFLGACT_data,GBWEI_Val,GBWEI_Data,GBFLGWEI_Val,GBFLGWEI_Data,
                GBPSUM_val0,GBPSUM_data0, GBPSUM_val1,GBPSUM_data1, GBPSUM_val2,GBPSUM_data2, 
                PEBACT_rdy, PEBFLGACT_rdy, GBPSUM_rdy0, GBPSUM_rdy1, GBPSUM_rdy2
                );
  // TB interface group
  modport TB(clocking rxcb_GBACT_Data,rxcb_GBFLGACT_data,rxcb_GBWEI_Data,rxcb_GBFLGWEI_Data,
                    txcb_WEIGB_Instr_Data, rxcb_GBPSUM_data0, rxcb_GBPSUM_data1, rxcb_GBPSUM_data2,
                    txcb_ACTPEB_data, txcb_FLGACTPEB_data,txcb_PSUMGB_data0,txcb_PSUMGB_data1, txcb_PSUMGB_data2  );

endinterface: DATA_IF

typedef virtual DATA_IF vDATA_IF;

`endif
