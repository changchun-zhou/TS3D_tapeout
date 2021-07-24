//======================================================
// Copyright (C) 2020 By zhoucc
// All Rights Reserved
//======================================================
// Module : POOL
// Author : CC zhou
// Contact :
// Date : 22 .2 .2020
//=======================================================
// Description :
//========================================================
`include "../source/include/dw_params_presim.vh"
module POOL#(
    parameter DATA_WIDTH = 8,
    parameter FLAG_WIDTH = 16,
    parameter ADDR_WIDTH = 8 
    )(
    input                                   clk             ,
    input                                   rst_n           ,
    input                                   CCUPOOL_reset   , // paulse
    
    output                                  POOLCFG_rdy     ,
    input                                   CFGPOOL_val     ,
    input  [`POOLCFG_WIDTH          -1 : 0] CFGPOOL_data    ,

    input                                   CCUPOOL_En      ,  // paulse: the last PEB finish
    input                                   CCUPOOL_ValFrm  , // level: last frame whether pooling;
    input                                   CCUPOOL_ValDelta,

    // POOL read psum
    output                                  POOLGB_rdy      ,
    output                                  POOLGB_fnh      , // GBPSUM finish curframe's pooling
    output [ADDR_WIDTH              -1 : 0] POOLGB_addr     ,
    input                                   GBPOOL_val      , // not used ??
    input  [`PSUM_WIDTH*`NUM_PEB    -1 : 0] GBPOOL_data     ,

    input                                   BF_rdy          ,
    output                                  BF_val          ,
    output [ADDR_WIDTH           -1 : 0] BF_addr         ,
    output [DATA_WIDTH              -1 : 0] BF_data         ,// bandwidth 8b/cycle

    input                                   BF_flg_rdy      ,
    output                                  BF_flg_val      ,
    output [FLAG_WIDTH              -1 : 0] BF_flg_data         
);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================
// reg  [ `GBFFLGOFM_ADDRWIDTH          -1 : 0] GBFFLGOFM_AddrWr;


//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
//wire                                                                CCUPOOL_En;
reg  [ `DATA_WIDTH                  -1 : 0] POOL_MEM [0:`NUM_PEB -1]; // modify to 2D array
wire  [ `PSUM_WIDTH                 -1 : 0] Output_Quant [0:`NUM_PEB -1]; // modify to 2D array
wire  [ `PSUM_WIDTH  + 20           -1 : 0] PELPOOL_Dat_Div [0:`NUM_PEB -1]; // modify to 2D array


reg [ 3                             -1 : 0] cnt_poolx;
reg [ 3                             -1 : 0] cnt_pooly;
wire[ `C_LOG_2(`LENPSUM * `LENPSUM) -1 : 0] AddrBasePEL;
reg                                         CFGPOOL_valpool;
reg [ 3                             -1 : 0] Stride;
reg [ `C_LOG_2(`LENPSUM)            -1 : 0] AddrCol;
reg [ `C_LOG_2(`LENPSUM*`LENPSUM)   -1 : 0] AddrBaseRow;
reg                                         FnhPoolRow;
wire                                        FnhPoolPat;
wire[ `NUM_PEB                      -1 : 0] FLAG_PSUM;
wire[ `DATA_WIDTH                   -2 : 0] ReLU [0: `NUM_PEB -1]; // 8bit MSB = 0

wire [ `DATA_WIDTH * `NUM_PEB       -1 : 0] FRMPOOL_DatWr;
wire [ `DATA_WIDTH * `NUM_PEB       -1 : 0] FRMPOOL_DatRd;
wire [ `DATA_WIDTH * `NUM_PEB       -1 : 0] DELTA_DatWr;
wire [ `DATA_WIDTH * `NUM_PEB       -1 : 0] DELTA_DatRd;
reg [ `DATA_WIDTH                   -1 : 0] SPRS_MEM [0 : `NUM_PEB -1];
wire [ `NUM_PEB                     -1 : 0] FLAG_MEM;

wire                                        SIPOOFM_En;
wire                                        SIPOFLGOFM_En;
reg [ `C_LOG_2(`NUM_PEB)            -1 : 0] SPRS_Addr;
wire                                        FnhSPRS;
wire                                        DELTA_EnRd;
wire                                        DELTA_EnWr;
reg [ `C_LOG_2(`LENPSUM*`LENPSUM)     -1 : 0] DELTA_AddrRd;
reg [ `C_LOG_2(`LENPSUM*`LENPSUM)     -1 : 0] DELTA_AddrWr;

wire                                        FRMPOOL_EnRd;
wire                                        FRMPOOL_EnWr;
reg [`C_LOG_2(`LENROW*`LENROW)      -1 : 0] FRMPOOL_AddrRd;
reg [`C_LOG_2(`LENROW*`LENROW)      -1 : 0] FRMPOOL_AddrWr;

reg [ `DATA_WIDTH                   -1 : 0] OFM_Addr;

wire                                        fifo_OFM_pop;
wire                                        fifo_OFM_empty;
wire                                        fifo_OFM_full;
wire                                        fifo_FLGOFM_pop;
wire                                        fifo_FLGOFM_empty;
wire                                        fifo_FLGOFM_full;
//=====================================================================================================================
// Logic Design :
//=====================================================================================================================
//assign CCUPOOL_En = &POOL_Val;
// FSM : ACT is ever gotten or not

localparam IDLE0        = 3'b000;
localparam IDLE         = 3'b100;
localparam RDPEL        = 3'b001;
localparam FRMPOOLDELTA = 3'b011;
localparam DELTA        = 3'b010;
localparam SPRS         = 3'b111;
//localparam RDRAM    = 3'b100;
//localparam WRRAM    = 3'b101;

reg [ 3 - 1 : 0  ] next_state;
reg [ 3 - 1 : 0  ] state;
wire [ 3 - 1 : 0  ] state_d;
wire [ 3 - 1 : 0  ] state_dd;
wire [ 3 - 1 : 0  ] state_ddd;


always @(*) begin
    case (state)
      IDLE0  :   if ( CCUPOOL_En )
                        next_state <= IDLE;
                    else
                        next_state <= IDLE0;  // avoid Latch
    IDLE:  if(FnhPoolPat)
                            next_state <= IDLE0;
                else
                next_state <= RDPEL;
      RDPEL: if(FnhPoolPat)
                            next_state <= IDLE0;
                    else  if (  cnt_poolx==Stride-1 && cnt_pooly==Stride-1 && GBPOOL_val ) // && POOLGB_rdy: state==RDPEL
                            //if(CCUPOOL_ValFrm)
                                next_state <= FRMPOOLDELTA;
                            //else
                                //next_state <= DELTA;
                    else
                        next_state <= RDPEL;
      FRMPOOLDELTA:
                   //if ( FnhPoolPat)
                        ///next_state <= IDLE0;
                     if( state_d ==FRMPOOLDELTA)
                            next_state <= SPRS;
                    else
                           next_state <= FRMPOOLDELTA;
        SPRS: if(FnhSPRS)
                        next_state <= IDLE;
                    else begin
                        next_state <= SPRS;
                    end
      default: next_state <= IDLE0;
    endcase
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
        state <= IDLE0;
    end else begin
        state <= next_state;
    end
end


assign POOLCFG_rdy = state == IDLE0;

reg [20  -1 :0 ] Scale_y;
reg [8   -1 :0 ] Bias_y;
wire [5   -1 :0 ] Quant_shift;
assign Quant_shift = 0;

reg                CFGPOOL_valfrmpool;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        {Scale_y, Bias_y, CFGPOOL_valpool, CFGPOOL_valfrmpool, Stride} <= 0;
    end else if ( CFGPOOL_val && POOLCFG_rdy ) begin
    // 20, 8 , 1, 3
        {Scale_y, Bias_y, CFGPOOL_valpool, CFGPOOL_valfrmpool,Stride} <= CFGPOOL_data;
    end
end
// assign {Scale_y, Bias_y, CFGPOOL_valpool, Stride} = CFGPOOL_data;
//CFGPOOL_valpool : level: Current layer whether pooling >CCUPOOL_ValFrm

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        AddrCol <= 1;
    end else if (state == IDLE0) begin 
        AddrCol <= 1;
    end else if ( FnhPoolRow)begin //////////////////////////////////
        AddrCol <= 1;
    end else if ( state == FRMPOOLDELTA && state_d != FRMPOOLDELTA ) begin
       AddrCol  <= AddrCol + Stride; // Stride ==3,  read PELPOOL_DatRd twice
    end
end
// Stride = 2 or 3 only
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
         FnhPoolRow<=0 ;
    end else begin
        FnhPoolRow <= (AddrCol + Stride >= `LENROW -1) && (cnt_poolx==Stride-1 && cnt_pooly==Stride-1 && POOLGB_rdy&& GBPOOL_val);  //;
    end
end
//assign FnhPoolRow = (AddrCol + Stride > `LENPSUM -1) && (cnt_poolx==Stride-1 && cnt_pooly==Stride-1);  //
//assign FnhPoolPat = AddrBaseRow + `LENPSUM * Stride > `LENPSUM * `LENPSUM -1;
// assign FnhPoolPat = AddrBasePEL > `LENROW * `LENPSUM -1;
assign FnhPoolPat = POOLGB_addr > `LENROW * `LENPSUM -2;

assign AddrBasePEL = AddrBaseRow + AddrCol;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        AddrBaseRow <= 0;
    end else if ( state == IDLE0 ) begin
         AddrBaseRow <= 0;
    end else if( FnhPoolRow ) begin
        AddrBaseRow <= AddrBaseRow + `LENROW * Stride;
    end
end

assign POOLGB_rdy = next_state == RDPEL ||state == RDPEL;
assign POOLGB_fnh = state == IDLE0 && fifo_OFM_empty && fifo_FLGOFM_empty;// ??????????synth
assign  POOLGB_addr = AddrBasePEL + cnt_poolx + `LENROW * cnt_pooly;

always @ ( posedge clk or negedge rst_n  ) begin
    if ( ! rst_n) begin
        cnt_poolx <= 0;
    end else if ( state == IDLE0 ) begin 
        cnt_poolx <= 0;
    end else if ( POOLGB_rdy&& GBPOOL_val)begin
        if (  cnt_poolx == Stride - 1 )
            cnt_poolx <= 0;
        else 
            cnt_poolx <= cnt_poolx + 1;
    end
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        cnt_pooly <= 0;
    end else if ( state == IDLE0) begin 
        cnt_pooly <= 0;
    end else if ( POOLGB_rdy&& GBPOOL_val && cnt_poolx == Stride - 1  )begin
        if ( cnt_pooly == Stride- 1 ) begin
            cnt_pooly <= 0;
        end else begin
            cnt_pooly <= cnt_pooly + 1;
        end
    end
end


`ifdef DELAY_SRAM
    wire [ `PSUM_WIDTH      -1 : 0] MEM_GBPOOL_data[ 0 : `NUM_PEB -1];
    generate
        genvar gv_i;
        for(gv_i=0; gv_i < `NUM_PEB; gv_i = gv_i +1) begin
            assign MEM_GBPOOL_data[gv_i] = GBPOOL_data[`PSUM_WIDTH*gv_i +: `PSUM_WIDTH];
        end
        
    endgenerate
`endif

// ==================================================================

generate
  genvar i;
  for(i=0;i<`NUM_PEB; i=i+1) begin:POOL_PEB
// ReLU
// to get y_q = y_f * s_y = (x_f*w_f + b_f)*s_y = Scale_y * x_q*w_q + Bias_y;
        assign PELPOOL_Dat_Div[i] = GBPOOL_val ? GBPOOL_data[`PSUM_WIDTH*i +: `PSUM_WIDTH] : 0;// only to use val
        assign Output_Quant[i] = ( PELPOOL_Dat_Div[i]*Scale_y ) >> Quant_shift + Bias_y;// Scale_y = 2**20/Scale_y(old)
        assign FLAG_PSUM[i] = Output_Quant[i][`PSUM_WIDTH- 1];
        assign ReLU[i]  =  FLAG_PSUM[i] ?  'b0 : Output_Quant[i];
//

  // Pooling 1x2x2
        // assign ReLU_q[i] = ReLU[i]/Scale_y + Bias_y;// 7bits
        always @ ( posedge clk or negedge rst_n ) begin
          if ( !rst_n ) begin
             POOL_MEM[i] <= 0;
          end else if ( next_state == IDLE ) begin
             POOL_MEM[i] <= 0;
         end else if(  GBPOOL_val && POOLGB_rdy )begin
             POOL_MEM[i]   <= (POOL_MEM[i]  >  {1'b0,ReLU[i] })? POOL_MEM[i] : {1'b0,ReLU[i]};//7 bit act(signed)
          end
        end
    // Pooling 2x1x1
assign FRMPOOL_DatWr[`DATA_WIDTH*i +: `DATA_WIDTH] = ( POOL_MEM[i] > FRMPOOL_DatRd[`DATA_WIDTH*i +: `DATA_WIDTH] || ~CCUPOOL_ValFrm||~CFGPOOL_valpool)? POOL_MEM[i] :FRMPOOL_DatRd[`DATA_WIDTH*i +: `DATA_WIDTH];
    //assign FRMPOOL_DatWr[`DATA_WIDTH*i +: `DATA_WIDTH] = CFGPOOL_valpool? ( CntFrm[0]? POOL_MEM : ):POOL_MEM[i];
    
    //assign DELTA_DatWr[`DATA_WIDTH*i +: `DATA_WIDTH] = $signed(FRMPOOL_DatWr[`DATA_WIDTH*i +: `DATA_WIDTH]) - ( CCUPOOL_ValDelta? $signed(DELTA_DatRd[ `DATA_WIDTH * i +: `DATA_WIDTH]) : 0);
        always @ ( posedge clk or negedge rst_n ) begin
            if ( !rst_n ) begin
                SPRS_MEM[i] <= 0;
            end else if ( state_d ==FRMPOOLDELTA ) begin
                SPRS_MEM[i] <= $signed(FRMPOOL_DatWr[`DATA_WIDTH*i +: `DATA_WIDTH]) - ( CCUPOOL_ValDelta? $signed(DELTA_DatRd[ `DATA_WIDTH * i +: `DATA_WIDTH]) : 0) ;
            end
        end
        assign FLAG_MEM[i] = |SPRS_MEM[i];
      end
endgenerate
assign DELTA_DatWr = FRMPOOL_DatWr;

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        SPRS_Addr <= 0;
   end else if ( state == IDLE ) begin
        SPRS_Addr <= 0;
    end else if ( state == SPRS && (SIPOOFM_En || ~FLAG_MEM[SPRS_Addr] ) && SPRS_Addr < 15) begin
        SPRS_Addr <= SPRS_Addr + 1 ;
    end
end
reg         valid_flag;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        valid_flag <= 0;
    end else if ( &SPRS_Addr && (SIPOOFM_En || ~FLAG_MEM[SPRS_Addr] ) ) begin
        valid_flag <= 0;
    end else if ( state == FRMPOOLDELTA && next_state == SPRS) begin
        valid_flag <= 1;
    end
end

assign FnhSPRS = (&SPRS_Addr) && ( fifo_OFM_empty&&fifo_FLGOFM_empty);

wire OFM_Val;
assign OFM_Val = ~CFGPOOL_valpool || (CFGPOOL_valpool && (~CFGPOOL_valfrmpool || CFGPOOL_valfrmpool && CCUPOOL_ValFrm));
assign SIPOOFM_En = FLAG_MEM[SPRS_Addr]  && state ==SPRS && OFM_Val && valid_flag;
assign SIPOFLGOFM_En = state_dd==FRMPOOLDELTA && state_ddd != FRMPOOLDELTA && OFM_Val;
//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        OFM_Addr <= 0;
    end else if ( state==IDLE0) begin 
        OFM_Addr <= 0;
    end else if ( state==SPRS && next_state != SPRS ) begin
        OFM_Addr <= OFM_Addr + 1;
    end
end

// sipo

fifo_fwft #(
    .DATA_WIDTH(`DATA_WIDTH+ `DATA_WIDTH ),
    .ADDR_WIDTH(4 )
    ) fifo_OFM(
    .clk ( clk ),
    .rst_n ( rst_n ),
    .Reset ( CCUPOOL_reset), // ASICCCU_start
    .push(SIPOOFM_En) ,
    .pop(fifo_OFM_pop ) ,
    .data_in( {SPRS_MEM[SPRS_Addr], OFM_Addr} ),
    .data_out ( {BF_data, BF_addr} ),
    .empty(fifo_OFM_empty ), 
    .full (fifo_OFM_full ) // BUG: not used: because FnhSPRS
    );
assign fifo_OFM_pop = BF_rdy && ~fifo_OFM_empty;
assign BF_val = ~fifo_OFM_empty;
// sipo


fifo_fwft #(
    .DATA_WIDTH(FLAG_WIDTH ),
    .ADDR_WIDTH(2 )
    ) fifo_FLGOFM(
    .clk ( clk ),
    .rst_n ( rst_n ),
    .Reset ( CCUPOOL_reset), // ASICCCU_start
    .push(SIPOFLGOFM_En) ,
    .pop(fifo_FLGOFM_pop ) ,
    .data_in( FLAG_MEM),
    .data_out (BF_flg_data ),
    .empty(fifo_FLGOFM_empty ), 
    .full (fifo_FLGOFM_full ) // BUG: not used
    );
assign fifo_FLGOFM_pop = BF_flg_rdy && ~fifo_FLGOFM_empty;
assign BF_flg_val = ~fifo_FLGOFM_empty;
// ==================================================================

assign FRMPOOL_EnRd = state == FRMPOOLDELTA && state_d != FRMPOOLDELTA && CCUPOOL_ValFrm;
assign FRMPOOL_EnWr = state_d == FRMPOOLDELTA && state_dd != FRMPOOLDELTA && ~CCUPOOL_ValFrm && CFGPOOL_valpool;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        FRMPOOL_AddrRd <= 0;
    end else if ( state == IDLE0 ) begin
         FRMPOOL_AddrRd <= 0;
    end else if (FRMPOOL_EnRd ) begin
        FRMPOOL_AddrRd <= FRMPOOL_AddrRd + 1;
    end
end
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        FRMPOOL_AddrWr <= 0;
    end else if ( state == IDLE0 ) begin
         FRMPOOL_AddrWr <= 0;
    end else if (FRMPOOL_EnWr ) begin
        FRMPOOL_AddrWr <= FRMPOOL_AddrWr + 1;
    end
end
// reuse

RAM_ACT_wrap #(// Cant Write and Read Stimulately
        .SRAM_BIT(`DATA_WIDTH),// 32
        .SRAM_BYTE(`NUM_PEB),
        .SRAM_WORD(`LENPSUM/2*`LENPSUM/2)
    ) inst_RAM_ACT_wrap (
        .clk      (clk),
        .rst_n    (rst_n),
        .addr_r   (FRMPOOL_AddrRd),
        .addr_w   (FRMPOOL_AddrWr),
        .read_en  (FRMPOOL_EnRd  ),
        .write_en (FRMPOOL_EnWr  ),
        .data_in  (FRMPOOL_DatWr ),
        .data_out (FRMPOOL_DatRd )
    );

assign DELTA_EnRd = state == FRMPOOLDELTA&& state_d != FRMPOOLDELTA && CCUPOOL_ValDelta;// paulse
assign DELTA_EnWr = state_d == FRMPOOLDELTA&& state_dd != FRMPOOLDELTA ;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        DELTA_AddrRd <= 0;
    end else if ( state == IDLE0 ) begin
         DELTA_AddrRd <= 0;
    end else if (DELTA_EnRd ) begin
        DELTA_AddrRd <= DELTA_AddrRd + 1;
    end
end
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        DELTA_AddrWr <= 0;
    end else if ( state == IDLE0 ) begin
         DELTA_AddrWr <= 0;
    end else if (DELTA_EnWr ) begin
        DELTA_AddrWr <= DELTA_AddrWr + 1;
    end
end

RAM_ACT_wrap #(// Cant Write and Read Stimulately
        .SRAM_BIT(`DATA_WIDTH),// 32
        .SRAM_BYTE(`NUM_PEB),
        .SRAM_WORD(`LENPSUM*`LENPSUM)
    ) RAM_DELTA (
        .clk      (clk),
        .rst_n    (rst_n),
        .addr_r   (DELTA_AddrRd),
        .addr_w   (DELTA_AddrWr),
        .read_en  (DELTA_EnRd  ),
        .write_en (DELTA_EnWr  ),
        .data_in  ( DELTA_DatWr),
        .data_out (DELTA_DatRd )
    );

Delay #(
    .NUM_STAGES(1),
    .DATA_WIDTH(3)
    )Delay_state_d
    (
        .CLK(clk),
        .RESET_N(rst_n),
        .DIN(state),
        .DOUT(state_d)
        );
Delay #(
    .NUM_STAGES(2),
    .DATA_WIDTH(3)
    )Delay_state_dd
    (
        .CLK(clk),
        .RESET_N(rst_n),
        .DIN(state),
        .DOUT(state_dd)
        );
Delay #(
    .NUM_STAGES(3),
    .DATA_WIDTH(3)
    )Delay_state_ddd
    (
        .CLK(clk),
        .RESET_N(rst_n),
        .DIN(state),
        .DOUT(state_ddd)
        );
endmodule
