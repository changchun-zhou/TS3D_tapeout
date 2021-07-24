module SRAM_CTRL # (
    parameter ADDR_WIDTH      = 9,
    parameter PORT_WIDTH      = 128,
    parameter WEI_WR_WIDTH    = 128, // 16B
    parameter FLGWEI_WR_WIDTH = 64, // 8B
    parameter ACT_WR_WIDTH    = 128, // 16B
    parameter FLGACT_WR_WIDTH = 32, // 4B)
    parameter SRAM_DEPTH        = 512
    ) (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low

    input start,
    input [3 : 0]SRAM_ID,
    input SRAM_Cover_Flag,

    input [5 : 0]SRAMIF_Wr_ID,
    input [5 : 0]SRAMIF_Rd_ID_Wei, SRAMIF_Rd_ID_WeiFlg, SRAMIF_Rd_ID_Act, SRAMIF_Rd_ID_ActFlg,
    input [1 : 0]State_Wr, State_Rd,

    output Wr_Req,
    output Rd_Prepare,
    input  write_SRAM_done, read_SRAM_done,

    input IFSRAM_Conf_rdy,
    input PESRAM_rdy,

    input write_en,
    input read_en,
    input [ADDR_WIDTH - 1 : 0]addr_w, addr_r,
    input [PORT_WIDTH - 1 : 0]data_in,
    output [PORT_WIDTH - 1 : 0]data_out
);



parameter WR_IDLE = 2'b00, WR_REQ_READY = 2'b01, WR_WRITE = 2'b11;
parameter RD_IDLE = 2'b00, RD_READ_READY = 2'b01, RD_READ = 2'b11;
parameter EMPTY = 2'b00, WRITE = 2'b01, READY_TO_READ = 2'b11, READ = 2'b10;

reg [2 : 0]Block_Ctrl_state, next_Block_Ctrl_state;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Block_Ctrl_state <= EMPTY;
    end
    else begin
        Block_Ctrl_state <= next_Block_Ctrl_state;
    end
end

always @( * ) begin
    if (~rst_n) begin
        next_Block_Ctrl_state = EMPTY;
    end
    else begin
        case(Block_Ctrl_state)
        EMPTY: if (start) begin
            next_Block_Ctrl_state = EMPTY;
        end else if (State_Wr == WR_REQ_READY && IFSRAM_Conf_rdy == 1 && SRAMIF_Wr_ID[3 : 0] == SRAM_ID) begin
            next_Block_Ctrl_state = WRITE;
        end else begin
            next_Block_Ctrl_state = EMPTY;
        end

        WRITE: if (start) begin
            next_Block_Ctrl_state = EMPTY;
        end else if (write_SRAM_done) begin
            next_Block_Ctrl_state = READY_TO_READ;
        end else begin
            next_Block_Ctrl_state = WRITE;
        end

        READY_TO_READ: if (start) begin
            next_Block_Ctrl_state = EMPTY;
        end else if (State_Rd == RD_READ_READY && PESRAM_rdy == 1 && (SRAMIF_Rd_ID_Wei[3 : 0] == SRAM_ID || SRAMIF_Rd_ID_WeiFlg[3 : 0] == SRAM_ID || SRAMIF_Rd_ID_Act[3 : 0] == SRAM_ID || SRAMIF_Rd_ID_ActFlg[3 : 0] == SRAM_ID)) begin
            next_Block_Ctrl_state = READ;
        end else begin
            next_Block_Ctrl_state = READY_TO_READ;
        end

        READ:if (start) begin
            next_Block_Ctrl_state = EMPTY;
        end else if (read_SRAM_done) begin
            if (SRAM_Cover_Flag) begin
                next_Block_Ctrl_state = EMPTY;
            end else begin
                next_Block_Ctrl_state = READY_TO_READ;
            end
        end else begin
            next_Block_Ctrl_state = READ;
        end
        endcase
    end
end

assign Wr_Req     = (Block_Ctrl_state == EMPTY);
assign Rd_Prepare = (Block_Ctrl_state == READY_TO_READ);


        RAM_ACT_wrap #(
            .SRAM_BIT(32),
            .SRAM_BYTE(4),
            .SRAM_WORD(512)
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
