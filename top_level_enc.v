`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:39:14 05/03/2016 
// Design Name: 
// Module Name:    top_level_enc 
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
module top_level_enc(
	input  clk,
	input  reset,
	input  start,
	input  [127:0] message,
	input  [127:0] e_key,
	input  [127:0] n,
	output [127:0] c,
	output reg done
    );

	reg  [127:0] counter;			//counter must go through 0-127 so use 7 bits (2^7 = 128)
	reg  [127:0] mult_a, mult_b;	//inputs to multiplier
	reg  [127:0] div_a, div_b;		//inputs to divider
	wire [255:0] prod;				//multiplier output (note double length)
	wire [127:0] quot;				//divider quotient output
	wire [127:0] remainder;			//divider remainder output
	reg  [127:0] cipher;				//Current ciphered message
	reg  [127:0] e;					//Encryption factor (usually 3)
	wire	mult_done, div_done;		//Multiplier/Divider done
	reg  mult_rst, div_rst;			//Mutiplier/Divider reset
	
	assign c = cipher;
	
	parameter [2:0] IDLE 	 = 0,
						 SQUARE	 = 1,
						 EI_1 	 = 2,
						 CIPHER	 = 3,
						 DIVIDE	 = 4,
						 WAIT_MULT= 5,
						 WAIT_DIV = 6,
						 END		 = 7;
						 
	reg [2:0] state;
	
	//128-bit sequential multiplier completes in 128 clock cycles
	rsa_mult muliply(
		.clk(clk),
		.rst(mult_rst),
		.done(mult_done),
		.a(mult_a),
		.b(mult_b),
		.c_mult(prod));
	//128 sequential divider completes in 128 clock cycles	
	rsa_div divide(
		.clk(clk),
		.reset_n(div_rst),
		.dividend_q(div_a),
		.divisor_m(div_b),
		.quotient(quot),
		.remainder(remainder),
		.done(div_done));
	
	always @(posedge clk) begin
		//$display("Product: %d", prod);
		$display("e: %b", e == e_key);
		if (reset) begin 
			e = e_key;
			state = IDLE;
			counter = 0;
			cipher = 0;
		end else begin
			case(state)
				IDLE: begin
					cipher = 1'b1;
					counter = 0;
					if (e[0] == 1) state = EI_1;
					else state = SQUARE;
				end
				
				SQUARE: begin			// e = 0
					mult_a = cipher;
					mult_b = cipher;
					mult_rst = 1;
					state = WAIT_MULT;
				end
				
				EI_1: begin				// e = 1
					if (counter == e_key) state = END;
					else begin
						mult_a = cipher;
						mult_b = message;
						mult_rst = 1;
						state = WAIT_MULT;
					end
				end
				
				CIPHER: begin
					cipher = remainder;
					counter = counter + 1;
					e = e >> 1;
					if (e[0]) state = EI_1;
					else state = SQUARE;
					
					if (counter == e_key) state = END;
				end
				
				DIVIDE: begin
					div_a = prod;
					div_b = n;
					div_rst = 0;
					state = WAIT_DIV;
				end
				
				WAIT_MULT: begin						// Wait for multiplier to finish
					if(mult_rst) mult_rst = 0;
					if(mult_done) state = DIVIDE;
					else state = WAIT_MULT;
				end
				
				WAIT_DIV: begin						// Wait for divider to finish
					if(!div_rst) div_rst = 1;
					if(div_done) state = CIPHER;
					else state = WAIT_DIV;
				end
				
				END		: begin
					done = 1;
					state = END;
				end
				
			endcase
		end
	
	end

endmodule
