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
`include "../tb/PO_DATA_IF.sv"

program automatic TEST(
  input bit clk, 
  DATA_IF.TB data_if,
);

  ENV env;
  task reset();

    top.DumpStart <= 1'd1;
    top.rst_n <= 1'd0;
    repeat(80+$urandom%20) @ (posedge clk);
    top.rst_n <= 1'd1;
    repeat(20+$urandom%20) @ (posedge clk);
    top.rst_n <= 1'd0;
    repeat(10+$urandom%20) @ (posedge clk);
    top.rst_n <= 1'd1;
    repeat(30+$urandom%20) @ (posedge clk);
  endtask: reset

  task done();

    repeat(1000+$urandom%20) @ (posedge clk);
    
    $system("echo 'run cmodel'");
    $system("./pool_out");
    $system("./gb_psum");
  endtask: done

  initial begin
    reset();
    
    env = new(data_if);
    env.build();
    env.init();
    env.run();
    
    done();
  end

endprogram

`endif
