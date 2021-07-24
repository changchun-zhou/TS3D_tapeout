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
`ifndef TEST
  `define TEST
  
`include "../tb/ENV.sv"
`include "../tb/DATA_IF.sv"

program automatic TEST(
  input bit clk, 
  DATA_IF.TB data_if,
  input int DataNum,
  input int FlagNum
);

	event input_done;
  ENV env;
  task reset();
data_if.rtxcb.IFCFG_val        <= 'd0;
data_if.rtxcb.IFCFG_data       <= 'd0;
data_if.rtxcb.GBCFG_rdy        <= 'd0;
data_if.rtxcb.POOLCFG_rdy      <= 'd0;
data_if.rtxcb.PEBCCU_fnh_block <= 'd0;
data_if.rtxcb.GBPSUMCFG_rdy    <= 'd0;
data_if.rtxcb.POOLCCU_clear_up <= 'd0;

		top.DumpStart <= 1'd1;

    top.rst_n <= 1'd1;
    repeat(20+$urandom%20) @ (posedge clk);
    top.rst_n <= 1'd0;
    repeat(80+$urandom%20) @ (posedge clk);
    top.rst_n <= 1'd1;
    repeat(30+$urandom%20) @ (posedge clk);
  endtask: reset

  initial begin
    // // top.next_block = 0;
    // top.reset_act = 0;
    // top.reset_wei = 0;
    reset();
    
    // top.next_block = 1;
    @(posedge clk)
    @(negedge clk)
    // top.next_block = 0;
    env = new(data_if, DataNum, FlagNum, input_done);
    env.build();
    $system("echo 'run cmodel'");
    $system("./pool_out");
    env.init();
    env.run();
    
    // top.next_block = 1;
    @(posedge clk);
    @(negedge clk);
    // top.next_block = 0;
    // @top.clear_up;
    // repeat(1000+$urandom%20) @ (posedge clk);
    // top.DumpEnd <= 1'd1;
  end

// integer i;
// initial begin
//     top.next_block = 0;
//     @(negedge top.rst_n);
//     @(posedge top.rst_n);
//     top.next_block = 1;
//     @(posedge clk)
//     top.next_block = 0;
//     repeat(1000)begin
//         top.next_block = 0;
//         @(posedge top.ARBPEB_Fnh )begin // posedge
//             @(posedge clk) // CCU delay
//             top.next_block = 1;
//         end
//         @(posedge clk);
//     end
// end

endprogram

`endif
