`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:02:33 04/18/2016 
// Design Name: 
// Module Name:    transceiver64 
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
module transceiver64(
    output UART_TX,
    output RECEIVED_TX,
	 input RECEIVED_RX,
    input UART_RX,
    input reset,
    input clock,
	 input tx_wr,
    output [127:0] rx_data,
    input [127:0] tx_data
    );
	 
	xmit transmitter (
	.clock(clock), 
	.reset(reset), 
	.inval(tx_data), 
	.tx_wr(tx_wr), 
	.rx_done(RECEIVED_RX), 
	.UART_TX(UART_TX)
	);
	

	rcvr receiver (
	.clock(clock), 
	.reset(reset), 
	.UART_RX(UART_RX), 
	.tx_done(RECEIVED_TX), 
	.data_out(rx_data)
	);

endmodule
