module Shift_unit
(
	input  logic        Clk, X, M,
	input  logic  [7:0] A, B, S,
	input  logic        Shift_En,
	input  logic        Itsthetime, 
	output logic  		  X_out,
	output logic  [7:0] A_out, B_out
);
	 logic       X_mul, X_mul0, X_mul1;
	 logic [7:0] A_mul, B_mul;
	 logic [7:0] A_mul0, A_mul1;
	 
	 // Itsthetime && M
	 full_adder_9bit FA9_0 (.Clk(Clk), .A(A), .S(S ^ 8'h1), .cin(1'h1), .A_out(A_mul0), .X_out(X_mul0));
	 
	 // !Itsthetime && M 
	 full_adder_9bit FA9_1 (.Clk(Clk), .A(A), .S(S),        .cin(1'h0), .A_out(A_mul1), .X_out(X_mul1));

	 always_ff @ (posedge Clk)  
    begin
	     // check M and Itsthetime
		  if (Itsthetime == 1 && M == 1)
				X_mul <= X_mul0;
				A_mul <= A_mul0;
		  if (Itsthetime == 0 && M == 1)
		      X_mul <= X_mul1;
   	      A_mul <= A_mul1;
	     // shift XAB 
		  if (Shift_En)
	         X_out <= X_mul;
	         A_out <= {X_mul, A_mul[7:1]};
		      B_out <= {A_mul[0], B_mul[7:1]};
    end
	 
endmodule

