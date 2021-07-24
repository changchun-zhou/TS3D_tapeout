`timescale 1ns/1ps
module fifo_fwft2 
// ******************************************************************
// Parameters
// ******************************************************************
#(
    parameter           INIT                = "init.mif",
    parameter    DATA_WIDTH          = 4,
    parameter    ADDR_WIDTH          = 8,
    parameter    RAM_DEPTH           = (1 << ADDR_WIDTH),
    parameter           INITIALIZE_FIFO     = "no"
)
// ******************************************************************
// Port Declarations
// ******************************************************************
(
    input  wire                             clk,
    //input  wire                             pop_enable,
    input  wire                             Reset,
    input  wire                             rst_n,
    input  wire                             push,
    input  wire [ 2                 -1 : 0] pop,
    input  wire [DATA_WIDTH-1:0]            data_in,
    output      [DATA_WIDTH-1:0]            data_out,
    output      [ 2                 -1 : 0] empty,
    output                                  full
    // output      [ADDR_WIDTH:0]              fifo_count
    //debug
    //output                                  fifo_pop,
    //output                                  fifo_empty,
    //output                                  dout_valid
);    
 
// ******************************************************************
// Internal variables
// ******************************************************************
    wire  [ 2                 -1 : 0]  fifo_pop;
    wire  [ 2                 -1 : 0] fifo_empty;
    reg   [ 2                 -1 : 0] dout_valid;
    
// ******************************************************************
// Logic
// ******************************************************************
    assign fifo_pop[0]    = !fifo_empty[0] && (!dout_valid[0] || pop[0]);
    assign fifo_pop[1]    = !fifo_empty[1] && (!dout_valid[1] || pop[1]);
    //assign fifo_pop    = !fifo_empty && (pop);
    //assign fifo_pop    = !fifo_empty && pop_enable && pop;
    assign empty[0]        = !dout_valid[0];
    assign empty[1]        = !dout_valid[1];

    always @ (posedge clk or negedge rst_n)
    begin
        if (!rst_n) begin
            dout_valid[0] <= 0;
        end else if(Reset) 
            dout_valid[0] <= 0;
        else if (fifo_pop[0]) begin
            dout_valid[0] <= 1;
        end
        else if (pop[0]) begin
            dout_valid[0] <= 0;
        end
    end

    always @ (posedge clk or negedge rst_n)
    begin
        if (!rst_n) begin
            dout_valid[1] <= 0;
        end else if(Reset) 
            dout_valid[1] <= 0;
        else if (fifo_pop[1]) begin
            dout_valid[1] <= 1;
        end
        else if (pop[1]) begin
            dout_valid[1] <= 0;
        end
    end
// ******************************************************************
// INSTANTIATIONS
// ******************************************************************

//-----------------------------------
// FIFO
//-----------------------------------
fifo_mr_sram_act #(
        .DATA_WIDTH         ( DATA_WIDTH   ),
        .ADDR_WIDTH         ( ADDR_WIDTH   ),
        .INIT               ( "init_x.mif" ),
        .INITIALIZE_FIFO    ( "no"         ),
        .RD_NUM             (2)
        )

    fifo_buffer(
        .clk                ( clk           ),  //input
        .rst_n              ( rst_n         ),  //input
        .Reset              ( Reset         ),
        .push               ( push          ),  //input
        .pop                ( fifo_pop      ),  //input
        .data_in            ( data_in       ),  //input
        .data_out           ( data_out      ),  //output
        .empty              ( fifo_empty    ),  //output
        .full               ( full          ) //output
        // .fifo_count         ( fifo_count    )   //output
);   

endmodule
