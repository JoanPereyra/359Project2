`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:00:24 04/15/2016 
// Design Name: 
// Module Name:    computation_master 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module computation_master(
    input clock,
	 input reset,
    input [127:0] rx_data,
    input rx_irq,
    output reg [127:0] tx_data,
    output tx_wr_out,
	 output UART_TX2,
	 input UART_RX2,
	 output RECEIVED_OUT,
	 output overflow,
	 output underflow,
	 input RECEIVED_IN
    );
	 
	reg [63:0]param1;//dont need
	reg [63:0]param2;//dont need
	
	reg tx_wr;
	assign tx_wr_out = tx_wr;

	reg [2:0]run_module; //[0] enc [1] send dec [2] echo
	wire [2:0]done;
	
	wire [127:0]outputs[2:0];

	always @(posedge clock) begin
		if (reset) begin
			param1 <= 32'd0;
			param2 <= 32'd0;
		end
		
		if(rx_irq) begin
			param1 <= rx_data[127:64];
			param2 <= rx_data[63:0];
			run_module[0] <= 1'b1;
		end else begin
			run_module <= 3'd0;
		end
		 
		 
		if(done) begin
			if(done[0]) begin // Encryption
				//tx_data <= outputs[1];
				run_module[1] <= 1'b1;
				run_module[0] <= 1'b0;
				tx_wr <= 1'b0;
			end 
			if(done[1]) begin // Decryption
				tx_data <= outputs[1];
				tx_wr <= 1'b1;
			end
			if(done[2]) begin //Echo
				tx_data <= outputs[2];
				tx_wr <= 1'b1;
			end
			
		end else begin
			tx_wr <= 1'b0;
		end
		
		
	end
	

	//will be decode
	transceiver64 multiplier_sender (
    .UART_TX(UART_TX2),
    .RECEIVED_TX(RECEIVED_OUT),
    .RECEIVED_RX(RECEIVED_IN),
    .UART_RX(UART_RX2),
    .reset(reset),
    .clock(clock),
    .tx_wr(run_module[1]),
    .rx_data(outputs[1]),
    .tx_data(outputs[0]) //takes in encryption c
   );
	reg dec_out_buf;
	reg dec_done_reg;
	
	always @(posedge clock) begin
		dec_out_buf <= RECEIVED_OUT;
		if (RECEIVED_OUT && ~dec_out_buf) begin
			dec_done_reg <= 1'b1;
		end else begin
			dec_done_reg <= 1'b0;
		end
	end
		
	assign done[1] = dec_done_reg;
	
	//Will be encode
/*FP_Addition_pipeline adder(
    .CLK_50M(clock), 
    .reset(reset), 
    .a(param1), 
    .b(param2),
	 .opcode(op_code), 
    .start_bit(run_add_sub), 
    .sum(sum_sub_add), 
    .done(add_sub_done)
    ); */
	 
	 
//to put java code
wire [127:0] key;
assign key = 17;
wire [127:0] n; 
assign n = 2773;

top_level_enc encode(
	.clk(clock),
	.reset(reset),
	.start(run_module[0]),
	.message(rx_data),
	.e_key(key),
	.n(n),
	.c(outputs[0]),
	.done(done[0])
    );
	 
	 echo echoer (
    .float1(param1), // first floating param
    .float2(param2), //second floating param
    .clock_50M(clock), // 50MHZ clock
    .reset(reset), // Reset
    .select(1'b1), // Debug don't use for real modules
    .start(run_module[2]), // Input that will be high when operation is desired
    .done(done[2]), // raise to high for at lease 1 clock tick when finished
    .out(outputs[2]) // Final value (32-bits)
    );


endmodule
