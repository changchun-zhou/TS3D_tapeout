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
`ifndef ENV
  `define ENV

`include "../tb/DATA_IF.sv"
`include "../tb/CFG.sv"
`include "../source/include/dw_params_presim.vh"
class ENV #(type IF_T = vDATA_IF);
  IF_T  data_if;
  CFG       cfg;
  DATA_RESP data_resp;
  int DataNum;
  int FlagNum;
  event done;

  extern function new( IF_T data_if, int DataNum, int FlagNum, event done);
  extern virtual function void build();
  extern virtual function void init();
  extern virtual task run();
   
endclass: ENV

function ENV::new( IF_T data_if, int DataNum, int FlagNum, event done);
  this.data_if = data_if;
  this.DataNum = DataNum;
  this.FlagNum = FlagNum;
  this.done    = done;
  cfg = new(DataNum,FlagNum);
endfunction: new

function void ENV::build( );
  $display("ENV build");
  data_resp = new(data_if);
  assert( cfg.randomize() );
  cfg.display();
endfunction: build

function void ENV::init( );
  $display("ENV init");
  // data_if.rxcb_GBACT_Data.GBACT_Val <= 0;
  // data_if.rxcb_GBFLGACT_data.GBFLGACT_val <= 0;
  // data_if.rxcb_GBWEI_Data.GBWEI_Val <= 0;
  // data_if.rxcb_GBFLGWEI_Data.GBFLGWEI_Val <= 0;

  // data_if.rxcb_GBACT_Data.GBACT_Data <= $urandom;
  // data_if.rxcb_GBFLGACT_data.GBFLGACT_data <= $urandom;
  // data_if.rxcb_GBWEI_Data.GBWEI_Data <= $urandom;
  // data_if.rxcb_GBFLGWEI_Data.GBFLGWEI_Data <= $urandom;

  fork
    data_resp.run();
  join_none

endfunction: init

task ENV::run();
  $display("ENV run");
  
  fork
    //@data_if.rxcb_data;
    for (int i=0; i<DataNum; i++) begin
      for(int j=0; j<12; j++) 
        data_if.rtxcb.IFCFG_data[`DATA_WIDTH*j +: `DATA_WIDTH] <= cfg.IFCFG_data[i][j];

      do begin
        `ifdef RANDOM
          data_if.rtxcb.IFCFG_val <= $urandom%2;
        `else
          data_if.rtxcb.IFCFG_val <= 1;
        `endif
        @data_if.rtxcb;
      end while( ~(data_if.rtxcb.CFGIF_rdy && data_if.rtxcb.IFCFG_val) );
      data_if.rtxcb.IFCFG_val <= 0;
    end

    for (int i=0; i<DataNum; i++) begin
      do begin
        `ifdef RANDOM
          data_if.rtxcb.POOLCCU_clear_up <= $urandom%2;
        `else
          data_if.rtxcb.POOLCCU_clear_up <= 1;
        `endif
        @data_if.rtxcb;
      end while( data_if.rtxcb.POOLCCU_clear_up);
      data_if.rtxcb.POOLCCU_clear_up <= 0;
      for(int j=0; j < 10000; j++) begin
        @data_if.rtxcb;
      end
    end

  join_none

  wait fork;
  $display("ENV input done");
  ->done;
endtask: run

`endif
