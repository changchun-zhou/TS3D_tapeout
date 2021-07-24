// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : MinLiu
// File   : RD_Ctrl_Wei.v
// Create : 2020-07-14 13:57:31
// Revise : 2020-08-07 09:02:20
// -----------------------------------------------------------------------------
// Description :
// -----------------------------------------------------------------------------
module RD_Ctrl_Wei # (
    parameter PORT_WIDTH       = 128,
    parameter NUM_PEB          = 16,
    parameter PE_NUM           = 27,
    parameter WEIADDR_WR_WIDTH = 16,
    parameter INSTR_WIDTH      = 8
    ) (
    input  clk,    // Clock
    input  rst_n,  // Asynchronous reset active low
    input  SRAM_config_start,
    input  read_Cyc_done_Wei,
    input  Rd_prepare_Wei,
    input  CCUGB_pullback_wei,

    input  IFWeiAddr_Conf_rdy,
    output WeiAddrIF_Conf_val,
    input  [11 : 0]Cycl_num_wei,

    output ADDRIF_rdy,
    input  IFADDR_val,
    input  [PORT_WIDTH - 1 : 0]Wei_Addr_Wr,

    output [NUM_PEB - 1 : 0]WEIPE_instr_rdy_all,
    input  [NUM_PEB - 1 : 0]PEWEI_instr_val_all,
    input  [INSTR_WIDTH * NUM_PEB  - 1 : 0] PEWEI_instr_data_all,

    output reg WeiData_read_en,
    output reg [15 : 0]WeiData_addr,
    output reg [1 : 0]State_Rd,
    output [3 : 0]Which_PEB_to_PE,
    output [4 : 0]Which_PE_to_PE,
    output read_SRAM_done,
    output [2 : 0]data_type
);

wire GBWEI_instr_rdy;
wire WEIGB_instr_val;
wire [INSTR_WIDTH - 1 : 0]WEIGB_instr_data;
wire [3 : 0]Which_PEB;
ARB_PE2Wei #(
    .PE_BLOCK(NUM_PEB),
    .INSTR_WIDTH(INSTR_WIDTH)
) inst_ARB_PE2Wei (
    .clk           (clk),
    .rst_n         (rst_n),
    .pull_back     (CCUGB_pullback_wei), 

    .WEIPE_rdy     (GBWEI_instr_rdy),
    .WEIPE_rdy_all (WEIPE_instr_rdy_all),

    .PEWei_val     (WEIGB_instr_val),
    .PEWei_val_all (PEWEI_instr_val_all),

    .data_out      (WEIGB_instr_data),
    .data_in       (PEWEI_instr_data_all),

    .Which_PEB     (Which_PEB)
);



reg [1 : 0]next_State_Rd;
parameter RD_IDLE = 2'b00, RD_READ_READY = 2'b01, RD_READ = 2'b11;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        State_Rd <= RD_IDLE;
    end else begin
        State_Rd <= next_State_Rd;
    end
end

always @( * ) begin
    if (~rst_n) begin
        next_State_Rd = RD_IDLE;
    end else begin
        case(State_Rd)
            RD_IDLE: if (SRAM_config_start) begin
                next_State_Rd = RD_IDLE;
            end else if (Rd_prepare_Wei) begin
                next_State_Rd = RD_READ_READY;
            end else begin
                next_State_Rd = RD_IDLE;
            end

            RD_READ_READY:if (SRAM_config_start) begin
                next_State_Rd = RD_IDLE;
            end else begin
                next_State_Rd = RD_READ;
            end

            RD_READ: if (SRAM_config_start) begin
                next_State_Rd = RD_IDLE;
            end else if (read_SRAM_done) begin
                next_State_Rd = RD_IDLE;
            end else begin
                next_State_Rd = RD_READ;
            end

            default: next_State_Rd = RD_IDLE;
        endcase
    end
end

    Wei_Address #(
            .PORT_WIDTH(PORT_WIDTH),
            .NUM_PEB(NUM_PEB),
            .PE_NUM(PE_NUM),
            .WEIADDR_WR_WIDTH(WEIADDR_WR_WIDTH),
            .INSTR_WIDTH(INSTR_WIDTH)
        ) inst_Wei_Address (
            .clk                (clk),
            .rst_n              (rst_n),
            .SRAM_config_start  (SRAM_config_start),
            .read_Cyc_done_Wei  (read_Cyc_done_Wei),
            .IFWeiAddr_Conf_rdy (IFWeiAddr_Conf_rdy),
            .WeiAddrIF_Conf_val (WeiAddrIF_Conf_val),
            .IFADDR_val         (IFADDR_val),
            .ADDRIF_rdy         (ADDRIF_rdy),
            .Wei_Addr_Wr        (Wei_Addr_Wr),
            .CCUGB_pullback_wei (CCUGB_pullback_wei),
            .Cycl_num_wei       (Cycl_num_wei),
            .State_Wei_Rd       (State_Rd),
            .GBWEI_instr_rdy    (GBWEI_instr_rdy),
            .WEIGB_instr_val    (WEIGB_instr_val),
            .WEIGB_instr_data   (WEIGB_instr_data),
            .WeiData_read_en    (WeiData_read_en),
            .WeiData_addr       (WeiData_addr),
            .read_SRAM_done     (read_SRAM_done),
            .Which_PEB          (Which_PEB),
            .Which_PEB_to_PE    (Which_PEB_to_PE),
            .Which_PE_to_PE     (Which_PE_to_PE ),
            .data_type          (data_type)
        );



endmodule
