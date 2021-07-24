module SRAM_Wr_ID #(
    parameter CYC_BITWIDTH = 'd8, 
    parameter DATA_TYPE = 2'b01
    )(
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    
    input start, 
    input [1 : 0]data_type, 
    input [3 : 0]SRAM_num,
    input [3 : 0]Data_num,
    input [CYC_BITWIDTH - 1 : 0]cyc_num,

    input read_out_flag, 

    output reg [3 : 0]Wr_ID,
    output reg done

);
    


reg [7 : 0]Round;
reg [CYC_BITWIDTH - 1 : 0]Cyc;
reg done_t;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        done_t <= 0; 
    end else if(start) begin
        done_t <= 0;
    end else if (read_out_flag == 1 && data_type == DATA_TYPE) begin 
        if (Data_num <= SRAM_num) begin
            if (Wr_ID == Data_num - 1) begin
                if (Cyc == cyc_num - 1) begin
                    done_t <= 1;
                end
            end
        end else if (Data_num < 2 * SRAM_num) begin
            if ((Wr_ID == Data_num - SRAM_num) || (Wr_ID == SRAM_num - 1)) begin
                if (Cyc == cyc_num - 1) begin
                    done_t <= 1;
                end
            end 
        end else begin
            if (Wr_ID == Data_num - SRAM_num * Round - 1) begin
                if (Cyc == cyc_num - 1) begin
                    done_t <= 1;
                end
            end
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        done <= 0;        
    end else if (read_out_flag == 1 && data_type == DATA_TYPE) begin
        done <= done_t;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Wr_ID <= 0;
        Round <= 0;  
    end else if (start) begin
        Wr_ID <= 0;
        Round <= 0;  
    end else if (read_out_flag == 1 && data_type == DATA_TYPE) begin
        if (Data_num <= SRAM_num) begin
            if (Wr_ID == Data_num - 1) begin
                Wr_ID <= Wr_ID;
                Round <= 0;
            end else begin
                Wr_ID <= Wr_ID + 1;
                Round <= 0;
            end
        end else if (Data_num < 2 * SRAM_num) begin
            if(Cyc == 0 && Round == 0) begin
                if (Wr_ID == SRAM_num - 1) begin
                    Wr_ID <= 1;
                    Round <= 1;
                end else begin
                    Wr_ID <= Wr_ID + 1;
                    Round <= Round;
                end
            end else begin
                if ((Wr_ID == Data_num - SRAM_num)) begin
                    if(Round == 1) begin
                        if(Cyc == cyc_num - 1) begin
                            Wr_ID <= Wr_ID;
                            Round <= Round;
                        end else begin 
                            Wr_ID <= 1;
                            Round <= 0;
                        end
                    end else begin
                        Wr_ID <= 1;
                        Round <= 1;
                    end
                    
                end else begin
                    Wr_ID <= Wr_ID + 1;
                    Round <= Round;
                end
            end
        end else begin
            if (Wr_ID == Data_num - SRAM_num * Round - 1) begin
                if (Cyc == cyc_num - 1) begin
                    Round <= Round;
                    Wr_ID <= Wr_ID;
                end else begin
                    Round <= 0;
                    Wr_ID <= 0;
                end
            end else if (Wr_ID == SRAM_num - 1) begin
                Wr_ID <= 0;
                Round <= Round + 1;
            end else begin
                Wr_ID <= Wr_ID + 1;
                Round <= Round;
            end
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Cyc   <= 0;
    end else if (start) begin
        Cyc   <= 0;
    end else if (read_out_flag == 1 && data_type == DATA_TYPE) begin
        if (Data_num <= SRAM_num) begin
            Cyc   <= 0;
        end else if (Data_num < 2 * SRAM_num) begin
            if(Cyc == 0 && Round == 0) begin
                Cyc   <= Cyc;
            end else begin
                if ((Wr_ID == Data_num - SRAM_num)) begin
                    if(Round == 1) begin
                        if(Cyc == cyc_num - 1) begin
                            Cyc   <= Cyc;
                        end else begin 
                            Cyc <= Cyc + 1;
                        end
                    end else begin
                        Cyc   <= Cyc;
                    end
                    
                end else begin
                    Cyc   <= Cyc;
                end
            end
        end else begin
            if (Wr_ID == Data_num - SRAM_num * Round - 1) begin
                if (Cyc == cyc_num - 1) begin
                    Cyc   <= Cyc;
                end else begin
                    Cyc   <= Cyc + 1;
                end
            end
        end
    end
end



endmodule