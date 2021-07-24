module WeiFlg_Abs # (
parameter PEB = 16
    ) (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    input [PEB - 1 : 0]WeiFlg_rdy,

    input  WeiFlg_val_s,
    output WeiFlg_rdy_s,
    output reg [PEB - 1 : 0]WeiFlg_val
);
reg [3 : 0]cnt_access_each_PEB;
reg [3 : 0]cnt_which_PEB;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_access_each_PEB <= 0;
        cnt_which_PEB       <= 0;
    end else if (WeiFlg_rdy[cnt_which_PEB] & WeiFlg_val_s) begin
        if (cnt_access_each_PEB == 13) begin
            cnt_access_each_PEB <= 0;
            cnt_which_PEB       <= cnt_which_PEB + 1;
        end else begin
            cnt_access_each_PEB <= cnt_access_each_PEB + 1;
        end
    end
end

reg WeiFlg_rdy_s_d;
integer i;
always @( * ) begin
    for (i = 0; i < 16; i = i + 1) begin
        if (i == cnt_which_PEB) begin
            WeiFlg_val[i] = WeiFlg_val_s;
        end else begin
            WeiFlg_val[i] = 0;
        end
    end
end

assign WeiFlg_rdy_s = WeiFlg_rdy[cnt_which_PEB];


endmodule
