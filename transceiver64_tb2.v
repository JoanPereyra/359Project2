`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:34:19 04/20/2016
// Design Name:   transceiver64
// Module Name:   H:/359/project1/transceiver64_tb2.v
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

module transceiver64_tb2;

	// Inputs
	reg UART_RX;
	reg reset;
	reg clock;
	reg tx_wr;
	reg [63:0] tx_data;
	reg RECEIVED_RX;

	// Outputs
	wire UART_TX;
	wire RECEIVED_TX;
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
	
	always begin
		#5 clock = ~clock;
		UART_RX = UART_TX;
		RECEIVED_RX = RECEIVED_TX;
	end

	initial begin
		// Initialize Inputs
		UART_RX = 0;
		reset = 1;
		clock = 0;
		tx_wr = 0;
		tx_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
        
		// Add stimulus here
		tx_data = 64'haabbccdd11223344;
		tx_wr = 1'b1;
		#20;
		tx_wr = 1'b0;
	end
      
endmodule

