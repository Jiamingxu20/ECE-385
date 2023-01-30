module lookahead_adder 
(
	input  logic  [15:0] A, B,
	input  logic         cin,
	output logic  [15:0] S,
	output logic         cout
);

	  
	  logic PG0, PG4, PG8, PG12;
	  logic GG0, GG4, GG8, GG12;
	  logic C4,  C8,  C12;
	  
	  logic CC4, CC8, CC12;
	  
	  always_comb
	  begin

		  C4 = GG0|(cin&PG0);
		  C8 = GG4|(GG0&PG4)|(cin&PG0&PG4);
		  C12 = GG8|(GG4&PG8)|(GG0&PG8&PG4)|(cin&PG8&PG4&PG0);

	  end
	  	  
	  lookahead_adder_4 LA0 (.A (A[3:0]),   .B (B[3:0]),   .cin (cin), .S (S[3:0]),   .cout (CC4),  .PG (PG0),  .GG (GG0));
	  lookahead_adder_4 LA1 (.A (A[7:4]),   .B (B[7:4]),   .cin (C4),  .S (S[7:4]),   .cout (CC8),  .PG (PG4),  .GG (GG4));
	  lookahead_adder_4 LA2 (.A (A[11:8]),  .B (B[11:8]),  .cin (C8),  .S (S[11:8]),  .cout (CC12), .PG (PG8),  .GG (GG8));
	  lookahead_adder_4 LA3 (.A (A[15:12]), .B (B[15:12]), .cin (C12), .S (S[15:12]), .cout (cout), .PG (PG12), .GG (GG12));
	  
	  
	  
endmodule
