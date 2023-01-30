//Always use input/output logic types when possible, prevents issues with tools that have strict type enforcement

module Processor (input logic   		   Clk,          // Internal
                                       Reset,        // Reset_ClearAX_LoadB:  Push button 0
													Run,     		 // LoadS:						Push button 1
                  input  logic [7:0]   SW,     // input data from switches
						output logic  			Xval,
                  output logic [7:0] 	Aval,
													Bval,
													Sval,
                  output logic [6:0]  	AhexL,
													AhexU,
													BhexL,
													BhexU);

	 // outputs from Synchronizer
	 logic Reset_SH, Run_SH, LoadB_SH, LoadS_SH;
	 logic [7:0] SW_S;
	 
	 // outputs from Control Unit / inputs to Multiplier Unit & Register Unit
	 logic ClearXA_Control, LoadB_Control, LoadS_Control;
	 logic Itsthetime, Shift_Control;
	 
	 logic A_out, B_out;
	 
	 logic [7:0] A_value_mul, B_value_mul;
	 
	 // outputs from Register Unit / inputs to Multiplier Unit
	 logic       X_value, M_value, X_mul;
	 logic [7:0] A_value, B_value, S_value;
	 
	 always_comb
    begin
	     Xval = X_value;
		  Aval = A_value;
		  Bval = B_value;
		  Sval = S_value;
    end

	 
	 // Adder&Shift Unit: Implement shift and add operations
	 multiplier_unit  mul_unit (
	                     .Clk(Clk), 
								.X(X_value), 
								.M(B_value[0]), 
								.A(A_value), 
								.S(S_value), 
								.Itsthetime(Itsthetime),
								.X_out(X_mul), 
								.A_out(A_value_mul)); 

		// Register Unit: Set up RegisterX, RegisterA, RegisterB, RegisterM, RegisterS
	 register_unit    reg_unit (
								// inputs to Register Unit
                        .Clk(Clk),
                        .Reset(Reset),
								.ClearXA(ClearXA_Control),
								.Shift_En(Shift_Control),
								
								.X_In(X_mul),
								
								.A_In(X_value),
								.B_In(A_out),
                        .Ld_B(LoadB_Control),
								.Ld_S(LoadS_Control),
								
								.A_8(A_value_mul),
								.B_8(B_value_mul),
								.SW(SW_S),
								// outputs from Register Unit
								.A_out(A_out),
                        .B_out(B_out),
								
							   .A(A_value),
							   .B(B_value),
							   .S(S_value),
							   .X(X_value)	);
								
	 // Control Unit: State Machine and generating control signals
	 control_unit     con_unit (
							   // inputs to Control Unit
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .Run(Run_SH),
								// outputs from Control Unit
								.Shift_En(Shift_Control),
                        .Ld_B(LoadB_Control),
                        .Ld_S(LoadS_Control),
							   .Clear_XA(ClearXA_Control),
							   .Itsthetime(Itsthetime)	);
								
	 // For display
	 HexDriver        HexAL (
                        .In0(A_value[3:0]),
                        .Out0(AhexL) );
	 HexDriver        HexBL (
                        .In0(B_value[3:0]),
                        .Out0(BhexL) );
	 HexDriver        HexAU (
                        .In0(A_value[7:4]),
                        .Out0(AhexU) );	
	 HexDriver        HexBU (
                        .In0(B_value[7:4]),
                        .Out0(BhexU) );
								
	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[1:0] (Clk, {~Reset,~Run}, {Reset_SH,  Run_SH});
	  sync SW_sync[7:0] (Clk, SW, SW_S);
	  
endmodule
