module multiplier_unit
(
	input  logic        Clk, X, M,
	input  logic  [7:0] A, S,
	input  logic        Itsthetime, 
	output logic  		  X_out,
	output logic  [7:0] A_out
);


	 logic       X_mul, X_mul0, X_mul1;
	 logic [7:0] A_mul, B_mul;
	 logic [7:0] A_mul0, A_mul1;
	 
	 // Itsthetime && M
	 full_adder_9bit FA9_0 (.Clk(Clk), .A(A), .S(S ^ {8{M}}), .cin(1'h1), .A_out(A_mul0), .X_out(X_mul0));
	 
	 // !Itsthetime && M 
	 full_adder_9bit FA9_1 (.Clk(Clk), .A(A), .S(S),        .cin(1'h0), .A_out(A_mul1), .X_out(X_mul1));

	 always_comb //_ff @ (posedge Clk)
    begin
	     // check M and Itsthetime
		  if (Itsthetime == 1 && M == 1) begin 
				X_out = X_mul0;
				A_out = A_mul0;
		  end 
		  else if (Itsthetime == 0 && M == 1) begin
		      X_out = X_mul1;
   	      A_out = A_mul1;
		  end
		  else begin
		      X_out = X;
   	      A_out = A;
		  end
    end
	 
endmodule

