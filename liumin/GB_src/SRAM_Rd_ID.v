module SRAM_Rd_ID #(
    parameter CYC_BITWIDTH = 8
    )(
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    input start,
    input pull_back, 

    // input [1 : 0]data_type,
    input [3 : 0]SRAM_num,
    input [3 : 0]Data_num,
    input [CYC_BITWIDTH - 1 : 0]cyc_num,
    input read_out_flag,
    input read_SRAM_done,

    output reg [3 : 0]Rd_ID,
    output reg done, 
    output reg [CYC_BITWIDTH - 1 : 0]Cyc, 
    output reg done_t
);

reg [3 : 0]Round;


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Rd_ID <= 0;
        Round <= 0;
    end else if (start | pull_back) begin
        Rd_ID <= 0;
        Round <= 0;
    end else if (read_out_flag == 1) begin
        if (Rd_ID == Data_num - Round * SRAM_num - 1 + (((2 * SRAM_num > Data_num) && (SRAM_num < Data_num)) ? 1 : 0)) begin
            Rd_ID <= 0;
            Round <= 0;
        end else begin
            if (Rd_ID == SRAM_num - 1) begin
                Rd_ID <= (2 * SRAM_num > Data_num) ? 1 : 0;
                Round <= Round + 1;
            end else begin
                Rd_ID <= Rd_ID + 1;
                Round <= Round;
            end
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Cyc <= 0;
    end else if (start | done) begin
        Cyc <= 0;
    end else if (read_out_flag == 1) begin
        if (Rd_ID == Data_num - Round * SRAM_num - 1 + (((2 * SRAM_num > Data_num) && (SRAM_num < Data_num)) ? 1 : 0) && done_t == 0) begin
            if (cyc_num - 1 == Cyc) begin
                Cyc <= 0;
            end else begin
                Cyc <= Cyc + 1;
            end
        end
    end
end

reg [CYC_BITWIDTH - 1 : 0]cyc_pull_back;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cyc_pull_back <= 0;
    end else if (pull_back) begin
       cyc_pull_back <= (cyc_pull_back == cyc_num - 1) ? 0 : cyc_pull_back + 1; 
    end
end


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        done_t  <= 0;
    end else if (start | done) begin
        done_t  <= 0;
    end else if (read_out_flag == 1) begin
        if (Rd_ID == Data_num - Round * SRAM_num - 1 + (((2 * SRAM_num > Data_num) && (SRAM_num < Data_num)) ? 1 : 0)) begin
            if (Cyc == cyc_num - 1 && cyc_pull_back == cyc_num - 1) begin
                done_t <= 1;
            end
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        done <= 0;
    end else if (start || done) begin
        done <= 0;
    end else if (done_t & read_SRAM_done) begin
        if (cyc_pull_back == cyc_num - 1)
            done <= 1;
    end
end

endmodule

