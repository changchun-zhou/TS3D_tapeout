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
module POOL_OUT #(
    parameter PORT_WIDTH = 128,
    parameter DATA_WIDTH = 8,
    parameter FLAG_WIDTH = 32,
    parameter ADDR_WIDTH = 8
) (
    input                       clk,
    input                       rst_n,

    input                       layer_fnh, // paulse
    output                      clear_up, // paulse

    output                      BF_rdy,
    input                       BF_val,
    input [ADDR_WIDTH   -1 : 0] BF_addr,
    input [DATA_WIDTH   -1 : 0] BF_data,// bandwidth 8b/cycle

    output                      BF_flg_rdy,
    input                       BF_flg_val,
    input [FLAG_WIDTH   -1 : 0] BF_flg_data,

    input                       IFPOOL_rdy,
    output                      POOLIF_val,
    output[PORT_WIDTH   -1 : 0] POOLIF_data,

    input                       IFPOOL_flg_rdy,
    output                      POOLIF_flg_val,
    output[PORT_WIDTH   -1 : 0] POOLIF_flg_data
   
);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================
localparam RAM_NUM    = 16;
localparam RAM_NUM_AW = 4;
localparam BADD_WIDTH = 6;
localparam ADD_NUM = 2 ** ADDR_WIDTH;

localparam BLK_STATE = 3;
localparam BLK_DIN   = 3'b000;
localparam BLK_OUT   = 3'b010;
localparam BLK_CLR   = 3'b100;

reg [BLK_STATE -1:0] blk_cs,flg_cs;
reg [BLK_STATE -1:0] blk_ns,flg_ns;

wire blk_din_done, flg_din_done;
wire blk_out_done, flg_out_done;
wire blk_clr_done, flg_clr_done;

wire [ADDR_WIDTH -1:0] bf_ram_ain_d;
wire [ADDR_WIDTH -1:0] bf_ram_ain = BF_addr;
wire [DATA_WIDTH -1:0] bf_ram_din = BF_data;

reg  [RAM_NUM_AW   :0] bf_last_num;
wire bf_ram_ren_d;
wire bf_ram_inv_d;
reg  [RAM_NUM    -1:0] bf_ram_ren;
reg  [RAM_NUM    -1:0] bf_ram_wen;
reg  [ADD_NUM    -1:0] bf_ram_inv;
reg  [RAM_NUM_AW -1:0] bf_ram_ptr_f,bf_ram_ptr_i;
wire [RAM_NUM_AW -1:0] bf_ram_ptr_d,bf_ram_ptr;
reg  [RAM_NUM    -1:0] bf_ram_vld [ADD_NUM -1:0];
reg  [RAM_NUM * ADD_NUM -1:0] bf_ram_vld_s;
wire bf_ram_rany = |bf_ram_ren;
wire bf_ram_wany_d;

reg  [ADDR_WIDTH -1:0] bf_ram_radd;
reg  [ADDR_WIDTH -1:0] bf_ram_wadd;
wire [DATA_WIDTH -1:0] bf_ram_dout [RAM_NUM -1:0];
reg  [PORT_WIDTH -1:0] bf_ram_dout_sel;

wire [RAM_NUM    -1:0 ]bf_blk_vld;
wire [ADDR_WIDTH -1:0] bf_blk_ain;
wire [PORT_WIDTH -1:0] bf_blk_din,bf_flg_din;
wire                   bf_blk_ren,bf_blk_ren_d;
wire                   bf_flg_ren,bf_flg_ren_d;
wire                   bf_blk_wen;
wire                   bf_flg_wen;
reg  [BADD_WIDTH   :0] bf_blk_cnt,bf_flg_cnt;

wire [2					 -1:0] bf_flg_vld_cnt;
wire [FLAG_WIDTH -1:0] bf_flg_data_d0 = flg_cs == BLK_CLR ? 'd0 : BF_flg_data;
wire [FLAG_WIDTH -1:0] bf_flg_data_d1;
wire [FLAG_WIDTH -1:0] bf_flg_data_d2;
wire [FLAG_WIDTH -1:0] bf_flg_data_d3;
wire bf_flg_val_d1,bf_flg_val_d2,bf_flg_val_d3;

wire                   bf_blk_rdy_full;
wire                   bf_blk_full, bf_flg_full;
wire [BADD_WIDTH -1:0] bf_blk_radd, bf_flg_radd;
wire [BADD_WIDTH -1:0] bf_blk_wadd, bf_flg_wadd;
wire [PORT_WIDTH -1:0] bf_blk_dout, bf_flg_dout;
wire [ADDR_WIDTH -1:0] bf_clr_dcnt;

RAM_DELTA_wrap #( .SRAM_DEPTH_BIT( ADDR_WIDTH ), .SRAM_WIDTH( DATA_WIDTH ))RAM_DATA_U[RAM_NUM-1:0]( clk, rst_n, bf_ram_radd, bf_ram_wadd, bf_ram_ren, bf_ram_wen, bf_ram_din, bf_ram_dout);
RAM_DELTA_wrap #( .SRAM_DEPTH_BIT( BADD_WIDTH ), .SRAM_WIDTH( PORT_WIDTH ))BLK_DATA_U             ( clk, rst_n, bf_blk_radd, bf_blk_wadd, bf_blk_ren, bf_blk_wen, bf_blk_din, bf_blk_dout);
RAM_DELTA_wrap #( .SRAM_DEPTH_BIT( BADD_WIDTH ), .SRAM_WIDTH( PORT_WIDTH ))BLK_FLAG_U             ( clk, rst_n, bf_flg_radd, bf_flg_wadd, bf_flg_ren, bf_flg_wen, bf_flg_din, bf_flg_dout);

//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
genvar gen_i;
generate for( gen_i=0 ; gen_i < ADD_NUM; gen_i = gen_i+1 ) begin : RAM_VLD_BLOCK
  always @ ( posedge clk or negedge rst_n )begin
    if( ~rst_n )
      bf_ram_vld[gen_i] <= 'd0;
    else if(  bf_ram_radd == gen_i && ~bf_blk_rdy_full && ((bf_last_num == 'd14 && bf_ram_wany_d) || blk_cs == BLK_CLR) && bf_ram_radd == bf_ram_ain)
      bf_ram_vld[gen_i] <= bf_ram_wen;
    else if(  bf_ram_radd == gen_i && ~bf_blk_rdy_full && ((bf_last_num == 'd14 && bf_ram_wany_d) || blk_cs == BLK_CLR) )
      bf_ram_vld[gen_i] <= 'd0;
    else if(  bf_ram_ain == gen_i )
      bf_ram_vld[gen_i] <= bf_ram_vld[gen_i] | bf_ram_wen;
  end
end
endgenerate

integer i;
always @ ( * ) begin
  for( i=0; i < ADD_NUM; i= i+1 )begin
    bf_ram_vld_s[RAM_NUM*i +:RAM_NUM] = bf_ram_vld[i];
  end
end

always @ ( * ) begin
    bf_ram_dout_sel[0 +:DATA_WIDTH] <= bf_blk_ain;
    for( i=1; i < RAM_NUM; i= i+1 )begin
      bf_ram_dout_sel[i*DATA_WIDTH +:DATA_WIDTH] <= bf_ram_inv_d ? bf_ram_dout[RAM_NUM-i] & {DATA_WIDTH{bf_blk_vld[RAM_NUM-i]}}:
                                                                   bf_ram_dout[      i-1] & {DATA_WIDTH{bf_blk_vld[      i-1]}};
    end
end

wire bf_ram_rinv = bf_ram_inv[bf_ram_radd];
always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    bf_ram_inv <= 'd0;
  else begin
    for( i=0 ; i < ADD_NUM; i = i+1 )begin
      if( i == bf_ram_radd )
        bf_ram_inv[i] <= bf_ram_inv[i] ^ bf_ram_rany;
      else
        bf_ram_inv[i] <= bf_ram_inv[i];
    end
  end
end

wire [RAM_NUM -1:0] bf_last_vld;
wire [RAM_NUM -1:0] bf_cur_vld = bf_ram_vld[bf_ram_ain];
always @ ( * ) begin
  bf_ram_ptr_f = 'd0;
  for( i = RAM_NUM-1; i >= 0; i = i - 1 )begin
    if( ~bf_cur_vld[i] )
      bf_ram_ptr_f = i;
  end
end
always @ ( * ) begin
  bf_ram_ptr_i = 'd0;
  for( i = 0; i < RAM_NUM; i = i + 1 )begin
    if( ~bf_cur_vld[i] )
      bf_ram_ptr_i = i;
  end
end
assign bf_ram_ptr = bf_ram_inv[bf_ram_ain] ? bf_ram_ptr_i : bf_ram_ptr_f;

always @ ( * ) begin
  bf_last_num = 'd0;
  for( i = RAM_NUM-1; i >= 0; i = i - 1 )begin
    bf_last_num = bf_last_num + bf_last_vld[i];
  end
end

wire [RAM_NUM -1:0] bf_ramr_vld = blk_cs == BLK_CLR ? bf_ram_vld[bf_clr_dcnt] : bf_last_vld;
wire bf_ram_wany = ~(&bf_cur_vld) && BF_val && ~bf_blk_rdy_full;
always @ ( * ) begin
  bf_ram_radd = blk_cs == BLK_CLR ? bf_clr_dcnt : bf_ram_ain_d;
  bf_ram_wadd = bf_ram_ain;
  bf_ram_wen = {{(RAM_NUM-1){1'd0}},bf_ram_wany} << bf_ram_ptr;
  bf_ram_ren = blk_cs == BLK_CLR ? (~bf_blk_rdy_full ? bf_ram_vld[bf_clr_dcnt] : 'd0) :
               (bf_last_num == 'd14) && bf_ram_wany_d && ~bf_blk_rdy_full ? (bf_ram_rinv ? 16'hFFFE : 16'h7FFF) : 'd0;//({{(RAM_NUM-1){1'd0}},~bf_blk_rdy_full && bf_ram_wany_d} << bf_ram_ptr_d) | bf_last_vld
end

reg layer_fnh_blk;
always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    layer_fnh_blk <= 'd0;
  else if( blk_clr_done && blk_cs == BLK_CLR )
    layer_fnh_blk <= 'd0;
  else if( ~layer_fnh_blk )
    layer_fnh_blk <= layer_fnh;
end

reg layer_fnh_flg;
always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    layer_fnh_flg <= 'd0;
  else if( flg_clr_done && flg_cs == BLK_CLR )
    layer_fnh_flg <= 'd0;
  else if( ~layer_fnh_flg )
    layer_fnh_flg <= layer_fnh;
end

always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    bf_blk_cnt <= 'd0;
  else
    bf_blk_cnt <= bf_blk_cnt + bf_blk_wen - (bf_blk_ren && |bf_blk_cnt);
end

always @ ( posedge clk or negedge rst_n )begin
  if( ~rst_n )
    bf_flg_cnt <= 'd0;
  else
    bf_flg_cnt <= bf_flg_cnt + bf_flg_wen - (bf_flg_ren && |bf_flg_cnt);
end

always @ ( * )begin
    case( blk_cs )
        BLK_DIN: blk_ns = blk_din_done ? BLK_OUT : (layer_fnh_blk && (bf_last_num < 'd14 || (bf_last_num == 'd14 && ~bf_ram_wany_d)) ? BLK_CLR : blk_cs);
        BLK_OUT: blk_ns = blk_out_done ? BLK_DIN : blk_cs;
        BLK_CLR: blk_ns = clear_up     ? BLK_DIN : blk_cs;
        default: blk_ns = BLK_DIN;
    endcase
end

always @ ( posedge clk or negedge rst_n )begin
    if( ~rst_n )
        blk_cs <= BLK_DIN;
    else
        blk_cs <= blk_ns;
end

always @ ( * )begin
    case( flg_cs )
        BLK_DIN: flg_ns = flg_din_done ? BLK_OUT : (layer_fnh_flg ? BLK_CLR : flg_cs);
        BLK_OUT: flg_ns = flg_out_done ? BLK_DIN : flg_cs;
        BLK_CLR: flg_ns = clear_up     ? BLK_DIN : flg_cs;
        default: flg_ns = BLK_DIN;
    endcase
end

always @ ( posedge clk or negedge rst_n )begin
    if( ~rst_n )
        flg_cs <= BLK_DIN;
    else
        flg_cs <= flg_ns;
end

wire clr_done = flg_clr_done & blk_clr_done && blk_cs == BLK_CLR && flg_cs == BLK_CLR;
wire clr_done_d,clr_done_d1;
//=====================================================================================================================
// Logic Design :
//=====================================================================================================================
assign clear_up = clr_done_d && ~clr_done_d1;
assign POOLIF_flg_data = bf_flg_dout;
assign POOLIF_flg_val = bf_flg_ren_d;
assign bf_flg_ren = IFPOOL_flg_rdy && |bf_flg_cnt && (flg_cs == BLK_OUT || flg_cs == BLK_CLR);

assign bf_flg_din = {bf_flg_data_d0,bf_flg_data_d1,bf_flg_data_d2,bf_flg_data_d3};
assign bf_flg_wen = &bf_flg_vld_cnt && (BF_flg_val || flg_cs == BLK_CLR) && ~bf_flg_full;
assign BF_flg_rdy =~bf_flg_full;

assign POOLIF_data = bf_blk_dout;
assign POOLIF_val  = bf_blk_ren_d;
assign bf_blk_ren  = IFPOOL_rdy && |bf_blk_cnt && (blk_cs == BLK_OUT || blk_cs == BLK_CLR);
assign bf_blk_wen = ~bf_blk_full && bf_ram_ren_d;

assign BF_rdy = ~(&bf_cur_vld) && ~bf_blk_rdy_full;

assign blk_din_done =   bf_blk_rdy_full;
assign blk_out_done =  &bf_blk_radd && bf_blk_ren;
assign blk_clr_done = ~|bf_blk_cnt && ~|bf_ram_vld_s && ~|bf_ram_wen && ~bf_ram_ren_d;

assign flg_din_done =   (bf_flg_cnt == {BADD_WIDTH{1'd1}}) && bf_flg_wen;
assign flg_out_done =  &bf_flg_radd && bf_flg_ren;
assign flg_clr_done = ~|bf_flg_cnt;

assign bf_blk_din = bf_ram_dout_sel;
assign bf_flg_full = bf_flg_cnt[BADD_WIDTH];
assign bf_blk_full = bf_blk_cnt[BADD_WIDTH];
assign bf_blk_rdy_full = (bf_blk_cnt == {BADD_WIDTH{1'd1}} && bf_ram_ren_d) || bf_blk_full;

wire bf_flg_vld_cnt_en = flg_cs == BLK_CLR ? |bf_flg_vld_cnt: BF_flg_val && BF_flg_rdy;
POOL_CNT #( 2 ) BF_FLG_VLD_CNT ( clk, rst_n, bf_flg_vld_cnt_en, bf_flg_vld_cnt );

wire bf_flg_data_en = (BF_flg_val || flg_cs == BLK_CLR) && ~bf_flg_full;
POOL_REG_E #( FLAG_WIDTH+1 ) BF_FLG_DATA_REG0( clk, rst_n, bf_flg_data_en, {BF_flg_val   ,bf_flg_data_d0} , {bf_flg_val_d1,bf_flg_data_d1} );
POOL_REG_E #( FLAG_WIDTH+1 ) BF_FLG_DATA_REG1( clk, rst_n, bf_flg_data_en, {bf_flg_val_d1,bf_flg_data_d1} , {bf_flg_val_d2,bf_flg_data_d2} );
POOL_REG_E #( FLAG_WIDTH+1 ) BF_FLG_DATA_REG2( clk, rst_n, bf_flg_data_en, {bf_flg_val_d2,bf_flg_data_d2} , {bf_flg_val_d3,bf_flg_data_d3} );

POOL_REG_E #( 1 ) PO_DATA_REG( clk, rst_n, IFPOOL_rdy    , bf_blk_ren , bf_blk_ren_d );
POOL_REG_E #( 1 ) PO_FLAG_REG( clk, rst_n, IFPOOL_flg_rdy, bf_flg_ren , bf_flg_ren_d );
POOL_REG_E #( 1 ) BF_WANY_REG( clk, rst_n,~bf_blk_rdy_full,bf_ram_wany, bf_ram_wany_d);
POOL_REG_E #( RAM_NUM    ) BF_CUR_VLD_REG ( clk, rst_n, ~bf_blk_rdy_full, bf_cur_vld , bf_last_vld  );
POOL_REG_E #( ADDR_WIDTH ) BF_RAM_ADD_REG0( clk, rst_n, ~bf_blk_rdy_full, bf_ram_ain , bf_ram_ain_d );
POOL_REG_E #( 1          ) BF_RANY_REG    ( clk, rst_n, ~bf_blk_full    , bf_ram_rany, bf_ram_ren_d );

POOL_REG #( ADDR_WIDTH ) BF_RAM_ADD_REG1( clk, rst_n, bf_ram_radd, bf_blk_ain   );
POOL_REG #( 1          ) BF_RAM_INV_REG ( clk, rst_n, bf_ram_rinv, bf_ram_inv_d );
POOL_REG #( RAM_NUM_AW ) BF_RAM_PTR_REG ( clk, rst_n, bf_ram_ptr , bf_ram_ptr_d );
POOL_REG #( 1          ) BF_CLR_REG0    ( clk, rst_n, clr_done   , clr_done_d   );
POOL_REG #( 1          ) BF_CLR_REG1    ( clk, rst_n, clr_done_d , clr_done_d1  );
POOL_REG #( RAM_NUM    ) BF_RAM_VLD_REG ( clk, rst_n, bf_ram_ren , bf_blk_vld   );

POOL_CNT #( BADD_WIDTH ) BF_BLK_WADD_CNT ( clk, rst_n, bf_blk_wen, bf_blk_wadd );
POOL_CNT #( BADD_WIDTH ) BF_BLK_RADD_CNT ( clk, rst_n, bf_blk_ren, bf_blk_radd );
POOL_CNT #( BADD_WIDTH ) BF_FLG_WADD_CNT ( clk, rst_n, bf_flg_wen, bf_flg_wadd );
POOL_CNT #( BADD_WIDTH ) BF_FLG_RADD_CNT ( clk, rst_n, bf_flg_ren, bf_flg_radd );

wire bf_clr_dcnt_en = blk_cs == BLK_CLR && ~bf_blk_rdy_full;
POOL_CNT #( ADDR_WIDTH ) BF_BLK_CLR_CNT ( clk, rst_n, bf_clr_dcnt_en, bf_clr_dcnt );
//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================

`ifdef ASSERT_ON

property bf_ram_rw_check;
@(posedge clk)
disable iff(rst_n!=1'b1)
    1 |-> ( ~( ( bf_ram_ren & bf_ram_wen == 'd0) && |bf_ram_ren && |bf_ram_wen ) );
endproperty
bf_ram_rw_chk: assert property ( bf_ram_rw_check )
begin
end
else
begin
    $display("Error: %t bf_ram_rw_check fail! Reading and Writing occur simultaneously, Call designer!",$time);
end

property bf_ram_num_check;
@(posedge clk)
disable iff(rst_n!=1'b1)
      1 |-> ( bf_last_num != 'd16);
endproperty
bf_ram_num_chk: assert property ( bf_ram_num_check )
begin
end
else
begin
    $display("Error: %t bf_ram_num_check fail! Ram fifo full, Call designer!",$time);
end

//property bf_ram_vld_check;
//@(posedge clk)
//disable iff(rst_n!=1'b1)
//  for( i = 0; i < ADD_NUM; i = i + 1 )begin
//    1 |-> ( bf_ram_vld[i] != 'd15);
//  end
//endproperty
//bf_ram_vld_chk: assert property ( bf_ram_vld_check )
//begin
//end
//else
//begin
//    $display("Error: %t bf_ram_vld_check fail! Ram fifo full, Call designer!",$time);
//end

`endif
endmodule

module POOL_REG_E #(
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

module POOL_REG #(
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

module POOL_CNT #(
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
