// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : MinLiu 
// File   : WR_Next_ID.v
// Create : 2020-07-15 11:40:57
// Revise : 2020-07-27 16:30:43
// -----------------------------------------------------------------------------
// Description :
// -----------------------------------------------------------------------------
module WR_Next_ID (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    input SRAM_config_start, 
    input read_Cyc_done_Wei, 
    input read_Cyc_done_WeiFlg, 
    input read_Cyc_done_Act, 
    input read_Cyc_done_ActFlg, 
    input next_Wr_ID_flag,
    input [1 : 0]State_Wr, 
    input [3 : 0]CFGGB_SRAM_num_wei, CFGGB_SRAM_num_flgwei, CFGGB_SRAM_num_act, CFGGB_SRAM_num_flgact, 
    input [3 : 0]CFGGB_Data_num_wei, CFGGB_Data_num_flgwei, CFGGB_Data_num_act, CFGGB_Data_num_flgact, 
    input [11 : 0]CFGGB_Cycl_num_wei, CFGGB_Cycl_num_flgwei, 
    input [7  : 0]CFGGB_Cycl_num_act, CFGGB_Cycl_num_flgact, 
    input [0 :15]Wr_Req_g, 

    output Wr_Req_n, 
    output [5 : 0]SRAMIF_Wr_ID, 
    output done_Wei, done_WeiFlg, done_Act, done_ActFlg 
);


wire [3 : 0]Wr_ID_Wei_cor, Wr_ID_WeiFlg_cor, Wr_ID_Act_cor, Wr_ID_ActFlg_cor;
wire [5 : 0]Wr_ID_Wei, Wr_ID_WeiFlg, Wr_ID_Act, Wr_ID_ActFlg;

assign Wr_ID_Wei = {2'b00, Wr_ID_Wei_cor};

Cor2Abs_ID inst_Cor2Abs_ID_Wr(
        .WeiFlg_cor_ID         (Wr_ID_WeiFlg_cor),
        .Act_cor_ID            (Wr_ID_Act_cor),
        .ActFlg_cor_ID         (Wr_ID_ActFlg_cor),
        .CFGGB_SRAM_num_wei    (CFGGB_SRAM_num_wei),
        .CFGGB_SRAM_num_flgwei (CFGGB_SRAM_num_flgwei),
        .CFGGB_SRAM_num_act    (CFGGB_SRAM_num_act),
        .CFGGB_SRAM_num_flgact (CFGGB_SRAM_num_flgact),
        .WeiFlg_abs_ID         (Wr_ID_WeiFlg),
        .Act_abs_ID            (Wr_ID_Act),
        .ActFlg_abs_ID         (Wr_ID_ActFlg)
    );


SRAM_Wr_ID #(
    .DATA_TYPE (2'b00), 
    .CYC_BITWIDTH (12)
    )
SRAM_Wr_ID_Wei (
    .clk                        (clk),    // Clock
    .rst_n                      (rst_n),  // Asynchronous reset active low
    .start                      (SRAM_config_start | read_Cyc_done_Wei), 
    .data_type                  (SRAMIF_Wr_ID[5 : 4]), 
    .SRAM_num                   (CFGGB_SRAM_num_wei),
    .Data_num                   (CFGGB_Data_num_wei),
    .read_out_flag              (next_Wr_ID_flag), 
    .cyc_num                    (CFGGB_Cycl_num_wei), 

    .Wr_ID                      (Wr_ID_Wei_cor),
    .done                       (done_Wei)
);


SRAM_Wr_ID #(
    .DATA_TYPE (2'b01),
    .CYC_BITWIDTH (12)
    )
SRAM_Wr_ID_WeiFlg (
    .clk                        (clk),    // Clock
    .rst_n                      (rst_n),  // Asynchronous reset active low
    
    .start                      (SRAM_config_start | read_Cyc_done_WeiFlg), 
    .data_type                  (SRAMIF_Wr_ID[5 : 4]), 
    .SRAM_num                   (CFGGB_SRAM_num_flgwei),
    .Data_num                   (CFGGB_Data_num_flgwei),
    .read_out_flag              (next_Wr_ID_flag), 
    .cyc_num                    (CFGGB_Cycl_num_flgwei), 

    .Wr_ID                      (Wr_ID_WeiFlg_cor),
    .done                       (done_WeiFlg)
);


SRAM_Wr_ID #(
    .DATA_TYPE (2'b10),
    .CYC_BITWIDTH (8)
    )
SRAM_Wr_ID_Act (
    .clk                        (clk),    // Clock
    .rst_n                      (rst_n),  // Asynchronous reset active low
    
    .start                      (SRAM_config_start | read_Cyc_done_Act), 
    .data_type                  (SRAMIF_Wr_ID[5 : 4]), 
     
    .SRAM_num                   (CFGGB_SRAM_num_act),
    .Data_num                   (CFGGB_Data_num_act),
    .read_out_flag              (next_Wr_ID_flag), 
    .cyc_num                    (CFGGB_Cycl_num_act), 

    .Wr_ID                      (Wr_ID_Act_cor),
    .done                       (done_ActFlg)
);

SRAM_Wr_ID #(
    .DATA_TYPE (2'b11),
    .CYC_BITWIDTH (8)
    )
SRAM_Wr_ID_ActFlg (
    .clk                        (clk),    // Clock
    .rst_n                      (rst_n),  // Asynchronous reset active low
    
    .start                      (SRAM_config_start | read_Cyc_done_ActFlg), 
    .data_type                  (SRAMIF_Wr_ID[5 : 4]), 
    .SRAM_num                   (CFGGB_SRAM_num_flgact),
    .Data_num                   (CFGGB_Data_num_flgact),
    .read_out_flag              (next_Wr_ID_flag), 
    .cyc_num                    (CFGGB_Cycl_num_act), 

    .Wr_ID                      (Wr_ID_ActFlg_cor),
    .done                       (done_Act)
);

wire Wr_Req_Wei, Wr_Req_WeiFlg, Wr_Req_Act, Wr_Req_ActFlg;
assign Wr_Req_Wei    = Wr_Req_g[Wr_ID_Wei[3 : 0]];
assign Wr_Req_WeiFlg = Wr_Req_g[Wr_ID_WeiFlg[3 : 0]];
assign Wr_Req_Act    = Wr_Req_g[Wr_ID_Act[3 : 0]];
assign Wr_Req_ActFlg = Wr_Req_g[Wr_ID_ActFlg[3 : 0]];

assign Wr_Req_n = Wr_Req_Wei | Wr_Req_WeiFlg | Wr_Req_Act | Wr_Req_ActFlg;
wire Wr_Req;
ARB_WR2SRAM Arbitrater(
    .clk                        ( clk ), 
    .rst_n                      ( rst_n), 

    .State_Wr                   ( State_Wr     ),

    .Wr_ID_Wei                  ( Wr_ID_Wei    ), 
    .Wr_ID_WeiFlg               ( Wr_ID_WeiFlg ), 
    .Wr_ID_Act                  ( Wr_ID_Act    ), 
    .Wr_ID_ActFlg               ( Wr_ID_ActFlg ), 

    .Wr_Req_Wei                 ( Wr_Req_Wei   ), 
    .Wr_Req_WeiFlg              ( Wr_Req_WeiFlg), 
    .Wr_Req_Act                 ( Wr_Req_Act   ), 
    .Wr_Req_ActFlg              ( Wr_Req_ActFlg), 

//
    .Wr_ID                      ( SRAMIF_Wr_ID ),
    .Wr_Req                     ( Wr_Req       )

    );
endmodule