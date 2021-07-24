// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : MinLiu 
// File   : SRAM.v
// Create : 2020-07-14 14:35:16
// Revise : 2020-08-03 10:31:14
// -----------------------------------------------------------------------------
// Description :
// -----------------------------------------------------------------------------


module SRAM # (
    parameter ADDR_WIDTH    = 7,
    parameter DATAIN_WIDTH  = 2 ** ADDR_WIDTH,
    parameter DATAOUT_WIDTH = 2 ** ADDR_WIDTH,
    parameter DATA_DEPTH    = 512
    )(
    input [ADDR_WIDTH - 1 : 0]A, 
    output reg [DATAOUT_WIDTH - 1 : 0]DO, 
    input [DATAIN_WIDTH - 1 : 0]DI,
    input [3 : 0]DVS, 
    input DVSE, 
    input WEB, 
    input CK,    // Clock
    input CSB
);


reg [DATAIN_WIDTH - 1 : 0]Sram_Block[0 : DATA_DEPTH - 1];

always @(posedge CK) begin
    if ((~CSB) & (WEB)) begin
        DO <= Sram_Block[A];
    end
end

always @(posedge CK) begin
    if ((~CSB) & (~WEB)) begin
        Sram_Block[A] <= DI;
    end
end

endmodule