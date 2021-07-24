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
`ifndef PO_DUMP
  `define PO_DUMP

module PO_DUMP(
  input   Clk,
  input   Rstn,
  input   DumpStart
);
  string  f_data_r,f_flag_r,f_data_n;
  string  f_data_c,f_flag_c;
  integer p_data_r,p_flag_r;
  integer p_data_c,p_flag_c;

  wire layer_fnh = top.TS3D_U.inst_POOL_OUT.layer_fnh;
  wire clear_up  = top.TS3D_U.inst_POOL_OUT.clear_up;

  wire                           bf_data_rdy = top.TS3D_U.inst_POOL_OUT.BF_rdy ;
  wire                           bf_data_vld = top.TS3D_U.inst_POOL_OUT.BF_val ;
  wire [`TB_ADDR_WIDTH   -1 : 0] bf_data_add = top.TS3D_U.inst_POOL_OUT.BF_addr;
  wire [`TB_DATA_WIDTH   -1 : 0] bf_data_dat = top.TS3D_U.inst_POOL_OUT.BF_data;

  wire                           bf_flag_rdy = top.TS3D_U.inst_POOL_OUT.BF_flg_rdy ;
  wire                           bf_flag_vld = top.TS3D_U.inst_POOL_OUT.BF_flg_val ;
  wire [`TB_FLAG_WIDTH   -1 : 0] bf_flag_dat = top.TS3D_U.inst_POOL_OUT.BF_flg_data;

  wire                           po_data_rdy = top.TS3D_U.inst_POOL_OUT.IFPOOL_rdy ;
  wire                           po_data_vld = top.TS3D_U.inst_POOL_OUT.POOLIF_val ;
  wire [`TB_PORT_WIDTH   -1 : 0] po_data_dat = top.TS3D_U.inst_POOL_OUT.POOLIF_data;

  wire                           po_flag_rdy = top.TS3D_U.inst_POOL_OUT.IFPOOL_flg_rdy ;
  wire                           po_flag_vld = top.TS3D_U.inst_POOL_OUT.POOLIF_flg_val ;
  wire [`TB_PORT_WIDTH   -1 : 0] po_flag_dat = top.TS3D_U.inst_POOL_OUT.POOLIF_flg_data;
  
  bit [32 -1:0] PsumCnt;
  int DataCnt = 0;
  int FlagCnt = 0;
  reg clear_up_d;
  string cmd;
  
  initial begin
  	$system("rm ./dump/*");
  	$system("rm ./dump_c/*");
  	$system("rm ./cfg/*");
  end
  
always @ ( posedge Clk)begin
  if( ~Rstn )
    PsumCnt <= 'd0;
  else if( clear_up_d )
    PsumCnt <= PsumCnt + 'd1;
end

always @ ( posedge Clk)begin
  if( ~Rstn )
    clear_up_d <= 'd0;
  else
    clear_up_d <= clear_up;
end

always @ ( posedge Clk )begin
  //if( DumpStart )begin
  //  f_data_n = $psprintf("_N%02d", PsumCnt);
  //  f_data_r = {"./dump/pool_data",f_data_n,".txt"};
  //  f_flag_r = {"./dump/pool_flag",f_data_n,".txt"}; 
  //  f_data_c = {"./cfg/pool_data",f_data_n,".txt"}; 
  //  f_flag_c = {"./cfg/pool_flag",f_data_n,".txt"}; 
  //end
  if( clear_up_d )begin
  	$system("echo 'run pool cmodel'");
    cmd = $psprintf("./pool_out %0d",PsumCnt);
    $display(cmd);
    $system(cmd);
    cmd = $psprintf("./pool_comp %0d",PsumCnt);
    $display(cmd);
    $system(cmd);
    $display("pool cmodel done");
  end
end

always @ ( posedge Clk )begin
  if( po_data_vld && po_data_rdy )begin
    f_data_r = $psprintf("./dump/pool_data_N%02d.txt",PsumCnt);
  	p_data_r = $fopen(f_data_r, "ab+");
  	for(integer i = 0; i < 16; i = i + 1 )begin
      $fwrite(p_data_r, "%3d ", po_data_dat[i*8+:8]);
    end
    $fwrite(p_data_r,"\n");
    $fclose(p_data_r);
    
  end
  if( po_flag_vld && po_flag_rdy )begin
    f_flag_r = $psprintf("./dump/pool_flag_N%02d.txt",PsumCnt);
  	p_flag_r = $fopen(f_flag_r, "ab+");
    $fwrite(p_flag_r, "%32x\n", po_flag_dat);
    $fclose(p_flag_r);
  end
end

always @ ( posedge Clk )begin
  if( bf_data_vld && bf_data_rdy )begin
  	f_data_c = $psprintf("./cfg/pool_data_N%02d.txt",PsumCnt);
  	p_data_c = $fopen(f_data_c, "ab+");
    $fwrite(p_data_c, "%3d:%3d ", bf_data_dat,bf_data_add);
    DataCnt++;
    if(DataCnt%16 == 0)$fwrite(p_data_c,"\n");
    $fclose(p_data_c);
  end
  if( bf_flag_vld && bf_flag_rdy )begin
    f_flag_c = $psprintf("./cfg/pool_flag_N%02d.txt",PsumCnt);
  	p_flag_c = $fopen(f_flag_c, "ab+");
  	$fwrite(p_flag_c, "%08h ", bf_flag_dat);
  	FlagCnt++;
    if(FlagCnt%16 == 0)$fwrite(p_flag_c,"\n");
    $fclose(p_flag_c);
  end
end
endmodule

`endif
