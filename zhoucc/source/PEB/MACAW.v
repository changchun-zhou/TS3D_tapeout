//======================================================
// Copyright (C) 2019 By zhoucc
// All Rights Reserved
//======================================================
// Module : MACAW
// Author : CC zhou
// Contact :
// Date : 3 .1 .2019
//=======================================================
// Description :
//========================================================
`include "../source/include/dw_params_presim.vh"
module MACAW(
    input                                                       clk     ,
    input                                                       rst_n   ,
    input                                                       PECMAC_Sta      ,
    output                                                      MACPEC_Fnh,//level; same time
    input [ `BLOCK_DEPTH                                -1 : 0] PECMAC_FlgAct,
    input [ `DATA_WIDTH                                 -1 : 0] PECMAC_Act,
    input [ `BLOCK_DEPTH                                -1 : 0] PECMAC_FlgWei,
    input [ `DATA_WIDTH                                 -1 : 0] PECMAC_Wei, // trans
    input                                                       PECMAC_ActWei_Val,
    output                                                      MACAW_ValOffset,// level
    // output                                                      MACAW_last_offset,
    output [ `C_LOG_2(`BLOCK_DEPTH)                     -1 : 0] MACAW_OffsetWei,
    output [ `C_LOG_2(`BLOCK_DEPTH)                     -1 : 0] MACAW_OffsetAct,
    input [ `DATA_WIDTH * 2+ `C_LOG_2(`BLOCK_DEPTH*3)      -1 : 0] MACMAC_Mac,
    output reg[ `DATA_WIDTH * 2 + `C_LOG_2(`BLOCK_DEPTH*3)  -1 : 0] MACCNV_Mac

);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================
wire O_ValFlag;
reg O_ValFlag_d;
wire [`C_LOG_2(`BLOCK_DEPTH) -1 : 0 ]AddrAct;
wire [`C_LOG_2(`BLOCK_DEPTH) -1 : 0 ]AddrWei;

//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================


// assign MACPEC_Fnh = ~O_ValFlag;
// assign MACAW_ValOffset = O_ValFlag_d;// offset is 1 clk after Valid Flag

//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================

FLGOFFSET #(
        .DATA_WIDTH(`BLOCK_DEPTH)
    ) inst_FLGOFFSET (
        .clk        (clk),
        .rst_n      (rst_n),
        .I_Sta      (PECMAC_Sta),
        .I_ActWei_Val (PECMAC_ActWei_Val ),// can compute next address
        .I_ActFlag  (PECMAC_FlgAct),
        .I_WeiFlag  (PECMAC_FlgWei),
        .O_Offset_val  (MACAW_ValOffset),// >>>>>??
        .O_fnh     (MACPEC_Fnh),
        .O_Offset_Act (MACAW_OffsetAct),
        .O_Offset_Wei (MACAW_OffsetWei)
    );

always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
        MACCNV_Mac <= 0;
    end else if ( PECMAC_Sta ) begin
        MACCNV_Mac <= MACMAC_Mac;
    end else if ( PECMAC_ActWei_Val && MACAW_ValOffset ) begin
        MACCNV_Mac <= $signed(MACCNV_Mac) + $signed(PECMAC_Act) * $signed(PECMAC_Wei);
    end
end
// always @ ( posedge clk or negedge rst_n ) begin
//     if ( !rst_n ) begin
//         O_ValFlag_d <= 0;
//     end else begin
//         O_ValFlag_d <= O_ValFlag;
//     end
// end
endmodule
