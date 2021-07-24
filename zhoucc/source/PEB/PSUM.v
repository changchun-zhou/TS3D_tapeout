//======================================================
// Copyright (C) 2019 By zhoucc
// All Rights Reserved
//======================================================
// Module : 
// Author : CC zhou
// Contact : 
// Date :  . .2019
//=======================================================
// Description :
//========================================================
`include "../source/include/dw_params_presim.vh"
// ***************************
// 1. Write Psum from 4 input ports
// 2. Be read by GB
module PSUM ( // Handshake
    input                                           clk     ,
    input                                           rst_n   ,
    input                                           reset,//
    output                                          PSUMARB_empty,
    input                                           ARBPSUM_fnh,
    input                                           MACPSUM_empty      ,// default==1

    input                                           psumaddr_val      ,
    input [ `PSUM_ADDR_WIDTH + `PSUM_WIDTH  -1 : 0] psumaddr,// MAC0 FIFO                        
    output                                          psumaddr_rdy,//reg

    input                                           datain_val,
    input [ `PSUM_WIDTH*`LENROW             -1 : 0] datain,
    output                                          datain_rdy ,//reg

    output                                          dataout_val,//reg
    output [ `PSUM_WIDTH*`LENROW            -1 : 0] dataout, //reg
    input                                           dataout_rdy 
    // 
);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================


//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
reg [ `PSUM_WIDTH*`LENROW - 1 : 0 ] PSUM_ARRAY;
reg signed[ `PSUM_WIDTH         - 1 : 0 ] PSO_PSUM_ARRAY [ 0 : `LENROW -1] ;
wire                                wr_en;
wire                                write_fnh;
//=====================================================================================================================
// Logic Design :
//=====================================================================================================================
localparam IDLE = 0;
localparam WAITIN = 1;
localparam WRITE = 2;
localparam WAITOUT = 3;

reg [2 -1 : 0           ] state;
reg [2 -1 : 0           ] next_state;

always @(*) begin
  if(!rst_n) begin
    next_state <= IDLE;
  end else begin
    case (state)
        IDLE  : if ( ~ARBPSUM_fnh  )
                    next_state <= WAITIN;
                else 
                    next_state <= IDLE;
        WAITIN: if ( datain_val && datain_rdy )  
                    next_state <= WRITE;
                else
                    next_state <= WAITIN;
        WRITE : if (reset)
                    next_state <= IDLE;
                else if ( write_fnh && ARBPSUM_fnh)
                    next_state <= WAITOUT;
                else
                    next_state <= WRITE;
        WAITOUT:if (reset)
                    next_state <= IDLE;
                else if ( dataout_rdy)
                    next_state <= IDLE;
                else
                    next_state <= WAITOUT;
      default: next_state <= IDLE;
    endcase
  end
end
// wire wire_PSUMARB_rdy;
assign write_fnh = MACPSUM_empty && ~psumaddr_val; // level
assign dataout_val = state == WAITOUT;
// assign wire_PSUMARB_rdy = ~(state==WRITE&&next_state==WAITOUT); // only not if judge whether to out

assign PSUMARB_empty = state == IDLE; //WAITOUT && next_state == WAITIN;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

assign datain_rdy = state == WAITIN;

assign wr_en = psumaddr_val && state==WRITE;
assign psumaddr_rdy =  state==WRITE;

wire [ `PSUM_ADDR_WIDTH     - 1 : 0] wr_addr;
wire [ `PSUM_WIDTH          - 1 : 0] wr_data;
assign wr_addr = psumaddr[0 +: `PSUM_ADDR_WIDTH];
assign wr_data = psumaddr[`PSUM_ADDR_WIDTH +: `PSUM_WIDTH];

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        PSUM_ARRAY <= 0;
    // end else if(reset) begin 
    //     PSUM_ARRAY <= 0;
    end else if ( datain_val && datain_rdy ) begin // After fetched, set to 0
        PSUM_ARRAY <= datain;
    end else if ( wr_en ) begin //
        PSUM_ARRAY[`PSUM_WIDTH*wr_addr +: `PSUM_WIDTH] <= 
        PSUM_ARRAY[`PSUM_WIDTH*wr_addr +: `PSUM_WIDTH] + wr_data; 
    end
end

generate
    genvar i;
    for(i=0; i<`LENROW; i=i+1) begin
        always @ ( posedge clk or negedge rst_n ) begin
            if ( !rst_n ) begin
                PSO_PSUM_ARRAY[i] <= 0;
            end else begin
                PSO_PSUM_ARRAY[i] <= PSUM_ARRAY[`PSUM_WIDTH*i +: `PSUM_WIDTH];
            end
        end
    end
endgenerate

assign dataout = PSUM_ARRAY;

    // Delay #(
    //     .NUM_STAGES(1),
    //     .DATA_WIDTH(1)
    //     )Delay_wire_PSUMARB_rdy(
    //     .CLK(clk),
    //     .RESET_N(rst_n),
    //     .DIN(wire_PSUMARB_rdy),
    //     .DOUT(PSUMARB_rdy)
    //     );
//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================

endmodule