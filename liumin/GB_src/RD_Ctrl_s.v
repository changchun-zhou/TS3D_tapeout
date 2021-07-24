// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : MinLiu
// File   : RD_Ctrl_s.v
// Create : 2020-07-15 15:44:32
// Revise : 2020-08-03 22:02:44
// -----------------------------------------------------------------------------
// Description :
// -----------------------------------------------------------------------------
module RD_Ctrl_s #(
    parameter SRAM_ADDRWIDTH = 9,
    parameter DATA_TYPE = 1,
    parameter PORT_SEP = 1,
    parameter CYC_BITWIDTH = 'd8
    )(
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    input start,

    input SRAM_prepare, //

    input  PESRAM_rdy,
    output SRAMPE_val,

    output read_en,
    output reg [SRAM_ADDRWIDTH - 1 : 0]addr_Rd,

    output read_SRAM_done,
    input  pull_back,

    //-------------------------------
    input [3 : 0]SRAM_num,
    input [3 : 0]Data_num,
    input [CYC_BITWIDTH - 1 : 0]cyc_num,

    output reg [1 : 0]State_Rd,
    output reg [3 : 0]Rd_ID,
    output [3 : 0]next_Rd_ID,
    output reg read_out_done,
    output reg [PORT_SEP - 1 : 0]cnt_td, 

    output [CYC_BITWIDTH - 1 : 0]Cyc, 
    output done_t
);


reg [1 : 0]next_State_Rd;
parameter RD_IDLE = 2'b00, RD_READ_READY = 2'b01, RD_READ = 2'b11;

wire SRAM_prepare_d;

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
            RD_IDLE: if (start) begin
                next_State_Rd = RD_IDLE;
            end else if (read_out_done) begin
                next_State_Rd = RD_IDLE;
            end else if (SRAM_prepare_d & SRAM_prepare) begin
                next_State_Rd = RD_READ_READY;
            end else begin
                next_State_Rd = RD_IDLE;
            end
            RD_READ_READY: if (start) begin
                next_State_Rd = RD_IDLE;
            end else if (PESRAM_rdy) begin
                next_State_Rd = RD_READ;
            end else begin
                next_State_Rd = RD_READ_READY;
            end
            RD_READ: if (start) begin
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

reg [PORT_SEP - 1 : 0]cnt_t;
wire read_en_t;
assign read_SRAM_done = ((addr_Rd == 0 && cnt_t == 0) && (PESRAM_rdy == 1) && (State_Rd == RD_READ)) || pull_back;
assign SRAMPE_val     = (State_Rd == RD_READ);

assign read_en_t      = ((State_Rd == RD_READ && next_State_Rd == RD_READ) || (State_Rd == RD_READ_READY && next_State_Rd == RD_READ)) && (PESRAM_rdy == 1);
assign read_en        = (read_en_t == 1) && (cnt_t == 0);


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_t  <= 0;
        cnt_td <= 0;
    end else if (start || read_SRAM_done) begin
        cnt_t  <= 0;
        cnt_td <= 0;
    end else if (DATA_TYPE == 2) begin
        cnt_t  <= 0;
        cnt_td <= 0;
    end else if (read_en_t) begin
        cnt_t  <= cnt_t + 1;
        cnt_td <= cnt_t;
    end
end


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        addr_Rd <= 0;
    end else if (State_Rd == RD_IDLE) begin
        addr_Rd <= 0;
    end else if (read_en) begin
        addr_Rd <= addr_Rd + 1;
    end
end

wire next_Rd_ID_flag;
assign next_Rd_ID_flag = (State_Rd == RD_READ_READY && next_State_Rd == RD_READ);

Delay #(
    .NUM_STAGES ( 1 ),
    .DATA_WIDTH ( 1 )
)
Delay_GBCFG_rdy
(
    .CLK                (clk),
    .RESET_N            (rst_n),
    .DIN                (SRAM_prepare),
    .DOUT               (SRAM_prepare_d)
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Rd_ID <= 0;
    end else if (State_Rd == RD_IDLE && SRAM_prepare == 1) begin
        Rd_ID <= next_Rd_ID;
    end
end


SRAM_Rd_ID # (
    .CYC_BITWIDTH(CYC_BITWIDTH)
    ) inst_SRAM_Rd_ID (
        .clk           (clk),
        .rst_n         (rst_n),
        .start         (start),
        .pull_back     (pull_back), 
        // .data_type     (data_type),
        .SRAM_num      (SRAM_num),
        .Data_num      (Data_num),
        .cyc_num       (cyc_num),
        .read_out_flag (next_Rd_ID_flag),

        .Rd_ID         (next_Rd_ID),
        .read_SRAM_done(read_SRAM_done),
        .done          (read_out_done), 
        .Cyc           (Cyc), 
        .done_t        (done_t)
    );

endmodule
