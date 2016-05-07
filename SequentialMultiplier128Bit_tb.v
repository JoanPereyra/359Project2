`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:23:33 05/06/2016
// Design Name:   SequentialMultiplier128Bit
// Module Name:   C:/Users/Kenny/Documents/UMD Classes/Spring 2016/ENEE359F/Bothe_Lab_05_Sequential_Multiplier/SequentialMultiplier128Bit_tb.v
// Project Name:  Bothe_Lab_05_Sequential_Multiplier
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SequentialMultiplier128Bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SequentialMultiplier128Bit_tb;

	// Inputs
	reg [127:0] a;
	reg [127:0] b;
	reg reset_n;
	reg clk;

	// Outputs
	wire [255:0] p;
	wire done;
	wire [1:0] state_out;
	wire [3:0] count_out;

	// Instantiate the Unit Under Test (UUT)
	SequentialMultiplier128Bit uut (
		.a(a), 
		.b(b), 
		.reset_n(reset_n), 
		.clk(clk), 
		.p(p), 
		.done(done), 
		.state_out(state_out), 
		.count_out(count_out)
	);

	integer i,j,f;
	time check;
	
	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		reset_n = 0;
		clk = 0;
		
		//f = $fopen("EightBitSequentialMultiplier_tb_Output.txt", "w");
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$display("128-bit Sequential Multiplier Simulation\n");
		//$fwrite(f, "8-bit Sequential Multiplier Simulation\n");
		
		// Add stimulus here
		for (i = 0; i < 1048576; i = 2*i+1) 
		begin
			a = i;
			for (j = 0; j < 1048576; j = 2*j+1) 
			begin
				b = j;
				check = a*b;
				reset_n = 0;
				#10;
				reset_n = 1;
				#3000;
				//$display("a = %b, b = %b", a, b); 	//display inputs as binary numbers
				//$display("p = %b \n", p);				//display outputs as binary numbers
				$display("a = %d, b = %d", a, b);	//display inputs as decimal numbers
				$display("p = %d", p);				//display outputs as decimal numbers
				$display("check = %d \n", check);
//				$fwrite(f, "a = %b, b = %b\n", a, b); 	//display inputs as binary numbers
//				$fwrite(f, "p = %b \n\n", p);				//display outputs as binary numbers
//				$fwrite(f, "a = %d, b = %d\n", a, b);	//display inputs as decimal numbers
//				$fwrite(f, "p = %d\n", p);				//display outputs as decimal numbers
//				$fwrite(f, "check = %d \n\n", check);
			end
		end
		//$fclose(f);
		a = 128'hffffffffffffffffffffffffffffffff;
		b = 128'hffffffffffffffffffffffffffffffff;
		reset_n = 0;
		#10;
		reset_n = 1;
		#3000;
		$finish;
	end
	
	always
		#5 clk = !clk;
	
endmodule
