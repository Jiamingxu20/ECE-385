module register_unit_A (input  logic        Clk, Reset, Shift_En,
                        input  logic        Shift_In, Load,
							   input  logic [7:0]  A_val,
                        output logic        A_out,
                        output logic [7:0]  A);
	 

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset)
			  A <= 8'h0;
		 else if (Load)
			  A <= A_val;
		 else if (Shift_En)
		 begin
			  A <= { Shift_In, A[7:1] }; 
	    end
    end
	
    assign A_out = A[0];

endmodule
