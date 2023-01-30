module full_adder_1bit
(
	input  logic  A, B,
	input  logic  cin,
	output logic  S,
	output logic  cout
);
	  
	  
	  always_comb
	  begin
		   cout = (A&B)|(A&cin)|(B&cin);
		   S = A^B^cin;
	  end 
     
endmodule

