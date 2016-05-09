`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:11:41 04/06/2016 
// Design Name: 
// Module Name:    rcvr 
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
module rcvr(
    input clock,
    input reset,
    input UART_RX,
    output reg tx_done,
    output reg [127:0] data_out
    );
	 
	 reg [3:0] counter16;
	 reg [8:0] bit_count;
	 reg recieving;
	 reg [128:0] data_buf;
	 reg odd;
	 reg rx1;
	 reg rx2;
	 
	always @(posedge clock) begin
		if(reset) begin
			recieving <= 0;
			data_out <= 8'h00;
			tx_done <= 1'b0;
		end
		else begin
			// Buffer UART_RX
			rx1 <= UART_RX;
			rx2 <= rx1;
			
			// Increment the counter
			counter16 <= counter16+1;
			
			// Look for start
			if (~recieving) begin
				if (~rx2) begin // Start?
					counter16 <= 4'h7;
					recieving <= 1;
					bit_count <= 0;
					tx_done <= 0;
					odd <= 0;
				end
			end
			else if (counter16 == 4'b0000) begin
				bit_count <= bit_count+9'd1;
				
				if (bit_count == 9'd0) begin // Is it really start?
					if (rx2) begin // RX went high again too fast. Not start
						recieving <= 1'b0;
					end
				end
				if (bit_count == 9'd130) begin // End bit
					recieving <= 1'b0;
					if(rx2) begin // End bit found
						if(odd) begin
							data_out <= data_buf[127:0];
							tx_done <= 1'b1;
						end
					end
				end
				else begin
					// Record and shift
					data_buf <= {rx2, data_buf[128:1]};
					
					// Record parity
					if(rx2) begin
						odd <= ~odd;
					end
					
				end
			end
		end
	end
			
				
			


endmodule
