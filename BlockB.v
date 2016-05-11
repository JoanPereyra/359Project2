`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:16:34 02/10/2016 
// Design Name: 
// Module Name:    BlockB 
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
module BlockB(
    input G_jk,
    input P_jk,
    input G_ij,
    input P_ij,
    input c_in,
    output c_pass,
    output c_out,
    output G_out,
    output P_out
    );

	assign c_pass = c_in;							//pass the carry in through untouched
	assign G_out = G_jk + (P_jk & G_ij);
	assign P_out = P_jk & P_ij;
	assign c_out = G_ij + (P_ij & c_in);

endmodule
