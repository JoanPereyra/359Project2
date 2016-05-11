`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:29:58 04/18/2016 
// Design Name: 
// Module Name:    multiplier_top 
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
module multiplier_top(
    output UART_TX,
    output RECEIVED_OUT,
    input  UART_RX,
    input  RECEIVED_IN,
    input  CLK_IN,
    input  resetIn
    );
	 
	wire clock_200M;
	wire CLKIN_IBUFG_OUT;
	wire clock_50M;
	wire dcm_locked;
	reg tx_wr;
	reg recieved_out_buf;
	wire [127:0] rx_data;
	reg [127:0] tx_data;
	wire [127:0] decrypt_out;
	wire done;
	

	wire reset;
	assign reset = ~dcm_locked;

/*	always @(posedge clock_50M) begin
		recieved_out_buf <= RECEIVED_OUT;
		if (RECEIVED_OUT) begin // Got a transmission
			if (~recieved_out_buf) begin
				
				// Echo for debug
				tx_data <= rx_data;
				tx_wr <= 1'b1;
			end else begin
				tx_wr <= 1'b0;
			end
		end else begin
			tx_wr <= 1'b0;
		end
	end*/

	reg start_bit;

	always @(posedge clock_50M) begin
		recieved_out_buf <= RECEIVED_OUT;
		if (RECEIVED_OUT) begin // Got a transmission
			if (~recieved_out_buf) begin
				start_bit <= 1'b1;
			end
			else begin
				start_bit <= 1'b0;
			end
		end
		else begin
			start_bit <= 1'b0;
		end
		
		if(done) begin
			tx_data <= decrypt_out;
			tx_wr <= 1'b1;
		end 
		else 
			tx_wr <= 1'b0;
	end
	
	
	//to put java code
	wire [127:0] key;
	//set to d
	assign key = 157;
	wire [127:0] n; 
	assign n = 2773;

top_level_enc encode(
	.clk(clock_50M),
	.reset(resetIn),
	.start(start_bit),
	.message(rx_data),
	.e_key(key),
	.n(n),
	.c(decrypt_out),
	.done(done)
    );
	 

/*	 wire overflow;
	 wire underflow;
	 
	 Multiplier_pipe_top Multiplier_inst (
    .float1(rx_data[63:32]), 
    .float2(rx_data[31:0]), 
    .start(start_bit), 
    .reset(resetIn), 
    .product(product), 
    .overflow(overflow), 
    .underflow(underflow), 
    .done(done), 
    .clock(clock_50M)
    );
*/

	
	clock_gen01 MYclock_gen01 (
	 .CLKIN_IN(CLK_IN), 
	 .RST_IN(resetIn), 
	 .CLKFX_OUT(clock_200M), 
	 .CLKIN_IBUFG_OUT(CLKIN_IBUFG_OUT), 
	 .CLK0_OUT(clock_50M), 
	 .LOCKED_OUT(dcm_locked)
	);

	transceiver64 transceiver (
    .UART_TX(UART_TX),
    .RECEIVED_TX(RECEIVED_OUT), 
    .RECEIVED_RX(RECEIVED_IN), 
    .UART_RX(UART_RX), 
    .reset(reset), 
    .clock(clock_50M), 
    .tx_wr(tx_wr),
    .rx_data(rx_data), 
    .tx_data(tx_data)
   );

endmodule
