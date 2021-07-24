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
	output reg										O_ValFlag, // current Flag is/not Valid == Next Addr is/not valid
	output reg										O_last_offset,
	output reg[ `C_LOG_2(DATA_WIDTH) 	-1 : 0] O_Offset_Act, // offset
	output reg[ `C_LOG_2(DATA_WIDTH) 	-1 : 0] O_Offset_Wei
	);

reg [ DATA_WIDTH	- 1 : 0 ] ActFlag;//MSB- LSB:ch31-ch0
reg [ DATA_WIDTH	- 1 : 0 ] WeiFlag;

reg [ `C_LOG_2(DATA_WIDTH) -1 : 0 ] Offset_Act;
reg [ `C_LOG_2(DATA_WIDTH) -1 : 0 ] Offset_Wei;

reg [ DATA_WIDTH	- 1 : 0 ] ActFlag_temp;
reg [ DATA_WIDTH	- 1 : 0 ] WeiFlag_temp;
reg [ DATA_WIDTH	- 1 : 0 ] ActCntFlag_temp;
reg [ DATA_WIDTH	- 1 : 0 ] WeiCntFlag_temp;

wire 						O_ValFlag_d;
// *******************************
// Combinational Logic
reg fnh_act,fnh_wei;
integer i;
always@( posedge clk ) begin
	Offset_Act = 0;
	fnh_act = 0;
	O_ValFlag = 0;
	for(i=0; i<DATA_WIDTH; i=i+1) begin
		if(ActFlag_temp[i] && ~WeiFlag_temp[i] && ~fnh_act) begin
			Offset_Act = Offset_Act + 1;
			fnh_act = 0;
			ActFlag[i] = 0;
		end else if(ActFlag_temp[i] && WeiFlag_temp[i]) begin
			Offset_Act = Offset_Act;
			fnh_act = 1;
			ActFlag[i] = 0;
			O_ValFlag = 1;
		end else begin
			Offset_Act = Offset_Act;
			fnh_act = fnh_act;
			ActFlag[i] = ActFlag[i];
		end
	end
end
integer j;
always@( posedge clk) begin
	Offset_Wei = 0;
	fnh_wei = 0;
	for(j=0; j<DATA_WIDTH; j=j+1) begin
		if(WeiFlag_temp[j] && ~ActFlag_temp[j] && ~fnh_wei) begin
			Offset_Wei = Offset_Wei + 1;
			fnh_wei = 0;
			WeiFlag[j] = 0;
		end else if(ActFlag_temp[j] && WeiFlag_temp[j]) begin
			Offset_Wei = Offset_Wei;
			fnh_wei = 1;
			WeiFlag[j] = 0;
		end else begin
			Offset_Wei = Offset_Wei;
			fnh_wei = fnh_wei;
			WeiFlag[j] = WeiFlag[j];
		end
	end
end

// *****************************
// Sequential Logic
always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
		ActFlag_temp    <= 0;
		WeiFlag_temp    <= 0;
		ActCntFlag_temp <= 0;
		O_Offset_Act      <= 0;
		O_Offset_Wei      <= 0;
	end else if (I_Sta) begin 
		ActFlag_temp    <= I_ActFlag;
		WeiFlag_temp    <= I_WeiFlag;		
    end else if( I_ActWei_Val) begin
		ActFlag_temp    <= ActFlag;
		WeiFlag_temp    <= WeiFlag;
		O_Offset_Act      <= Offset_Act;
		O_Offset_Wei      <= Offset_Wei;
		O_last_offset     <= ~O_ValFlag && O_ValFlag_d; // paulse
    end
end

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

