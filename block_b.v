`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:17:51 02/17/2016 
// Design Name: 
// Module Name:    block_b 
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
module block_B(
	input G_jk,
	input P_jk,
	input G_ij,
	input P_ij,
	input c_i,
	output G_ik,
	output P_ik,
	output c_iout,
	output c_j
    );

assign G_ik = G_jk | (P_jk & G_ij);
assign P_ik = P_jk & P_ij;
assign c_j = G_ij | (P_ij & c_i);
assign c_iout = c_i;

endmodule
