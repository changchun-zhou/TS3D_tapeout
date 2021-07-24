//======================================================
// Copyright (C) 2019 By zhoucc
// All Rights Reserved
//======================================================
// Module : ACT
// Author : CC zhou
// Contact : 
// Date : 6 . 13.2019
//=======================================================
// Description :
//========================================================
`include "../source/include/dw_params_presim.vh"
module REGFLGWEI #( // Handshake
    parameter  DATA_WIDTH = 32,
    parameter  ADDR_WIDTH = 5,
    parameter  WR_NUM = 2,
    parameter  RD_NUM = 27 
) (
    input                               clk     ,
    input                               rst_n   ,
    input                               reset   ,
    output                              datain_rdy,
    input                               datain_val,
    input [ DATA_WIDTH*WR_NUM   -1 : 0] datain,

    output[ RD_NUM              -1 : 0] dataout_val,
    output[DATA_WIDTH *RD_NUM   -1 : 0] dataout

);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================





//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
reg [ ADDR_WIDTH                -1 : 0] wr_pointer;
reg [ DATA_WIDTH*(RD_NUM+1)               -1 : 0] mem; //[ 0 : RD_NUM ]; // 28
wire [ DATA_WIDTH               -1 : 0] MEM_mem[ 0 : RD_NUM]; //[ 0 : RD_NUM ]; // 28

//=====================================================================================================================
// Logic Design :
//=====================================================================================================================


always @ (posedge clk or negedge rst_n)
begin : WRITE_PTR
  if (!rst_n) begin
    wr_pointer <= 0;
  end else if( reset )begin
    wr_pointer <= 0;
  end else if (datain_val && datain_rdy) begin
    wr_pointer <= wr_pointer + WR_NUM;
  end
end

wire[ ADDR_WIDTH    -1 : 0] wr_addr;
assign wr_addr = wr_pointer; // transform to register address
always @ (posedge clk or negedge rst_n) begin :WRITE
  if( !rst_n) begin
    mem <= 0;
  end else if (datain_val && datain_rdy) begin
    mem[ DATA_WIDTH*wr_addr +: (DATA_WIDTH*WR_NUM)] <= datain;
  end
end

assign datain_rdy = wr_pointer < (RD_NUM + 1); // < 14

generate
    genvar i;
    for(i=0;i<RD_NUM;i=i+1) begin
        assign dataout[DATA_WIDTH*i +: DATA_WIDTH] = mem[DATA_WIDTH*i +: DATA_WIDTH];
        assign dataout_val[i] = wr_pointer == RD_NUM + 1; //14
        assign MEM_mem[i] = mem[DATA_WIDTH*i +: DATA_WIDTH];
    end
endgenerate


//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================


endmodule

