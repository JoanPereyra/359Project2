`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:11:46 04/19/2016 
// Design Name: 
// Module Name:    echo 
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
module echo(
    input [63:0] float1,
    input [63:0] float2,
    input clock_50M,
    input reset,
    input select,
    input start,
    output reg done,
    output reg [127:0] out
    );
	 
	 reg [6:0] clock128;
	 reg running;
	 reg select_save;
	 
	 always @(posedge clock_50M) begin
		if (reset) begin
			clock128 <= 7'd0;
			out <= 128'd0;
			done <= 1'b0;
			running <= 1'b0;
			select_save <= 1'b0;
		end else if(start && ~running) begin
			running <= 1'b1;
			clock128 <= 1'b0;
			done <= 1'b0;
			select_save <= select;
		end else if (running) begin
			clock128 <= clock128 + 7'd1;
			if (clock128 == 7'd127) begin
				if (select_save) out <= {float2,float1};
				else out <= {float2,float1};
				done <= 1'b1;
				running <= 1'b0;
			end else done <= 1'b0;
		end else done <= 1'b0;
	end

endmodule
