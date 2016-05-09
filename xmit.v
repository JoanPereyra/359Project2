`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:46 04/06/2016 
// Design Name: 
// Module Name:    xmit 
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
module xmit(
	input clock, 
	input reset, 
	input [127:0] inval, 
	input tx_wr, 
	input rx_done, 
	output reg UART_TX
	);

	reg [127:0] fifo [15:0];
	reg [3:0] rx_pointer;
	reg [3:0] tx_pointer;
	reg [8:0] bits_sent;
	reg [3:0] counter16;
	reg [2:0] count8;
	
	reg transmit;
	reg parity;
	reg [127:0] send_buf;
	
	always @ (posedge clock) begin
		
		if (reset) begin
			UART_TX <= 1;
			bits_sent <= 0;
			rx_pointer <= 4'd0;
			tx_pointer <= 4'd0;
			transmit <= 1'b0;
			parity <= 1;
			counter16 <= 0;
			count8 <= 3'b000;
		end
		if (tx_wr && ~transmit) begin
			transmit <= 1;
			send_buf <= inval;
			counter16 <= 0;
			bits_sent <= 0;
			parity <= 1;
		end
		
		if (transmit) begin
			counter16 <= counter16+1;
			if(counter16 == 15) begin
				if (bits_sent < 132) begin
					bits_sent <= bits_sent+1;
					if (bits_sent == 0) begin // Send start bit
						UART_TX <= 1'b0;
					end
					else if (bits_sent == 129) begin // Parity
						UART_TX <= parity;
					end
					else if (bits_sent == 130) begin // End bit 
						UART_TX <= 1'b1;
					end
					else if (bits_sent == 131) begin // Decide if otherside recieved the bits
						if(~rx_done) begin
							bits_sent <= 0;
						end else begin
							transmit <= 1'b0;
						end
					end
					else begin // Send the bits
						UART_TX <= send_buf[0];
						send_buf <= {1'b0, send_buf[127:1]};
						if(send_buf[0]) parity <= ~parity;
					end
				end
				else begin
					transmit <= 1'b0;
				end
			end
		end // Transmit
	end // Clock

endmodule
