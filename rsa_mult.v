`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:14:02 05/03/2016 
// Design Name: 
// Module Name:    rsa_mult 
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
module rsa_mult(
	input clk,
	input rst,
	input [127:0] a,
	input [127:0] b,
	output [255:0] c_mult,
	output done
    );

	reg [127:0] multiplicand;
	reg [256:0] P; //bit 16 is carry, bit [7:0] is multiplicand
	reg [127:0] partial_prod;
	wire [127:0] sum_out;
	reg [7:0] counter;
	
	parameter [1:0] IDLE = 2'b00,
						 ADD = 2'b01,
						 NO_ADD = 2'b10,
						 END = 2'b11;
						 
	reg [1:0] state;
	assign c_mult = P[255:0];
	assign done = state[1] & state[0];	// END
	
	bit_adder_2n #(128) Adder(.a(P[255:128]), .b(partial_prod), .c(1'b0), .sum(sum_out), .carry_out(carry));
		
	always @(posedge clk) begin
		if (rst) begin 
			state = IDLE;
			counter <= 0;
		end else begin
			case(state) 
				IDLE:
					begin
						multiplicand <= a;
						P[256:128] <= 0;
						P[127:0] <= b;
						counter <= 0;
						partial_prod = P[0] * multiplicand;
					
						if (partial_prod) state = ADD; 
						else state = NO_ADD;
					
					end
				ADD:
					begin
				
						if (counter == 129)
							begin
								state = END;
							end
						else 
							begin
								//add multiplicand and shift
								P <= {carry, sum_out, P[127:0]} >> 1;
								partial_prod = P[0] * multiplicand;
								counter <=  counter + 1;
						
								if (partial_prod) state = ADD; 
								else state= NO_ADD;
							end
					end
				NO_ADD:
						begin
				
						if (counter == 129)
							begin
								state = END;
							end
						else 
							begin
								//add multiplicand and shift
								P <= P >> 1;
								partial_prod = P[0] * multiplicand;
								counter <=  counter + 1;
						
								if (partial_prod) state = ADD; 
								else state = NO_ADD;
							end
					end
				END:
					begin
						state = END;
					end
			
			endcase
		end
	end

endmodule
