module testbench_lab5();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic          Clk = 0;
logic          Continue, Run;
logic [9:0]    SW;
logic [9:0]    LED;
logic [6:0]  	HEX0,
					HEX1,
		   		HEX2,
					HEX3;
// To store expected results

integer ErrorCnt = 0;


slc3_testtop slc3_test0 (.*);	


// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 



// when Run/Continue == 0, we Run/Continue
// when Run/Continue == 1, we do not Run/Continue

initial begin: TEST
Run = 1'b1;
Continue = 1'b1;

#2 
Run = 1'b0;
Continue = 1'b0;

#2
Run = 1'b1;
Continue = 1'b1;


/*/Test 1
assign SW = 10'h3;

#2 Run = 1'b0;
#2 Run = 1'b1;
*/


/*/Test 2
assign SW = 10'h6;

#2 Run = 1'b0;
#2 Run = 1'b1;

#80 Continue = 1'b0;
#4 Continue = 1'b1;

#100 Continue = 1'b0;
#4 Continue = 1'b1;
*/

/*/Test 3
assign SW = 10'hB;

#2 Run = 1'b0;
#2 Run = 1'b1;

#80 Continue = 1'b0;
#4 Continue = 1'b1;

#100 Continue = 1'b0;
#4 Continue = 1'b1;

#100 Continue = 1'b0;
#4 Continue = 1'b1;

#100 Continue = 1'b0;
#4 Continue = 1'b1;

#100 Continue = 1'b0;
#4 Continue = 1'b1;
*/

/*/XOR Test

assign SW = 10'h014;

#2 Run = 1'b0;
#2 Run = 1'b1;

#300 Continue = 1'b0;    // Set A to 1
#4 Continue = 1'b1;

assign SW = 10'hff;
#300 Continue = 1'b0;    // Set B to 3
#4 Continue = 1'b1;
*/

/*/Multiplier Test

assign SW = 10'h031;

#2 Run = 1'b0;
#2 Run = 1'b1;

#200 Continue = 1'b0;    // Set A to 3
#4 Continue = 1'b1;

#200 Continue = 1'b0;    // Set B to 2
#4 Continue = 1'b1;

#300 Continue = 1'b0;    // Set B to 2
#4 Continue = 1'b1;

#300 Continue = 1'b0;    // Set B to 2
#4 Continue = 1'b1;

#300 Continue = 1'b0;    // Set B to 2
#4 Continue = 1'b1;

#2000 Continue = 1'b0;    // Set B to 2
#4 Continue = 1'b1;
*/

//Sort Test
#10
assign SW = 10'h05A;
Run = 1'b0;
#5 Run = 1'b1;

#100 
assign SW = 10'h002;
#100 Continue = 1'b0;
#10 Continue = 1'b1;

#30000
assign SW = 10'h003;
Continue = 1'b0;  
#500 Continue = 1'b1;



#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;

#300 Continue = 1'b0;  
#10 Continue = 1'b1;


end
endmodule
