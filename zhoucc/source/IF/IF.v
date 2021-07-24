//======================================================
// Copyright (C) 2020 By zhoucc
// All Rights Reserved
//======================================================
// Module : IF
// Author : CC zhou
// Contact :
// Date : 3 .8 .2020
//=======================================================
// Description :
//========================================================
`include "../source/include/dw_params_presim.vh"
module IF #(
    parameter PORT_WIDTH = 128,
    parameter ASYSFIFO_ADDRWIDTH = 5
    )(


    input                                   clk         , // TS3D
    input                                   rst_n       ,
    input                                   reset       ,
    // Interface 
    output                                  IFGB_cfg_rdy,
    input                                   GBIF_cfg_val,
    input   [ 4                     -1 : 0] GBIF_cfg_info, // {id, w/r}
    // 
    output                                  IFGB_wr_rdy,
    input                                   GBIF_wr_val,
    input   [ PORT_WIDTH            -1 : 0] GBIF_wr_data,
    // cfg -> flagwei > wei_address > wei > flagact > act
    output                                  IFGB_rd_val,
    input                                   GBIF_rd_rdy,
    output  [PORT_WIDTH             -1 : 0] IFGB_rd_data,

    input                                   O_spi_sck   , //FPGA //PAD 100 pad
    input   [ PORT_WIDTH            -1 : 0] I_spi_data  ,
    output  [ PORT_WIDTH            -1 : 0] O_spi_data  ,
    input                                   O_spi_cs_n  , //FPGA //PAD
    output                                  config_req  , //FPGA //PAD
    output                                  near_full   ,
    output  reg                             switch_rdwr 

);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================


//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
wire [PORT_WIDTH        -1 : 0] O_spi_data_rd   ;
wire [PORT_WIDTH        -1 : 0] O_spi_data_wr   ;
// wire                            switch_rdwr     ;
wire                            config_req_rd   ;
wire                            config_req_wr   ;
reg  [ 3                -1 : 0] cfg_data        ;
wire                            rd_cfg_pls      ;
wire                            wr_cfg_pls      ;
wire                            rd_cfg_rdy      ;
wire                            wr_cfg_rdy      ;
wire HandShake;
//=====================================================================================================================
// Logic Design :
//=====================================================================================================================


assign O_spi_data = switch_rdwr ? O_spi_data_rd : O_spi_data_wr;
assign config_req = switch_rdwr ? config_req_rd : config_req_wr;

assign HandShake = GBIF_cfg_val && IFGB_cfg_rdy;

always @ ( posedge clk or negedge rst_n ) begin
    if(~ rst_n) begin
        {cfg_data, switch_rdwr} <= 0; // 0: write; 1 read;
    end else if ( HandShake ) begin
        {cfg_data, switch_rdwr} <= GBIF_cfg_info;//
    end
end

assign rd_cfg_pls = HandShake && GBIF_cfg_info[0]; // 1 : read
assign wr_cfg_pls = HandShake && ~GBIF_cfg_info[0]; // 0 : write

assign IFGB_cfg_rdy = rd_cfg_rdy && wr_cfg_rdy;

//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================


top_asyncFIFO_rd #(
        .SPI_WIDTH(PORT_WIDTH),
        .ADDR_WIDTH_FIFO(ASYSFIFO_ADDRWIDTH)
    ) top_asyncFIFO_rd0 (
        .clk_chip      (clk),
        .reset_n_chip  (rst_n),
        .O_spi_sck     (O_spi_sck),
        .I_spi_data    (I_spi_data),
        .O_spi_data    (O_spi_data_rd),
        .O_spi_cs_n    (O_spi_cs_n),
        .config_req    (config_req_rd),
        .full          (near_full      ),
        .config_ready  (rd_cfg_rdy),
        .config_paulse (rd_cfg_pls),
        .config_data   ({1'b0,GBIF_cfg_info[1+:3]}),
        .O_config_data (  ),
        .rd_req        (GBIF_rd_rdy),
        .rd_valid      (IFGB_rd_val),
        .rd_data       (IFGB_rd_data),
        .rd_done       ( IF_RdDone)
    );


top_asyncFIFO_wr #(
        .SPI_WIDTH(PORT_WIDTH),
        .ADDR_WIDTH_FIFO(ASYSFIFO_ADDRWIDTH)
    ) top_asyncFIFO_wr (
        .clk_chip      (clk),
        .reset_n_chip  (rst_n),
        .O_spi_sck     (O_spi_sck),
        .IO_spi_data   (O_spi_data_wr),
        .O_spi_cs_n    (O_spi_cs_n ),
        .config_req    (config_req_wr),//save enough, then req to FPGA
        .config_ready  (wr_cfg_rdy),
        .config_paulse (wr_cfg_pls),
        .config_data   ({1'b0,GBIF_cfg_info[1+:3]}),
        .wr_ready      (IFGB_wr_rdy),
        .wr_req        (GBIF_wr_val && IFGB_wr_rdy),
        .wr_data       (GBIF_wr_data)
    );



endmodule
