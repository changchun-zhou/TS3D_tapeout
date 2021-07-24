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
            @data_if.rtxcb;
            `ifdef RANDOM
              data_if.rtxcb.BF_rdy <= 1; //$urandom%2;
            `else
              data_if.rtxcb.BF_rdy <= 1;
            `endif
            end

        forever begin
            `ifdef RANDOM
              data_if.rtxcb.BF_flg_rdy <= $urandom%2;
            `else
              data_if.rtxcb.BF_flg_rdy <= 1;
            `endif
            @data_if.rtxcb;
          end   

    join_none
 
endtask : run

`endif
