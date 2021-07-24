// This is a simple example.
// You can make a your own header file and set its path to settings.
// (Preferences > Package Settings > Verilog Gadget > Settings - User)
//
//      "header": "Packages/Verilog Gadget/template/verilog_header.v"
//
// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : zhouchch@pku.edu.cn
// File   : PEL.v
// Create : 2020-07-14 08:50:54
// Revise : 2020-08-11 12:47:06
// Editor : sublime text3, tab size (2)
// -----------------------------------------------------------------------------
`include "../source/include/dw_params_presim.vh"
module PEL #(
    parameter NUM_PEB = 16
) (
    input                                                           clk     ,
    input                                                           rst_n   ,
                                                            
    input   [ 1*NUM_PEB                                     -1 : 0] next_block      ,// paulse:reset wei/arb
    input   [ 1*NUM_PEB                                     -1 : 0] reset_act       ,// paulse
    input   [ 1*NUM_PEB                                     -1 : 0] reset_wei       ,
    output  [ 1*NUM_PEB                                     -1 : 0] ARBPEB_Fnh      , // level
    output  [ 1*1                                           -1 : 0] ACTGB_Rdy       ,
    input   [ 1*1                                           -1 : 0] GBACT_Val       ,
    input   [`BUSWIDTH_ACT*1                             -1 : 0] GBACT_Data      , // 16B
    output  [ 1*1                                           -1 : 0] FLGACTGB_rdy    ,
    input   [ 1*1                                           -1 : 0] GBFLGACT_val    ,
    input   [`BUSWIDTH_FLGACT*1                          -1 : 0] GBFLGACT_data   ,  // 4B
    // input   [ 1*1                                           -1 : 0] PEBACT_rdy      ,//PEB
    // output  [ 1*1                                           -1 : 0] ACTPEB_val      ,
    // output  [ `REGACT_WR_WIDTH*1                            -1 : 0] ACTPEB_data     ,
    // input   [ 1*1                                           -1 : 0] PEBFLGACT_rdy   ,//PEB
    // output  [ 1*1                                           -1 : 0] FLGACTPEB_val   ,
    // output  [`REGFLGACT_WR_WIDTH*1                          -1 : 0] FLGACTPEB_data  ,
    input   [ 1*NUM_PEB                                     -1 : 0] GBWEI_Instr_Rdy ,
    output  [ 1*NUM_PEB                                     -1 : 0] WEIGB_Instr_Val ,
    output  [`DATA_WIDTH*NUM_PEB                            -1 : 0] WEIGB_Instr_Data,
    output  [ 1*NUM_PEB                                     -1 : 0] WEIGB_Rdy       ,
    input   [ 1*NUM_PEB                                     -1 : 0] GBWEI_Val       ,
    input   [ `BUSWIDTH_WEI                                 -1 : 0] GBWEI_Data      ,
    output  [ 1*NUM_PEB                                     -1 : 0] FLGWEIGB_Rdy    ,
    input   [ 1*NUM_PEB                                     -1 : 0] GBFLGWEI_Val    ,
    input   [ `BUSWIDTH_FLGWEI                              -1 : 0] GBFLGWEI_Data   ,
    output  [ 1*3*NUM_PEB                                   -1 : 0] PSUMGB_val      ,// PE0
    output  [ `BUSWIDTH_PSUM*3*NUM_PEB                      -1 : 0] PSUMGB_data     ,
    input   [ 1*3*NUM_PEB                                   -1 : 0] GBPSUM_rdy      ,
    output  [ 1*3*NUM_PEB                                   -1 : 0] PSUMGB_rdy      ,// Psum In
    input   [ `BUSWIDTH_PSUM                                -1 : 0] GBPSUM_data     ,
    input   [ 1*3*NUM_PEB                                   -1 : 0] GBPSUM_val           
    // output  [ 341                                           -1 : 0] PELMONITOR
);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================





//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================





//=====================================================================================================================
// Logic Design :
//=====================================================================================================================

generate
  genvar i;
  for(i=0;i<NUM_PEB;i=i+1) begin:PEB
    wire [ 1*1                                           -1 : 0] ACTGB_Rdy       ;
    wire [ 1*1                                           -1 : 0] GBACT_Val       ;
    wire [`BUSWIDTH_ACT*1                             -1 : 0] GBACT_Data      ;
    wire [ 1*1                                           -1 : 0] FLGACTGB_rdy    ;
    wire [ 1*1                                           -1 : 0] GBFLGACT_val    ;
    wire [`BUSWIDTH_FLGACT*1                          -1 : 0] GBFLGACT_data   ;

    wire [ 1*1                                           -1 : 0] PEBACT_rdy    ;
    wire [ 1*1                                           -1 : 0] ACTPEB_val    ;
    wire [ `BUSWIDTH_ACT*1                            -1 : 0] ACTPEB_data   ;
    wire [ 1*1                                           -1 : 0] PEBFLGACT_rdy ;
    wire [ 1*1                                           -1 : 0] FLGACTPEB_val ;
    wire [`BUSWIDTH_FLGACT*1                          -1 : 0] FLGACTPEB_data;
    wire                                                        PELACT_Handshake_n;
      PEB inst_PEB
    (
      .clk              (clk),
      .rst_n            (rst_n),
      .next_block       (next_block[i]),
      .reset_act        (reset_act[i]),
      .reset_wei        (reset_wei[i]),
      .PEBCCU_Fnh       (ARBPEB_Fnh[i]),
      .PELACT_Handshake_n(PELACT_Handshake_n),
      .ACTGB_Rdy        (ACTGB_Rdy), // Input 
      .GBACT_Val        (GBACT_Val),
      .GBACT_Data       (GBACT_Data),
      .FLGACTGB_rdy     (FLGACTGB_rdy),
      .GBFLGACT_val     (GBFLGACT_val),
      .GBFLGACT_data    (GBFLGACT_data),
      .PEBACT_rdy       (PEBACT_rdy), // Output
      .ACTPEB_val       (ACTPEB_val),
      .ACTPEB_data      (ACTPEB_data),
      .PEBFLGACT_rdy    (PEBFLGACT_rdy),
      .FLGACTPEB_val    (FLGACTPEB_val),
      .FLGACTPEB_data   (FLGACTPEB_data),
      .GBWEI_Instr_Rdy  (GBWEI_Instr_Rdy[i]),
      .WEIGB_Instr_Val  (WEIGB_Instr_Val[i]),
      .WEIGB_Instr_Data (WEIGB_Instr_Data[`DATA_WIDTH*i +: `DATA_WIDTH]),
      .WEIGB_Rdy        (WEIGB_Rdy[i]),
      .GBWEI_Val        (GBWEI_Val[i]),
      .GBWEI_Data       (GBWEI_Data),
      .FLGWEIGB_Rdy     (FLGWEIGB_Rdy[i]),
      .GBFLGWEI_Val     (GBFLGWEI_Val[i]),
      .GBFLGWEI_Data    (GBFLGWEI_Data),
      .PSUMGB_val0      (PSUMGB_val[i*3+0]),
      .PSUMGB_data0     (PSUMGB_data[`BUSWIDTH_PSUM*(i*3+0) +: `BUSWIDTH_PSUM]),
      .GBPSUM_rdy0      (GBPSUM_rdy[i*3+0]),
      .PSUMGB_val1      (PSUMGB_val[i*3+1]),
      .PSUMGB_data1     (PSUMGB_data[`BUSWIDTH_PSUM*(i*3+1) +: `BUSWIDTH_PSUM]),
      .GBPSUM_rdy1      (GBPSUM_rdy[i*3+1]),
      .PSUMGB_val2      (PSUMGB_val[i*3+2]),
      .PSUMGB_data2     (PSUMGB_data[`BUSWIDTH_PSUM*(i*3+2) +: `BUSWIDTH_PSUM]),
      .GBPSUM_rdy2      (GBPSUM_rdy[i*3+2]),
      .PSUMGB_rdy0      (PSUMGB_rdy[i*3+0]),
      .GBPSUM_data0     (GBPSUM_data),
      .GBPSUM_val0      (GBPSUM_val[i*3+0]),
      .PSUMGB_rdy1      (PSUMGB_rdy[i*3+1]),
      .GBPSUM_data1     (GBPSUM_data),
      .GBPSUM_val1      (GBPSUM_val[i*3+1]),
      .PSUMGB_rdy2      (PSUMGB_rdy[i*3+2]),
      .GBPSUM_data2     (GBPSUM_data),
      .GBPSUM_val2      (GBPSUM_val[i*3+2])
    );
  end
endgenerate

generate
    genvar j;
    for(j=0; j<NUM_PEB -1; j=j+1) begin
        assign PEB[j].PEBACT_rdy    = PEB[j+1].ACTGB_Rdy   ;   
        assign PEB[j].PEBFLGACT_rdy = PEB[j+1].FLGACTGB_rdy;   
        assign PEB[j+1].GBACT_Val    = PEB[j].ACTPEB_val    ;
        assign PEB[j+1].GBACT_Data   = PEB[j].ACTPEB_data   ;
        assign PEB[j+1].GBFLGACT_val = PEB[j].FLGACTPEB_val ;
        assign PEB[j+1].GBFLGACT_data= PEB[j].FLGACTPEB_data;
        if(j==0) begin
          assign PEB[j].PELACT_Handshake_n = 0 ;
          assign PEB[j].PELACT_Handshake_n = 0 ;
        end else begin
          assign PEB[j].PELACT_Handshake_n = 1 ;
          assign PEB[j].PELACT_Handshake_n = 1 ;
        end
    end
endgenerate

assign PEB[NUM_PEB -1].PEBACT_rdy    = 1'b1;
assign PEB[NUM_PEB -1].PEBFLGACT_rdy = 1'b1;
assign ACTGB_Rdy = PEB[0].ACTGB_Rdy;
assign FLGACTGB_rdy = PEB[0].FLGACTGB_rdy;
assign PEB[0].GBACT_Val     = GBACT_Val     ;
assign PEB[0].GBACT_Data    = GBACT_Data    ;
assign PEB[0].GBFLGACT_val  = GBFLGACT_val  ;
assign PEB[0].GBFLGACT_data = GBFLGACT_data ;
assign PEB[15].PELACT_Handshake_n = 1 ;
assign PEB[15].PELACT_Handshake_n = 1 ;

// assign PELMONITOR = { // 325 + 16 = 341
//   PEB[7].ACTGB_Rdy,
//   PEB[7].GBACT_Val,
//   PEB[6].ACTGB_Rdy,
//   PEB[6].GBACT_Val,
//   PEB[5].ACTGB_Rdy,
//   PEB[5].GBACT_Val,
//   PEB[4].ACTGB_Rdy,
//   PEB[4].GBACT_Val,
//   PEB[3].ACTGB_Rdy,
//   PEB[3].GBACT_Val,
//   PEB[2].ACTGB_Rdy,
//   PEB[2].GBACT_Val,
//   PEB[1].ACTGB_Rdy,
//   PEB[1].GBACT_Val,
//   PEB[0].ACTGB_Rdy,
//   PEB[0].GBACT_Val,
//   PEB[0].PEBMONITOR
// }


//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================

endmodule