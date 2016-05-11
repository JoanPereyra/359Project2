`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:06:57 05/05/2016
// Design Name:   computation_master
// Module Name:   E:/359FLab/group_proj1/359Project1/groupProject1/test_computation_master2.v
// Project Name:  groupProject1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: computation_master
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_computation_master2;

	// Inputs
	reg clock;
	reg reset;
	reg [127:0] rx_data;
	reg rx_irq;
	reg UART_RX2;
	reg RECEIVED_IN;

	// Outputs
	wire [127:0] tx_data;
	wire tx_wr_out;
	wire UART_TX2;
	wire RECEIVED_OUT;
	wire overflow;
	wire underflow;

	// Instantiate the Unit Under Test (UUT)
	computation_master uut (
		.clock(clock), 
		.reset(reset), 
		.rx_data(rx_data), 
		.rx_irq(rx_irq), 
		.tx_data(tx_data), 
		.tx_wr_out(tx_wr_out), 
		.UART_TX2(UART_TX2), 
		.UART_RX2(UART_RX2), 
		.RECEIVED_OUT(RECEIVED_OUT), 
		.overflow(overflow), 
		.underflow(underflow), 
		.RECEIVED_IN(RECEIVED_IN)
	);

	always #5 clock = ~clock;

	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		rx_data = 0;
		rx_irq = 0;
		UART_RX2 = 0;
		RECEIVED_IN = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 1;
		#100;
		reset = 0;
		#100;
        
		// Add stimulus here
		//rx_data = {2'b00, 32'hAABBCCDD, 32'h0000FFFF};
		rx_data = {64'hBE9B6F8BBE9B6F8B, 64'h3FBD7B2D3FBD7B2D};
		rx_irq = 1;
		#10;
		rx_irq = 0;
		#10000;
		rx_irq = 0;
	end
      
endmodule

