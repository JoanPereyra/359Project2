`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:04:46 05/08/2016 
// Design Name: 
// Module Name:    encrypt_try 
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
module encrypt_try(
	input clock,
	input [127:0] message,
   input start,
   input reset,
   input [127:0] key,
	input [127:0] n,
   output done,
   output reg [127:0] message_enc
   );
	
	wire [255:0] mult_prod;
	wire [127:0] div_quot, div_remain;
	wire mult_done, div_done;
	
	reg [7:0] counter;
	reg [127:0] mult_a, mult_b, dividend, divisor, c, key_shift, m;
	reg mult_start, div_start;
	reg [2:0] state;
	
	SequentialMultiplier128Bit rsa_multiply(
		.a(mult_a),
		.b(mult_b),
		.clk(clock),
		.reset_n(mult_start),
		.p(mult_prod),
		.done(mult_done)
		);
		
	rsa_div rsa_divide(
		.dividend_q(dividend),
		.divisor_m(divisor),
		.clk(clock),
		.reset_n(div_start),
		.done(div_done),
		.quotient(div_quot),
		.remainder(div_remain)
		);
		
		
		
	parameter [2:0] 	IDLE = 3'd0, 
							C_SQ = 3'd1,
							DIV_A = 3'd2,
							A_DONE = 3'd3,
							C_M = 3'd4,
							DIV_B = 3'd5,
							B_DONE = 3'd6,
							DONE = 3'd7;
		
	always@(posedge clock or posedge reset) begin
		if (reset) begin
			counter = 7'd0;
			c = 127'b0;
			state = IDLE;
			end
		else begin
			case (state)
				IDLE	:	begin
								c = 127'b1;
								counter = 7'd0;
								mult_a = c;
								mult_b = c;
								if (start) begin
									mult_start = 1'b1;
									divisor = n;
									key_shift = key;
									m = message;
									state = C_SQ;
								end
							end
				
				C_SQ	:	begin
								if (mult_done) begin
									dividend = mult_prod[127:0];
									div_start = 1'b1;
									state = DIV_A;
								end
							end
							
				DIV_A	:	begin
								if (div_done) begin
									c = div_remain;
									state = A_DONE;
								end
							end
				
				A_DONE :	begin
								if (key_shift[127]) begin
									mult_a = c;
									mult_b = m;
									mult_start = 1'b1;
									state = C_M;
								end else begin
									state = B_DONE;
								end
							end
							
				C_M	:	begin
								if (mult_done) begin
									dividend = mult_prod[127:0];
									div_start = 1'b1;
									state = DIV_B;
								end
							end
							
				DIV_B	:	begin
								if (div_done) begin
									c = div_remain;
									state = B_DONE;
								end
							end
							
				B_DONE :	begin
								if (counter == 127) begin
									message_enc = c;
									state = DONE;
								end else begin
									key_shift = key_shift << 1;
									counter = counter + 1;
									mult_a = c;
									mult_b = c;
									mult_start = 1'b1;
									state = C_SQ;
								end
								
							end
				
				DONE	:	begin
								state = done;
	
							end
			endcase
		end
	end

	assign done = &state[2:0];
			

endmodule
