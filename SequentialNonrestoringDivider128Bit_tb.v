`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:17:20 05/04/2016
// Design Name:   SequentialNonrestoringDivider128Bit
// Module Name:   C:/Users/Kenny/Documents/UMD Classes/Spring 2016/ENEE359F/Bothe_Lab_05_Sequential_Dividers/SequentialNonrestoringDivider128Bit_tb.v
// Project Name:  Bothe_Lab_05_Sequential_Dividers
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SequentialNonrestoringDivider128Bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SequentialNonrestoringDivider128Bit_tb;

	// Inputs
	reg [127:0] dividend_q;
	reg [127:0] divisor_m;
	reg clk;
	reg reset_n;

	// Outputs
	wire [127:0] quotient;
	wire [127:0] remainder;
	wire done;
	wire [2:0] state_out;
	wire [7:0] count_out;

	// Instantiate the Unit Under Test (UUT)
	SequentialNonrestoringDivider128Bit uut (
		.dividend_q(dividend_q), 
		.divisor_m(divisor_m), 
		.clk(clk), 
		.reset_n(reset_n), 
		.quotient(quotient), 
		.remainder(remainder), 
		.done(done), 
		.state_out(state_out), 
		.count_out(count_out)
	);

	integer i,j,f,check_q, check_r;
	
	initial begin
		// Initialize Inputs
		dividend_q = 0;
		divisor_m = 0;
		reset_n = 0;
		clk = 0;
		
		f = $fopen("SequentialNonrestoringDivider128Bit_tb_Output.txt", "w");
		
		// Wait 100 ns for global reset to finish
		#100;
      reset_n = 1;
		// Add stimulus here
		$display("128-bit Sequential Nonrestoring Divider Simulation\n");
		$fwrite(f, "128-bit Sequential Nonrestoring Divider Simulation\n");
		
		dividend_q = 4294967295;
		divisor_m = 25;
		check_q = dividend_q / divisor_m;
		check_r = dividend_q % divisor_m;
		reset_n = 0;
		#10;
		reset_n = 1;
		#5000;
		
		// Add stimulus here
		for (i = 0; i < 256; i = i+1) 
		begin
			dividend_q = i;
			for (j = 1; j < 256; j = 2*j+1) 
			begin
				divisor_m = j;
				check_q = dividend_q / divisor_m;
				check_r = dividend_q % divisor_m;
				reset_n = 0;
				#10;
				reset_n = 1;
				#5000;
				//$display("dividend = %b, divisor = %b", dividend_q, divisor_m); 	//display inputs as binary numbers
				//$display("quotient = %b, remainder = %b \n", quotient, remainder);				//display outputs as binary numbers
				
				$display("dividend = %d, divisor = %d", dividend_q, divisor_m);	//display inputs as decimal numbers
				$display("quotient = %d, remainder = %d", quotient, remainder);				//display outputs as decimal numbers
				$display("check: quotient = %d, remainder = %d \n", check_q, check_r);
				
				//$fwrite(f, "dividend = %b, divisor = %b", dividend_q, divisor_m); 	//display inputs as binary numbers
				//$fwrite(f, "quotient = %b, remainder = %b \n", quotient, remainder);				//display outputs as binary numbers
				
				$fwrite(f, "dividend = %d, divisor = %d", dividend_q, divisor_m);	//display inputs as decimal numbers
				$fwrite(f, "quotient = %d, remainder = %d", quotient, remainder);				//display outputs as decimal numbers
				$fwrite(f, "check: quotient = %d, remainder = %d \n", check_q, check_r);
			end
		end
		$fclose(f);
		$finish;
	end
	
	always
		#5 clk = !clk;
	
endmodule
