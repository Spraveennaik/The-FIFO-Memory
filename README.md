# The-FIFO-Memory

 

Submitted to : Dr. B. R. Chandavarkar
	              NITK,Surathkal.

Submitted by : Ishaan R Dharamdas  - 16CO117
	        Praveen Naik S           - 16CO133


Abstract : FIFO Memory implementation

Description : 
	
1. FIFO, or First In, First Out, is a method that relates to the organization and manipulation of data 
according to time and prioritization. In essence, the queue processing technique is done as per a first-come, 
first-served behaviour. 

2. The algorithm of the operating system scheduling gives every process CPU time according to the order it comes.
Each item is stored in a queue data structure. The first data which is added to the queue will be the first data to be
removed. Processing continues to proceed sequentially in this same order. 

3. FIFO is used for synchronization purposes in computer and CPU hardware. FIFO is generally implemented 
as a circular queue, and thus has a read pointer and a write pointer. A synchronous FIFO uses the same clock for
reading and writing. An asynchronous FIFO, however, uses separate clocks for reading and writing.


Components:

1. Write signal : Signal to write data into FIFO memory.
2. Read signal : Signal to read data from FIFO memory.
3. Input data    : 8-bit input data to be stored in FIFO memory.
4. Output data : 8-bit output data to be read from FIFO memory.
5. Full              : A signal which indicates that the FIFO memory is full.
6. Empty         : A signal which indicates that FIFO memory is empty.
7. Overflow     : A signal which is high when we try to write the data and the FIFO memory is full.
8. Underflow   : A signal which is high when we try to read the data and the FIFO memory is empty.
9. Reset  	       :Signal to reset the FIFO memory ciruit.

Working :

1.    First Reset the entire circuit.
2.    Initially, the FIFO memory is empty. So the Empty signal is High.
3.    Now, if you pass the read signal, it triggers the underflow signal.
4.    Inorder to write data into the FIFO memory, enable the write signal and enter the 8-bit input data. Toggle the write signal back to zero.
5.    Now, to read data stored in the FIFO memory, enable the read signal. The output will be displayed.
6.    You can repeat step 4 to write data in the FIFO memory.
7.    Once the FIFO memory is full, the Full signal becomes High.
8.    If the write signal is enabled when the Full signal is High, Overflow is detected and Write signal becomes inactive. No data can be entered.
9.    You can read the data that is stored in the FIFO memory by following step 5.
10.  Once the FIFO memory becomes empty, the Empty signal becomes High.
11.  If read signal is enabled when Empty is High, Underflow is detected and Read signal becomes inactive. No data can be read.
12.  The data that has been written first into FIFO will be the data that will be read out first.Hence it is called FIFO memory.
