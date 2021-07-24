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
  integer fp_PSUMGB_data0_r;
  integer fp_PSUMGB_data1_r;
  integer fp_PSUMGB_data2_r;
  integer fp_ACTPEB_data_r;
  integer fp_FLGACTPEB_data_r;
  int index = 0;
  reg [ 20              : 0] addr_w_idwei;
  reg [ 20              : 0] addr_r_idwei;
  reg [ 8            -1 : 0] IDWei[0: 2**10];

always @ ( posedge Clk )begin
  if( DumpStart )begin
    f_num  = $psprintf("%0d",index++);
  end
end

initial begin
    addr_r_idwei        = 0;
    fp_PSUMGB_data0_r   = $fopen("./dump/PSUMGB_data0_rtl.txt", "w");
    fp_PSUMGB_data1_r   = $fopen("./dump/PSUMGB_data1_rtl.txt", "wb");
    fp_PSUMGB_data2_r   = $fopen("./dump/PSUMGB_data2_rtl.txt", "wb");
    fp_GBWEI_IDWei_r    = $fopen("./dump/GBWEI_IDWei.txt", "wb");
    fp_ACTPEB_data_r    = $fopen("./dump/ACTPEB_data.txt", "wb");
    fp_FLGACTPEB_data_r = $fopen("./dump/FLGACTPEB_data.txt", "wb");
end

always @ ( posedge Clk )begin
        if(!top.rst_n) begin
            addr_w_idwei <= 0;
        end else if(top.reset_wei) begin
            addr_w_idwei <= 0;
        end else if( top.inst_PEB.WEIGB_Instr_Val && top.inst_PEB.GBWEI_Instr_Rdy )begin
            
            for(integer i = 0; i < 1; i = i + 1 )begin
              $fwrite(fp_GBWEI_IDWei_r, "%3d ", top.inst_PEB.WEIGB_Instr_Data[0+:5]);
            end
            $fwrite(fp_GBWEI_IDWei_r,"\n");
            // $fclose(fp_GBWEI_IDWei_r);

            IDWei[addr_w_idwei] <= top.inst_PEB.WEIGB_Instr_Data[0+:5];
            addr_w_idwei <= addr_w_idwei + 1;

        end
end

// initial begin
//     @(posedge top.rst_n);
//     @(posedge top.clk);
//     for (int i=0; i<40959; i++) begin

//         for(int j=0; j<16; j++)
//             top.data_if.rxcb_GBWEI_Data.GBWEI_Data[`C_LOG_2(`MAC_NUM) + `DATA_WIDTH*j +: `DATA_WIDTH] <= cfg.GBWEI_Data[top.Weirow][j];
//         do begin
//             if(top.DUMP_U.addr_r_idwei < top.DUMP_U.addr_w_idwei) begin
//                 top.data_if.rxcb_GBWEI_Data.GBWEI_Data[0 +: `C_LOG_2(`MAC_NUM)] <= top.DUMP_U.IDWei[top.DUMP_U.addr_r_idwei]; // dump
//                 `ifdef RANDOM
//                   top.data_if.rxcb_GBWEI_Data.GBWEI_Val <= $urandom%2;
//                 `else
//                   top.data_if.rxcb_GBWEI_Data.GBWEI_Val <= 1;
//                 `endif

//             end else
//                 top.data_if.rxcb_GBWEI_Data.GBWEI_Val <= 0;  
//             @top.data_if.rxcb_GBWEI_Data;
//             top.test_wei = 1;
//         end while( ~(top.data_if.rxcb_GBWEI_Data.WEIGB_Rdy && top.data_if.rxcb_GBWEI_Data.GBWEI_Val) && !top.reset_wei);
//         top.test_wei = 0;
//       if(top.reset_wei) begin
//         @top.data_if.rxcb_GBWEI_Data; // wait Weirow set to 0
//         @top.data_if.rxcb_GBWEI_Data; // wait Weirow set to 0
//       end
//       top.data_if.rxcb_GBWEI_Data.GBWEI_Val <= 0;

//     end
// end 


always @ ( posedge Clk )begin
  if( top.inst_PEB.PSUMGB_val0 && top.inst_PEB.GBPSUM_rdy0 )begin
  	for(integer i = 0; i < 16; i = i + 1 )begin
      $fwrite(fp_PSUMGB_data0_r, "%12d ", $signed(top.inst_PEB.PSUMGB_data0[32*i+:32]));
    end
    $fwrite(fp_PSUMGB_data0_r,"\n");
  end

end

always @ ( posedge Clk )begin
  if( top.inst_PEB.PSUMGB_val1 && top.inst_PEB.GBPSUM_rdy1 )begin
    for(integer i = 0; i < 16; i = i + 1 )begin
      $fwrite(fp_PSUMGB_data1_r, "%12d ", $signed(top.inst_PEB.PSUMGB_data1[32*i+:32]));
    end
    $fwrite(fp_PSUMGB_data1_r,"\n");
  end

end

always @ ( posedge Clk )begin
  if( top.inst_PEB.PSUMGB_val2 && top.inst_PEB.GBPSUM_rdy2 )begin
    for(integer i = 0; i < 16; i = i + 1 )begin
      $fwrite(fp_PSUMGB_data2_r, "%12d ", $signed(top.inst_PEB.PSUMGB_data2[32*i+:32]));
    end
    $fwrite(fp_PSUMGB_data2_r,"\n");
  end

end

always @ ( posedge Clk )begin
  if( top.inst_PEB.ACTPEB_val  )begin
    for(integer i = 0; i < 16; i = i + 1 )begin // Only val because pop and !fifo_full
      $fwrite(fp_ACTPEB_data_r, "%4d ", $signed(top.inst_PEB.ACTPEB_data[8*i+:8]));
    end
    $fwrite(fp_ACTPEB_data_r,"\n");
  end

end

always @ ( posedge Clk )begin
  if( top.inst_PEB.FLGACTPEB_val  )begin
    for(integer i = 0; i < 32; i = i + 1 )begin
      $fwrite(fp_FLGACTPEB_data_r, "%1d ", (top.inst_PEB.FLGACTPEB_data[i]));
    end
    $fwrite(fp_FLGACTPEB_data_r,"\n");
  end

end

endmodule

`endif
