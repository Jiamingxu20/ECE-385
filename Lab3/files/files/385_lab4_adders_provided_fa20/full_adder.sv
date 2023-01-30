module full_adder
(
	input  logic [3:0] A, B,
	input  logic       cin,
	output logic [3:0] S,
	output logic       cout
);
	  
	  logic C1, C2, C3;
	  
	  
	  
	  full_adder_1bit FA1_0 (.A (A[0]), .B (B[0]), .cin (cin), .S (S[0]), .cout (C1));
	  full_adder_1bit FA1_1 (.A (A[1]), .B (B[1]), .cin (C1),  .S (S[1]), .cout (C2));
	  full_adder_1bit FA1_2 (.A (A[2]), .B (B[2]), .cin (C2),  .S (S[2]), .cout (C3));
	  full_adder_1bit FA1_3 (.A (A[3]), .B (B[3]), .cin (C3),  .S (S[3]), .cout (cout));
     
endmodule

