module register_unit_B (input  logic        Clk, Reset, Shift_En,
                        input  logic        Shift_In, Load,
							   input  logic [7:0]  B_val,
                        output logic        B_out,
                        output logic [7:0]  B);
	 

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset)
			  B <= 8'h0;
		 else if (Load)
			  B <= B_val;
		 else if (Shift_En)
		 begin
			  B <= { Shift_In, B[7:1] }; 
	    end
    end
	
    assign B_out = B[0];

endmodule
