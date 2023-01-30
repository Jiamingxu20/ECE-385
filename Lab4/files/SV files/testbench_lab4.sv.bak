module testbench_lab3();

timeunit 10ns;

timeprecision 1ns;

logic [15:0] A, B, S;
logic cin, cout; 
		

//ripple_adder RA (.A (A), .B (B), .cin (cin), .S (S), .cout (cout));

//lookahead_adder LA (.A (A), .B (B), .cin (cin), .S (S), .cout (cout));

select_adder LA (.A (A), .B (B), .cin (cin), .S (S), .cout (cout));


initial begin: TEST_ADDERS
A = 16'h270F;
B = 16'h270F;
cin = 1'h0;


end
endmodule
