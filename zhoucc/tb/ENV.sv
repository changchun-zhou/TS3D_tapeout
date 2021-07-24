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
  data_if.rxcb_GBACT_Data.GBACT_Val <= 0;
  data_if.rxcb_GBFLGACT_data.GBFLGACT_val <= 0;
  data_if.rxcb_GBWEI_Data.GBWEI_Val <= 0;
  data_if.rxcb_GBFLGWEI_Data.GBFLGWEI_Val <= 0;

  data_if.rxcb_GBACT_Data.GBACT_Data <= $urandom;
  data_if.rxcb_GBFLGACT_data.GBFLGACT_data <= $urandom;
  data_if.rxcb_GBWEI_Data.GBWEI_Data <= $urandom;
  data_if.rxcb_GBFLGWEI_Data.GBFLGWEI_Data <= $urandom;

  fork
    data_resp.run();
  join_none

endfunction: init

task ENV::run();
  $display("ENV run");

  fork
    //@data_if.rxcb_data;
    for (int i=0; i<DataNum; i++) begin
      for(int j=0; j<16; j++) 
        data_if.rxcb_GBACT_Data.GBACT_Data[`DATA_WIDTH*j +: `DATA_WIDTH] <= cfg.GBACT_Data[top.Actrow][j];

      do begin
        `ifdef RANDOM
          data_if.rxcb_GBACT_Data.GBACT_Val <= $urandom%2;
        `else
          data_if.rxcb_GBACT_Data.GBACT_Val <= 1;
        `endif
        @data_if.rxcb_GBACT_Data;
      end while( ~(data_if.rxcb_GBACT_Data.ACTGB_Rdy && data_if.rxcb_GBACT_Data.GBACT_Val) && !top.reset_act );
      data_if.rxcb_GBACT_Data.GBACT_Val <= 0;
      if(top.reset_act) 
        @data_if.rxcb_GBACT_Data;
    end

    for (int i=0; i<DataNum; i++) begin
        for(int j=0; j<`BLOCK_DEPTH; j++)
            data_if.rxcb_GBFLGACT_data.GBFLGACT_data[j] <= cfg.GBFLGACT_data[top.FlgActrow][j];

      do begin
        `ifdef RANDOM
          data_if.rxcb_GBFLGACT_data.GBFLGACT_val <= $urandom%2;
        `else
          data_if.rxcb_GBFLGACT_data.GBFLGACT_val <= 1;
        `endif
        @data_if.rxcb_GBFLGACT_data;
      end while( ~(data_if.rxcb_GBFLGACT_data.GBFLGACT_rdy && data_if.rxcb_GBFLGACT_data.GBFLGACT_val) && !top.reset_act);
      data_if.rxcb_GBFLGACT_data.GBFLGACT_val <= 0;
      if(top.reset_act)
        @data_if.rxcb_GBFLGACT_data;
    end

    for (int i=0; i<DataNum; i++) begin
        
        for(int j=0; j<16; j++)
            data_if.rxcb_GBWEI_Data.GBWEI_Data[`C_LOG_2(`MAC_NUM) + `DATA_WIDTH*j +: `DATA_WIDTH] <= cfg.GBWEI_Data[top.Weirow][j];
        do begin
            if(top.DUMP_U.addr_r_idwei < top.DUMP_U.addr_w_idwei) begin
                data_if.rxcb_GBWEI_Data.GBWEI_Data[0 +: `C_LOG_2(`MAC_NUM)] <= top.DUMP_U.IDWei[top.DUMP_U.addr_r_idwei]; // dump
                `ifdef RANDOM
                  data_if.rxcb_GBWEI_Data.GBWEI_Val <= $urandom%2;
                `else
                  data_if.rxcb_GBWEI_Data.GBWEI_Val <= 1;
                `endif

            end else
                data_if.rxcb_GBWEI_Data.GBWEI_Val <= 0;  
            @data_if.rxcb_GBWEI_Data;
        end while( ~(data_if.rxcb_GBWEI_Data.WEIGB_Rdy && data_if.rxcb_GBWEI_Data.GBWEI_Val ) && !top.reset_wei );
      data_if.rxcb_GBWEI_Data.GBWEI_Val <= 0;
      if(top.reset_wei)
        @data_if.rxcb_GBWEI_Data;
      // top.DUMP_U.addr_r_idwei = top.DUMP_U.addr_r_idwei + 1;
    end

    for (int i=0; i<DataNum; i++) begin
        for(int j=0; j<64; j++)
            data_if.rxcb_GBFLGWEI_Data.GBFLGWEI_Data[j] <= cfg.GBFLGWEI_Data[top.FlgWeirow][j];
      do begin
        `ifdef RANDOM
          data_if.rxcb_GBFLGWEI_Data.GBFLGWEI_Val <= $urandom%2;
        `else
          data_if.rxcb_GBFLGWEI_Data.GBFLGWEI_Val <= 1;
        `endif
        @data_if.rxcb_GBFLGWEI_Data;
      end while( ~(data_if.rxcb_GBFLGWEI_Data.FLGWEIGB_Rdy && data_if.rxcb_GBFLGWEI_Data.GBFLGWEI_Val) && !top.reset_wei );
      data_if.rxcb_GBFLGWEI_Data.GBFLGWEI_Val <= 0;
      if(top.reset_wei)
        @data_if.rxcb_GBFLGWEI_Data;
    end

    for (int i=0; i<DataNum; i++) begin
      data_if.rxcb_GBPSUM_data0.GBPSUM_data0 <= 0;
      data_if.rxcb_GBPSUM_data1.GBPSUM_data1 <= 0;
      data_if.rxcb_GBPSUM_data2.GBPSUM_data2 <= 0;

      do begin
        `ifdef RANDOM
          data_if.rxcb_GBPSUM_data0.GBPSUM_val0 <= $urandom%2;
          data_if.rxcb_GBPSUM_data1.GBPSUM_val1 <= $urandom%2;
          data_if.rxcb_GBPSUM_data2.GBPSUM_val2 <= $urandom%2;
        `else
          data_if.rxcb_GBPSUM_data0.GBPSUM_val0 <= 1;
          data_if.rxcb_GBPSUM_data1.GBPSUM_val1 <= 1;
          data_if.rxcb_GBPSUM_data2.GBPSUM_val2 <= 1;
        `endif
        @data_if.rxcb_GBPSUM_data0;
      end while( ~(data_if.rxcb_GBPSUM_data0.PSUMGB_rdy0 && data_if.rxcb_GBPSUM_data0.GBPSUM_val0) );
      data_if.rxcb_GBPSUM_data0.GBPSUM_val0 <= 0;
    end
  join_none

  wait fork;
  $display("ENV input done");
  ->done;
endtask: run

`endif
