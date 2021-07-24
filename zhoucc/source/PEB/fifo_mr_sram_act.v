`include "../source/include/dw_params_presim.vh"
module fifo_mr_sram_act // multiple read; mem -> SRAM
#(  // Parameters
    parameter   DATA_WIDTH          = 64,
    parameter   INIT                = "init.mif",
    parameter   ADDR_WIDTH          = 4,
    parameter   RAM_DEPTH           = (1 << ADDR_WIDTH),
    parameter   INITIALIZE_FIFO     = "no",
    parameter   TYPE                = "MLAB",
    parameter   RD_NUM              = 1
)(  // Ports
    input  wire                             clk,
    input  wire                             rst_n,
    input  wire                             Reset,
    input  wire                             push,
    input  wire [ RD_NUM            -1 : 0] pop,//own
    input  wire [ DATA_WIDTH        -1 : 0] data_in,
    output wire  [ DATA_WIDTH       -1 : 0] data_out,
    output wire  [ RD_NUM           -1 : 0] empty, // own
    output wire                             full // share: because 1 write
);

// Port Declarations
// ******************************************************************
// Internal variables
// ******************************************************************
reg  [ RD_NUM          - 1 : 0] empty_inter;
reg  [ RD_NUM          - 1 : 0] full_inter;

reg     [ADDR_WIDTH-1:0]        wr_pointer;             //Write Pointer

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
// always @ (posedge clk or negedge rst_n) begin :WRITE
//   if( !rst_n) begin
//     mem[wr_pointer] <= 0;
//   end else if (push && !full) begin
//     mem[wr_pointer] <= data_in;
//   end
// end

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
    end
endgenerate

wire [ ADDR_WIDTH-1 : 0] addr_r;   
wire [ ADDR_WIDTH-1 : 0] addr_w;  
wire                        read_en; 
wire                        write_en; 
assign addr_r = pop[0]? GEN_RD[0].rd_pointer : GEN_RD[1].rd_pointer;
assign addr_w = wr_pointer;
assign read_en = pop[0]|pop[1];
assign write_en = push && !full;

RAM_ACT_wrap #(// Cant Write and Read Stimulately
        .SRAM_BIT(DATA_WIDTH),// 32
        .SRAM_BYTE(1),
        .SRAM_WORD(2**ADDR_WIDTH)
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


endmodule
