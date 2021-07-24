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
module REGARRAY #( // Handshake
    parameter  DATA_WIDTH = `DATA_WIDTH,
    parameter  ADDR_WIDTH = `MAX_DEPTH_WIDTH, // ALL addr width
    parameter  REG_ADDR_WIDTH = 7, // this registerfile addr width
    parameter  WR_NUM = `REGACT_WR_WIDTH/DATA_WIDTH,
    parameter  RD_NUM = `MAC_NUM 
) (
    input                           clk     ,
    input                           rst_n   ,
    input                           reset   ,

    output                          datain_rdy,
    input                           datain_val,
    input [ DATA_WIDTH*WR_NUM-1: 0] datain,

    input [ ADDR_WIDTH -1:0] dataout_addr[ 0 : RD_NUM -1],
    input [ RD_NUM          -1 : 0] dataout_rdy,
    input [ RD_NUM          -1 : 0] dataout_sw,
    input                           ARBACT_RowOn,
    input [ ADDR_WIDTH      -1 : 0] AddrRowAct,
    output [ RD_NUM          -1 : 0] dataout_val, //reg
    output [DATA_WIDTH -1: 0] dataout[ 0 : `MAC_NUM -1] //reg

);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================


// reg [ ADDR_WIDTH    -1 : 0] dataout_addr[ 0: RD_NUM -1];
wire [ RD_NUM            -1 : 0] wire_dataout_val;
wire [ DATA_WIDTH       -1 : 0] wire_dataout[0: RD_NUM   -1];
//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
wire [ RD_NUM           -1 : 0] datain_req_sw;

reg [ DATA_WIDTH * (2**REG_ADDR_WIDTH)   -1 : 0] mem; // [ 0 : 2**REG_ADDR_WIDTH -1];
reg [ ADDR_WIDTH    -1 : 0] wr_pointer;
wire[ REG_ADDR_WIDTH    -1 : 0] MEM_dataout_addr[ 0: RD_NUM -1];
wire [RD_NUM            -1 : 0] lack;
//=====================================================================================================================
// Logic Design :
//=====================================================================================================================

localparam IDLE     = 0;
localparam WRITE    = 1;
localparam READ     = 2;

reg [2 -1 : 0           ] state;
reg [2 -1 : 0           ] next_state;

always @(*) begin
  if(!rst_n) begin
    next_state <= IDLE;
  end else begin
    case (state)
        IDLE:   if ( |dataout_sw )
                    next_state <= WRITE;
                else 
                    next_state <= IDLE;
        WRITE:  if (reset)
                    next_state <= IDLE;
                else if( datain_val)
                    next_state <= READ;
                else 
                    next_state <= WRITE;
        READ:   if (reset)
                    next_state <= IDLE;
                else if (lack )
                    next_state <= WRITE;
                else
                    next_state <= READ;
      default: next_state <= IDLE;
    endcase
  end
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end
// *****************************************************************************

always @ (posedge clk or negedge rst_n)
begin : WRITE_PTR
  if (!rst_n) begin
    wr_pointer <= 0;
  end else if( reset )begin
    wr_pointer <= 0;
  end else if (datain_val) begin
    wr_pointer <= wr_pointer + WR_NUM;
  end
end

wire[ REG_ADDR_WIDTH    -1 : 0] wr_addr;
assign wr_addr = wr_pointer; // transform to register address
always @ (posedge clk or negedge rst_n) begin
  if( !rst_n) begin
    mem <= 0;
  end else if ( reset) begin 
    mem <= 0;
  end else if (datain_val) begin
    mem[ DATA_WIDTH*wr_addr +: (DATA_WIDTH*WR_NUM)] <= datain;
  end
end

generate
    genvar i;
    for(i=0;i<RD_NUM;i=i+1) begin
        wire [ADDR_WIDTH    -1 : 0] dataout_addr_tmp;
        wire Cnst_L;
        // assign dataout_addr_tmp = (dataout_rdy[i] ? MEM_dataout_addr[i] : 0);
        assign dataout_addr_tmp = dataout_addr[i]; // because addr is + and ARBMAC_Rst reset addr to baseaddr
        assign dataout[i] = mem[DATA_WIDTH*MEM_dataout_addr[i] +: DATA_WIDTH];
        assign Cnst_L = (wr_pointer < 2**REG_ADDR_WIDTH) || ( (wr_pointer - 2**REG_ADDR_WIDTH) <= dataout_addr_tmp);
        assign dataout_val[i] = dataout_rdy[i] && Cnst_L && dataout_addr_tmp < wr_pointer;
        assign datain_req_sw[i] = dataout_sw[i] && ( ( $signed(wr_pointer) <= $signed(dataout_addr_tmp) ) ||  $signed($signed(wr_pointer) - $signed(dataout_addr_tmp) ) <= $signed(2**REG_ADDR_WIDTH - WR_NUM) );
        // assign datain_req_sw[i] = dataout_sw[i] && ( ( wr_pointer <= dataout_addr_tmp ) ||  ((wr_pointer - dataout_addr_tmp)  <= (2**REG_ADDR_WIDTH - WR_NUM)) );
        // transform to register address
        assign MEM_dataout_addr[i] = dataout_addr[i];
    end
endgenerate

wire datain_rdy_sw;
wire datain_rdy_min; // when someone weight is not arbed, judge current row's AddrRowAct with wr_pointer
assign datain_rdy_sw  = ((datain_req_sw & dataout_sw) == dataout_sw) && dataout_sw!=0; // switch on's mac all require
assign datain_rdy_min = ARBACT_RowOn ? 1 : ( ( wr_pointer <= AddrRowAct ) ||  (wr_pointer - AddrRowAct ) <= (2**REG_ADDR_WIDTH - WR_NUM) ) ;
// always @ ( posedge clk or negedge rst_n ) begin 
//     if ( !rst_n ) begin
//         datain_rdy <= 0;
//     end else begin
//         datain_rdy <= datain_rdy_sw && datain_rdy_min;
//     end
// end
assign lack = datain_rdy_sw && datain_rdy_min;

reg reg_datain_rdy;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        reg_datain_rdy <= 0;
    end else if ( reset ) begin
        reg_datain_rdy <= 0;
    end else if ( datain_val ) begin
        reg_datain_rdy <= 0;
    end else if ( state != WRITE && next_state == WRITE) begin
        reg_datain_rdy <= 1;
    end
end

assign datain_rdy = reg_datain_rdy && ~datain_val; // because SRAM_WEI.dataout_val delay after .dataout_rdy

//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================


endmodule

