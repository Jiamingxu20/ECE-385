module lookahead_adder_4 
(
	input   logic  [3:0] A, B,
	input   logic        cin,
	output  logic  [3:0] S,
	output  logic        cout,
	output  logic		   PG,
	output  logic		   GG
);
	  
	  logic P0, P1, P2, P3;
	  logic G0, G1, G2, G3;
	  logic C1, C2, C3;
	  logic cc1, cc2, cc3;
	  
	  
	  always_comb
	  begin
	  
		   G0 = A[0]&B[0];
		   G1 = A[1]&B[1];
		   G2 = A[2]&B[2];
		   G3 = A[3]&B[3];

		   P0 = A[0]^B[0];
		   P1 = A[1]^B[1];
		   P2 = A[2]^B[2];
		   P3 = A[3]^B[3];
		  
		   PG = P0&P1&P2&P3;
		   GG = G3|(G2&P3)|(G1&P2&P3)|(G0&P1&P2&P3);
		  
		   C1 = (cin&P0)|(G0);
		   C2 = (cin&P0&P1)|(G0&P1)|(G1);
		   C3 = (cin&P0&P1&P2)|(G0&P1&P2)|(G1&P2)|(G2);
		  		  
	  end
	  
	  full_adder_1bit FA1_0 (.A (A[0]), .B (B[0]), .cin (cin), .S (S[0]), .cout (cc1));
	  full_adder_1bit FA1_1 (.A (A[1]), .B (B[1]), .cin (C1),  .S (S[1]), .cout (cc2));
	  full_adder_1bit FA1_2 (.A (A[2]), .B (B[2]), .cin (C2),  .S (S[2]), .cout (cc3));
	  full_adder_1bit FA1_3 (.A (A[3]), .B (B[3]), .cin (C3),  .S (S[3]), .cout (cout));
     
endmodule
