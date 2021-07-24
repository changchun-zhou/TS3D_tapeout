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
    parameter NUM_PEB         = 16 ;
    parameter PORT_WIDTH      = 128;
    parameter POOL_WIDTH      = 32 ;
    parameter FIFO_ADDR_WIDTH = 6 ;

    // logic                                  CCUPOOL_reset   ;
    logic                                  POOLCFG_rdy     ;
    logic                                  CFGPOOL_val     ;
    logic [`POOLCFG_WIDTH          -1 : 0] CFGPOOL_data    ;
    logic                                  CCUPOOL_En      ;
    logic                                  CCUPOOL_ValFrm  ;
    logic                                  CCUPOOL_ValDelta;
    logic                                  POOLGB_rdy      ;
    logic                                  POOLGB_fnh      ;
    logic [8              -1 : 0] POOLGB_addr     ;
    logic                                  GBPOOL_val      ;
    logic [`PSUM_WIDTH*`NUM_PEB    -1 : 0] GBPOOL_data     ;
    logic                                  BF_rdy          ;
    logic                                  BF_val          ;
    logic [8              -1 : 0] BF_addr         ;
    logic [8              -1 : 0] BF_data         ;
    logic                                  BF_flg_rdy      ;
    logic                                  BF_flg_val      ;
    logic [16              -1 : 0] BF_flg_data     ;
logic                     O_DLL_lock   ;
logic                     O_clk_out    ;
logic                     O_sck_out    ;
logic                     O_config_req ;
logic                     O_near_full  ;
logic                     O_switch_rdwr;
logic [`PORT_WIDTH     -1:0] O_spi_data   ;
logic [`PORT_WIDTH     -1:0] I_spi_data   ;
//   clocking rtxcb @(posedge clk);
//     output 
// // CCUPOOL_reset    ,   
// CFGPOOL_val     ,
// CFGPOOL_data    ,
// CCUPOOL_En      ,
// CCUPOOL_ValFrm  ,
// CCUPOOL_ValDelta ,    
// GBPOOL_val      ,
// GBPOOL_data     ,
// BF_rdy           ,       
// BF_flg_rdy       ;   
//     input  
// POOLCFG_rdy,
// POOLGB_rdy ,
// POOLGB_fnh ,
// POOLGB_addr,
// BF_val  ,
// BF_addr ,
// BF_data ,
// BF_flg_data;
//   endclocking:rtxcb


  // DUT interface group
  modport DUT( 
output
// POOLCFG_rdy,
O_DLL_lock   ,
O_clk_out    ,
O_sck_out    ,
O_config_req ,
O_near_full  ,
O_switch_rdwr,
O_spi_data,
input
// CCUPOOL_reset    ,   
I_spi_cs_n  ,
I_spi_data 
                );
  // TB interface group
  modport TB(clocking rtxcb  );

endinterface: DATA_IF

typedef virtual DATA_IF vDATA_IF;

`endif
