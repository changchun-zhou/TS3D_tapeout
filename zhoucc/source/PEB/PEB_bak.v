//======================================================
// Copyright (C) 2019 By zhoucc
// All Rights Reserved
//======================================================
// Module : PEB
// Author : CC zhou
// Contact : 
// Date : 6 .13 .2019
//=======================================================
// Description :
//========================================================
`include "../source/include/dw_params_presim.vh"
module PEB (
    input                               clk     ,
    input                               rst_n   ,

    input                               next_block,// paulse:reset wei/arb
    input                               reset_act,// paulse
    input                               reset_wei,
    output                              ACTGB_Rdy,
    input                               GBACT_Val,
    input    [`REGACT_WR_WIDTH  -1 : 0] GBACT_Data, // 16B

    output                              GB_WrReq_FLGACT,
    input                               GB_WrEn_FLGACT,
    input   [`REGFLGACT_WR_WIDTH-1 : 0] GB_WrDat_FLGACT,  // 4B

    input                               PEBACT_Rdy,//PEB
    output                              ACTPEB_Val,
    output [ `REGACT_WR_WIDTH   -1 : 0] ACTPEB_Data,

    input                               PEBFLGACT_RdReq,//PEB
    output                              PEBFLGACT_RdVal,
    output [`REGFLGACT_WR_WIDTH -1 : 0] PEBFLGACT_RdDat,

    output                              WEIGB_Instr_Rdy,
    input                               GBWEI_Instr_Val,
    input  [`DATA_WIDTH         -1 : 0] GBWEI_Instr_Data,

    output                              WEIGB_Rdy,
    input                               GBWEI_Val,
    input  [`REGWEI_WR_WIDTH+`C_LOG_2(`MAC_NUM)-1 : 0] GBWEI_Data,

    output                              FLGWEIGB_Rdy,
    input                               GBFLGWEI_Val,
    input  [`REGFLGWEI_WR_WIDTH -1 : 0] GBFLGWEI_Data,

    output                              PSUMGB_val0,// PE0
    output [ `PSUM_WIDTH*`LENROW-1 : 0] PSUMGB_data0,
    input                               GBPSUM_rdy0,

    output                              PSUMGB_val1,// PE1
    output [ `PSUM_WIDTH*`LENROW-1 : 0] PSUMGB_data1,
    input                               GBPSUM_rdy1, 

    output                              PSUMGB_val2,// PE2
    output [ `PSUM_WIDTH*`LENROW-1 : 0] PSUMGB_data2,
    input                               GBPSUM_rdy2,

    output                              PSUMGB_rdy0,// Psum In
    input [ `PSUM_WIDTH*`LENROW  -1: 0] GBPSUM_data0,
    input                               GBPSUM_val0,

    output                              PSUMGB_rdy1,// Psum In
    input [ `PSUM_WIDTH*`LENROW  -1: 0] GBPSUM_data1,
    input                               GBPSUM_val1,

    output                              PSUMGB_rdy2,// Psum In
    input [ `PSUM_WIDTH*`LENROW  -1: 0] GBPSUM_data2,
    input                               GBPSUM_val2,
    output                              test
);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================





//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
wire [ `MAC_NUM                             -1 : 0] MACMUX_Val;
wire [`PSUM_ADDR_WIDTH                      -1 : 0] MACMUX_Addr[0: `MAC_NUM - 1];
wire [`PSUM_WIDTH                           -1 : 0] MACMUX_Psum [0: `MAC_NUM - 1];
wire [`MAC_NUM                              -1 : 0] MACARB_ReqHelp;
wire [`MAC_NUM                              -1 : 0] ARBMAC_Rst;
wire [`REGACT_ADDR_WIDTH*`MAC_NUM           -1 : 0] ARBMAC_AddrBaseAct;

wire [`MAC_NUM                              -1 : 0] Stop_Psum_All;
wire [`MAC_NUM_WIDTH*`MAC_NUM+`CHN_DEPTH_WIDTH-1:0] ARBMAC_IDWei;// << 5
wire [1 * `MAC_NUM                          -1 :0 ] ARBMAC_NewRow;// << 5

wire [ `REGFLGACT_ADDR_WIDTH*`MAC_NUM       -1 : 0] Regarray_FlgActout_addr;
wire [`BLOCK_DEPTH*`MAC_NUM                 -1 : 0] Regarray_FlgActout;

wire [ `REGACT_ADDR_WIDTH*`MAC_NUM          -1 : 0] REGARRAY_ACT_RdAddr;
wire [ `DATA_WIDTH*`MAC_NUM                 -1 : 0] Regarray_Actout;
wire [ 1*`MAC_NUM                           -1 : 0] Regarray_Actout_Rdy;
wire [ 1*`MAC_NUM                           -1 : 0] Regarray_Actout_Val;

wire [ `BLOCK_DEPTH * `MAC_NUM              -1 : 0] regarray_flgweiout;
wire [ 10 *2* `MAC_NUM                        -1 : 0] Regarray_weiout_addr;
wire  [ `MAC_NUM*2                             -1 : 0] Regarray_weiout_Rdy;
// reg  [ `MAC_NUM                             -1 : 0] Regarray_weiout_Rdy_tmp;
wire [  `MAC_NUM*2                            -1 : 0] Regarray_weiout_Val;
wire [ `DATA_WIDTH*2 * `MAC_NUM               -1 : 0] Regarray_weiout;

wire [ `MAC_NUM                             -1 : 0] SRAM_WEI_dataout_rdy;
wire [ `MAC_NUM                             -1 : 0] SRAM_WEI_dataout_val;
wire [ `DATA_WIDTH * 8             -1 : 0] SRAM_WEI_dataout;

wire                                                REGARRAY_ACT_WrReq;
wire                                                REGARRAY_ACT_WrEn;
wire [ `REGACT_WR_WIDTH                     -1 : 0] REGARRAY_ACT_WrDat;

wire                                                REGARRAY_FLGACT_WrReq;
wire                                                REGARRAY_FLGACT_WrEn;
wire [ `REGFLGACT_WR_WIDTH                  -1 : 0] REGARRAY_FLGACT_WrDat;

wire                                                REGARRAY_FLGWEI_WrReq;
wire                                                REGARRAY_FLGWEI_WrEn;
wire [ `REGFLGWEI_WR_WIDTH                  -1 : 0] REGARRAY_FLGWEI_WrDat;

wire [ `REGACT_ADDR_WIDTH * 3               -1 : 0] MACARB_AddrBaseRow;

// wire [ `MAC_NUM                     - 1 : 0 ]MACARB_ReqHelp;

wire [ `PSUM_ADDR_WIDTH * `MAC_NUM          -1 : 0] PSUMARB_AddrPsum;

wire [ `MAC_NUM_WIDTH * `MAC_NUM*2          -1 : 0] ARBCHN_IDMAC_Help;
wire                                                ARBPSUM_PlsNewRow;
wire [ `REGFLGWEI_ADDR_WIDTH * `MAC_NUM     -1 : 0] regarray_flgweiout_offset;
wire [ 1* `MAC_NUM                          -1 : 0] regarray_flgweiout_rdy;
wire [ 1* `MAC_NUM                          -1 : 0] regarray_flgweiout_val;
wire [ `MAC_NUM                             -1 : 0] ARBPSUM_PlsMux;

wire [2*`MAC_NUM                            -1 : 0] ARBCHN_Switch;

wire [ `MAC_NUM                             -1 : 0] Regarray_FlgActout_Val;
wire [ `MAC_NUM                             -1 : 0] Regarray_FlgActout_Rdy;
wire [ `MAC_NUM                             -1 : 0] MUXMAC_Rdy;
wire [ `MAC_NUM/3                           -1 : 0] PSUMARB_rdy;

// Row Address
reg [ `C_LOG_2(`BLOCK_DEPTH*`LENROW*`LENROW)-1 : 0] AddrRowAct[0 : `LENROW -1];
reg [ 10                                    -1 : 0] AddrBlockWei [0 : 32 -1]; // 1024
wire [ 10                                    -1 : 0] AddrWei [0 : 27 -1]; // 1024

wire                                                wr_en_AddrRowAct;
reg [ `C_LOG_2(`LENROW)                     -1 : 0] wr_addr_AddrRowAct;
wire [ `C_LOG_2(`REGFLGACT_WR_WIDTH)        -1 : 0] count_act;

wire [ 4*`MAC_NUM                           -1 : 0] ARBMAC_IDActRow;

wire [ (`MAC_NUM_WIDTH+1)*`MAC_NUM -1 : 0] ARBMAC_IDCHN;
wire [ `MAC_NUM                             -1 : 0] MAC_AddrWei_Rdy;

wire [ `MAC_NUM*2                       -1 : 0] MUX_datain_rdy;
wire [ `MAC_NUM*2                       -1 : 0] CHN_rdy;
//=====================================================================================================================
// Logic Design :
//=====================================================================================================================






//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================
generate
    genvar i;
    for(i=0;i<`MAC_NUM;i=i+1) begin: MAC
        // wire MAC_Stop_Psum;
        wire [`REGACT_ADDR_WIDTH    -1 : 0] MAC_AddrAct;//????+ `CHN_DEPTH_WIDTH
        wire [`REGFLGACT_ADDR_WIDTH -1 : 0] MAC_AddrFlgAct;//?+ `CHN_DEPTH_WIDTH
        wire [`REGWEI_ADDR_WIDTH    -1 : 0] MAC_AddrWei;//?+ `CHN_DEPTH_WIDTH
        wire                                MAC_AddrFlgAct_Rdy;
        wire                                MAC_FlgAct_Val;
        wire [`BLOCK_DEPTH          -1: 0 ] MAC_FlgAct;
        wire [`BLOCK_DEPTH          -1: 0 ] MAC_FlgWei;
        wire [`DATA_WIDTH           -1 : 0] MAC_Act;
        wire [`DATA_WIDTH           -1 : 0] MAC_Wei;
        wire [ 2                    -1 : 0] PEBMAC_WeiCol;
        wire                                MAC_Wei_Val;

        MAC inst_MAC
            (
                .clk                (clk),
                .rst_n              (rst_n),

                .MACMUX_Val         (MACMUX_Val[i]),
                .MACMUX_Addr        (MACMUX_Addr[i]),
                .MACMUX_Psum        (MACMUX_Psum[i]),
                .MUXMAC_Rdy         (MUXMAC_Rdy[i]),

                .MACARB_ReqHelp      (MACARB_ReqHelp[i]),
                .ARBMAC_Rst         (ARBMAC_Rst[i]),
                .PEBMAC_WeiCol      (PEBMAC_WeiCol  ),

                .MAC_FlgWei         (MAC_FlgWei),
                .MAC_FlgWei_Val     (MAC_FlgWei_Val),

                .MAC_AddrFlgAct_Rdy ( MAC_AddrFlgAct_Rdy),
                .MAC_AddrFlgAct     (MAC_AddrFlgAct),//// + 5bit width <<
                .MAC_FlgAct_Val     ( MAC_FlgAct_Val),
                .MAC_FlgAct         (MAC_FlgAct),

                .MAC_AddrAct_Rdy    ( MAC_AddrAct_Rdy),
                .MAC_AddrAct        (MAC_AddrAct),// + 5bit width <<
                .MAC_Act_Val        ( MAC_Act_Val),
                .MAC_Act            (MAC_Act),

                .MAC_AddrWei_Rdy    ( MAC_AddrWei_Rdy[i]),
                .MAC_AddrWei        (MAC_AddrWei),// + 5bit width <<
                .MAC_Wei_Val        ( MAC_Wei_Val),
                .MAC_Wei            (MAC_Wei)
                
            );
assign PEBMAC_WeiCol =  ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 0  )? 0  : 
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 1  )? 1  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 2  )? 2  : 
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 3  )? 0  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 4  )? 1  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 5  )? 2  : 
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 6  )? 0  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 7  )? 1  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 8  )? 2  : 
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 9  )? 0  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 10 )? 1  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 11 )? 2  : 
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 12 )? 0  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 13 )? 1  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 14 )? 2  : 
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 15 )? 0  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 16 )? 0  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 17 )? 1  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 18 )? 2  : 
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 19 )? 0  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 20 )? 1  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 21 )? 2  : 
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 22 )? 0  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 23 )? 1  :
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 24 )? 2  : 
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 25 )? 0  : 
                        ( ARBMAC_IDWei[`MAC_NUM_WIDTH*i +: `MAC_NUM_WIDTH] == 26 )? 0  :
                        0;
 
        assign Regarray_FlgActout_Rdy[i ] = MAC_AddrFlgAct_Rdy;
        wire  [8   -1 : 0] AddrRowFlgAct = ARBMAC_IDActRow[4*i +: 4];
        assign Regarray_FlgActout_addr[`REGFLGACT_ADDR_WIDTH*i +: `REGFLGACT_ADDR_WIDTH] = 
                MAC_AddrFlgAct + AddrRowFlgAct << 4; // *16
        assign MAC_FlgAct_Val = Regarray_FlgActout_Val[i];
        assign MAC_FlgAct = Regarray_FlgActout[`BLOCK_DEPTH*i +: `BLOCK_DEPTH];// <<

        assign Regarray_Actout_Rdy[i] = MAC_AddrAct_Rdy;
        assign REGARRAY_ACT_RdAddr[`REGACT_ADDR_WIDTH*i +: `REGACT_ADDR_WIDTH] = 
                MAC_AddrAct + AddrRowAct[ARBMAC_IDActRow[4*i +: 4]];
        assign MAC_Act = Regarray_Actout[`DATA_WIDTH * i +: `DATA_WIDTH];
        assign MAC_Act_Val = Regarray_Actout_Val[i];

        assign regarray_flgweiout_rdy[i] = 1;
        // assign regarray_flgweiout_offset[`REGFLGACT_ADDR_WIDTH*ARBMAC_IDWei[`MAC_NUM_WIDTH*i +:`MAC_NUM_WIDTH ] +: `REGFLGACT_ADDR_WIDTH] = i;//?
        assign MAC_FlgWei = regarray_flgweiout[ `BLOCK_DEPTH*ARBMAC_IDWei[`MAC_NUM_WIDTH*i +:`MAC_NUM_WIDTH ] +: `BLOCK_DEPTH];
        assign MAC_FlgWei_Val = regarray_flgweiout_val[ARBMAC_IDWei[`MAC_NUM_WIDTH*i +:`MAC_NUM_WIDTH ]];

        // i-th MAC <=> ARBMAC_IDWei[i]-th Weight
        // always @(*) begin
        //     Regarray_weiout_Rdy = Regarray_weiout_Rdy_tmp;
        //     Regarray_weiout_Rdy[ ARBMAC_IDWei[`MAC_NUM_WIDTH*i +:`MAC_NUM_WIDTH ] ] = MAC_AddrWei_Rdy;
        // end
                
        assign AddrWei[i] = MAC_AddrWei + AddrBlockWei[ARBMAC_IDWei[`MAC_NUM_WIDTH*i +:`MAC_NUM_WIDTH ]];
        assign MAC_Wei_Val = Regarray_weiout_Val[ARBMAC_IDCHN[(`MAC_NUM_WIDTH+1)*i +: `MAC_NUM_WIDTH+1]];
        assign MAC_Wei = Regarray_weiout[`DATA_WIDTH*ARBMAC_IDCHN[(`MAC_NUM_WIDTH+1)*i +: `MAC_NUM_WIDTH+1] +: `DATA_WIDTH];

        wire                            regarray_weiin_rdy;
        wire                            regarray_weiin_val;
        wire [ `DATA_WIDTH*8    -1 : 0] regarray_weiin;
        REGARRAY #(
            .DATA_WIDTH (`DATA_WIDTH),
            .ADDR_WIDTH (10),
            .REG_ADDR_WIDTH(`REGWEI_ADDR_WIDTH),
            .WR_NUM (`REGWEI_WR_WIDTH / `DATA_WIDTH),
            .RD_NUM (2)) // two read channels
            REGARRAY_WEI // only a wei
            (
                .clk            (clk   ),
                .rst_n          (rst_n),
                .datain_rdy     (regarray_weiin_rdy),
                .datain_val     (regarray_weiin_val),
                .datain         (regarray_weiin),
                .dataout_addr   (Regarray_weiout_addr[20*i +: 20]),
                .dataout_rdy    (Regarray_weiout_Rdy[i +: 2]), // to MAC
                .dataout_val    (Regarray_weiout_Val[i +: 2]),
                .dataout        (Regarray_weiout[`DATA_WIDTH*2*i +: `DATA_WIDTH*2])
            );

        assign SRAM_WEI_dataout_rdy[i] = regarray_weiin_rdy;
        assign regarray_weiin_val = SRAM_WEI_dataout_val[i];
        assign regarray_weiin = SRAM_WEI_dataout;

        assign MUXMAC_Rdy[i] = CHN_rdy[ARBMAC_IDCHN[(`MAC_NUM_WIDTH+1)*i +: `MAC_NUM_WIDTH+1]];

    end
endgenerate


// From MAC to wei_Chn(54)
generate
    genvar chn;
    for(chn=0;chn<`MAC_NUM; chn=chn+1) begin 
        assign Regarray_weiout_Rdy[chn] = MAC_AddrWei_Rdy[ARBCHN_IDMAC_Help[(`MAC_NUM_WIDTH)*chn +: `MAC_NUM_WIDTH]];
        assign Regarray_weiout_addr[10*chn +: 10] = AddrWei[ARBCHN_IDMAC_Help[(`MAC_NUM_WIDTH)*chn +: `MAC_NUM_WIDTH]];
    end
endgenerate


SRAM_ACT #(
    .DATA_WIDTH(`REGACT_WR_WIDTH)
    )inst_SRAM_ACT // 1 input; 2 output FIFO
    (
        .clk            (clk                ),
        .rst_n          (rst_n              ),
        .datain_rdy     (ACTGB_Rdy          ),
        .datain_val     (GBACT_Val          ),
        .datain         (GBACT_Data         ),
        .dataout_rdy0   (REGARRAY_ACT_WrReq ),
        .dataout_val0   (REGARRAY_ACT_WrEn  ),
        .dataout0       (REGARRAY_ACT_WrDat ),
        .dataout_rdy1   (PEBACT_Rdy       ),
        .dataout_val1   (ACTPEB_Val       ),
        .dataout1       (ACTPEB_Data       )
    );
REGARRAY #(
    .DATA_WIDTH (`DATA_WIDTH),
    .ADDR_WIDTH(`REGACT_ADDR_WIDTH),
    .REG_ADDR_WIDTH(7),
    .WR_NUM (`REGACT_WR_WIDTH/`DATA_WIDTH),
    .RD_NUM (`MAC_NUM))
REGARRAY_ACT
    (
        .clk            (clk),
        .rst_n          (rst_n),
        .datain_rdy     (REGARRAY_ACT_WrReq),
        .datain_val     (REGARRAY_ACT_WrEn),
        .datain         (REGARRAY_ACT_WrDat),
        .dataout_addr (REGARRAY_ACT_RdAddr),
        .dataout_rdy    (Regarray_Actout_Rdy),
        .dataout_val    (Regarray_Actout_Val),
        .dataout        (Regarray_Actout)
    );

SRAM_ACT #(
    .DATA_WIDTH(`REGFLGACT_WR_WIDTH)
    )inst_SRAM_FLGACT
    (
        .clk          (clk                    ),
        .rst_n        (rst_n                  ),
        .datain_rdy   (GB_WrReq_FLGACT        ),
        .datain_val   (GB_WrEn_FLGACT         ),
        .datain       (GB_WrDat_FLGACT        ),
        .dataout_rdy0 (REGARRAY_FLGACT_WrReq  ),
        .dataout_val0 (REGARRAY_FLGACT_WrEn   ),
        .dataout0     (REGARRAY_FLGACT_WrDat  ),
        .dataout_rdy1 (PEBFLGACT_RdReq        ),
        .dataout_val1 (PEBFLGACT_RdVal        ),
        .dataout1     (PEBFLGACT_RdDat        )
    );
REGARRAY #(
    .DATA_WIDTH (`BLOCK_DEPTH),
    .ADDR_WIDTH(`REGFLGACT_ADDR_WIDTH),//256*1024/32 = 256*32 -> 13
    .REG_ADDR_WIDTH(5),
    .WR_NUM (`REGFLGACT_WR_WIDTH/`BLOCK_DEPTH),
    .RD_NUM (`MAC_NUM))
REGARRAY_FLGACT
    (
        .clk            (clk),
        .rst_n          (rst_n),
        .reset          (reset_act),
        .datain_rdy     (REGARRAY_FLGACT_WrReq),
        .datain_val     (REGARRAY_FLGACT_WrEn),
        .datain         (REGARRAY_FLGACT_WrDat),
        .dataout_addr   (Regarray_FlgActout_addr),
        .dataout_rdy    (Regarray_FlgActout_Rdy),
        .dataout_val    (Regarray_FlgActout_Val ),
        .dataout        (Regarray_FlgActout)
    );
assign wr_en_AddrRowAct = REGARRAY_FLGACT_WrReq && REGARRAY_FLGACT_WrEn;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        wr_addr_AddrRowAct <= 1; // from 1 begin write
    end else if ( reset_act) begin  // reset
        wr_addr_AddrRowAct <= 1;
    end else if ( wr_en_AddrRowAct ) begin
        wr_addr_AddrRowAct <= wr_addr_AddrRowAct + 1;
    end
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        AddrRowAct[0] <= 0; // baseaddr0 == 0
    end else if ( reset_act ) begin 
        AddrRowAct[0] <= 0;
    end else if ( wr_en_AddrRowAct ) begin
        AddrRowAct[wr_addr_AddrRowAct] <= count_act;
    end
end

COUNT1 #(
    .DATA_WIDTH(`REGFLGACT_WR_WIDTH))
    COUNT1_FLGACT(
    .din(REGARRAY_FLGACT_WrDat),
    .dout(count_act));


SRAM_WEI #(
    .DATA_WIDTH( `REGWEI_WR_WIDTH), // 8B or 16B??
    .RD_NUM ( `MAC_NUM),
    .ADDR_WIDTH(1)
 )inst_SRAM_WEI( 
    .instrout_rdy (WEIGB_Instr_Rdy ),
    .instrout_val (GBWEI_Instr_Val ),
    .instrout     (GBWEI_Instr_Data),
    .datain_rdy   (WEIGB_Rdy       ),
    .datain_val   (GBWEI_Val       ),
    .datain       (GBWEI_Data      ),
    .dataout_rdy  (SRAM_WEI_dataout_rdy),
    .dataout_val  (SRAM_WEI_dataout_val),
    .dataout      (SRAM_WEI_dataout)
);


REGFLGWEI #(
    .DATA_WIDTH (`BLOCK_DEPTH),
    .ADDR_WIDTH(`REGFLGWEI_ADDR_WIDTH),
    .WR_NUM (`REGFLGWEI_WR_WIDTH/`BLOCK_DEPTH),
    .RD_NUM (`MAC_NUM))
REGFLGWEI
    (
        .clk            (clk),
        .rst_n          (rst_n),
        .reset          (next_block),
        .datain_rdy     (FLGWEIGB_Rdy),
        .datain_val     (GBFLGWEI_Val),
        .datain         (GBFLGWEI_Data), // 8B
        .dataout_val    (regarray_flgweiout_val),
        .dataout        (regarray_flgweiout)
    );
generate
    genvar wei;
    for(wei=0;wei<`MAC_NUM;wei=wei+1) begin
        wire                            wr_en_AddrBlockWei;
        wire [ `C_LOG_2(`BLOCK_DEPTH)   -1 : 0] count_wei;
        assign wr_en_AddrBlockWei = next_block;

        always @ ( posedge clk or negedge rst_n ) begin
            if ( !rst_n ) begin
                AddrBlockWei[wei] <= 0; // baseaddr0 == 0
            end else if ( reset_wei ) begin 
                AddrBlockWei[wei] <= 0;
            end else if ( wr_en_AddrBlockWei ) begin
                AddrBlockWei[wei] <= AddrBlockWei[wei] + count_wei;
            end
        end
        COUNT1 #(
            .DATA_WIDTH(`BLOCK_DEPTH))
            COUNT1_WEI(
            .din(regarray_flgweiout[`BLOCK_DEPTH*wei +: `BLOCK_DEPTH]),
            .dout(count_wei));
    end
endgenerate


ARB inst_ARB
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .PEBARB_Sta         (next_block),
        .ARBPEB_Fnh         (ARBPEB_Fnh), // level

        .MAC_ReqHelp      (MACARB_ReqHelp),
        .PSUMARB_rdy        (PSUMARB_rdy),

        .ARBMAC_Rst         (ARBMAC_Rst),
        .ARBMAC_IDActRow    (ARBMAC_IDActRow),
        .ARBMAC_IDWei       (ARBMAC_IDWei),
        .ARBMAC_IDCHN       (ARBMAC_IDCHN),

        .ARBCHN_IDMAC_Help (ARBCHN_IDMAC_Help),
        // .ARBWEI_IDMAC
        .ARBCHN_Switch  ( ARBCHN_Switch)
    );


generate
    genvar j;
    for(j=0;j<`KERNEL_SIZE;j=j+1) begin: PSUM
        wire AWPSUM_Val0;
        wire AWPSUM_Val1;
        wire AWPSUM_Val2;
        wire MUXPSUM_Fnh0;
        wire MUXPSUM_Fnh1;
        wire MUXPSUM_Fnh2;

        wire [ `MAC_NUM_WIDTH + `PSUM_WIDTH -1 : 0] AWPSUM_Value0;
        wire [ `MAC_NUM_WIDTH + `PSUM_WIDTH -1 : 0] AWPSUM_Value1;
        wire [ `MAC_NUM_WIDTH + `PSUM_WIDTH -1 : 0] AWPSUM_Value2;

        wire PSUMAW_Val0  ;
        wire PSUMAW_Val1  ;
        wire PSUMAW_Val2  ;
        wire PSUMAW_Val3  ;

        wire PSUMGB_val;
        wire [ `PSUM_WIDTH * `LENROW    - 1 : 0] PSUMGB_data;
        wire GBPSUM_rdy ;
        wire GBPSUM_val;
        wire [ `PSUM_WIDTH * `LENROW    - 1 : 0] GBPSUM_data;
        wire PSUMGB_rdy ;
        wire        NXTPSUM_RdRdy;
        wire        NXTPSUM_RdVal;
        reg [ `PSUM_ADDR_WIDTH      -1 : 0] NXTPSUM_RdAddr;
        wire[ `PSUM_WIDTH           -1 : 0] NXTPSUM_RdDat;
        wire [ `PSUM_WIDTH + `PSUM_ADDR_WIDTH + 1       -1 : 0] dataout[0:3 -1];
        // assign datain = {  MACMUX_Psum[ARBCHN_IDMAC_Help[5*((3*j+jx)*2+1) +: 5]], 
        //                             MACMUX_Addr[ARBCHN_IDMAC_Help[5*((3*j+jx)*2+1) +: 5]]};
        generate
            genvar jx;
            for(jx=0;jx<3;jx=jx+1) begin: GEN_Mux
                wire [ `PSUM_WIDTH + `PSUM_ADDR_WIDTH + 1       -1 : 0] datain0;
                wire [ `PSUM_WIDTH + `PSUM_ADDR_WIDTH + 1       -1 : 0] datain1;

                wire                datain_val0;     
                wire                datain_rdy0;     
                wire                datain_val1;     
                wire                datain_rdy1; 
                wire                dataout_rdy;   
                wire                dataout_val; 

                wire                MUXPSUM_Fnh;
                // CHN0
                assign datain0 = {  MACMUX_Psum[ARBCHN_IDMAC_Help[5*((3*j+jx)*2) +: 5]],
                                    MACMUX_Addr[ARBCHN_IDMAC_Help[5*((3*j+jx)*2) +: 5]]};
                assign datain_val0 = ARBCHN_Switch[(3*j+jx)*2] && MACMUX_Val[ARBCHN_IDMAC_Help[5*((3*j+jx)*2) +: 5]];// condition??
                // assign MUXMAC_Rdy[ARBCHN_IDMAC_Help[5*((3*j+jx)*2) +: 5]] = ARBCHN_Switch[(3*j+jx)*2] && datain_rdy0;

                // CHN1
                assign datain1 = {  MACMUX_Psum[ARBCHN_IDMAC_Help[5*((3*j+jx)*2+1) +: 5]], 
                                    MACMUX_Addr[ARBCHN_IDMAC_Help[5*((3*j+jx)*2+1) +: 5]]};
                assign datain_val1 = ARBCHN_Switch[(3*j+jx)*2+1] && MACMUX_Val[ARBCHN_IDMAC_Help[5*((3*j+jx)*2+1) +: 5]];
                // assign MUXMAC_Rdy[ARBCHN_IDMAC_Help[5*((3*j+jx)*2+1) +: 5]] = ARBCHN_Switch[(3*j+jx)*2+1] && datain_rdy1;

                // (ch0: off or finish) && ((ch1: off or finish))
                assign MUXPSUM_Fnh =    (~ARBCHN_Switch[(3*j+jx)*2] || MACARB_ReqHelp[ARBCHN_IDMAC_Help[5*((3*j+jx)*2) +: 5]]) && 
                                        (~ARBCHN_Switch[(3*j+jx)*2+1] || MACARB_ReqHelp[ARBCHN_IDMAC_Help[5*((3*j+jx)*2+1) +: 5]]);
                // ** 2 input 1 output ****
                Mux_2I #(
                    .DATA_WIDTH(`PSUM_WIDTH + `PSUM_ADDR_WIDTH ),
                    .FIFO_ADDR_WIDTH(1)
                    )Mux_2I(
                    .clk(clk),
                    .rst_n(rst_n),
                    .datain_val0(datain_val0),
                    .datain0(datain0),
                    .datain_rdy0(MUX_datain_rdy[(3*j+jx)*2]),
                    .datain_val1(datain_val1),
                    .datain1(datain1),
                    .datain_rdy1(MUX_datain_rdy[(3*j+jx)*2+1]),
                    .dataout_rdy(dataout_rdy),
                    .dataout(dataout[jx]),
                    .dataout_val(dataout_val)
                    );
            end
        endgenerate

        wire                PSUMAW_Rdy0;
        wire                PSUMAW_Rdy1;
        wire                PSUMAW_Rdy2  ;
        assign AWPSUM_Val0 = GEN_Mux[0].dataout_val;
        assign AWPSUM_Val1 = GEN_Mux[1].dataout_val;
        assign AWPSUM_Val2 = GEN_Mux[2].dataout_val;

        assign MUXPSUM_Fnh0 = GEN_Mux[0].MUXPSUM_Fnh;
        assign MUXPSUM_Fnh1 = GEN_Mux[1].MUXPSUM_Fnh;
        assign MUXPSUM_Fnh2 = GEN_Mux[2].MUXPSUM_Fnh;
        
        assign AWPSUM_Value0 = dataout[0];
        assign AWPSUM_Value1 = dataout[1];
        assign AWPSUM_Value2 = dataout[2];

        assign GEN_Mux[0].dataout_rdy = PSUMAW_Rdy0;
        assign GEN_Mux[1].dataout_rdy = PSUMAW_Rdy1;
        assign GEN_Mux[2].dataout_rdy = PSUMAW_Rdy2;

        PSUM inst_PSUM ( // Handshake
            .clk           (clk),
            .rst_n         (rst_n),
            .reset          (next_block),
            .PSUMARB_rdy(PSUMARB_rdy[j]),
            .AWPSUM_Val0 (AWPSUM_Val0),// can't generate in generate ???
            .AWPSUM_Val1 (AWPSUM_Val1),
            .AWPSUM_Val2 (AWPSUM_Val2),
            .AWPSUM_Fnh0 (AWPSUM_Fnh0),
            .AWPSUM_Fnh1 (AWPSUM_Fnh1),
            .AWPSUM_Fnh2 (AWPSUM_Fnh2),
            .AWPSUM_Value0  (AWPSUM_Value0),
            .AWPSUM_Value1  (AWPSUM_Value1),
            .AWPSUM_Value2  (AWPSUM_Value2),
            .PSUMAW_Rdy0    (MUXPSUM_Fnh0  ),
            .PSUMAW_Rdy1    (MUXPSUM_Fnh1  ),
            .PSUMAW_Rdy2    (MUXPSUM_Fnh2  ),
            .datain_val     (GBPSUM_val ),
            .datain         (GBPSUM_data),
            .datain_rdy     (PSUMGB_rdy),
            .dataout_val    (PSUMGB_val),
            .dataout        (PSUMGB_data),
            .dataout_rdy    (GBPSUM_rdy )
        );
    end
endgenerate
assign CHN_rdy = ARBCHN_Switch & MUX_datain_rdy;
// generate
//     genvar mac;
    
// endgenerate


// Psum In 
assign PSUM[0].GBPSUM_val = GBPSUM_val0;
assign PSUM[1].GBPSUM_val = GBPSUM_val0;
assign PSUM[2].GBPSUM_val = GBPSUM_val0;
assign PSUM[3].GBPSUM_val = GBPSUM_val1;
assign PSUM[4].GBPSUM_val = GBPSUM_val1;
assign PSUM[5].GBPSUM_val = GBPSUM_val1;
assign PSUM[6].GBPSUM_val = GBPSUM_val2;
assign PSUM[7].GBPSUM_val = GBPSUM_val2;
assign PSUM[8].GBPSUM_val = GBPSUM_val2;

assign PSUM[0].GBPSUM_data = GBPSUM_data0;
assign PSUM[1].GBPSUM_data = GBPSUM_data0;
assign PSUM[2].GBPSUM_data = GBPSUM_data0;
assign PSUM[3].GBPSUM_data = GBPSUM_data1;
assign PSUM[4].GBPSUM_data = GBPSUM_data1;
assign PSUM[5].GBPSUM_data = GBPSUM_data1;
assign PSUM[6].GBPSUM_data = GBPSUM_data2;
assign PSUM[7].GBPSUM_data = GBPSUM_data2;
assign PSUM[8].GBPSUM_data = GBPSUM_data2;

assign PSUMGB_rdy0 = PSUM[0].PSUMGB_rdy || PSUM[1].PSUMGB_rdy || PSUM[2].PSUMGB_rdy;
assign PSUMGB_rdy1 = PSUM[3].PSUMGB_rdy || PSUM[4].PSUMGB_rdy || PSUM[5].PSUMGB_rdy;
assign PSUMGB_rdy2 = PSUM[6].PSUMGB_rdy || PSUM[7].PSUMGB_rdy || PSUM[8].PSUMGB_rdy;


// Psum Out
assign PSUMGB_data0 =   PSUM[0].PSUMGB_val? PSUM[0].PSUMGB_data : 
                        PSUM[1].PSUMGB_val? PSUM[1].PSUMGB_data :
                        PSUM[2].PSUMGB_val? PSUM[2].PSUMGB_data : 0;
assign PSUMGB_data1 =   PSUM[3].PSUMGB_val? PSUM[3].PSUMGB_data : 
                        PSUM[4].PSUMGB_val? PSUM[4].PSUMGB_data :
                        PSUM[5].PSUMGB_val? PSUM[5].PSUMGB_data : 0;
assign PSUMGB_data2 =   PSUM[6].PSUMGB_val? PSUM[6].PSUMGB_data : 
                        PSUM[7].PSUMGB_val? PSUM[7].PSUMGB_data :
                        PSUM[8].PSUMGB_val? PSUM[8].PSUMGB_data : 0;

assign PSUMGB_val0 = PSUM[0].PSUMGB_val || PSUM[1].PSUMGB_val || PSUM[2].PSUMGB_val;
assign PSUMGB_val1 = PSUM[3].PSUMGB_val || PSUM[4].PSUMGB_val || PSUM[5].PSUMGB_val;
assign PSUMGB_val2 = PSUM[6].PSUMGB_val || PSUM[7].PSUMGB_val || PSUM[8].PSUMGB_val;
assign PSUM[0].GBPSUM_rdy = GBPSUM_rdy0;
assign PSUM[1].GBPSUM_rdy = GBPSUM_rdy0;
assign PSUM[2].GBPSUM_rdy = GBPSUM_rdy0;
assign PSUM[3].GBPSUM_rdy = GBPSUM_rdy1;
assign PSUM[4].GBPSUM_rdy = GBPSUM_rdy1;
assign PSUM[5].GBPSUM_rdy = GBPSUM_rdy1;
assign PSUM[6].GBPSUM_rdy = GBPSUM_rdy2;
assign PSUM[7].GBPSUM_rdy = GBPSUM_rdy2;
assign PSUM[8].GBPSUM_rdy = GBPSUM_rdy2;

// assign test = |(PSUM[0].GEN_Mux[0].dataout + PSUM[8].GEN_Mux[0].dataout);

endmodule

module Mux_2I #( // Handshake protocol
    parameter DATA_WIDTH = 8,
    parameter FIFO_ADDR_WIDTH = 2
    )(
    input                           clk,
    input                           rst_n,
    input                           datain_val0,
    input   [ DATA_WIDTH    -1 : 0] datain0,
    output                          datain_rdy0,//paulse

    input                           datain_val1,
    input   [ DATA_WIDTH    -1 : 0] datain1,
    output                          datain_rdy1,//paulse

    input                           dataout_rdy,
    output  [ DATA_WIDTH    -1 : 0] dataout,
    output                          dataout_val //paulse
    );
    wire        fifo_push;
    wire        fifo_push0;
    wire        fifo_push1;
    wire        fifo_pop;
    wire        fifo_pop_d;
    wire        fifo_empty;
    wire        fifo_full;
    wire [ DATA_WIDTH   -1 : 0] fifo_in;
    wire [ DATA_WIDTH   -1 : 0] fifo_out;
    assign datain_rdy0 = ~fifo_full; //Supest level
    assign datain_rdy1 = ~fifo_full && ~(datain_rdy0 && datain_val0);

    // actually, posedge is GetOut ahead a clk
    assign fifo_push = datain_rdy0 && datain_val0 || datain_rdy1 && datain_val1;
    assign fifo_in = datain_rdy0 && datain_val0 ? datain0 : datain1;

    fifo_asic #( // fifo_fwft : first output a data? ??????????
        .DATA_WIDTH(DATA_WIDTH ),
        .ADDR_WIDTH(FIFO_ADDR_WIDTH )
        ) fifo_Mux(
        .clk ( clk ),
        .rst_n ( rst_n ),
        .Reset ( 1'b0),
        .push(fifo_push) ,
        .pop(fifo_pop ) ,
        .data_in( fifo_in),
        .data_out (fifo_out ),
        .empty(fifo_empty ),
        .full (fifo_full )
        );
    assign dataout = fifo_out;
    assign fifo_pop = dataout_rdy && ~fifo_empty;
    assign dataout_val = fifo_pop_d;// fifo_fwft?????? short delay

    Delay #(
        .NUM_STAGES(1),
        .DATA_WIDTH(1)
        )Delay_fifo_pop_d(
        .CLK(clk),
        .RESET_N(rst_n),
        .DIN(fifo_pop),
        .DOUT(fifo_pop_d)
        );
endmodule


module COUNT1 #(
    parameter DATA_WIDTH = 10,
    parameter ADDR_WIDTH = `C_LOG_2(DATA_WIDTH)
    )(
    input [ DATA_WIDTH    -1 : 0] din,
    output [ ADDR_WIDTH    -1 : 0] dout
    );
wire [ (DATA_WIDTH -1)*ADDR_WIDTH -1 : 0] count;

generate
    genvar i;
    for(i=0;i<DATA_WIDTH-1;i=i+1) begin: ACCUM 
        if(i==0)
            assign count[ADDR_WIDTH*i +: ADDR_WIDTH] = din[i] +din[i+1];
        else 
            assign count[ADDR_WIDTH*i +: ADDR_WIDTH]= count[ADDR_WIDTH*(i-1) +: ADDR_WIDTH] + din[i+1];    
    end    
endgenerate

assign dout = count[ADDR_WIDTH*(DATA_WIDTH - 2) +: ADDR_WIDTH];


endmodule
