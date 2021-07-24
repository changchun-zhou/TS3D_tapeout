//======================================================
// Copyright (C) 2020 By zhoucc
// All Rights Reserved
//======================================================
// Module : MAC
// Author : CC zhou
// Contact : 
// Date : 6 . 12.2020
//=======================================================
// Description :
//========================================================
`include "../source/include/dw_params_presim.vh"
module MAC
    (
    input                                   clk     ,
    input                                   rst_n   ,

    output                                  MACMUX_Val,
    output reg [`PSUM_ADDR_WIDTH    -1 : 0] MACMUX_Addr,       
    output [ `PSUM_WIDTH            -1 : 0] MACMUX_Psum,
    input                                   MUXMAC_Rdy,

    output                                  MACARB_ReqHelp,
    input                                   ARBMAC_Rst,
    // input [ `REGACT_ADDR_WIDTH      -1 : 0] ARBMAC_OffsetRow,// how many valid data in a row 
    input [ 2                       -1 : 0] PEBMAC_WeiCol, // W0 W1 or W2 for MACMUX_Addr AddrBase
    
    input [ `BLOCK_DEPTH            -1 : 0] MAC_FlgWei,
    input                                   MAC_FlgWei_Val,

    output                                  MAC_AddrFlgAct_Rdy,
    output reg [ `REGFLGACT_ADDR_WIDTH  -1 : 0] MAC_AddrFlgAct,
    input                                   MAC_FlgAct_Val,
    input [ `BLOCK_DEPTH            -1 : 0] MAC_FlgAct,

    output                                  MAC_AddrAct_Rdy,
    output [ `REGACT_ADDR_WIDTH     -1 : 0] MAC_AddrAct,
    input                                   MAC_Act_Val,
    input [ `DATA_WIDTH             -1 : 0] MAC_Act,

    output                                  MAC_AddrWei_Rdy,
    output [ `REGWEI_ADDR_WIDTH     -1 : 0] MAC_AddrWei,
    input                                   MAC_Wei_Val,
    input [ `DATA_WIDTH             -1 : 0] MAC_Wei // trans     
);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================





//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
reg MAC_Sta_;
wire MAC_Fnh;
wire MAC_Fnh_d;// ???
reg [`REGACT_ADDR_WIDTH        -1 : 0]MAC_AddrAct_tmp;
wire [`C_LOG_2(`BLOCK_DEPTH)    -1: 0]MACAW_OffsetAct;
reg [`REGWEI_ADDR_WIDTH        -1 : 0]MAC_AddrWei_tmp;

wire [`C_LOG_2(`BLOCK_DEPTH)    -1: 0] MACAW_OffsetWei;

wire MACAW_ValOffset;
wire MAC_FnhRow;
wire        MACAW_last_offset;

wire ActWei_Val;
//=====================================================================================================================
// Logic Design :
//=====================================================================================================================

localparam IDLE = 0;
localparam WAIT = 1;
localparam COMP = 2;

reg [2 -1 : 0           ] state;
reg [2 -1 : 0           ] next_state;

always @(*) begin
  if(!rst_n) begin
    next_state <= IDLE;
  end else begin
    case (state)
        IDLE  : if ( ARBMAC_Rst )
                    next_state <= WAIT;
                else 
                    next_state <= IDLE;
        WAIT:   if (MAC_FlgWei_Val&&MAC_FlgAct_Val  )
                    next_state <= COMP; // Compute all chns of a location
                else 
                    next_state <= WAIT;
        COMP:   if ( MAC_FnhRow ) 
                    next_state <= IDLE;
                else if ( MAC_Fnh && MUXMAC_Rdy)
                    next_state <= WAIT;
                else 
                    next_state <= COMP;

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

assign MAC_AddrFlgAct_Rdy = state == WAIT;// 
assign MAC_Sta = state==WAIT && next_state==COMP; // paulse

assign MACMUX_Val = state == COMP && MAC_Fnh;

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        MAC_AddrFlgAct <= 0;
    end else if ( ARBMAC_Rst ) begin
        MAC_AddrFlgAct <= 0; // or 16
    end else if ( state == COMP && MAC_Fnh && ~MAC_Fnh_d ) begin
        MAC_AddrFlgAct <= MAC_AddrFlgAct + 1;
    end
end

assign MAC_FnhRow = MAC_AddrFlgAct == 15 && MAC_Fnh; //computed a row
assign MACARB_ReqHelp = next_state == IDLE;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        MACMUX_Addr <= 1 - PEBMAC_WeiCol;
    end else if (ARBMAC_Rst  ) begin
        MACMUX_Addr <= 1 - PEBMAC_WeiCol;// W0:1; W1:0; W2:-1
    end else if ( state == COMP && MAC_Fnh && ~MAC_Fnh_d  ) begin// posedge
        MACMUX_Addr <= MACMUX_Addr + 1;
    end
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        MAC_AddrAct_tmp <= -1; // 
    end else if (ARBMAC_Rst) begin
        MAC_AddrAct_tmp <= -1;
    end else if (ActWei_Val || MACAW_last_offset ) begin // 
        MAC_AddrAct_tmp <= MAC_AddrAct;
    end
end
assign MAC_AddrAct = state == COMP? MAC_AddrAct_tmp + MACAW_OffsetAct : MAC_AddrAct_tmp;

assign MAC_AddrAct_Rdy = MACAW_ValOffset; // ARBMAC_Rst || MACAW_ValOffset;// Make sure that Array isn't empty
assign MAC_AddrWei_Rdy = MACAW_ValOffset;

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        MAC_AddrWei_tmp <= -1;
    end else if (ARBMAC_Rst) begin
        MAC_AddrWei_tmp <= -1;
    end else if (ActWei_Val  ) begin
        MAC_AddrWei_tmp <= MAC_AddrWei;
    end
end
assign MAC_AddrWei = state == COMP? MAC_AddrWei_tmp + MACAW_OffsetWei : MAC_AddrWei_tmp;


assign ActWei_Val = MAC_Wei_Val&&MAC_Act_Val;
//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================

MACAW inst_MACAW
(
  .clk           (clk),
  .rst_n         (rst_n),
  .PECMAC_Sta    (MAC_Sta),
  .PECMAC_FlgAct (MAC_FlgAct),
  .PECMAC_FlgWei (MAC_FlgWei),
  .PECMAC_ActWei_Val(ActWei_Val),
  .PECMAC_Act    (MAC_Act),
  .PECMAC_Wei    (MAC_Wei),
  .MACAW_ValOffset(MACAW_ValOffset),
  .MACAW_last_offset(MACAW_last_offset),
  .MACAW_OffsetWei(MACAW_OffsetWei),
  .MACAW_OffsetAct(MACAW_OffsetAct),
  .MACPEC_Fnh    (MAC_Fnh),
  .MACMAC_Mac    (0),
  .MACCNV_Mac    (MACMUX_Psum)
);

Delay #(
    .NUM_STAGES(1),
    .DATA_WIDTH(1)
    )Delay_MAC_Fnh_d(
    .CLK(clk),
    .RESET_N(rst_n),
    .DIN(MAC_Fnh),
    .DOUT(MAC_Fnh_d)
    );
    
endmodule