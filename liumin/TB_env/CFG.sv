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

`include "../tb/DEFINE.sv"

class CFG;
  
  extern function new();
  extern virtual function void display(input string prefix="");

endclass : CFG


//========================================================
  function CFG::new();

  this.FrameNum = top.FrameNum;

endfunction : new

//========================================================
function void CFG::display(input string prefix = "");

endfunction : display

`endif
