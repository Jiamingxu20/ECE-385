module control_unit (input  logic Clk, Reset, Run,
                     output logic Shift_En, Add, Sub, Clear_XA);

    enum logic [5:0] {Start, Hold, Hold1, S0, S1, S2, S3, S4, S5, S6, S7, A0, A1, A2, A3, A4, A5, A6, A7}   curr_state, next_state; 
	 

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)  
    begin
        if (Reset)
            curr_state <= Start;
        else 
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
    begin
		  next_state  = curr_state;	//required because I haven't enumerated all possibilities below
        unique case (curr_state) 
				Start:   if (Run)
                        next_state = Hold1;
				Hold1 :  next_state = A0;
				A0  :    next_state = S0;
            S0  :    next_state = A1;
            A1  :    next_state = S1;
            S1  :    next_state = A2;
            A2  :    next_state = S2;
            S2  :    next_state = A3;
            A3  :    next_state = S3;
            S3  :    next_state = A4;
            A4  :    next_state = S4;
            S4  :    next_state = A5;
				A5  :    next_state = S5;
            S5  :    next_state = A6;
            A6  :    next_state = S6;
            S6  :    next_state = A7;
            A7  :    next_state = S7;
            S7  :    next_state = Hold;
				Hold :	if (~Run) 
                        next_state = Start;
							  
        endcase
   
		  // Assign outputs based on ‘state’
        case (curr_state) 
	   	   Start:
	         begin
                Shift_En = 1'h0;
					 Clear_XA = 1'h0;
					 Add      = 1'h0;
					 Sub      = 1'h0;
		      end
				Hold1:
	         begin
                Shift_En = 1'h0;
					 Clear_XA = 1'h1;
					 Add      = 1'h0;
					 Sub      = 1'h0;
		      end
				A0, A1, A2, A3, A4, A5, A6:      // Add State
	         begin
				    Shift_En = 1'h0;
					 Clear_XA = 1'h0;
					 Add      = 1'h1;
					 Sub      = 1'h0;
		      end
				S0, S1, S2, S3, S4, S5, S6, S7:  // Shift State
	         begin
				    Shift_En = 1'h1;
					 Clear_XA = 1'h0;
					 Add      = 1'h0;
					 Sub      = 1'h0;
		      end
				A7:                              // Sub State
	         begin
				    Shift_En = 1'h0;
					 Clear_XA = 1'h0;
					 Add      = 1'h1;
					 Sub      = 1'h1;
		      end
				Hold: 
				begin 
					 Shift_En = 1'h0;
					 Clear_XA = 1'h0;
					 Add      = 1'h0;
					 Sub      = 1'h0;
				end 
				default:
					begin
						Shift_En = 1'h0;
						Clear_XA = 1'h0;
						Add      = 1'h0;
						Sub      = 1'h0;
					end
		    
        endcase
    end

endmodule
