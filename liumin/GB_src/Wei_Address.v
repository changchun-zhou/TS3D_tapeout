// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : MinLiu
// File   : Wei_Address.v
// Create : 2020-07-20 16:55:37
// Revise : 2020-08-07 08:59:39
// -----------------------------------------------------------------------------
// Description :
// -----------------------------------------------------------------------------
module Wei_Address # (
    parameter PORT_WIDTH       = 128,
    parameter NUM_PEB          = 16,
    parameter PE_NUM           = 27,
    parameter WEIADDR_WR_WIDTH = 16,
    parameter INSTR_WIDTH      = 8
    )(
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    input SRAM_config_start,
    input read_Cyc_done_Wei,

    input  IFWeiAddr_Conf_rdy,
    output WeiAddrIF_Conf_val,

    input  IFADDR_val,
    output ADDRIF_rdy,
    input  [PORT_WIDTH - 1 : 0]Wei_Addr_Wr,

    input  CCUGB_pullback_wei,
    input  [11 : 0]Cycl_num_wei,
    input  [1 : 0]State_Wei_Rd,

    output GBWEI_instr_rdy,
    input  WEIGB_instr_val,
    input  [3 : 0]Which_PEB,
    input  [INSTR_WIDTH  - 1 : 0] WEIGB_instr_data,


    output reg WeiData_read_en,
    output reg [15 : 0]WeiData_addr,
    output read_SRAM_done,
    output [3 : 0]Which_PEB_to_PE,
    output [4 : 0]Which_PE_to_PE,
    output reg [2 : 0]data_type, 

    output reg [2 : 0]state

);


reg [11 : 0]cyc_cnt;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cyc_cnt <= 0;
    end else if (SRAM_config_start) begin
        cyc_cnt <= 0;
    end else if (CCUGB_pullback_wei) begin
        if (cyc_cnt == Cycl_num_wei - 1) begin
            cyc_cnt <= 0;
        end else begin
            cyc_cnt <= cyc_cnt + 1;
        end
    end
end

assign read_SRAM_done = (cyc_cnt == Cycl_num_wei - 1) && (CCUGB_pullback_wei == 1);

wire write_en;
reg [8 : 0]addr_w;
parameter IDLE = 3'b000, CFG = 3'b001, WRITE = 3'b011, READY_TO_READ = 3'b010, READ = 3'b110;
parameter RD_IDLE = 2'b00, RD_READ_READY = 2'b01, RD_READ = 2'b11;


reg [2 : 0]next_state;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

reg start_fgroup;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        start_fgroup <= 0;
    end else if ( read_SRAM_done ) begin
        start_fgroup <= 1;
    end else begin
        start_fgroup <= 0;
    end
end


always @( * ) begin
    if (~rst_n) begin
        next_state = IDLE;
    end else begin
        case(state)
        IDLE: if (SRAM_config_start | start_fgroup) begin
            next_state = CFG;
        end else begin
            next_state = IDLE;
        end

        CFG: if (IFWeiAddr_Conf_rdy) begin
            next_state = WRITE;
        end else begin
            next_state = CFG;
        end

        WRITE: if (SRAM_config_start  | start_fgroup) begin
            next_state = CFG;
        end else if (write_en == 1 && addr_w == PE_NUM * NUM_PEB - 8) begin
            next_state = READY_TO_READ;
        end else begin
            next_state = WRITE;
        end

        READY_TO_READ: if (SRAM_config_start  | start_fgroup) begin
            next_state = CFG;
        end else begin
            next_state = READ;
        end

        READ: if (SRAM_config_start  | start_fgroup) begin
            next_state = CFG;
        end else if (read_SRAM_done) begin
            next_state = IDLE;
        end else if (CCUGB_pullback_wei) begin
            next_state = READY_TO_READ;
        end else begin
            next_state = READ;
        end

        default: next_state = IDLE;

        endcase
    end
end

assign WeiAddrIF_Conf_val = (state == CFG) && (read_Cyc_done_Wei == 0);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_type <= 0;
    end else if (state == IDLE && next_state == WRITE) begin
        data_type <= 3'b011;
    end else if (state == WRITE && next_state == READY_TO_READ)begin
        data_type <= 0;
    end
end


//===================== write data to weiaddr =====================
assign ADDRIF_rdy = (state == WRITE);
assign write_en   = ADDRIF_rdy & IFADDR_val;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        addr_w <= 0;
    end else if (SRAM_config_start) begin
        addr_w <= 0;
    end else if (write_en == 1) begin
        if (addr_w == PE_NUM * NUM_PEB - 8) begin
            addr_w <= 0;
        end else begin
            addr_w <= addr_w + 8;
        end
    end
end

reg [15 : 0]Wei_Addr_Mem_1[0 : PE_NUM * NUM_PEB - 1];
reg [15 : 0]Wei_Addr_Mem_2[0 : PE_NUM * NUM_PEB - 1];
always @(posedge clk) begin
    if (write_en) begin
        Wei_Addr_Mem_1[addr_w + 0] <= Wei_Addr_Wr[WEIADDR_WR_WIDTH * 0 +: WEIADDR_WR_WIDTH];
        Wei_Addr_Mem_1[addr_w + 1] <= Wei_Addr_Wr[WEIADDR_WR_WIDTH * 1 +: WEIADDR_WR_WIDTH];
        Wei_Addr_Mem_1[addr_w + 2] <= Wei_Addr_Wr[WEIADDR_WR_WIDTH * 2 +: WEIADDR_WR_WIDTH];
        Wei_Addr_Mem_1[addr_w + 3] <= Wei_Addr_Wr[WEIADDR_WR_WIDTH * 3 +: WEIADDR_WR_WIDTH];
        Wei_Addr_Mem_1[addr_w + 4] <= Wei_Addr_Wr[WEIADDR_WR_WIDTH * 4 +: WEIADDR_WR_WIDTH];
        Wei_Addr_Mem_1[addr_w + 5] <= Wei_Addr_Wr[WEIADDR_WR_WIDTH * 5 +: WEIADDR_WR_WIDTH];
        Wei_Addr_Mem_1[addr_w + 6] <= Wei_Addr_Wr[WEIADDR_WR_WIDTH * 6 +: WEIADDR_WR_WIDTH];
        Wei_Addr_Mem_1[addr_w + 7] <= Wei_Addr_Wr[WEIADDR_WR_WIDTH * 7 +: WEIADDR_WR_WIDTH];
    end
end


//===================== read data from weiaddr =====================
wire WeiAddr_read_en;
wire [8 : 0]WeiAddr_addr;
reg  [3 : 0]Wei_Access_cnt;

assign GBWEI_instr_rdy = State_Wei_Rd == RD_READ && state == READ && Wei_Access_cnt == 0;

assign WeiAddr_read_en = WEIGB_instr_val & GBWEI_instr_rdy;
assign WeiAddr_addr    = (Which_PEB ) * 27 + (WEIGB_instr_data[4 : 0]);

reg [0 : PE_NUM * NUM_PEB - 1]Turn_Flag;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Turn_Flag <= 0;
    end else if (state == READY_TO_READ) begin
        Turn_Flag <= 0;
    end else if (WEIGB_instr_val & GBWEI_instr_rdy) begin
        Turn_Flag[WeiAddr_addr] <= 1;
    end
end


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Wei_Access_cnt <= 0;
    end else if (WEIGB_instr_val & GBWEI_instr_rdy) begin
        Wei_Access_cnt <= WEIGB_instr_data[7 : 5] - 1;
    end else if (Wei_Access_cnt != 0) begin
        Wei_Access_cnt <= Wei_Access_cnt - 1;
    end
end


//===================== the addr of SRAM_wei and the corsp read_en =====================

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        WeiData_addr <= 0;
    end else if (WeiAddr_read_en) begin
        if (Turn_Flag[WeiAddr_addr] == 1) begin
            WeiData_addr <= Wei_Addr_Mem_2[WeiAddr_addr];
        end else begin
            WeiData_addr <= Wei_Addr_Mem_1[WeiAddr_addr];
        end
    end else if (Wei_Access_cnt != 0) begin
        WeiData_addr <= WeiData_addr + 1;
    end
end



always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        WeiData_read_en <= 0;
    end else if (WeiAddr_read_en) begin
        WeiData_read_en <= 1;
    end else if (Wei_Access_cnt != 0) begin
        WeiData_read_en <= 1;
    end else begin
        WeiData_read_en <= 0;
    end
end


//===================== write bias weiaddr to MEM_2 =====================
reg Bias_WeiAddr_wr_en;
wire [15 : 0]Bias_WeiAddR;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Bias_WeiAddr_wr_en <= 0;
    end else begin
        Bias_WeiAddr_wr_en <= WeiAddr_read_en;
    end
end

reg [8 : 0]Bias_WeiAddr_addr;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Bias_WeiAddr_addr <= 0;
    end else if (WeiAddr_read_en) begin
        Bias_WeiAddr_addr <= WeiAddr_addr;
    end
end

always @(posedge clk) begin
    if (Bias_WeiAddr_wr_en) begin
        Wei_Addr_Mem_2[Bias_WeiAddr_addr] <= WeiData_addr + Wei_Access_cnt + 1;
    end
end


//===================== generate which_PEB_to_PE =====================
reg [3 : 0]Which_PEB_t;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Which_PEB_t <= 0;
    end else if (WeiAddr_read_en) begin
        Which_PEB_t <= Which_PEB;
    end
end

reg [4 : 0]Which_PE_t;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Which_PE_t <= 0;
    end else if (WeiAddr_read_en) begin
        Which_PE_t <= WEIGB_instr_data[4 : 0];
    end
end

    Delay #(
            .NUM_STAGES(1),
            .DATA_WIDTH(4)
        ) inst_Delay (
            .CLK     (clk),
            .RESET_N (rst_n),
            .DIN     (Which_PEB_t),
            .DOUT    (Which_PEB_to_PE)
        );

        Delay #(
            .NUM_STAGES(1),
            .DATA_WIDTH(5)
        ) inst_Delay_which_PE (
            .CLK     (clk),
            .RESET_N (rst_n),
            .DIN     (Which_PE_t),
            .DOUT    (Which_PE_to_PE)
        );





endmodule
