//======================================================
// Copyright (C) 2019 By zhoucc
// All Rights Reserved
//======================================================
// Module : 
// Author : CC zhou
// Contact : 
// Date :  . .2019
//=======================================================
// Description :
//========================================================
module GB #(
    parameter PORT_WIDTH      = 128 ,
    parameter INSTR_WIDTH     = 8   ,
    parameter IDWEI_WIDTH     = 5   ,
    parameter NUM_PEB         = 16  ,
    parameter WEI_WR_WIDTH    = 128 , // 16B
    parameter FLGWEI_WR_WIDTH = 64  , // 8B
    parameter ACT_WR_WIDTH    = 128 , // 16B
    parameter FLGACT_WR_WIDTH = 32  , // 4B
    parameter PSUM_WIDTH      = 32  ,
    parameter ADDR_WIDTH      = 8   ,
    parameter PSUMBUS_WIDTH   = PSUM_WIDTH*16
) (
    input                               clk                     ,
    input                               rst_n                   ,

    // Configure
    output                              GBCFG_rdy               , // level
    input                               CFGGB_val               , // level
        
    input [ 4                   -1 : 0] CFGGB_num_alloc_wei     ,         
    input [ 4                   -1 : 0] CFGGB_num_alloc_flgwei  , // Number of Bank SRAM for flagwei              
    input [ 4                   -1 : 0] CFGGB_num_alloc_flgact  ,                       
    input [ 4                   -1 : 0] CFGGB_num_alloc_act     , /* allocate SRAM BANK to Activation*/

    input [ 4                   -1 : 0] CFGGB_num_total_flgwei  , 
    input [ 4                   -1 : 0] CFGGB_num_total_flgact  , 
    input [ 4                   -1 : 0] CFGGB_num_total_act     , 

    input [12                   -1 : 0] CFGGB_num_loop_wei      , // patch * frame = 8*8 * 64
    input [8                    -1 : 0] CFGGB_num_loop_act      , // 1024/32 = 32
    // Center Controller
    input                               CCUGB_pullback_wei      , // 
    input                               CCUGB_pullback_act      , // 
    input                               CCUGB_reset_all         ,

    // Interface 
    input                               IFGB_cfg_rdy            ,
    output                              GBIF_cfg_val            ,
    output[ 4                   -1 : 0] GBIF_cfg_info           , // {id, w/r}

    input                               IFGB_wr_rdy             ,
    output                              GBIF_wr_val             ,
    output[ PORT_WIDTH          -1 : 0] GBIF_wr_data            ,
    // cfg -> flagwei > wei_address > wei > flagact > act
    input                               IFGB_rd_val             ,
    output                              GBIF_rd_rdy             ,
    input [PORT_WIDTH           -1 : 0] IFGB_rd_data            ,

    // PEL's WEI
    output[NUM_PEB              -1 : 0] GBWEI_instr_rdy         ,
    input [NUM_PEB              -1 : 0] WEIGB_instr_val         ,
    input [INSTR_WIDTH*NUM_PEB  -1 : 0] WEIGB_instr_data        ,

    input [NUM_PEB              -1 : 0] WEIGB_rdy               ,
    output[NUM_PEB              -1 : 0] GBWEI_val               ,
    output[IDWEI_WIDTH          -1 : 0] GBWEI_idwei             ,
    output[WEI_WR_WIDTH         -1 : 0] GBWEI_data              ,

    // PEL's FLGWEI
    input [NUM_PEB              -1 : 0] FLGWEIGB_rdy            ,
    output[NUM_PEB              -1 : 0] GBFLGWEI_val            ,
    output[FLGWEI_WR_WIDTH      -1 : 0] GBFLGWEI_data           ,

    // PEL's ACT
    input [                     -1 : 0] ACTGB_rdy               ,
    output[                     -1 : 0] GBACT_val               ,
    output[ACT_WR_WIDTH         -1 : 0] GBACT_data              ,

    // PEL's FLGACT
    input [                     -1 : 0] FLGACTGB_rdy            ,
    output[                     -1 : 0] GBFLGACT_val            ,
    output[FLGACT_WR_WIDTH      -1 : 0] GBFLGACT_data           ,

    // POOL's Interface 
    output                              IFPOOL_flg_rdy          ,
    input                               POOLIF_flg_val          ,
    input [PORT_WIDTH           -1 : 0] POOLIF_flg_data         ,

    output                              IFPOOL_rdy              ,
    input                               POOLIF_val              ,
    input [PORT_WIDTH           -1 : 0] POOLIF_data             ,

    input                               CFGIF_rdy               , // reg
    output                              IFCFG_val               , // push full
    output  [ PORT_WIDTH        -1 : 0] IFCFG_data              

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


   // *************************************************************************
   // Modify
   // *************************************************************************
   // Delay 2 clks
   wire GBCFG_rdy_d;
   wire GBCFG_rdy_dd;
   DFQRM2TM Delay_GBCFG_rdy_d (.CK(clk),
    .D(GBCFG_rdy),
    .Q(GBCFG_rdy_d),
    .RB(rst_n));
   DFQRM2TM Delay_GBCFG_rdy_dd (.CK(clk),
    .D(GBCFG_rdy_d),
    .Q(GBCFG_rdy_dd),
    .RB(rst_n));

   // INV
   wire GBCFG_rdy_r;
   wire GBCFG_rdy_d_r;
   wire GBCFG_rdy_dd_r;

   INVM4TM Inv_GBCFG_rdy    (.A(GBCFG_rdy), .Z(GBCFG_rdy_r));
   INVM4TM Inv_GBCFG_rdy_d  (.A(GBCFG_rdy_d), .Z(GBCFG_rdy_d_r));
   INVM4TM Inv_GBCFG_rdy_dd (.A(GBCFG_rdy_dd), .Z(GBCFG_rdy_dd_r));

   wire GBCFG_rdy_3_r;
   AN3M4TM AN3_Inv_GBCFG_rdy3 (.A(GBCFG_rdy_r), .B(GBCFG_rdy_d_r), .C(GBCFG_rdy_dd_r), .Z(GBCFG_rdy_3_r));

   // GBACT_val
   wire GBACT_val_t;
   AN2M4TM AN2_GBACT_val (.A(GBACT_val_t), .B(GBCFG_rdy_3_r),.Z(GBACT_val));

   // GBFLGACT_val
   wire GBFLGACT_val_t;
   AN2M4TM AN2_GBFLGACT_val (.A(GBFLGACT_val_t), .B(GBCFG_rdy_3_r), .Z(GBFLGACT_val));
     
   // GBWEI_val
   wire [ 15 : 0] GBWEI_val_t;
   AN2M4TM AN2_GBWEI_val0  (.A(GBWEI_val_t[0 ]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[0 ]));
   AN2M4TM AN2_GBWEI_val1  (.A(GBWEI_val_t[1 ]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[1 ]));
   AN2M4TM AN2_GBWEI_val2  (.A(GBWEI_val_t[2 ]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[2 ]));
   AN2M4TM AN2_GBWEI_val3  (.A(GBWEI_val_t[3 ]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[3 ]));
   AN2M4TM AN2_GBWEI_val4  (.A(GBWEI_val_t[4 ]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[4 ]));
   AN2M4TM AN2_GBWEI_val5  (.A(GBWEI_val_t[5 ]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[5 ]));
   AN2M4TM AN2_GBWEI_val6  (.A(GBWEI_val_t[6 ]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[6 ]));
   AN2M4TM AN2_GBWEI_val7  (.A(GBWEI_val_t[7 ]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[7 ]));
   AN2M4TM AN2_GBWEI_val8  (.A(GBWEI_val_t[8 ]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[8 ]));
   AN2M4TM AN2_GBWEI_val9  (.A(GBWEI_val_t[9 ]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[9 ]));
   AN2M4TM AN2_GBWEI_val10 (.A(GBWEI_val_t[10]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[10]));
   AN2M4TM AN2_GBWEI_val11 (.A(GBWEI_val_t[11]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[11]));
   AN2M4TM AN2_GBWEI_val12 (.A(GBWEI_val_t[12]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[12]));
   AN2M4TM AN2_GBWEI_val13 (.A(GBWEI_val_t[13]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[13]));
   AN2M4TM AN2_GBWEI_val14 (.A(GBWEI_val_t[14]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[14]));
   AN2M4TM AN2_GBWEI_val15 (.A(GBWEI_val_t[15]), .B(GBCFG_rdy_3_r), .Z(GBWEI_val[15]));

   // GBFLGWEI_val
   wire [ 15 : 0] GBFLGWEI_val_t;
   AN2M4TM AN2_GBFLGWEI_val0  (.A(GBFLGWEI_val_t[0 ]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[0 ]));
   AN2M4TM AN2_GBFLGWEI_val1  (.A(GBFLGWEI_val_t[1 ]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[1 ]));
   AN2M4TM AN2_GBFLGWEI_val2  (.A(GBFLGWEI_val_t[2 ]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[2 ]));
   AN2M4TM AN2_GBFLGWEI_val3  (.A(GBFLGWEI_val_t[3 ]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[3 ]));
   AN2M4TM AN2_GBFLGWEI_val4  (.A(GBFLGWEI_val_t[4 ]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[4 ]));
   AN2M4TM AN2_GBFLGWEI_val5  (.A(GBFLGWEI_val_t[5 ]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[5 ]));
   AN2M4TM AN2_GBFLGWEI_val6  (.A(GBFLGWEI_val_t[6 ]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[6 ]));
   AN2M4TM AN2_GBFLGWEI_val7  (.A(GBFLGWEI_val_t[7 ]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[7 ]));
   AN2M4TM AN2_GBFLGWEI_val8  (.A(GBFLGWEI_val_t[8 ]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[8 ]));
   AN2M4TM AN2_GBFLGWEI_val9  (.A(GBFLGWEI_val_t[9 ]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[9 ]));
   AN2M4TM AN2_GBFLGWEI_val10 (.A(GBFLGWEI_val_t[10]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[10]));
   AN2M4TM AN2_GBFLGWEI_val11 (.A(GBFLGWEI_val_t[11]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[11]));
   AN2M4TM AN2_GBFLGWEI_val12 (.A(GBFLGWEI_val_t[12]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[12]));
   AN2M4TM AN2_GBFLGWEI_val13 (.A(GBFLGWEI_val_t[13]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[13]));
   AN2M4TM AN2_GBFLGWEI_val14 (.A(GBFLGWEI_val_t[14]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[14]));
   AN2M4TM AN2_GBFLGWEI_val15 (.A(GBFLGWEI_val_t[15]), .B(GBCFG_rdy_3_r), .Z(GBFLGWEI_val[15]));

   // *************************************************************************
   // End Modify
   // *************************************************************************






//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================


endmodule