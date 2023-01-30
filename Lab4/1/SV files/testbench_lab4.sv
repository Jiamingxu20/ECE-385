module testbench_lab4();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic          Clk = 0;
logic          Reset, Run;
logic [7:0]    SW;
logic  			Xval;
logic [7:0] 	Aval,
					Bval,
					Sval;
logic [6:0]  	AhexL,
					AhexU,
		   		BhexL,
					BhexU;

// To store expected results
logic [15:0] ans_1a;
				

integer ErrorCnt = 0;
		

Processor processor0(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 


initial begin: TEST_VECTORS
Reset = 1;
// when reset == 0, we reset
// when reset == 1, we do not reset
Run = 1;       // clear XA, load B, B=1
SW = 8'h7;     // Set SW to 1

#3 Reset = 0;	
#3 Reset = 1;

#3 SW = 8'b11000101;  // Set SW to 0
   Run = 0;	   // load S, S=0
	
#50 Run = 1;
    ans_1a = (16'b1111111001100011); // Expected result of 1st cycle

    if (Aval != ans_1a[15:8])
	 ErrorCnt++;
    if (Bval != ans_1a[7:0])
	 ErrorCnt++;

if (ErrorCnt == 0)
	$display("Success!");
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
end
endmodule
