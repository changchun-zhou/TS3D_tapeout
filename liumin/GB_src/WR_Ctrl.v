// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : MinLiu 
// File   : WR_Ctrl.v
// Create : 2020-07-12 20:59:35
// Revise : 2020-07-31 11:27:58
// -----------------------------------------------------------------------------
// Description :
// -----------------------------------------------------------------------------
module WR_Ctrl #(
    parameter SRAM_ADDRWIDTH = 9, 
    parameter SRAM_DEPTH = 2 ** SRAM_ADDRWIDTH, 
    parameter WR_IDLE = 2'b00, 
    parameter WR_REQ_READY = 2'b01, 
    parameter WR_WRITE = 2'b11
    )(
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    input SRAM_config_start,

    input read_Cyc_done_Wei, 
    input read_Cyc_done_WeiFlg, 
    input read_Cyc_done_Act, 
    input read_Cyc_done_ActFlg, 

    input [3  : 0]CFGGB_SRAM_num_wei, CFGGB_SRAM_num_flgwei, CFGGB_SRAM_num_act, CFGGB_SRAM_num_flgact, 
    input [3  : 0]CFGGB_Data_num_wei, CFGGB_Data_num_flgwei, CFGGB_Data_num_act, CFGGB_Data_num_flgact, 
    input [11 : 0]CFGGB_Cycl_num_wei, CFGGB_Cycl_num_flgwei, 
    input [7  : 0]CFGGB_Cycl_num_act, CFGGB_Cycl_num_flgact, 
    input [0  :15]Wr_Req_g, 

    output [5 : 0]SRAMIF_Wr_ID, 
    output done_Wei, done_WeiFlg, done_Act, done_ActFlg,
    
    output reg [1 : 0]State_Wr,  
    output write_en, 
    output write_SRAM_done, 
    output reg [SRAM_ADDRWIDTH - 1 : 0]addr_Wr,

     
    input IFSRAM_Conf_rdy, 
    output SRAMIF_Conf_val, 

    input IFSRAM_Wr_val, 
    output SRAMIF_Wr_rdy
    
);

wire Wr_Req_n; 
reg read_out_flag;
reg [1 : 0]next_State_Wr;


assign write_SRAM_done = (&addr_Wr == 1) && (write_en == 1);


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        State_Wr <= WR_IDLE;        
    end else begin
        State_Wr <= next_State_Wr;        
    end
end

always @( * ) begin
    if (~rst_n) begin
        next_State_Wr = WR_IDLE;        
    end else begin
        case(State_Wr)
        WR_IDLE: if (SRAM_config_start)begin 
            next_State_Wr = WR_IDLE;
        end else if (Wr_Req_n) begin
            next_State_Wr = WR_REQ_READY;
        end else begin
            next_State_Wr = WR_IDLE;
        end
        WR_REQ_READY: if (SRAM_config_start)begin 
            next_State_Wr = WR_IDLE;
        end else if (IFSRAM_Conf_rdy) begin
            next_State_Wr = WR_WRITE;
        end else begin
            next_State_Wr = WR_REQ_READY;
        end
        WR_WRITE: if (SRAM_config_start)begin 
            next_State_Wr = WR_IDLE;
        end else if (write_SRAM_done) begin
            next_State_Wr = WR_IDLE;
        end else begin
            next_State_Wr = WR_WRITE;
        end
        default: next_State_Wr = WR_IDLE;
        endcase
    end
end

assign SRAMIF_Conf_val = (State_Wr == WR_REQ_READY);
assign SRAMIF_Wr_rdy   = (State_Wr == WR_WRITE);

assign write_en = (State_Wr == WR_WRITE) && (IFSRAM_Wr_val == 1);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        addr_Wr <= 0;  
    end else if (SRAM_config_start) begin
        addr_Wr <= 0;
    end else if (write_en) begin
        addr_Wr <= addr_Wr + 1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        read_out_flag <= 1'b0;        
    end else if (State_Wr == WR_IDLE && next_State_Wr == WR_REQ_READY) begin
        read_out_flag <= 1'b1;
    end else begin
        read_out_flag <= 1'b0; 
    end
end


WR_Next_ID inst_WR_Next_ID(
        .clk                   (clk),
        .rst_n                 (rst_n),
        .SRAM_config_start     (SRAM_config_start),

        .read_Cyc_done_Wei      (read_Cyc_done_Wei), 
        .read_Cyc_done_WeiFlg   (read_Cyc_done_WeiFlg), 
        .read_Cyc_done_Act      (read_Cyc_done_Act), 
        .read_Cyc_done_ActFlg   (read_Cyc_done_ActFlg), 


        .next_Wr_ID_flag       (read_out_flag),
        .State_Wr              (State_Wr), 
        .CFGGB_SRAM_num_wei    (CFGGB_SRAM_num_wei),
        .CFGGB_SRAM_num_flgwei (CFGGB_SRAM_num_flgwei),
        .CFGGB_SRAM_num_act    (CFGGB_SRAM_num_act),
        .CFGGB_SRAM_num_flgact (CFGGB_SRAM_num_flgact),
        .CFGGB_Data_num_wei    (CFGGB_Data_num_wei),
        .CFGGB_Data_num_flgwei (CFGGB_Data_num_flgwei),
        .CFGGB_Data_num_act    (CFGGB_Data_num_act),
        .CFGGB_Data_num_flgact (CFGGB_Data_num_flgact),
        .CFGGB_Cycl_num_wei    (CFGGB_Cycl_num_wei),
        .CFGGB_Cycl_num_flgwei (CFGGB_Cycl_num_flgwei),
        .CFGGB_Cycl_num_act    (CFGGB_Cycl_num_act),
        .CFGGB_Cycl_num_flgact (CFGGB_Cycl_num_flgact),
        .SRAMIF_Wr_ID          (SRAMIF_Wr_ID), 
        .Wr_Req_g              (Wr_Req_g),
        .Wr_Req_n              (Wr_Req_n),
        .done_Wei              (done_Wei),
        .done_WeiFlg           (done_WeiFlg),
        .done_Act              (done_Act),
        .done_ActFlg           (done_ActFlg)
    );

endmodule