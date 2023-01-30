/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
 
 

// tank1 ////////////////////////////////////////////////////////////////////////////////////////

module  tank0up
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/tank0up.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  tank0down
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/tank0down.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule






module  tank0left
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/tank0left.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule





module  tank0right
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/tank0right.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule









// tank2 ////////////////////////////////////////////////////////////////////////////////////////

module  tank2up
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/tank1up.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  tank2down
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/tank1down.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule






module  tank2left
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/tank1left.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule





module  tank2right
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/tank1right.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule






// bullet ////////////////////////////////////////////////////////////////////////////////////////
module  bullet_ram
(
		input Clk,
		input [3:0] read_address,
		output logic [3:0] data_Out
);

logic [3:0] mem [0:15];

initial
begin
	 $readmemh("sprite_bytes/bullet.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule




// bullet2 ////////////////////////////////////////////////////////////////////////////////////////
module  bullet_ram2
(
		input Clk,
		input [3:0] read_address,
		output logic [3:0] data_Out
);

logic [3:0] mem [0:15];

initial
begin
	 $readmemh("sprite_bytes/bullet.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule






module  iron_ram
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/iron.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule





module  hq_ram
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/hq.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  hq1_ram
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/hq_inverted.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  wall_ram
(
		input Clk,
		input [7:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:255];

initial
begin
	 $readmemh("sprite_bytes/sw.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  water_ram
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/water.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule






module  boom_ram
(
		input Clk,
		input [7:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:255];

initial
begin
	 $readmemh("sprite_bytes/boom1.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule




module  boom_ram2
(
		input Clk,
		input [7:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:255];

initial
begin
	 $readmemh("sprite_bytes/boom1.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  grass_ram
(
		input Clk,
		input [9:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/grass.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule





module  i_ram
(
		input Clk,
		input [11:0] read_address,
		output logic [2:0] data_Out
);

logic [2:0] mem [0:4095];

initial
begin
	 $readmemh("sprite_bytes/i.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule






module  gamebegin_ram
(
		input Clk,
		input [15:0] read_address,
		output logic [3:0] data_Out
);

logic [4:0] mem [0:65535];

initial
begin
	 $readmemh("sprite_bytes/gamebegin.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule






module  player1wins_ram
(
		input Clk,
		input [16:0] read_address,
		output logic [3:0] data_Out
);

logic [4:0] mem [0:131071];

initial
begin
	 $readmemh("sprite_bytes/player1wins.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule







module  player2wins_ram
(
		input Clk,
		input [16:0] read_address,
		output logic [3:0] data_Out
);

logic [4:0] mem [0:131071];

initial
begin
	 $readmemh("sprite_bytes/player2wins.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule









module  restart_ram
(
		input Clk,
		input [12:0] read_address,
		output logic  data_Out
);

logic  mem [0:8191];

initial
begin
	 $readmemh("sprite_bytes/restart.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule




module  esc_ram
(
		input Clk,
		input [15:0] read_address,
		output logic  data_Out
);

logic  mem [0:65535];

initial
begin
	 $readmemh("sprite_bytes/esc1.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



