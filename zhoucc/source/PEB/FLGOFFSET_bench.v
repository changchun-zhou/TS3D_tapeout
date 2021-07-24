`include "../source/include/dw_params_presim.vh"
module FLGOFFSET # (
	parameter DATA_WIDTH = 32)
	(
	input 										clk,
	input  										rst_n,
	input 										I_Sta, // paulse: same with I_ActFlag
	input 										I_ActWei_Val,// can compute next address
	input [ DATA_WIDTH					-1 : 0] I_ActFlag,// MSB-LSB:ch0-ch31 
	input [ DATA_WIDTH  				-1 : 0] I_WeiFlag,// MSB-LSB:ch0-ch31
	output 										O_ValFlag, // current Flag is/not Valid == Next Addr is/not valid
	output reg										O_last_offset,
	output reg[ `C_LOG_2(DATA_WIDTH) 	-1 : 0] O_Offset_Act, // offset
	output reg[ `C_LOG_2(DATA_WIDTH) 	-1 : 0] O_Offset_Wei
	);

wire [ DATA_WIDTH	- 1 : 0 ] ActFlag;//MSB- LSB:ch31-ch0
wire [ DATA_WIDTH	- 1 : 0 ] WeiFlag;
wire [ DATA_WIDTH	- 1 : 0 ] AndFlag;
wire [ DATA_WIDTH	- 1 : 0 ] SetFlag;
wire [ DATA_WIDTH	- 1 : 0 ] ActCntFlag;
wire [ DATA_WIDTH	- 1 : 0 ] WeiCntFlag;
wire [ `C_LOG_2(DATA_WIDTH) -1 : 0 ] Offset_Act;
wire [ `C_LOG_2(DATA_WIDTH) -1 : 0 ] Offset_Wei;

reg [ DATA_WIDTH	- 1 : 0 ] ActFlag_temp;
reg [ DATA_WIDTH	- 1 : 0 ] WeiFlag_temp;
reg [ DATA_WIDTH	- 1 : 0 ] ActCntFlag_temp;
reg [ DATA_WIDTH	- 1 : 0 ] WeiCntFlag_temp;

wire 						O_ValFlag_d;
// *******************************
// Combinational Logic
assign ActFlag = I_Sta ? I_ActFlag : ActFlag_temp;// Switch
assign WeiFlag = I_Sta ? I_WeiFlag : WeiFlag_temp;

assign AndFlag = ActFlag & WeiFlag;

generate
	genvar i;
	for(i=1;i<DATA_WIDTH;i=i+1)
		assign SetFlag[i] = AndFlag[i-1] | SetFlag[i-1];
endgenerate
assign SetFlag[0] = 0;

assign ActCntFlag = (~SetFlag & ActFlag);// | ActCntFlag_temp; offset
assign WeiCntFlag = (~SetFlag & WeiFlag);// | WeiCntFlag_temp;

assign O_ValFlag = SetFlag[DATA_WIDTH-1];

// *****************************
// Sequential Logic
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
		ActFlag_temp    <= 0;
		WeiFlag_temp    <= 0;
		ActCntFlag_temp <= 0;
		WeiCntFlag_temp <= 0;
		O_Offset_Act      <= 0;
		O_Offset_Wei      <= 0;
    end else if(I_Sta || I_ActWei_Val) begin
		ActFlag_temp    <= SetFlag  & ActFlag;
		WeiFlag_temp    <= SetFlag  & WeiFlag;
		ActCntFlag_temp <= ~SetFlag & ActFlag;
		WeiCntFlag_temp <= ~SetFlag & WeiFlag;
		O_Offset_Act      <= Offset_Act;
		O_Offset_Wei      <= Offset_Wei;
		O_last_offset     <= ~O_ValFlag && O_ValFlag_d; // paulse
    end
end

assign 	Offset_Act = 
		ActCntFlag[0] +
		ActCntFlag[1] +
		ActCntFlag[2] +
		ActCntFlag[3] +
		ActCntFlag[4] +
		ActCntFlag[5] +
		ActCntFlag[6] +
		ActCntFlag[7] +
		ActCntFlag[8] +
		ActCntFlag[9] +
		ActCntFlag[10] +
		ActCntFlag[11] +
		ActCntFlag[12] +
		ActCntFlag[13] +
		ActCntFlag[14] +
		ActCntFlag[15] +
		ActCntFlag[16] +
		ActCntFlag[17] +
		ActCntFlag[18] +
		ActCntFlag[19] +
		ActCntFlag[20] +
		ActCntFlag[21] +
		ActCntFlag[22] +
		ActCntFlag[23] +
		ActCntFlag[24] +
		ActCntFlag[25] +
		ActCntFlag[26] +
		ActCntFlag[27] +
		ActCntFlag[28] +
		ActCntFlag[29] +
		ActCntFlag[30] +
		ActCntFlag[31] ;
assign Offset_Wei = 
		WeiCntFlag[0] +
		WeiCntFlag[1] +
		WeiCntFlag[2] +
		WeiCntFlag[3] +
		WeiCntFlag[4] +
		WeiCntFlag[5] +
		WeiCntFlag[6] +
		WeiCntFlag[7] +
		WeiCntFlag[8] +
		WeiCntFlag[9] +
		WeiCntFlag[10] +
		WeiCntFlag[11] +
		WeiCntFlag[12] +
		WeiCntFlag[13] +
		WeiCntFlag[14] +
		WeiCntFlag[15] +
		WeiCntFlag[16] +
		WeiCntFlag[17] +
		WeiCntFlag[18] +
		WeiCntFlag[19] +
		WeiCntFlag[20] +
		WeiCntFlag[21] +
		WeiCntFlag[22] +
		WeiCntFlag[23] +
		WeiCntFlag[24] +
		WeiCntFlag[25] +
		WeiCntFlag[26] +
		WeiCntFlag[27] +
		WeiCntFlag[28] +
		WeiCntFlag[29] +
		WeiCntFlag[30] +
		WeiCntFlag[31] ;
Delay #(
    .NUM_STAGES(1),
    .DATA_WIDTH(1)
    )Delay_O_ValFlag_d(
    .CLK(clk),
    .RESET_N(rst_n),
    .DIN(O_ValFlag),
    .DOUT(O_ValFlag_d)
    );
endmodule

