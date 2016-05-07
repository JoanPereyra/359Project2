`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:38:48 05/05/2016 
// Design Name: 
// Module Name:    CLATreeAdder128Bit 
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
module CLATreeAdder128Bit(
		input [127:0] a,
		input [127:0] b,
		input carry_in,
		output [127:0] s,
		output carry_out
		);
		
		wire c [0:254];
		wire g [0:254];
		wire p [0:254];

		assign c[254] = carry_in;
		assign carry_out = g[254]|(p[254]&carry_in);
		
		generate
		genvar i;
			
			for(i = 0; i<128; i = i+1)
			begin: Block_Generator
				
				BlockA A(
					.a(a[i]),
					.b(b[i]),
					.s(s[i]),
					.g(g[i]),
					.p(p[i]),
					.c_in(c[i])
					);
				if	(i < 127)
					BlockB B(
						.c_in(c[i+128]),
						.c_pass(c[2*i]),
						.c_out(c[2*i+1]),
						.G_ij(g[2*i]),
						.G_jk(g[2*i+1]),
						.G_out(g[i+128]),
						.P_ij(p[2*i]),
						.P_jk(p[2*i+1]),
						.P_out(p[i+128])
						);
					
			end
		endgenerate
					
endmodule
