module register_unit (input  logic        Clk, Reset, Shift_En, ClearXA,
                      input  logic        X_In, A_In, B_In, Ld_B, Ld_S,
							 input  logic [7:0]  A_8, B_8,
                      input  logic [7:0]  SW, 
							 //
                      output logic A_out, B_out, X,
                      output logic [7:0]  A,
                      output logic [7:0]  B,
							 output logic [7:0]  S);

	 
	 logic S_out;
	 
	 always_comb
    begin
		  if (ClearXA) 
				X = 1'b0;
		  else if ()
		      X = X_In;
    end


    reg_8  reg_A (.Clk(Clk), .Reset(Reset | ClearXA), .Shift_En(Shift_En), .Shift_In(A_In), .Load(1'b0), 
						.Data_in(A_8),
	               .Shift_Out(A_out), .Data_Out(A));
	
    reg_8  reg_B (.Clk(Clk), .Reset(1'b0), .Shift_En(Shift_En), .Shift_In(A_out), .Load(Ld_B), 
						.Data_in(SW),
	               .Shift_Out(B_out), .Data_Out(B));
						
    reg_8  reg_S (.Clk(Clk), .Reset(1'b0), .Shift_En(1'b0), .Shift_In(1'b0), .Load(Ld_S), 
						.Data_in(A_8), 
	               .Shift_Out(S_out), .Data_Out(S));

endmodule
