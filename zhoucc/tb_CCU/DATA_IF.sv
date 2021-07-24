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
    logic                              CFGIF_rdy               ; // reg
    logic                              IFCFG_val               ; // push full
    logic [ PORT_WIDTH         -1 : 0] IFCFG_data              ;                   
    logic                              GBCFG_rdy               ; // level
    logic                              CFGGB_val               ; // level
    logic [ 4                  -1 : 0] CFGGB_num_alloc_wei     ;         
    logic [ 4                  -1 : 0] CFGGB_num_alloc_flgwei  ; // Number of Bank SRAM for flagwei              
    logic [ 4                  -1 : 0] CFGGB_num_alloc_flgact  ;                       
    logic [ 4                  -1 : 0] CFGGB_num_alloc_act     ; /* allocate SRAM BANK to Activation*/
    logic [ 4                  -1 : 0] CFGGB_num_total_flgwei  ; 
    logic [ 4                  -1 : 0] CFGGB_num_total_flgact  ; 
    logic [ 4                  -1 : 0] CFGGB_num_total_act     ; 
    logic [12                  -1 : 0] CFGGB_num_loop_wei      ; // patch * frame = 8*8 * 64
    logic [8                   -1 : 0] CFGGB_num_loop_act      ; // 1024/32 = 32
    logic                              CCUGB_pullback_wei      ; //  reg
    logic                              CCUGB_reset_all         ; // reg
    logic                              POOLCFG_rdy             ;
    logic                              CFGPOOL_val             ;
    logic [`POOLCFG_WIDTH      -1 : 0] CFGPOOL_data             ;
    logic                              CCUPOOL_reset           ; // reg
    logic  [ 1*NUM_PEB         -1 : 0] CCUPEB_next_block       ; // reg
    logic  [ 1*NUM_PEB         -1 : 0] CCUPEB_reset_act        ; // reg
    logic  [ 1*NUM_PEB         -1 : 0] CCUPEB_reset_wei        ; // reg
    logic  [ 1*NUM_PEB         -1 : 0] PEBCCU_fnh_block        ;
    logic                              GBPSUMCFG_rdy         ;
    logic                              CFGGBPSUM_val         ;
    logic  [6                  -1 : 0] CFGGBPSUM_num_frame   ;
    logic  [6                  -1 : 0] CFGGBPSUM_num_block   ;
    logic                              CCUGB_reset_patch     ;
    logic  [6                  -1 : 0] CCUGB_frame           ;
    logic  [6                  -1 : 0] CCUGB_block           ;
    logic                              CCUPOOL_En            ;
    logic                              CCUPOOL_ValFrm        ;
    logic                              CCUPOOL_ValDelta      ;
    logic                              CCUPOOL_layer_fnh     ;
    logic                              POOLCCU_clear_up      ;

  clocking rtxcb @(posedge clk);
    output 
IFCFG_val             ,
IFCFG_data            ,
GBCFG_rdy             ,
POOLCFG_rdy           ,
PEBCCU_fnh_block      ,
GBPSUMCFG_rdy         ,
POOLCCU_clear_up      ;
    input  
CFGIF_rdy             ,
CFGGB_val             ,
CFGGB_num_alloc_wei   ,
CFGGB_num_alloc_flgwei,
CFGGB_num_alloc_flgact,
CFGGB_num_alloc_act   ,
CFGGB_num_total_flgwei,
CFGGB_num_total_flgact,
CFGGB_num_total_act   ,
CFGGB_num_loop_wei    ,
CFGGB_num_loop_act    ,
CCUGB_pullback_wei    ,
CCUGB_reset_all       ,
CFGPOOL_val           ,
CFGPOOL_data          ,
CCUPOOL_reset         ,
CCUPEB_next_block     ,
CCUPEB_reset_act      ,
CCUPEB_reset_wei      ,
CFGGBPSUM_val         ,
CFGGBPSUM_num_frame   ,
CFGGBPSUM_num_block   ,
CCUGB_reset_patch     ,
CCUGB_frame           ,
CCUGB_block           ,
CCUPOOL_En            ,
CCUPOOL_ValFrm        ,
CCUPOOL_ValDelta      ,
CCUPOOL_layer_fnh     ;
  endclocking:rtxcb


  // DUT interface group
  modport DUT( 
output
CFGIF_rdy             ,
CFGGB_val             ,
CFGGB_num_alloc_wei   ,
CFGGB_num_alloc_flgwei,
CFGGB_num_alloc_flgact,
CFGGB_num_alloc_act   ,
CFGGB_num_total_flgwei,
CFGGB_num_total_flgact,
CFGGB_num_total_act   ,
CFGGB_num_loop_wei    ,
CFGGB_num_loop_act    ,
CCUGB_pullback_wei    ,
CCUGB_reset_all       ,
CFGPOOL_val           ,
CFGPOOL_data          ,
CCUPOOL_reset         ,
CCUPEB_next_block     ,
CCUPEB_reset_act      ,
CCUPEB_reset_wei      ,
CFGGBPSUM_val         ,
CFGGBPSUM_num_frame   ,
CFGGBPSUM_num_block   ,
CCUGB_reset_patch     ,
CCUGB_frame           ,
CCUGB_block           ,
CCUPOOL_En            ,
CCUPOOL_ValFrm        ,
CCUPOOL_ValDelta      ,
CCUPOOL_layer_fnh     ,
input
IFCFG_val             ,
IFCFG_data            ,
GBCFG_rdy             ,
POOLCFG_rdy           ,
PEBCCU_fnh_block      ,
GBPSUMCFG_rdy         ,
POOLCCU_clear_up      
                );
  // TB interface group
  modport TB(clocking rtxcb  );

endinterface: DATA_IF

typedef virtual DATA_IF vDATA_IF;

`endif
