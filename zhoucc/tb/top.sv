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
  bit test_wei;
  bit DumpStart;
  bit DumpEnd;
  
  bit [`DATA_WIDTH -1:0] GBWEI_Data [][16];
  
integer Weirow=0;
integer FlgWeirow=0;
integer Actrow=0;
integer FlgActrow=0;
  // System Clock and Reset
  always #5 clk = ~clk;
  
  DATA_IF data_if(clk);
  `ifdef DUMP_EN
    DUMP DUMP_U(clk, DumpStart, DumpEnd);
  `endif
  TEST TEST_U(clk, data_if, DataNum, FlagNum);
  
  //DUT
  PEB inst_PEB
    (
      .clk              (clk),
      .rst_n            (rst_n),
      .next_block       (next_block),
      .reset_act        (reset_act),
      .reset_wei        (reset_wei),
      .ARBPEB_Fnh       (ARBPEB_Fnh),
      .ACTGB_Rdy        (data_if.ACTGB_Rdy    ),
      .GBACT_Val        (data_if.GBACT_Val    ),
      .GBACT_Data       (data_if.GBACT_Data   ),
      .GBFLGACT_rdy     (data_if.GBFLGACT_rdy ),
      .GBFLGACT_val     (data_if.GBFLGACT_val ),
      .GBFLGACT_data    (data_if.GBFLGACT_data),
      .PEBACT_rdy       (data_if.PEBACT_rdy ),
      .ACTPEB_val       (data_if.ACTPEB_val ),
      .ACTPEB_data      (data_if.ACTPEB_data),
      .PEBFLGACT_rdy    (data_if.PEBFLGACT_rdy ),
      .FLGACTPEB_val    (data_if.FLGACTPEB_val ),
      .FLGACTPEB_data   (data_if.FLGACTPEB_data),
      .GBWEI_Instr_Rdy  (data_if.GBWEI_Instr_Rdy ),
      .WEIGB_Instr_Val  (data_if.WEIGB_Instr_Val ),
      .WEIGB_Instr_Data (data_if.WEIGB_Instr_Data),
      .WEIGB_Rdy        (data_if.WEIGB_Rdy),
      .GBWEI_Val        (data_if.GBWEI_Val),
      .GBWEI_Data       (data_if.GBWEI_Data),
      .FLGWEIGB_Rdy     (data_if.FLGWEIGB_Rdy),
      .GBFLGWEI_Val     (data_if.GBFLGWEI_Val),
      .GBFLGWEI_Data    (data_if.GBFLGWEI_Data),
      .PSUMGB_val0      (data_if.PSUMGB_val0    ),
      .PSUMGB_data0     (data_if.PSUMGB_data0   ),
      .GBPSUM_rdy0      (data_if.GBPSUM_rdy0    ),
      .PSUMGB_val1      (data_if.PSUMGB_val1    ),
      .PSUMGB_data1     (data_if.PSUMGB_data1   ),
      .GBPSUM_rdy1      (data_if.GBPSUM_rdy1    ),
      .PSUMGB_val2      (data_if.PSUMGB_val2    ),
      .PSUMGB_data2     (data_if.PSUMGB_data2   ),
      .GBPSUM_rdy2      (data_if.GBPSUM_rdy2    ),
      .PSUMGB_rdy0      (data_if.PSUMGB_rdy0    ),
      .GBPSUM_data0     (data_if.GBPSUM_data0   ),
      .GBPSUM_val0      (data_if.GBPSUM_val0    ),
      .PSUMGB_rdy1      (data_if.PSUMGB_rdy1    ),
      .GBPSUM_data1     (data_if.GBPSUM_data1   ),
      .GBPSUM_val1      (data_if.GBPSUM_val1    ),
      .PSUMGB_rdy2      (data_if.PSUMGB_rdy2    ),
      .GBPSUM_data2     (data_if.GBPSUM_data2   ),
      .GBPSUM_val2      (data_if.GBPSUM_val2    )
    );
reg flag_finish;
initial begin
//save wave data ---------------------------------------------
    flag_finish = 0;
    $shm_open("wave_synth_shm" ,,,,1024);//1G
    $shm_probe(top,"AS");
    repeat(1000000) @(negedge clk);
    $shm_close;
    flag_finish = 1;
    $finish;
end

endmodule

`endif
