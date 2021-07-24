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

`include "../tb/TEST.sv"
`include "../tb/DUMP.sv"    

module top;

  int DataNum = $urandom % 40959;
  int FlagNum = $urandom % 10239;

  bit clk;
  bit rst_n;
  bit next_block;
  bit reset_act;
  bit reset_wei;
  bit ARBPEB_Fnh;
  
  bit DumpStart;
  bit DumpEnd;

  // System Clock and Reset
  always #5 clk = ~clk;
  
  DATA_IF data_if(clk);
  `ifdef DUMP_EN
    DUMP DUMP_U(clk, DumpStart, DumpEnd);
  `endif
  TEST TEST_U(clk, data_if, DataNum, FlagNum);
  
  //DUT
  CCU inst_CCU (
      .clk                    (clk),
      .rst_n                  (rst_n),
      .ASICCCU_start          (1'b1),
      .CFGIF_rdy              (data_if.CFGIF_rdy),
      .IFCFG_val              (data_if.IFCFG_val),
      .IFCFG_data             (data_if.IFCFG_data),
      .GBCFG_rdy              (data_if.GBCFG_rdy),
      .CFGGB_val              (data_if.CFGGB_val),
      .CFGGB_num_alloc_wei    (data_if.CFGGB_num_alloc_wei),
      .CFGGB_num_alloc_flgwei (data_if.CFGGB_num_alloc_flgwei),
      .CFGGB_num_alloc_flgact (data_if.CFGGB_num_alloc_flgact),
      .CFGGB_num_alloc_act    (data_if.CFGGB_num_alloc_act),
      .CFGGB_num_total_flgwei (data_if.CFGGB_num_total_flgwei),
      .CFGGB_num_total_flgact (data_if.CFGGB_num_total_flgact),
      .CFGGB_num_total_act    (data_if.CFGGB_num_total_act),
      .CFGGB_num_loop_wei     (data_if.CFGGB_num_loop_wei),
      .CFGGB_num_loop_act     (data_if.CFGGB_num_loop_act),
      .CCUGB_pullback_wei     (data_if.CCUGB_pullback_wei),
      .CCUGB_reset_all        (data_if.CCUGB_reset_all),
      .POOLCFG_rdy            (data_if.POOLCFG_rdy),
      .CFGPOOL_val            (data_if.CFGPOOL_val),
      .CFGPOOL_data           (data_if.CFGPOOL_data),
      .CCUPOOL_reset          (data_if.CCUPOOL_reset),
      .CCUPEB_next_block      (data_if.CCUPEB_next_block),
      .CCUPEB_reset_act       (data_if.CCUPEB_reset_act),
      .CCUPEB_reset_wei       (data_if.CCUPEB_reset_wei),
      .PEBCCU_fnh_block       (data_if.PEBCCU_fnh_block),
      .GBPSUMCFG_rdy          (data_if.GBPSUMCFG_rdy),
      .CFGGBPSUM_val          (data_if.CFGGBPSUM_val),
      .CFGGBPSUM_num_frame    (data_if.CFGGBPSUM_num_frame),
      .CFGGBPSUM_num_block    (data_if.CFGGBPSUM_num_block),
      .CCUGB_reset_patch      (data_if.CCUGB_reset_patch),
      .CCUGB_frame            (data_if.CCUGB_frame),
      .CCUGB_block            (data_if.CCUGB_block),
      .CCUPOOL_En             (data_if.CCUPOOL_En),
      .CCUPOOL_ValFrm         (data_if.CCUPOOL_ValFrm),
      .CCUPOOL_ValDelta       (data_if.CCUPOOL_ValDelta),
      .CCUPOOL_layer_fnh      (data_if.CCUPOOL_layer_fnh),
      .POOLCCU_clear_up       (data_if.POOLCCU_clear_up)
    );

reg flag_finish;
initial begin
//save wave data ---------------------------------------------
    flag_finish = 0;
    $shm_open("wave_synth_shm" ,,,,1024);//1G
    $shm_probe(top,"AS");
    repeat(100000) @(negedge clk);
    $shm_close;
    flag_finish = 1;
    $finish;
end

endmodule

`endif
