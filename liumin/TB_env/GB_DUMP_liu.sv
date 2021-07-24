module GB_DUMP_liu # (
    parameter DATA_TYPE_WEIFLG = 1,
    parameter DATA_TYPE_ACT    = 2,
    parameter DATA_TYPE_ACTFLG = 3,
    parameter ADDR_WIDTH       = 9,
    parameter PORT_WIDTH       = 128,
    parameter WEI_WR_WIDTH     = 128, // 16B
    parameter FLGWEI_WR_WIDTH  = 64, // 8B
    parameter ACT_WR_WIDTH     = 128, // 16B
    parameter FLGACT_WR_WIDTH  = 32,  // 4B)
    parameter MEMDEPTH         = 512,
    parameter NUM_PEB          = 16,
    parameter PE_NUM           = 27,
    parameter WEIADDR_WR_WIDTH = 16,
    parameter INSTR_WIDTH      = 8
    )(
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    input DumpStart

);

wire IFGB_cfg_rdy = top.TS3D_U.inst_GB.IFGB_cfg_rdy;
wire GBIF_cfg_val = top.TS3D_U.inst_GB.GBIF_cfg_val;
wire [3 : 0]GBIF_cfg_info = top.TS3D_U.inst_GB.GBIF_cfg_info;

wire GBIF_rd_rdy = top.TS3D_U.inst_GB.GBIF_rd_rdy;
wire IFGB_rd_val = top.TS3D_U.inst_GB.IFGB_rd_val;
wire [PORT_WIDTH - 1 : 0]IFGB_rd_data = top.TS3D_U.inst_GB.IFGB_rd_data;

wire IFGB_wr_rdy = top.TS3D_U.inst_GB.IFGB_wr_rdy;
wire GBIF_wr_val = top.TS3D_U.inst_GB.GBIF_wr_val;
wire [PORT_WIDTH - 1 : 0]GBIF_wr_data = top.TS3D_U.inst_GB.GBIF_wr_data;

//==================================================================================

wire [NUM_PEB              -1 : 0] GBWEI_instr_rdy = top.TS3D_U.inst_GB.GBWEI_instr_rdy;
wire [NUM_PEB              -1 : 0] WEIGB_instr_val = top.TS3D_U.inst_GB.WEIGB_instr_val;
wire [INSTR_WIDTH*NUM_PEB  -1 : 0] WEIGB_instr_data = top.TS3D_U.inst_GB.WEIGB_instr_data;

wire [NUM_PEB         - 1 : 0]WEIGB_rdy = top.TS3D_U.inst_GB.WEIGB_rdy;
wire [NUM_PEB         - 1 : 0]GBWEI_val = top.TS3D_U.inst_GB.GBWEI_val;
wire [WEI_WR_WIDTH    + 4 : 0]GBWEI_data = top.TS3D_U.inst_GB.GBWEI_data;

wire [NUM_PEB - 1 : 0]FLGWEIGB_rdy = top.TS3D_U.inst_GB.FLGWEIGB_rdy;
wire [NUM_PEB - 1 : 0]GBFLGWEI_val = top.TS3D_U.inst_GB.GBFLGWEI_val;
wire [FLGWEI_WR_WIDTH - 1 : 0]GBFLGWEI_data = top.TS3D_U.inst_GB.GBFLGWEI_data;

wire ACTGB_rdy = top.TS3D_U.inst_GB.ACTGB_rdy;
wire GBACT_val = top.TS3D_U.inst_GB.GBACT_val;
wire [ACT_WR_WIDTH    - 1 : 0]GBACT_data = top.TS3D_U.inst_GB.GBACT_data;

wire FLGACTGB_rdy = top.TS3D_U.inst_GB.FLGACTGB_rdy;
wire GBFLGACT_val = top.TS3D_U.inst_GB.GBFLGACT_val;
wire [FLGACT_WR_WIDTH - 1 : 0]GBFLGACT_data = top.TS3D_U.inst_GB.GBFLGACT_data;

wire CCUGB_pullback_wei = top.TS3D_U.inst_GB.CCUGB_pullback_wei;
wire CCUGB_pullback_act = top.TS3D_U.inst_GB.CCUGB_pullback_act;

//--------------------- data_in dump out ---------------------
integer input_file, input_file_instr, input_file_w, input_file_wa, input_file_wf, input_file_a, input_file_af;
integer k, j, m;
initial begin
    input_file          = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/input_file.txt", "a");
    input_file_instr  = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/input_file_instr.txt", "a");
    input_file_w       = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/input_file_w.txt", "a");
    input_file_wa     = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/input_file_wa.txt", "a");
    input_file_wf     = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/input_file_wf.txt", "a");
    input_file_a       = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/input_file_a.txt", "a");
    input_file_af      = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/input_file_af.txt", "a");
end

always @(posedge clk or negedge rst_n) begin
    if (GBIF_rd_rdy & IFGB_rd_val) begin
        if(GBIF_cfg_info == {1'b0, 2'd3, 1'b1})begin
            $fwrite(input_file_wa, "%16b\n%16b\n%16b\n%16b\n%16b\n%16b\n%16b\n%16b", IFGB_rd_data[15:0], IFGB_rd_data[31:16], IFGB_rd_data[47:32], IFGB_rd_data[63:48], IFGB_rd_data[79:64], IFGB_rd_data[95:80], IFGB_rd_data[111:96], IFGB_rd_data[127:112]);$fwrite(input_file_wa, "\n");
        end else if (GBIF_cfg_info == {1'b1, 2'd0, 1'b1}) begin
            $fwrite(input_file_w, "%128b", IFGB_rd_data);$fwrite(input_file_w, "\n");
        end else if (GBIF_cfg_info == {1'b1, 2'd1, 1'b1}) begin
            $fwrite(input_file_wf, "%64b\n%64b", IFGB_rd_data[63  :  0], IFGB_rd_data[127 : 64]);$fwrite(input_file_wf, "\n");
        end else if (GBIF_cfg_info == {1'b1, 2'd2, 1'b1}) begin
            $fwrite(input_file_a, "%128b", IFGB_rd_data);$fwrite(input_file_a, "\n");
        end else if (GBIF_cfg_info == {1'b1, 2'd3, 1'b1}) begin
            $fwrite(input_file_af, "%32b", IFGB_rd_data[31  :  0]);$fwrite(input_file_af, "\n");
            $fwrite(input_file_af, "%32b", IFGB_rd_data[63  : 32]);$fwrite(input_file_af, "\n");
            $fwrite(input_file_af, "%32b", IFGB_rd_data[95  : 64]);$fwrite(input_file_af, "\n");
            $fwrite(input_file_af, "%32b", IFGB_rd_data[127 : 96]);$fwrite(input_file_af, "\n");
        end
        $fwrite(input_file, "%128b", IFGB_rd_data);$fwrite(input_file, "\n");
    end
end




//--------------------- read out dump out ---------------------
//===================== instr ======================
always @(posedge clk or negedge rst_n) begin
    for (k = 0; k < 16; k = k + 1)begin
        if (WEIGB_instr_val[k] & GBWEI_instr_rdy[k]) begin
            $fwrite(input_file_instr, "%4d\t%5d\t%3d", k, WEIGB_instr_data[k * 8 +: 5], WEIGB_instr_data[k * 8 + 5 +: 3]);$fwrite(input_file_instr, "\n");
        end

    end
end

//===================== weight =====================
integer out_file_w;
initial begin
    out_file_w = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/out_file_w.txt", "a");
end
always @(posedge clk or negedge rst_n) begin
    // for (j = 0; j < 16; j = j + 1)begin
        if (WEIGB_rdy & GBWEI_val) begin
            $fwrite(out_file_w, "%128b", GBWEI_data[132 : 5]);$fwrite(out_file_w, "\n");
        end
        if (CCUGB_pullback_wei) begin
            $fwrite(out_file_w, "\n");
            $fwrite(input_file_instr, "\n");
        end
        // break;
    // end
end

//===================== wei flg =====================
integer out_file_wf;
initial begin
    out_file_wf = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/out_file_wf.txt", "a");
end


always @(posedge clk or negedge rst_n) begin
    // for (m = 0; m < 16; m = m + 1)begin
        if (FLGWEIGB_rdy& GBFLGWEI_val) begin
            $fwrite(out_file_wf, "%64b", GBFLGWEI_data);$fwrite(out_file_wf, "\n");
        end
end

//===================== act =====================
integer out_file_a;
initial begin
    out_file_a = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/out_file_a.txt", "a");
end
always @(posedge clk or negedge rst_n) begin
    if (ACTGB_rdy & GBACT_val) begin
        $fwrite(out_file_a, "%128b", GBACT_data);$fwrite(out_file_a, "\n");
    end
end

//===================== act flg =====================
integer out_file_af;
initial begin
    out_file_af = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/out_file_af.txt", "a");
end
always @(posedge clk or negedge rst_n) begin
    if (FLGACTGB_rdy & GBFLGACT_val) begin
        $fwrite(out_file_af, "%32b", GBFLGACT_data);$fwrite(out_file_af, "\n");
    end
end


//-----------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------          read_out cnt          --------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------
integer out_file_w_cnt, out_file_wf_cnt, out_file_wi_cnt, out_file_a_cnt, out_file_af_cnt;
initial begin
    out_file_w_cnt = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/read_out_cnt/wei_data.txt", "a");
    out_file_wf_cnt = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/read_out_cnt/wei_flag.txt", "a");
    out_file_wi_cnt = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/read_out_cnt/wei_instr.txt", "a");
    out_file_a_cnt = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/read_out_cnt/act_data.txt", "a");
    out_file_af_cnt = $fopen("/workspace/home/zhoucc/Share/TS3D/liumin/dump/read_out_cnt/act_flag.txt", "a");
end

reg [31 : 0]wei_data_cnt;
reg [31 : 0]wei_flag_cnt;
reg [31 : 0]wei_instr_cnt;

reg [31 : 0]act_data_cnt;
reg [31 : 0]act_flag_cnt;

always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wei_data_cnt <= 0;
        end else if (CCUGB_pullback_wei) begin
            $fwrite(out_file_w_cnt, "%d", wei_data_cnt);
            $fwrite(out_file_w_cnt, "\n");
            wei_data_cnt <= 0;
        end else if (WEIGB_rdy & GBWEI_val) begin
            wei_data_cnt <= wei_data_cnt + 1;
        end
end

always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wei_flag_cnt <= 0;
        end else if (CCUGB_pullback_wei) begin
            $fwrite(out_file_wf_cnt, "%d", wei_flag_cnt);
            $fwrite(out_file_wf_cnt, "\n");
            wei_flag_cnt <= 0;
        end else if (FLGWEIGB_rdy & GBFLGWEI_val) begin
            wei_flag_cnt <= wei_flag_cnt + 1;
        end
end

always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wei_instr_cnt <= 0;
        end else if (CCUGB_pullback_wei) begin
            $fwrite(out_file_wi_cnt, "%d", wei_instr_cnt);
            $fwrite(out_file_wi_cnt, "\n");
            wei_instr_cnt <= 0;
        end else if (WEIGB_instr_val & GBWEI_instr_rdy) begin
            wei_instr_cnt <= wei_instr_cnt + 1;
        end
end

always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            act_data_cnt <= 0;
        end else if (CCUGB_pullback_act) begin
            $fwrite(out_file_a_cnt, "%d", act_data_cnt);
            $fwrite(out_file_a_cnt, "\n");
            act_data_cnt <= 0;
        end else if (ACTGB_rdy & GBACT_val) begin
            act_data_cnt <= act_data_cnt + 1;
        end
end

always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            act_flag_cnt <= 0;
        end else if (CCUGB_pullback_act) begin
            $fwrite(out_file_af_cnt, "%d", act_flag_cnt);
            $fwrite(out_file_af_cnt, "\n");
            act_flag_cnt <= 0;
        end else if (FLGACTGB_rdy & GBFLGACT_val) begin
            act_flag_cnt <= act_flag_cnt + 1;
        end
end


endmodule
