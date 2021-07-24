// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : MinLiu 
// File   : TOP_IF.sv
// Create : 2020-08-05 15:33:14
// Revise : 2020-08-05 15:48:28
// -----------------------------------------------------------------------------
// Description :
// -----------------------------------------------------------------------------
`ifndef TOP_IF
  `define TOP_IF

`include "../tb/DEFINE.sv"

interface TOP_IF(input bit clk);

    logic                          IFGB_cfg_rdy;
    logic                          GBIF_cfg_val;
    logic [ 4             - 1 : 0] GBIF_cfg_info;

    logic                          IFGB_wr_rdy;
    logic                          GBIF_wr_val;
    logic [`TB_PORT_WIDTH - 1 : 0] GBIF_wr_data;

    logic                          IFGB_rd_val;
    logic                          GBIF_rd_rdy;
    logic [`TB_PORT_WIDTH - 1 : 0] IFGB_rd_data;


    clocking txcb_cfg @(posedge clk);
        output IFGB_cfg_rdy;
        input  GBIF_cfg_val, GBIF_cfg_info;
    endclocking:txcb_pool

    clocking txcb_wr @(posedge clk);
        output IFGB_wr_rdy;
        input  GBIF_wr_val, GBIF_wr_data;
    endclocking: txcb_wr 

    clocking rxcb_rd @(posedge clk);
        output IFGB_rd_val, IFGB_rd_data;
        input  pool_rd_rdy; 
    endclocking: rxcb_rd 

    modport DUT( 
        output GBIF_cfg_val, GBIF_cfg_info, GBIF_wr_val, GBIF_wr_data, pool_rd_rdy, 
        input  IFGB_cfg_rdy, IFGB_wr_rdy, IFGB_rd_val, IFGB_rd_data
        );

  modport TB(clocking txcb_cfg, txcb_wr, rxcb_rd);

endinterface: TOP_IF

typedef virtual TOP_IF    vTOP_IF;
typedef virtual TOP_IF.TB vTOP_TB;


`endif