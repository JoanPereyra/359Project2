`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:20:38 05/04/2016
// Design Name:   bit_adder_2n
// Module Name:   F:/359FLab/Project 2/Lab5_sequential_mult_8bit/test_128bit_add.v
// Project Name:  sequential_mult_8bit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bit_adder_2n
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_128bit_add;

	// Inputs
	reg [127:0] a;
	reg [127:0] b;
	reg c;

	// Outputs
	wire [127:0] sum;
	wire carry_out;
	wire P_ik;
	wire G_ik;

	// Instantiate the Unit Under Test (UUT)
	bit_adder_2n uut (
		.a(a), 
		.b(b), 
		.c(c), 
		.sum(sum), 
		.carry_out(carry_out), 
		.P_ik(P_ik), 
		.G_ik(G_ik)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		c = 0;

		// Wait 100 ns for global reset to finish
		#100;
		a = 2045;
		b = 3453456;
		c = 1'b1;
        
		// Add stimulus here

	end
      
endmodule

