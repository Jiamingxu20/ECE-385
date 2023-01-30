module datapath (
	input  logic Clk, Reset, Run, Continue, 
	input  logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED, // Load control signals
	input  logic GatePC, GateMDR, GateALU, GateMARMUX, // Gate control signals
	input  logic SR2MUX, ADDR1MUX,
	input  logic MIO_EN, DRMUX, SR1MUX,
	input  logic [1:0] PCMUX, ADDR2MUX, ALUK,
	input  logic [15:0] MDR_In, 
	output logic BEN,
	output logic [15:0] IR, MAR, MDR, PC, Cycle_counter
);

logic [15:0] PC_out, PCMUX_out, PC_incrementer_out;
logic [15:0] BUS, IR_copy;
logic [2:0] DRMUX_out, SR1MUX_out; 
logic [15:0] SR1OUT, SR2OUT, SR2MUX_out, ALU_out;
logic [15:0] ADDR_out, ADDR1MUX_out, ADDR2MUX_out;
assign ADDR_out = ADDR1MUX_out + ADDR2MUX_out;
assign PC_incrementer_out = PC_out + 16'h0001;
assign IR = IR_copy;
assign PC = PC_out;

always_ff @(posedge Clk)
begin
    if (Reset) begin
      Cycle_counter <= 0;
    end else if ((PC < 16'h0048) && (PC >= 16'h003A)) begin
      Cycle_counter ++;
    end
end 
// MUX Block ////////////////////
multiplixer_buffer multiplixer_buffer_0 (
	.Clk(Clk),
	.GatePC_in(PC_out), .GateMDR_in(MDR), .GateALU_in(ALU_out), .GateMARMUX_in(ADDR_out),
	.GatePC(GatePC), .GateMDR(GateMDR), .GateALU(GateALU), .GateMARMUX(GateMARMUX),
	.out(BUS)
);

// PC Block /////////////////////////
Reg_16 PC_0 (
	.Clk(Clk), .Reset(Reset), .Load(LD_PC),
	.in(PCMUX_out),
	.out(PC_out)
);
PCMUX PCMUX_0 (
	.Select(PCMUX),
	.A(PC_incrementer_out), .B(ADDR_out), .C(BUS),
	.out(PCMUX_out)
);

// IR Block //////////////////////////
Reg_16 IR_0 (
	.Clk(Clk), .Reset(Reset), .Load(LD_IR),
	.in(BUS),
	.out(IR_copy)
);

// MAR & MDR Block ///////////////////
logic [15:0] MIO_out;
Reg_16 MAR_0 (
	.Clk(Clk), .Reset(Reset), .Load(LD_MAR),
	.in(BUS),
	.out(MAR)
);
MIOMUX MIOMUX_0 (
	.Select(MIO_EN), 
	.A(MDR_In), .B(BUS),
	.out(MIO_out)
);
Reg_16 MDR_0 (
	.Clk(Clk), .Reset(Reset), .Load(LD_MDR),
	.in(MIO_out),
	.out(MDR)
);

// nzp&ben Block /////////////////////////
logic nzp_out;
nzp nzp_0 (
	.Clk(Clk), .Reset(Reset), .Load(LD_CC),
	.NZP(IR_copy[11:9]), .in(BUS),
	.out(nzp_out)
);
ben ben_0 (
	.Clk(Clk), .Reset(Reset), .Load(LD_BEN), 
	.in(nzp_out),
	.out(BEN)
);

// REG_FILE Block ////////////////////////
reg_file reg_file_0 (
	.Clk(Clk), .Reset(Reset), .bus(BUS), .IR(IR_copy), 
	.LD(LD_REG), .DRMUX_out(DRMUX_out), .SR1MUX_out(SR1MUX_out),
	.SR1OUT(SR1OUT), .SR2OUT(SR2OUT)
);
DRMUX DRMUX_0 (
	.IR(IR_copy), .Select(DRMUX), 
	.out(DRMUX_out)
);
SR1MUX SR1MUX_0 (
	.IR(IR_copy), .Select(SR1MUX), 
	.out(SR1MUX_out)
);
SR2MUX SR2MUX_0 (
	.SR2OUT(SR2OUT), .IR(IR_copy), .Select(SR2MUX),
	.out(SR2MUX_out)
);
ALU ALU_0 (
	.A(SR1OUT), .B(SR2MUX_out), .Select(ALUK), 
	.out(ALU_out)
);

// ADDR1MUX & ADDR2MUX Block /////////////
ADDR1MUX ADDR1MUX_0 (
	.PC(PC_out), .SR1OUT(SR1OUT), .Select(ADDR1MUX),
	.out(ADDR1MUX_out)
);
ADDR2MUX ADDR2MUX_0 (
	.Select(ADDR2MUX), .IR(IR_copy), 
	.out(ADDR2MUX_out)
);

endmodule
