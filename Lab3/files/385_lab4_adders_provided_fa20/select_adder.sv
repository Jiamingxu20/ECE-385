module select_adder (
	input  logic [15:0] A, B,
	input  logic        cin,
	output logic [15:0] S,
	output logic        cout
);

    logic c0, c1, c2, c3, c4, c5, c6;
	 logic [15:0] s0, s1, s2, s3, s4, s5, s6;
	 logic cc0, cc1;
	 
	 full_adder FA0 (.A (A[3:0]), .B (B[3:0]), .cin (cin), .S (S[3:0]), .cout (c0));
	 
	 
	 full_adder FA1 (.A (A[7:4]), .B (B[7:4]), .cin (0), .S (s0[7:4]), .cout (c1));
	 full_adder FA2 (.A (A[7:4]), .B (B[7:4]), .cin (1), .S (s1[7:4]), .cout (c2));
	 MUX MUX_1 (.S0 (s0[7:4]), .S1 (s1[7:4]), .C(c0), .S(S[7:4]));
	 assign cc0 = (c0&c2)|(c1);
	 
	 
	 full_adder FA3 (.A (A[11:8]), .B (B[11:8]), .cin (0), .S (s2[11:8]), .cout (c3));
	 full_adder FA4 (.A (A[11:8]), .B (B[11:8]), .cin (1), .S (s3[11:8]), .cout (c4));
	 MUX MUX_2 (.S0 (s2[11:8]), .S1 (s3[11:8]), .C(cc0), .S(S[11:8]));
	 assign cc1 = (cc0&c4)|(c3);
	 
	 
	 full_adder FA5 (.A (A[15:12]), .B (B[15:12]), .cin (0), .S (s4[15:12]), .cout (c5));
	 full_adder FA6 (.A (A[15:12]), .B (B[15:12]), .cin (1), .S (s5[15:12]), .cout (c6));
	 MUX MUX_3 (.S0 (s4[15:12]), .S1 (s5[15:12]), .C(cc1), .S(S[15:12]));
	 assign cout = (cc1&c6)|(c5);
	 

endmodule
