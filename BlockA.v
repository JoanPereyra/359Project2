`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:10:34 02/10/2016 
// Design Name: 
// Module Name:    BlockA 
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
module BlockA(
    input a,
    input b,
    output p,
    output g,
    input c_in,
    output s
    );

	assign s = a^b^c_in; 	//sum bit is aXORbXORc
	assign g = a&b;		//initial carry generate bit is aANDb
	assign p = a + b;		//initial carry propagate bit is aORb

endmodule
