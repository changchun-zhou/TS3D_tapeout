// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : MinLiu 
// File   : ARB_2.v
// Create : 2020-07-14 21:07:23
// Revise : 2020-07-16 20:13:28
// -----------------------------------------------------------------------------
// Description :
// -----------------------------------------------------------------------------
module ARB_2 #(
    parameter PE_BLOCK = 16
    )(
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    input [15 : 0]sig, 

    output reg [3 : 0]sel
);

reg [3 : 0]shift_step;
wire [15 : 0]sig_w;
assign sig_w = (sig >> shift_step) | (sig << 16 - shift_step);
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sel <= 0;        
        shift_step <= 0;
    end else begin
        if (sig_w[0] == 1) begin
            sel        <= 0 + shift_step;
            shift_step <= shift_step + 1;
        end else if (sig_w[1] == 1) begin
            sel        <= 1 + shift_step;
            shift_step <= shift_step + 2;
        end else if (sig_w[2] == 1) begin
            sel        <= 2 + shift_step;
            shift_step <= shift_step + 3;
        end else if (sig_w[3] == 1) begin
            sel        <= 3 + shift_step;
            shift_step <= shift_step + 4;
        end else if (sig_w[4] == 1) begin
            sel        <= 4 + shift_step;
            shift_step <= shift_step + 5;
        end else if (sig_w[5] == 1) begin
            sel        <= 5 + shift_step;
            shift_step <= shift_step + 6;
        end else if (sig_w[6] == 1) begin
            sel        <= 6 + shift_step;
            shift_step <= shift_step + 7;
        end else if (sig_w[7] == 1) begin
            sel        <= 7 + shift_step;
            shift_step <= shift_step + 8;
        end else if (sig_w[8] == 1) begin
            sel        <= 8 + shift_step;
            shift_step <= shift_step + 9;
        end else if (sig_w[9] == 1) begin
            sel        <= 9 + shift_step;
            shift_step <= shift_step + 10;
        end else if (sig_w[10] == 1) begin
            sel        <= 10 + shift_step;
            shift_step <= shift_step + 11;
        end else if (sig_w[11] == 1) begin
            sel        <= 11 + shift_step;
            shift_step <= shift_step + 12;
        end else if (sig_w[12] == 1) begin
            sel        <= 12 + shift_step;
            shift_step <= shift_step + 13;
        end else if (sig_w[13] == 1) begin
            sel        <= 13 + shift_step;
            shift_step <= shift_step + 14;
        end else if (sig_w[14] == 1) begin
            sel        <= 14 + shift_step;
            shift_step <= shift_step + 15;
        end else if (sig_w[15] == 1) begin
            sel        <= 15 + shift_step;
            shift_step <= shift_step + 0;
        end
    end
end

endmodule