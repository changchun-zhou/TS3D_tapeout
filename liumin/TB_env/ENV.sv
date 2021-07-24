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
`include "../tb/DATA_STIM.sv"
`include "../tb/DATA_RESP.sv"
`include "../tb/CFG.sv"

class ENV;
  CFG cfg;
  
  vDATA_TB  data_if;

  DATA_RESP data_resp;
  DATA_STIM data_stim;

  extern function new( vDATA_TB data_if);
  extern virtual function void build();
  extern virtual function void init();
  extern virtual task run();
   
endclass: ENV

function ENV::new( vDATA_TB data_if);
  this.data_if = data_if;

  cfg = new();
endfunction: new

function void ENV::build( );
  $display("ENV build");

  data_resp = new(data_if);
  data_stim = new(data_if);

  assert( cfg.randomize() );
  cfg.display();
endfunction: build

function void ENV::init( );
  $display("ENV init");

  fork
    data_resp.run();
  join_none

endfunction: init

task ENV::run();
  $display("ENV run");
  fork
    data_stim.run(cfg);
  join_none
  
  wait fork;

  $display("ENV run done");

endtask: run

`endif