`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:00:24 04/15/2016 
// Design Name: 
// Module Name:    computation_master 
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
module computation_master(
    input clock,
	 input reset,
    input [127:0] rx_data,
    input rx_irq,
    output reg [127:0] tx_data,
    output tx_wr_out,
	 output UART_TX2,
	 input UART_RX2,
	 output RECEIVED_OUT,
	 output overflow,
	 output underflow,
	 input RECEIVED_IN
    );
	 
	//reg [1:0]op_code;
	reg [63:0]param1;
	reg [63:0]param2;
	reg tx_wr;
	assign tx_wr_out = tx_wr;

	reg [3:0]run_module;
	wire [3:0]done;
	
	wire [127:0]outputs[3:0];

	always @(posedge clock) begin
		if (reset) begin
			param1 <= 32'd0;
			param2 <= 32'd0;
		end
		
		if(rx_irq) begin
			param1 <= rx_data[127:64];
			param2 <= rx_data[63:0];
			run_module[2] <= 1'b1;
		end else begin
			run_module <= 3'd0;
		end
		 
		
		if(done) begin
			if(done[0]) begin // Addition
				tx_data <= outputs[0];
			end 
			if(done[1]) begin // Subtraction
				tx_data <= outputs[1];
			end
			if(done[2]) begin // Multiplication
				tx_data <= outputs[2];
			end
			if(done[3]) begin // Multiplication
				tx_data <= outputs[3];
			end
			tx_wr <= 1'b1;
		end else begin
			tx_wr <= 1'b0;
		end
		
		
	end
	
	wire run_add_sub;
	assign run_add_sub = run_module[0] | run_module[1];
	wire add_sub_done;
	wire [31:0] sum_sub_add;
	assign done[0] = add_sub_done;
	assign done[1] = add_sub_done;
	assign outputs[0] = sum_sub_add;
	assign outputs[1] = sum_sub_add;

	//will be decode
	transceiver64 multiplier_sender (
    .UART_TX(UART_TX2),
    .RECEIVED_TX(RECEIVED_OUT),
    .RECEIVED_RX(RECEIVED_IN),
    .UART_RX(UART_RX2),
    .reset(reset),
    .clock(clock),
    .tx_wr(run_module[2]),
    .rx_data({outputs[2]}),
    .tx_data({param1, param2})
   );
	reg mult_out_buf;
	reg mult_done_reg;
	
	always @(posedge clock) begin
		mult_out_buf <= RECEIVED_OUT;
		if (RECEIVED_OUT && ~mult_out_buf) begin
			mult_done_reg <= 1'b1;
		end else begin
			mult_done_reg <= 1'b0;
		end
	end
		
	assign done[2] = mult_done_reg;
	
	//Will be encode
/*FP_Addition_pipeline adder(
    .CLK_50M(clock), 
    .reset(reset), 
    .a(param1), 
    .b(param2),
	 .opcode(op_code), 
    .start_bit(run_add_sub), 
    .sum(sum_sub_add), 
    .done(add_sub_done)
    ); */
	 
	 echo echoer (
    .float1(param1), // first floating param
    .float2(param2), //second floating param
    .clock_50M(clock), // 50MHZ clock
    .reset(reset), // Reset
    .select(1'b1), // Debug don't use for real modules
    .start(run_module[3]), // Input that will be high when operation is desired
    .done(done[3]), // raise to high for at lease 1 clock tick when finished
    .out(outputs[3]) // Final value (32-bits)
    );


endmodule
