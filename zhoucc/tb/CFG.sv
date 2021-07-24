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
`ifndef CFG
  `define CFG

`include "../source/include/dw_params_presim.vh"

class CFG;

  

  bit [31:0] DataNum;
  bit [31:0] FlagNum;

  constraint c_DataNum
    {DataNum inside {[1:40959]}; }

  rand bit [`DATA_WIDTH -1:0] GBACT_Data [][16]; // 16B
  rand bit [1           -1:0] GBFLGACT_data [][`BLOCK_DEPTH];// 32b
  rand bit [`DATA_WIDTH           -1:0] GBFLGACT_data_seed [][`BLOCK_DEPTH];// 32b
  rand bit [`DATA_WIDTH -1:0] GBWEI_Data [][16]; // 16B
  rand bit [`C_LOG_2(`MAC_NUM) -1 :0] IDWei[];
  rand bit [1           -1:0] GBFLGWEI_Data [][64]; // 8B

    constraint c_IDWei
    { foreach( IDWei[i]){
        IDWei[i] inside {[0:26]};
      } 
    }
    // constraint c_GBFLGACT_data
    // { foreach( GBFLGACT_data[i]){
    //         foreach (GBFLGACT_data[i][j]){
    //             if (GBFLGACT_data_seed[i][j] < 64)
    //                 GBFLGACT_data[i][j] == 1;
    //             else 
    //                 GBFLGACT_data[i][j] == 0;
    //         }
    //     } 
    // }
  
  extern function new(input bit [31:0] DataNum, input bit [31:0] FlagNum);
  extern virtual function void display(input string prefix="");

endclass : CFG


//========================================================
  function CFG::new(input bit [31:0] DataNum, input bit [31:0] FlagNum);
  if (!(DataNum inside {[1:40959]})) begin
    $display("FATAL %m DataNum %0d out of bounds 1..4096", DataNum);
    $finish;
  end
  this.DataNum = DataNum;
  this.FlagNum = FlagNum;
  GBACT_Data = new[DataNum]; //?????????????
  GBFLGACT_data = new[DataNum]; //?????????????
  GBFLGACT_data_seed = new[DataNum]; //?????????????
  GBWEI_Data = new[DataNum]; //?????????????
  IDWei = new[DataNum]; //?????????????
  GBFLGWEI_Data = new[DataNum]; //?????????????
  // bf_addr = new[DataNum];
  // bf_flag = new[FlagNum];

endfunction : new

//========================================================
function void CFG::display(input string prefix = "");
  integer fp_GBACT_Data = $fopen("GBACT_Data.txt", "wb");
  integer fp_GBFLGACT_data = $fopen("GBFLGACT_data.txt", "wb");
  integer fp_GBWEI_Data = $fopen("GBWEI_Data.txt", "wb");
  integer fp_GBFLGWEI_Data = $fopen("GBFLGWEI_Data.txt", "wb");
  $display( "//================ %sConfig: DataNum=%0d,FlagNum=%0d ================\n", prefix, DataNum, FlagNum);

  foreach (GBACT_Data[i])begin
    foreach(GBACT_Data[i][j]) begin
      $fwrite(fp_GBACT_Data, "%4d", $signed(GBACT_Data[i][j]));
      if( j %16 == 15 )$fwrite(fp_GBACT_Data, "\n");//16B
    end
  end
  $fclose(fp_GBACT_Data);

  foreach (GBFLGACT_data[i])begin
    foreach(GBFLGACT_data[i][j]) begin
        $fwrite(fp_GBFLGACT_data, "%1d", GBFLGACT_data[i][j]);
        if( j %32 == 31 )$fwrite(fp_GBFLGACT_data, "\n");//4B
  end
  end
  $fclose(fp_GBFLGACT_data);

  foreach (GBWEI_Data[i])begin
    foreach(GBWEI_Data[i][j]) begin
        $fwrite(fp_GBWEI_Data, "%4d", $signed(GBWEI_Data[i][j]));
        if( j %16 == 15 )$fwrite(fp_GBWEI_Data, "\n");//16B
    end
  end
  $fclose(fp_GBWEI_Data);

  foreach (GBFLGWEI_Data[i])begin
    foreach(GBFLGWEI_Data[i][j]) begin
        $fwrite(fp_GBFLGWEI_Data, "%1d", GBFLGWEI_Data[i][j]);
        if( j %64 == 63 )$fwrite(fp_GBFLGWEI_Data, "\n"); // 8B
    end
  end
  $fclose(fp_GBFLGWEI_Data);


endfunction : display

`endif
