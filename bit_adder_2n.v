`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:18:25 02/17/2016 
// Design Name: 
// Module Name:    bit_adder_2n 
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
module bit_adder_2n #(parameter N=128)(
	input [N-1:0] a,
	input [N-1:0] b,
	input c,
	output [N-1:0] sum,
	output carry_out,
	output P_ik,
	output G_ik
    );

wire [N*2-1:0] wire_p;
wire [N*2-1:0] wire_g;
wire [2*N-1:0] wire_carry;

assign wire_carry[2*N-2] = c; //carry always starts as c_in

generate 
	genvar i;

	for (i = 0; i < N; i = i+1)
		begin: N_block
		block_spg A(
				.a(a[i]),
				.b(b[i]),
				.c(wire_carry[i]),
				.p(wire_p[i]),
				.g(wire_g[i]),
				.s(sum[i])
				);
		if (i < N-1) //i*2
				block_B B(
				.G_jk(wire_g[2*i+1]),
				.P_jk(wire_p[2*i+1]),
				.G_ij(wire_g[2*i]),
				.P_ij(wire_p[2*i]),
				.c_i(wire_carry[N+i]),
				.G_ik(wire_g[i+N]),
				.P_ik(wire_p[i+N]),
				.c_iout(wire_carry[2*i]),
				.c_j(wire_carry[2*i+1])
				);
		end
		
 endgenerate
		

//assign carry_out = wire_g[N-1] + (wire_p[N-1] & wire_carry[N-1]); //test 4 and 8 bit
assign P_ik = wire_p[N+(N-2)];
assign G_ik = wire_g[N+(N-2)];
assign carry_out = G_ik | (P_ik & c);

 
endmodule