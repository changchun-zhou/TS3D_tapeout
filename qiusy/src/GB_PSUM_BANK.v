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
module GB_PSUM_BANK #(
    parameter PSUM_WIDTH = 32,
    parameter ADDR_WIDTH = 8,
    parameter PSUMBUS_WIDTH = PSUM_WIDTH*16
  )(
    input                               clk,
    input                               rst_n,

    input                               PSum_start,
    input                               PSum_clear,
    output                              Psum_idles,

    input [6                      -1:0] CFGGB_num_frame,
    input [6                      -1:0] CFGGB_num_block,
                                  
    input [6                      -1:0] CCUGB_frame,
    input [6                      -1:0] CCUGB_block,

    // PEs read psum              
    input [3                      -1:0] PSumRdReady, // 3*32 = 96
    output[3                      -1:0] PSumRdValid,
    output[PSUMBUS_WIDTH          -1:0] PSumRdData , // send psum to PE Array

    // PEs write psum             
    output[3                      -1:0] PSumWrReady,
    input [3                      -1:0] PSumWrValid,
    input [PSUMBUS_WIDTH*3        -1:0] PSumWrData , // recieve psum from PE Array

    // POOL read psum
    input                               POOLGB_fnh,
    output[PSUM_WIDTH             -1:0] GBPOOL_data,
    input [ADDR_WIDTH             -1:0] POOLGB_addr,
    output                              GBPOOL_val,
    input                               POOLGB_req

  );
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================
localparam ADD_NUM      = 64;
localparam ADD_NUM_AW   = 6;
localparam RAM_NUM      = 4;
localparam RAM_NUM_AW   = 2;
localparam RAM_DEPTH    = RAM_NUM * ADD_NUM;
localparam RAM_DEPTH_AW = 8;//log2(RAM_DEPTH)
localparam RAM_WIDTH    = PSUM_WIDTH * 4;
localparam P16_WIDTH    = PSUMBUS_WIDTH;

localparam PSUM_STATE = 5;
localparam PSUM_IDLE  = 5'b00001;
localparam PSUM_ERAM  = 5'b00010;
localparam PSUM_POOL  = 5'b00100;
localparam PSUM_WEXT  = 5'b01000;
localparam PSUM_EXPO  = 5'b10000;

//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
wire [6            -1:0] cur_frame = CCUGB_frame;
wire [6            -1:0] cur_block = CCUGB_block;
wire [6            -1:0] num_frame = CFGGB_num_frame;
wire [6            -1:0] num_block = CFGGB_num_block;

wire is_last_block = cur_block == num_block;
wire is_pool_block = cur_block == num_block && |cur_frame;
wire is_num0_block = cur_block == 'd0 && cur_frame == 'd0;

reg  [PSUM_STATE   -1:0] psum_cs;
reg  [PSUM_STATE   -1:0] psum_ns;

wire is_idle = psum_cs == PSUM_IDLE;
wire is_rram = psum_cs == PSUM_ERAM;
wire is_wram = psum_cs == PSUM_ERAM;
wire is_pool = psum_cs == PSUM_POOL || psum_cs == PSUM_EXPO;
wire is_wext = psum_cs == PSUM_WEXT;
wire is_expo = psum_cs == PSUM_EXPO;
reg [3-1:0] wram_req;
reg [3-1:0] rram_req;

reg                      psum_ram_ren;
wire                     psum_ram_ren_d;
reg                      psum_ram_wen;
reg  [RAM_WIDTH    -1:0] psum_ram_din;
wire [RAM_WIDTH    -1:0] psum_ram_dout;
wire [RAM_WIDTH    -1:0] psum_ram_dsel;
reg  [RAM_DEPTH_AW -1:0] psum_ram_wadd;
reg  [RAM_DEPTH_AW -1:0] psum_ram_radd;

wire is_rdr3 = &psum_ram_radd[RAM_DEPTH_AW-1 -:2] && psum_ram_ren;
wire is_rdr3_d;

reg  [2            -1:0] psum_wram_sel;
reg  [2            -1:0] psum_rram_sel;

reg  [ADD_NUM_AW   -1:0] psum_ram_wcnt [3 -1:0];
reg  [ADD_NUM_AW   -1:0] psum_ram_rcnt [3 -1:0];
reg  [3            -1:0] psum_ram_wdone;
reg  [3            -1:0] psum_ram_rdone;
wire [2            -1:0] psum_ren_ptr;
wire [2            -1:0] psum_ren_ptr_d;

wire [RAM_WIDTH    -1:0] psum_ram_dout_d0 = is_num0_block || (psum_ren_ptr_d == 'd0 && cur_block == 'd0) || (is_rdr3_d && cur_frame == 'd0 && is_last_block) ? 'd0 : psum_ram_dout;
wire [RAM_WIDTH    -1:0] psum_ram_dout_d1,psum_ram_dout_d2,psum_ram_dout_d3,psum_ram_dout_r3;
wire [P16_WIDTH*3  -1:0] psum_ram_dout_s;

reg  [3            -1:0] psum_dout_en;
reg  [2            -1:0] psum_dout_cnt;
reg  [3            -1:0] psum_dout_vld;
reg  [3            -1:0] psum_rram_vld;
wire [2            -1:0] psum_dout_ptr;

wire [2            -1:0] psum_wen_ptr;
reg  [ADD_NUM_AW   -1:0] psum_rr3_cnt;
wire [ADD_NUM_AW   -1:0] psum_wr3_cnt;
wire [2            -1:0] psum_din_cnt = psum_ram_wcnt[psum_wen_ptr][0+:2];

wire [PSUMBUS_WIDTH-1:0] psum_data_add_wsel = PSumWrData[psum_wen_ptr*PSUMBUS_WIDTH +:PSUMBUS_WIDTH];
wire [RAM_WIDTH    -1:0] psum_data_sel = is_wext ? psum_ram_dout_d1 : PSumWrData[RAM_WIDTH*{psum_wen_ptr,psum_din_cnt} +:RAM_WIDTH];
reg  [PSUM_WIDTH   -1:0] psum_data_add_s [4-1:0];
wire [RAM_WIDTH    -1:0] psum_data_add = {psum_data_add_s[3],psum_data_add_s[2],psum_data_add_s[1],psum_data_add_s[0]};

wire wram_last = psum_ram_wen && &psum_ram_wadd[0 +:ADD_NUM_AW];
wire rram_last = psum_ram_ren && &psum_ram_radd[0 +:ADD_NUM_AW];
wire wext_done = wram_last;
assign Psum_idles = is_idle;

wire psum_ram_ren_sel = is_num0_block || (cur_block == 'd0 && psum_ren_ptr == 'd0) ? 'd0 : psum_ram_ren;
assign psum_ram_dsel = psum_ram_ren_d ? psum_ram_dout_d0 : psum_ram_dout_d1;
RAM_DELTA_wrap #( .SRAM_DEPTH_BIT( RAM_DEPTH_AW ), .SRAM_WIDTH( RAM_WIDTH ), .BYTES(4))PSUM_RAM_U ( clk, rst_n, psum_ram_radd, psum_ram_wadd, psum_ram_ren_sel, psum_ram_wen, psum_ram_din, psum_ram_dout);

//=====================================================================================================================
// Logic Design :
//=====================================================================================================================
genvar gen_i;
generate
  for( gen_i=0 ; gen_i < 3; gen_i = gen_i+1 ) begin : RAM_CNT_BLOCK
    always @ ( posedge clk or negedge rst_n )begin
      if( ~rst_n )
        psum_ram_wcnt[gen_i] <= 'd0;
      else if( PSum_clear )
        psum_ram_wcnt[gen_i] <= 'd0;
      else
        psum_ram_wcnt[gen_i] <= psum_ram_wcnt[gen_i] + ( gen_i == psum_wen_ptr && psum_ram_wen && is_wram);
    end

    always @ ( posedge clk or negedge rst_n )begin
      if( ~rst_n )
        psum_ram_rcnt[gen_i] <= 'd0;
      else if( PSum_clear )
        psum_ram_rcnt[gen_i] <= 'd0;
      else
        psum_ram_rcnt[gen_i] <= psum_ram_rcnt[gen_i] + ( gen_i == psum_ren_ptr && psum_ram_ren && is_rram && ~is_rdr3);
    end

    always @ ( * )begin
      wram_req[gen_i] = PSumWrValid[gen_i] && is_wram;
      rram_req[gen_i] = ~psum_ram_rdone[gen_i] && ~psum_rram_vld[gen_i] && is_rram;
    end
  end
endgenerate

generate
  for( gen_i=0 ; gen_i < 3; gen_i = gen_i+1 ) begin : FSM2_BLOCK          

    always @ ( posedge clk or negedge rst_n )begin
      if( ~rst_n )
        psum_ram_wdone[gen_i] <= 'd0;
      else if( is_idle )
        psum_ram_wdone[gen_i] <= 'd0;
      else if( gen_i == psum_wen_ptr && wram_last && is_wram)
        psum_ram_wdone[gen_i] <= 'd1;
    end
     
    always @ ( posedge clk or negedge rst_n )begin
      if( ~rst_n )
        psum_ram_rdone[gen_i] <= 'd0;
      else if( is_idle )
        psum_ram_rdone[gen_i] <= 'd0;
      else if( gen_i == psum_ren_ptr && rram_last && is_rram)
        psum_ram_rdone[gen_i] <= 'd1;
    end

  end      

endgenerate

wire [RAM_WIDTH    -1:0] psum_ram_dout_r3_sel = psum_ram_ren_d && is_rdr3_d ? psum_ram_dout_d0 : psum_ram_dout_r3;
generate
  for( gen_i=0 ; gen_i < 4; gen_i = gen_i+1 ) begin : DATA_ADD_BLOCK  
    always @ ( * )begin
      psum_data_add_s[gen_i] = $signed(psum_ram_dout_r3_sel[gen_i*PSUM_WIDTH +:PSUM_WIDTH]) + $signed(psum_data_sel[gen_i*PSUM_WIDTH +:PSUM_WIDTH]);
    end
  end
endgenerate

always @ ( * )begin
  case( psum_cs )
    PSUM_IDLE: psum_ns = PSum_start ? PSUM_ERAM : psum_cs;
    PSUM_ERAM: psum_ns = (&psum_ram_wdone && (&psum_ram_rdone && ~(|psum_dout_vld) && ~psum_ram_ren_d)) || PSum_clear ? ( is_pool_block ? PSUM_POOL : PSUM_IDLE) : psum_cs;
    PSUM_POOL: psum_ns = POOLGB_fnh ? (cur_frame == num_frame ? PSUM_WEXT : PSUM_IDLE) : psum_cs;
    PSUM_WEXT: psum_ns = wext_done ? PSUM_EXPO : psum_cs;
    PSUM_EXPO: psum_ns = POOLGB_fnh ? PSUM_IDLE : psum_cs;
    default  : psum_ns = PSUM_IDLE;
  endcase
end

always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    psum_cs <= PSUM_IDLE;
  else
    psum_cs <= psum_ns;
end

always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    psum_rr3_cnt <= 'd0;
  else if( PSum_clear )
    psum_rr3_cnt <= 'd0;     
  else if( &psum_ram_radd[RAM_DEPTH_AW-1 -:2] && psum_ram_ren && ~is_pool )
    psum_rr3_cnt <= psum_rr3_cnt + 'd1;
end

always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    psum_dout_cnt <= 'd0;
  else if( PSum_clear )
    psum_dout_cnt <= 'd0;     
  else if( psum_ram_ren_d && is_rram && ~is_rdr3_d )
    psum_dout_cnt <= psum_dout_cnt + 'd1;
end

integer i;
wire psum_dout_en_a = psum_ram_ren_d && &psum_dout_cnt && is_rram && ~is_rdr3_d;
always @ ( * )begin
  for( i=0; i < 3; i= i+1 )begin
    psum_dout_en[i] = psum_dout_en_a && i == psum_ren_ptr_d;
  end
end

always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    psum_dout_vld <= 'd0;
  else if( PSum_clear )
    psum_dout_vld <= 'd0;
  else begin
    for( i=0 ; i < 3; i = i+1 )begin
      if( ~psum_dout_vld[i] )
        psum_dout_vld[i] <= psum_dout_en[i];
      else
        psum_dout_vld[i] <= ~(PSumRdReady[i] && psum_dout_ptr == i);
    end
  end
end

always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    psum_rram_vld <= 'd0;
  else if( PSum_clear )
    psum_rram_vld <= 'd0;
  else begin
    for( i=0 ; i < 3; i = i+1 )begin
      if( ~psum_rram_vld[i] )
        psum_rram_vld[i] <= psum_ram_ren && &psum_ram_rcnt[i][0+:2] && i == psum_ren_ptr && is_rram && ~is_rdr3;
      else
        psum_rram_vld[i] <= ~(PSumRdReady[i] && psum_dout_ptr == i && psum_dout_vld[i]);
    end
  end
end

reg psum_rr1_vld;
always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    psum_rr1_vld <= 'd0;
  else if( is_wext )begin
    if( psum_ram_radd[RAM_DEPTH_AW-1 -:2] == 'd1 && psum_ram_ren )
      psum_rr1_vld <= 'd1;
    else if( psum_ram_wen )
      psum_rr1_vld <= 'd0;
  end
end

reg psum_rr3_vld;
always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    psum_rr3_vld <= 'd0;
  else if( is_last_block )begin
    if( &psum_ram_radd[RAM_DEPTH_AW-1 -:2] && psum_ram_ren )
      psum_rr3_vld <= 'd1;
    else if( (&psum_ram_wadd[RAM_DEPTH_AW-1 -:2] && psum_ram_wen) || GBPOOL_val )
      psum_rr3_vld <= 'd0;
  end
end

wire read_ram3 = psum_wen_ptr == 'd2 && is_last_block;
always @ ( * )begin
  psum_ram_din  = is_wext || read_ram3 ? psum_data_add : psum_data_sel;
  psum_ram_ren  = is_wext || read_ram3 ? ~psum_rr3_vld : (|rram_req  || (is_pool && POOLGB_req));
  psum_ram_wen  = (|wram_req || is_wext)  && ~psum_ram_ren;
  psum_ram_radd = is_wext ? {psum_rr1_vld,1'd1,psum_rr3_cnt} : read_ram3 ? {2'd3,psum_rr3_cnt} : (is_pool && POOLGB_req ? {2'd3,POOLGB_addr[2+:ADD_NUM_AW]} : {psum_rram_sel,psum_ram_rcnt[psum_ren_ptr]});
  psum_ram_wadd = is_wext ? {2'd3,psum_wr3_cnt} : {psum_wram_sel,psum_ram_wcnt[psum_wen_ptr]};
end

always@ ( * )begin
  psum_rram_sel = psum_ren_ptr == 'd0 ? 'd0 : ( psum_ren_ptr == 'd1 ? {1'd0,|cur_block} : {|cur_block,~|cur_block});
  psum_wram_sel = psum_wen_ptr == 'd2 && cur_block == num_block ? 'd3 : psum_wen_ptr;
end

//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================
assign PSumRdData = psum_ram_dout_s[psum_dout_ptr*P16_WIDTH +:P16_WIDTH];
assign PSumRdValid = psum_dout_ptr == 'd0 ? {2'd0,psum_dout_vld[0]} : (psum_dout_ptr == 'd1 ? {1'd0,psum_dout_vld[1],1'd0} : {psum_dout_vld[2],2'd0});//psum_dout_vld[psum_dout_ptr] << psum_dout_ptr;

assign PSumWrReady = {&psum_ram_wcnt[psum_wen_ptr][0 +:2] & psum_ram_wen} << psum_wen_ptr;
assign GBPOOL_data = psum_ram_dsel[POOLGB_addr[0+:2]*PSUM_WIDTH+:PSUM_WIDTH];
assign GBPOOL_val  = is_pool && psum_rr3_vld;

PSUM_REG_E #( RAM_WIDTH ) PSUM_DOR3_REG0 ( clk, rst_n, psum_ram_ren_d && is_rdr3_d, psum_ram_dout_d0 , psum_ram_dout_r3 );
PSUM_REG_E #( RAM_WIDTH ) PSUM_DOUT_REG0 ( clk, rst_n, psum_ram_ren_d, psum_ram_dout_d0 , psum_ram_dout_d1 );
PSUM_REG_E #( RAM_WIDTH ) PSUM_DOUT_REG1 ( clk, rst_n, psum_ram_ren_d, psum_ram_dout_d1 , psum_ram_dout_d2 );
PSUM_REG_E #( RAM_WIDTH ) PSUM_DOUT_REG2 ( clk, rst_n, psum_ram_ren_d, psum_ram_dout_d2 , psum_ram_dout_d3 );

PSUM_REG_E #( P16_WIDTH ) PSUM_DOUT_REG[3 -1:0]( clk, rst_n, psum_dout_en, {psum_ram_dout_d0,psum_ram_dout_d1,psum_ram_dout_d2,psum_ram_dout_d3} , psum_ram_dout_s );

PSUM_REG #( 1 ) PSUM_REN_REG ( clk, rst_n, psum_ram_ren , psum_ram_ren_d );
PSUM_REG #( 2 ) PSUM_PTR_REG ( clk, rst_n, psum_ren_ptr , psum_ren_ptr_d );
PSUM_REG #( 1 ) PSUM_RR3_REG ( clk, rst_n, is_rdr3      , is_rdr3_d );

wire psum_wr3_cnt_en = psum_ram_wen && is_wext;
PSUM_CNT #( ADD_NUM_AW ) PSUM_WRAM3_CNT ( clk, rst_n, psum_wr3_cnt_en, psum_wr3_cnt );

PSUM_ARB #(3,2) PSUM_WEN_PTR_ARB ( clk, rst_n, |PSumWrReady , wram_req, psum_wen_ptr );
PSUM_ARB #(3,2) PSUM_REN_PTR_ARB ( clk, rst_n, |psum_dout_en, rram_req, psum_ren_ptr );

wire psum_dout_ptr_en = |(PSumRdValid & PSumRdReady);
PSUM_ARB #(3,2) PSUM_OUT_PTR_ARB ( clk, rst_n, psum_dout_ptr_en, psum_dout_vld, psum_dout_ptr );

`ifdef ASSERT_ON
wire         [16 -1:0][32 -1:0] rd_data = PSumRdData;
wire [3 -1:0][16 -1:0][32 -1:0] wr_data = PSumWrData;
`endif
endmodule

module PSUM_REG_E #(
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

module PSUM_REG #(
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

module PSUM_CNT #(
    parameter DW = 8
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
      cnt_reg <= cnt_reg + 1'd1;
    else
      cnt_reg <= cnt_reg;
  end
endmodule

module PSUM_ARB #(
    parameter NUM = 3,
    parameter NAW = 2
) (
    input            Clk   ,
    input            Rstn  ,
    input            Enable,

    input  [NUM-1:0] Req,
    output [NAW-1:0] ArbId
);
  reg [NAW-1:0] arb_id;
  reg [NAW-1:0] id_map [NUM-1:0];

  genvar gen_i;
  generate     
    for( gen_i=0 ; gen_i < NUM; gen_i = gen_i+1 ) begin : MAP_BLOCK
      always @ ( posedge Clk or negedge Rstn )begin
        if( ~Rstn )
          id_map[gen_i] <= gen_i;
        else if( Enable )begin
          if( gen_i == NUM-1 )
            id_map[gen_i] <= id_map[0];
          else
            id_map[gen_i] <= id_map[gen_i+1];
        end
      end
    end
  endgenerate

  integer i;
  always @ ( * )begin
    arb_id = 0;
    for( i = NUM-1; i >= 0; i = i - 1 )begin
      if( Req[id_map[i]] )
        arb_id = id_map[i];
    end
  end
  assign ArbId = arb_id;

endmodule
