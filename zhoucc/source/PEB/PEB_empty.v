//======================================================
// Copyright (C) 2019 By zhoucc
// All Rights Reserved
//======================================================
// Module : PEB
// Author : CC zhou
// Contact : 
// Date : 6 .13 .2019
//=======================================================
// Description :
//========================================================
`include "../source/include/dw_params_presim.vh"
module PEB (
    input                               clk     ,
    input                               rst_n   ,

    input                               next_block,// paulse:reset wei/arb
    input                               reset_act,// paulse
    input                               reset_wei,
    output                              PEBCCU_Fnh, // level
    input                               PELACT_Handshake_n,
    output                              ACTGB_Rdy,
    input                               GBACT_Val,
    input    [`BUSWIDTH_ACT     -1 : 0] GBACT_Data, // 16B

    output                              FLGACTGB_rdy,
    input                               GBFLGACT_val,
    input   [`BUSWIDTH_FLGACT   -1 : 0] GBFLGACT_data,  // 4B

    input                               PEBACT_rdy,//PEB
    output                              ACTPEB_val,
    output [ `BUSWIDTH_ACT      -1 : 0] ACTPEB_data,

    input                               PEBFLGACT_rdy,//PEB
    output                              FLGACTPEB_val,
    output [`BUSWIDTH_FLGACT    -1 : 0] FLGACTPEB_data,

    input                               GBWEI_Instr_Rdy,
    output                              WEIGB_Instr_Val,
    output  [`DATA_WIDTH        -1 : 0] WEIGB_Instr_Data,

    output                              WEIGB_Rdy,
    input                               GBWEI_Val,
    input  [`BUSWIDTH_WEI       -1 : 0] GBWEI_Data,

    output                              FLGWEIGB_Rdy,
    input                               GBFLGWEI_Val,
    input  [`BUSWIDTH_FLGWEI    -1 : 0] GBFLGWEI_Data,

    output                              PSUMGB_val0,// PE0
    output [ `BUSWIDTH_PSUM     -1 : 0] PSUMGB_data0,
    input                               GBPSUM_rdy0,

    output                              PSUMGB_val1,// PE1
    output [ `BUSWIDTH_PSUM     -1 : 0] PSUMGB_data1,
    input                               GBPSUM_rdy1, 

    output                              PSUMGB_val2,// PE2
    output [ `BUSWIDTH_PSUM     -1 : 0] PSUMGB_data2,
    input                               GBPSUM_rdy2,

    output                              PSUMGB_rdy0,// Psum In
    input [ `BUSWIDTH_PSUM      -1 : 0] GBPSUM_data0,
    input                               GBPSUM_val0,

    output                              PSUMGB_rdy1,// Psum In
    input [ `BUSWIDTH_PSUM      -1 : 0] GBPSUM_data1,
    input                               GBPSUM_val1,

    output                              PSUMGB_rdy2,// Psum In
    input [ `BUSWIDTH_PSUM      -1 : 0] GBPSUM_data2,
    input                               GBPSUM_val2
);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================




//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
assign PEBCCU_Fnh = 1;

assign ACTGB_Rdy      = 1;
assign FLGACTGB_rdy   = 1;
assign ACTPEB_val     = 0;
assign ACTPEB_data    = 0;
assign FLGACTPEB_val  = 0;
assign FLGACTPEB_data = 0;

assign WEIGB_Instr_Val  = 0;
assign WEIGB_Instr_Data = 0;
assign WEIGB_Rdy        = 0;

assign PSUMGB_val0      = 0;
assign PSUMGB_data0     = 0;
assign PSUMGB_val1      = 0;
assign PSUMGB_data1     = 0;
assign PSUMGB_val2      = 0;
assign PSUMGB_data2     = 0;

assign PSUMGB_rdy0 = 0;
assign PSUMGB_rdy1 = 0;
assign PSUMGB_rdy2 = 0;


REGFLGWEI #(
    .DATA_WIDTH (`BLOCK_DEPTH),
    .ADDR_WIDTH(`REGFLGWEI_ADDR_WIDTH),
    .WR_NUM (`REGFLGWEI_WR_WIDTH/`BLOCK_DEPTH),
    .RD_NUM (`MAC_NUM))
REGFLGWEI
    (
        .clk            (clk),
        .rst_n          (rst_n),
        .reset          (next_block),
        .datain_rdy     (FLGWEIGB_Rdy),
        .datain_val     (GBFLGWEI_Val),
        .datain         (GBFLGWEI_Data), // 8B
        .dataout_val    ( ),
        .dataout        ( )
    );

endmodule
