`timescale 1ns/1ps
module fifo_mr_sram_act
#(  // Parameters
    parameter   DATA_WIDTH          = 64,
    parameter   INIT                = "init.mif",
    parameter   ADDR_WIDTH          = 4,
    parameter   RAM_DEPTH           = (1 << ADDR_WIDTH),
    parameter   INITIALIZE_FIFO     = "no",
    parameter   TYPE                = "MLAB",
    parameter   RD_NUM              = 1
)(  // Ports
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         Reset,
    input  wire                         push,
    input  wire [ RD_NUM          -1 : 0 ]   pop,
    input  wire [ DATA_WIDTH -1 : 0 ]   data_in,
    output reg  [ DATA_WIDTH*RD_NUM -1 : 0 ] data_out,
    output reg  [ RD_NUM          -1 : 0 ] empty, // own
    output reg                           full // share: because 1 write
);

// Port Declarations
// ******************************************************************
// Internal variables
// ******************************************************************
wire  [ RD_NUM          - 1 : 0] empty_inter;
wire  [ RD_NUM          - 1 : 0] full_inter;

reg     [ADDR_WIDTH-1:0]        wr_pointer;             //Write Pointer

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
always @ (posedge clk or negedge rst_n) begin :WRITE
  if( !rst_n) begin
    mem[wr_pointer] <= 0;
  end else if (push && !full) begin
    mem[wr_pointer] <= data_in;
  end
end

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
            fifo_count <= fifo_count + 1;
          else if (pop[i] && (!push||push&&full_inter[i]) && !empty_inter[i])
            fifo_count <= fifo_count - 1;
        end

        always @ (posedge clk or negedge rst_n)
        begin : READ_PTR
          if (!rst_n) begin
            rd_pointer <= 0;
          end else if( Reset )begin
            rd_pointer <= 0;
          end else if (pop[i] && !empty_inter[i]) begin
            rd_pointer <= rd_pointer + 1;
          end
        end

        always @ (posedge clk or negedge rst_n)
        begin : READ
          if (!rst_n) begin
            data_out[DATA_WIDTH*i +: DATA_WIDTH] <= 0;
          end else if (pop[i] && !empty_inter[i]) begin
            data_out[DATA_WIDTH*i +: DATA_WIDTH] <= mem[rd_pointer];
          end else begin
            data_out[DATA_WIDTH*i +: DATA_WIDTH] <= data_out[DATA_WIDTH*i +: DATA_WIDTH];
          end
        end
    end
endgenerate


RAM_ACT_wrap #(// Cant Write and Read Stimulately
        .SRAM_DEPTH_BIT(ADDR_WIDTH),// 32
        .SRAM_WIDTH(DATA_WIDTH)
    ) inst_RAM_ACT_wrap (
        .clk      (clk),
        .rst_n    (rst_n),
        .addr_r   (addr_r),
        .addr_w   (addr_w),
        .read_en  (RAM_RdEn),
        .write_en (write_en),
        .data_in  (datain),
        .data_out (RAM_RdDat)
    );


endmodule
