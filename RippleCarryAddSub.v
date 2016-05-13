`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:14:29 05/13/2016 
// Design Name: 
// Module Name:    RippleCarryAddSub 
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
module RippleCarryAddSub #(parameter SIZE=15) (
    input [SIZE:0] a,
    input [SIZE:0] b,
    input c_in,
    output c_out,
    output [SIZE:0] s
    );

wire carry [SIZE+1:0];
wire b_add_sub [SIZE:0];
wire add_sub;

assign add_sub = c_in;
assign carry[0] = c_in;
	 
genvar i;
generate

	for (i = 0; i <= SIZE; i = i+1)
	begin: FullAdder_Gen
	
		assign b_add_sub[i] = b[i]^add_sub;
	
		FullAdd_Struct FA(
			.a(a[i]),
			.b(b_add_sub[i]),
			.c_in(carry[i]),
			.s(s[i]),
			.c_out(carry[i+1])
			);
		
	end
endgenerate
	
assign c_out = carry[SIZE+1];

endmodule