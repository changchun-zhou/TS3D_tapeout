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
`ifndef GB_DUMP
  `define GB_DUMP

module GB_DUMP(
  input   Clk,
  input   Rstn,
  
  input   DumpStart
);

  wire PSum_start        = top.TS3D_U.inst_GB_PSUM.PSum_start;
  wire CCUGB_reset_patch = top.TS3D_U.inst_GB_PSUM.CCUGB_reset_patch;
  
  wire [6                            -1:0] CFGGB_num_frame = top.TS3D_U.inst_GB_PSUM.CFGGB_num_frame;
  wire [6                            -1:0] CFGGB_num_block = top.TS3D_U.inst_GB_PSUM.CFGGB_num_block;
  wire [6                            -1:0] CCUGB_frame     = top.TS3D_U.inst_GB_PSUM.cur_frame_d2   ;
  wire [6                            -1:0] CCUGB_block     = top.TS3D_U.inst_GB_PSUM.cur_block_d2   ;
  
  wire [`TB_TOT_PEB                  -1:0] psum_rd_rdy = top.TS3D_U.inst_GB_PSUM.PSUMGB_rdy ; 
  wire [`TB_TOT_PEB                  -1:0] psum_rd_vld = top.TS3D_U.inst_GB_PSUM.GBPSUM_val ;
  wire [`TB_PSUMBUS_WIDTH            -1:0] psum_rd_dat = top.TS3D_U.inst_GB_PSUM.GBPSUM_data;
                                 
  wire [`TB_TOT_PEB                  -1:0] psum_wr_rdy = top.TS3D_U.inst_GB_PSUM.GBPSUM_rdy ;
  wire [`TB_TOT_PEB                  -1:0] psum_wr_vld = top.TS3D_U.inst_GB_PSUM.PSUMGB_val ;
  wire [`TB_PSUMBUS_WIDTH*`TB_TOT_PEB-1:0] psum_wr_dat = top.TS3D_U.inst_GB_PSUM.PSUMGB_data;
  
  wire                                     pool_rd_fnh = top.TS3D_U.inst_GB_PSUM.POOLGB_fnh ;
  wire [`TB_ADDR_WIDTH               -1:0] pool_rd_add = top.TS3D_U.inst_GB_PSUM.POOLGB_addr;
  wire                                     pool_rd_rdy = top.TS3D_U.inst_GB_PSUM.GBPOOL_val ;
  wire                                     pool_rd_vld = top.TS3D_U.inst_GB_PSUM.POOLGB_rdy ;
  wire [`TB_PSUM_WIDTH*`TB_NUM_PEB   -1:0] pool_rd_dat = top.TS3D_U.inst_GB_PSUM.GBPOOL_data;

  wire is_expo = top.TS3D_U.inst_GB_PSUM.GB_PSUM_BANK_U[0].is_expo;

  bit  [32 -1:0] PsumCnt;
  bit  [32 -1:0] PoolCnt;
  int PoolNum[];
  int RRamNum[];
  int WRamNum[];
  wire PSumStart = PSum_start && CCUGB_frame == 'd0 && CCUGB_block == 'd0;

  string  f_psum_r[`TB_TOT_PEB],f_psum_w[`TB_TOT_PEB],f_pool_r[`TB_NUM_PEB],f_pool_w,f_psum_n[`TB_TOT_PEB],f_pool_n[`TB_NUM_PEB],f_pool_m;
  integer p_psum_r[`TB_TOT_PEB],p_psum_w[`TB_TOT_PEB],p_pool_r[`TB_NUM_PEB],p_pool_w,f_psum_m[`TB_TOT_PEB];
  string  f_cfg,f_num;
  integer p_cfg;

  reg CCUGB_reset_patch_d;
  string cmd;

always @ ( posedge Clk)begin
  if( ~Rstn )
    CCUGB_reset_patch_d <= 'd0;
  else
    CCUGB_reset_patch_d <= CCUGB_reset_patch;
end

always @ ( posedge Clk )begin
  if( CCUGB_reset_patch_d )begin
    $system("echo 'run gb_psum cmodel'");
    cmd = $psprintf("./gb_psum %0d 1",PsumCnt);
    $display(cmd);
    $system(cmd);
    cmd = $psprintf("./psum_comp %0d",PsumCnt);
    $display(cmd);
    $system(cmd);
    $display("gb_psum cmodel done");
  end
end

always @ ( posedge Clk)begin
  if( ~Rstn )
    PsumCnt <= 'd0;
  else if( CCUGB_reset_patch_d )
    PsumCnt <= PsumCnt + 'd1;
end

always @ ( posedge Clk)begin
  if( ~Rstn )
    PoolCnt <= 'd0;
  else if( CCUGB_reset_patch )
    PoolCnt <= 'd0;
  else if( pool_rd_vld && pool_rd_rdy )
    PoolCnt <= PoolCnt + 'd1;
end

//to cmodel
always @ ( posedge Clk )begin
  if( PSumStart )begin
    f_num = $psprintf("_N%02d", PsumCnt);
    f_cfg = {"./cfg/cfg",f_num,".txt"};
    PoolNum = new[CFGGB_num_frame+2];
    RRamNum = new[(CFGGB_num_frame+1)*(CFGGB_num_block+1)];
    WRamNum = new[(CFGGB_num_frame+1)*(CFGGB_num_block+1)];
  end
end

always @ ( posedge Clk )begin
  if( CCUGB_reset_patch )begin
    p_cfg = $fopen(f_cfg, "ab+");
    $fwrite(p_cfg, "FrameNum=%0d\n", CFGGB_num_frame+1);
    $fwrite(p_cfg, "BlockNum=%0d\n", CFGGB_num_block+1);
    for(integer i = 0; i < (CFGGB_num_frame+2); i = i + 1 )begin
      $fwrite(p_cfg, "PoolNum =%0d\n", PoolNum[i]);
      PoolNum[i] = 0;
    end
    for(integer i = 0; i < (CFGGB_num_frame+1)*(CFGGB_num_block+1); i = i + 1 )begin
      $fwrite(p_cfg, "RRamNum =%0d\n", RRamNum[i]);
      $fwrite(p_cfg, "WRamNum =%0d\n", WRamNum[i]);
      RRamNum[i] = 0;
      WRamNum[i] = 0;
    end
    $fclose(p_cfg);
  end
end

genvar gen_i;
generate
  for( gen_i=0 ; gen_i < `TB_TOT_PEB; gen_i = gen_i+1 ) begin : DUMP_BLOCK
    //always @ ( posedge Clk )begin
    //  if( PSumStart )begin
    //    f_psum_n[gen_i] = $psprintf("%02d_N%02d", gen_i, PsumCnt);
    //    f_psum_r[gen_i] = {"./dump/psum",f_psum_n[gen_i],".txt"};
    //    f_psum_w[gen_i] = {"./cfg/psum",f_psum_n[gen_i],".txt"};
    //  end
    //end   

    always @ ( posedge Clk )begin
      if( psum_rd_vld[gen_i] && psum_rd_rdy[gen_i] )begin
      	f_psum_r[gen_i] = $psprintf("./dump/psum%02d_N%02d_F%02d_B%02d.txt", gen_i, PsumCnt, CCUGB_frame, CCUGB_block);
        p_psum_r[gen_i] = $fopen(f_psum_r[gen_i], "ab+");
        for(integer i = 0; i < 16; i = i + 1 )begin
          $fwrite(p_psum_r[gen_i], "%12d ", $signed(psum_rd_dat[i*32+:32]));
          if( i %4 == 3 )$fwrite(p_psum_r[gen_i], "\n");
        end
        $fwrite(p_psum_r[gen_i],"\n");
        $fclose(p_psum_r[gen_i]);
        if(gen_i == 0)RRamNum[CCUGB_frame*(CFGGB_num_block+1)+CCUGB_block]++;
      end
    end

    //to cmodel
    always @ ( posedge Clk )begin
      if( psum_wr_vld[gen_i] && psum_wr_rdy[gen_i] )begin
      	f_psum_w[gen_i] = $psprintf("./cfg/psum%02d_N%02d_F%02d_B%02d.txt", gen_i, PsumCnt, CCUGB_frame, CCUGB_block);
        p_psum_w[gen_i] = $fopen(f_psum_w[gen_i], "ab+");
        for(integer i = 0; i < 16; i = i + 1 )begin
          $fwrite(p_psum_w[gen_i], "%12d ", $signed(psum_wr_dat[i*32+`TB_PSUMBUS_WIDTH*gen_i +:32]));
          if( i %4 == 3 )$fwrite(p_psum_w[gen_i], "\n");
        end
        $fclose(p_psum_w[gen_i]);
        if(gen_i == 0)WRamNum[CCUGB_frame*(CFGGB_num_block+1)+CCUGB_block]++;
      end
    end
  end
endgenerate

//to cmodel
always @ ( posedge Clk )begin
  if( PSumStart )begin
  	f_pool_m = $psprintf("_N%02d", PsumCnt);
    f_pool_w = {"./cfg/pool",f_pool_m,".txt"};
    p_pool_w = $fopen(f_pool_w, "ab+");
    $fclose(p_pool_w);
  end
end
always @ ( posedge Clk )begin    
  if( pool_rd_vld && pool_rd_rdy )begin
    p_pool_w = $fopen(f_pool_w, "ab+");
    $fwrite(p_pool_w, "%3d ", pool_rd_add);
    if(PoolCnt%16 == 15)$fwrite(p_pool_w, "\n");
    if( is_expo )
      PoolNum[CCUGB_frame+1]++;
    else
      PoolNum[CCUGB_frame]++;
    $fclose(p_pool_w);
  end
end

//dump
generate
  for( gen_i=0 ; gen_i < `TB_NUM_PEB; gen_i = gen_i+1 ) begin : POOL_DUMP_BLOCK

    always @ ( posedge Clk )begin
      if( PSumStart )begin
        f_pool_n[gen_i] = $psprintf("%02d_N%02d", gen_i, PsumCnt);
        f_pool_r[gen_i] = {"./dump/pool",f_pool_n[gen_i],".txt"};
      end
    end

    always @ ( posedge Clk )begin    
      if( pool_rd_vld && pool_rd_rdy )begin
        p_pool_r[gen_i] = $fopen(f_pool_r[gen_i], "ab+");
        $fwrite(p_pool_r[gen_i], "%12d\n", $signed(pool_rd_dat[gen_i*32+:32]));
        $fclose(p_pool_r[gen_i]);
      end
    end

  end
endgenerate

endmodule

`endif
