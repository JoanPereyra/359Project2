`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:54:56 02/24/2016 
// Design Name: 
// Module Name:    EightBitAdder 
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
module EightBitAdder(
    input [7:0] a,
    input [7:0] b,
	 input carry_in,
    output [7:0] s,
    output carry_out
    );
		
		wire c [0:14];
		wire g [0:14];
		wire p [0:14];

		assign c[14] = carry_in;
		assign carry_out = g[14]|(p[14]&carry_in);
		
		generate
		genvar i;
			
			for(i = 0; i<8; i = i+1)
			begin: Block_Generator
				
				BlockA A(
					.a(a[i]),
					.b(b[i]),
					.s(s[i]),
					.g(g[i]),
					.p(p[i]),
					.c_in(c[i])
					);
				if	(i < 7)
					BlockB B(
						.c_in(c[i+8]),
						.c_pass(c[2*i]),
						.c_out(c[2*i+1]),
						.G_ij(g[2*i]),
						.G_jk(g[2*i+1]),
						.G_out(g[i+8]),
						.P_ij(p[2*i]),
						.P_jk(p[2*i+1]),
						.P_out(p[i+8])
						);
					
			end
		endgenerate
					
		
endmodule