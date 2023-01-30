module full_adder_9bit
(	
	input  logic       Clk,
	input  logic [7:0] A, S,
	input  logic       cin,
	output logic [7:0] A_out,
	output logic       X_out
);
	  
	  logic        C1, C2, C3, C4, C5, C6, C7, C8, C9;
	  logic [8:0]  A_9, S_9, A_9_out;
	  
	  
	  always_comb
	  begin
	      // sign extend RegisterA and RegisterS from 8-bit to 9-bit
		   A_9 = {A[7], A[7:0]};
			S_9 = {S[7], S[7:0]};
	  end 

	  full_adder_1bit FA1_0 (.A (A_9[0]), .B (S_9[0]), .cin (cin), .S (A_9_out[0]), .cout (C1));
	  full_adder_1bit FA1_1 (.A (A_9[1]), .B (S_9[1]), .cin (C1),  .S (A_9_out[1]), .cout (C2));
	  full_adder_1bit FA1_2 (.A (A_9[2]), .B (S_9[2]), .cin (C2),  .S (A_9_out[2]), .cout (C3));
	  full_adder_1bit FA1_3 (.A (A_9[3]), .B (S_9[3]), .cin (C3),  .S (A_9_out[3]), .cout (C4));
	  full_adder_1bit FA1_4 (.A (A_9[4]), .B (S_9[4]), .cin (C4),  .S (A_9_out[4]), .cout (C5));
	  full_adder_1bit FA1_5 (.A (A_9[5]), .B (S_9[5]), .cin (C5),  .S (A_9_out[5]), .cout (C6));
	  full_adder_1bit FA1_6 (.A (A_9[6]), .B (S_9[6]), .cin (C6),  .S (A_9_out[6]), .cout (C7));
	  full_adder_1bit FA1_7 (.A (A_9[7]), .B (S_9[7]), .cin (C7),  .S (A_9_out[7]), .cout (C8));
	  full_adder_1bit FA1_8 (.A (A_9[8]), .B (S_9[8]), .cin (C8),  .S (A_9_out[8]), .cout (C9));
     
	  always_comb
	  begin
		   A_out = A_9_out[7:0];
			X_out = A_9_out[8];
	  end 
	  
endmodule


module full_adder_1bit
(
	input  logic  A, B,
	input  logic  cin,
	output logic  S,
	output logic  cout
);
	  
	  
	  always_comb
	  begin
		   cout = (A&B)|(A&cin)|(B&cin);
		   S = A^B^cin;
	  end 
     
endmodule

