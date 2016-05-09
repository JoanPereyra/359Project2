`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:55:03 05/09/2016 
// Design Name: 
// Module Name:    SequentialNonrestoringDivider256Bit 
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
module SequentialNonrestoringDivider256Bit(
    input [255:0] dividend_q,
    input [255:0] divisor_m,
    input clk,
	 input reset_n,
    output [255:0] quotient,
	 output [255:0] remainder,
	 output done,
	 output [2:0] state_out,
	 output [8:0] count_out
    );
	 
	parameter [2:0] 	START = 3'b000,
							SHIFT = 3'b001,
							ACCUM = 3'b010,
							FIX_REMAINDER = 3'b011,
							DONE = 3'b100;
							
							
	reg [2:0] state;
	reg [8:0] count;
	reg [255:0] q_shift;
	reg [256:0] a_shift;
	reg add_sub_control;
	//reg carry;
	
	wire [257:0] add_sub_out;
	wire [8:0] count_plusone;
	//wire [8:0] add_sub_a;
	//wire [8:0] add_sub_b;
	
	NineBitTreeCLA count_inc (
		.a(count),
		.b(9'b0),
		.carry_in(1'b1),
		.s(count_plusone),
		.carry_out()
		);
	
	AddSubCLA257Bits add_sub (
		.a(a_shift), 
		.b({1'b0, divisor_m}), 
		.add_sub(add_sub_control), 
		.s(add_sub_out[256:0]), 
		.carry_out(add_sub_out[257])
		);
	
	always @(posedge clk or negedge reset_n)
	begin
		if (!reset_n) 
			state <= START;
		else
		begin
		
			case (state)
				START: 			begin
									q_shift = dividend_q;
									a_shift = 257'h000000000000000000000000000000000000000000000000000000000000000000;
									add_sub_control = 1;
									count = 9'h00;
									state <= SHIFT;
									end
							
				SHIFT: 			begin
									count = count + 1;
									{a_shift, q_shift} = {a_shift[256:0], q_shift, 1'b0};
									state <= ACCUM;
									end
							
				ACCUM:			begin
									a_shift = add_sub_out[256:0];
									if (add_sub_out[256])
										begin
										add_sub_control = 0;
										q_shift[0] = 0;
										end
									else
										begin
										add_sub_control = 1;
										q_shift[0] = 1;
										end
									state <= (count == 9'b100000000)? FIX_REMAINDER : SHIFT;
									end
				
				FIX_REMAINDER:	begin
									if (a_shift[256])
										begin
										add_sub_control = 0;
										a_shift = add_sub_out[256:0];
										state <= FIX_REMAINDER;
										end
									else
										begin
										state <= DONE;
										end
									end
				
				DONE:				begin
									state <= DONE;
									end
			endcase
		end
	end
	
	assign done = state[2];
	assign state_out = state;
	assign count_out = count;
	assign quotient = q_shift;
	assign remainder = a_shift[255:0];

endmodule