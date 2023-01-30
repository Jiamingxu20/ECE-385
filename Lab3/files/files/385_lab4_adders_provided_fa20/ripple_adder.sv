module ripple_adder
(
	input  logic  [15:0] A, B,
	input  logic         cin,
	output logic  [15:0] S,
	output logic         cout
);
	 
	  logic c0, c1, c2, c3, c4;
	  
	  assign c0 = cin;
	  assign cout = c4;

	  
	  full_adder FA0 (.A (A[3:0]),   .B (B[3:0]),   .cin (c0),  .S (S[3:0]),   .cout (c1));
	  full_adder FA1 (.A (A[7:4]),   .B (B[7:4]),   .cin (c1),  .S (S[7:4]),   .cout (c2));
	  full_adder FA2 (.A (A[11:8]),  .B (B[11:8]),  .cin (c2),  .S (S[11:8]),  .cout (c3));
	  full_adder FA3 (.A (A[15:12]), .B (B[15:12]), .cin (c3),  .S (S[15:12]), .cout (c4));
	  

	  
endmodule
