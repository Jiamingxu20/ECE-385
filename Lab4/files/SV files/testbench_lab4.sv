module testbench_lab4();

timeunit 10ns;	
timeprecision 1ns;


logic          Clk = 0;
logic          Reset, Run;
logic [7:0]    SW;
logic  			Xval;
logic [7:0] 	Aval,
					Bval;
logic [6:0]  	HEX0,
					HEX1,
		   		HEX2,
					HEX3;

// To store expected results
logic [15:0] ans_1a0;
logic [15:0] ans_1a1;
logic [15:0] ans_1a2;
logic [15:0] ans_1a3;

				

integer ErrorCnt0 = 0;
integer ErrorCnt1 = 0;
integer ErrorCnt2 = 0;
integer ErrorCnt3 = 0;
	

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
// when reset == 0, we reset
// when reset == 1, we do not reset


///////////////////////////////////////////////////////////////////////
// Test ++ 5*27=135
#2 Reset = 1;

#2 Run = 1;              
#2 SW = 8'b00000101;    // 5

#2 Reset = 0;				 
#2 Reset = 1;

#2 SW = 8'b00011011;    // 27
#2 Run = 0;	             
	
#50 Run = 1;
    ans_1a0 = (16'b0000000010000111);    // 135
    if (Aval != ans_1a0[15:8]) begin  
			ErrorCnt0++;
	 end
    if (Bval != ans_1a0[7:0]) begin
			ErrorCnt0++;
	 end 
if (ErrorCnt0 == 0)
	$display("++Success!");
else
	$display("%d error(s) detected. Try again!", ErrorCnt0);
	
///////////////////////////////////////////////////////////////////////
// Test +- 7*-59=135
#2 Reset = 1;

#2 Run = 1;              
#2 SW = 8'b00000111;    // 7

#2 Reset = 0;				 
#2 Reset = 1;

#2 SW = 8'b11000101;    // -59
#2 Run = 0;	             
	
#50 Run = 1;
    ans_1a1 = (16'b1111111001100011);    // -413
    if (Aval != ans_1a1[15:8]) begin  
			ErrorCnt1++;
	 end
    if (Bval != ans_1a1[7:0]) begin
			ErrorCnt1++;
	 end 
if (ErrorCnt1 == 0)
	$display("+-Success!");
else
	$display("%d error(s) detected. Try again!", ErrorCnt1);
	
///////////////////////////////////////////////////////////////////////
// Test -- -71*-5=355
#2 Reset = 1;

#2 Run = 1;              
#2 SW = 8'b10111001;    // -71

#2 Reset = 0;				 
#2 Reset = 1;

#2 SW = 8'b11111011;    // -5
#2 Run = 0;	             
	
#50 Run = 1;
    ans_1a2 = (16'b0000000101100011);    // 355
    if (Aval != ans_1a2[15:8]) begin  
			ErrorCnt2++;
	 end
    if (Bval != ans_1a2[7:0]) begin
			ErrorCnt2++;
	 end 
if (ErrorCnt2 == 0)
	$display("--Success!");
else
	$display("%d error(s) detected. Try again!", ErrorCnt2);
	
///////////////////////////////////////////////////////////////////////
// Test -+ -15*6=-90
#2 Reset = 1;

#2 Run = 1;              
#2 SW = 8'b11110001;    // -15

#2 Reset = 0;				 
#2 Reset = 1;

#2 SW = 8'b00000110;    // 6
#2 Run = 0;	             
	
#50 Run = 1;
    ans_1a3 = (16'b1111111110100110);    // -90
    if (Aval != ans_1a3[15:8]) begin  
			ErrorCnt3++;
	 end
    if (Bval != ans_1a3[7:0]) begin
			ErrorCnt3++;
	 end 
if (ErrorCnt3 == 0)
	$display("-+Success!");
else
	$display("%d error(s) detected. Try again!", ErrorCnt3);
	
	
	
	
end
endmodule
