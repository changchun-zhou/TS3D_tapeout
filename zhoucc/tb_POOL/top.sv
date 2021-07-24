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
  bit CCUPOOL_reset;
  // System Clock and Reset
  always #5 clk = ~clk;
  
  DATA_IF data_if(clk);
  `ifdef DUMP_EN
    DUMP DUMP_U(clk, DumpStart, DumpEnd);
  `endif
  TEST TEST_U(clk, data_if, DataNum, FlagNum);
  
  //DUT
  POOL inst_POOL (
      .clk              (clk),
      .rst_n            (rst_n),
      .CCUPOOL_reset    (CCUPOOL_reset),
      .POOLCFG_rdy      (data_if.POOLCFG_rdy),
      .CFGPOOL_val      (data_if.CFGPOOL_val),
      .CFGPOOL_data     (data_if.CFGPOOL_data),
      .CCUPOOL_En       (data_if.CCUPOOL_En),
      .CCUPOOL_ValFrm   (data_if.CCUPOOL_ValFrm),
      .CCUPOOL_ValDelta (data_if.CCUPOOL_ValDelta),
      .POOLGB_rdy       (data_if.POOLGB_rdy),
      .POOLGB_fnh       (data_if.POOLGB_fnh),
      .POOLGB_addr      (data_if.POOLGB_addr),
      .GBPOOL_val       (data_if.GBPOOL_val),
      .GBPOOL_data      (data_if.GBPOOL_data),
      .BF_rdy           (data_if.BF_rdy),
      .BF_val           (data_if.BF_val),
      .BF_addr          (data_if.BF_addr),
      .BF_data          (data_if.BF_data),
      .BF_flg_rdy       (data_if.BF_flg_rdy),
      .BF_flg_val       (data_if.BF_flg_val),
      .BF_flg_data      (data_if.BF_flg_data)
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
