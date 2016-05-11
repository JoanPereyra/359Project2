`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:38:46 05/03/2016
// Design Name:   rsa_mult
// Module Name:   C:/Users/Samantha/Documents/UMD/enee356F/Lab5_Samantha Thibeault_GOOD/Lab5/Lab5_sequential_mult_8bit/test_rsa_mult.v
// Project Name:  sequential_mult_8bit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: rsa_mult
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_rsa_mult;

	// Inputs
	reg clk;
	reg rst;
	reg [127:0] a;
	reg [127:0] b;
	reg [2:0] key;

	// Outputs
	wire [255:0] c_mult;

	// Instantiate the Unit Under Test (UUT)
	rsa_mult uut (
		.clk(clk), 
		.rst(rst), 
		.a(a), 
		.b(b), 
		//.key(key), 
		.c_mult(c_mult)
	);

always #20 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		a = 0;
		b = 0;
		//key = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
      a = 12738473;
		b = 8;
		// Add stimulus here

	end
      
endmodule

