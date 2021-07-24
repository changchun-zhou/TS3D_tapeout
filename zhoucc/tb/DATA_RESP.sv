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
`ifndef DATA_RESP
  `define DATA_RESP

`include "../tb/DATA_IF.sv"

class DATA_RESP #(type IF_T = vDATA_IF);
  IF_T data_if;
  
  extern function new(IF_T data_if);
  extern virtual task run();

endclass: DATA_RESP

function DATA_RESP::new(IF_T data_if);
  this.data_if = data_if;
endfunction: new
  
task DATA_RESP::run();
  
  fork
    forever begin
      @data_if.txcb_WEIGB_Instr_Data; // posedge clk
      `ifdef RANDOM
          data_if.txcb_WEIGB_Instr_Data.GBWEI_Instr_Rdy <= $urandom%2;
      `else
          data_if.txcb_WEIGB_Instr_Data.GBWEI_Instr_Rdy <= 1;
      `endif
    end
  join_none

  fork
    forever begin
      @(posedge top.clk); // posedge clk
        if(top.reset_wei) begin
            top.Weirow = 0;
            top.DUMP_U.addr_r_idwei = 0;
        end else if(data_if.rxcb_GBWEI_Data.WEIGB_Rdy && data_if.rxcb_GBWEI_Data.GBWEI_Val) begin
            top.Weirow = top.Weirow + 1;
            top.DUMP_U.addr_r_idwei = top.DUMP_U.addr_r_idwei + 1;
        end
    end
  join_none

  fork
    forever begin
      @(posedge top.clk); // posedge clk
        if(top.reset_wei) begin
            top.FlgWeirow = 0;
        end else if(data_if.rxcb_GBFLGWEI_Data.FLGWEIGB_Rdy && data_if.rxcb_GBFLGWEI_Data.GBFLGWEI_Val) begin
            top.FlgWeirow = top.FlgWeirow + 1;
        end
    end
  join_none

  fork
    forever begin
      @(posedge top.clk); // posedge clk
        if(top.reset_act) begin
            top.Actrow = 0;
        end else if(data_if.rxcb_GBACT_Data.ACTGB_Rdy && data_if.rxcb_GBACT_Data.GBACT_Val) begin
            top.Actrow = top.Actrow + 1;
        end
    end
  join_none
  fork
    forever begin
      @(posedge top.clk); // posedge clk
        if(top.reset_act) begin
            top.FlgActrow = 0;
        end else if(data_if.rxcb_GBFLGACT_data.GBFLGACT_rdy && data_if.rxcb_GBFLGACT_data.GBFLGACT_val) begin
            top.FlgActrow = top.FlgActrow + 1;
        end
    end
  join_none

  fork
    forever begin
      @data_if.txcb_ACTPEB_data; // posedge clk
      `ifdef RANDOM
          data_if.txcb_ACTPEB_data.PEBACT_rdy <= $urandom%2;
      `else
          data_if.txcb_ACTPEB_data.PEBACT_rdy <= 1;
      `endif
      if(data_if.txcb_ACTPEB_data.PEBACT_rdy) // delay a clk becuase pop
        @data_if.txcb_ACTPEB_data; // posedge clk
    end
  join_none

  fork
    forever begin
      @data_if.txcb_FLGACTPEB_data; // posedge clk
      `ifdef RANDOM
          data_if.txcb_FLGACTPEB_data.PEBFLGACT_rdy <= $urandom%2;
      `else
          data_if.txcb_FLGACTPEB_data.PEBFLGACT_rdy <= 1;
      `endif
      if(data_if.txcb_FLGACTPEB_data.PEBFLGACT_rdy) // delay a clk becuase pop
        @data_if.txcb_FLGACTPEB_data; // 
    end
  join_none

  fork
    forever begin
      @data_if.txcb_PSUMGB_data0; // posedge clk
      `ifdef RANDOM
          data_if.txcb_PSUMGB_data0.GBPSUM_rdy0 <= $urandom%2;
      `else
          data_if.txcb_PSUMGB_data0.GBPSUM_rdy0 <= 1;
      `endif
    end
  join_none
  
  fork
    forever begin
      @data_if.txcb_PSUMGB_data1; // posedge clk
      `ifdef RANDOM
          data_if.txcb_PSUMGB_data1.GBPSUM_rdy1 <= $urandom%2;
      `else
          data_if.txcb_PSUMGB_data1.GBPSUM_rdy1 <= 1;
      `endif
    end
  join_none
  
  fork
    forever begin
      @data_if.txcb_PSUMGB_data2; // posedge clk
      `ifdef RANDOM
          data_if.txcb_PSUMGB_data2.GBPSUM_rdy2 <= $urandom%2;
      `else
          data_if.txcb_PSUMGB_data2.GBPSUM_rdy2 <= 1;
      `endif
    end
  join_none
 
endtask : run

`endif
