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
	
//	encrypt_try uut (
//		.clock(clk), 
//		.reset(reset), 
//		.start(start), 
//		.message(message), 
//		.key(e_key), 
//		.n(n), 
//		.message_enc(c), 
//		.done(done)
//	);
	
	always #10 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		start = 0;
		message = 0;
		e_key = 0;
		n = 0;
		#20;
		
		// Start Encryption
		start = 1;
		n = 128'hdfe37dc2fbfce3ac2042306c3a706fb1;
		
		// Encryption
		message = 128'h50000000000000000000000000000000;
		e_key = 128'd3;
		#20;
		
		reset = 0;
		#20;
		start = 0;
		#5000000;	// Wait 1.4 ms
		
		// Reset for decryption
		//reset = 1;
		#20;
		
		// Start Decryption
		start = 1;
		
		// Decryption
		message = 128'h4be0fcf48d1b0681cecbfc292a9d2015;
		e_key = 128'h954253d752a897c6d60f72df9a514ea3;
		#20;
		
		reset = 0;
		#20;
		start = 0;
		#5000000; 	// Wait 1.4 ms
		
		$finish;
		
	end
      
endmodule

