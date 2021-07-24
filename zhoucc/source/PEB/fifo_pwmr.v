`timescale 1ns/1ps
`include "../source/include/dw_params_presim.vh"
module fifo_pwmr // parallel write; multiple read
#(  // Parameters
    parameter   DATA_WIDTH          = 64,
    parameter   INIT                = "init.mif",
    parameter   ADDR_WIDTH          = 4,
    parameter   RAM_DEPTH           = (1 << ADDR_WIDTH),
    parameter   INITIALIZE_FIFO     = "no",
    parameter   TYPE                = "MLAB",
    parameter   RD_NUM              = 1,
    parameter   WR_NUM              = 1
)(  // Ports
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         Reset,
    input  wire                         push,
    input  wire [ RD_NUM          -1 : 0 ]   pop,// pop must valid
    input  wire [ ADDR_WIDTH*RD_NUM      -1 : 0 ] pop_offset,// RD_NUM*  1,2,3,4 ...
    input  wire [ DATA_WIDTH*WR_NUM -1 : 0 ]   data_in,
    output wire  [ DATA_WIDTH*RD_NUM -1 : 0 ] data_out, // stimulate with pop
    output wire  [ RD_NUM          -1 : 0 ] empty, // own
    output wire                           full // share: because 1 write
);

// Port Declarations
// ******************************************************************
// Internal variables
// ******************************************************************
reg  [ RD_NUM          - 1 : 0] empty_inter;
reg  [ RD_NUM          - 1 : 0] full_inter;

reg     [ADDR_WIDTH - `C_LOG_2(WR_NUM) -1:0]        wr_pointer;             //Write Pointer

//(* ram_style = TYPE *)
reg     [DATA_WIDTH-1:0]        mem[0:RAM_DEPTH-1];     //Memory/*synthesis ramstyle = "MLAB" */
// ******************************************************************
// INSTANTIATIONS
// ******************************************************************
initial begin
  if (INITIALIZE_FIFO == "yes") begin
    $readmemb(INIT, mem, 0, RAM_DEPTH-1);
  end
end
always @ (posedge clk or negedge rst_n)
begin : WRITE_PTR
  if (!rst_n) begin
    wr_pointer <= 0;
  end else if( Reset )begin
    wr_pointer <= 0;
  end else if (push && !full) begin
    wr_pointer <= wr_pointer + 1;
  end
end

generate
    genvar j;
    for(j=0;j<WR_NUM;j=j+1) begin

        always @ (posedge clk or negedge rst_n) begin :WRITE
          if( !rst_n) begin
            mem[wr_pointer+j] <= 0;
          end else if (push && !full) begin
            mem[wr_pointer+j] <= data_in;
          end
        end
    end
endgenerate


assign full = |full_inter;
assign empty = empty_inter;
generate
    genvar i;
    for(i=0;i<RD_NUM;i=i+1) begin:GEN_RD
        reg     [ADDR_WIDTH-1:0]        rd_pointer;             //Read Pointer
        reg     [ADDR_WIDTH :0]        fifo_count;             //Read Pointer

        always @ (fifo_count)
        begin : FIFO_STATUS
          empty_inter[i]   = (fifo_count == 0);
          full_inter[i]    = (fifo_count == RAM_DEPTH);
        end

        always @ (posedge clk or negedge rst_n)
        begin : FIFO_COUNTER
          if (!rst_n) begin
            if( INITIALIZE_FIFO == "yes")
              fifo_count <= RAM_DEPTH;
            else
              fifo_count <= 0;
          end else if( Reset) begin
              fifo_count <= 0;
          end else if (push && (!pop[i]||pop[i]&&empty_inter[i]) && !full_inter[i])
            fifo_count <= fifo_count + WR_NUM;//
          else if (pop[i] && (!push||push&&full_inter[i]) && !empty_inter[i])
            fifo_count <= fifo_count - pop_offset;
        end

        always @ (posedge clk or negedge rst_n)
        begin : READ_PTR
          if (!rst_n) begin
            rd_pointer <= 0;
          end else if( Reset )begin
            rd_pointer <= 0;
          end else if (pop[i] && !empty_inter[i]) begin
            rd_pointer <= rd_pointer + pop_offset;
          end
        end

        // always @ (posedge clk or negedge rst_n)
        // begin : READ
        //   if (!rst_n) begin
        //     data_out[DATA_WIDTH*i +: DATA_WIDTH] <= 0;
        //   end else if (pop[i] && !empty_inter[i]) begin
        //     data_out[DATA_WIDTH*i +: DATA_WIDTH] <= mem[rd_pointer];
        //   end else begin
        //     data_out[DATA_WIDTH*i +: DATA_WIDTH] <= data_out[DATA_WIDTH*i +: DATA_WIDTH];
        //   end
        // end

        assign data_out[DATA_WIDTH*i +: DATA_WIDTH] = mem[rd_pointer+pop_offset[ADDR_WIDTH*i +: ADDR_WIDTH]];
    end
endgenerate


endmodule
