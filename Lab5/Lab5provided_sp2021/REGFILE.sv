module reg_file (
    input logic  Clk, Reset, LD,
    input logic  [15:0] bus, IR,
    input logic  [2:0] DRMUX_out, SR1MUX_out,
    output logic [15:0] SR1OUT, SR2OUT
);
logic [7:0] out;
logic [15:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;

always_comb
begin
if (LD == 1'h1)
	begin
		 if (DRMUX_out == 3'b000)
			  out = 8'b00000001;
		 else if (DRMUX_out == 3'b001)
			  out = 8'b00000010;
		 else if (DRMUX_out == 3'b010)
			  out = 8'b00000100;
		 else if (DRMUX_out == 3'b011)
			  out = 8'b00001000;
		 else if (DRMUX_out == 3'b100)
			  out = 8'b00010000;
		 else if (DRMUX_out == 3'b101)
			  out = 8'b00100000;
		 else if (DRMUX_out == 3'b110)
			  out = 8'b01000000;
		 else if (DRMUX_out == 3'b111)
			  out = 8'b10000000;
		 else
			  out = 8'bxxxxxxxx;
	end
else 
	out = 8'b00000000;
end 

register register0(.Clk(Clk), .Reset(Reset), .Load(out[0]), .Data(bus), .reg_out(reg0));
register register1(.Clk(Clk), .Reset(Reset), .Load(out[1]), .Data(bus), .reg_out(reg1));
register register2(.Clk(Clk), .Reset(Reset), .Load(out[2]), .Data(bus), .reg_out(reg2));
register register3(.Clk(Clk), .Reset(Reset), .Load(out[3]), .Data(bus), .reg_out(reg3));
register register4(.Clk(Clk), .Reset(Reset), .Load(out[4]), .Data(bus), .reg_out(reg4));
register register5(.Clk(Clk), .Reset(Reset), .Load(out[5]), .Data(bus), .reg_out(reg5));
register register6(.Clk(Clk), .Reset(Reset), .Load(out[6]), .Data(bus), .reg_out(reg6));
register register7(.Clk(Clk), .Reset(Reset), .Load(out[7]), .Data(bus), .reg_out(reg7));


always_comb
begin 
    if (SR1MUX_out == 3'b000)
        SR1OUT = reg0;
    else if (SR1MUX_out == 3'b001)
        SR1OUT = reg1;
    else if (SR1MUX_out == 3'b010)
        SR1OUT = reg2;
    else if (SR1MUX_out == 3'b011)
        SR1OUT = reg3;
    else if (SR1MUX_out == 3'b100)
        SR1OUT = reg4;
    else if (SR1MUX_out == 3'b101)
        SR1OUT = reg5;
    else if (SR1MUX_out == 3'b110)   
        SR1OUT = reg6;
    else if (SR1MUX_out == 3'b111)
        SR1OUT = reg7;
    else 
        SR1OUT = 16'h0000;
end
always_comb
begin 
    if (IR[2:0] == 3'b000)
        SR2OUT = reg0;
    else if (IR[2:0] == 3'b001)
        SR2OUT = reg1;
    else if (IR[2:0] == 3'b010)
        SR2OUT = reg2;
    else if (IR[2:0] == 3'b011)
        SR2OUT = reg3;
    else if (IR[2:0] == 3'b100)
        SR2OUT = reg4;
    else if (IR[2:0] == 3'b101)
        SR2OUT = reg5;
    else if (IR[2:0] == 3'b110)
        SR2OUT = reg6;
    else if (IR[2:0] == 3'b111)
        SR2OUT = reg7;
    else
        SR2OUT = 16'h0000;
end
endmodule


module register(
    input logic  Clk, Reset, Load,
    input logic  [15:0] Data,
    output logic [15:0] reg_out
);
always_ff @ (posedge Clk)
begin
    if (Reset)
        reg_out <= 16'h0000;
    else if (Load)
        reg_out <= Data;
end
endmodule