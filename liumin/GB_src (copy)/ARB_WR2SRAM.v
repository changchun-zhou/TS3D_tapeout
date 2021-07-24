module ARB_WR2SRAM (
    input clk, 
    input rst_n, 
    input [1 : 0]State_Wr, 
    input [5 : 0]Wr_ID_Wei, Wr_ID_WeiFlg, Wr_ID_Act, Wr_ID_ActFlg, 
    input Wr_Req_Wei, Wr_Req_WeiFlg, Wr_Req_Act, Wr_Req_ActFlg, 

    output reg [5 : 0]Wr_ID, 
    output reg Wr_Req

);

parameter IDLE = 2'b00, REQ_READY = 2'b01, READY_TO_WRITE = 2'b11, WRITE = 2'b10; 

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Wr_Req <= 0;        
    end else if (State_Wr == IDLE) begin
        Wr_Req <= Wr_Req_Wei | Wr_Req_WeiFlg | Wr_Req_Act | Wr_Req_ActFlg;
    end else begin
        Wr_Req <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Wr_ID <= 0;    
    end else if ((State_Wr == IDLE) && (Wr_Req_Wei | Wr_Req_WeiFlg | Wr_Req_Act | Wr_Req_ActFlg) == 1) begin
        if (Wr_Req_Wei) begin
            Wr_ID <= Wr_ID_Wei;
        end else begin
            case(Wr_ID[5 : 4])
            2'b00: if (Wr_Req_WeiFlg) begin
                Wr_ID <= Wr_ID_WeiFlg;
            end else if (Wr_Req_Act) begin
                Wr_ID <= Wr_ID_Act;
            end else if (Wr_Req_ActFlg) begin
                Wr_ID <= Wr_ID_ActFlg;
            end 
            2'b01: if (Wr_Req_Act) begin
                Wr_ID <= Wr_ID_Act;
            end else if (Wr_Req_ActFlg) begin
                Wr_ID <= Wr_ID_ActFlg;
            end else if (Wr_Req_WeiFlg) begin
                Wr_ID <= Wr_ID_WeiFlg;
            end 
            2'b10: if (Wr_Req_ActFlg) begin
                Wr_ID <= Wr_ID_ActFlg;
            end else if (Wr_Req_WeiFlg) begin
                Wr_ID <= Wr_ID_WeiFlg;
            end else if (Wr_Req_Act) begin
                Wr_ID <= Wr_ID_Act;
            end  
            2'b11: if (Wr_Req_WeiFlg) begin
                Wr_ID <= Wr_ID_WeiFlg;
            end else if (Wr_Req_Act) begin
                Wr_ID <= Wr_ID_Act;
            end else if (Wr_Req_ActFlg) begin
                Wr_ID <= Wr_ID_ActFlg;
            end 
            endcase
        end
    end    
end


endmodule