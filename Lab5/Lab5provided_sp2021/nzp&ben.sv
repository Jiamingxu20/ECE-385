module nzp (
	 input  logic Clk, Reset, Load,
    input  logic [2:0] NZP,
    input  logic [15:0] in, 
	 output logic out
);
logic ben;
logic n, z, p;
logic N, Z, P;
assign N = NZP[2];
assign Z = NZP[1];
assign P = NZP[0];

always_ff @ (posedge Clk)
begin 
	if (Load) begin
		 if (in == 16'h0000) begin
			  n = 1'b0;
			  z = 1'b1;
			  p = 1'b0;
		 end
		 else if (in[15] == 1'b0) begin
			  n = 1'b0;
			  z = 1'b0;
			  p = 1'b1;
		 end
		 else begin
			  n = 1'b1;
			  z = 1'b0;
			  p = 1'b0;
		 end
	end
end 

assign out = (N&n) | (Z&z) | (P&p);


endmodule




module ben (
	 input  logic Clk, Reset, Load,
    input  logic in,
	 output logic out
);

always_ff @ (posedge Clk)
begin 
	 if (Reset)
		 out <= 1'b0;
	 else if (Load)
		 out <= in;
	 else 
		  out <= out;
end 
endmodule
