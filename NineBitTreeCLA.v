`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:00:51 02/29/2016 
// Design Name: 
// Module Name:    NineBitTreeCLA 
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
module NineBitTreeCLA(
    input [8:0] a,
    input [8:0] b,
	 input carry_in,
    output [8:0] s,
    output carry_out
    );
	 wire c8_out;
		
		wire c [0:14];
		wire g [0:14];
		wire p [0:14];

		
		assign carry_out = g_con[1]|(p_con[1]&carry_in);
		
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
		
		BlockA LastBit_A(
			.a(a[8]),
			.b(b[8]),
			.s(s[8]),
			.g(g_con[0]),
			.p(p_con[0]),
			.c_in(c_con)
			);
			
		wire [1:0] g_con, p_con;
		wire c_con;
		
		BlockB B_08(
			.c_in(carry_in),
			.c_pass(c[14]),
			.c_out(c_con),
			.G_ij(g[14]),
			.G_jk(g_con[0]),
			.G_out(g_con[1]),
			.P_ij(p[14]),
			.P_jk(p_con[0]),
			.P_out(p_con[1])
			);
					
		
endmodule