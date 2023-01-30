module Reg_16 (
	 input  logic Clk, Reset, Load,
    input  logic [15:0] in,
	 output logic [15:0] out
);
always_ff @ (posedge Clk)
begin
	if (Reset)
        out <= 16'h0000;
    else if (Load)
        out <= in;
end
endmodule


module led (
	 input  logic Clk, Reset, Load,
    input  logic [9:0] in,
	 output logic [9:0] out
);
always_ff @ (posedge Clk)
begin
	if (Reset)
        out <= 10'b0000000000;
    else if (Load)
        out <= in;
end
endmodule
