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

    output                              GBFLGACT_rdy,
    input                               GBFLGACT_val,
    input   [`REGFLGACT_WR_WIDTH-1 : 0] GBFLGACT_data,  // 4B

    input                               PEBACT_rdy,//PEB
    output                              ACTPEB_val,
    output [ `REGACT_WR_WIDTH   -1 : 0] ACTPEB_data,

    input                               PEBFLGACT_rdy,//PEB
    output                              FLGACTPEB_val,
    output [`REGFLGACT_WR_WIDTH -1 : 0] FLGACTPEB_data,

    input                               GBWEI_Instr_Rdy,
    output                               WEIGB_Instr_Val,
    output  [`DATA_WIDTH         -1 : 0] WEIGB_Instr_Data,

    output                              WEIGB_Rdy,
    input                               GBWEI_Val,
    input  [`SRAMWEI_WR_WIDTH+`C_LOG_2(`MAC_NUM)-1 : 0] GBWEI_Data,

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
    input                               GBPSUM_val2
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
wire [ `ADDR_WIDTH_ALL* `MAC_NUM                        -1 : 0] Regarray_weiout_addr;
wire  [ `MAC_NUM                             -1 : 0] Regarray_weiout_Rdy;
// reg  [ `MAC_NUM                             -1 : 0] Regarray_weiout_Rdy_tmp;
wire [  `MAC_NUM                            -1 : 0] Regarray_weiout_Val;
wire [ `DATA_WIDTH * `MAC_NUM               -1 : 0] Regarray_weiout;

wire [ `MAC_NUM                             -1 : 0] SRAM_WEI_dataout_rdy;
wire [ `ADDR_WIDTH_ALL*`MAC_NUM             -1 : 0] SRAM_WEI_dataout_addr;
wire [ `MAC_NUM                             -1 : 0] SRAM_WEI_dataout_val;
wire [ `SRAMWEI_WR_WIDTH                    -1 : 0] SRAM_WEI_dataout;

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
reg [ `ADDR_WIDTH_ALL                                    -1 : 0] AddrBlockWei [0 : 32 -1]; // 1024
wire [ `ADDR_WIDTH_ALL*32                                    -1 : 0] AddrBlockWei_array; // 1024
wire [ `ADDR_WIDTH_ALL                                   -1 : 0] AddrWei [0 : 27 -1]; // 1024

wire                                                wr_en_AddrRowAct;
reg [ `C_LOG_2(`LENROW)                     -1 : 0] wr_addr_AddrRowAct;
wire [ `C_LOG_2(`REGFLGACT_WR_WIDTH)        -1 : 0] count_act_point;
reg  [ 5+8+5                                -1 : 0] count_act_row;

wire [ 4*`MAC_NUM                           -1 : 0] ARBMAC_IDActRow;

wire [ (`MAC_NUM_WIDTH+1)*`MAC_NUM      -1 : 0] ARBMAC_IDCHN;
wire [ `MAC_NUM                         -1 : 0] MAC_AddrWei_Rdy;

wire [ `MAC_NUM*2                       -1 : 0] MUX_datain_rdy;
wire [ `MAC_NUM*2                       -1 : 0] CHN_rdy;

wire [ `MAC_NUM * 9                     -1 : 0] ARBPSUM_SwitchOnMAC;

wire [ `MAC_NUM_WIDTH                   -1 : 0] IDMAC_push[ 0 : 9 -1];
wire [ 9                                -1 : 0] PSUMMAC_rdy;
wire [ 4*`MAC_NUM                       -1 : 0] ARBMAC_IDPSUM;

reg [ 5                 -1 : 0] x_axis;
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
        wire [ 4                    -1 : 0] IDActRow;
        // assign IDActRow = 
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
        wire  [8   -1 : 0] AddrRowFlgAct;
        assign AddrRowFlgAct = ARBMAC_IDActRow[4*i +: 4];
        assign Regarray_FlgActout_addr[`REGFLGACT_ADDR_WIDTH*i +: `REGFLGACT_ADDR_WIDTH] = 
                MAC_AddrFlgAct + ( AddrRowFlgAct << 4 ); // *16
        assign MAC_FlgAct_Val = Regarray_FlgActout_Val[i];
        assign MAC_FlgAct = Regarray_FlgActout[`BLOCK_DEPTH*i +: `BLOCK_DEPTH];// <<

        assign Regarray_Actout_Rdy[i] = MAC_AddrAct_Rdy;
        assign REGARRAY_ACT_RdAddr[`REGACT_ADDR_WIDTH*i +: `REGACT_ADDR_WIDTH] = 
                MAC_AddrAct + AddrRowAct[ARBMAC_IDActRow[4*i +: 4]];
        assign MAC_Act = Regarray_Actout[`DATA_WIDTH * i +: `DATA_WIDTH];
        assign MAC_Act_Val = Regarray_Actout_Val[i];

        assign regarray_flgweiout_rdy[i] = 1;

        assign MAC_FlgWei = regarray_flgweiout[ `BLOCK_DEPTH*ARBMAC_IDWei[`MAC_NUM_WIDTH*i +:`MAC_NUM_WIDTH ] +: `BLOCK_DEPTH];
        assign MAC_FlgWei_Val = regarray_flgweiout_val[ARBMAC_IDWei[`MAC_NUM_WIDTH*i +:`MAC_NUM_WIDTH ]];

        assign AddrWei[i] = MAC_AddrWei + AddrBlockWei[ARBMAC_IDWei[`MAC_NUM_WIDTH*i +:`MAC_NUM_WIDTH ]];

        wire                            regarray_weiin_rdy;
        wire                            regarray_weiin_val;
        wire [ `DATA_WIDTH*8    -1 : 0] regarray_weiin;

        REGWEI #( // bond with MAC
            .DATA_WIDTH (`DATA_WIDTH),
            .ADDR_WIDTH (10),
            .REG_ADDR_WIDTH(3),
            .WR_NUM (`REGWEI_WR_WIDTH / `DATA_WIDTH),
            .RD_NUM (1)) // two read channels
            REGARRAY_WEI // only a wei
            (
                .clk            (clk   ),
                .rst_n          (rst_n),
                .reset          (reset_wei),
                .datain_rdy     (regarray_weiin_rdy),
                .datain_addr    (Regarray_weiin_addr),
                .datain_val     (regarray_weiin_val),
                .datain         (regarray_weiin),
                .dataout_addr   (AddrWei[i]),
                .dataout_rdy    (MAC_AddrWei_Rdy), // to MAC
                .dataout_val    (MAC_Wei_Val),
                .dataout        (MAC_Wei)
            );
        assign SRAM_WEI_dataout_rdy[i] = regarray_weiin_rdy;
        assign SRAM_WEI_dataout_addr[`ADDR_WIDTH_ALL*i +: `ADDR_WIDTH_ALL] = Regarray_weiin_addr;
        assign regarray_weiin_val = SRAM_WEI_dataout_val[i];
        assign regarray_weiin = SRAM_WEI_dataout;
        assign MUXMAC_Rdy[i] = i == IDMAC_push[ARBMAC_IDPSUM[4*i +: 4]] && PSUMMAC_rdy[ARBMAC_IDPSUM[4*i +: 4]];
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
        .dataout_rdy1   (PEBACT_rdy       ),
        .dataout_val1   (ACTPEB_val       ),
        .dataout1       (ACTPEB_data       )
    );
REGARRAY #(
    .DATA_WIDTH (`DATA_WIDTH),
    .ADDR_WIDTH(`REGACT_ADDR_WIDTH),
    .REG_ADDR_WIDTH(4),
    .WR_NUM (`REGACT_WR_WIDTH/`DATA_WIDTH),
    .RD_NUM (`MAC_NUM))
REGARRAY_ACT
    (
        .clk            (clk),
        .rst_n          (rst_n),
        .reset          (reset_act),
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
        .datain_rdy   (GBFLGACT_rdy        ),
        .datain_val   (GBFLGACT_val         ),
        .datain       (GBFLGACT_data        ),
        .dataout_rdy0 (REGARRAY_FLGACT_WrReq  ),
        .dataout_val0 (REGARRAY_FLGACT_WrEn   ),
        .dataout0     (REGARRAY_FLGACT_WrDat  ),
        .dataout_rdy1 (PEBFLGACT_rdy        ),
        .dataout_val1 (FLGACTPEB_val        ),
        .dataout1     (FLGACTPEB_data        )
    );
REGARRAY #(
    .DATA_WIDTH (`BLOCK_DEPTH),
    .ADDR_WIDTH(`REGFLGACT_ADDR_WIDTH),//256*1024/32 = 256*32 -> 13
    .REG_ADDR_WIDTH(3),
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
    end else if ( x_axis == 16 ) begin
        AddrRowAct[wr_addr_AddrRowAct] <= count_act_row;
    end
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        count_act_row <= 0;
    end else if ( reset_act) begin 
        count_act_row <= 0;
    end else if ( wr_en_AddrRowAct ) begin
        count_act_row <= count_act_row + count_act_point;
    end
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        x_axis <= 0;
    end else if ( x_axis == 16 && !wr_en_AddrRowAct  ) begin
        x_axis <= 0;
    end else if ( x_axis == 16 && wr_en_AddrRowAct  ) begin
        x_axis <= 1; 
    end else if ( wr_en_AddrRowAct ) begin
        x_axis <= x_axis + 1;
    end
end


COUNT1 #(
    .DATA_WIDTH(`REGFLGACT_WR_WIDTH))
    COUNT1_FLGACT(
    .din(REGARRAY_FLGACT_WrDat),
    .dout(count_act_point));


SRAM_WEI #(
    .IN_DATA_WIDTH ( `SRAMWEI_WR_WIDTH),
    .OUT_DATA_WIDTH( `REGWEI_WR_WIDTH), // 8B or 16B??
    .RD_NUM ( `MAC_NUM),
    .ADDR_WIDTH(2),
    .ADDR_WIDTH_ALL(`ADDR_WIDTH_ALL)
 )inst_SRAM_WEI( 
    .clk            (clk),
    .rst_n          (rst_n),

    .instrout_rdy (GBWEI_Instr_Rdy ),
    .instrout_val (WEIGB_Instr_Val ),
    .instrout     (WEIGB_Instr_Data),
    .datain_rdy   (WEIGB_Rdy       ),
    .datain_val   (GBWEI_Val       ),
    .datain       (GBWEI_Data      ),
    .AddrBlockWei (AddrBlockWei_array),
    .ARBMAC_IDWei (ARBMAC_IDWei),
    .dataout_rdy  (SRAM_WEI_dataout_rdy),
    .dataout_addr (SRAM_WEI_dataout_addr),
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

generate
    genvar block;
    for(block=0;block<32;block=block+1) begin
        assign AddrBlockWei_array[`ADDR_WIDTH_ALL*block +: `ADDR_WIDTH_ALL] = AddrBlockWei[block];
    end
    
endgenerate

wire [ `MAC_NUM_WIDTH        -1 : 0] MEM_ARBCHN_IDMAC_Help [0: `MAC_NUM*2 -1] ;
ARB inst_ARB
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .PEBARB_Sta         (next_block),
        .ARBPEB_Fnh         (ARBPEB_Fnh), // level

        .MAC_ReqHelp        (MACARB_ReqHelp),
        .PSUMARB_rdy        (PSUMARB_rdy),

        .ARBMAC_Rst         (ARBMAC_Rst),
        .ARBMAC_IDActRow    (ARBMAC_IDActRow),
        .ARBMAC_IDWei       (ARBMAC_IDWei),
        .ARBMAC_IDPSUM       (ARBMAC_IDPSUM),

        // .ARBCHN_IDMAC_Help (ARBCHN_IDMAC_Help),
        // .ARBWEI_IDMAC
        .ARBPSUM_SwitchOnMAC  ( ARBPSUM_SwitchOnMAC)
    );
wire [ `MAC_NUM_WIDTH       -1 : 0] wire_IDMAC_push[ 0 : 9 -1];
generate
    genvar j;
    for(j=0;j<9;j=j+1) begin: PSUM // ??????

        wire                                    datain_val;
        wire                                    datain_rdy;
        wire [ `PSUM_WIDTH + `PSUM_ADDR_WIDTH-1 : 0] datain;
        wire                                    dataout_val;
        wire                                    dataout_rdy;
        wire [ `PSUM_WIDTH + `PSUM_ADDR_WIDTH-1 : 0] dataout;

        wire                                    MACPSUM_fnh;
        wire                                    psumaddr_val;

        wire                                    PSUMGB_val;
        wire [ `PSUM_WIDTH * `LENROW    -1 : 0] PSUMGB_data;
        wire                                    GBPSUM_rdy ;
        wire                                    GBPSUM_val;
        wire [ `PSUM_WIDTH * `LENROW    -1 : 0] GBPSUM_data;
        wire                                    PSUMGB_rdy ;

        //Switch on's MAC are finished
        // assign MACPSUM_fnh  = (ARBPSUM_SwitchOnMAC [`MAC_NUM *j +: `MAC_NUM] & MACARB_ReqHelp) == ARBPSUM_SwitchOnMAC [`MAC_NUM *j +: `MAC_NUM]; 
        assign MACPSUM_fnh = ~|ARBPSUM_SwitchOnMAC [`MAC_NUM *j +: `MAC_NUM] && ~datain_val ; //BUG: && fifo
        assign datain = {  MACMUX_Psum[IDMAC_push[j]], MACMUX_Addr[IDMAC_push[j]]};

        assign datain_val = | (ARBPSUM_SwitchOnMAC [`MAC_NUM *j +: `MAC_NUM] & MACMUX_Val); // BUG
        assign PSUMMAC_rdy [j] = datain_rdy;

        ARRAY2ID #(
            .ARRAY_WIDTH(`MAC_NUM))
            ARRAY2ID_IDMAC_push( // Help other
            .Array(ARBPSUM_SwitchOnMAC [`MAC_NUM *j +: `MAC_NUM] & MACMUX_Val),
            .ID(wire_IDMAC_push[j]),
            .Array_One( )
            );
        Delay #(
        .NUM_STAGES(1),
        .DATA_WIDTH(`MAC_NUM_WIDTH)
        )Delay_IDMAC_push(
        .CLK(clk),
        .RESET_N(rst_n),
        .DIN(wire_IDMAC_push[j]),
        .DOUT(IDMAC_push[j])
        );
        Mux_2I #(
            .DATA_WIDTH(`PSUM_WIDTH + `PSUM_ADDR_WIDTH ),
            .FIFO_ADDR_WIDTH(1)
            )Mux_2I(
            .clk(clk),
            .rst_n(rst_n),
            .datain_val0(datain_val),
            .datain0(datain),
            .datain_rdy0(datain_rdy),
            .datain_val1(0),
            .datain1(0),
            .datain_rdy1(),
            .dataout_rdy(dataout_rdy),
            .dataout(dataout),
            .dataout_val(dataout_val)
            );
        PSUM inst_PSUM
        (
            .clk          (clk),
            .rst_n        (rst_n),
            .reset        (next_block),
            .PSUMARB_rdy  (PSUMARB_rdy[j]),
            .MACPSUM_fnh  (MACPSUM_fnh),
            .psumaddr_val (dataout_val),
            .psumaddr     (dataout),
            .psumaddr_rdy (dataout_rdy),
            .datain_val     (GBPSUM_val ),
            .datain         (GBPSUM_data),
            .datain_rdy     (PSUMGB_rdy),
            .dataout_val    (PSUMGB_val),
            .dataout        (PSUMGB_data),
            .dataout_rdy    (GBPSUM_rdy )
        );
    end
endgenerate
// assign CHN_rdy = ARBCHN_Switch & MUX_datain_rdy;

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

    fifo_fwft #(
            .DATA_WIDTH(DATA_WIDTH),
            .ADDR_WIDTH(FIFO_ADDR_WIDTH)
        ) inst_fifo_fwft (
            .clk        (clk),
            .Reset      (1'b0),
            .rst_n      (rst_n),
            .push       (fifo_push),
            .pop        (fifo_pop),
            .data_in    (fifo_in),
            .data_out   (fifo_out),
            .empty      (fifo_empty),
            .full       (fifo_full),
            .fifo_count ()
        );

    assign dataout = fifo_out;
    assign fifo_pop = dataout_rdy && ~fifo_empty;
    assign dataout_val = ~fifo_empty;// fifo_fwft?????? short delay

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
    output reg[ ADDR_WIDTH    -1 : 0] dout
    );
wire [ (DATA_WIDTH -1)*ADDR_WIDTH -1 : 0] count;

integer i;
always@(*) begin
    dout = 0;
    for(i=0; i< DATA_WIDTH; i=i+1) begin
        if(din[i])
            dout = dout + 1;
    end
end 

endmodule
