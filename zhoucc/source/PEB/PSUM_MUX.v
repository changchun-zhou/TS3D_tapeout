//======================================================
// Copyright (C) 2019 By zhoucc
// All Rights Reserved
//======================================================
// Module : GEN_Mux
// Author : CC zhou
// Contact : 
// Date :  . .2019
//=======================================================
// Description :
//========================================================
`include "../source/include/dw_params_presim.vh"
module PSUM_MUX (
    input                                       clk     ,
    input                                       rst_n   ,

    input[ `MAC_NUM_WIDTH * 6           -1 : 0] ARBCHN_IDMAC_Help      ,
    input [6                            -1 : 0] ARBCHN_Switch     ,

    output [ 6                          -1 : 0] MUX_datain_rdy,
    input [ `MAC_NUM                    -1 : 0] MACMUX_Val,
    input [ `PSUM_ADDR_WIDTH*`MAC_NUM   -1 : 0] MACMUX_Addr,  
    input [ `PSUM_WIDTH*`MAC_NUM        -1 : 0] MACMUX_Psum,  
    input [ `MAC_NUM                    -1 : 0] MACARB_ReqHelp,

    output [3                           -1 : 0] MUXPSUM_Fnh,
    input  [3                           -1 : 0]    dataout_rdy,
    output [3                           -1 : 0]     dataout_val,
    output [ (`PSUM_WIDTH + `PSUM_ADDR_WIDTH + 1)*3       -1 : 0]     dataout

);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================





//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================





//=====================================================================================================================
// Logic Design :
//=====================================================================================================================

generate
    genvar jx;
    for(jx=0;jx<3;jx=jx+1) begin: GEN_Mux
        wire [ `PSUM_WIDTH + `PSUM_ADDR_WIDTH + 1       -1 : 0] datain0;
        wire [ `PSUM_WIDTH + `PSUM_ADDR_WIDTH + 1       -1 : 0] datain1;

        wire                datain_val0;     
        wire                datain_rdy0;     
        wire                datain_val1;     
        wire                datain_rdy1; 
        // wire                dataout_rdy;   
        // wire                dataout_val; 

        // wire                MUXPSUM_Fnh;
        // CHN0
        assign datain0 = {  MACMUX_Psum[ARBCHN_IDMAC_Help[5*((jx)*2) +: 5]],
                            MACMUX_Addr[ARBCHN_IDMAC_Help[5*((jx)*2) +: 5]]};
        assign datain_val0 = ARBCHN_Switch[(jx)*2] && MACMUX_Val[ARBCHN_IDMAC_Help[5*((jx)*2) +: 5]];// condition??
        // assign MUXMAC_Rdy[ARBCHN_IDMAC_Help[5*((jx)*2) +: 5]] = ARBCHN_Switch[(jx)*2] && datain_rdy0;

        // CHN1
        assign datain1 = {  MACMUX_Psum[ARBCHN_IDMAC_Help[5*((jx)*2+1) +: 5]], 
                            MACMUX_Addr[ARBCHN_IDMAC_Help[5*((jx)*2+1) +: 5]]};
        assign datain_val1 = ARBCHN_Switch[(jx)*2+1] && MACMUX_Val[ARBCHN_IDMAC_Help[5*((jx)*2+1) +: 5]];
        // assign MUXMAC_Rdy[ARBCHN_IDMAC_Help[5*((jx)*2+1) +: 5]] = ARBCHN_Switch[(jx)*2+1] && datain_rdy1;

        // (ch0: off or finish) && ((ch1: off or finish))
        assign MUXPSUM_Fnh[jx] =    (~ARBCHN_Switch[(jx)*2] || MACARB_ReqHelp[ARBCHN_IDMAC_Help[5*((jx)*2) +: 5]]) && 
                                (~ARBCHN_Switch[(jx)*2+1] || MACARB_ReqHelp[ARBCHN_IDMAC_Help[5*((jx)*2+1) +: 5]]);
        // ** 2 input 1 output ****
        Mux_2I #(
            .DATA_WIDTH(`PSUM_WIDTH + `PSUM_ADDR_WIDTH ),
            .FIFO_ADDR_WIDTH(1)
            )Mux_2I(
            .clk(clk),
            .rst_n(rst_n),
            .datain_val0(datain_val0),
            .datain0(datain0),
            .datain_rdy0(MUX_datain_rdy[jx*2]),
            .datain_val1(datain_val1),
            .datain1(datain1),
            .datain_rdy1(MUX_datain_rdy[jx*2+1]),
            .dataout_rdy(dataout_rdy[jx]),
            .dataout(dataout[(`PSUM_WIDTH + `PSUM_ADDR_WIDTH + 1)*jx +: (`PSUM_WIDTH + `PSUM_ADDR_WIDTH + 1)]),
            .dataout_val(dataout_val[jx])
            );
    end
endgenerate




//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================


endmodule