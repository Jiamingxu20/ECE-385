module Statemachine (   input logic         Clk, Reset, Enter, Player1wins, Player2wins, Esc, 
								output logic        gamebegin_on, gaming_on, gameend_on, reset0, pause);

	enum logic [4:0] {gamebegin, gaming, Player1WIN, Hold1, Player2WIN, Hold2, Pause, Phold1, Phold2}   State, Next_state;   // Internal state logic
	
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= gamebegin;
		else 
			State <= Next_state;
	end

	always_comb
	begin 
		gamebegin_on = 1'b0;
		gaming_on = 1'b0;
		gameend_on = 1'b0;
		reset0 = 1'b0;
		pause = 1'b0;
		
		Next_state = State;
		unique case (State)
		
			gamebegin : 
				if (Enter) 
					Next_state = gaming;

			gaming :
				if (Esc)
					Next_state = Pause;
				else if (Player1wins) 
					Next_state = Player1WIN;
				else if (Player2wins) 
					Next_state = Player2WIN;
			
			
			Pause :
				if (!Esc) 
					Next_state = Phold1;
				else 
					Next_state = Pause;
			
			Phold1 :
				if (Esc) 
					Next_state = Phold2;
				else 
					Next_state = Phold1;
					
			Phold2 :
				if (!Esc) 
					Next_state = gaming;
				else 
					Next_state = Phold2;

			Player1WIN :
				if (Enter) 
					Next_state = Hold1;
			
			Hold1 :
				if (!Enter) 
					Next_state = gamebegin;
					
			Player2WIN :
				if (Enter) 
					Next_state = Hold2;
					
			Hold2 :
				if (!Enter) 
					Next_state = gamebegin;

		default : ;
		endcase
		
		// Assign control signals based on current state
		case (State)
			gamebegin: 
				gamebegin_on = 1'b1;
			
			gaming: 
				gaming_on = 1'b1;
			
			Player1WIN: 
				gameend_on = 1'b1;
			
			Player2WIN: 
				gameend_on = 1'b1;
			
			Hold1:
			begin
				gameend_on = 1'b1;
				reset0 = 1'b1;
			end
			
			Hold2:
			begin
				gameend_on = 1'b1;
				reset0 = 1'b1;
			end
			
			Pause: 
				pause = 1'b1;
			
			Phold1: 
				pause = 1'b1;
			
			Phold2: 
				pause = 1'b1;
			
			default : ;
		endcase
	end 
endmodule
