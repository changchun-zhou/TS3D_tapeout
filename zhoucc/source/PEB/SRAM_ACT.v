//======================================================
// Copyright (C) 2019 By zhoucc
// All Rights Reserved
//======================================================
// Module : SRAM_ACT
// Author : CC zhou
// Contact : 
// Date :  . .2019
//=======================================================
// Description :
//========================================================
`include "../source/include/dw_params_presim.vh"
module SRAM_ACT #( //FIFO 1 input 2 output fifo_asic
    parameter  DATA_WIDTH= `REGACT_WR_WIDTH,
    parameter  ADDR_WIDTH= 5,
    parameter  RD_NUM    = 2
    // parameter  PELACT_Handshake_n = 0
) (
    input                   clk     ,
    input                   rst_n   ,
    input                   reset   ,
    input                   PELACT_Handshake_n,

    output                  datain_rdy,
    input                   datain_val,
    input  [DATA_WIDTH      - 1 :0] datain,

    input                   dataout_rdy0,//REGACT
    output                  dataout_val0,
    output [DATA_WIDTH      - 1 : 0] dataout0,

    input                   dataout_rdy1,//PEB
    output                  dataout_val1,
    output [DATA_WIDTH      - 1 : 0] dataout1
);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================





//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
wire [ 2            - 1 : 0] fifo_pop;
wire [ 2            - 1 : 0] fifo_pop_d;
wire [ 2            - 1 : 0] fifo_empty;
wire                        fifo_push;
wire                        fifo_full;
wire [DATA_WIDTH      - 1 : 0] fifo_in;
wire [DATA_WIDTH      - 1 : 0] fifo_out;
// wire PELACT_Handshake_n;
//=====================================================================================================================
// Logic Design :
//=====================================================================================================================
assign datain_rdy = PELACT_Handshake_n ? !fifo_full && ~datain_val : !fifo_full; // Supest because of HandShake && ~(|fifo_pop); // lowest
assign fifo_push = PELACT_Handshake_n ? datain_val                 : datain_val && datain_rdy; // lowest
assign fifo_in = datain;

assign fifo_pop[0] = dataout_rdy0 && !fifo_empty[0] && !fifo_push;// SubSupest 
assign dataout_val0 = fifo_pop_d[0];

assign fifo_pop[1] = dataout_rdy1 && !fifo_empty[1] && ~fifo_pop[0] && !fifo_push; // lowest
assign dataout_val1 = fifo_pop_d[1];

assign dataout0 = fifo_out;
assign dataout1 = fifo_out;

//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================

fifo_mr_sram_act #( // Config SRAM
    .DATA_WIDTH(DATA_WIDTH ),
    .ADDR_WIDTH(ADDR_WIDTH ),
    .RD_NUM ( 2)
    ) fifo_Mux(
    .clk ( clk ),
    .rst_n ( rst_n ),
    .Reset ( reset),
    .push(fifo_push) ,
    .pop(fifo_pop ) ,//Own
    .data_in( fifo_in),
    .data_out (fifo_out ),
    .empty(fifo_empty ),//own
    .full (fifo_full )
    );
Delay #(
    .NUM_STAGES(1),
    .DATA_WIDTH(2)
    )Delay_fifo_pop_d(
    .CLK(clk),
    .RESET_N(rst_n),
    .DIN(fifo_pop),
    .DOUT(fifo_pop_d)
    );


endmodule