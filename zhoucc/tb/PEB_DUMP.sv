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

module PEB_DUMP( // dump output
  input   Clk,
  
  input   DumpStart,
  input   DumpEnd
);

  integer fp_GBACT_Data   [0 : 15];
  integer fp_GBFLGACT_data[0 : 15];
  integer fp_GBWEI_Data   [0 : 15];
  integer fp_GBFLGWEI_Data[0 : 15];

  integer fp_PSUMGB_data0_r  [0 : 15];
  integer fp_PSUMGB_data1_r  [0 : 15];
  integer fp_PSUMGB_data2_r  [0 : 15];
  integer fp_ACTPEB_data_r   [0 : 15];
  integer fp_FLGACTPEB_data_r[0 : 15];

initial begin
    for(int file_i=0; file_i <16; file_i=file_i+1) begin
        fp_GBACT_Data      [file_i] = $fopen({"dump_rtl/GBACT_Data_"    ,file_i,".txt"}, "wb");
        fp_GBFLGACT_data   [file_i] = $fopen({"dump_rtl/GBFLGACT_data_" ,file_i,".txt"}, "wb");
        fp_GBWEI_Data      [file_i] = $fopen({"dump_rtl/GBWEI_Data_"    ,file_i,".txt"}, "wb");
        fp_GBFLGWEI_Data   [file_i] = $fopen({"dump_rtl/GBFLGWEI_Data_" ,file_i,".txt"}, "wb");
        fp_GBWEI_IDWei_r   [file_i] = $fopen({"dump_rtl/GBWEI_IDWei_"   ,file_i,".txt"}, "wb");
        fp_PSUMGB_data0_r  [file_i] = $fopen({"dump_rtl/PSUMGB_data0_"  ,file_i,".txt"}, "wb");
        fp_PSUMGB_data1_r  [file_i] = $fopen({"dump_rtl/PSUMGB_data1_"  ,file_i,".txt"}, "wb");
        fp_PSUMGB_data2_r  [file_i] = $fopen({"dump_rtl/PSUMGB_data2_"  ,file_i,".txt"}, "wb");
        fp_ACTPEB_data_r   [file_i] = $fopen({"dump_rtl/ACTPEB_data_"   ,file_i,".txt"}, "wb");
        fp_FLGACTPEB_data_r[file_i] = $fopen({"dump_rtl/FLGACTPEB_data_",file_i,".txt"}, "wb");
    end
end 

generate
    genvar gv_i;
    for(gv_i=0; gv_i<16; gv_i=gv_i+1) begin:PEB

        always @ ( posedge Clk )begin
            if(top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.ACTGB_Rdy && top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.GBACT_Val ) begin
                for(int j=0; j<16 ; j=j+1)
                    $fwrite(fp_GBACT_Data[gv_i], "%04d", $signed(top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.GBACT_Data[`DATA_WIDTH*j +: `DATA_WIDTH]));
                $fwrite(fp_GBACT_Data[gv_i], "\n");//16B
            end 
        end

        always @ ( posedge Clk )begin
            if(top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.FLGACTGB_rdy && top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.GBFLGACT_val ) begin
                for(int j=0; j<32 ; j=j+1)
                    $fwrite(fp_GBFLGACT_data[gv_i], "%01d", $signed(top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.GBFLGACT_data[j]));
                $fwrite(fp_GBFLGACT_data[gv_i], "\n");//16B
            end 
        end

        always @ ( posedge Clk )begin
            if(top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.WEIGB_Rdy && top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.GBWEI_Val ) begin
                for(int j=0; j<16 ; j=j+1)
                    $fwrite(fp_GBWEI_Data[gv_i], "%04d", $signed(top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.GBWEI_Data[`DATA_WIDTH*j +: `DATA_WIDTH]));
                $fwrite(fp_GBWEI_Data[gv_i], "\n");//16B
            end 
        end

        always @ ( posedge Clk )begin
            if(top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.FLGWEIGB_Rdy && top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.GBFLGWEI_Val ) begin
                for(int j=0; j<16 ; j=j+1)
                    $fwrite(fp_GBFLGWEI_Data[gv_i], "%04d", $signed(top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.GBFLGWEI_Data[j]));
                $fwrite(fp_GBFLGWEI_Data[gv_i], "\n");//16B
            end 
        end


        // ************************************************************************************************
        // OUTPUT DUMP
        // 
        always @ ( posedge Clk )begin
            if(top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.GBWEI_Instr_Rdy && top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.WEIGB_Instr_Val ) begin
                for(int j=0; j<1 ; j=j+1)
                    $fwrite(fp_GBWEI_IDWei_r[gv_i], "%04d", $signed(top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.WEIGB_Instr_Data[`DATA_WIDTH*j +: `DATA_WIDTH]));
                $fwrite(fp_GBWEI_IDWei_r[gv_i], "\n");//16B
            end 
        end

        always @ ( posedge Clk )begin
          if( top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.PSUMGB_val0 && top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.GBPSUM_rdy0 )begin
          	for(integer i = 0; i < 16; i = i + 1 )begin
              $fwrite(fp_PSUMGB_data0_r[gv_i], "%12d ", $signed(top.inst_PEB.PSUMGB_data0[32*i+:32]));
            end
            $fwrite(fp_PSUMGB_data0_r[gv_i],"\n");
          end

        end

        always @ ( posedge Clk )begin
          if( top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.PSUMGB_val1 && top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.GBPSUM_rdy1 )begin
            for(integer i = 0; i < 16; i = i + 1 )begin
              $fwrite(fp_PSUMGB_data1_r[gv_i], "%12d ", $signed(top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.PSUMGB_data1[32*i+:32]));
            end
            $fwrite(fp_PSUMGB_data1_r[gv_i],"\n");
          end

        end

        always @ ( posedge Clk )begin
          if( top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.PSUMGB_val2 && top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.GBPSUM_rdy2 )begin
            for(integer i = 0; i < 16; i = i + 1 )begin
              $fwrite(fp_PSUMGB_data2_r[gv_i], "%12d ", $signed(top.inst_PEB.PSUMGB_data2[32*i+:32]));
            end
            $fwrite(fp_PSUMGB_data2_r[gv_i],"\n");
          end

        end

        always @ ( posedge Clk )begin
          if( top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.ACTPEB_val  )begin
            for(integer i = 0; i < 16; i = i + 1 )begin // Only val because pop and !fifo_full
              $fwrite(fp_ACTPEB_data_r[gv_i], "%4d ", $signed(top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.ACTPEB_data[8*i+:8]));
            end
            $fwrite(fp_ACTPEB_data_r[gv_i],"\n");
          end

        end

        always @ ( posedge Clk )begin
          if( top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.FLGACTPEB_val  )begin
            for(integer i = 0; i < 32; i = i + 1 )begin
              $fwrite(fp_FLGACTPEB_data_r[gv_i], "%1d ", (top.TS3D_U.inst_PEL.PEB[gv_i].inst_PEB.FLGACTPEB_data[i]));
            end
            $fwrite(fp_FLGACTPEB_data_r[gv_i],"\n");
          end

        end
    end
endgenerate

endmodule

`endif
