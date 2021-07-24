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
`ifndef DUMP
  `define DUMP

module DUMP( // dump output
  input   Clk,
  
  input   DumpStart,
  input   DumpEnd
);
  string  f_data_r,f_flag_r,f_num;
  string  f_data_c,f_flag_c, f_GBWEI_IDWei_r;
  integer p_data,p_flag, fp_GBWEI_IDWei_r;
  integer fp_POOLGB_addr;
  integer   fp_BF_addr  ;  
  integer fp_BF_data    ;
  integer fp_BF_flg_data;
  integer fp_PSUMGB_data1_r;
  integer fp_PSUMGB_data2_r;
  integer fp_ACTPEB_data_r;
  integer fp_FLGACTPEB_data_r;
  int index = 0;
  reg [ 20              : 0] addr_w_idwei;
  reg [ 20              : 0] addr_r_idwei;
  reg [ 8            -1 : 0] IDWei[0: 2**10];

// always @ ( posedge Clk )begin
//   if( DumpStart )begin
//     f_num  = $psprintf("%0d",index++);
//   end
// end

initial begin
    addr_r_idwei        = 0;
    fp_POOLGB_addr   = $fopen("./dump/PSUMGB_data0_rtl.txt", "w");
    fp_BF_addr    = $fopen("./dump/BF_addr.txt", "w");
    fp_BF_data    = $fopen("./dump/BF_data.txt", "w");
    fp_BF_flg_data   = $fopen("./dump/BF_flg_data.txt", "w");
end

always @ ( posedge Clk )begin
  if( top.inst_POOL.POOLGB_rdy && top.inst_POOL.GBPOOL_val )begin
      $fwrite(fp_POOLGB_addr, "%4d ", top.inst_POOL.POOLGB_addr);
    // end
    $fwrite(fp_POOLGB_addr,"\n");
  end

end

always @ ( posedge Clk )begin
  if( top.inst_POOL.BF_rdy && top.inst_POOL.BF_val )begin
      $fwrite(fp_BF_addr, "%4d ", top.inst_POOL.BF_addr);
      $fwrite(fp_BF_data, "%4d ", $signed(top.inst_POOL.BF_data));

    // end
    $fwrite(fp_BF_addr,"\n");
    $fwrite(fp_BF_data,"\n");
  end

end


always @ ( posedge Clk )begin
  if( top.inst_POOL.BF_flg_rdy && top.inst_POOL.BF_flg_val )begin
    for(integer i = 0; i < 16; i = i + 1 )begin
      $fwrite(fp_BF_flg_data, "%1d ", top.inst_POOL.BF_flg_data[i]);
    end
    $fwrite(fp_BF_flg_data,"\n");
  end

end

endmodule

`endif
