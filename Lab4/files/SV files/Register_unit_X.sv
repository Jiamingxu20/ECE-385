module register_unit_X (input  logic        Clk, Reset, Load,
							   input  logic        X_In,
                        output logic        X);
	 
	 always_ff @ (posedge Clk)
    begin
		  if (Reset) begin
				X <= 1'b0;
		  end 
		  else if (Load) begin
		      X <= X_In;
		  end
    end
	 
endmodule
