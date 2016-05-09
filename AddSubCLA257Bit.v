`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:57:34 05/09/2016 
// Design Name: 
// Module Name:    AddSubCLA257Bit 
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
module AddSubCLA257Bit(
		input [256:0] a,
		input [256:0] b,
		input add_sub,
		output [256:0] s,
		output carry_out
		);
	 
		wire c [0:510];
		wire g [0:510];
		wire p [0:510];
		wire b_add_sub [256:0];
		wire [1:0] g_con, p_con;
		wire c_con;
		
		assign carry_out = (g_con[1]|(p_con[1]&add_sub))^add_sub;
		
		generate
		genvar i;
			
			for(i = 0; i<257; i = i+1)
			begin: Block_Generator
				
				if (i < 256)
					BlockA A(
						.a(a[i]),
						.b(b_add_sub[i]),
						.s(s[i]),
						.g(g[i]),
						.p(p[i]),
						.c_in(c[i])
						);
				if	(i < 255)
					BlockB B(
						.c_in(c[i+256]),
						.c_pass(c[2*i]),
						.c_out(c[2*i+1]),
						.G_ij(g[2*i]),
						.G_jk(g[2*i+1]),
						.G_out(g[i+256]),
						.P_ij(p[2*i]),
						.P_jk(p[2*i+1]),
						.P_out(p[i+256])
						);
						
				assign b_add_sub[i] = b[i]^add_sub;
					
			end
		endgenerate
		
		BlockA LastBit_A(
			.a(a[256]),
			.b(b_add_sub[256]),
			.s(s[256]),
			.g(g_con[0]),
			.p(p_con[0]),
			.c_in(c_con)
			);
		
		BlockB B_08(
			.c_in(add_sub),
			.c_pass(c[510]),
			.c_out(c_con),
			.G_ij(g[510]),
			.G_jk(g_con[0]),
			.G_out(g_con[1]),
			.P_ij(p[510]),
			.P_jk(p_con[0]),
			.P_out(p_con[1])
			);
					
		
endmodule
