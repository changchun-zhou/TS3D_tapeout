//======================================================
// Copyright (C) 2020 By 
// All Rights Reserved
//======================================================
// Module : 
// Author : 
// Contact : 
// Date : 
//=======================================================
// Description :
//========================================================
module GB_PSUM #(
    parameter NUM_PEB = 16,
    parameter PSUM_WIDTH = 32,
    parameter ADDR_WIDTH = 8,
    parameter PSUMBUS_WIDTH = PSUM_WIDTH*16
  )(
    input                               clk,
    input                               rst_n,
    output[128*NUM_PEB+24         -1:0] GBPSUM_debug,

    output                              GBCFG_rdy, // level
    input                               CFGGB_val, // level
    input [6                    -1 : 0] CFGGB_num_frame,
    input [6                    -1 : 0] CFGGB_num_block,

    input                               CCUGB_reset_patch,
    input [6                    -1 : 0] CCUGB_frame,
    input [6                    -1 : 0] CCUGB_block,

    // PEs read psum
    input [3*NUM_PEB            -1 : 0] PSUMGB_rdy, // 3*16 = 48
    output[3*NUM_PEB            -1 : 0] GBPSUM_val,
    output[PSUMBUS_WIDTH        -1 : 0] GBPSUM_data, // send psum to PE Array

    // PEs write psum
    output[3*NUM_PEB            -1 : 0] GBPSUM_rdy,
    input [3*NUM_PEB            -1 : 0] PSUMGB_val,
    input [PSUMBUS_WIDTH*3*NUM_PEB-1:0] PSUMGB_data, // recieve psum from PE Array


    // POOL read psum
    input                               POOLGB_fnh,
    output[PSUM_WIDTH*NUM_PEB   -1 : 0] GBPOOL_data,
    input [ADDR_WIDTH           -1 : 0] POOLGB_addr,
    output                              GBPOOL_val,
    input                               POOLGB_rdy

  );

localparam PS16_WIDTH = PSUMBUS_WIDTH;
localparam NUM_PES = NUM_PEB * 3;
localparam  AW_PES = 6;

wire [6 -1:0] cur_frame_d1,cur_frame_d2,cur_frame_d3;
wire [6 -1:0] cur_block_d1,cur_block_d2,cur_block_d3;
wire [6 -1:0] num_frame;
wire [6 -1:0] num_block;

wire PSum_reset = CCUGB_reset_patch;
wire PSum_start = /*CCUGB_reset_patch ||*/ (cur_frame_d3 != cur_frame_d2) || (cur_block_d3 != cur_block_d2) || (CFGGB_val && GBCFG_rdy);
wire PSum_clear = (cur_frame_d1 != CCUGB_frame) || (cur_block_d1 != CCUGB_block);
wire [NUM_PEB-1:0] Psum_idles;
wire psum_idle = &Psum_idles;
wire psum_done = (cur_frame_d2 == num_frame) && (cur_frame_d3 == num_frame) && (cur_block_d2 == num_block) && (cur_block_d3 == num_block) && psum_idle;

reg  [NUM_PEB-1:0] pool_data_vld;
wire [NUM_PEB-1:0] gb_pool_req = ~pool_data_vld & {NUM_PEB{POOLGB_rdy}};
wire gb_pool_fnh = POOLGB_fnh;
wire [PSUM_WIDTH*NUM_PEB   -1:0] gb_pool_dat,gb_pool_dat_d;
wire [NUM_PEB              -1:0] gb_pool_vld;
wire [ADDR_WIDTH           -1:0] gb_pool_add = POOLGB_addr;

wire [AW_PES -1:0] rd_cur_ptr;
wire [AW_PES -1:0] rd_arb_ptr;

reg  [3*NUM_PEB            -1:0] rd_psum_req;
wire [64                   -1:0] rd_psum_req_sft = {16'd0,rd_psum_req,16'd0,rd_psum_req} >> rd_cur_ptr;
wire [64                   -1:0] rd_psum_msk = 1'd1 << rd_arb_ptr;
wire [3*NUM_PEB            -1:0] rd_psum_rdy = PSUMGB_rdy & rd_psum_msk[0 +:3*NUM_PEB];
wire [3*NUM_PEB            -1:0] rd_psum_vld;
wire [PS16_WIDTH*3*NUM_PEB -1:0] rd_psum_dat;

wire [3*NUM_PEB            -1:0] wr_psum_rdy;
wire [3*NUM_PEB            -1:0] wr_psum_vld = PSUMGB_val;
wire [PS16_WIDTH*3*NUM_PEB -1:0] wr_psum_dat = PSUMGB_data;

integer i;
always @ ( * )begin
  for( i = 0; i < 3*NUM_PEB; i = i + 1 )begin
    rd_psum_req[i] = PSUMGB_rdy[i];
  end
end

reg  [AW_PES -1:0] rd_arb_ptr_sft;
always @ ( * )begin
  rd_arb_ptr_sft = 'd0;
  for( i = 64-1; i >= 0; i = i - 1 )begin
    if( rd_psum_req_sft[i] )
    	rd_arb_ptr_sft = i;
  end
end
assign rd_arb_ptr = rd_arb_ptr_sft + rd_cur_ptr;

always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    pool_data_vld <= 'd0;
  else if( &pool_data_vld && POOLGB_rdy )
    pool_data_vld <= 'd0;
  else begin
    for( i=0; i < NUM_PEB; i= i+1 )begin
      if( ~pool_data_vld[i] )
        pool_data_vld[i] <= gb_pool_vld[i];
    end
  end
end

assign GBPOOL_val  = &pool_data_vld;
assign GBPOOL_data = gb_pool_dat_d;
assign GBPSUM_val  = rd_psum_vld & rd_psum_msk;
assign GBPSUM_data = rd_psum_dat[rd_arb_ptr*PS16_WIDTH +:PS16_WIDTH];
assign GBPSUM_rdy  = wr_psum_rdy;
assign GBCFG_rdy   = psum_idle;

GBPSUM_REG_C  #( 6 ) CUR_FRAME_REG0 ( clk, rst_n, psum_done, CCUGB_frame , cur_frame_d1 );
GBPSUM_REG_C  #( 6 ) CUR_BLOCK_REG0 ( clk, rst_n, psum_done, CCUGB_block , cur_block_d1 );
GBPSUM_REG_CE #( 6 ) CUR_FRAME_REG1 ( clk, rst_n, psum_done, psum_idle, cur_frame_d1, cur_frame_d2 );
GBPSUM_REG_CE #( 6 ) CUR_BLOCK_REG1 ( clk, rst_n, psum_done, psum_idle, cur_block_d1, cur_block_d2 );
GBPSUM_REG_C  #( 6 ) CUR_FRAME_REG2 ( clk, rst_n, psum_done, cur_frame_d2, cur_frame_d3 );
GBPSUM_REG_C  #( 6 ) CUR_BLOCK_REG2 ( clk, rst_n, psum_done, cur_block_d2, cur_block_d3 );

wire cfg_en = CFGGB_val && GBCFG_rdy;
GBPSUM_REG_E #( 6 ) NUM_FRAME_REG ( clk, rst_n, cfg_en, CFGGB_num_frame , num_frame );
GBPSUM_REG_E #( 6 ) NUM_BLOCK_REG ( clk, rst_n, cfg_en, CFGGB_num_block , num_block );

GBPSUM_REG_E #( PSUM_WIDTH ) POOL_DATA_REG[NUM_PEB-1:0] ( clk, rst_n, ~pool_data_vld & gb_pool_vld, gb_pool_dat , gb_pool_dat_d );

wire rd_cur_ptr_cnt_en = |(rd_psum_vld & rd_psum_rdy);
GBPSUM_CNT #( AW_PES, NUM_PES ) RD_CUR_PTR_CNT ( clk, rst_n, rd_cur_ptr_cnt_en, rd_cur_ptr );

//for debug
wire [128*NUM_PEB -1:0] BankDebug;
wire [24          -1:0] PsumDebug;

assign PsumDebug = {pool_data_vld,
                    rd_cur_ptr,rd_arb_ptr};

assign GBPSUM_debug = {PsumDebug,BankDebug};

  GB_PSUM_BANK #(
    .PSUM_WIDTH      ( PSUM_WIDTH     ),
    .ADDR_WIDTH      ( ADDR_WIDTH     ),
    .PSUMBUS_WIDTH   ( PSUMBUS_WIDTH  )
  ) GB_PSUM_BANK_U[NUM_PEB-1:0] (

    .clk             ( clk            ),
    .rst_n           ( rst_n          ),
    .BankDebug       ( BankDebug      ),

    .PSum_reset      ( PSum_reset     ),
    .PSum_start      ( PSum_start     ),
    .PSum_clear      ( PSum_clear     ),
    .Psum_idles      ( Psum_idles     ),

    .CFGGB_num_frame ( num_frame      ),
    .CFGGB_num_block ( num_block      ),
    .CCUGB_frame     ( cur_frame_d2   ),
    .CCUGB_block     ( cur_block_d2   ),

    .PSumRdReady     ( rd_psum_rdy    ),
    .PSumRdValid     ( rd_psum_vld    ),
    .PSumRdData      ( rd_psum_dat    ),

    .PSumWrReady     ( wr_psum_rdy    ),
    .PSumWrValid     ( wr_psum_vld    ),
    .PSumWrData      ( wr_psum_dat    ),

    .POOLGB_fnh      ( gb_pool_fnh    ),
    .GBPOOL_data     ( gb_pool_dat    ),
    .POOLGB_addr     ( gb_pool_add    ),
    .GBPOOL_val      ( gb_pool_vld    ),
    .POOLGB_req      ( gb_pool_req    )
  );

endmodule

module GBPSUM_REG_E #(
    parameter DW = 8
) (
    input            Clk   ,
    input            Rstn  ,
    input            Enable,

    input  [DW -1:0] DataIn,
    output [DW -1:0] DataOut
);
  reg [DW -1:0] data_out;
  assign DataOut = data_out;
  always @ ( posedge Clk or negedge Rstn )begin
    if( ~Rstn )
      data_out <= 'd0;
    else if( Enable )
      data_out <= DataIn;
  end
endmodule

module GBPSUM_REG #(
    parameter DW = 8
) (
    input            Clk   ,
    input            Rstn  ,

    input  [DW -1:0] DataIn,
    output [DW -1:0] DataOut
);
  reg [DW -1:0] data_out;
  assign DataOut = data_out;
  always @ ( posedge Clk or negedge Rstn )begin
    if( ~Rstn )
      data_out <= 'd0;
    else
      data_out <= DataIn;
  end
endmodule

module GBPSUM_REG_CE #(
    parameter DW = 8
) (
    input            Clk   ,
    input            Rstn  ,
    input            Clear ,
    input            Enable,

    input  [DW -1:0] DataIn,
    output [DW -1:0] DataOut
);
  reg [DW -1:0] data_out;
  assign DataOut = data_out;
  always @ ( posedge Clk or negedge Rstn )begin
    if( ~Rstn )
      data_out <= 'd0;
    else if( Clear )
      data_out <= 'd0;
    else if( Enable )
      data_out <= DataIn;
  end
endmodule

module GBPSUM_REG_C #(
    parameter DW = 8
) (
    input            Clk   ,
    input            Rstn  ,
    input            Clear ,

    input  [DW -1:0] DataIn,
    output [DW -1:0] DataOut
);
  reg [DW -1:0] data_out;
  assign DataOut = data_out;
  always @ ( posedge Clk or negedge Rstn )begin
    if( ~Rstn )
      data_out <= 'd0;
    else if( Clear )
      data_out <= 'd0;
    else
      data_out <= DataIn;
  end
endmodule

module GBPSUM_CNT #(
    parameter DW  =  6,
    parameter MAX = 48
) (
    input            Clk   ,
    input            Rstn  ,
    input            Enable,

    output [DW -1:0] Cnt
);
  reg [DW -1:0] cnt_reg;
  assign Cnt = cnt_reg;
  always @ ( posedge Clk or negedge Rstn )begin
    if( ~Rstn )
      cnt_reg <= 'd0;
    else if( Enable )
      if( cnt_reg >= (MAX-1) )
      	cnt_reg <= 'd0;
      else
      	cnt_reg <= cnt_reg + 1'd1;
  end
endmodule
