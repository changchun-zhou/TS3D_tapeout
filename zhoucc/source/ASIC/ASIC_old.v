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
// File   : ASIC.v
// Create : 2020-07-14 16:21:51
// Revise : 2020-08-05 11:10:11
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`include "../source/include/dw_params_presim.vh"
module ASIC (
    input                           I_reset_n       ,
    input                           I_reset_dll     ,
    inout[ `PORT_WIDTH -1 : 0 ] IO_spi_data     ,
    input                           I_spi_sck       ,
    input                           I_spi_cs_n      ,
    input                           I_OE_req        ,
    output                          O_config_req    ,
    output                          O_near_full     ,
    output                          O_switch_rdwr   ,
    input                           I_bypass        ,
    output                          O_clk_out       ,
    input                           I_clk_in        ,
    input                           I_SW                                       

);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================





//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================


wire                                 clk            ; // TS3D
wire                                 rst_n          ;
wire                                 reset          ;
wire                                 IFGB_cfg_rdy   ;
wire                                 GBIF_cfg_val   ;
wire [ 4                     -1 : 0] GBIF_cfg_info  ; // {id, w/r}
wire                                 IFGB_wr_rdy    ;
wire                                 GBIF_wr_val    ;
wire [ `PORT_WIDTH            -1 : 0] GBIF_wr_data   ;
wire                                 IFGB_rd_val    ;
wire                                 GBIF_rd_rdy    ;
wire [`PORT_WIDTH             -1 : 0] IFGB_rd_data   ;
wire                                 O_spi_sck      ; //FPGA //PAD 100 pad
wire [ `PORT_WIDTH       -1 : 0] I_spi_data     ;
wire [ `PORT_WIDTH       -1 : 0] O_spi_data     ;
wire                                 O_spi_cs_n     ; //FPGA //PAD
wire                                 config_req     ; //FPGA //PAD
wire                                 near_full      ;
wire                                 switch_rdwr    ;
                                
//=====================================================================================================================
// Logic Design :
//=====================================================================================================================
wire                                OE_req_rd       ;
// wire                                config_req_rd   ;
reg                                 pad_OE_rd       ;

wire                                DLL_BYPASS_i    ;
wire                                DLL_S1_i        ;
wire                                clk_to_dll_i    ;

wire                                S0_dll          ;

always @ ( posedge clk ) begin
    pad_OE_rd <= ( config_req && !OE_req_rd )|| ~switch_rdwr; // PAD turns direction needs time: default = 0 write
end

//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================
supply0 VSS,VSSIO,VSSA;
supply1 VDD,VDDIO,VDDA;

IPOC    IPOC_cell           (.PORE(PORE     ), .VDD  (VDD ), .VSS(VSS ), .VDDIO(VDDIO));
IUMBFS  reset_n_PAD         (.DO (1'b0      ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (rst_n        ), .PAD (I_reset_n        ), .PORE (PORE));
IUMBFS  reset_dll_PAD       (.DO (1'b0      ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (reset_dll    ), .PAD (I_reset_dll      ), .PORE (PORE));
IUMBFS  BYPASS_PAD          (.DO (1'b0      ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (DLL_BYPASS_i ), .PAD (I_bypass   ), .PORE (PORE));
IUMBFS  DLL_CLOCK_OUT_PAD   (.DO (clk       ), .IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b1), .PIN2 (1'b1), .PU (1'b0), .SMT (1'b0), .DI (             ), .PAD (O_clk_out  ), .PORE (PORE));
// IUMBFS  DLL_clk_PAD         (.DO (1'b0      ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b1), .PIN2 (1'b1), .PU (1'b0), .SMT (1'b0), .DI (clk          ), .PAD (I_clk_in   ), .PORE (PORE));
assign clk = I_clk_in;
IUMBFS  S0_dll_PAD          (.DO (1'b0      ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (S0_dll       ), .PAD (I_SW                    ), .PORE (PORE));
//wire outclk_dll;
//  DLL DLL_i (.CLK(clk), .RST(reset_dll), .BYPASS(DLL_BYPASS_i), .S1(1'b0), .S0( S0_dll), .OUTCLK(outclk_dll ), .VDDA(VDDA), .VSSA(VSSA) );

generate
  genvar k;
  for ( k=0; k<`PORT_WIDTH; k=k+1 ) begin: IO_spi_data_PAD_rd0_GEN
    IUMBFS IO_spi_data_PAD_rd0 (.DO (O_spi_data[k]), .IDDQ (1'b0), .IE (1'b1), .OE (pad_OE_rd), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (I_spi_data[k]), .PAD (IO_spi_data[k]), .PORE (PORE));
  end
endgenerate

// IUMBFS  O_spi_sck_PAD_rd0   (.DO ( 1'b0      ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (O_spi_sck    ), .PAD (I_spi_sck ), .PORE (PORE));
assign O_spi_sck = I_spi_sck;
IUMBFS  O_spi_cs_n_PAD_rd0  (.DO ( 1'b0      ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (O_spi_cs_n   ), .PAD (I_spi_cs_n), .PORE (PORE));
IUMBFS  OE_req_PAD_rd0      (.DO ( 1'b0      ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (OE_req_rd    ), .PAD (I_OE_req    ), .PORE (PORE));
IUMBFS  near_full_PAD_rd0   (.DO (near_full  ), .IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b1), .PIN2 (1'b1), .PU (1'b0), .SMT (1'b0), .DI (             ), .PAD (O_near_full ), .PORE (PORE));
IUMBFS  Switch_RdWr_PAD     (.DO (switch_rdwr), .IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b1), .PIN2 (1'b1), .PU (1'b0), .SMT (1'b0), .DI (             ), .PAD (O_switch_rdwr   ), .PORE (PORE));
IUMBFS  config_req_PAD_rd0  (.DO ( config_req), .IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (             ), .PAD (O_config_req), .PORE (PORE));


IF #(
    .PORT_WIDTH(`PORT_WIDTH),
    .ASYSFIFO_ADDRWIDTH(`ASYSFIFO_ADDRWIDTH)
    ) inst_IF (
        .clk           (clk             ),
        .rst_n         (rst_n           ),
        .reset         (1'b0           ),
        .IFGB_cfg_rdy  (IFGB_cfg_rdy    ),
        .GBIF_cfg_val  (GBIF_cfg_val    ),
        .GBIF_cfg_info (GBIF_cfg_info   ),
        .IFGB_wr_rdy   (IFGB_wr_rdy     ),
        .GBIF_wr_val   (GBIF_wr_val     ),
        .GBIF_wr_data  (GBIF_wr_data    ),
        .IFGB_rd_val   (IFGB_rd_val     ),
        .GBIF_rd_rdy   (GBIF_rd_rdy     ),
        .IFGB_rd_data  (IFGB_rd_data    ),
        .O_spi_sck     (O_spi_sck       ),
        .I_spi_data    (I_spi_data      ),
        .O_spi_data    (O_spi_data      ),
        .O_spi_cs_n    (O_spi_cs_n      ),
        .config_req    (config_req      ),
        .near_full     (near_full       ),
        .switch_rdwr   (switch_rdwr     )
    );

TS3D  TS3D (
    .clk                    ( clk               ),
    .rst_n                  ( rst_n             ),
    .IFGB_cfg_rdy           ( IFGB_cfg_rdy      ),
    .GBIF_cfg_val           ( GBIF_cfg_val      ),
    .GBIF_cfg_info          ( GBIF_cfg_info     ),
    .IFGB_wr_rdy            ( IFGB_wr_rdy       ),
    .GBIF_wr_val            ( GBIF_wr_val       ),
    .GBIF_wr_data           ( GBIF_wr_data      ),
    .IFGB_rd_val            ( IFGB_rd_val       ),
    .GBIF_rd_rdy            ( GBIF_rd_rdy       ),
    .IFGB_rd_data           ( IFGB_rd_data      )
);


  IVDDFS \genblk1[0].u_PVDD1 (.VDD (VDD), .VSS (VSS));
  IVSSFS \genblk1[0].u_PVSS1 (.VDDIO (VDDIO), .VSS (VSS), .VSSIO (VSSIO));
  IVDDFS \genblk1[1].u_PVDD1 (.VDD (VDD), .VSS (VSS));
  IVSSFS \genblk1[1].u_PVSS1 (.VDDIO (VDDIO), .VSS (VSS), .VSSIO (VSSIO));
  IVDDFS \genblk1[2].u_PVDD1 (.VDD (VDD), .VSS (VSS));
  IVSSFS \genblk1[2].u_PVSS1 (.VDDIO (VDDIO), .VSS (VSS), .VSSIO (VSSIO));
  IVDDFS \genblk1[3].u_PVDD1 (.VDD (VDD), .VSS (VSS));
  IVSSFS \genblk1[3].u_PVSS1 (.VDDIO (VDDIO), .VSS (VSS), .VSSIO (VSSIO));
  IVDDFS \genblk1[4].u_PVDD1 (.VDD (VDD), .VSS (VSS));
  IVSSFS \genblk1[4].u_PVSS1 (.VDDIO (VDDIO), .VSS (VSS), .VSSIO (VSSIO));
  IVDDFS \genblk1[5].u_PVDD1 (.VDD (VDD), .VSS (VSS));
  IVSSFS \genblk1[5].u_PVSS1 (.VDDIO (VDDIO), .VSS (VSS), .VSSIO (VSSIO));
  IVDDFS \genblk1[6].u_PVDD1 (.VDD (VDD), .VSS (VSS));
  IVSSFS \genblk1[6].u_PVSS1 (.VDDIO (VDDIO), .VSS (VSS), .VSSIO (VSSIO));
  IVDDFS \genblk1[7].u_PVDD1 (.VDD (VDD), .VSS (VSS));
  IVSSFS \genblk1[7].u_PVSS1 (.VDDIO (VDDIO), .VSS (VSS), .VSSIO (VSSIO));

  IVDDIOFS \genblk2[0].u_PVDDIO1 (.VDDIO (VDDIO), .VSSIO (VSSIO));
  IVSSIOFS \genblk2[0].u_PVSSIO1 (.VDD (VDD), .VSS (VSS), .VSSIO (VSSIO));
  IVDDIOFS \genblk2[1].u_PVDDIO1 (.VDDIO (VDDIO), .VSSIO (VSSIO));
  IVSSIOFS \genblk2[1].u_PVSSIO1 (.VDD (VDD), .VSS (VSS), .VSSIO (VSSIO));
  IVDDIOFS \genblk2[2].u_PVDDIO1 (.VDDIO (VDDIO), .VSSIO (VSSIO));
  IVSSIOFS \genblk2[2].u_PVSSIO1 (.VDD (VDD), .VSS (VSS), .VSSIO (VSSIO));
  IVDDIOFS \genblk2[3].u_PVDDIO1 (.VDDIO (VDDIO), .VSSIO (VSSIO));
  IVSSIOFS \genblk2[3].u_PVSSIO1 (.VDD (VDD), .VSS (VSS), .VSSIO (VSSIO));
  IVDDIOFS \genblk2[4].u_PVDDIO1 (.VDDIO (VDDIO), .VSSIO (VSSIO));
  IVSSIOFS \genblk2[4].u_PVSSIO1 (.VDD (VDD), .VSS (VSS), .VSSIO (VSSIO));
  IVDDIOFS \genblk2[5].u_PVDDIO1 (.VDDIO (VDDIO), .VSSIO (VSSIO));
  IVSSIOFS \genblk2[5].u_PVSSIO1 (.VDD (VDD), .VSS (VSS), .VSSIO (VSSIO));
  IVDDIOFS \genblk2[6].u_PVDDIO1 (.VDDIO (VDDIO), .VSSIO (VSSIO));
  IVSSIOFS \genblk2[6].u_PVSSIO1 (.VDD (VDD), .VSS (VSS), .VSSIO (VSSIO));
  IVDDIOFS \genblk2[7].u_PVDDIO1 (.VDDIO (VDDIO), .VSSIO (VSSIO));
  IVSSIOFS \genblk2[7].u_PVSSIO1 (.VDD (VDD), .VSS (VSS), .VSSIO (VSSIO));

  IVDDANACFS VDDA_dll_pad (.VDDANAC(VDDA), .VSSANAC(VSSA));
  IVSSANACFS VSSA_dll_pad (.VDDANAC(VDDA), .VSSANAC(VSSA));

endmodule
