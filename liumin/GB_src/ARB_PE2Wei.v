// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : MinLiu
// File   : ARB_PE2Wei.v
// Create : 2020-07-22 14:27:54
// Revise : 2020-07-24 19:42:38
// -----------------------------------------------------------------------------
// Description :
// -----------------------------------------------------------------------------
module ARB_PE2Wei #(
    parameter PE_BLOCK    = 16,
    parameter INSTR_WIDTH = 8
    )(
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    input pull_back, 
    input WEIPE_rdy,
    input [PE_BLOCK               - 1 : 0]PEWei_val_all,
    input [INSTR_WIDTH * PE_BLOCK - 1 : 0]data_in,

    output reg [PE_BLOCK    - 1 : 0]WEIPE_rdy_all,
    output reg [INSTR_WIDTH - 1 : 0]data_out,
    output reg [3               : 0]Which_PEB,
    output reg PEWei_val
);

reg  [3  : 0]shift_step;
wire [15 : 0]sig_w;
assign sig_w = (PEWei_val_all >> shift_step) | (PEWei_val_all << (16 - shift_step));
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_step <= 0;
    end else if (pull_back) begin
        shift_step <= 0;
    end else if (WEIPE_rdy * PEWei_val) begin
        if (sig_w[0] == 1) begin
            shift_step <= shift_step + 1;
        end else if (sig_w[1] == 1) begin
            shift_step <= shift_step + 2;
        end else if (sig_w[2] == 1) begin
            shift_step <= shift_step + 3;
        end else if (sig_w[3] == 1) begin
            shift_step <= shift_step + 4;
        end else if (sig_w[4] == 1) begin
            shift_step <= shift_step + 5;
        end else if (sig_w[5] == 1) begin
            shift_step <= shift_step + 6;
        end else if (sig_w[6] == 1) begin
            shift_step <= shift_step + 7;
        end else if (sig_w[7] == 1) begin
            shift_step <= shift_step + 8;
        end else if (sig_w[8] == 1) begin
            shift_step <= shift_step + 9;
        end else if (sig_w[9] == 1) begin
            shift_step <= shift_step + 10;
        end else if (sig_w[10] == 1) begin
            shift_step <= shift_step + 11;
        end else if (sig_w[11] == 1) begin
            shift_step <= shift_step + 12;
        end else if (sig_w[12] == 1) begin
            shift_step <= shift_step + 13;
        end else if (sig_w[13] == 1) begin
            shift_step <= shift_step + 14;
        end else if (sig_w[14] == 1) begin
            shift_step <= shift_step + 15;
        end else if (sig_w[15] == 1) begin
            shift_step <= shift_step + 0;
        end
    end
end


wire [3 : 0]Which_PEB_d;
wire PEWei_val_d;
wire [INSTR_WIDTH - 1 : 0]data_out_d;
always @( * ) begin
        if (sig_w[0] == 1) begin
            Which_PEB = 0 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[1] == 1) begin
            Which_PEB = 1 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[2] == 1) begin
            Which_PEB = 2 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[3] == 1) begin
            Which_PEB = 3 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[4] == 1) begin
            Which_PEB = 4 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[5] == 1) begin
            Which_PEB = 5 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[6] == 1) begin
            Which_PEB = 6 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[7] == 1) begin
            Which_PEB = 7 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[8] == 1) begin
            Which_PEB = 8 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[9] == 1) begin
            Which_PEB = 9 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[10] == 1) begin
            Which_PEB = 10 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[11] == 1) begin
            Which_PEB = 11 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[12] == 1) begin
            Which_PEB = 12 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[13] == 1) begin
            Which_PEB = 13 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[14] == 1) begin
            Which_PEB = 14 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else if (sig_w[15] == 1) begin
            Which_PEB = 15 + shift_step;
            PEWei_val = PEWei_val_all[Which_PEB];
            data_out  =       data_in[Which_PEB * 8 +: 8];
        end else begin
            Which_PEB = Which_PEB_d;
            PEWei_val = 0;
            data_out  = data_out_d;
        end
end


    Delay #(
            .NUM_STAGES(1),
            .DATA_WIDTH(4)
        ) inst_Delay_whichPE (
            .CLK     (clk),
            .RESET_N (rst_n),
            .DIN     (Which_PEB),
            .DOUT    (Which_PEB_d)
        );

    Delay #(
            .NUM_STAGES(1),
            .DATA_WIDTH(1)
        ) inst_Delay_PEWei_val (
            .CLK     (clk),
            .RESET_N (rst_n),
            .DIN     (PEWei_val),
            .DOUT    (PEWei_val_d)
        );

    Delay #(
            .NUM_STAGES(1),
            .DATA_WIDTH(INSTR_WIDTH)
        ) inst_Delay_data_out (
            .CLK     (clk),
            .RESET_N (rst_n),
            .DIN     (data_out),
            .DOUT    (data_out_d)
        );

integer i;
always @( * ) begin
    for (i = 0; i < 16; i = i + 1)begin
        if (i == Which_PEB) begin
            WEIPE_rdy_all[i] = WEIPE_rdy;
        end else begin
            WEIPE_rdy_all[i] = 0;
        end
    end
end


endmodule
