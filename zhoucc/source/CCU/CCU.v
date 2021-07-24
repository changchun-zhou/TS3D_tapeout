// This is a simple example.
// You can make a your own header file and set its path to settings.
// (Preferences > Package Settings > Verilog Gadget > Settings - User)
//
//      "header": "Packages/Verilog Gadget/template/verilog_header.v"
//
// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : zhouchch@pku.edu.cn
// File   : CCU.v
// Create : 2020-07-14 21:09:52
// Revise : 2020-08-13 10:33:19
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`include "../source/include/dw_params_presim.vh"
module CCU #(
    parameter NUM_PEB         = 16 ,
    parameter PORT_WIDTH      = 128,
    parameter POOL_WIDTH      = 32 ,
    parameter FIFO_ADDR_WIDTH = 6  
    )(
    input                               clk                     ,
    input                               rst_n                   ,
    input                               ASICCCU_start           ,

    output                              CFGIF_rdy               , // reg
    input                               IFCFG_val               , // push full
    input  [ PORT_WIDTH         -1 : 0] IFCFG_data              ,
    // Configure
    input                               GBCFG_rdy               , // level
    output reg                          CFGGB_val               , // level

    output [ 4                  -1 : 0] CFGGB_num_alloc_wei     ,         
    output [ 4                  -1 : 0] CFGGB_num_alloc_flgwei  , // Number of Bank SRAM for flagwei              
    output [ 4                  -1 : 0] CFGGB_num_alloc_flgact  ,                       
    output [ 4                  -1 : 0] CFGGB_num_alloc_act     , /* allocate SRAM BANK to Activation*/

    output [ 4                  -1 : 0] CFGGB_num_total_flgwei  , 
    output [ 4                  -1 : 0] CFGGB_num_total_flgact  , 
    output [ 4                  -1 : 0] CFGGB_num_total_act     , 

    output [12                  -1 : 0] CFGGB_num_loop_wei      , // patch * frame = 8*8 * 64
    output [8                   -1 : 0] CFGGB_num_loop_act      , // 1024/32 = 32
    // Center Controller
    output                              CCUGB_pullback_wei      , //  reg
    output                              CCUGB_pullback_act      , //  reg
    output                              CCUGB_reset_all         , // reg

    // Pooling
    input                               POOLCFG_rdy             ,
    output  reg                         CFGPOOL_val             ,
    output [`POOLCFG_WIDTH      -1 : 0] CFGPOOL_data            , // {Scale_y, Bias_y, POOL_ValIFM, Stride}
    output                              CCUPOOL_reset           , // reg

    // PEB
    output  [ 1*NUM_PEB         -1 : 0] CCUPEB_next_block       , // reg
    output  [ 1*NUM_PEB         -1 : 0] CCUPEB_reset_act        , // reg
    output  [ 1*NUM_PEB         -1 : 0] CCUPEB_reset_wei        , // reg
    input   [ 1*NUM_PEB         -1 : 0] PEBCCU_fnh_block        ,

    input                               GBPSUMCFG_rdy         ,
    output  reg                         CFGGBPSUM_val         ,
    output  [6                  -1 : 0] CFGGBPSUM_num_frame   ,
    output  [6                  -1 : 0] CFGGBPSUM_num_block   ,
    
    output                              CCUGB_reset_patch     , // siyuan GBPSUM
    input [ 1*3*`NUM_PEB        -1 : 0] PSUMGB_val            ,
    output  [6                  -1 : 0] CCUGB_frame           , // siyuan GBPSUM
    output  [6                  -1 : 0] CCUGB_block           , // siyuan GBPSUM

    output                              CCUPOOL_En            , // POOL
    input                               POOLGB_fnh            ,
    output                              CCUPOOL_ValFrm        , // POOL
    output                              CCUPOOL_ValDelta      , // POOL

    output                              CCUPOOL_layer_fnh     , // siyuan POOL_OUT: clear up all data and flag to IF
    input                               POOLCCU_clear_up      ,  // clear up finish
    output [212                  -1 : 0]CCUMONITOR

);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================





//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
wire                                start_cmp     ;
wire [ 1*NUM_PEB            -1 : 0] PEBCCU_fnh_block_d;

wire                                inc_block ;
wire                                inc_frame ;
wire                                inc_ftrgrp;
wire                                inc_patch ;
wire                                inc_layer ;
wire                                inc_block_d;
wire                                inc_frame_d;
wire                                inc_ftrgrp_d;
wire                                inc_layer_d;
wire                                overflow_block ;
wire                                overflow_frame ;
wire                                overflow_ftrgrp;
wire                                overflow_patch ;
wire                                overflow_layer ;

wire [ `BLK_WIDTH           -1 : 0] CFGCCU_num_block;
wire [ `BLK_WIDTH           -1 : 0] CFGCCU_num_block_tmp;
wire [ `FRAME_WIDTH         -1 : 0] CFGCCU_num_frame;
wire [ `PATCH_WIDTH         -1 : 0] CFGCCU_num_patch;
wire [ `FTRGRP_WIDTH        -1 : 0] CFGCCU_num_ftrgrp;
wire [ `LAYER_WIDTH         -1 : 0] CFGCCU_num_layer;
wire [ `BLK_WIDTH           -1 : 0] cnt_block;
wire [ `FRAME_WIDTH         -1 : 0] cnt_frame;
wire [ `PATCH_WIDTH         -1 : 0] cnt_patch;
wire [ `FTRGRP_WIDTH        -1 : 0] cnt_ftrgrp;
wire [ `LAYER_WIDTH         -1 : 0] cnt_layer;

wire [ PORT_WIDTH           -1 : 0] fifo_out;
wire                                fifo_empty;
wire                                fifo_full;

reg                                 wait_inc_layer;
wire                                CFGCCU_valframepool;
wire                                all_finish;


//=====================================================================================================================
// Logic Design :
//=====================================================================================================================
localparam IDLE    = 3'b000;
localparam CFG     = 3'b001;
localparam CMP     = 3'b010;
localparam STOP    = 3'b011;
localparam WAITGBF = 3'b100;
reg [ 3 -1:0 ]state;
reg [ 3 -1:0 ]next_state;
always @(*) begin
    case ( state )
        IDLE : if( ASICCCU_start)
                    next_state <= CFG; //A network config a time
                else
                    next_state <= IDLE;
        CFG: if( fifo_full)
                    next_state <= CMP;
                else
                    next_state <= CFG;
        CMP: if( all_finish) /// CMP_FRM CMP_PAT CMP_...
                    next_state <= IDLE;
                else
                    next_state <= CMP;
        default: next_state <= IDLE;
    endcase
end
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

assign start_cmp = state == CFG && next_state == CMP; // paulse : Configure finish
assign all_finish = inc_layer && overflow_layer;
// *****************************************************************************
// Loop Ctrl
// *****************************************************************************

// for PEBGB_fnh_paulse_4d: inc_block
    // wire            PEBGB_fnh; //paulse
    // wire            PEBGB_fnh_d; //paulse
    // wire            PEBGB_fnh_paulse;
    // wire            PEBGB_fnh_paulse_4d; // GBPSUM 64B ->16B
    // assign PEBGB_fnh = &PEBCCU_fnh_block && ~(|PSUMGB_val); // PEB finish && PEB trans psum to GBPSUM; 
    // assign PEBGB_fnh_paulse = PEBGB_fnh && ~PEBGB_fnh_d;

// overflow_frame: waiting pool finish then next ftrgrp
assign inc_block  =  (overflow_frame&& overflow_block)?CCUGB_reset_patch :  &PEBCCU_fnh_block && ~(&PEBCCU_fnh_block_d) && state == CMP ; // paulse: all PEB finish
assign inc_frame  = overflow_block && inc_block ;
// assign inc_ftrgrp = overflow_frame && inc_frame ;
assign inc_ftrgrp = overflow_frame && inc_frame ;
assign inc_patch  = overflow_ftrgrp&& inc_ftrgrp;

wire layer_fnh = overflow_patch && inc_patch;
// assign inc_layer  = layer_fnh && POOLCCU_clear_up; // 
assign inc_layer  = wait_inc_layer && POOLCCU_clear_up; // 

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        wait_inc_layer <= 0;
    end else if ( inc_layer ) begin
        wait_inc_layer <= 0;
    end else if ( layer_fnh ) begin
        wait_inc_layer <= 1;
    end
end

assign CCUGB_pullback_wei = inc_frame_d;
assign CCUGB_pullback_act = inc_ftrgrp_d;
assign CCUGB_reset_all    = layer_fnh; // reg

assign CCUGB_block        = cnt_block;
assign CCUPOOL_layer_fnh  = layer_fnh; // curlayer finish
assign CCUPOOL_reset      = inc_layer_d;


// pooling cross frame: layer's 3 5 7..
assign CCUPOOL_ValFrm     = cnt_frame[0] && cnt_frame !=0 && CFGCCU_valframepool; //??? pooling cross frame
assign CCUPOOL_ValDelta   = 0; //cnt_frame != 0; //??? delta cross frame: output feature map
generate
    genvar i;
    for(i=0; i<NUM_PEB; i=i+1)begin
        assign CCUPEB_next_block[i]  = start_cmp || inc_block_d; // 16 bits
        assign CCUPEB_reset_act[i]   = start_cmp || inc_ftrgrp_d;
        assign CCUPEB_reset_wei[i]   = start_cmp || inc_frame_d;
    end
endgenerate

reg [ `FRAME_WIDTH + 1      -1 : 0] cntpoolfrm;
reg                                 POOLGB_fnh_d;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        POOLGB_fnh_d <= 1;
    end else begin
        POOLGB_fnh_d <= POOLGB_fnh;
    end
end
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        cntpoolfrm <= 0;
    end else if (CCUGB_reset_patch) begin 
        cntpoolfrm <= 0;
    end else if ( POOLGB_fnh && ~POOLGB_fnh_d ) begin
        cntpoolfrm <= cntpoolfrm + 1;
    end
end
assign CCUGB_reset_patch  = cntpoolfrm== CFGCCU_num_frame + 1 + 1; // clear GBPSUM: 

wire inc_CCUGB_frame;
wire overflow_block_d;
wire val_pool = POOLGB_fnh&& &PEBCCU_fnh_block&& overflow_block_d;// be used to add pool 2 times
wire val_pool_d;
assign inc_CCUGB_frame = (CCUGB_frame >=CFGCCU_num_frame + 1 + 1)? 0: CCUGB_frame < CFGCCU_num_frame ? inc_frame : val_pool && ~val_pool_d;//???
assign CCUPOOL_En         = inc_CCUGB_frame; //
// 0 1 2 3; POOLGB_fnh ->4 -> pool_val and pool_en pool_fnh ->5 ->reset_patch -> 0; ->

wire [ `FRAME_WIDTH     -1 : 0] counter_CCUGB_frame_MAX_COUNT;
assign counter_CCUGB_frame_MAX_COUNT = CFGCCU_num_frame + 1 + 1;
counter #(
        .COUNT_WIDTH(`FRAME_WIDTH)
    ) counter_CCUGB_frame(
        .CLK       (clk         ),
        .RESET_N   (rst_n       ),
        .CLEAR     (CCUGB_reset_patch   ),
        .DEFAULT   ({`FRAME_WIDTH{1'b0}}           ),
        .INC       (inc_CCUGB_frame   ),
        .DEC       (1'b0           ),
        .MIN_COUNT ({`FRAME_WIDTH{1'b0}}           ),
        .MAX_COUNT (counter_CCUGB_frame_MAX_COUNT),
        .OVERFLOW  ( ),
        .UNDERFLOW (            ),
        .COUNT     (CCUGB_frame   )
    );



counter #(
    .COUNT_WIDTH(`BLK_WIDTH)
    ) counter_Blk(
        .CLK       (clk         ),
        .RESET_N   (rst_n       ),
        .CLEAR     (inc_layer   ),
        .DEFAULT   ({`BLK_WIDTH{1'b0}}           ),
        .INC       (inc_block   ),
        .DEC       (1'b0           ),
        .MIN_COUNT ({`BLK_WIDTH{1'b0}}           ),
        .MAX_COUNT (CFGCCU_num_block), // 7 15
        .OVERFLOW  (overflow_block),
        .UNDERFLOW (            ),
        .COUNT     (cnt_block   )
    );
counter #(
        .COUNT_WIDTH(`FRAME_WIDTH)
    ) counter_Frame(
        .CLK       (clk         ),
        .RESET_N   (rst_n       ),
        .CLEAR     (inc_layer   ),
        .DEFAULT   ({`FRAME_WIDTH{1'b0}}           ),
        .INC       (inc_frame   ),
        .DEC       (1'b0           ),
        .MIN_COUNT ({`FRAME_WIDTH{1'b0}}           ),
        .MAX_COUNT (CFGCCU_num_frame),
        .OVERFLOW  (overflow_frame),
        .UNDERFLOW (            ),
        .COUNT     (cnt_frame   )
    );
counter #(
        .COUNT_WIDTH(`FTRGRP_WIDTH)
    ) counter_FtrGrp(
        .CLK       (clk         ),
        .RESET_N   (rst_n       ),
        .CLEAR     (inc_layer   ),
        .DEFAULT   ({`FTRGRP_WIDTH{1'b0}}           ),
        .INC       (inc_ftrgrp  ),
        .DEC       (1'b0           ),
        .MIN_COUNT ({`FTRGRP_WIDTH{1'b0}}           ),
        .MAX_COUNT (CFGCCU_num_ftrgrp),
        .OVERFLOW  (overflow_ftrgrp),
        .UNDERFLOW (            ),
        .COUNT     (cnt_ftrgrp  )
    );
counter #(
        .COUNT_WIDTH(`PATCH_WIDTH)
    ) counter_Patch(
        .CLK       (clk         ),
        .RESET_N   (rst_n       ),
        .CLEAR     (inc_layer   ),
        .DEFAULT   ({`PATCH_WIDTH{1'b0}}           ),
        .INC       (inc_patch   ),
        .DEC       (1'b0           ),
        .MIN_COUNT ({`PATCH_WIDTH{1'b0}}           ),
        .MAX_COUNT (CFGCCU_num_patch),
        .OVERFLOW  (overflow_patch),
        .UNDERFLOW (            ),
        .COUNT     (cnt_patch   )
    );
counter #(
        .COUNT_WIDTH(`LAYER_WIDTH)
    ) counter_Layer(
        .CLK       (clk         ),
        .RESET_N   (rst_n       ),
        .CLEAR     (1'b0           ),
        .DEFAULT   ({`LAYER_WIDTH{1'b0}}           ),
        .INC       (inc_layer         ),
        .DEC       (1'b0           ),
        .MIN_COUNT ({`LAYER_WIDTH{1'b0}}           ),
        .MAX_COUNT (CFGCCU_num_layer),
        .OVERFLOW  (overflow_layer),
        .UNDERFLOW (            ),
        .COUNT     (cnt_layer   )
    );

// *****************************************************************************
// Configure
// *****************************************************************************
wire                fifo_pop;
wire                fifo_push;
assign CFGIF_rdy = ~fifo_full && (state == CFG || state == IDLE) ; // reg

assign fifo_pop = start_cmp || inc_layer;
assign fifo_push = IFCFG_val && CFGIF_rdy;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        CFGGB_val <= 0;
    end else if ( fifo_pop ) begin // except
        CFGGB_val <= 1;
    end else if ( GBCFG_rdy) begin
        CFGGB_val <= 0;
    end
end
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        CFGPOOL_val <= 0;
    end else if ( fifo_pop ) begin
        CFGPOOL_val <= 1;
    end else if ( POOLCFG_rdy) begin
        CFGPOOL_val <= 0;
    end
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        CFGGBPSUM_val <= 0;
    // every ftrgrp start: fifo_pop || not last ftrgrp in a layer
    end else if ( fifo_pop || (inc_ftrgrp && ~(overflow_patch&&overflow_ftrgrp) ) ) begin
        CFGGBPSUM_val <= 1;
    end else if ( GBPSUMCFG_rdy) begin
        CFGGBPSUM_val <= 0;
    end
end

assign CFGGBPSUM_num_frame = CFGCCU_num_frame;
assign CFGGBPSUM_num_block = CFGCCU_num_block;
// `ifdef DELAY_SRAM
//     assign CFGCCU_num_block = 4; // sim
// `else 
//     assign CFGCCU_num_block = CFGCCU_num_block_tmp;
// `endif
assign CFGCCU_num_block = CFGCCU_num_block_tmp;
assign  { //122
        CFGCCU_valframepool, // 1
        CFGCCU_num_layer , // 6
        CFGCCU_num_patch, // 8
        CFGCCU_num_ftrgrp, // 11
        CFGCCU_num_frame, // 6
        CFGCCU_num_block_tmp, // 10  89:80 
        CFGGB_num_alloc_flgwei, // 4 
        CFGGB_num_alloc_wei, // 4 
        CFGGB_num_alloc_flgact, // 4
        CFGGB_num_alloc_act,  // 4
        CFGGB_num_total_flgwei, // 4
        CFGGB_num_total_flgact, // 4
        CFGGB_num_total_act, // 4
        CFGGB_num_loop_wei, // 12
        CFGGB_num_loop_act, // 8 
        CFGPOOL_data // 33
        } = fifo_out; 
// CONV2: IFCFG_data = { 1'd0, 
// 6'd10, 8'd15, 11'd7, 6'd15, 10'd1, 
// 4'd1, 4'd2,4'd4, 4'd8, 
// 4'd1,4'd4, 4'd8, 
// 12'd16, 8'd8, 
// { 20'd1, 8'd0, 1'd1, 1'd0, 3'd2 }}
//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================

fifo_asic #(
    .DATA_WIDTH(PORT_WIDTH ),
    .ADDR_WIDTH(FIFO_ADDR_WIDTH )
    ) fifo_CONFIG(
    .clk ( clk ),
    .rst_n ( rst_n ),
    .Reset ( 1'b0), // ASICCCU_start
    .push(fifo_push) ,
    .pop(fifo_pop ) ,
    .data_in( IFCFG_data),
    .data_out (fifo_out ),
    .empty(fifo_empty ),
    .full (fifo_full )
    );

Delay #(
    .NUM_STAGES(1),
    .DATA_WIDTH(NUM_PEB)
    )Delay_PEBCCU_fnh_d(
    .CLK(clk),
    .RESET_N(rst_n),
    .DIN(PEBCCU_fnh_block),
    .DOUT(PEBCCU_fnh_block_d)
    );
Delay #(
    .NUM_STAGES(1),
    .DATA_WIDTH(1)
    )Delay_inc_block_d(
    .CLK(clk),
    .RESET_N(rst_n),
    .DIN(inc_block),
    .DOUT(inc_block_d)
    );
Delay #(
    .NUM_STAGES(1),
    .DATA_WIDTH(1)
    )Delay_inc_frame_d(
    .CLK(clk),
    .RESET_N(rst_n),
    .DIN(inc_frame),
    .DOUT(inc_frame_d)
    );
Delay #(
    .NUM_STAGES(1),
    .DATA_WIDTH(1)
    )Delay_inc_ftrgrp_d(
    .CLK(clk),
    .RESET_N(rst_n),
    .DIN(inc_ftrgrp),
    .DOUT(inc_ftrgrp_d)
    );

Delay #(
    .NUM_STAGES(1),
    .DATA_WIDTH(1)
    )Delay_inc_layer_d(
    .CLK(clk),
    .RESET_N(rst_n),
    .DIN(inc_layer),
    .DOUT(inc_layer_d)
    );
// Delay #(
//     .NUM_STAGES(1),
//     .DATA_WIDTH(1)
//     )Delay_PEBGB_fnh_d(
//     .CLK(clk),
//     .RESET_N(rst_n),
//     .DIN(PEBGB_fnh),
//     .DOUT(PEBGB_fnh_d)
//     );
// Delay #(
//     .NUM_STAGES(4),
//     .DATA_WIDTH(1)
//     )Delay_PEBGB_fnh_paulse_4d(
//     .CLK(clk),
//     .RESET_N(rst_n),
//     .DIN(PEBGB_fnh_paulse),
//     .DOUT(PEBGB_fnh_paulse_4d)
//     );
Delay #(
    .NUM_STAGES(1),
    .DATA_WIDTH(1)
    )Delay_val_pool_d(
    .CLK(clk),
    .RESET_N(rst_n),
    .DIN(val_pool),
    .DOUT(val_pool_d)
    );
Delay #(
    .NUM_STAGES(1),
    .DATA_WIDTH(1)
    )Delay_overflow_block_d(
    .CLK(clk),
    .RESET_N(rst_n),
    .DIN(overflow_block),
    .DOUT(overflow_block_d)
    );

assign CCUMONITOR = { // 36 + 4 + 3 + 5 + 3 + 3 + 5 + 15 + 2 + 128 + 2 + 6 = 212
    fifo_out            , // 128
    fifo_pop            ,
    fifo_push           ,
    cntpoolfrm          , // 6
    inc_block           ,
    inc_frame           ,
    inc_ftrgrp          ,
    inc_patch           ,
    inc_layer           ,
    wait_inc_layer      ,
    cnt_block[0 +:5]    , // 5
    cnt_frame[0 +: 4]   , // 4
    cnt_ftrgrp[0 +: 6]  , // 6
    cnt_patch[ 0 +: 4]  , // 4
    cnt_layer[ 0 +: 4]  , // 4
    CCUPOOL_layer_fnh   ,    
    POOLCCU_clear_up    ,    
    CCUPOOL_En          ,    
    POOLGB_fnh          ,    
    CCUPOOL_ValFrm      ,    
    CCUPOOL_ValDelta    ,    
    CCUGB_reset_patch   ,    
    CCUGB_frame         , // 6
    GBPSUMCFG_rdy       ,        
    CFGGBPSUM_val       ,        
    CCUPEB_next_block[0],        
    CCUPEB_reset_act[0] ,        
    CCUPEB_reset_wei[0] ,        
    PEBCCU_fnh_block    , // 16
    POOLCFG_rdy         ,        
    CFGPOOL_val         ,
    CCUPOOL_reset       ,        
    CCUGB_pullback_wei  ,    
    CCUGB_pullback_act  ,    
    CCUGB_reset_all     ,      
    CFGGB_val           ,    
    GBCFG_rdy           ,    
    IFCFG_val           ,    
    CFGIF_rdy           ,    
    state                // 3
};
endmodule
