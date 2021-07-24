//======================================================
// Copyright (C) 2019 By zhoucc
// All Rights Reserved
//======================================================
// Module : ARB
// Author : CC zhou
// Contact : 
// Date : 6 .12.2020
//=======================================================
// Description :
//========================================================
`include "../source/include/dw_params_presim.vh"
module ARB (
    input                                       clk     ,
    input                                       rst_n   ,
    input                                       PEBARB_Sta,
    output                                      ARBPEB_Fnh, // finish a block's arb 

// Finish a row computation: + intra signal:corresponding Weight is first or second row
    input  [ `MAC_NUM                   -1 : 0] MAC_ReqHelp,
    input  [ `MAC_NUM/3                 -1 : 0] PSUMARB_rdy,

    output reg [ `MAC_NUM               -1 : 0] ARBMAC_Rst,
    output reg[ `C_LOG_2(`LENROW)*`MAC_NUM-1:0] ARBMAC_IDActRow,
    output reg[ `MAC_NUM_WIDTH*`MAC_NUM -1 : 0] ARBMAC_IDWei,// for Weight
    output reg[ 4*`MAC_NUM              -1 : 0] ARBMAC_IDPSUM,

    output reg[`MAC_NUM*9               -1 : 0] ARBPSUM_SwitchOnMAC// 2bit->2MAC compute or not
      
);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================





//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================

// i-th Weight Require being helped
wire [ `MAC_NUM          - 1 : 0] WEI_ReqHelped; 

wire [ `MAC_NUM_WIDTH       -1 : 0] IDWei_Helped;

wire                                Help_Other;
wire                                Help;
wire                                Help_Self;
wire [ `MAC_NUM             -1 : 0] MAC_Help_One;
wire [ `MAC_NUM             -1 : 0] MAC_ReqHelp_One;
wire [ `MAC_NUM             -1 : 0] Help_One_Self;
wire [ `MAC_NUM             -1 : 0] WEI_Helped_One;

wire [ `MAC_NUM/3           -1 : 0] rdy_psum_shift;

reg [ `C_LOG_2(`LENROW) -1:0] arbrow; // arb which actrow;

wire                                arb_en;
wire[ `MAC_NUM_WIDTH        -1 : 0] IDMAC_Help;

wire [`MAC_NUM*9               -1 : 0] PSUM_SwitchOffMAC;

wire [ 4                        -1 : 0] IDPSUM_Helped;
//=====================================================================================================================
// Logic Design :
//=====================================================================================================================
// **************************************************************************
localparam IDLE = 0;
localparam ARB = 1;
localparam COMP = 2;

reg [2 -1 : 0           ] state;
reg [2 -1 : 0           ] next_state;

always @(*) begin
  if(!rst_n) begin
    next_state <= IDLE;
  end else begin
    case (state)
        IDLE  : if ( PEBARB_Sta )
                    next_state <= ARB;
                else 
                    next_state <= IDLE;
        ARB:    if( arbrow == `LENROW)
                    next_state <= IDLE;
                else 
                    next_state <= ARB;

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

// **************************************************************************
// WEI_ReqHelped
// **************************************************************************
// Current row's weight whether need to be computed：0.need 1.not need
reg [ `MAC_NUM*`LENROW  -1 : 0] flagcompwei_currow; 
wire[ `MAC_NUM  -1 : 0] rdy_wei2psum;
wire[ `MAC_NUM  -1 : 0] rdy_wei2mux;
wire[ `MAC_NUM  -1 : 0] rdy_MUX_Helped;

// 1.flagcompwei_currow
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        arbrow <= 0; // 
    end else if ( next_state == IDLE ) begin
        arbrow <= 0;
    end else if ( &flagcompwei_currow[`MAC_NUM*arbrow +: `MAC_NUM] ) begin // ??? 
        arbrow <= arbrow + 1;
    end
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin // reset, which column need to be computed
        flagcompwei_currow <=
                           {{9'b000_111_111,9'b000_111_111,9'b000_111_111},
                            {9'b000_000_111,9'b000_000_111,9'b000_000_111},
                            {378'd0}, // 27*14
                            {9'b111_000_000,9'b111_000_000,9'b111_000_000},
                            {9'b111_111_000,9'b111_111_000,9'b111_111_000}}; 
    end else if ( next_state == IDLE ) begin // every block reset
        flagcompwei_currow <=
                           {{9'b000_111_111,9'b000_111_111,9'b000_111_111},
                            {9'b000_000_111,9'b000_000_111,9'b000_000_111},
                            {378'd0}, // 27*14
                            {9'b111_000_000,9'b111_000_000,9'b111_000_000},
                            {9'b111_111_000,9'b111_111_000,9'b111_111_000}}; 
    end else if ( arb_en ) begin // arb a weight -> 1;
        flagcompwei_currow[`MAC_NUM*arbrow+IDWei_Helped] <= 1;
    end
end

assign arb_en = Help && state == ARB;
assign ARBPEB_Fnh = state == IDLE; //
// 2.rdy_wei2psum
// resort according to weights;
reg [ 2    -1 : 0] remainder_row; // arbrow % 3;

integer for_i;
always @(*) begin
 remainder_row =  ( arbrow == 0  )? 0  : 
                        ( arbrow == 1  )? 1  :
                        ( arbrow == 2  )? 2  : 
                        ( arbrow == 3  )? 0  :
                        ( arbrow == 4  )? 1  :
                        ( arbrow == 5  )? 2  : 
                        ( arbrow == 6  )? 0  :
                        ( arbrow == 7  )? 1  :
                        ( arbrow == 8  )? 2  : 
                        ( arbrow == 9  )? 0  :
                        ( arbrow == 10 )? 1  :
                        ( arbrow == 11 )? 2  : 
                        ( arbrow == 12 )? 0  :
                        ( arbrow == 13 )? 1  :
                        ( arbrow == 14 )? 2  : 
                        ( arbrow == 15 )? 0  : 0;
end
// always(*)begin
//     if(arbrow < 3)
//         remainder_row = arbrow;
//     else if (arbrow < 6)
//         remainder_row = arbrow -6;
// end
generate
    genvar pec;
    for(pec=0;pec<3;pec=pec+1) begin // transform PSUM to weight to get which weight 's psum is ready
        assign rdy_psum_shift[3*pec +: 3] = // shift weight_row by act_row
                        remainder_row == 0 ? { PSUMARB_rdy[3*pec + 1], PSUMARB_rdy[3*pec + 2], PSUMARB_rdy[3*pec + 0] } : // {2,1,0} = { 1,2,0}
                        remainder_row == 1 ? { PSUMARB_rdy[3*pec + 2], PSUMARB_rdy[3*pec + 0], PSUMARB_rdy[3*pec + 1] } :// 
                        remainder_row == 2 ? { PSUMARB_rdy[3*pec + 0], PSUMARB_rdy[3*pec + 1], PSUMARB_rdy[3*pec + 2] } :// 
                        0;
    end
endgenerate


generate
    genvar i;
    for(i=0;i<`MAC_NUM; i=i+1) begin: MAC_REQHELP 
        assign rdy_wei2psum[i] = rdy_psum_shift[i/3]; // from 9 to 27
    end
endgenerate


// 4.WEI_ReqHelped
assign WEI_ReqHelped = ~flagcompwei_currow[`MAC_NUM*arbrow +: `MAC_NUM] & rdy_wei2psum;

// **************************************************************************

// **************************************************************************
// Arb Process
// **************************************************************************

// Most of time is Help Self;
assign Help = (|MAC_ReqHelp) && (|WEI_ReqHelped);

ARRAY2ID ARRAY2ID_IDWei_Helped ( // Help other
    .Array(WEI_ReqHelped),
    .ID(IDWei_Helped),
    .Array_One(WEI_Helped_One)
    );

ARRAY2ID ARRAY2ID_IDMAC_Help ( // Help other
    .Array(MAC_ReqHelp),
    .ID(IDMAC_Help),
    .Array_One(MAC_Help_One)
    );
// **************************************************************************

// **************************************************************************
// Arb result out
// **************************************************************************

// 1. to MAC
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        ARBMAC_Rst <= 0;
        ARBMAC_IDWei <= 0;
        ARBMAC_IDPSUM <= 0;
        ARBMAC_IDActRow <= 0;
    end else if( arb_en ) begin // Need to help each other
        ARBMAC_Rst <= MAC_Help_One ;//by bit or, then ~ & other
        ARBMAC_IDWei[`MAC_NUM_WIDTH*IDMAC_Help +: `MAC_NUM_WIDTH] <= IDWei_Helped;// i-th Weight
        ARBMAC_IDPSUM[`MAC_NUM_WIDTH*IDMAC_Help +: `MAC_NUM_WIDTH] <= IDPSUM_Helped;//which MAC will help
        ARBMAC_IDActRow[`C_LOG_2(`LENROW)*IDMAC_Help +: `C_LOG_2(`LENROW)] <= arbrow;
    end else begin 
        ARBMAC_Rst <= 0; // arb at most one
    end
end

wire [ 4                        -1 : 0] Remainder_IDWei_Helped;
wire [ 4                        -1 : 0] Quotient_IDWei_Helped;
// 2. to CHN from IDWei_Helped to CHN's switch, to get weight's rdy
wire [ 4*9                      -1 : 0] Base_wei2psum;
wire [ 4*9                      -1 : 0] IDARRAY_Wei2PSUM;
assign Base_wei2psum = { 4'd1, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd0, 4'd0, 4'd0}; //A_row0 => w_row1 w_row2 w_row0

assign IDARRAY_Wei2PSUM = 
                        remainder_row == 0 ?  Base_wei2psum : // Shifted by A_row
                        remainder_row == 1 ? {Base_wei2psum[4*0 +: 4*6], Base_wei2psum[4*6 +: 4*3]} : 
                        remainder_row == 2 ? {Base_wei2psum[4*0 +: 4*3], Base_wei2psum[4*3 +: 4*6]} : 0;

QR_27DIV9 QR_27DIV9( // /3
    .datain(IDWei_Helped),
    .Quotient(Quotient_IDWei_Helped), // i-th PEC in a PEB
    .Remainder(Remainder_IDWei_Helped) // i-th PSUM Row in a PEC
    );

assign IDPSUM_Helped = IDARRAY_Wei2PSUM[4*Remainder_IDWei_Helped +: 4] + Quotient_IDWei_Helped*3;

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        ARBPSUM_SwitchOnMAC <= 0;
    end else if ( PEBARB_Sta ) begin 
        ARBPSUM_SwitchOnMAC <= 0;
    end else begin
    // arb_en: Open; PSUM_SwitchOffMAC: MAC_fnh -> close
        ARBPSUM_SwitchOnMAC <= ( arb_en ? 1 << (`MAC_NUM*IDPSUM_Helped + IDMAC_Help) : 0) | ( ARBPSUM_SwitchOnMAC & ~PSUM_SwitchOffMAC );// Switch
    end
end

// from MAC finish to chn Switch Off/empty
generate
    genvar psum;
    for(psum=0;psum<9;psum=psum+1) begin
        assign PSUM_SwitchOffMAC[`MAC_NUM*psum +: `MAC_NUM] = MAC_ReqHelp; //
    end
endgenerate

//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================

endmodule

module ARRAY2ID #(
    parameter ARRAY_WIDTH = `MAC_NUM
    )(
    input [ ARRAY_WIDTH                -1 : 0] Array,
    output reg[ `C_LOG_2(ARRAY_WIDTH)      -1 : 0] ID,
    output reg[ ARRAY_WIDTH                -1 : 0] Array_One 
    );

integer i;
reg fnh;
always @ ( Array) begin
    fnh = 0;
    Array_One = 0;
    ID = 0;
    for(i=0;i<ARRAY_WIDTH; i=i+1)begin
        if(Array[i] && !fnh) begin
            ID  = i;
            fnh = 1;
            Array_One[i] = 1; 
        end
    end
end

endmodule


module QR_27DIV9 (
    input   [ 5  -1 : 0] datain,
    output reg  [ 4  -1 : 0] Quotient,
    output reg [ 4  -1 : 0] Remainder);
always @(*) begin
    if ( datain < 5'd9) begin
        Quotient = 4'd0;
        Remainder = datain;
    end else if (datain < 5'd18) begin
        Quotient = 4'd1;
        Remainder = datain - 5'd9;
    end else if (datain < 5'd27) begin
        Quotient = 4'd2;
        Remainder = datain - 5'd18;
    end else begin
        Quotient = 4'd3; // 11 error
        Remainder = 4'd31;   
    end
end

endmodule