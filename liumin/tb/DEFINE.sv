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
`ifndef DEFINE
  `define DEFINE

`define TB_DATA_WIDTH 8
`define TB_ADDR_WIDTH 8
`define TB_FLAG_WIDTH 32
`define TB_PORT_WIDTH 128
`define TB_TOT_DATA   409599
`define TB_TOT_FLAG   102399

//`define TB_ADDR_WIDTH     8
`define TB_NUM_PEB        16
`define TB_TOT_PEB        48
`define TB_PSUM_WIDTH     32
`define TB_PSUMBUS_WIDTH  512
`define TB_TOT_FRAME      64
`define TB_TOT_BLOCK      64
`define TB_TOT_POOL       256


function integer clogb2 (input integer bit_depth);
begin
for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
bit_depth = bit_depth>>1;
end

endfunction
`endif
