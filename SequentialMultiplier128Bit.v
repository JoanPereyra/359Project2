`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:41:05 05/05/2016 
// Design Name: 
// Module Name:    SequentialMultiplier128Bit 
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
module SequentialMultiplier128Bit(
    input [127:0] a,
    input [127:0] b,
	 input reset_n,
	 input clk,
    output [255:0] p,
	 output done,
	 output [1:0] state_out,
	 output [3:0] count_out
    );
	 
	 parameter [1:0] 	START = 2'b00,
							ACCUM = 2'b01,
							SHIFT = 2'b10,
							DONE = 2'b11;
	 
	 //reg [15:0] prod;
	 reg [127:0] a_shift, sum_shift;
	 reg [7:0] counter;
	 reg [1:0] state/*, next*/;
	 reg c_reg;
	 wire [127:0] ab, sum;
	 wire carry;
	 
	 CLATreeAdder128Bit add (
		.a(ab),
		.b(sum_shift),
		.carry_in(1'b0),
		.s(sum),
		.carry_out(carry)
		);
	 
	 generate
	 genvar i;
		 for(i = 0; i<128; i = i+1)
		 begin: a_gen
			assign ab[i] = a_shift[0]&b[i];
		 end
	 endgenerate
	 
	 always @(posedge clk or negedge reset_n)
	 begin
		if (!reset_n) 
			state <= START;
		else
		begin
			//state <= next;
		
		case (state)
			START :	begin
							a_shift = a;
							//prod = 16'b0000000000000000;
							sum_shift = 128'h00000000000000000000000000000000;
							counter = 8'b00000000;
							state <= ACCUM;
							//next = ACCUM;
						end
						
			ACCUM :	begin
							sum_shift = sum;
							c_reg = carry;
							state <= SHIFT;
							//next = SHIFT;
						end
						
			SHIFT :	begin
							{c_reg, sum_shift, a_shift} = {1'b0, c_reg, sum_shift, a_shift[127:1]};
							counter = counter + 1;
							state <= (counter == 128)? DONE : ACCUM;
							//next = (counter == 8)? DONE : ACCUM;
						end
						
			DONE :	begin
							//prod = {sum_shift, a_shift};
							state <= DONE;
							//next = DONE;
						end
		endcase
		end
						
	 end
	 
	 assign count_out = counter;
	 assign state_out = state;
	 assign p = {sum_shift, a_shift};
	 //assign p = prod;
	 assign done = state[0]&state[1];

endmodule
