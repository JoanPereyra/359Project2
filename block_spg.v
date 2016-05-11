`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:40:17 02/24/2016 
// Design Name: 
// Module Name:    block_spg 
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
module block_spg(
	input a,
	input b,
	input c,
	output p,
	output g,
	output s
    );

assign s = a^b^c;
assign p = a | b;
assign g = a & b;

endmodule
