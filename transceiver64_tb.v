`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:55:09 04/20/2016
// Design Name:   transceiver64
// Module Name:   H:/359/project1/transceiver64_tb.v
// Project Name:  project1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: transceiver64
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module transceiver64_tb;

	// Inputs
	reg UART_RX;
	reg reset;
	reg clock;
	reg tx_wr;
	reg [63:0] tx_data;

	// Outputs
	wire UART_TX;
	wire RECEIVED_TX;
	wire RECEIVED_RX;
	wire rx_done;
	wire tx_done;
	wire [63:0] rx_data;

	// Instantiate the Unit Under Test (UUT)
	transceiver64 uut (
		.UART_TX(UART_TX), 
		.RECEIVED_TX(RECEIVED_TX), 
		.RECEIVED_RX(RECEIVED_RX), 
		.UART_RX(UART_RX), 
		.reset(reset), 
		.clock(clock), 
		.tx_wr(tx_wr), 
		.rx_data(rx_data), 
		.tx_data(tx_data)
	);
	
	integer clock16;
	integer transmit_bit;
	integer input_index;
	reg [66:0] in_val[4:0];
	
	always #5 clock = ~clock;

	initial begin
	
		in_val[0] = {1'b1, 1'b1, 64'hFF00FF00FF00FF00, 1'b0};
		in_val[1] = {1'b0, 64'haabbccdd11223344, 1'b1, 1'b1};
		in_val[2] = {1'b0, 64'haabbccdd11223344, 1'b1, 1'b1};
		in_val[3] = {1'b0, 64'haabbccdd11223344, 1'b1, 1'b1};
		in_val[4] = {1'b0, 64'haabbccdd11223344, 1'b1, 1'b1};
		clock = 0;
		reset = 1;
		UART_RX = 1;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
      for (input_index = 0; input_index < 5; input_index = input_index+1) begin
			for (transmit_bit = 0; transmit_bit < 67; transmit_bit = transmit_bit+1) begin
				for(clock16 = 0; clock16 < 16; clock16 = clock16+1) begin
					#10;
				end
				if (transmit_bit == 0) UART_RX = 0; // START BIT
				else if (transmit_bit == 66) UART_RX = 1; // END BIT
				else begin
					UART_RX = in_val[input_index][transmit_bit];
				end
			end
			#300;
		end
	end
      
endmodule

