// This is a simple example.
// You can make a your own header file and set its path to settings.
// (Preferences > Package Settings > Verilog Gadget > Settings - User)
//
//    "header": "Packages/Verilog Gadget/template/verilog_header.v"
//
// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : zhouchch@pku.edu.cn
// File   : GB_PSUM.v
// Create : 2020-07-10 08:51:21
// Revise : 2020-07-10 08:51:21
// Editor : sublime text3, tab size (2)
// -----------------------------------------------------------------------------
module GB_PSUM #(
    parameter NUM_PEB       = 32,
    parameter PSUM_WIDTH    = 32,
    parameter ADDR_WIDTH    = 8,
    parameter PSUMBUS_WIDTH = PSUM_WIDTH*16
  )(
    input                               clk             ,
    input                               rst_n           ,

    output                              GBCFG_rdy       , // level
    input                               CFGGB_val       , // level
    input [6                    -1 : 0] CFGGB_num_frame ,
    input [6                    -1 : 0] CFGGB_num_block ,

    input                               CCUGB_reset_patch,
    input [6                    -1 : 0] CCUGB_frame     ,
    input [6                    -1 : 0] CCUGB_block     ,

    // PEs read psum
    input [3*NUM_PEB            -1 : 0] PSUMGB_rdy      , // 3*32 = 96
    output[3*NUM_PEB            -1 : 0] GBPSUM_val      ,
    output[PSUMBUS_WIDTH        -1 : 0] GBPSUM_data     , // send psum to PE Array

    // PEs write psum
    output[3*NUM_PEB            -1 : 0] GBPSUM_rdy      ,
    input [3*NUM_PEB            -1 : 0] PSUMGB_val      ,
    input [PSUMBUS_WIDTH*3*NUM_PEB-1:0] PSUMGB_data     , // recieve psum from PE Array


    // POOL read psum
    output[PSUM_WIDTH*NUM_PEB   -1 : 0] GBPOOL_data     ,
    input [ADDR_WIDTH           -1 : 0] POOLGB_addr     ,
    output                              GBPOOL_val      ,
    input                               POOLGB_rdy      ,

    input                               POOLGB_fnh       // paulse

  );







endmodule