/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [11:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);


//put other local variables here
logic           blank, sync, VGA_CLK, rden_a, wren_a;
logic [9:0] 	 DrawX, DrawY;
logic [31:0]    VGA_READDATA, q_a, READDATA, AVL_READDATA_0, AVL_READDATA_1;

// local variable for drawing 
logic           inversebit, charSelect;
logic [2:0]		 DrawXmod;
logic [3:0]     DrawYmod, FGD_IDX, BKG_IDX;
logic [6:0]     charX;
logic [5:0]     charY;
logic [7:0]     data;
logic [9:0]     VGA_ADDR;
logic [10:0]    addr0;



// palette Registers
int i;
logic [31:0] Control_reg [8]; 
always_ff @(posedge CLK)
begin 
	if (RESET) 
	begin
		for (i = 0; i < 8; i = i + 1) 
		begin
			Control_reg[i] <= 32'h0;
		end
	end	
	else if (AVL_WRITE & AVL_CS & AVL_ADDR[11]) 
		Control_reg[AVL_ADDR-12'h800] <= AVL_WRITEDATA;
	else if (AVL_READ & AVL_CS & AVL_ADDR[11]) 
		AVL_READDATA_1 <= Control_reg[AVL_ADDR-12'h800];
end





// VGA_controller
vga_controller vga_controller_0 ( .Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(VGA_CLK),
								  .blank(blank), .sync(sync), .DrawX(DrawX), .DrawY(DrawY) );


// 2 ports on-chip memory: 
//		port a: for avalon_read, avalon_write, and vga_read
//		port b: for control_read

ram ram_1 ( .aclr_a(RESET),
				.clock_a(CLK),
				.address_a(AVL_ADDR),
			   .byteena_a(AVL_BYTE_EN),
				.data_a(AVL_WRITEDATA),
				.rden_a(AVL_READ & (~AVL_ADDR[11]) & AVL_CS),
				.wren_a(AVL_WRITE & (~AVL_ADDR[11])  & AVL_CS),
				.q_a(AVL_READDATA_0),
				//
				.aclr_b(RESET),
				.address_b(VGA_ADDR),
				.clock_b(CLK), 
				.data_b(),                				     // leave blank since we did not use port b to write
				.rden_b(1'b1),				     				  // always read the control register's value
				.wren_b(1'b0),				   				  // never use port b to write 
				.q_b(VGA_READDATA) );



// MUX for AVL_READDATA
always_comb 
begin 
	if (AVL_ADDR[11] == 1'b0)
		AVL_READDATA = AVL_READDATA_0;
	else 
		AVL_READDATA = AVL_READDATA_1;
end


//handle drawing (may either be combinational or sequential - or both).
assign charX = DrawX[9:3]; // DrawX/8                // the x location of each character
assign charY = DrawY[9:4]; // DrawY/16					  // the y location of each character
assign VGA_ADDR = (charY*80 + charX)/2;				  // the address at the VRAM
assign charSelect = (charY*80 + charX) % 2;			  // the 1 character select from 2 characters
assign DrawXmod = DrawX % 8;         // pixel x locations of electron gun at each word [7:0]
assign DrawYmod = DrawY % 16;		 // pixel y locations of electron gun at each word [15:0]


always_comb
begin 
	if (charSelect == 1'b0) 
	begin 
		inversebit = VGA_READDATA[15];
		addr0 = 16*VGA_READDATA[14:8];
		FGD_IDX = VGA_READDATA[7:4];
		BKG_IDX = VGA_READDATA[3:0];
	end
	else if (charSelect == 1'b1) 
	begin
		inversebit = VGA_READDATA[31];
		addr0 = 16*VGA_READDATA[30:24];
		FGD_IDX = VGA_READDATA[23:20];
		BKG_IDX = VGA_READDATA[19:16];
	end
	else 
	begin
		inversebit = 1'b0;
		addr0 = 11'h0;
		FGD_IDX = 4'h0;
		BKG_IDX = 4'h0;
	end
end



////////////////////////////////////////////////////////////////////////////////
// use the 4-bit FGD_IDX and BKG_IDX to the the RBG color in c program 

font_rom font_rom_1 (.addr(addr0 + DrawYmod), .data(data));

always_ff @ (posedge VGA_CLK)
begin:Printing
	if (blank)
	begin
		if (data[7-DrawXmod])
		begin
			if (!inversebit) 
			begin
				if (FGD_IDX % 2 == 0) 
				begin 
					red   <= Control_reg[FGD_IDX/2][12:9]; 
					green <= Control_reg[FGD_IDX/2][8:5];
					blue  <= Control_reg[FGD_IDX/2][4:1];
				end 
				else 
				begin
					red   <= Control_reg[FGD_IDX/2][24:21];
					green <= Control_reg[FGD_IDX/2][20:17];
					blue  <= Control_reg[FGD_IDX/2][16:13];
				end
			end
			//
			else 
			begin
				if (BKG_IDX % 2 == 0) 
				begin 
					red   <= Control_reg[BKG_IDX/2][12:9]; 
					green <= Control_reg[BKG_IDX/2][8:5];
					blue  <= Control_reg[BKG_IDX/2][4:1];
				end 
				else 
				begin
					red   <= Control_reg[BKG_IDX/2][24:21];
					green <= Control_reg[BKG_IDX/2][20:17];
					blue  <= Control_reg[BKG_IDX/2][16:13];
				end
			end
			
		end 
		//
		//
		else 
		begin
			if (!inversebit) 
			begin
				if (BKG_IDX % 2 == 0) 
				begin 
					red   <= Control_reg[BKG_IDX/2][12:9]; 
					green <= Control_reg[BKG_IDX/2][8:5];
					blue  <= Control_reg[BKG_IDX/2][4:1];
				end 
				else 
				begin
					red   <= Control_reg[BKG_IDX/2][24:21];
					green <= Control_reg[BKG_IDX/2][20:17];
					blue  <= Control_reg[BKG_IDX/2][16:13];
				end
			end
			//
			else 
			begin
				if (FGD_IDX % 2 == 0) 
				begin 
					red   <= Control_reg[FGD_IDX/2][12:9]; 
					green <= Control_reg[FGD_IDX/2][8:5];
					blue  <= Control_reg[FGD_IDX/2][4:1];
				end 
				else 
				begin
					red   <= Control_reg[FGD_IDX/2][24:21];
					green <= Control_reg[FGD_IDX/2][20:17];
					blue  <= Control_reg[FGD_IDX/2][16:13];
				end
			end
			
		end
	end
	//
	else 
	begin 
		red = 4'h0;
		green = 4'h0;
		blue = 4'h0;
	end
end

endmodule







