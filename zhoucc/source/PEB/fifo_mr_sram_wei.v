`timescale 1ns/1ps
`include "../source/include/dw_params_presim.vh"
module fifo_mr_sram_wei // multiple read; mem -> SRAM
#(  // Parameters
    parameter   DATA_WIDTH          = 64,
    parameter   INIT                = "init.mif",
    parameter   ADDR_WIDTH          = 1,// 2 Each id's Address space
    parameter   RAM_DEPTH      = (1 << ADDR_WIDTH),
    parameter   INITIALIZE_FIFO     = "no",
    parameter   TYPE                = "MLAB",
    parameter   RD_NUM              = 27,
    parameter   COUNT_WIDTH = (`C_LOG_2(RD_NUM)+ADDR_WIDTH+1)
)(  // Ports
    input  wire                             clk,
    input  wire                             rst_n,
    input  wire                             Reset,
    input  wire                             push,
    input  wire [ `C_LOG_2(RD_NUM)       -1 : 0]  push_id,
    input  wire                             pop,//own
    input  wire [ `C_LOG_2(RD_NUM)        -1: 0]  pop_id,
    input  wire [ DATA_WIDTH      -1 : 0]   data_in,
    output wire  [ DATA_WIDTH     -1 : 0]  data_out,
    output wire  [ RD_NUM          -1 : 0 ] empty, // own
    output wire  [ RD_NUM         -1 : 0]   full, // share: because 1 write
    output reg   [ COUNT_WIDTH*RD_NUM -1 : 0]  fifo_count 
);

// Port Declarations
// ******************************************************************
// Internal variables
// ******************************************************************
reg  [ RD_NUM          - 1 : 0] empty_inter;
reg  [ RD_NUM          - 1 : 0] full_inter;


//(* ram_style = TYPE *)
// reg     [DATA_WIDTH-1:0]        mem[0:RAM_DEPTH-1];     //Memory/*synthesis ramstyle = "MLAB" */
// ******************************************************************
// INSTANTIATIONS
// ******************************************************************
// initial begin
//   if (INITIALIZE_FIFO == "yes") begin
//     $readmemb(INIT, mem, 0, RAM_DEPTH-1);
//   end
// end
        reg     [ADDR_WIDTH-1:0]        rd_pointer[0:RD_NUM-1];             //Read Pointer
        reg     [ADDR_WIDTH-1:0]        wr_pointer[0:RD_NUM-1];             //Write Pointer

assign full = full_inter;
assign empty = empty_inter;
generate
    genvar i;
    for(i=0;i<RD_NUM;i=i+1) begin:GEN
        wire  push_inter;
        wire  pop_inter;

        assign push_inter = push && push_id==i;
        assign pop_inter = pop && pop_id == i;
        always @ (posedge clk or negedge rst_n)
        begin : WRITE_PTR
          if (!rst_n) begin
            wr_pointer[i] <= 0;
          end else if( Reset )begin
            wr_pointer[i] <= 0;
          end else if (push_inter && !full_inter[i]) begin
            wr_pointer[i] <= wr_pointer[i] + 1;
          end
        end


        always @ (fifo_count[COUNT_WIDTH*i +: COUNT_WIDTH])
        begin : FIFO_STATUS
          empty_inter[i]   = (fifo_count[COUNT_WIDTH*i +: COUNT_WIDTH] == 0);
          full_inter[i]    = (fifo_count[COUNT_WIDTH*i +: COUNT_WIDTH] == RAM_DEPTH);
        end

        always @ (posedge clk or negedge rst_n)
        begin : FIFO_COUNTER
          if (!rst_n) begin
            if( INITIALIZE_FIFO == "yes")
              fifo_count[COUNT_WIDTH*i +: COUNT_WIDTH] <= RAM_DEPTH;
            else
              fifo_count[COUNT_WIDTH*i +: COUNT_WIDTH] <= 0;
          end else if( Reset) begin
              fifo_count[COUNT_WIDTH*i +: COUNT_WIDTH] <= 0;
          end else if (push_inter && (!pop_inter||pop_inter&&empty_inter[i]) && !full_inter[i])
            fifo_count[COUNT_WIDTH*i +: COUNT_WIDTH] <= fifo_count[COUNT_WIDTH*i +: COUNT_WIDTH] + 1;
          else if (pop_inter && (!push_inter||push_inter&&full_inter[i]) && !empty_inter[i])
            fifo_count[COUNT_WIDTH*i +: COUNT_WIDTH] <= fifo_count[COUNT_WIDTH*i +: COUNT_WIDTH] - 1;
        end

        always @ (posedge clk or negedge rst_n)
        begin : READ_PTR
          if (!rst_n) begin
            rd_pointer[i] <= 0;
          end else if( Reset )begin
            rd_pointer[i] <= 0;
          end else if (pop_inter && !empty_inter[i]) begin
            rd_pointer[i] <= rd_pointer[i] + 1;
          end
        end

    end
endgenerate




wire [ `C_LOG_2(RD_NUM) + ADDR_WIDTH -1 : 0] addr_r;   
wire [ `C_LOG_2(RD_NUM) + ADDR_WIDTH -1 : 0] addr_w;  
wire                        read_en; 
wire                        write_en; 
assign addr_r = rd_pointer[pop_id];
assign addr_w = wr_pointer[push_id];
assign read_en = pop && !empty[pop_id];
assign write_en = push && !full[push_id];

RAM_WEI_wrap #(// Can't Write and Read Stimulately
        .SRAM_DEPTH_BIT(`C_LOG_2(RD_NUM) + ADDR_WIDTH),// 32
        .SRAM_WIDTH(DATA_WIDTH)
    ) inst_RAM_WEI_wrap (
        .clk      (clk),
        .rst_n    (rst_n),
        .addr_r   (addr_r),
        .addr_w   (addr_w),
        .read_en  (read_en),
        .write_en (write_en),
        .data_in  (data_in),
        .data_out (data_out)
    );

endmodule
