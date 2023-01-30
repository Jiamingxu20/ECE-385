module MUX
(
	input  logic  [3:0] S0, S1,
	input  logic        C,
	output logic  [3:0] S
);
	  
	  
	  always_comb
	  begin
		   if (C==0)
				S[3:0] = S0[3:0];
			else
				S[3:0] = S1[3:0];
	  end
     
endmodule

