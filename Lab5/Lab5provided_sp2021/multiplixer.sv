// Tristate buffers
module multiplixer_buffer (
    input logic  Clk, 
    input logic  [15:0] GatePC_in, GateMDR_in, GateALU_in, GateMARMUX_in,
    input logic  GatePC, GateMDR, GateALU, GateMARMUX,
    output logic [15:0] out
);
always_comb
begin
	if (GatePC == 1'b1) 
        out = GatePC_in;
    else if (GateMDR == 1'b1)
        out = GateMDR_in;
    else if (GateALU == 1'b1)
        out = GateALU_in;
    else if (GateMARMUX == 1'b1)
        out = GateMARMUX_in;
    else 
        out = 16'bxxxxxxxxxxxxxxxx;
end
endmodule

// PC MUX
module PCMUX (
    input logic  [1:0]  Select,
    input logic  [15:0] A, B, C,
    output logic [15:0] out
);
always_comb
begin
	if (Select == 2'b00) 
        out = A;
    else if (Select == 2'b01)
        out = B;
    else if (Select == 2'b10)
        out = C;
    else 
        out = 16'bxxxxxxxxxxxxxxxx;
end
endmodule

module MIOMUX (
    input  logic  Select,
    input  logic  [15:0] A, B,
    output logic  [15:0] out
);
always_comb
begin
	if (Select == 1'b1) 
        out = A;
    else 
        out = B;
end
endmodule


module SR1MUX (
    input logic  [15:0] IR,
    input logic  Select,
    output logic [2:0] out
);
always_comb
begin
    if (Select == 1'b1) 
        out = IR[11:9];
    else 
        out = IR[8:6];
end
endmodule



module SR2MUX (
    input  logic [15:0] SR2OUT, IR,
	 input  logic Select,
    output logic [15:0] out
);
logic [15:0] IR_SEXT;
assign IR_SEXT = {IR[4], IR[4], IR[4], IR[4], IR[4], IR[4], IR[4], IR[4], IR[4], IR[4], IR[4], IR[4:0]};
always_comb
begin
	if (Select == 1'b1) 
        out = IR_SEXT;
    else 
        out = SR2OUT;
end
endmodule




module DRMUX (
    input logic  [15:0] IR, 
    input logic  Select,
    output logic [2:0] out
);
always_comb
begin
    if (Select == 1'b1)
        out = 3'b111;
    else
        out = IR[11:9];
end
endmodule



module ALU (
    input logic  [15:0] A, B,
    input logic  [1:0]  Select,
    output logic [15:0] out
);
always_comb
begin
    if (Select == 2'b00)
        out = A + B;
    else if (Select == 2'b01)
        out = A & B;
    else if (Select == 2'b10)
        out = ~A;
    else
        out = A;
end
endmodule


module ADDR1MUX (
    input logic  [15:0] PC, SR1OUT,
    input logic  Select,
    output logic [15:0] out
);
always_comb
begin
    if (Select == 0)
        out = PC;
    else
        out = SR1OUT;
end
endmodule


module ADDR2MUX (
    input logic  [1:0] Select,
    input logic  [15:0] IR,
    output logic [15:0] out
);    
logic [15:0] a, b, c, d;
assign a = 16'h0000;
assign b = {IR[5], IR[5], IR[5], IR[5], IR[5], IR[5], IR[5], IR[5], IR[5], IR[5], IR[5:0]};
assign c = {IR[8], IR[8], IR[8], IR[8], IR[8], IR[8], IR[8], IR[8:0]};
assign d = {IR[10], IR[10], IR[10], IR[10], IR[10], IR[10:0]};
always_comb
begin
    if (Select == 2'b00)
        out = a;
    else if (Select == 2'b01)
        out = b;
    else if (Select == 2'b10)
        out = c;
    else
        out = d;
end
endmodule


