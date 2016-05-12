`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:08:24 05/12/2016 
// Design Name: 
// Module Name:    top_level_2 
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
module top_level_2(
  input               CLK_50M,
  input       [ 1: 0] SW,
  output              UART_TX,
  input               UART_RX,
  output					 UART_TX2,
  output		  [ 5: 0] LED,
  input					 UART_RX2,
  output					 RECEIVED_OUT,
  input					 RECEIVED_IN,
  input               resetIn
);

// Clock Resets Signals
  wire          clock_50M;
  wire          clock_200M;
  wire          dcm_locked;
  wire          arst_n = dcm_locked;
  
// UART Signals
  wire        [15: 0] divisor;
  wire        [ 127: 0] rx_data;
  wire                rx_irq;
  wire        [ 127: 0] tx_data;
  wire                tx_wr;
  wire                tx_irq;
  wire                tx_tcvr;
  
// FIFO
  reg         [ 3: 0] rx_pointer;
  reg         [ 3: 0] tx_pointer;
  reg         [ 7: 0] fifo [9:0];
  

/*************************************************************/
//             CLOCK GEN AND COUNTERS                        //
/*************************************************************/

   reg        RST_IN;
   reg  [3:0] RST_Counter;
   wire       CLKIN_IBUFG_OUT;
  

	clock_gen01 MYclock_gen01 (
		 .CLKIN_IN(CLK_50M), 
		 .RST_IN(RST_IN), 
		 .CLKFX_OUT(clock_200M), 
		 .CLKIN_IBUFG_OUT(CLKIN_IBUFG_OUT), 
		 .CLK0_OUT(clock_50M), 
		 .LOCKED_OUT(dcm_locked)
    );
 
	parameter [1:0] RESET  = 2'b00,
	                WAIT   = 2'b01,
						 LOCKED = 2'b10;
	reg [1:0] nx_state;

	always @ (posedge CLKIN_IBUFG_OUT or posedge resetIn) begin
		if (resetIn)	nx_state <= RESET;
	   else begin           
			case (nx_state)
				RESET     : begin
									RST_Counter <= 0;
									RST_IN <= 1;
									nx_state <= WAIT;
								end
				
				WAIT      : begin
									RST_Counter <= RST_Counter + 1;
									RST_IN <= 1;
									if (RST_Counter > 3)
										 nx_state <= LOCKED;
									else
										 nx_state <= WAIT;
							  end
				
				LOCKED    : begin
									RST_IN <= 0;
									nx_state <= LOCKED;
								end
				
				default   : begin
									RST_Counter <= 0;
									RST_IN <= 1;							   
								end						 
			endcase
		end
	end




/*************************************************************/
//                  RS-232 TRANCEIVER                        //
/*************************************************************/
parameter clk_freq = 50000000;
parameter baud = 115200;
assign UART_TX = tx_tcvr;
assign divisor = clk_freq/baud/16;

uart_transceiver transceiver(
	.sys_clk          ( clock_50M ),
	.sys_rst          ( ~arst_n   ),
	.uart_rx          ( UART_RX   ),
	.uart_tx          ( tx_tcvr   ),
	.divisor          ( divisor   ),
	.rx_data          ( rx_data   ),
	.rx_done          ( rx_irq    ),
	.tx_data          ( tx_data   ),
	.tx_wr            ( tx_wr     ),
	.tx_done          ( tx_irq    )
);



/*************************************************************/
//                  PLACE YOUR CODE HERE                     //
/*************************************************************/

//reg tx_wr_reg;
//reg [31:0]tx_data_reg;
//always @(posedge clock_50M) begin
//	if (rx_irq) begin
//		tx_data <= rx_data[31:0];
//		tx_wr <= 1'b1;
//	end else tx_wr <= 1'b0;
//end
//assign tx_wr = tx_wr_reg;
//assign tx_data = tx_data_reg;
//assign UART_TX2 = 1'b0;
//assign RECEIVED_OUT = 1'b0;


computation_master compute (
    .clock(clock_50M), 
    .reset(~arst_n), 
    .rx_data(rx_data), 
    .rx_irq(rx_irq), 
    .tx_data(tx_data), 
    .tx_wr_out(tx_wr),
	 .UART_RX2(UART_RX2),
	 .UART_TX2(UART_TX2),
	 .RECEIVED_OUT(RECEIVED_OUT),
	 .RECEIVED_IN(RECEIVED_IN),
	 .overflow(LED[0]),
	 .underflow(LED[1])
);

	

endmodule