/*==========================================================================================================================================================
/	
/	Title            		  :- FIFO Memory																					
/	Register No      		  :- 16CO117 - 16CO133																				
/	Abstract         		  :- FIFO Memory Implementation																		
/	Functionalities  		  :- 1. Initially, the FIFO	memory is empty and Empty signal is high.								
/		               		 	 2. When Write signal is enabled, data can be written into the memory provided it isn't full	
/								 3. If we continue entering data into the memory, data will be stored in FIFO manner.			
/								 4. Once the FIFO memory is full, Full signal will be high. If we try to write data, Overflow	
/								 	signal will be triggered.																	
/								 5. To read data from FIFO, we enable the read signal which gives out the data that was entered 
/									first.																						
/								 6. We can continue to read data from memory until it becomes empty.							
/								 7. Once the FIFO is empty, Empty signal will be high. Now, if we try to read data Underflow	
/									signal will be triggered.																		
/						  		 8. Overall, the data entered or removed follows the FIFO fashion.								
/	
/	Brief Description on code :- 	All outputs of the code are generated in the respective VCD file. This code is used to 		
/								check for several conditions like Full, Empty, Overflow, Underflow of the FIFO memory.			
/									It is important to note that read and write pointers point to the same memory location		
/								at both full and empty conditions. Therefore, in order to differentiate between the two, one	
/								extra bit is added to read and write pointers. For example if a FIFO has depth of 256 then 		
/								to span it completely 8-bits will be needed. Therefore with one extra bit read and write 		
/								pointers will be of 9-bits. When their lower 8-bits point to same memory location their MSBs 	
/								are used to ascertain whether it is a full condition or empty condition. In empty conditions 	
/								the MSBs are equal whereas in full conditionMSBs are different.									
/																															    
/	                             																								
===========================================================================================================================================================*/

// Top level Verilog code for FIFO Memory
module VerilogDM_117_133(data_out, fifo_full, fifo_empty, fifo_overflow, fifo_underflow, clk, rst_n, wr, rd, data_in);
	
	input	wr;					// Write signal
	input	rd; 				// Read signal
	input   clk; 				// Clock to drive the circuit
	input   rst_n;				// Reset signal
	input	[7:0] data_in;	 	// 8-bit input data
	
	output	[7:0] data_out;		// 8-bit output data
	output	fifo_full;			// Signal to indicate that FIFO is full
	output	fifo_empty;			// Signal to indicate that FIFO is empty
	output	fifo_overflow;		// Signal to indicate Overflow condition
	output	fifo_underflow;		// Signal to indicate Underflow condition
	
	wire	[4:0] wptr;			// Write pointer
	wire	[4:0] rptr;			// Read pointer
	wire    fifo_we;			// To indicate that data can been entered 
	wire	fifo_rd;			// To indicate that data can be read
 
	write_pointer top1(wptr, fifo_we, wr, fifo_full, clk, rst_n);
	
	read_pointer top2(rptr, fifo_rd, rd, fifo_empty, clk, rst_n);

	memory_array top3(data_out, data_in, clk, rst_n, fifo_we, fifo_rd, wptr, rptr);

	status_signal top4(fifo_full, fifo_empty, fifo_overflow, fifo_underflow, wr, rd, fifo_we, fifo_rd, wptr, rptr, clk, rst_n);

endmodule

// Verilog code for Write Pointer sub-module
// This module drives the Write pointer
module write_pointer(wptr, fifo_we, wr, fifo_full, clk, rst_n);

	input	wr, fifo_full, clk, rst_n;

	output	[4:0] wptr;
	output	fifo_we;

	reg		[4:0] wptr;
  
	assign fifo_we = (~fifo_full) & wr;
	
	always @(posedge clk or negedge rst_n) begin

		if(~rst_n)							// If reset is low, Write pointer resets
			wptr <= 5'b00000;
	
		else if(fifo_we)					// If fifo_we is high (data can be entered),
			wptr <= wptr + 5'b00001;		// write pointer increments by 1

		else								// Else, write pointer remains same
			wptr <= wptr;
	
	end

endmodule

// Verilog code for Read Pointer sub-module
// This module drives the Read pointer
module read_pointer(rptr, fifo_rd, rd, fifo_empty, clk, rst_n);

	input	rd;				
	input	fifo_empty;
	input	clk;
	input	rst_n;
	
	output	[4:0] rptr;
	output	fifo_rd;
	
	reg		[4:0] rptr;
	
	assign fifo_rd = (~fifo_empty) & rd;
	
	always @(negedge clk or negedge rst_n) begin

		if(~rst_n)							// If reset is low, Read pointer resets
			rptr <= 5'b00000;
	
		else if(fifo_rd)					// If fifo_rd is high (data can be read),
			rptr <= rptr + 5'b00001;		// read pointer increments by 1

		else								// Else, read pointer remains same
			rptr <= rptr;
			
	end

endmodule

// Verilog code for Memory Array submodule
// The core of the FIFO memory
module memory_array(data_out, data_in, clk, rst_n, fifo_we, fifo_rd, wptr, rptr);
	
	input	[7:0] data_in;
	input	clk;
	input	rst_n;
	input	fifo_we;
	input	fifo_rd;
	input	[4:0] wptr;
	input	[4:0]rptr;
	
	output	[7:0] data_out;
	
	
	reg		[7:0] data_out2[15:0];			// 16 8-bit registers
	
	wire	[0:3]WR;						// Write-to-Register
	wire	[0:15]RegisterSelect;			// To select register where data is to be written
	wire	[3:0]RR;						// Read from register
	wire	[0:15]RRDecoded;				// To select register from where data will be read
	wire	[7:0] B[15:0];					// Series of outputs from 8-bit register
	
	always @(posedge clk) begin
		
		if(fifo_we)
			data_out2[wptr[3:0]] <= data_in ;

	end
	
	decoder_4_to_16 DC(WR[0:3], RegisterSelect[0:15]);

	decoder_4_to_16 DC1(RR[3:0], RRDecoded[0:15]);
	
	assign data_out = data_out2[rptr[3:0]];

	generate
		genvar i;
		for(i=0; i<16; i=i+1)
		begin
			register_8_bit RB(~clk, rst_n, WriteData[i], data_in, B[i][7:0]);
		end
	endgenerate

endmodule

// Verilog code for 4-16-decoder
module decoder_4_to_16 (
	
	input 	[0:3] A,						
	output	[0:15] B
	);
	
	assign B[0] = ~A[3] & ~A[2] & ~A[1] & ~A[0];
	assign B[1] = ~A[3] & ~A[2] & ~A[1] & A[0];
	assign B[2] = ~A[3] & ~A[2] & A[1] & ~A[0];
	assign B[3] = ~A[3] & ~A[2] & A[1] & A[0];
	assign B[4] = ~A[3] & A[2] & ~A[1] & ~A[0];
	assign B[5] = ~A[3] & A[2] & ~A[1] & A[0];
	assign B[6] = ~A[3] & A[2] & A[1] & ~A[0];
	assign B[7] = ~A[3] & A[2] & A[1] & A[0];
	assign B[8] = A[3] & ~A[2] & ~A[1] & ~A[0];
	assign B[9] = A[3] & ~A[2] & ~A[1] & A[0];
	assign B[10] = A[3] & ~A[2] & A[1] & ~A[0];
	assign B[11] = A[3] & ~A[2] & A[1] & A[0];
	assign B[12] = A[3] & A[2] & ~A[1] & ~A[0];
	assign B[13] = A[3] & A[2] & ~A[1] & A[0];
	assign B[14] = A[3] & A[2] & A[1] & ~A[0];
	assign B[15] = A[3] & A[2] & A[1] & A[0];
	
endmodule 

// Verilog code for 8-bit register
module register_8_bit(clock, reset, write, in, out);
	
	input clock;
	input reset;
	input write;
	input [7:0] in;
	
	output [7:0] out;

	wire clk1;
	
	assign clk1 = clk & write;
	D_flip_flop D0[7:0](in[7:0], clk1, reset, out[7:0]);
	
endmodule

// Verilog code for D Flip-Flop
module D_flip_flop(input D, clk, reset, output reg Q);
	
	always @(posedge clk or negedge reset) begin
		if(~reset)
		begin
			Q <= 1'b0;
		end
		else
		begin
			Q <= D;
		end
	end

endmodule

// Verilog code for Status Signals sub-module
// This module generates all the necessary output signals of FIFO memory
module status_signal(fifo_full, fifo_empty, fifo_overflow, fifo_underflow, wr, rd, fifo_we, fifo_rd, wptr, rptr, clk, rst_n);

	input	wr;
	input	rd;
	input	fifo_we;
	input	fifo_rd;
	input	clk;
	input	rst_n;
	input	[4:0] wptr;
	input	[4:0] rptr;

	output reg	fifo_full;
	output reg	fifo_empty;
	output reg	fifo_overflow;
	output reg	fifo_underflow;

	wire 	fbit_comp;						// Checks if the MSB of write and read pointers is the same
	wire	overflow_set;					// Checks overflow condition
	wire	underflow_set;					// Checks underflow condition
	wire 	pointer_equal;					// Returns high if both the read and write pointer point to the same memory location

	assign fbit_comp = wptr[4] ^ rptr[4];
	assign pointer_equal = (wptr[3:0] - rptr[3:0]) ? 0:1;
	assign overflow_set = fifo_full & wr;
	assign underflow_set = fifo_empty & rd;

	always @ * begin

		fifo_full = fbit_comp & pointer_equal;
		fifo_empty = (~fbit_comp) & pointer_equal;
	
	end

	always @(posedge clk or negedge rst_n) begin		// This snippet is used to generate Overflow signal
	
		if(~rst_n)
			fifo_overflow <= 0;

		else if((overflow_set == 1) && (fifo_rd == 0))
			fifo_overflow <= 1;
		
		else if(fifo_rd)
			fifo_overflow <= 0;

		else
			fifo_overflow <= fifo_overflow;
	
	end
 
	always @(posedge clk or negedge rst_n) begin		// This snippet is used to generate Underflow signal

		if(~rst_n)
			fifo_underflow <= 0;
		
		else if((underflow_set == 1) && (fifo_we == 0))
			fifo_underflow <= 1;

		else if(fifo_we)
			fifo_underflow <= 0;

		else
			fifo_underflow <= fifo_underflow;

	end
	
endmodule
