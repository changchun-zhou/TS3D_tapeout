`include "../source/include/dw_params_presim.vh"
module REGWEI #( // Handshake
    parameter  DATA_WIDTH = `DATA_WIDTH,
    parameter  ADDR_WIDTH = `MAX_DEPTH_WIDTH, // ALL addr width
    parameter  REG_ADDR_WIDTH = 3, // this registerfile addr width
    parameter  WR_NUM = 8,
    parameter  RD_NUM = 1 
) (
    input                           clk     ,
    input                           rst_n   ,
    input                           reset   ,

    output                          datain_rdy,
    output reg[ ADDR_WIDTH  -1 : 0] datain_addr, // *8
    input                           datain_val,
    input [ DATA_WIDTH*WR_NUM-1: 0] datain,

    input [ ADDR_WIDTH* RD_NUM-1:0] dataout_addr,
    input [ RD_NUM          -1 : 0] dataout_rdy,
    input [ RD_NUM          -1 : 0] dataout_sw, // Switch On
    output [ RD_NUM          -1 : 0] dataout_val,
    output [DATA_WIDTH *RD_NUM-1: 0] dataout
);
// reg [ ADDR_WIDTH -1:0] dataout_addr [ 0 : RD_NUM-1];
wire [ RD_NUM -1 : 0] wire_dataout_val;
wire [DATA_WIDTH *RD_NUM-1: 0] wire_dataout;

reg [ DATA_WIDTH        -1 : 0] mem[ 0 : WR_NUM -1];
wire [RD_NUM            -1 : 0] lack;
wire [RD_NUM            -1 : 0] intra_addr;


localparam IDLE     = 0;
localparam IDLE1     = 3;
localparam WRITE    = 1;
localparam READ     = 2;

reg [2 -1 : 0           ] state;
reg [2 -1 : 0           ] next_state;

always @(*) begin
  if(!rst_n) begin
    next_state <= IDLE;
  end else begin
    case (state)
        IDLE:   if ( 1'b1 )
                    next_state <= IDLE1;
                else 
                    next_state <= IDLE;
        IDLE1:       next_state <= WRITE; //need delay A clk 
        WRITE:  if (reset)
                    next_state <= IDLE;
                else if( datain_val)
                    next_state <= READ;
                else 
                    next_state <= WRITE;
        READ:   if (reset)
                    next_state <= IDLE;
                else if (lack )
                    next_state <= WRITE;
                else
                    next_state <= READ;
      default: next_state <= IDLE;
    endcase
  end
end

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

generate
    genvar i;
    for(i=0;i<WR_NUM;i=i+1) begin
        always @ ( posedge clk or negedge rst_n ) begin
            if ( !rst_n ) begin
                mem[i] <= 0;
            end else if ( reset ) begin 
                mem[i] <= 0;
            end else if (datain_val  ) begin
                mem[i] <= datain[DATA_WIDTH*i +: DATA_WIDTH];
            end
        end
    end
endgenerate
wire [ REG_ADDR_WIDTH   -1 : 0] rd_addr[0 : RD_NUM-1]; // cut to 3 bits
generate
    genvar j;
    for(j=0;j<RD_NUM;j=j+1) begin
        assign intra_addr[j] = (dataout_addr[ADDR_WIDTH*j +: ADDR_WIDTH] <  (datain_addr+1)*WR_NUM) && (dataout_addr[ADDR_WIDTH*j +: ADDR_WIDTH] >=  (datain_addr)*WR_NUM);
        assign dataout_val[j] = state == READ && dataout_rdy[j] && intra_addr[j];
        assign rd_addr[j] = dataout_addr[ADDR_WIDTH*j +: ADDR_WIDTH];
        assign dataout[DATA_WIDTH*j +: DATA_WIDTH] = mem[rd_addr[j]]; 
        assign lack[j] = dataout_rdy[j] && ( dataout_addr[ADDR_WIDTH*j +: ADDR_WIDTH] >=  (datain_addr+1)*WR_NUM || dataout_addr[ADDR_WIDTH*j +: ADDR_WIDTH] <  (datain_addr)*WR_NUM );

    end
endgenerate

// assign datain_rdy = next_state == WRITE; // because SRAM_WEI.dataout_val delay after .dataout_rdy
// assign datain_rdy = state == WRITE; // because SRAM_WEI.dataout_val delay after .dataout_rdy

reg reg_datain_rdy;
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        reg_datain_rdy <= 0;
    end else if (reset ) begin
        reg_datain_rdy <= 0;
    end else if ( datain_val ) begin
        reg_datain_rdy <= 0;
    end else if ( state != WRITE && next_state == WRITE) begin
        reg_datain_rdy <= 1;
    end
end

assign datain_rdy = reg_datain_rdy && ~datain_val; // because SRAM_WEI.dataout_val delay after .dataout_rdy

always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
        datain_addr <= 0;
    end else if (reset) begin
        datain_addr <= 0;
    end else if ( state == READ && next_state == WRITE ) begin 
        datain_addr <= dataout_addr >> REG_ADDR_WIDTH; // /8 according to MAC address
    end
end



endmodule