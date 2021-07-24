module Cor2Abs_ID (
    input [3 : 0]WeiFlg_cor_ID, Act_cor_ID, ActFlg_cor_ID, 
    input [3 : 0]CFGGB_SRAM_num_wei, CFGGB_SRAM_num_flgwei, CFGGB_SRAM_num_act, CFGGB_SRAM_num_flgact,  

    output [5 : 0]WeiFlg_abs_ID, Act_abs_ID, ActFlg_abs_ID

);

assign WeiFlg_abs_ID = {2'b01, WeiFlg_cor_ID + CFGGB_SRAM_num_wei};
assign Act_abs_ID    = {2'b10, Act_cor_ID + CFGGB_SRAM_num_wei + CFGGB_SRAM_num_flgwei};
assign ActFlg_abs_ID = {2'b11, ActFlg_cor_ID + CFGGB_SRAM_num_wei + CFGGB_SRAM_num_flgwei + CFGGB_SRAM_num_act};

endmodule