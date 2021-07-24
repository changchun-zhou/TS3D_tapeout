// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : MinLiu
// File   : SRAM_Block.v
// Create : 2020-07-13 21:47:25
// Revise : 2020-08-06 20:16:16
// -----------------------------------------------------------------------------
// Description :
// -----------------------------------------------------------------------------
`timescale 1ns/1ps

module SRAM_Block # (
    parameter DATA_TYPE_WEIFLG = 1,
    parameter DATA_TYPE_ACT    = 2,
    parameter DATA_TYPE_ACTFLG = 3,
    parameter ADDR_WIDTH       = 9,
    parameter NUM_PEB          = 16,
    parameter PE_NUM           = 27,
    parameter PORT_WIDTH       = 128,
    parameter WEI_WR_WIDTH     = 128, // 16B
    parameter FLGWEI_WR_WIDTH  = 64, // 8B
    parameter ACT_WR_WIDTH     = 128, // 16B
    parameter FLGACT_WR_WIDTH  = 32 // 4B)
    ) (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low

    input Layer_start,

    //--------------------------------------------
    input  CFGGB_val,
    output reg GBCFG_rdy,

    input [3  : 0]CFGGB_SRAM_num_wei, CFGGB_SRAM_num_flgwei, CFGGB_SRAM_num_act, CFGGB_SRAM_num_flgact,
    input [3  : 0]CFGGB_Data_num_flgwei, CFGGB_Data_num_act, CFGGB_Data_num_flgact,
    input [11 : 0]CFGGB_Cycl_num_wei,
    input [7  : 0]CFGGB_Cycl_num_act,

    input CCUGB_pullback_wei,
    input CCUGB_pullback_act,
    //--------------------------------------------
    input  IFWR_Conf_rdy,
    output reg IFWR_Conf_val,
    output reg [2 : 0]IFWR_Conf_DT,

    //--------------------------------------------
    input  IFWR_Data_val,
    output reg IFWR_Data_rdy,
    input  [PORT_WIDTH - 1 : 0]IFWR_Data_data,

    //--------------------------------------------
    output [NUM_PEB - 1 : 0]WEIPE_instr_rdy_all,
    input  [NUM_PEB - 1 : 0]PEWEI_instr_val_all,
    input  [8 * NUM_PEB  - 1 : 0] PEWEI_instr_data_all,

    //--------------------------------------------
    input  [NUM_PEB - 1 : 0]PESRAM_rdy_Wei,
    output reg [NUM_PEB - 1 : 0]SRAMPE_val_Wei,
    output [PORT_WIDTH - 1 : 0]PESRAM_data_Wei,

    input  [NUM_PEB - 1 : 0]PESRAM_rdy_WeiFlg,
    output [NUM_PEB - 1 : 0]SRAMPE_val_WeiFlg,
    output [FLGWEI_WR_WIDTH - 1 : 0]PESRAM_data_WeiFlg,

    input  PESRAM_rdy_Act,
    output SRAMPE_val_Act,
    output [PORT_WIDTH - 1 : 0]PESRAM_data_Act,

    input  PESRAM_rdy_ActFlg,
    output SRAMPE_val_ActFlg,
    output [FLGACT_WR_WIDTH - 1 : 0]PESRAM_data_ActFlg,

    //--------------------------------------------

    output [4  : 0]Which_PE_to_PE, 
    output [99 : 0]debug_info

);


//--------------------- cfg abs of weiaddress and other data ---------------------
wire [3 : 0]Which_PEB_to_PE;

wire [5 : 0]SRAMIF_Wr_ID;
wire [2 : 0]SRAMIF_Wr_DT;
wire [2 : 0]data_type_weiaddr;

assign SRAMIF_Wr_DT = {1'b1, SRAMIF_Wr_ID[5 : 4]};

wire IFSRAM_Conf_rdy;
wire SRAMIF_Conf_val;

wire IFWeiAddr_Conf_rdy;
wire WeiAddrIF_Conf_val;

reg IFWR_Conf_val_d;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        IFWR_Conf_val_d <= 0;
    end else begin
        IFWR_Conf_val_d <= IFWR_Conf_val;
    end
end

always @( * ) begin
    if (WeiAddrIF_Conf_val) begin
        IFWR_Conf_val = WeiAddrIF_Conf_val;
        IFWR_Conf_DT  = 3;
    end else if (SRAMIF_Conf_val) begin
        IFWR_Conf_val = SRAMIF_Conf_val;
        IFWR_Conf_DT  = SRAMIF_Wr_DT;
    end else begin
        IFWR_Conf_val = 0;
        IFWR_Conf_DT  = 0;
    end
end

reg [3 : 0]IFWR_Conf_DT_t;
reg [3 : 0]IFWR_Conf_DT_t_d;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        IFWR_Conf_DT_t_d <= 4'b1000;
    end else begin
        IFWR_Conf_DT_t_d <= IFWR_Conf_DT_t;
    end
end

always @( * ) begin
    if (IFWR_Conf_val & IFWR_Conf_rdy) begin
        IFWR_Conf_DT_t = IFWR_Conf_DT;
    end else begin
        IFWR_Conf_DT_t = IFWR_Conf_DT_t_d;
    end
end

assign IFWeiAddr_Conf_rdy = (IFWR_Conf_DT_t ==            3) ? IFWR_Conf_rdy : 0;
assign IFSRAM_Conf_rdy    = (IFWR_Conf_DT_t == SRAMIF_Wr_DT) ? IFWR_Conf_rdy : 0;


//--------------------------------------------

wire IFSRAM_Wr_val;
wire SRAMIF_Wr_rdy;
wire [PORT_WIDTH - 1 : 0]IFSRAM_Wr_Data;

wire ADDRIF_rdy;
wire IFADDR_val;
wire [PORT_WIDTH - 1 : 0]Wei_Addr_Wr;

assign Wei_Addr_Wr    = (IFWR_Conf_DT_t == 3'b011      ) ? IFWR_Data_data : 0;
assign IFSRAM_Wr_Data = (IFWR_Conf_DT_t == SRAMIF_Wr_DT) ? IFWR_Data_data : 0;

assign IFADDR_val     = (IFWR_Conf_DT_t == 3'b011      ) ? IFWR_Data_val : 0;
assign IFSRAM_Wr_val  = (IFWR_Conf_DT_t == SRAMIF_Wr_DT) ? IFWR_Data_val : 0;

always @( * ) begin
    if (IFWR_Conf_DT_t == 3) begin
        IFWR_Data_rdy = ADDRIF_rdy;
    end else if (IFWR_Conf_DT_t == SRAMIF_Wr_DT) begin
        IFWR_Data_rdy = SRAMIF_Wr_rdy;
    end else begin
        IFWR_Data_rdy = 0;
    end
end





//===================== FSM =====================
parameter IDLE = 2'b00, CFG_BLOCK = 2'b01, WAIT = 2'b11;
reg [1 : 0]State_CFG, next_State_CFG;

parameter WR_IDLE = 2'b00, WR_REQ_READY = 2'b01, WR_WRITE = 2'b11;
parameter RD_IDLE = 2'b00, RD_READ_READY = 2'b01, RD_READ = 2'b11;
reg [1 : 0]State_Wr, next_State_Wr;

reg config_done;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        config_done <= 0;
    end
    else if (State_CFG == CFG_BLOCK) begin
        if (CFGGB_val) begin
            config_done <= 1;
        end else begin
            config_done <= 0;
        end
    end else begin
        if (CFGGB_val & GBCFG_rdy) begin
            config_done <= 1;
        end else begin
            config_done <= 0;
        end
    end
end

always @( * ) begin
    if (~rst_n) begin
        next_State_CFG = IDLE;
    end
    else begin
        case(State_CFG)
        IDLE:
            next_State_CFG = CFG_BLOCK;

        CFG_BLOCK:
            if (config_done) begin
                next_State_CFG = WAIT;
            end else begin
                next_State_CFG = CFG_BLOCK;
            end

        WAIT:
            if (Layer_start) begin
                next_State_CFG = IDLE;
            end else begin
                next_State_CFG = WAIT;
            end

        default: next_State_CFG = IDLE;
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        State_CFG <= IDLE;
    end else begin
        State_CFG <= next_State_CFG;
    end
end

wire SRAM_config_start;
Delay #(
    .NUM_STAGES ( 1 ),
    .DATA_WIDTH ( 1 )
)
Delay_GBCFG_rdy
(
    .CLK                (clk),
    .RESET_N            (rst_n),
    .DIN                (config_done),
    .DOUT               (SRAM_config_start)
);


//================ config the SRAM Block ===================
wire read_Cyc_done_WeiFlg, read_Cyc_done_Act, read_Cyc_done_ActFlg;
reg  read_Cyc_done_Wei;
reg  [1 : 0]latch_rdy;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        GBCFG_rdy <= 1'b0;
        latch_rdy <= 0;
    end else if (next_State_CFG == CFG_BLOCK) begin
        if (CFGGB_val) begin
            GBCFG_rdy <= 1'b0;
        end else begin
            GBCFG_rdy <= 1'b1;
        end
    end else if (read_Cyc_done_Wei & read_Cyc_done_WeiFlg & read_Cyc_done_Act & read_Cyc_done_ActFlg) begin
        if (GBCFG_rdy == 1) begin
            if (CFGGB_val) begin
                GBCFG_rdy <= 1'b0;
                latch_rdy <= 2;
            end
        end else begin
            if (latch_rdy != 0) begin
                GBCFG_rdy <= 1'b0;
                latch_rdy <= latch_rdy - 1;
            end else begin
                GBCFG_rdy <= 1;
            end
        end
    end
end

reg [15 : 0]SRAM_Cover_Flag;
generate
    genvar cover_f_i;
    for (cover_f_i = 0; cover_f_i < 16; cover_f_i = cover_f_i + 1) begin: COVER_FLAG
        always @(posedge clk) begin
            if (State_CFG != IDLE) begin
                if (CFGGB_val & GBCFG_rdy) begin
                    if (cover_f_i < CFGGB_SRAM_num_wei) begin
                        SRAM_Cover_Flag[cover_f_i] <= 1'b0;

                    end else if (cover_f_i < CFGGB_SRAM_num_wei + CFGGB_SRAM_num_flgwei) begin
                        if (CFGGB_SRAM_num_flgwei >= CFGGB_Data_num_flgwei) begin
                            SRAM_Cover_Flag[cover_f_i] <= 1'b0;
                        end else if (2 * CFGGB_SRAM_num_flgwei > CFGGB_Data_num_flgwei) begin
                            if (cover_f_i == CFGGB_SRAM_num_wei) begin
                                SRAM_Cover_Flag[cover_f_i] <= 1'b0;
                            end else if (cover_f_i <= CFGGB_SRAM_num_wei + (CFGGB_Data_num_flgwei - CFGGB_SRAM_num_flgwei)) begin
                                SRAM_Cover_Flag[cover_f_i] <= 1'b1;
                            end else begin
                                SRAM_Cover_Flag[cover_f_i] <= 1'b0;
                            end
                        end else begin
                            SRAM_Cover_Flag[cover_f_i] <= 1'b1;
                        end

                    end else if (cover_f_i < CFGGB_SRAM_num_wei + CFGGB_SRAM_num_flgwei + CFGGB_SRAM_num_act) begin
                        if (CFGGB_SRAM_num_act >= CFGGB_Data_num_act) begin
                            SRAM_Cover_Flag[cover_f_i] <= 1'b0;
                        end else if (2 * CFGGB_SRAM_num_act > CFGGB_Data_num_act) begin
                            if (cover_f_i == CFGGB_SRAM_num_wei + CFGGB_SRAM_num_flgwei) begin
                                SRAM_Cover_Flag[cover_f_i] <= 1'b0;
                            end else if (cover_f_i <= CFGGB_SRAM_num_wei + CFGGB_SRAM_num_flgwei + (CFGGB_Data_num_act - CFGGB_SRAM_num_act)) begin
                                SRAM_Cover_Flag[cover_f_i] <= 1'b1;
                            end else begin
                                SRAM_Cover_Flag[cover_f_i] <= 1'b0;
                            end
                        end else begin
                            SRAM_Cover_Flag[cover_f_i] <= 1'b1;
                        end

                    end else begin
                        if (CFGGB_SRAM_num_flgact >= CFGGB_Data_num_flgact) begin
                            SRAM_Cover_Flag[cover_f_i] <= 1'b0;
                        end else if (2 * CFGGB_SRAM_num_act > CFGGB_Data_num_act) begin
                            if (cover_f_i == CFGGB_SRAM_num_wei + CFGGB_SRAM_num_flgwei + CFGGB_SRAM_num_act) begin
                                SRAM_Cover_Flag[cover_f_i] <= 1'b0;
                            end else if (cover_f_i <= CFGGB_SRAM_num_wei + CFGGB_SRAM_num_flgwei + CFGGB_SRAM_num_act + (CFGGB_Data_num_flgact - CFGGB_SRAM_num_flgact)) begin
                                SRAM_Cover_Flag[cover_f_i] <= 1'b1;
                            end else begin
                                SRAM_Cover_Flag[cover_f_i] <= 1'b0;
                            end
                        end else begin
                            SRAM_Cover_Flag[cover_f_i] <= 1'b1;
                        end
                    end
                end
            end
        end
    end
endgenerate


//===================== WR SRAM =====================
wire [0 : 15]Wr_Req_g;
wire done_Wei, done_WeiFlg, done_Act, done_ActFlg;

wire write_en;
wire [ADDR_WIDTH - 1 : 0]addr_Wr;
wire write_SRAM_done;

WR_Ctrl #(
    .SRAM_ADDRWIDTH(ADDR_WIDTH),
    .SRAM_DEPTH(2 ** ADDR_WIDTH),
    .WR_IDLE(WR_IDLE),
    .WR_REQ_READY(WR_REQ_READY),
    .WR_WRITE(WR_WRITE)
) inst_WR_Ctrl (
    .clk                   (clk),
    .rst_n                 (rst_n),
    .SRAM_config_start     (SRAM_config_start),
    .CFGGB_SRAM_num_wei    (CFGGB_SRAM_num_wei),
    .CFGGB_SRAM_num_flgwei (CFGGB_SRAM_num_flgwei),
    .CFGGB_SRAM_num_act    (CFGGB_SRAM_num_act),
    .CFGGB_SRAM_num_flgact (CFGGB_SRAM_num_flgact),
    .CFGGB_Data_num_wei    (CFGGB_SRAM_num_wei),
    .CFGGB_Data_num_flgwei (CFGGB_Data_num_flgwei),
    .CFGGB_Data_num_act    (CFGGB_Data_num_act),
    .CFGGB_Data_num_flgact (CFGGB_Data_num_flgact),
    .CFGGB_Cycl_num_wei    (CFGGB_Cycl_num_wei),
    .CFGGB_Cycl_num_flgwei (CFGGB_Cycl_num_wei),
    .CFGGB_Cycl_num_act    (CFGGB_Cycl_num_act),
    .CFGGB_Cycl_num_flgact (CFGGB_Cycl_num_act),
    .Wr_Req_g              (Wr_Req_g),
    .SRAMIF_Wr_ID          (SRAMIF_Wr_ID),
    .done_Wei              (done_Wei),
    .done_WeiFlg           (done_WeiFlg),
    .done_Act              (done_Act),
    .done_ActFlg           (done_ActFlg),
    .read_Cyc_done_Wei     (read_Cyc_done_Wei),
    .read_Cyc_done_WeiFlg  (read_Cyc_done_WeiFlg),
    .read_Cyc_done_Act     (read_Cyc_done_Act),
    .read_Cyc_done_ActFlg  (read_Cyc_done_ActFlg),
    .State_Wr              (State_Wr),
    .write_en              (write_en),
    .write_SRAM_done       (write_SRAM_done),
    .addr_Wr               (addr_Wr),
    .IFSRAM_Conf_rdy       (IFSRAM_Conf_rdy),
    .SRAMIF_Conf_val       (SRAMIF_Conf_val),
    .IFSRAM_Wr_val         (IFSRAM_Wr_val),
    .SRAMIF_Wr_rdy         (SRAMIF_Wr_rdy)
);


//===================== RD SRAM =====================
wire Rd_prepare_WeiFlg, Rd_prepare_Act, Rd_prepare_ActFlg;

wire read_en_WeiFlg, read_en_Act, read_en_ActFlg;
wire [ADDR_WIDTH - 1 : 0]addr_Rd_WeiFlg, addr_Rd_Act, addr_Rd_ActFlg;
wire read_SRAM_done_WeiFlg, read_SRAM_done_Act, read_SRAM_done_ActFlg;

wire [1 : 0]State_Rd_WeiFlg, State_Rd_Act, State_Rd_ActFlg;
wire [5 : 0]SRAMIF_Rd_ID_WeiFlg, SRAMIF_Rd_ID_Act, SRAMIF_Rd_ID_ActFlg;
wire [5 : 0]next_Rd_ID_WeiFlg, next_Rd_ID_Act, next_Rd_ID_ActFlg;

wire rd_addr_bias_WeiFlg, rd_addr_bias_Act;
wire [1 : 0]rd_addr_bias_ActFlg;
wire SRAMPE_val_WeiFlg_s, PESRAM_rdy_WeiFlg_s;
    WeiFlg_Abs #(
            .PEB(NUM_PEB)
        ) inst_WeiFlg_Abs (
            .clk          (clk),
            .rst_n        (rst_n),
            // .start        (SRAM_config_start),
            .WeiFlg_rdy   (PESRAM_rdy_WeiFlg),
            .WeiFlg_val_s (SRAMPE_val_WeiFlg_s),
            .WeiFlg_rdy_s (PESRAM_rdy_WeiFlg_s),
            .WeiFlg_val   (SRAMPE_val_WeiFlg)
        );

wire done_t_WeiFlg, done_t_Act, done_t_ActFlg; 
wire [11 : 0]Cyc_WeiFlg; 
wire [7 : 0]Cyc_Act, Cyc_ActFlg;
RD_Ctrl #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) inst_RD_Ctrl (
        .clk                   (clk),
        .rst_n                 (rst_n),
        .SRAM_config_start     (SRAM_config_start),
        .CFGGB_SRAM_num_wei    (CFGGB_SRAM_num_wei),
        .CFGGB_SRAM_num_flgwei (CFGGB_SRAM_num_flgwei),
        .CFGGB_SRAM_num_act    (CFGGB_SRAM_num_act),
        .CFGGB_SRAM_num_flgact (CFGGB_SRAM_num_flgact),
        .CFGGB_Data_num_wei    (CFGGB_SRAM_num_wei),
        .CFGGB_Data_num_flgwei (CFGGB_Data_num_flgwei),
        .CFGGB_Data_num_act    (CFGGB_Data_num_act),
        .CFGGB_Data_num_flgact (CFGGB_Data_num_flgact),
        .CFGGB_Cycl_num_wei    (CFGGB_Cycl_num_wei),
        .CFGGB_Cycl_num_flgwei (CFGGB_Cycl_num_wei),
        .CFGGB_Cycl_num_act    (CFGGB_Cycl_num_act),
        .CFGGB_Cycl_num_flgact (CFGGB_Cycl_num_act),
        .Rd_prepare_WeiFlg     (Rd_prepare_WeiFlg),
        .Rd_prepare_Act        (Rd_prepare_Act),
        .Rd_prepare_ActFlg     (Rd_prepare_ActFlg),
        .SRAMIF_Rd_ID_WeiFlg   (SRAMIF_Rd_ID_WeiFlg),
        .SRAMIF_Rd_ID_Act      (SRAMIF_Rd_ID_Act),
        .SRAMIF_Rd_ID_ActFlg   (SRAMIF_Rd_ID_ActFlg),
        .next_Rd_ID_WeiFlg     (next_Rd_ID_WeiFlg),
        .next_Rd_ID_Act        (next_Rd_ID_Act),
        .next_Rd_ID_ActFlg     (next_Rd_ID_ActFlg),
        .State_Rd_WeiFlg       (State_Rd_WeiFlg),
        .State_Rd_Act          (State_Rd_Act),
        .State_Rd_ActFlg       (State_Rd_ActFlg),
        .CCUGB_pullback_wei    (CCUGB_pullback_wei),
        .CCUGB_pullback_act    (CCUGB_pullback_act),
        .read_SRAM_done_WeiFlg (read_SRAM_done_WeiFlg),
        .read_SRAM_done_Act    (read_SRAM_done_Act),
        .read_SRAM_done_ActFlg (read_SRAM_done_ActFlg),
        .PESRAM_rdy_WeiFlg     (PESRAM_rdy_WeiFlg_s),
        .PESRAM_rdy_Act        (PESRAM_rdy_Act),
        .PESRAM_rdy_ActFlg     (PESRAM_rdy_ActFlg),
        .SRAMPE_val_WeiFlg     (SRAMPE_val_WeiFlg_s),
        .SRAMPE_val_Act        (SRAMPE_val_Act),
        .SRAMPE_val_ActFlg     (SRAMPE_val_ActFlg),
        .addr_Rd_WeiFlg        (addr_Rd_WeiFlg),
        .addr_Rd_Act           (addr_Rd_Act),
        .addr_Rd_ActFlg        (addr_Rd_ActFlg),
        .read_en_WeiFlg        (read_en_WeiFlg),
        .read_en_Act           (read_en_Act),
        .read_en_ActFlg        (read_en_ActFlg),
        .read_Cyc_done_WeiFlg  (read_Cyc_done_WeiFlg),
        .read_Cyc_done_Act     (read_Cyc_done_Act),
        .read_Cyc_done_ActFlg  (read_Cyc_done_ActFlg),
        .rd_addr_bias_WeiFlg   (rd_addr_bias_WeiFlg),
        .rd_addr_bias_Act      (rd_addr_bias_Act),
        .rd_addr_bias_ActFlg   (rd_addr_bias_ActFlg), 

        .done_t_WeiFlg         (done_t_WeiFlg),
        .done_t_Act            (done_t_Act), 
        .done_t_ActFlg         (done_t_ActFlg), 
        .Cyc_WeiFlg            (Cyc_WeiFlg), 
        .Cyc_Act               (Cyc_Act), 
        .Cyc_ActFlg            (Cyc_ActFlg)
    );
wire [1  : 0]State_Rd_Wei;
wire read_en_Wei;
wire [15 : 0]addr_Rd_Wei;
wire [5  : 0]SRAMIF_Rd_ID_Wei;
reg  [5  : 0]SRAMIF_Rd_ID_Wei_d;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        SRAMIF_Rd_ID_Wei_d <= 0;
    end else if (read_en_Wei) begin
        SRAMIF_Rd_ID_Wei_d <= SRAMIF_Rd_ID_Wei;
    end
end


wire read_SRAM_done_Wei;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        read_Cyc_done_Wei <= 0;
    end else if (SRAM_config_start || read_Cyc_done_Wei) begin
        read_Cyc_done_Wei <= 0;
    end else if (read_SRAM_done_Wei) begin
        read_Cyc_done_Wei <= 1;
    end
end

assign SRAMIF_Rd_ID_Wei = {2'b00, addr_Rd_Wei[12 : 9]};

reg Rd_prepare_Wei;


wire SRAMPE_val_Wei_s;
Delay #(
    .NUM_STAGES ( 1 ),
    .DATA_WIDTH ( 1 )
)
Delay_read_en_Wei
(
    .CLK                (clk),
    .RESET_N            (rst_n),
    .DIN                (read_en_Wei),
    .DOUT               (SRAMPE_val_Wei_s)
);

integer i ;
always @( * ) begin
    for ( i = 0; i < NUM_PEB; i = i + 1) begin
        if (i == Which_PEB_to_PE) begin
            SRAMPE_val_Wei[i] = SRAMPE_val_Wei_s;
        end else begin
            SRAMPE_val_Wei[i] = 0;
        end
    end
end
wire [2 : 0]state_Wei_Addr;
RD_Ctrl_Wei  # (
    .PORT_WIDTH       (PORT_WIDTH),
    .NUM_PEB          (NUM_PEB),
    .PE_NUM           (PE_NUM),
    .WEIADDR_WR_WIDTH (16),
    .INSTR_WIDTH      (8)
    ) RD_Ctrl_Wei(
    .clk                        (clk),    // Clock
    .rst_n                      (rst_n),  // Asynchronous reset active low
    .SRAM_config_start          (SRAM_config_start),
    .read_Cyc_done_Wei          (read_Cyc_done_Wei),
    .Rd_prepare_Wei             (Rd_prepare_Wei),
    .CCUGB_pullback_wei         (CCUGB_pullback_wei),

    .IFWeiAddr_Conf_rdy         (IFWeiAddr_Conf_rdy),
    .WeiAddrIF_Conf_val         (WeiAddrIF_Conf_val),
    .Cycl_num_wei               (CFGGB_Cycl_num_wei),

    .ADDRIF_rdy                 (ADDRIF_rdy),
    .IFADDR_val                 (IFADDR_val),
    .Wei_Addr_Wr                (Wei_Addr_Wr),

    .WEIPE_instr_rdy_all        (WEIPE_instr_rdy_all),
    .PEWEI_instr_val_all        (PEWEI_instr_val_all),
    .PEWEI_instr_data_all       (PEWEI_instr_data_all),

    .WeiData_read_en            (read_en_Wei),
    .WeiData_addr               (addr_Rd_Wei),
    .State_Rd                   (State_Rd_Wei),
    .Which_PEB_to_PE            (Which_PEB_to_PE),
    .Which_PE_to_PE             (Which_PE_to_PE),
    .read_SRAM_done             (read_SRAM_done_Wei),
    .data_type                  (data_type_weiaddr), 
    .state_Wei_Addr             (state_Wei_Addr)
);



//===================== Block Control =====================
parameter Block_Ctrl_IDLE = 3'b000, Block_Ctrl_READY_TO_WRITE = 3'b001, Block_Ctrl_WRITE = 3'b011, Block_Ctrl_READY_TO_READ = 3'b010, Block_Ctrl_READ = 3'b110;


wire [0 : 15]Rd_Prepare_g;
wire [0 : 15]SRAMPE_val_g;
reg  [PORT_WIDTH - 1 : 0]data_out_g[0 : 15];

generate
    genvar block_ctrl_i;
        for (block_ctrl_i = 0; block_ctrl_i < 16; block_ctrl_i = block_ctrl_i + 1) begin: BLOCK_CTRL
        wire Wr_Req, Rd_Prepare;
        wire [3 : 0]SRAM_ID;
        reg  [1 : 0]State_Rd;
        wire write_SRAM_done_s;
        reg  read_SRAM_done_s;

        reg  PESRAM_rdy;

        wire write_en_s;
        reg  read_en_s;
        wire [PORT_WIDTH - 1 : 0]data_in, data_out;
        reg  [ADDR_WIDTH - 1 : 0]addr_r;
        wire [ADDR_WIDTH - 1 : 0]addr_w;

        reg start;
        wire [1 : 0]SRAM_Block_state;

        assign SRAM_ID = block_ctrl_i;
    SRAM_CTRL # (
        .ADDR_WIDTH(ADDR_WIDTH),
        .PORT_WIDTH(PORT_WIDTH),
        .WEI_WR_WIDTH(WEI_WR_WIDTH), // 16B
        .FLGWEI_WR_WIDTH(FLGWEI_WR_WIDTH), // 8B
        .ACT_WR_WIDTH(ACT_WR_WIDTH), // 16B
        .FLGACT_WR_WIDTH(FLGACT_WR_WIDTH), // 4B)
        .SRAM_DEPTH(2 ** ADDR_WIDTH)
    )SRAM_CTRL (
        .clk                    (clk),    // Clock
        .rst_n                  (rst_n),  // Asynchronous reset active low

        .start                  (start),
        .SRAM_ID                (SRAM_ID),
        .SRAM_Cover_Flag        (SRAM_Cover_Flag[block_ctrl_i]),

        .SRAMIF_Wr_ID           (SRAMIF_Wr_ID),
        .SRAMIF_Rd_ID_Wei       (SRAMIF_Rd_ID_Wei),
        .SRAMIF_Rd_ID_WeiFlg    (SRAMIF_Rd_ID_WeiFlg),
        .SRAMIF_Rd_ID_Act       (SRAMIF_Rd_ID_Act),
        .SRAMIF_Rd_ID_ActFlg    (SRAMIF_Rd_ID_ActFlg),

        .State_Wr               (State_Wr),
        .State_Rd               (State_Rd),

        .write_SRAM_done        (write_SRAM_done_s),
        .read_SRAM_done         (read_SRAM_done_s),

        .Wr_Req                 (Wr_Req),
        .Rd_Prepare             (Rd_Prepare),

        .IFSRAM_Conf_rdy        (IFSRAM_Conf_rdy),
        .PESRAM_rdy             (PESRAM_rdy),

        .write_en               (write_en_s),
        .read_en                (read_en_s),
        .data_in                (data_in),
        .data_out               (data_out),
        .addr_w                 (addr_w),
        .addr_r                 (addr_r), 

        .Block_Ctrl_state       (SRAM_Block_state)
        );
        assign Wr_Req_g    [block_ctrl_i] = Wr_Req;
        assign Rd_Prepare_g[block_ctrl_i] = Rd_Prepare;//output to the Wr_ctrl

        assign write_en_s        = (SRAMIF_Wr_ID[3 : 0] == SRAM_ID) ? write_en        : 0;
        assign addr_w            = (SRAMIF_Wr_ID[3 : 0] == SRAM_ID) ? addr_Wr         : 0;
        assign data_in           = (SRAMIF_Wr_ID[3 : 0] == SRAM_ID) ? IFSRAM_Wr_Data  : 0;
        assign write_SRAM_done_s = (SRAMIF_Wr_ID[3 : 0] == SRAM_ID) ? write_SRAM_done : 0;//input to the SRAM from the Wr_ctrl

        always @( * ) begin
            data_out_g[block_ctrl_i] = data_out;
        end
        always @( * ) begin
            if (block_ctrl_i <= CFGGB_SRAM_num_wei - 1) begin
                read_SRAM_done_s = read_SRAM_done_Wei;
                if (SRAMIF_Rd_ID_Wei[3 : 0] == block_ctrl_i) begin
                    PESRAM_rdy = PESRAM_rdy_Wei[Which_PEB_to_PE];
                    addr_r     = addr_Rd_Wei[8 : 0];
                    read_en_s  = read_en_Wei;
                end else begin
                    PESRAM_rdy = 0;
                    addr_r     = addr_Rd_Wei[8 : 0];
                    read_en_s  = 0;
                end
            end else begin
                if (SRAMIF_Rd_ID_WeiFlg[3 : 0] == block_ctrl_i) begin
                    read_SRAM_done_s  = read_SRAM_done_WeiFlg;
                    PESRAM_rdy        = PESRAM_rdy_WeiFlg_s;
                    addr_r            = addr_Rd_WeiFlg;
                    read_en_s         = read_en_WeiFlg;

                end else if (SRAMIF_Rd_ID_Act[3 : 0] == block_ctrl_i) begin
                    read_SRAM_done_s  = read_SRAM_done_Act;
                    PESRAM_rdy        = PESRAM_rdy_Act;
                    addr_r            = addr_Rd_Act;
                    read_en_s         = read_en_Act;

                end else if (SRAMIF_Rd_ID_ActFlg[3 : 0] == block_ctrl_i) begin
                    read_SRAM_done_s  = read_SRAM_done_ActFlg;
                    PESRAM_rdy        = PESRAM_rdy_ActFlg;
                    addr_r            = addr_Rd_ActFlg;
                    read_en_s         = read_en_ActFlg;

                end else begin
                    read_SRAM_done_s = 0;
                    PESRAM_rdy       = 0;
                    addr_r           = 0;
                    read_en_s        = 0;
                end
            end
        end

        always @( * ) begin
            State_Rd = RD_IDLE;
            if (block_ctrl_i < CFGGB_SRAM_num_wei) begin
                State_Rd = State_Rd_Wei;
                start    = SRAM_config_start || read_Cyc_done_Wei;
            end else if (block_ctrl_i < CFGGB_SRAM_num_wei + CFGGB_SRAM_num_flgwei) begin
                State_Rd = State_Rd_WeiFlg;
                start    = SRAM_config_start || read_Cyc_done_WeiFlg;
            end else if (block_ctrl_i < CFGGB_SRAM_num_wei + CFGGB_SRAM_num_flgwei + CFGGB_SRAM_num_act) begin
                State_Rd = State_Rd_Act;
                start    = SRAM_config_start || read_Cyc_done_Act;
            end else begin
                State_Rd = State_Rd_ActFlg;
                start    = SRAM_config_start || read_Cyc_done_ActFlg;
            end
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Rd_prepare_Wei <= 0;
    end else if (SRAMIF_Wr_ID[5 : 4] == 0 && SRAMIF_Wr_ID[3 : 0] == CFGGB_SRAM_num_wei - 1) begin
        Rd_prepare_Wei <= write_SRAM_done;
    end else begin
        Rd_prepare_Wei <= 0;
    end
end
assign Rd_prepare_WeiFlg = Rd_Prepare_g[next_Rd_ID_WeiFlg[3 : 0]];
assign Rd_prepare_Act    = Rd_Prepare_g[next_Rd_ID_Act[3 : 0]];
assign Rd_prepare_ActFlg = Rd_Prepare_g[next_Rd_ID_ActFlg[3 : 0]];

assign PESRAM_data_Wei    = data_out_g[SRAMIF_Rd_ID_Wei_d[3 : 0]];
assign PESRAM_data_WeiFlg = data_out_g[SRAMIF_Rd_ID_WeiFlg[3 : 0]][rd_addr_bias_WeiFlg * FLGWEI_WR_WIDTH +: FLGWEI_WR_WIDTH];
assign PESRAM_data_Act    = data_out_g[SRAMIF_Rd_ID_Act[3 : 0]];
assign PESRAM_data_ActFlg = data_out_g[SRAMIF_Rd_ID_ActFlg[3 : 0]][rd_addr_bias_ActFlg * FLGACT_WR_WIDTH +: FLGACT_WR_WIDTH];



assign debug_info = {
    BLOCK_CTRL[ 0].SRAM_Block_state, //2bit
    BLOCK_CTRL[ 1].SRAM_Block_state, 
    BLOCK_CTRL[ 2].SRAM_Block_state, 
    BLOCK_CTRL[ 3].SRAM_Block_state, 
    BLOCK_CTRL[ 4].SRAM_Block_state, 
    BLOCK_CTRL[ 5].SRAM_Block_state, 
    BLOCK_CTRL[ 6].SRAM_Block_state, 
    BLOCK_CTRL[ 7].SRAM_Block_state, 
    BLOCK_CTRL[ 8].SRAM_Block_state, 
    BLOCK_CTRL[ 9].SRAM_Block_state, 
    BLOCK_CTRL[10].SRAM_Block_state, 
    BLOCK_CTRL[11].SRAM_Block_state, 
    BLOCK_CTRL[12].SRAM_Block_state, 
    BLOCK_CTRL[13].SRAM_Block_state, 
    BLOCK_CTRL[14].SRAM_Block_state, 
    BLOCK_CTRL[15].SRAM_Block_state,
    State_Wr, //2bit
    state_Wei_Addr, //3bit
    State_Rd_Wei, //2bit
    State_Rd_WeiFlg, //2bit
    State_Rd_Act, //2bit
    State_Rd_ActFlg,  //2bit
    done_t_WeiFlg, 
    done_t_Act, 
    done_t_ActFlg, 
    Cyc_WeiFlg, 
    Cyc_Act, 
    Cyc_ActFlg, 
    read_Cyc_done_Wei, 
    read_Cyc_done_WeiFlg, 
    read_Cyc_done_Act, 
    read_Cyc_done_ActFlg
    };


endmodule

