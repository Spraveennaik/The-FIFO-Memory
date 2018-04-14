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

// The timescale directive  
`timescale 1 ns/ 10 ps

`define DELAY 10


module Verilog_117_133;

	// Parameter definitions
	parameter ENDTIME = 2500;	// Parameter to decide ending time of program
	
	// Input regs
	reg     clk;				// Clock to drive the circuit
	reg     rst_n;				// Reset signal (negative edge triggered)
	reg     wr;					// Write pointer
	reg     rd;					// Read pointer
	reg     [7:0] data_in;		// 8-bit input data
	
	// Output wires
	wire     [7:0] data_out;	// 8-bit output data
	wire     fifo_empty;		// Signal to indicate that FIFO is empty
	wire     fifo_full;			// Signal to indicate that FIFO is full
	wire     fifo_overflow;		// Signal to indicate Overflow condition
	wire     fifo_underflow;	// Signal to indicate Overflow condition

	integer i;					// iterator used in looping statements

	// Instantiation
	
	VerilogBM_117_133 FIFO (
	//VerilogDM_117_133 FIFO (	
		
		// Outputs
		data_out, fifo_full, fifo_empty, fifo_overflow, fifo_underflow,
		// Inputs
		clk, rst_n, wr, rd, data_in
		);
	
	// Initial Conditions
	initial begin
		   
		$dumpfile("VerilogBM-117-133.vcd");
		//$dumpfile("VerilogDM-117-133.vcd");
		$dumpvars(0, Verilog_117_133);

		clk		= 1'b0;
		rst_n	= 1'b0;
		wr		= 1'b0;
		rd		= 1'b0;
		data_in	= 8'd0;
	
	end

	// Generating Test Vectors
	initial begin
		
		   main;
	
	end
	
	task main;
	fork
		clock_generator;		// Used to generate the clock cycle
		reset_generator;		// Used to change the reset value
		operation_process;		// Driver task to write and read data in and from the FIFO memory
		result_fifo;			// Used to display the result of the code
		endsimulation;			// Task to end the simulation
	join
	endtask
	
	task clock_generator;
	begin	   
		   forever #`DELAY clk = !clk;
	end
	endtask
	
	task reset_generator;
	begin
		#(`DELAY*2)
		rst_n = 1'b1;
		# 7.9
		rst_n = 1'b0;
		# 7.09
		rst_n = 1'b1;
	end
	endtask
	
	task operation_process;
	begin
		for (i = 0; i < 17; i = i + 1) begin: WRE
			#(`DELAY*5)
			wr = 1'b1;
			data_in = data_in + 8'd1;
			#(`DELAY*2)
			wr = 1'b0;
		end
		#(`DELAY)
		for (i = 0; i < 17; i = i + 1) begin: RDE
			#(`DELAY*5)
			rd = 1'b1;
			#(`DELAY*2)
			rd = 1'b0;
		end
	end
	endtask

	// Result of fifo
	task result_fifo; 
	begin
		$display("----------------------------------------------");
		$display("----------------------------------------------");
		$display("------------- SIMULATION RESULT --------------");
		$display("----------------------------------------------");
		$display("----------------------------------------------");
		$monitor("TIME=%0d, reset=%d, wr=%b, rd=%b, data_in=%h, data_out=%h, fifo_empty=%d, fifo_full=%d, underflow=%d, overflow=%d",$time, rst_n, wr, rd, data_in, data_out, fifo_empty, fifo_full, fifo_underflow, fifo_overflow);
	end
	endtask

	// Determines the simulation limit
	task endsimulation;
	begin
		#ENDTIME
		$display("------------ THE SIMUALTION FINISHED ------------");
		$finish;
	end
	endtask

endmodule
