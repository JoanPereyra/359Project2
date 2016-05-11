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
	
	parameter [3:0] IDLE 	 		= 0,
						 DIV_SQ			= 1,
						 DIV_E			= 2,
						 C_SQ				= 3,
						 C_M				= 4,
						 WAIT_MULT_E	= 5,
						 WAIT_MULT_SQ	= 6,
						 WAIT_DIV_E		= 7,
						 WAIT_DIV_SQ	= 8,
						 SET_REM_E		= 9,
						 SET_REM_SQ		= 10,
						 END		 		= 11;
						 
	reg [3:0] state;
	reg running;
	
	//128-bit sequential multiplier completes in 128 clock cycles
//	rsa_mult muliply(
//		.clk(clk),
//		.rst(mult_rst),
//		.done(mult_done),
//		.a(mult_a),
//		.b(mult_b),
//		.c_mult(prod));

	SequentialMultiplier128Bit multiply(
		.clk(clk),
		.reset_n(mult_rst),
		.done(mult_done),
		.a(mult_a),
		.b(mult_b),
		.p(prod));
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
		if (reset) begin 
			e = e_key;
			state = IDLE;
			running = 0;
			done = 0;
			counter = 0;
			cipher = 0;
		end else if (start) begin
			done = 1'b0;
			running = 1'b1;
			e = e_key;
			state = IDLE;
		end else if (running) begin
			case(state)
				IDLE: begin
					cipher = 1'b1;
					counter = 0;
					//if(start) begin
						mult_a = cipher;
						mult_b = cipher;
						mult_rst = 0;
						state = WAIT_MULT_SQ;
					//end
				end
				
				C_SQ: begin			// e = 0
					mult_a = cipher;
					mult_b = cipher;
					mult_rst = 0;
					state = WAIT_MULT_SQ;
				end
				
				C_M: begin
					mult_a = cipher;
					mult_b = message;
					mult_rst = 0;
					state = WAIT_MULT_E;
				end
				
				SET_REM_SQ: begin
					cipher = remainder;
					if(e[127]) state = C_M;
					else state = SET_REM_E;
				end
				
				SET_REM_E: begin
					cipher = remainder;
					if (counter == 127) state = END;
					else begin
						e = e << 1;
						$display("e: %b", e);
						counter = counter + 1;
						state = C_SQ;
					end
				end
				
				DIV_SQ: begin
					div_a = prod;
					div_b = n;
					div_rst = 0;
					state = WAIT_DIV_SQ;
				end
				
				DIV_E: begin
					div_a = prod;
					div_b = n;
					div_rst = 0;
					state = WAIT_DIV_E;
				end
				
				WAIT_MULT_E: begin						// Wait for multiplier to finish
					if(!mult_rst) mult_rst = 1;
					if(mult_done) begin 
						state = DIV_E; 
						$display("Product: %d", prod); 
					end
					else state = WAIT_MULT_E;
				end
				
				WAIT_MULT_SQ: begin						// Wait for multiplier to finish
					if(!mult_rst) mult_rst = 1;
					if(mult_done) begin 
						state = DIV_SQ; 
						$display("Product: %d", prod); 
					end
					else state = WAIT_MULT_SQ;
				end
				
				WAIT_DIV_SQ: begin						// Wait for divider to finish
					if(!div_rst) div_rst = 1;
					if(div_done) begin 
						state = SET_REM_SQ; 
						$display("Quotient: %d", quot); 
						$display("Remainder: %d", remainder); 
					end
					else state = WAIT_DIV_SQ;
				end
				
				WAIT_DIV_E: begin						// Wait for divider to finish
					if(!div_rst) div_rst = 1;
					if(div_done) begin 
						state = SET_REM_E; 
						$display("Quotient: %d", quot); 
						$display("Remainder: %d", remainder); 
					end
					else state = WAIT_DIV_E;
				end
				
				END: begin
					done = 1;
					running = 1'b0;
					state = END;
				end
				
			endcase
		end else done = 0;
	
	end

endmodule

