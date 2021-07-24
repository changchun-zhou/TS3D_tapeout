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

`ifndef top
  `define top

// `include "../tb/TEST.sv"
// `include "../tb/DUMP.sv"    
`timescale 1ns/100ps
module top;

  int DataNum = $urandom % 40959;
  int FlagNum = $urandom % 10239;

  bit clk;
  bit sck;
  bit rst_n;
  bit next_block;
  bit reset_act;
  bit reset_wei;
  bit ARBPEB_Fnh;
  
  bit DumpStart;
  bit DumpEnd;
  bit CCUPOOL_reset;
  // System Clock and Reset
  always #5 clk = ~clk;
  always #8 sck = ~sck;
initial begin
    rst_n = 1;
    #20 rst_n = 0;
    #20 rst_n = 1;
end
  // DATA_IF data_if(clk);
  // `ifdef DUMP_EN
  //   DUMP DUMP_U(clk, DumpStart, DumpEnd);
  // `endif
  // TEST TEST_U(clk, data_if, DataNum, FlagNum);
  
// *****************************************************************************
// inst_ASIC
// *****************************************************************************
wire                        I_OE_req;
wire [ `PORT_WIDTH  -1 : 0] IO_spi_data;
wire [ `PORT_WIDTH  -1 : 0] I_spi_data;
reg [ `PORT_WIDTH  -1 : 0] O_spi_data;

wire                        O_config_req;
wire                        O_near_full;
wire                        O_switch_rdwr;
reg                         I_spi_cs_n;
    ASIC ASIC_U
        (
            .I_reset_n     (rst_n),
            .I_reset_dll   (1'b0),
            .I_clk_in      (clk),
            .I_bypass      (1'b0),
            .I_SW0         (1'b0),
            .I_SW1         (1'b0),
            .O_DLL_lock    (),
            .O_clk_out     (),
            .O_sck_out     (),
            .IO_spi_data   (IO_spi_data),
            .O_config_req  (O_config_req),
            .O_near_full   (O_near_full),
            .O_switch_rdwr (O_switch_rdwr),
            .I_OE_req      (I_OE_req),
            .I_spi_cs_n    (I_spi_cs_n),
            .I_spi_sck     (sck),
            .I_in_1        (),
            .I_in_2        (),
            .I_bypass_fifo (1'b0)
        );
supply0 VSS,VSSIO,VSSA;
supply1 VDD,VDDIO,VDDA;
IPOC    IPOC_cell           (.PORE(PORE     ), .VDD  (VDD ), .VSS(VSS ), .VDDIO(VDDIO));
generate
  genvar i;
  for ( i=0; i<`PORT_WIDTH; i=i+1 ) begin: PAD
    IUMBFS IO_spi_data_PAD (.DO (O_spi_data[i]), .IDDQ (1'b0), .IE (1'b1), .OE (~I_OE_req), .PD (1'b0), .PIN1 (1'b1), .PIN2 (1'b1), .PU (1'b0), .SMT (1'b0), .DI (I_spi_data[i]), .PAD (IO_spi_data[i]), .PORE (PORE));
  end
endgenerate

// assign GBIF_cfg_info = I_spi_data;
// assign O_spi_data = IFGB_rd_data;
// assign GBIF_wr_data = I_spi_data;

// reg [ 4                        -1 : 0] GBIF_cfg_info_d;
// always @ ( posedge clk or negedge rst_n ) begin
//     if ( !rst_n ) begin
//         GBIF_cfg_info_d <= 0;
//     end else if ( GBIF_cfg_val && IFGB_cfg_rdy ) begin
//         GBIF_cfg_info_d <= I_spi_data;
//     end
// end
// assign GBIF_cfg_info = GBIF_cfg_val && IFGB_cfg_rdy ? I_spi_data : GBIF_cfg_info_d;
// assign I_OE_req = GBIF_cfg_val && IFGB_cfg_rdy ? 1'b1 : ~GBIF_cfg_info_d[0];
// always @ ( posedge sck or negedge rst_n ) begin
//     if ( !rst_n ) begin
//         I_OE_req <= 1'b1;
//     end else if ( O_config_req && ) begin // configure state
//         I_OE_req <= 1'b1; // 1 write
//     end else 
//         I_OE_req <= ~O_switch_rdwr; // wr/rd data state
// end
assign I_OE_req = O_switch_rdwr&&~I_spi_cs_n ? 0 : 1;
wire            empty;
always @ ( negedge sck or negedge rst_n ) begin
    if ( !rst_n ) begin
        I_spi_cs_n <= 1'b1;
    end else if ( O_config_req ) begin
        I_spi_cs_n <= 1'b0;
    end else if ( empty ) begin
        I_spi_cs_n <= 1'b1;
    end
end

assign empty = O_spi_data == 63; // -1
always @ ( negedge sck or negedge rst_n ) begin
    if ( !rst_n ) begin
        O_spi_data <= 0;
    end else if (I_spi_cs_n ) begin
        O_spi_data <= 0;
    end else if ( ~I_spi_cs_n ) begin
        O_spi_data <= O_spi_data + 1;
    end
end


// *****************************************************************************
// 
// *****************************************************************************
assign top.ASIC_U.GBIF_cfg_val = 1;
assign top.ASIC_U.GBIF_cfg_info = 2;
assign top.ASIC_U.GBIF_rd_rdy = 1;

reg [ `PORT_WIDTH        -1 : 0] GBIF_wr_data;
assign top.ASIC_U.GBIF_wr_val = 1;

always @ ( posedge top.clk or negedge top.rst_n ) begin
    if ( !top.rst_n ) begin
        GBIF_wr_data <= 0;
    end else if ( top.ASIC_U.GBIF_cfg_val && top.ASIC_U.IFGB_cfg_rdy) begin
        GBIF_wr_data <= 0;
    end else if ( top.ASIC_U.GBIF_wr_val && top.ASIC_U.ASICGB_wr_rdy ) begin
        GBIF_wr_data <= GBIF_wr_data + 1;
    end
end

assign top.ASIC_U.GBIF_wr_data = GBIF_wr_data;


reg flag_finish;
// initial begin
// //save wave data ---------------------------------------------
//     flag_finish = 0;
//     $shm_open("wave_synth_shm" ,,,,1024);//1G
//     $shm_probe(top,"AS");
//     repeat(100000) @(negedge clk);
//     $shm_close;
//     flag_finish = 1;
//     $finish;
// end

endmodule

`endif
