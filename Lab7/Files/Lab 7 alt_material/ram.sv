module ram_00 (
input  logic        RESET, AVL_READ, AVL_WRITE, AVL_CS, AVL_CLK,
input  logic [3:0]  AVL_BYTE_EN,
input  logic [9:0]  AVL_ADDR,
input  logic [31:0] AVL_WRITEDATA, 
output logic [31:0] AVL_READDATA, 
/////
input  logic        VGA_CLK,
input  logic [9:0]  VGA_ADDR,
output logic [31:0] VGA_READDATA, Control
);

logic [31:0] mem [601];


integer j;

initial
begin
	for (j = 0; j <601; j++) 
		mem[j] = i[31:0];
end



int i;
// for avalon
always_ff @(posedge AVL_CLK)
begin 
	if (RESET) 
	begin
		for (i = 0; i < 601; i = i + 1) 
		begin
			mem[i] <= 32'h0;
		end
	end	
	else if (AVL_WRITE && AVL_CS) 
	begin
		case (AVL_BYTE_EN)
				4'b1111 : 
					mem[AVL_ADDR] <= AVL_WRITEDATA;
				4'b1100 : 
				    mem[AVL_ADDR][31:16] <= AVL_WRITEDATA[31:16];
				4'b0011 : 
					mem[AVL_ADDR][15:0] <= AVL_WRITEDATA[15:0];
				4'b1000 :
					mem[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
				4'b0100 :
					mem[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
				4'b0010 :
					mem[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
				4'b0001 :
					mem[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];
				default : 
					mem[AVL_ADDR] <= 32'h0;
		endcase
	end
	else if (AVL_READ && AVL_CS) 
	begin
		AVL_READDATA <= mem[AVL_ADDR];
	end
end

// for vga
always_ff @ (posedge VGA_CLK)
begin 
	if (1)
		VGA_READDATA <= mem[VGA_ADDR];
		Control <= mem[600];
end 

endmodule 