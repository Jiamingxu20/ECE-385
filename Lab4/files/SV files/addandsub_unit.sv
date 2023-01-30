module addandsub_unit
(
	input  logic        Clk, X, M,
	input  logic  [7:0] A, S,
	input  logic        Fn, 
	output logic  		  X_out,
	output logic  [7:0] A_out
);


	 logic       X_mul0, X_mul1;
	 logic [7:0] A_mul0, A_mul1;
	 
	 full_adder_9bit FA9_0 (.Clk(Clk), .A(A), .S(S ^ {8{1'b1}}), .cin(1'h1), .A_out(A_mul0), .X_out(X_mul0));
	 
	 full_adder_9bit FA9_1 (.Clk(Clk), .A(A), .S(S),        .cin(1'h0), .A_out(A_mul1), .X_out(X_mul1));

	 always_comb
    begin
		  if (Fn == 1'b1) begin 
				X_out = X_mul0;
				A_out = A_mul0;
		  end 
		  else if (Fn == 1'b0 && M == 1'b1) begin
		      X_out = X_mul1;
   	      A_out = A_mul1;
		  end
		  else begin
				X_out = X;
   	      A_out = A;
		  end
    end
	 
endmodule
