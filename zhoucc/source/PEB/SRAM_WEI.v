//======================================================
// Copyright (C) 2019 By zhoucc
// All Rights Reserved
//======================================================
// Module : 
// Author : CC zhou
// Contact : 
// Date :  . .2019
//=======================================================
// Description :
//========================================================
`include "../source/include/dw_params_presim.vh"
// 16B GB in, 8B out
//
module SRAM_WEI #(// According ID: 1 Write; 
    parameter  IN_DATA_WIDTH = `SRAMWEI_WR_WIDTH,
    parameter  OUT_DATA_WIDTH = `REGWEI_WR_WIDTH,
    parameter  RD_NUM     = `MAC_NUM,
    parameter  ADDR_WIDTH = 2, // every Weight's Address space
    parameter  COUNT_WIDTH = (`C_LOG_2(RD_NUM)+ADDR_WIDTH+1),
    parameter  ADDR_WIDTH_ALL = 10

) (
    input                                       clk     ,
    input                                       rst_n   ,
    input                                       reset   ,

    input                                       instrout_rdy,
    output                                      instrout_val,
    output[`DATA_WIDTH -1 : 0] instrout    ,

    output                                      datain_rdy  ,// if 1 rdy, high level
    input                                       datain_val  ,
    input [IN_DATA_WIDTH+`C_LOG_2(RD_NUM)-1 : 0] datain   ,

    input [ADDR_WIDTH_ALL * RD_NUM      -1 : 0] AddrBlockWei,
    input [`MAC_NUM_WIDTH     -1 : 0] ARBMAC_IDWei[ 0 : `MAC_NUM -1],
    input  [ RD_NUM                     -1 : 0] dataout_rdy  , 
    input [ ADDR_WIDTH_ALL *RD_NUM      -1 : 0] dataout_addr ,                  
    output reg[ RD_NUM                  -1 : 0] dataout_val  ,
    output [ OUT_DATA_WIDTH             -1 : 0] dataout       

);
//=====================================================================================================================
// Constant Definition :
//=====================================================================================================================
wire [ `C_LOG_2(RD_NUM)         -1 : 0] wire_IDMAC_rd;

//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
reg [ `C_LOG_2(RD_NUM)      -1 : 0] scanf_id;
reg [ `C_LOG_2(RD_NUM)+ADDR_WIDTH+1 -1 : 0] req_write_count;

wire                                scanf_fnh;
wire                                write_fnh;

reg  [ `C_LOG_2(RD_NUM)    -1 : 0] id_wr_wei    ;
wire                                en_rd   ;
wire                                fifo_pop_d   ;
// wire  [ `C_LOG_2(RD_NUM)    -1 : 0] id_rd_wei;
wire  [ `C_LOG_2(RD_NUM)    -1 : 0] fifo_pop_id_d;

wire                                fifo_instr_push  ;
wire                                fifo_instr_pop   ;
wire [`DATA_WIDTH-1:0]fifo_instr_in    ;
wire [`DATA_WIDTH-1:0]fifo_instr_out   ;
wire                                fifo_instr_empty ;
wire                                fifo_instr_full  ;

wire [ COUNT_WIDTH              -1 : 0] empty_count;
wire [ `C_LOG_2(RD_NUM) + ADDR_WIDTH -1 : 0] addr_r;   
wire [ `C_LOG_2(RD_NUM) + ADDR_WIDTH -1 : 0] addr_w;  
wire                                        read_en; 
reg                                        write_en; 

wire                                    en_rd_wei;
wire                                    en_wr_wei;
wire [ ADDR_WIDTH_ALL           -1 : 0] addr_rd_mac[0: RD_NUM -1];
reg  [ ADDR_WIDTH_ALL           -1 : 0] addr_rd_mac_d[0: RD_NUM -1];
reg  [ ADDR_WIDTH_ALL           -1 : 0] addr_wr_wei[0: RD_NUM -1];
wire [ RD_NUM                   -1 : 0] val_rd_mac;
wire [ RD_NUM                   -1 : 0] One_IDMAC_rd;

reg  [ IN_DATA_WIDTH            -1 : 0] data_in; 
wire [ IN_DATA_WIDTH            -1 : 0] data_out; 
reg  [ IN_DATA_WIDTH            -1 : 0] data_out_tmp; 
wire [ `C_LOG_2(RD_NUM)         -1 : 0] IDMAC_rd;
wire [ `C_LOG_2(RD_NUM)         -1 : 0] IDMAC_rd_d;
wire [ `C_LOG_2(RD_NUM) + 2         -1 : 0] IDWei_rd;

wire [ `MAC_NUM_WIDTH           -1 : 0] MEM_ARBMAC_IDWei[0 : `MAC_NUM   -1];
// Logic Design :
//=====================================================================================================================
localparam IDLE = 3'b000;
localparam SCANF = 3'b001;
localparam WRITE = 3'b010;

reg [ 3 -1:0 ]state;
reg [ 3 -1:0 ]next_state;
always @(*) begin
    case ( state )
        IDLE :  if( 1'b1)
                    next_state <= SCANF; //A network config a time
                else
                    next_state <= IDLE;
        SCANF:  if ( reset )
                    next_state <= IDLE;
                else if( scanf_fnh)
                    next_state <= WRITE;
                else
                    next_state <= SCANF;
        WRITE:  if ( reset )
                    next_state <= IDLE;
                else if( write_fnh)//every layer
                    next_state <= SCANF;
                else
                    next_state <= WRITE;
        default: next_state <= IDLE;
    endcase
end
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        scanf_id <= 0;
    end else if ( reset ) begin 
        scanf_id <= 0;
    end else if ( scanf_fnh ) begin 
        scanf_id <= 0;
    end else if ( state == SCANF && !fifo_instr_full ) begin
        scanf_id <= scanf_id + 1;
    end
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        req_write_count <= 0;
    end else if ( reset ) begin 
        req_write_count <= 0;
    end else if ( fifo_instr_push ) begin // count require write
        req_write_count <= req_write_count + empty_count;
    end else if ( write_en ) begin // count written
        req_write_count <= req_write_count -1;
    end
end
assign write_fnh = req_write_count ==0;// Global Buffer write finish

// ***********************************************************
// Instr FIFO
// assign empty_count = 1<<ADDR_WIDTH - (addr_wr_wei[scanf_id]>>1 - AddrBlockWei[scanf_id]>>4); 
wire empty;
assign empty = (1<<ADDR_WIDTH) > ((addr_wr_wei[scanf_id]>>1) - (AddrBlockWei[ADDR_WIDTH_ALL*scanf_id +: ADDR_WIDTH_ALL]>>4) );
assign empty_count = empty? 1 : 0; 
// assign empty_count = 1; 

assign scanf_fnh       = scanf_id == RD_NUM -1;
assign fifo_instr_in   = { empty_count , scanf_id}; // 
assign fifo_instr_push = state==SCANF && ( empty_count) && !fifo_instr_full ;
assign fifo_instr_pop  = instrout_rdy && instrout_val;
assign instrout        = fifo_instr_out;
assign instrout_val    = !fifo_instr_empty && state == WRITE; // only WRITE; in order to separate write wei with scanf

// ***********************************************************
// SRAM Write/ Read

generate
    genvar i;
    for(i=0; i<RD_NUM;i=i+1) begin
        always @ ( posedge clk or negedge rst_n ) begin
            if ( !rst_n ) begin
                addr_wr_wei[i] <= 0;
            end else if ( reset) begin 
                addr_wr_wei[i] <= 0;
            end else if ( write_en && id_wr_wei==i ) begin
                addr_wr_wei[i] <= addr_wr_wei[i] + 2;
            end
        end
        // for 27 MAC
        assign addr_rd_mac[i] = dataout_addr[ADDR_WIDTH_ALL*i +: ADDR_WIDTH_ALL]; // 8B
        // for 27 MAC
        assign val_rd_mac[i] = addr_rd_mac[i] < addr_wr_wei[ARBMAC_IDWei[i]];

        assign MEM_ARBMAC_IDWei[i] = ARBMAC_IDWei[i];
        always @ ( posedge clk or negedge rst_n ) begin
            if ( !rst_n ) begin
                addr_rd_mac_d[i] <= 0;
            end else if ( reset ) begin 
                addr_rd_mac_d[i] <= 0;
            end else if ( read_en ) begin
                addr_rd_mac_d[i] <= addr_rd_mac[i];
            end
        end
    end
endgenerate

assign IDWei_rd = MEM_ARBMAC_IDWei[IDMAC_rd];

// Input Handshake
assign datain_rdy = next_state == WRITE; // write_fnh -> pull down

// assign write_en   = datain_val; // 2 Bytes
// assign id_wr_wei  = datain[`C_LOG_2(RD_NUM)-1:0];
// assign data_in    = datain[`C_LOG_2(RD_NUM) +: IN_DATA_WIDTH];

`ifdef DELAY_SRAM  // sim
wire [ `DATA_WIDTH  -1 : 0] mem_data_in[0 : 15];
generate
    genvar gv_j;
    for(gv_j=0; gv_j <16; gv_j=gv_j+1) begin
        assign mem_data_in[gv_j] = data_in[`DATA_WIDTH*gv_j +: `DATA_WIDTH];
    end
    
endgenerate
`endif

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        {data_in, id_wr_wei, write_en} <= 0;
    end else begin
        // {data_in, id_wr_wei, write_en} <= {datain, datain_val && datain_rdy} ;
        {data_in, id_wr_wei, write_en} <= {datain, datain_val} ; // only datain_val because of GB
    end
end

wire [ ADDR_WIDTH       -1 : 0] addr_rd_mac_sram; // cut to 2 bits
wire [ ADDR_WIDTH       -1 : 0] addr_wr_wei_sram;
assign addr_rd_mac_sram  = addr_rd_mac[IDMAC_rd] >> 1; // 2bits' compared address
assign addr_wr_wei_sram  = addr_wr_wei[id_wr_wei] >> 1;
assign addr_r  = addr_rd_mac_sram + 4*IDWei_rd ; // convert to absolute addr
assign addr_w  = addr_wr_wei_sram + 4*id_wr_wei;
assign read_en = | (dataout_rdy & val_rd_mac) && !write_en; // Write first

// LSB or MSB
assign dataout = addr_rd_mac_d[IDMAC_rd_d][0] ? data_out[64 +: 64] : data_out[0 +: 64];

// Delay a clk
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        dataout_val <= 0;
    end else if ( reset ) begin 
        dataout_val <= 0;
    end else if ( read_en ) begin
        dataout_val <= One_IDMAC_rd; // paulse
    end else begin
        dataout_val <= 0;
    end
end
// always @ ( posedge clk or negedge rst_n ) begin
//     if ( !rst_n ) begin
//         data_out_tmp <= 0;
//     end else if ( read_en ) begin
//         data_out_tmp <= data_out;
//     end
// end

//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================

RAM_ACT_wrap #(// Cant Write and Read Stimulately
        .SRAM_BIT(IN_DATA_WIDTH),// 32
        .SRAM_BYTE(1),
        .SRAM_WORD(2**ADDR_WIDTH*RD_NUM)
    ) inst_RAM_ACT_wrap (
        .clk      (clk),
        .rst_n    (rst_n),
        .addr_r   (addr_r),
        .addr_w   (addr_w),
        .read_en  (read_en),
        .write_en (write_en),
        .data_in  (data_in),
        .data_out (data_out)
    );
fifo_fwft #( // fifo_fwft : first output a data? ??????????
    .DATA_WIDTH(`DATA_WIDTH ),
    .ADDR_WIDTH(`C_LOG_2(RD_NUM) )
    ) fifo_instr(
    .clk ( clk ),
    .rst_n ( rst_n ),
    .Reset ( reset),
    .push(fifo_instr_push),
    .pop(fifo_instr_pop ),
    .data_in( fifo_instr_in),
    .data_out (fifo_instr_out ),
    .empty(fifo_instr_empty ),
    .full (fifo_instr_full ),
    .fifo_count()
    );

ARRAY2ID  #(
    .ARRAY_WIDTH(RD_NUM)
    )ARRAY2ID_IDfifo(
    .Array((dataout_rdy & val_rd_mac)),
    .ID(IDMAC_rd),
    .Array_One(One_IDMAC_rd)
    );
// always @ ( posedge clk or negedge rst_n ) begin
//     if ( !rst_n ) begin
//         IDMAC_rd <= 0;
//     end else begin
//         IDMAC_rd <= wire_IDMAC_rd;
//     end
// end

Delay #(
    .NUM_STAGES(1),
    .DATA_WIDTH(`C_LOG_2(RD_NUM))
    )Delay_IDMAC_rd_d(
    .CLK(clk),
    .RESET_N(rst_n),
    .DIN(IDMAC_rd),
    .DOUT(IDMAC_rd_d)
    );
endmodule