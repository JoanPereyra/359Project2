`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:52:48 04/25/2016
// Design Name:   multiplier_top
// Module Name:   H:/359/project1/multiplier_top_tb.v
// Project Name:  project1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: multiplier_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module multiplier_top_tb;

	// Inputs
	reg UART_RX;
	reg CLK_IN;
	reg resetIn;

	// Outputs
	wire UART_TX;
	wire RECEIVED_OUT;
	wire UART_RX2;
	wire UART_TX2;
	wire RECEIVED_IN;
	
	

	// Instantiate the Unit Under Test (UUT)
	multiplier_top multlevel (
		.UART_TX(UART_RX2), 
		.RECEIVED_OUT(RECEIVED_IN), 
		.UART_RX(UART_TX2), 
		.RECEIVED_IN(RECEIVED_OUT), 
		.CLK_IN(CLK_IN), 
		.resetIn(resetIn)
	);
	
	// Instantiate the top-level module
	top_level toplevel (
    .CLK_50M(CLK_IN), 
    .SW(2'b00), 
    .UART_TX(UART_TX), 
    .UART_RX(UART_RX), 
    .UART_TX2(UART_TX2), 
    .UART_RX2(UART_RX2), 
    .RECEIVED_OUT(RECEIVED_OUT), 
    .RECEIVED_IN(RECEIVED_IN), 
    .resetIn(resetIn)
    );

	always #5 CLK_IN = ~CLK_IN;
	
	integer octet_index;
	integer bit_index;
	integer input_index;
	reg [127:0] in_val [1:0];
		
	initial begin
	
		in_val[0] = {128'hFF00FF00FF00FF00FF00FF00FF00FF00};
		//in_val[1] = {128'hFF00FF00FF00FF00aa11bb11aa11bb11};
	
		// Initialize Inputs
		UART_RX = 0;
		CLK_IN = 0;
		resetIn = 1;

		// Wait 100 ns for global reset to finish
		#100;
		
		resetIn = 1'b0;
        
		// Add stimulus here
		for (input_index = 0; input_index < 1; input_index = input_index +1) begin
			for (octet_index = 0; octet_index < 16; octet_index = octet_index +1) begin
				UART_RX = 1'b0; // Start bit
				#4320;
				for (bit_index = 0; bit_index < 8; bit_index =bit_index + 1) begin
					UART_RX = in_val[input_index][octet_index * 8 + bit_index];
					#4320;
				end
				UART_RX = 1'b1; // End bit
				#4320;
			end
			#4320; // Extra spacer between inputs
		end
	end
		
      
endmodule

