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
    data_if.rxcb_GBACT_Data.GBACT_Val <= 'd0;
    data_if.rxcb_GBACT_Data.GBACT_Data     <= 'd0;
    data_if.rxcb_GBFLGACT_data.GBFLGACT_val     <= 'd0;
    data_if.rxcb_GBFLGACT_data.GBFLGACT_data <= 'd0;
    data_if.rxcb_GBWEI_Data.GBWEI_Val     <= 'd0;
    data_if.rxcb_GBWEI_Data.GBWEI_Data <= 'd0;
    data_if.rxcb_GBFLGWEI_Data.GBFLGWEI_Val <= 'd0;
    data_if.rxcb_GBFLGWEI_Data.GBFLGWEI_Data <= 'd0;
    data_if.txcb_WEIGB_Instr_Data.GBWEI_Instr_Rdy <= 'd0;

		top.DumpStart <= 1'd1;

    top.rst_n <= 1'd1;
    repeat(20+$urandom%20) @ (posedge clk);
    top.rst_n <= 1'd0;
    repeat(80+$urandom%20) @ (posedge clk);
    top.rst_n <= 1'd1;
    repeat(30+$urandom%20) @ (posedge clk);
  endtask: reset

  initial begin
    // top.next_block = 0;
    top.reset_act = 0;
    top.reset_wei = 0;
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

integer i;
initial begin
    top.next_block = 0;
    @(negedge top.rst_n);
    @(posedge top.rst_n);
    top.next_block = 1;
    @(posedge clk)
    top.next_block = 0;
    repeat(1000)begin
        top.next_block = 0;
        @(posedge top.ARBPEB_Fnh )begin // posedge
            @(posedge clk) // CCU delay
            top.next_block = 1;
        end
        @(posedge clk);
    end
end

integer cnt_blk;
initial begin
    cnt_blk = 0;
    fork
        repeat(100) begin
            @(posedge top.next_block);
            @(posedge clk)
            cnt_blk = cnt_blk + 1;
        end
    join_none

    fork
        repeat(100) begin
            top.reset_wei = 0;
            top.reset_act = 0;
            @(posedge top.next_block)
            if(cnt_blk %4 == 0) begin// Numblock = 4
                top.reset_wei = 1;
                if(cnt_blk %8 == 0) // 4 block/frame; 2 frame/patch
                    top.reset_act = 1;
                @(posedge clk);
                @(negedge clk);
            end
            else @(posedge clk);

        end
    join_none
end 


endprogram

`endif
