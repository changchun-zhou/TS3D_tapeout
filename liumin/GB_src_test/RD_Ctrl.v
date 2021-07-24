// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : MinLiu 
// File   : RD_Ctrl.v
// Create : 2020-07-15 15:44:57
// Revise : 2020-08-03 18:52:13
// -----------------------------------------------------------------------------
// Description :
// -----------------------------------------------------------------------------
module RD_Ctrl #( 
    parameter ADDR_WIDTH = 9
    ) (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    input SRAM_config_start, 

    input [3  : 0]CFGGB_SRAM_num_wei, CFGGB_SRAM_num_flgwei, CFGGB_SRAM_num_act, CFGGB_SRAM_num_flgact, 
    input [3  : 0]CFGGB_Data_num_wei, CFGGB_Data_num_flgwei, CFGGB_Data_num_act, CFGGB_Data_num_flgact, 
    input [11 : 0]CFGGB_Cycl_num_wei, CFGGB_Cycl_num_flgwei, 
    input [7  : 0]CFGGB_Cycl_num_act, CFGGB_Cycl_num_flgact, 
   
    input  Rd_prepare_WeiFlg, Rd_prepare_Act, Rd_prepare_ActFlg,

    output [5 : 0]SRAMIF_Rd_ID_WeiFlg, SRAMIF_Rd_ID_Act, SRAMIF_Rd_ID_ActFlg,
    output [5 : 0]next_Rd_ID_WeiFlg, next_Rd_ID_Act, next_Rd_ID_ActFlg,
    output [1 : 0]State_Rd_WeiFlg, State_Rd_Act, State_Rd_ActFlg, 

    input  CCUGB_pullback_wei, CCUGB_pullback_act, 
    output read_SRAM_done_WeiFlg, read_SRAM_done_Act, read_SRAM_done_ActFlg, 
    
    input  PESRAM_rdy_WeiFlg, PESRAM_rdy_Act, PESRAM_rdy_ActFlg, 
    output SRAMPE_val_WeiFlg, SRAMPE_val_Act, SRAMPE_val_ActFlg,
    output [ADDR_WIDTH - 1 : 0]addr_Rd_WeiFlg, addr_Rd_Act, addr_Rd_ActFlg, 
    output read_en_WeiFlg, read_en_Act, read_en_ActFlg, 
    output read_Cyc_done_WeiFlg, read_Cyc_done_Act, read_Cyc_done_ActFlg, 
    output reg rd_addr_bias_WeiFlg, 
    output reg rd_addr_bias_Act, 
    output reg [1 : 0]rd_addr_bias_ActFlg 
);

wire [3 : 0]Rd_ID_WeiFlg_cor, Rd_ID_Act_cor, Rd_ID_ActFlg_cor;
wire [3 : 0]next_Rd_ID_WeiFlg_cor, next_Rd_ID_Act_cor, next_Rd_ID_ActFlg_cor;
wire cnt_t_wf; 
wire cnt_t_a;
wire [1 : 0]cnt_t_af;

    RD_Ctrl_s #(
            .SRAM_ADDRWIDTH(ADDR_WIDTH),
            .DATA_TYPE     (1), 
            .PORT_SEP      (1), 
            .CYC_BITWIDTH  (12)
        ) inst_RD_Ctrl_WeiFlg (
            .clk            (clk),
            .rst_n          (rst_n),
            .start          (SRAM_config_start),

            .SRAM_prepare   (Rd_prepare_WeiFlg),
            .PESRAM_rdy     (PESRAM_rdy_WeiFlg),
            .SRAMPE_val     (SRAMPE_val_WeiFlg),

            .read_en        (read_en_WeiFlg),
            .addr_Rd        (addr_Rd_WeiFlg),
            .pull_back      (CCUGB_pullback_wei),
            .read_SRAM_done (read_SRAM_done_WeiFlg),

            .SRAM_num       (CFGGB_SRAM_num_flgwei),
            .Data_num       (CFGGB_Data_num_flgwei),
            .cyc_num        (CFGGB_Cycl_num_flgwei),

            .State_Rd       (State_Rd_WeiFlg),
            .Rd_ID          (Rd_ID_WeiFlg_cor),
            .next_Rd_ID     (next_Rd_ID_WeiFlg_cor),
            .read_out_done  (read_Cyc_done_WeiFlg), 
            .cnt_td         (rd_addr_bias_WeiFlg)
        );

        
        RD_Ctrl_s #(
            .SRAM_ADDRWIDTH(ADDR_WIDTH),
            .DATA_TYPE     (2),  
            .PORT_SEP      (1), 
            .CYC_BITWIDTH  (8)
        ) inst_RD_Ctrl_Act (
            .clk            (clk),
            .rst_n          (rst_n),
            .start          (SRAM_config_start),

            .SRAM_prepare   (Rd_prepare_Act),
            .PESRAM_rdy     (PESRAM_rdy_Act),
            .SRAMPE_val     (SRAMPE_val_Act),

            .read_en        (read_en_Act),
            .addr_Rd        (addr_Rd_Act),
            .pull_back      (CCUGB_pullback_act),
            .read_SRAM_done (read_SRAM_done_Act),

            .SRAM_num       (CFGGB_SRAM_num_act),
            .Data_num       (CFGGB_Data_num_act),
            .cyc_num        (CFGGB_Cycl_num_act),

            .State_Rd       (State_Rd_Act),
            .Rd_ID          (Rd_ID_Act_cor),
            .next_Rd_ID     (next_Rd_ID_Act_cor),
            .read_out_done  (read_Cyc_done_Act), 
            .cnt_td         (rd_addr_bias_Act)
        );

        RD_Ctrl_s #(
            .SRAM_ADDRWIDTH(ADDR_WIDTH), 
            .DATA_TYPE     (3), 
            .PORT_SEP      (2), 
            .CYC_BITWIDTH  (8)
        ) inst_RD_Ctrl_ActFlg (
            .clk            (clk),
            .rst_n          (rst_n),
            .start          (SRAM_config_start),

            .SRAM_prepare   (Rd_prepare_ActFlg),
            .PESRAM_rdy     (PESRAM_rdy_ActFlg),
            .SRAMPE_val     (SRAMPE_val_ActFlg),

            .read_en        (read_en_ActFlg),
            .addr_Rd        (addr_Rd_ActFlg),
            .pull_back      (CCUGB_pullback_act),
            .read_SRAM_done (read_SRAM_done_ActFlg),

            .SRAM_num       (CFGGB_SRAM_num_flgact),
            .Data_num       (CFGGB_Data_num_flgact),
            .cyc_num        (CFGGB_Cycl_num_flgact),

            .State_Rd       (State_Rd_ActFlg),
            .Rd_ID          (Rd_ID_ActFlg_cor),
            .next_Rd_ID     (next_Rd_ID_ActFlg_cor),
            .read_out_done  (read_Cyc_done_ActFlg), 
            .cnt_td         (rd_addr_bias_ActFlg)
        );







Cor2Abs_ID inst_Cor2Abs_ID_Rd(
        .WeiFlg_cor_ID         (Rd_ID_WeiFlg_cor),
        .Act_cor_ID            (Rd_ID_Act_cor),
        .ActFlg_cor_ID         (Rd_ID_ActFlg_cor),
        .CFGGB_SRAM_num_wei    (CFGGB_SRAM_num_wei),
        .CFGGB_SRAM_num_flgwei (CFGGB_SRAM_num_flgwei),
        .CFGGB_SRAM_num_act    (CFGGB_SRAM_num_act),
        .CFGGB_SRAM_num_flgact (CFGGB_SRAM_num_flgact),
        .WeiFlg_abs_ID         (SRAMIF_Rd_ID_WeiFlg),
        .Act_abs_ID            (SRAMIF_Rd_ID_Act),
        .ActFlg_abs_ID         (SRAMIF_Rd_ID_ActFlg)
    );

Cor2Abs_ID inst_Cor2Abs_ID_Next_Rd(
        .WeiFlg_cor_ID         (next_Rd_ID_WeiFlg_cor),
        .Act_cor_ID            (next_Rd_ID_Act_cor),
        .ActFlg_cor_ID         (next_Rd_ID_ActFlg_cor),
        .CFGGB_SRAM_num_wei    (CFGGB_SRAM_num_wei),
        .CFGGB_SRAM_num_flgwei (CFGGB_SRAM_num_flgwei),
        .CFGGB_SRAM_num_act    (CFGGB_SRAM_num_act),
        .CFGGB_SRAM_num_flgact (CFGGB_SRAM_num_flgact),
        .WeiFlg_abs_ID         (next_Rd_ID_WeiFlg),
        .Act_abs_ID            (next_Rd_ID_Act),
        .ActFlg_abs_ID         (next_Rd_ID_ActFlg)
    );



endmodule