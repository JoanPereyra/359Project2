`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:36:43 05/06/2016
// Design Name:   top_level_enc
// Module Name:   Z:/Xilinx/Project2/RSA_alg/enc_tb.v
// Project Name:  RSA_alg
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_level_enc
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module enc_tb;

	// Inputs
	reg clk;
	reg reset;
	reg start;
	reg [127:0] message;
	reg [127:0] e_key;
	reg [127:0] n;

	// Outputs
	wire [127:0] c;
	wire done;

	// Instantiate the Unit Under Test (UUT)
	top_level_enc uut (
		.clk(clk), 
		.reset(reset), 
		.start(start), 
		.message(message), 
		.e_key(e_key), 
		.n(n), 
		.c(c), 
		.done(done)
	);
	
	always #10 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		start = 0;
		message = 0;
		e_key = 0;
		n = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		start = 1;
		message = 920;
		e_key = 5'b10001;		//17;
		n = 2773;
		
		#20;
		reset = 0;
		
		// Answer should be 948
        
		// Add stimulus here

	end
      
endmodule

