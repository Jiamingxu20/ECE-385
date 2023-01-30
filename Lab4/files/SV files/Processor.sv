//Always use input/output logic types when possible, prevents issues with tools that have strict type enforcement

module Processor (input logic   		   Clk,          // Internal
                                       Reset,        // Reset_ClearAX_LoadB:  Push button 0
													Run,     	  // LoadS:						Push button 1
                  input  logic [7:0]   SW,           // input data from switches
						//
						output logic  			Xval, 
                  output logic [7:0] 	Aval,
													Bval,
                  output logic [6:0]  	HEX0,
													HEX1,
													HEX2,
													HEX3);

	 // outputs from Synchronizer
	 logic Reset_SH, Run_SH;
	 logic [7:0] SW_S;
	 
	 // outputs from Control Unit / inputs to Multiplier Unit & Register Unit
	 logic ClearXA_Control, Shift_Control, Add, Sub;
	 
	 // the shifted out bit from A
	 logic A_out;
	 
	 // the value of A and B after mul
	 logic [7:0] A_value_mul, B_value_mul; 
	 logic 		 X_mul;
	 
	 // outputs from Register Unit / inputs to Multiplier Unit
	 logic       X_value, M_value;
	 logic [7:0] A_value, B_value;
	 logic Fn, clean;
	 
	 assign Fn = Sub & M_value;
	 assign clean = Reset_SH | ClearXA_Control;
	 assign M_value = B_value[0];
	 
	 assign Aval = A_value;
	 assign Bval = B_value;
	 assign Xval = X_value;

	 
	 // Adder&Shift Unit: Implement shift and add operations
	 addandsub_unit   add_unit ( 
								.Clk(Clk),
								.M(M_value), 
								.X(X_value),
								.A(A_value), 
								.S(SW_S), 
								.Fn(Fn),
								.X_out(X_mul),
								.A_out(A_value_mul)); 

	 // Register Unit: Set up RegisterX, RegisterA, RegisterB, RegisterM, RegisterS		
    register_unit_X  reg_unit_X (
								// inputs to Register Unit
                        .Clk(Clk),
                        .Reset(clean),
								.Load(Add || Sub),
								.X_In(X_mul),
								// outputs from Register Unit
								.X(X_value) );

	 register_unit_A  reg_unit_A (
								// inputs to Register Unit
                        .Clk(Clk),
                        .Reset(clean),
								.Shift_En(Shift_Control),
								.Shift_In(X_value),
								.Load(Add),
								.A_val(A_value_mul),
								// outputs from Register Unit
								.A_out(A_out),
								.A(A_value) );
								
	 register_unit_B  reg_unit_B (
								// inputs to Register Unit
                        .Clk(Clk),
                        .Reset(),
								.Shift_En(Shift_Control),
								.Shift_In(A_out),
								.Load(Reset_SH),
								.B_val(SW_S),
								// outputs from Register Unit
								.B_out(),
								.B(B_value) );
								
	 // Control Unit: State Machine and generating control signals
	 control_unit     con_unit (
							   // inputs to Control Unit
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .Run(Run_SH),
								// outputs from Control Unit
								.Shift_En(Shift_Control),
								.Add(Add),
                        .Sub(Sub),
							   .Clear_XA(ClearXA_Control)	);
								
	 // For display
	 HexDriver        HexAL (
                        .In0(A_value[3:0]),
                        .Out0(HEX0) );
	 HexDriver        HexBL (
                        .In0(B_value[3:0]),
                        .Out0(HEX2) );
	 HexDriver        HexAU (
                        .In0(A_value[7:4]),
                        .Out0(HEX1) );	
	 HexDriver        HexBU (
                        .In0(B_value[7:4]),
                        .Out0(HEX3) );
								
	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[1:0] (Clk, {~Reset,~Run}, {Reset_SH,  Run_SH});
	  sync SW_sync[7:0] (Clk, SW, SW_S);
	  
endmodule
