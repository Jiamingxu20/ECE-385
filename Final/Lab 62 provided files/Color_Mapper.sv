//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

module  color_mapper ( input               Clk, frame_clk, Reset, Is_bullet_on, Is_bullet_on2, gamebegin_on, gaming_on, gameend_on, BulletHittank2, Bullet2Hittank, 
							  input  		[7:0]  keycode, keycode2, keycode3, keycode4,
							  input        [9:0]  DrawX, DrawY, 
							  input        [9:0]  BallX,  BallY,  BallS,  BulletX,  BulletY,  BulletS,  BulletX_Motion,  BulletY_Motion,
							  input        [9:0]  BallX2, BallY2, BallS2, BulletX2, BulletY2, BulletS2, BulletX_Motion2, BulletY_Motion2,
							  input               HitIron, HitWall, HitIron2, HitWall2, Player1wins, Player2wins, pause,
							  input		   [291:0][9:0] WallHitArray_out, WallHitArray_out2,
                       output logic [7:0]  Red, Green, Blue );
									  
logic ball_on, bullet_on, ball_on2, bullet_on2, hq_on, hq1_on, sw_on, iron_on, iron_on1, iron_on2, iron_on3, iron_on4, water_on, grass_on, i_on, gamebegin_on0;
logic boom_on3, boom_on4, player1wins_on, player2wins_on, restart_on, iron_on5, iron_on6, iron_on7, esc_on;
logic [9:0] iron_size, sw_size;
int DistX, DistY, Size, DistX2, DistY2, Size2;
assign DistX = DrawX - BulletX;
assign DistY = DrawY - BulletY;
assign Size = BulletS;
assign DistX2 = DrawX - BulletX2;
assign DistY2 = DrawY - BulletY2;
assign Size2 = BulletS2;
assign iron_size = 16;
assign sw_size = 8;



// Tank ////////////////////////////////////////////////////////////////////////////////////

// tank up
logic [9:0] tank0up_read_address;
logic [2:0] tank0up_data_out;
logic [23:0] RGBtank0up;
assign tank0up_read_address = (DrawX - (BallX - 10'h10)) + 32*(DrawY - (BallY - 10'h10));

tank0up tank0up (.Clk(Clk), .read_address(tank0up_read_address), .data_Out(tank0up_data_out));

always_comb 
begin
	case(tank0up_data_out)
		3'h0:RGBtank0up = 24'h230E0E;
		3'h1:RGBtank0up = 24'hFFA044;
		3'h2:RGBtank0up = 24'hAF7F03;
		3'h3:RGBtank0up = 24'hAC7C00;
		3'h4:RGBtank0up = 24'hF8D878;
		default:RGBtank0up = 24'hFFFFFF;
	endcase
end

// tank down 	 
logic [9:0] tank0down_read_address;
logic [2:0] tank0down_data_out;
logic [23:0] RGBtank0down;
assign tank0down_read_address = (DrawX - (BallX - 10'h10)) + 32*(DrawY - (BallY - 10'h10));

tank0down tank0down (.Clk(Clk), .read_address(tank0down_read_address), .data_Out(tank0down_data_out));

always_comb 
begin
	case(tank0down_data_out)
		3'h0:RGBtank0down = 24'h230E0E;
		3'h1:RGBtank0down = 24'hFFA044;
		3'h2:RGBtank0down = 24'hAF7F03;
		3'h3:RGBtank0down = 24'hAC7C00;
		3'h4:RGBtank0down = 24'hF8D878;
		default:RGBtank0down = 24'hFFFFFF;
	endcase
end
	 

// tank left
logic [9:0] tank0left_read_address;
logic [2:0] tank0left_data_out;
logic [23:0] RGBtank0left;
assign tank0left_read_address = (DrawX - (BallX - 10'h10)) + 32*(DrawY - (BallY - 10'h10));

tank0left tank0left (.Clk(Clk), .read_address(tank0left_read_address), .data_Out(tank0left_data_out));

always_comb 
begin
	case(tank0left_data_out)
		3'h0:RGBtank0left = 24'h230E0E;
		3'h1:RGBtank0left = 24'hFFA044;
		3'h2:RGBtank0left = 24'hAF7F03;
		3'h3:RGBtank0left = 24'hAC7C00;
		3'h4:RGBtank0left = 24'hF8D878;
		default:RGBtank0left = 24'hFFFFFF;
	endcase
end

// tank right 	 
logic [9:0] tank0right_read_address;
logic [2:0] tank0right_data_out;
logic [23:0] RGBtank0right;
assign tank0right_read_address = (DrawX - (BallX - 10'h10)) + 32*(DrawY - (BallY - 10'h10));

tank0right tank0right (.Clk(Clk), .read_address(tank0right_read_address), .data_Out(tank0right_data_out));

always_comb 
begin
	case(tank0right_data_out)
		3'h0:RGBtank0right = 24'h230E0E;
		3'h1:RGBtank0right = 24'hFFA044;
		3'h2:RGBtank0right = 24'hAF7F03;
		3'h3:RGBtank0right = 24'hAC7C00;
		3'h4:RGBtank0right = 24'hF8D878;
		default:RGBtank0right = 24'hFFFFFF;
	endcase
end


logic [2:0] Direct;
always_ff @ (posedge Reset or posedge Clk )
begin
	if (Reset)
		Direct <= 3'b011;
	else if (gaming_on)
		begin
			if (keycode == 8'h04 || keycode2 == 8'h04 || keycode3 == 8'h04 || keycode4 == 8'h04)    //A
				Direct <= 3'b000;
			else if (keycode == 8'h07 || keycode2 == 8'h07 || keycode3 == 8'h07 || keycode4 == 8'h07)	   //D
				Direct <= 3'b001;
			else if (keycode == 8'h16 || keycode2 == 8'h16 || keycode3 == 8'h16 || keycode4 == 8'h16)    //S
				Direct <= 3'b010;
			else if (keycode == 8'h1A || keycode2 == 8'h1A || keycode3 == 8'h1A || keycode4 == 8'h1A)    //W
				Direct <= 3'b011;
			else 
				Direct <= Direct;
		end
end

always_comb
begin:Ball_on_proc
	if ((DrawX >= BallX - BallS) &&
	(DrawX <= BallX + BallS) &&
	(DrawY >= BallY - BallS) &&
	(DrawY <= BallY + BallS))
		ball_on = 1'b1;
	else 
		ball_on = 1'b0;
end












// Tank2 ////////////////////////////////////////////////////////////////////////////////////
	 
// tank2 up
logic [9:0] tank2up_read_address;
logic [2:0] tank2up_data_out;
logic [23:0] RGBtank2up;
assign tank2up_read_address = (DrawX - (BallX2 - 10'h10)) + 32*(DrawY - (BallY2 - 10'h10));

tank2up tank2up (.Clk(Clk), .read_address(tank2up_read_address), .data_Out(tank2up_data_out));

always_comb 
begin
	case(tank2up_data_out)
		3'h0:RGBtank2up = 24'h230E0E;
		3'h1:RGBtank2up = 24'hacfaf6;
		3'h2:RGBtank2up = 24'h018528;
		3'h3:RGBtank2up = 24'h0a560e;
		3'h4:RGBtank2up = 24'h75d7ad;
		default:RGBtank2up = 24'hFFFFFF;
	endcase
end

// tank2 down 	 
logic [9:0] tank2down_read_address;
logic [2:0] tank2down_data_out;
logic [23:0] RGBtank2down;
assign tank2down_read_address = (DrawX - (BallX2 - 10'h10)) + 32*(DrawY - (BallY2 - 10'h10));

tank2down tank2down (.Clk(Clk), .read_address(tank2down_read_address), .data_Out(tank2down_data_out));

always_comb 
begin
	case(tank2down_data_out)
		3'h0:RGBtank2down = 24'h230E0E;
		3'h1:RGBtank2down = 24'hacfaf6;
		3'h2:RGBtank2down = 24'h018528;
		3'h3:RGBtank2down= 24'h0a560e;
		3'h4:RGBtank2down = 24'h75d7ad;
		default:RGBtank2down = 24'hFFFFFF;
	endcase
end
	 

// tank2 left
logic [9:0] tank2left_read_address;
logic [2:0] tank2left_data_out;
logic [23:0] RGBtank2left;
assign tank2left_read_address = (DrawX - (BallX2 - 10'h10)) + 32*(DrawY - (BallY2 - 10'h10));

tank2left tank2left (.Clk(Clk), .read_address(tank2left_read_address), .data_Out(tank2left_data_out));

always_comb 
begin
	case(tank2left_data_out)
		3'h0:RGBtank2left = 24'h230E0E;
		3'h1:RGBtank2left = 24'hacfaf6;
		3'h2:RGBtank2left = 24'h018528;
		3'h3:RGBtank2left = 24'h0a560e;
		3'h4:RGBtank2left = 24'h75d7ad;
		default:RGBtank2left = 24'hFFFFFF;
	endcase
end

// tank2 right 	 
logic [9:0] tank2right_read_address;
logic [2:0] tank2right_data_out;
logic [23:0] RGBtank2right;
assign tank2right_read_address = (DrawX - (BallX2 - 10'h10)) + 32*(DrawY - (BallY2 - 10'h10));

tank2right tank2right (.Clk(Clk), .read_address(tank2right_read_address), .data_Out(tank2right_data_out));

always_comb 
begin
	case(tank2right_data_out)
		3'h0:RGBtank2right = 24'h230E0E;
		3'h1:RGBtank2right = 24'hacfaf6;
		3'h2:RGBtank2right = 24'h018528;
		3'h3:RGBtank2right = 24'h0a560e;
		3'h4:RGBtank2right = 24'h75d7ad;
		default:RGBtank2right = 24'hFFFFFF;
	endcase
end


logic [2:0] Direct2;
always_ff @ (posedge Reset or posedge Clk )
begin
	if (Reset)
		Direct2 <= 3'b010;
	else if (gaming_on)
		begin
			if (keycode == 8'h50 || keycode2 == 8'h50 || keycode3 == 8'h50 || keycode4 == 8'h50)    //A
				Direct2 <= 3'b000;
			else if (keycode == 8'h4F || keycode2 == 8'h4F || keycode3 == 8'h4F || keycode4 == 8'h4F)	   //D
				Direct2 <= 3'b001;
			else if (keycode == 8'h51 || keycode2 == 8'h51 || keycode3 == 8'h51 || keycode4 == 8'h51)    //S
				Direct2 <= 3'b010;
			else if (keycode == 8'h52 || keycode2 == 8'h52 || keycode3 == 8'h52 || keycode4 == 8'h52)    //W
				Direct2 <= 3'b011;
			else 
				Direct2 <= Direct2;
		end
end





always_comb
begin:Ball_on_proc2
	if ((DrawX >= BallX2 - BallS2) &&
	(DrawX <= BallX2 + BallS2) &&
	(DrawY >= BallY2 - BallS2) &&
	(DrawY <= BallY2 + BallS2))
		ball_on2 = 1'b1;
	else 
		ball_on2 = 1'b0;
end





	 	 
	 
// bullet ////////////////////////////////////////////////////////////////////////////////////
logic [3:0] bullet_read_address;
logic [3:0] bullet_data_out;
logic [23:0] RGBbullet;
assign bullet_read_address = (DrawX - (BulletX - 10'h2)) + 4*(DrawY - (BulletY - 10'h2));

bullet_ram bullet_ram (.Clk(Clk), .read_address(bullet_read_address), .data_Out(bullet_data_out));

always_comb 
begin
	case(bullet_data_out)
		4'h0:RGBbullet = 24'h000000;
		4'h1:RGBbullet = 24'hCD8734;
		4'h2:RGBbullet = 24'hB94308;
		4'h3:RGBbullet = 24'hDAA64D;
		4'h4:RGBbullet = 24'hE7CA72;
		4'h5:RGBbullet = 24'hFFFFC9;
		4'h6:RGBbullet = 24'hC16018;
		4'h7:RGBbullet = 24'hBB480B;
		4'h8:RGBbullet = 24'hBF5713;
		default:RGBbullet = 24'hFFFFFF;
	endcase
end

always_comb
begin:Bullet_on_proc
	if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
		bullet_on = 1'b1;
	else 
		bullet_on = 1'b0;
end




// bullet2 ////////////////////////////////////////////////////////////////////////////////////
logic [3:0] bullet_read_address2;
logic [3:0] bullet_data_out2;
logic [23:0] RGBbullet2;
assign bullet_read_address2 = (DrawX - (BulletX2 - 10'h2)) + 4*(DrawY - (BulletY2 - 10'h2));

bullet_ram2 bullet_ram2 (.Clk(Clk), .read_address(bullet_read_address2), .data_Out(bullet_data_out2));

always_comb 
begin
	case(bullet_data_out2)
		4'h0:RGBbullet2 = 24'h000000;
		4'h1:RGBbullet2 = 24'hCD8734;
		4'h2:RGBbullet2 = 24'hB94308;
		4'h3:RGBbullet2 = 24'hDAA64D;
		4'h4:RGBbullet2 = 24'hE7CA72;
		4'h5:RGBbullet2 = 24'hFFFFC9;
		4'h6:RGBbullet2 = 24'hC16018;
		4'h7:RGBbullet2 = 24'hBB480B;
		4'h8:RGBbullet2 = 24'hBF5713;
		default:RGBbullet2 = 24'hFFFFFF;
	endcase
end

always_comb
begin:Bullet_on_proc2
	if ( ( DistX2*DistX2 + DistY2*DistY2) <= (Size2 * Size2) ) 
		bullet_on2 = 1'b1;
	else 
		bullet_on2 = 1'b0;
end






// wall ////////////////////////////////////////////////////////////////////////////////////

parameter [9:0] wallX=294;  // Center position on the X axis
parameter [9:0] wallY=471;  // Center position on the Y axis
parameter [9:0] WallSize = 292;
parameter [9:0] WallBlockSize = 8;

logic wall_on;
logic [7:0] wall_read_address;
logic [2:0] wall_data_out;
logic [23:0] RGBwall;
logic [WallSize-1:0][9:0] WallXarray, WallYarray;
logic [WallSize-1:0] Wallcheck;

assign wall_read_address = (DrawX - (wallX - 10'h8)) + 16*(DrawY - (wallY - 10'h8));

wall_ram wall_ram (.Clk(Clk), .read_address(wall_read_address), .data_Out(wall_data_out));

always_comb 
begin
	case(wall_data_out)
		3'h0:RGBwall = 24'h000000;
		3'h1:RGBwall = 24'hbc7200;
		3'h2:RGBwall = 24'h748481;
		3'h3:RGBwall = 24'ha43101;
		3'h4:RGBwall = 24'ha43102;
		default:RGBwall = 24'hFFFFFF;
	endcase
end


assign WallXarray = '{294, 294, 294, 310, 326, 342, 342, 342, 8,   24,  8,   24,
							 631, 615, 599, 583, 631, 615, 599, 583, 599, 599, 599, 599, 599, 599, 583, 583, 583, 583, 583, 583,
							 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 503, 487, 503, 487,
							 631, 615, 631, 615, 631, 631, 182, 182, 197, 197, 213, 213, 229, 229, 182, 182, 197, 197, 213, 213, 229, 229,
							 40, 40, 56, 56, 40, 40, 56, 56, 8, 8, 24, 24, 8, 8, 24, 24, 40, 40, 56, 56, 72, 72, 88, 88,  //108 so far
							 72,  72,  72,  72,  72,  72,  72,  72,  72,  72,  88,  88,  88,  88,  88,  88,  88,  88,  88,  88,  //128 so far
							 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 152, 152, 152, 152, 152, 152, 152, 152, 152, 152, //148 so far
							 343, 343, 343, 343, 343, 343, 343, 343, 359, 359, 359, 359, 359, 359, 359, 359,
							 488, 488, 488, 488, 488, 488, 488, 488, 504, 504, 504, 504, 504, 504, 504, 504, // 184 so far
							 424, 424, 424, 424, 424, 424, 440, 440, 440, 440, 440, 440, // 192 so far
							 392, 392, 392, 392, 392, 392, 408, 408, 408, 408, 408, 408,
							 200, 200, 200, 200, 200, 200, 216, 216, 216, 216, 216, 216, // 216
							 200, 200, 200, 200, 200, 200, 216, 216, 216, 216, 216, 216, // 228
							 200, 200, 200, 200, 216, 216, 216, 216, // 236 
							 488, 488, 488, 488, 488, 488, 504, 504, 504, 504, 504, 504,
							 568, 552, 536, 520, 568, 552, 536, 520, //256
							 104, 120, 104, 120, 104, 120, 104, 120, //264
							 584, 600, 584, 600, 568, 552, 568, 552, //272
							 568, 568, 568, 568, 552, 552, 552, 552, // 280
							 343, 359, 343, 359, 295, 295, 295, 343, 343, 343, 327, 311, 343, 359};
// 351, 368
assign WallYarray = '{471, 455, 439, 439, 439, 439, 455, 471, 327, 327, 343, 343,
							 88,  88,  88,  88,  72,  72,  72,  72,  104, 120, 136, 152, 168, 184, 104, 120, 136, 152, 168, 184, 
							 280, 280, 264, 264, 312, 312, 296, 296, 152, 152, 136, 136, 184, 184, 168, 168, 216, 216, 200, 200, 248, 248, 232, 232, 136, 136, 152, 152,
							 440, 440, 424, 424, 408, 392, 201, 217, 201, 217, 201, 217, 201, 217, 233, 249, 233, 249, 233, 249, 233, 249,
							 8, 23, 8, 23, 39, 55, 39, 55, 102, 118, 102, 118, 134, 150, 134, 150, 134, 150, 134, 150, 134, 150, 134, 150, //108 so far
							 327, 343, 359, 375, 391, 407, 423, 439, 455, 471, 327, 343, 359, 375, 391, 407, 423, 439, 455, 471,   
							 327, 343, 359, 375, 391, 407, 423, 439, 455, 471, 327, 343, 359, 375, 391, 407, 423, 439, 455, 471, 
							 354, 338, 322, 306, 290, 274, 258, 242, 354, 338, 322, 306, 290, 274, 258, 242,
							 359, 375, 391, 407, 423, 439, 455, 471, 359, 375, 391, 407, 423, 439, 455, 471, 
							 391, 407, 423, 439, 455, 471, 391, 407, 423, 439, 455, 471,
							 8,   24,  40,  56,  72,  88,  8,   24,  40,  56,  72,  88,
							 8,   24,  40,  56,  72,  88,  8,   24,  40,  56,  72,  88,
							 472, 456, 440, 424, 408, 392, 472, 456, 440, 424, 408, 392, 
							 472, 456, 440, 424, 472, 456, 440, 424, 
							 8,   24,  40,  56,  72,  88,  8,   24,  40,  56,  72,  88,
							 72,  72,  72,  72,  88,  88,  88,  88,
							 472, 472, 456, 456, 440, 440, 423, 423,
							 423, 423, 440, 440, 423, 423, 440, 440,
							 408, 392, 376, 360, 408, 392, 376, 360,
							 376, 376, 392, 392, 8,   24,  40,  8,   24,  40,  40,  40, 370, 370};



always_comb
begin
	for (int i = 0; i < WallSize; i++)
	begin
		if ((DrawX >= WallXarray[i] - WallBlockSize) &&
		 (DrawX <= WallXarray[i] + WallBlockSize) &&
		 (DrawY >= WallYarray[i] - WallBlockSize) &&
		 (DrawY <= WallYarray[i] + WallBlockSize))
			begin
				if (WallHitArray_out[i] || WallHitArray_out2[i])
					Wallcheck[i] = 0;
				else 
					Wallcheck[i] = 1;
			end
		else 
			Wallcheck[i] = 0;
	end
	
	for (int i = 0; i < WallSize; i++)
	begin
		if (i == 0)
			wall_on = Wallcheck[0];
		else 
			wall_on = wall_on || Wallcheck[i];
	end
end

















// boom ////////////////////////////////////////////////////////////////////////////////////
logic [7:0] boom_read_address;
logic [2:0] boom_data_out;
logic [23:0] RGBboom;

assign boom_read_address = (DrawX - (BulletX - 10'h8)) + 16*(DrawY - (BulletY - 10'h8));

boom_ram boom_ram (.Clk(Clk), .read_address(boom_read_address), .data_Out(boom_data_out));

always_comb 
begin
	case(boom_data_out)
		3'h0:RGBboom = 24'h230E0E;
		3'h1:RGBboom = 24'hfff5fd;
		3'h2:RGBboom = 24'h630071;
		3'h3:RGBboom = 24'hb20e0c;
		3'h4:RGBboom = 24'h833f8a;
		default:RGBboom = 24'hFFFFFF;
	endcase
end



logic [7:0] boom_read_address2;
logic [2:0] boom_data_out2;
logic [23:0] RGBboom2;

assign boom_read_address2 = (DrawX - (BulletX2 - 10'h8)) + 16*(DrawY - (BulletY2 - 10'h8));

boom_ram2 boom_ram2 (.Clk(Clk), .read_address(boom_read_address2), .data_Out(boom_data_out2));

always_comb 
begin
	case(boom_data_out2)
		3'h0:RGBboom2 = 24'h230E0E;
		3'h1:RGBboom2 = 24'hfff5fd;
		3'h2:RGBboom2 = 24'h630071;
		3'h3:RGBboom2 = 24'hb20e0c;
		3'h4:RGBboom2 = 24'h833f8a;
		default:RGBboom2 = 24'hFFFFFF;
	endcase
end




parameter [9:0] IronSize_col= 21;
parameter [9:0] IronBlockWidth_col = 16;
parameter [9:0] WallBlockWidth = 8;
parameter [9:0] bullethit_size = 1;
parameter [9:0] drawingsize = 8;

logic [IronSize_col-1:0][9:0] IronXarray_col, IronYarray_col;

logic Col_iron, Col_wall, boom_on, boommmmm;
logic [IronSize_col-1:0] BulletHitIron_col;
logic [WallSize-1:0] BulletHitWall_col;


logic Col_iron2, Col_wall2, boom_on2, boommmmm2;
logic [IronSize_col-1:0] BulletHitIron_col2;
logic [WallSize-1:0] BulletHitWall_col2;

assign IronXarray_col = '{16,  48,  80,  80,  559, 527, 144, 177, 432, 432, 432, 287, 351, 319, 287, 351, 319, 464, 528, 528, 240};

assign IronYarray_col = '{271, 271, 271, 303, 144, 144, 80,  80,  240, 272, 304,  80,  80,  80, 400, 400, 400, 464, 16,  48, 464};



always_comb
begin 
	for (int i = 0; i < IronSize_col; i++)
	begin
		if ((BulletX + BulletX_Motion + bullethit_size >= IronXarray_col[i] - IronBlockWidth_col)
		&& (BulletX + BulletX_Motion - bullethit_size <= IronXarray_col[i] + IronBlockWidth_col)
		&& (BulletY + BulletY_Motion + bullethit_size >= IronYarray_col[i] - IronBlockWidth_col)
		&& (BulletY + BulletY_Motion - bullethit_size <= IronYarray_col[i] + IronBlockWidth_col))
			BulletHitIron_col[i] = 1;
		else
			BulletHitIron_col[i] = 0;
	end
end 

always_comb
begin 
	for (int i = 0; i < IronSize_col; i++)
	begin
		if ((BulletX2 + BulletX_Motion2 + bullethit_size >= IronXarray_col[i] - IronBlockWidth_col)
		&& (BulletX2 + BulletX_Motion2 - bullethit_size <= IronXarray_col[i] + IronBlockWidth_col)
		&& (BulletY2 + BulletY_Motion2 + bullethit_size >= IronYarray_col[i] - IronBlockWidth_col)
		&& (BulletY2 + BulletY_Motion2 - bullethit_size <= IronYarray_col[i] + IronBlockWidth_col))
			BulletHitIron_col2[i] = 1;
		else
			BulletHitIron_col2[i] = 0;
	end
end



// boom1
always_comb
begin 
	for (int i = 0; i < WallSize; i++)
	begin
		if ((BulletX + BulletX_Motion + bullethit_size >= WallXarray[i] - WallBlockWidth)
		&& (BulletX + BulletX_Motion - bullethit_size <= WallXarray[i] + WallBlockWidth)
		&& (BulletY + BulletY_Motion + bullethit_size >= WallYarray[i] - WallBlockWidth)
		&& (BulletY + BulletY_Motion - bullethit_size <= WallYarray[i] + WallBlockWidth))
			begin 
				if (WallHitArray_out[i])
					BulletHitWall_col[i] = 0;
				else
					BulletHitWall_col[i] = 1;
			end 
		else
			BulletHitWall_col[i] = 0;
	end
end 

always_comb
begin
	for (int i = 0; i < IronSize_col; i++)
	begin
		if (i == 0)
			Col_iron = BulletHitIron_col[0];
		else 
			Col_iron = Col_iron || BulletHitIron_col[i];
	end
	
	for (int i = 0; i < WallSize; i++)
	begin
		if (i == 0)
			Col_wall = BulletHitWall_col[0];
		else 
			Col_wall = Col_wall || BulletHitWall_col[i];
	end
	
end


assign boommmmm = Col_wall || Col_iron;

always_comb
begin:Boom_on_proc
	if (((DrawX >= BulletX - drawingsize) &&
	(DrawX <= BulletX + drawingsize) &&
	(DrawY >= BulletY - drawingsize) &&
	(DrawY <= BulletY + drawingsize))  && boommmmm)
		boom_on = 1'b1;
	else 
		boom_on = 1'b0;
end





// boom2
always_comb
begin 
	for (int i = 0; i < WallSize; i++)
	begin
		if ((BulletX2 + BulletX_Motion2 + bullethit_size >= WallXarray[i] - WallBlockWidth)
		&& (BulletX2 + BulletX_Motion2 - bullethit_size <= WallXarray[i] + WallBlockWidth)
		&& (BulletY2 + BulletY_Motion2 + bullethit_size >= WallYarray[i] - WallBlockWidth)
		&& (BulletY2 + BulletY_Motion2 - bullethit_size <= WallYarray[i] + WallBlockWidth))
			begin 
				if (WallHitArray_out2[i])
					BulletHitWall_col2[i] = 0;
				else
					BulletHitWall_col2[i] = 1;
			end 
		else
			BulletHitWall_col2[i] = 0;
	end
end 

always_comb
begin
	for (int i = 0; i < IronSize_col; i++)
	begin
		if (i == 0)
			Col_iron2 = BulletHitIron_col2[0];
		else 
			Col_iron2 = Col_iron2 || BulletHitIron_col2[i];
	end
	
	for (int i = 0; i < WallSize; i++)
	begin
		if (i == 0)
			Col_wall2 = BulletHitWall_col2[0];
		else 
			Col_wall2 = Col_wall2 || BulletHitWall_col2[i];
	end
	
end


assign boommmmm2 = Col_wall2 || Col_iron2;


always_comb
begin:Boom_on_proc2
	if (((DrawX >= BulletX2 - drawingsize) &&
	(DrawX <= BulletX2 + drawingsize) &&
	(DrawY >= BulletY2 - drawingsize) &&
	(DrawY <= BulletY2 + drawingsize))  && boommmmm2)
		boom_on2 = 1'b1;
	else 
		boom_on2 = 1'b0;
end






// boom3 BulletHittank2

logic [7:0] boom_read_address3;
logic [2:0] boom_data_out3;
logic [23:0] RGBboom3;

assign boom_read_address3 = (DrawX - (BulletX - 10'h8)) + 16*(DrawY - (BulletY - 10'h8));

boom_ram boom_ram3 (.Clk(Clk), .read_address(boom_read_address3), .data_Out(boom_data_out3));

always_comb 
begin
	case(boom_data_out3)
		3'h0:RGBboom3 = 24'h230E0E;
		3'h1:RGBboom3 = 24'hfff5fd;
		3'h2:RGBboom3 = 24'h630071;
		3'h3:RGBboom3 = 24'hb20e0c;
		3'h4:RGBboom3 = 24'h833f8a;
		default:RGBboom3 = 24'hFFFFFF;
	endcase
end

always_comb
begin:Boom_on_proc3
	if ((DrawX >= BulletX - drawingsize) &&
	(DrawX <= BulletX + drawingsize) &&
	(DrawY >= BulletY - drawingsize) &&
	(DrawY <= BulletY + drawingsize))
		boom_on3 = 1'b1;
	else 
		boom_on3 = 1'b0;
end




// boom4 Bullet2Hittank

logic [7:0] boom_read_address4;
logic [2:0] boom_data_out4;
logic [23:0] RGBboom4;

assign boom_read_address4 = (DrawX - (BulletX2 - 10'h8)) + 16*(DrawY - (BulletY2 - 10'h8));

boom_ram boom_ram4 (.Clk(Clk), .read_address(boom_read_address4), .data_Out(boom_data_out4));

always_comb 
begin
	case(boom_data_out4)
		3'h0:RGBboom4 = 24'h230E0E;
		3'h1:RGBboom4 = 24'hfff5fd;
		3'h2:RGBboom4 = 24'h630071;
		3'h3:RGBboom4 = 24'hb20e0c;
		3'h4:RGBboom4 = 24'h833f8a;
		default:RGBboom4 = 24'hFFFFFF;
	endcase
end

always_comb
begin:Boom_on_proc4
	if ((DrawX >= BulletX2 - drawingsize) &&
	(DrawX <= BulletX2 + drawingsize) &&
	(DrawY >= BulletY2 - drawingsize) &&
	(DrawY <= BulletY2 + drawingsize))
		boom_on4 = 1'b1;
	else 
		boom_on4 = 1'b0;
end



parameter [9:0] Bullet_X_Min=0;       // Leftmost point on the X axis
parameter [9:0] Bullet_X_Max=639;     // Rightmost point on the X axis
parameter [9:0] Bullet_Y_Min=0;       // Topmost point on the Y axis
parameter [9:0] Bullet_Y_Max=479;     // Bottommost point on the Y axis

parameter [9:0] Bsize=6;     // Bottommost point on the Y axis

// boom bullethitboundary

logic BulletHitBoundary, BulletHitBoundary2;

assign BulletHitBoundary = ((BulletX + BulletX_Motion) <= (Bullet_X_Min + Bsize))
									|| ((BulletX + BulletX_Motion) >= (Bullet_X_Max - Bsize))
									|| ((BulletY + BulletY_Motion) >= (Bullet_Y_Max - Bsize))
									|| ((BulletY + BulletY_Motion) <= (Bullet_Y_Min + Bsize));




assign BulletHitBoundary2 = ((BulletX2 + BulletX_Motion2) <= (Bullet_X_Min + Bsize))
									|| ((BulletX2 + BulletX_Motion2) >= (Bullet_X_Max - Bsize))
									|| ((BulletY2 + BulletY_Motion2) >= (Bullet_Y_Max - Bsize))
									|| ((BulletY2 + BulletY_Motion2) <= (Bullet_Y_Min + Bsize));














// iron ////////////////////////////////////////////////////////////////////////////////////
logic [9:0] iron_read_address, iron_read_address1, iron_read_address2, iron_read_address3, iron_read_address4, iron_read_address5, iron_read_address6, iron_read_address7;
logic [2:0] iron_data_out, iron_data_out1, iron_data_out2, iron_data_out3, iron_data_out4, iron_data_out5, iron_data_out6, iron_data_out7;
logic [23:0] RGBiron, RGBiron1, RGBiron2, RGBiron3, RGBiron4, RGBiron5, RGBiron6, RGBiron7;
	 
parameter [9:0] IronX=16;  // Center position on the X axis
parameter [9:0] IronY=271;  // Center position on the Y axis

parameter [9:0] IronX1=432;  // Center position on the X axis
parameter [9:0] IronY1=272;  // Center position on the Y axis

parameter [9:0] IronX2=319;  // Center position on the X axis
parameter [9:0] IronY2=80;  // Center position on the Y axis

parameter [9:0] IronX3=319;  // Center position on the X axis
parameter [9:0] IronY3=400;  // Center position on the Y axis

parameter [9:0] IronX4=240;  // Center position on the X axis
parameter [9:0] IronY4=464;  // Center position on the Y axis

parameter [9:0] IronX5=144;  // Center position on the X axis
parameter [9:0] IronY5=80;  // Center position on the Y axis

parameter [9:0] IronX6=528;  // Center position on the X axis
parameter [9:0] IronY6=16;  // Center position on the Y axis

parameter [9:0] IronX7=464;  // Center position on the X axis
parameter [9:0] IronY7=464;  // Center position on the Y axis







assign iron_read_address = (DrawX - (IronX + 32 - 10'h10)) + 32*(DrawY - (IronY + 32 - 10'h10));

iron_ram iron_ram (.Clk(Clk), .read_address(iron_read_address), .data_Out(iron_data_out));


assign iron_read_address1 = (DrawX - (IronX1 + 32 - 10'h10)) + 32*(DrawY - (IronY1 + 32 - 10'h10));

iron_ram iron_ram1 (.Clk(Clk), .read_address(iron_read_address1), .data_Out(iron_data_out1));


assign iron_read_address2 = (DrawX - (IronX2 - 10'h10)) + 32*(DrawY - (IronY2 - 10'h10));

iron_ram iron_ram2 (.Clk(Clk), .read_address(iron_read_address2), .data_Out(iron_data_out2));


assign iron_read_address3 = (DrawX - (IronX3 - 10'h10)) + 32*(DrawY - (IronY3 - 10'h10));

iron_ram iron_ram3 (.Clk(Clk), .read_address(iron_read_address3), .data_Out(iron_data_out3));


assign iron_read_address4 = (DrawX - (IronX4 - 10'h10)) + 32*(DrawY - (IronY4 - 10'h10));

iron_ram iron_ram4 (.Clk(Clk), .read_address(iron_read_address4), .data_Out(iron_data_out4));


assign iron_read_address5 = (DrawX - (IronX5 - 10'h10)) + 32*(DrawY - (IronY5 - 10'h10));

iron_ram iron_ram5 (.Clk(Clk), .read_address(iron_read_address5), .data_Out(iron_data_out5));


assign iron_read_address6 = (DrawX - (IronX6 - 10'h10)) + 32*(DrawY - (IronY6 - 10'h10));

iron_ram iron_ram6 (.Clk(Clk), .read_address(iron_read_address6), .data_Out(iron_data_out6));


assign iron_read_address7 = (DrawX - (IronX7 - 10'h10)) + 32*(DrawY - (IronY7 - 10'h10));

iron_ram iron_ram7 (.Clk(Clk), .read_address(iron_read_address7), .data_Out(iron_data_out7));




always_comb 
begin
	case(iron_data_out)
		3'h0:RGBiron = 24'h000000;
		3'h1:RGBiron = 24'hF7F7F7;
		3'h2:RGBiron = 24'h6D6D6D;
		3'h3:RGBiron = 24'h898989;
		3'h4:RGBiron = 24'hADADAD;
		default:RGBiron = 24'hFFFFFF;
	endcase
	
	case(iron_data_out1)
		3'h0:RGBiron1 = 24'h000000;
		3'h1:RGBiron1 = 24'hF7F7F7;
		3'h2:RGBiron1 = 24'h6D6D6D;
		3'h3:RGBiron1 = 24'h898989;
		3'h4:RGBiron1 = 24'hADADAD;
		default:RGBiron1 = 24'hFFFFFF;
	endcase
	
	case(iron_data_out2)
		3'h0:RGBiron2 = 24'h000000;
		3'h1:RGBiron2 = 24'hF7F7F7;
		3'h2:RGBiron2 = 24'h6D6D6D;
		3'h3:RGBiron2 = 24'h898989;
		3'h4:RGBiron2 = 24'hADADAD;
		default:RGBiron2 = 24'hFFFFFF;
	endcase
	
	case(iron_data_out3)
		3'h0:RGBiron3 = 24'h000000;
		3'h1:RGBiron3 = 24'hF7F7F7;
		3'h2:RGBiron3 = 24'h6D6D6D;
		3'h3:RGBiron3 = 24'h898989;
		3'h4:RGBiron3 = 24'hADADAD;
		default:RGBiron3 = 24'hFFFFFF;
	endcase
	
	case(iron_data_out4)
		3'h0:RGBiron4 = 24'h000000;
		3'h1:RGBiron4 = 24'hF7F7F7;
		3'h2:RGBiron4 = 24'h6D6D6D;
		3'h3:RGBiron4 = 24'h898989;
		3'h4:RGBiron4 = 24'hADADAD;
		default:RGBiron4 = 24'hFFFFFF;
	endcase
	
	
	case(iron_data_out5)
		3'h0:RGBiron5 = 24'h000000;
		3'h1:RGBiron5 = 24'hF7F7F7;
		3'h2:RGBiron5 = 24'h6D6D6D;
		3'h3:RGBiron5 = 24'h898989;
		3'h4:RGBiron5 = 24'hADADAD;
		default:RGBiron5 = 24'hFFFFFF;
	endcase
	
	
	case(iron_data_out6)
		3'h0:RGBiron6 = 24'h000000;
		3'h1:RGBiron6 = 24'hF7F7F7;
		3'h2:RGBiron6 = 24'h6D6D6D;
		3'h3:RGBiron6 = 24'h898989;
		3'h4:RGBiron6 = 24'hADADAD;
		default:RGBiron6 = 24'hFFFFFF;
	endcase
	
	
	case(iron_data_out7)
		3'h0:RGBiron7 = 24'h000000;
		3'h1:RGBiron7 = 24'hF7F7F7;
		3'h2:RGBiron7 = 24'h6D6D6D;
		3'h3:RGBiron7 = 24'h898989;
		3'h4:RGBiron7 = 24'hADADAD;
		default:RGBiron7 = 24'hFFFFFF;
	endcase	
	
end


parameter [9:0] IronSize = 6;
parameter [9:0] IronSize1 = 3;
parameter [9:0] IronSize2 = 3;
parameter [9:0] IronSize3 = 3;
parameter [9:0] IronSize4 = 1;
parameter [9:0] IronSize5 = 2;
parameter [9:0] IronSize6 = 2;
parameter [9:0] IronSize7 = 1;


parameter [9:0] IronBlockWidth = 16;

logic [IronSize-1:0][9:0] IronXarray, IronYarray; 
logic [IronSize1-1:0][9:0] IronXarray1, IronYarray1; 
logic [IronSize2-1:0][9:0] IronXarray2, IronYarray2; 
logic [IronSize3-1:0][9:0] IronXarray3, IronYarray3;
logic [IronSize4-1:0][9:0] IronXarray4, IronYarray4;
logic [IronSize5-1:0][9:0] IronXarray5, IronYarray5;
logic [IronSize6-1:0][9:0] IronXarray6, IronYarray6;
logic [IronSize7-1:0][9:0] IronXarray7, IronYarray7;


logic [IronSize-1:0] Ironcheck;
logic [IronSize1-1:0] Ironcheck1;
logic [IronSize2-1:0] Ironcheck2;
logic [IronSize3-1:0] Ironcheck3;
logic [IronSize4-1:0] Ironcheck4;
logic [IronSize5-1:0] Ironcheck5;
logic [IronSize6-1:0] Ironcheck6;
logic [IronSize7-1:0] Ironcheck7;



assign IronXarray = '{16,  48,  80,  80,  559, 527};
assign IronYarray = '{271, 271, 271, 303, 144, 144};

assign IronXarray1 = '{432, 432, 432};
assign IronYarray1 = '{240, 272, 304};

assign IronXarray2 = '{287, 351, 319};
assign IronYarray2 = '{80,  80,  80};

assign IronXarray3 = '{287, 351, 319};
assign IronYarray3 = '{400, 400, 400};

assign IronXarray4 = '{240};
assign IronYarray4 = '{464};

assign IronXarray5 = '{144, 177};
assign IronYarray5 = '{80,  80 };

assign IronXarray6 = '{528, 528};
assign IronYarray6 = '{16,  48};

assign IronXarray7 = '{464};
assign IronYarray7 = '{464};


always_comb
begin
	for (int i = 0; i < IronSize; i++)
	begin
		if ((DrawX >= IronXarray[i] - IronBlockWidth) &&
		 (DrawX <= IronXarray[i] + IronBlockWidth) &&
		 (DrawY >= IronYarray[i] - IronBlockWidth) &&
		 (DrawY <= IronYarray[i] + IronBlockWidth))
			Ironcheck[i] = 1;
		else 
			Ironcheck[i] = 0;
	end
	
	for (int i = 0; i < IronSize; i++)
	begin
		if (i == 0)
			iron_on = Ironcheck[0];
		else 
			iron_on = iron_on || Ironcheck[i];
	end
	
	for (int i = 0; i < IronSize1; i++)
	begin
		if ((DrawX >= IronXarray1[i] - IronBlockWidth) &&
		 (DrawX <= IronXarray1[i] + IronBlockWidth) &&
		 (DrawY >= IronYarray1[i] - IronBlockWidth) &&
		 (DrawY <= IronYarray1[i] + IronBlockWidth))
			Ironcheck1[i] = 1;
		else 
			Ironcheck1[i] = 0;
	end
	
	for (int i = 0; i < IronSize1; i++)
	begin
		if (i == 0)
			iron_on1 = Ironcheck1[0];
		else 
			iron_on1 = iron_on1 || Ironcheck1[i];
	end
	
	
	for (int i = 0; i < IronSize2; i++)
	begin
		if ((DrawX >= IronXarray2[i] - IronBlockWidth) &&
		 (DrawX <= IronXarray2[i] + IronBlockWidth) &&
		 (DrawY >= IronYarray2[i] - IronBlockWidth) &&
		 (DrawY <= IronYarray2[i] + IronBlockWidth))
			Ironcheck2[i] = 1;
		else 
			Ironcheck2[i] = 0;
	end
	
	for (int i = 0; i < IronSize2; i++)
	begin
		if (i == 0)
			iron_on2 = Ironcheck2[0];
		else 
			iron_on2 = iron_on2 || Ironcheck2[i];
	end
	

	
	
	for (int i = 0; i < IronSize3; i++)
	begin
		if ((DrawX >= IronXarray3[i] - IronBlockWidth) &&
		 (DrawX <= IronXarray3[i] + IronBlockWidth) &&
		 (DrawY >= IronYarray3[i] - IronBlockWidth) &&
		 (DrawY <= IronYarray3[i] + IronBlockWidth))
			Ironcheck3[i] = 1;
		else 
			Ironcheck3[i] = 0;
	end
	
	for (int i = 0; i < IronSize3; i++)
	begin
		if (i == 0)
			iron_on3 = Ironcheck3[0];
		else 
			iron_on3 = iron_on3 || Ironcheck3[i];
	end
	
	
	
	
	
	for (int i = 0; i < IronSize4; i++)
	begin
		if ((DrawX >= IronXarray4[i] - IronBlockWidth) &&
		 (DrawX <= IronXarray4[i] + IronBlockWidth) &&
		 (DrawY >= IronYarray4[i] - IronBlockWidth) &&
		 (DrawY <= IronYarray4[i] + IronBlockWidth))
			Ironcheck4[i] = 1;
		else 
			Ironcheck4[i] = 0;
	end
	
	for (int i = 0; i < IronSize4; i++)
	begin
		if (i == 0)
			iron_on4 = Ironcheck4[0];
		else 
			iron_on4 = iron_on4 || Ironcheck4[i];
	end
	
	
	
	for (int i = 0; i < IronSize5; i++)
	begin
		if ((DrawX >= IronXarray5[i] - IronBlockWidth) &&
		 (DrawX <= IronXarray5[i] + IronBlockWidth) &&
		 (DrawY >= IronYarray5[i] - IronBlockWidth) &&
		 (DrawY <= IronYarray5[i] + IronBlockWidth))
			Ironcheck5[i] = 1;
		else 
			Ironcheck5[i] = 0;
	end
	
	for (int i = 0; i < IronSize5; i++)
	begin
		if (i == 0)
			iron_on5 = Ironcheck5[0];
		else 
			iron_on5 = iron_on5 || Ironcheck5[i];
	end
	
	
	
	for (int i = 0; i < IronSize6; i++)
	begin
		if ((DrawX >= IronXarray6[i] - IronBlockWidth) &&
		 (DrawX <= IronXarray6[i] + IronBlockWidth) &&
		 (DrawY >= IronYarray6[i] - IronBlockWidth) &&
		 (DrawY <= IronYarray6[i] + IronBlockWidth))
			Ironcheck6[i] = 1;
		else 
			Ironcheck6[i] = 0;
	end
	
	for (int i = 0; i < IronSize6; i++)
	begin
		if (i == 0)
			iron_on6 = Ironcheck6[0];
		else 
			iron_on6 = iron_on6 || Ironcheck6[i];
	end
	
	
	for (int i = 0; i < IronSize7; i++)
	begin
		if ((DrawX >= IronXarray7[i] - IronBlockWidth) &&
		 (DrawX <= IronXarray7[i] + IronBlockWidth) &&
		 (DrawY >= IronYarray7[i] - IronBlockWidth) &&
		 (DrawY <= IronYarray7[i] + IronBlockWidth))
			Ironcheck7[i] = 1;
		else 
			Ironcheck7[i] = 0;
	end
	
	for (int i = 0; i < IronSize7; i++)
	begin
		if (i == 0)
			iron_on7 = Ironcheck7[0];
		else 
			iron_on7 = iron_on7 || Ironcheck7[i];
	end	
	
	
		
end












// hq ////////////////////////////////////////////////////////////////////////////////////

logic [9:0] hq_read_address;
logic [2:0] hq_data_out;
logic [23:0] RGBhq;

parameter [9:0] hqX=319;  // Center position on the X axis
parameter [9:0] hqY=463;  // Center position on the Y axis

assign hq_read_address = (DrawX - (hqX - 10'h10)) + 32*(DrawY - (hqY - 10'h10));

hq_ram hq_ram (.Clk(Clk), .read_address(hq_read_address), .data_Out(hq_data_out));

always_comb 
begin
	case(hq_data_out)
		3'h0:RGBhq = 24'h000000;
		3'h1:RGBhq = 24'h230E0E;
		3'h2:RGBhq = 24'h272727;
		3'h3:RGBhq = 24'h767676;
		3'h4:RGBhq = 24'hBE3236;
		default:RGBhq = 24'hFFFFFF;
	endcase
end

always_comb
begin:Hq_on_proc
	if ((DrawX >= hqX - iron_size) &&
	(DrawX <= hqX + iron_size) &&
	(DrawY >= hqY - iron_size) &&
	(DrawY <= hqY + iron_size))
		hq_on = 1'b1;
	else 
		hq_on = 1'b0;
end






// hq1 ////////////////////////////////////////////////////////////////////////////////////

logic [9:0] hq1_read_address;
logic [2:0] hq1_data_out;
logic [23:0] RGBhq1;

parameter [9:0] hq1X=319;  // Center position on the X axis
parameter [9:0] hq1Y=16;  // Center position on the Y axis

assign hq1_read_address = (DrawX - (hq1X - 10'h10)) + 32*(DrawY - (hq1Y - 10'h10));

hq1_ram hq1_ram (.Clk(Clk), .read_address(hq1_read_address), .data_Out(hq1_data_out));

always_comb 
begin
	case(hq1_data_out)
		3'h0:RGBhq1 = 24'h000000;
		3'h1:RGBhq1 = 24'h230E0E;
		3'h2:RGBhq1 = 24'h272727;
		3'h3:RGBhq1 = 24'h767676;
		3'h4:RGBhq1 = 24'hBE3236;
		default:RGBhq1 = 24'hFFFFFF;
	endcase
end

always_comb
begin:Hq1_on_proc
	if ((DrawX >= hq1X - iron_size) &&
	(DrawX <= hq1X + iron_size) &&
	(DrawY >= hq1Y - iron_size) &&
	(DrawY <= hq1Y + iron_size))
		hq1_on = 1'b1;
	else 
		hq1_on = 1'b0;
end
	 

	 
	 
	 
	 
	 
	 
	 

// water ////////////////////////////////////////////////////////////////////////////////////

parameter [9:0] zeroX=0;  // Center position on the X axis
parameter [9:0] zeroY=0;  // Center position on the Y axis
parameter [9:0] WaterSize = 23;
parameter [9:0] WaterBlockSize = 16;

logic [9:0] water_read_address;
logic [2:0] water_data_out;
logic [23:0] RGBwater;
logic [WaterSize-1:0][9:0] WaterXarray, WaterYarray;
logic [WaterSize-1:0] Watercheck;
assign water_read_address = (DrawX - (zeroX - 10'h10)) + 32*(DrawY - (zeroY - 10'h10));

water_ram water_ram (.Clk(Clk), .read_address(water_read_address), .data_Out(water_data_out));

always_comb 
begin
	case(water_data_out)
		3'h0:RGBwater = 24'h000000;
		3'h1:RGBwater = 24'h3640ff;
		3'h2:RGBwater = 24'hbdfef3;
		3'h3:RGBwater = 24'hcecfd1;
		3'h4:RGBwater = 24'h736ad9;
		default:RGBwater = 24'hFFFFFF;
	endcase
end

assign WaterXarray = '{287, 254, 221, 287, 287, 287, 287, 287, 255, 223, 191, 159, 319, 351, 383, 527, 527, 527, 527, 559, 591, 48,  80};
assign WaterYarray = '{303, 303, 303, 271, 239, 207, 175, 143, 143, 143, 143, 143, 176, 176, 176, 208, 240, 272, 304, 304, 304, 206, 206};

always_comb
begin
	for (int i = 0; i < WaterSize; i++)
	begin
		if ((DrawX >= WaterXarray[i] - WaterBlockSize) &&
		 (DrawX <= WaterXarray[i] + WaterBlockSize) &&
		 (DrawY >= WaterYarray[i] - WaterBlockSize) &&
		 (DrawY <= WaterYarray[i] + WaterBlockSize))
			Watercheck[i] = 1;
		else 
			Watercheck[i] = 0;
	end
	
	for (int i = 0; i < WaterSize; i++)
	begin
		if (i == 0)
			water_on = Watercheck[0];
		else 
			water_on = water_on || Watercheck[i];
	end
end














// grass ////////////////////////////////////////////////////////////////////////////////////

parameter [9:0] GrassSize = 47;
parameter [9:0] GrassBlockSize = 16;

logic [9:0] Grass_read_address;
logic [2:0] Grass_data_out;
logic [23:0] RGBGrass;
logic [GrassSize-1:0][9:0] GrassXarray, GrassYarray;
logic [GrassSize-1:0] Grasscheck;
assign Grass_read_address = (DrawX - (zeroX - 10'h10)) + 32*(DrawY - (zeroY - 10'h10));

grass_ram grass_ram (.Clk(Clk), .read_address(Grass_read_address), .data_Out(Grass_data_out));

always_comb 
begin
	case(Grass_data_out)
		3'h0:RGBGrass = 24'h230E0E;
		3'h1:RGBGrass = 24'h9cea00;
		3'h2:RGBGrass = 24'h346c12;
		3'h3:RGBGrass = 24'h29584a;
		3'h4:RGBGrass = 24'h9dde3d;
		default:RGBGrass = 24'hFFFFFF;
	endcase
end

assign GrassXarray = '{255, 222, 190, 159, 159, 159, 159, 190, 222, 255, 255, 255, 255, //13
							  559, 527, 495, 495, 495, 495, 495, // 20 so far 
							  16,  16,  16,  16, //24
							  624, 592, 560, 528,
							  80, 80, 80, 80, 112, 112, 112, 112, 16,  48,  80, 624, 624, 592, 592, //45
							  319, 351, 383, 16}; 
assign GrassYarray = '{270, 270, 270, 270, 238, 206, 174, 174, 174, 174, 206, 238, 270,
							  176, 176, 176, 208, 240, 272, 304,
							  464, 432, 400, 368,
							  464, 464, 464, 464, 
							  16, 48, 80, 110, 16, 48,  80,  110, 238, 238, 238, 16, 47,  16,  47,
							  144, 144, 144, 206};

always_comb
begin
	for (int i = 0; i < GrassSize; i++)
	begin
		if ((DrawX >= GrassXarray[i] - GrassBlockSize) &&
		 (DrawX <= GrassXarray[i] + GrassBlockSize) &&
		 (DrawY >= GrassYarray[i] - GrassBlockSize) &&
		 (DrawY <= GrassYarray[i] + GrassBlockSize))
			Grasscheck[i] = 1;
		else 
			Grasscheck[i] = 0;
	end
	
	for (int i = 0; i < GrassSize; i++)
	begin
		if (i == 0)
			grass_on = Grasscheck[0];
		else 
			grass_on = grass_on || Grasscheck[i];
	end
end



// i ////////////////////////////////////////////////////////////////////////////////////

logic [11:0] i_read_address;
logic [2:0] i_data_out;
logic [23:0] RGBi;

//parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
//parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis

parameter [9:0] iX=208;  // Center position on the X axis
parameter [9:0] iY=224;  // Center position on the Y axis

assign i_read_address = (DrawX - (iX - 10'h16)) + 44*(DrawY - (iY - 10'h20));

i_ram i_ram (.Clk(Clk), .read_address(i_read_address), .data_Out(i_data_out));

always_comb 
begin
	case(i_data_out)
		3'h0:RGBi = 24'h000000;
		3'h1:RGBi = 24'he94922;
		3'h2:RGBi = 24'h0a244b;
		3'h3:RGBi = 24'h767676;
		3'h4:RGBi = 24'hBE3236;
		default:RGBi = 24'hFFFFFF;
	endcase
end

always_comb
begin:i_on_proc
	if ((DrawX >= iX - 22) &&
	(DrawX <= iX + 22) &&
	(DrawY >= iY - 32) &&
	(DrawY <= iY + 32))
		i_on = 1'b1;
	else 
		i_on = 1'b0;
end
	 

// gamebegin ////////////////////////////////////////////////////////////////////////////////////

logic [15:0] gamebegin_read_address;
logic [3:0] gamebegin_data_out;
logic [23:0] RGBgamebegin;

parameter [9:0] gamebeginX=320;  // Center position on the X axis
parameter [9:0] gamebeginY=240;  // Center position on the Y axis

assign gamebegin_read_address = (DrawX - (gamebeginX - 10'hA0)) + 320*(DrawY - (gamebeginY - 10'h5A));

gamebegin_ram gamebegin_ram (.Clk(Clk), .read_address(gamebegin_read_address), .data_Out(gamebegin_data_out));

always_comb 
begin
	case(gamebegin_data_out)
		4'h0:RGBgamebegin = 24'h000000;
		4'h1:RGBgamebegin = 24'hbc7200;
		4'h2:RGBgamebegin = 24'h748481;
		
		4'h3:RGBgamebegin = 24'ha43101;
		4'h4:RGBgamebegin = 24'ha43102;
		4'h5:RGBgamebegin = 24'hFFA044;
		
		4'h6:RGBgamebegin = 24'hAF7F03;
		4'h7:RGBgamebegin = 24'hAC7C00;
		4'h8:RGBgamebegin = 24'hF8D878;
		
		4'h9:RGBgamebegin = 24'hacfaf6;
		4'hA:RGBgamebegin = 24'h018528;
		4'hB:RGBgamebegin = 24'h0a560e;
		
		4'hC:RGBgamebegin = 24'h75d7ad;
		4'hD:RGBgamebegin = 24'hFFFFFF;
		default:RGBgamebegin = 24'hFFFFFF;
	endcase
end

always_comb
begin:gamebegin_on_proc
	if ((DrawX >= gamebeginX - 160) &&
	(DrawX <= gamebeginX + 160) &&
	(DrawY >= gamebeginY - 90) &&
	(DrawY <= gamebeginY + 90))
		gamebegin_on0 = 1'b1;
	else 
		gamebegin_on0 = 1'b0;
end













// player1wins ////////////////////////////////////////////////////////////////////////////////////

logic [16:0] player1wins_read_address;
logic [3:0] player1wins_data_out;
logic [23:0] RGBplayer1wins;

parameter [9:0] player1winsX=320;  // Center position on the X axis
parameter [9:0] player1winsY=240;  // Center position on the Y axis

assign player1wins_read_address = (DrawX - (player1winsX - 10'hA0)) + 320*(DrawY - (player1winsY - 10'h80));

player1wins_ram player1wins_ram (.Clk(Clk), .read_address(player1wins_read_address), .data_Out(player1wins_data_out));

always_comb 
begin
	case(player1wins_data_out)
		4'h0:RGBplayer1wins = 24'h000000;
		4'h1:RGBplayer1wins = 24'hbc7200;
		4'h2:RGBplayer1wins = 24'h748481;
		
		4'h3:RGBplayer1wins = 24'ha43101;
		4'h4:RGBplayer1wins = 24'ha43102;
		4'h5:RGBplayer1wins = 24'hFFA044;
		
		4'h6:RGBplayer1wins = 24'hAF7F03;
		4'h7:RGBplayer1wins = 24'hAC7C00;
		4'h8:RGBplayer1wins = 24'hF8D878;
		
		4'h9:RGBplayer1wins = 24'hacfaf6;
		4'hA:RGBplayer1wins = 24'h018528;
		4'hB:RGBplayer1wins = 24'h0a560e;
		
		4'hC:RGBplayer1wins = 24'h75d7ad;
		4'hD:RGBplayer1wins = 24'hFFFFFF;
		default:RGBplayer1wins = 24'hFFFFFF;
	endcase
end

always_comb
begin:player1wins_on_proc
	if ((DrawX >= player1winsX - 160) &&
	(DrawX <= player1winsX + 160) &&
	(DrawY >= player1winsY - 128) &&
	(DrawY <= player1winsY + 128))
		player1wins_on = 1'b1;
	else 
		player1wins_on = 1'b0;
end




// player2wins ////////////////////////////////////////////////////////////////////////////////////

logic [16:0] player2wins_read_address;
logic [3:0] player2wins_data_out;
logic [23:0] RGBplayer2wins;

parameter [9:0] player2winsX=320;  // Center position on the X axis
parameter [9:0] player2winsY=240;  // Center position on the Y axis

assign player2wins_read_address = (DrawX - (player2winsX - 10'hA0)) + 320*(DrawY - (player2winsY - 10'h80));

player2wins_ram player2wins_ram (.Clk(Clk), .read_address(player2wins_read_address), .data_Out(player2wins_data_out));

always_comb 
begin
	case(player2wins_data_out)
		4'h0:RGBplayer2wins = 24'h000000;
		4'h1:RGBplayer2wins = 24'hbc7200;
		4'h2:RGBplayer2wins = 24'h748481;
		
		4'h3:RGBplayer2wins = 24'ha43101;
		4'h4:RGBplayer2wins = 24'ha43102;
		4'h5:RGBplayer2wins = 24'hFFA044;
		
		4'h6:RGBplayer2wins = 24'hAF7F03;
		4'h7:RGBplayer2wins = 24'hAC7C00;
		4'h8:RGBplayer2wins = 24'hF8D878;
		
		4'h9:RGBplayer2wins = 24'hacfaf6;
		4'hA:RGBplayer2wins = 24'h018528;
		4'hB:RGBplayer2wins = 24'h0a560e;
		
		4'hC:RGBplayer2wins = 24'h75d7ad;
		4'hD:RGBplayer2wins = 24'hFFFFFF;
		default:RGBplayer2wins = 24'hFFFFFF;
	endcase
end

always_comb
begin:player2wins_on_proc
	if ((DrawX >= player2winsX - 160) &&
	(DrawX <= player2winsX + 160) &&
	(DrawY >= player2winsY - 128) &&
	(DrawY <= player2winsY + 128))
		player2wins_on = 1'b1;
	else 
		player2wins_on = 1'b0;
end












// esc ////////////////////////////////////////////////////////////////////////////////////

logic [15:0] esc_read_address;
logic  esc_data_out;
logic [23:0] RGBesc;

parameter [9:0] escX=320;  // Center position on the X axis
parameter [9:0] escY=240;  // Center position on the Y axis

assign esc_read_address = (DrawX - (escX - 10'h8C)) + 280*(DrawY - (escY - 10'h64));

esc_ram esc_ram (.Clk(Clk), .read_address(esc_read_address), .data_Out(esc_data_out));

always_comb 
begin
	case(esc_data_out)
		1'h0:RGBesc = 24'h000000;
		1'h1:RGBesc = 24'hFFFFFF;
		default:RGBesc = 24'hFFFFFF;
	endcase
end

always_comb
begin:esc_on_proc
	if ((DrawX >= escX - 140) &&
	(DrawX <= escX + 140) &&
	(DrawY >= escY - 100) &&
	(DrawY <= escY + 100))
		esc_on = 1'b1;
	else 
		esc_on = 1'b0;
end

















// restart ////////////////////////////////////////////////////////////////////////////////////

logic [16:0] restart_read_address;
logic        restart_data_out;
logic [23:0] RGBrestart;

parameter [9:0] restartX=320;  // Center position on the X axis
parameter [9:0] restartY=403;  // Center position on the Y axis

assign restart_read_address = (DrawX - (restartX - 10'h3C)) + 120*(DrawY - (restartY - 10'h22));

restart_ram restart_ram (.Clk(Clk), .read_address(restart_read_address), .data_Out(restart_data_out));

always_comb 
begin
	case(restart_data_out)
		1'h0:RGBrestart = 24'h000000;
		1'h1:RGBrestart = 24'hFFFFFF;
		default:RGBrestart = 24'hFFFFFF;
	endcase
end

always_comb
begin:restart_on_proc
	if ((DrawX >= restartX - 60) &&
	(DrawX <= restartX + 60) &&
	(DrawY >= restartY - 34) &&
	(DrawY <= restartY + 34))
		restart_on = 1'b1;
	else 
		restart_on = 1'b0;
end










// RGB ////////////////////////////////////////////////////////////////////////////////////
always_ff @ (posedge Clk)
begin:RGB_Display
	
	if (gamebegin_on) //gamebegin_on
		begin
		
			if (gamebegin_on0)
				begin 
					Red <= RGBgamebegin[23:16];
					Green <= RGBgamebegin[15:8];
					Blue <= RGBgamebegin[7:0];
				end
				
			else 
				begin 
					Red <= 8'h00; 
					Green <= 8'h00;
					Blue <= 8'h00;
				end
		end
	
	
	else if (pause) // pause
		begin
			
			if (esc_on) // esc_on
				begin 
					Red <= RGBesc[23:16];
					Green <= RGBesc[15:8];
					Blue <= RGBesc[7:0];
				end
			else 
				begin 
					Red <= 8'h00; 
					Green <= 8'h00;
					Blue <= 8'h00;
				end 
		end 
	
	else if (gaming_on)
		begin
			
			if (grass_on && (RGBGrass != 24'h230E0E))
				begin 
					Red <= RGBGrass[23:16];
					Green <= RGBGrass[15:8];
					Blue <= RGBGrass[7:0];
				end

			// tank1
			else if ((Direct == 3'b000) && (RGBtank0left != 24'h230E0E) && ball_on)
				begin
					Red <= RGBtank0left[23:16];     // left
					Green <= RGBtank0left[15:8];
					Blue <= RGBtank0left[7:0];
				end
			
			else if ((Direct == 3'b001) &&  (RGBtank0right != 24'h230E0E) && ball_on)
				begin
					Red <= RGBtank0right[23:16];    // right
					Green <= RGBtank0right[15:8];
					Blue <= RGBtank0right[7:0];
				end

			else if ((Direct == 3'b010) &&  (RGBtank0down != 24'h230E0E) && ball_on)
				begin
					Red <= RGBtank0down[23:16];     // down
					Green <= RGBtank0down[15:8];
					Blue <= RGBtank0down[7:0];
				end
				
			else if ((Direct == 3'b011) &&  (RGBtank0up != 24'h230E0E) && ball_on)
				begin
					Red <= RGBtank0up[23:16];    	 // up
					Green <= RGBtank0up[15:8];
					Blue <= RGBtank0up[7:0];
				end
				
			// tank2
			else if ((Direct2 == 3'b000) && (RGBtank2left != 24'h230E0E) && ball_on2)
				begin
					Red <= RGBtank2left[23:16];     // left
					Green <= RGBtank2left[15:8];
					Blue <= RGBtank2left[7:0];
				end
			
			else if ((Direct2 == 3'b001) &&  (RGBtank2right != 24'h230E0E) && ball_on2)
				begin
					Red <= RGBtank2right[23:16];    // right
					Green <= RGBtank2right[15:8];
					Blue <= RGBtank2right[7:0];
				end

			else if ((Direct2 == 3'b010) &&  (RGBtank2down != 24'h230E0E) && ball_on2)
				begin
					Red <= RGBtank2down[23:16];     // down
					Green <= RGBtank2down[15:8];
					Blue <= RGBtank2down[7:0];
				end
				
			else if ((Direct2 == 3'b011) &&  (RGBtank2up != 24'h230E0E) && ball_on2)
				begin
					Red <= RGBtank2up[23:16];    	 // up
					Green <= RGBtank2up[15:8];
					Blue <= RGBtank2up[7:0];
				end

			else if (bullet_on && Is_bullet_on)
				begin 
					Red <= RGBbullet[23:16];
					Green <= RGBbullet[15:8];
					Blue <= RGBbullet[7:0];
				end
				 
			else if (bullet_on2 && Is_bullet_on2)
				begin 
					Red <= RGBbullet2[23:16];
					Green <= RGBbullet2[15:8];
					Blue <= RGBbullet2[7:0];
				end

			else if (boom_on && Is_bullet_on && (RGBboom != 24'h230E0E))  //(boom_on111 && Is_bullet_on111 && (RGBboom != 24'h230E0E))
				begin 
					Red <= RGBboom[23:16];
					Green <= RGBboom[15:8];
					Blue <= RGBboom[7:0];
				end 

			else if (boom_on2 && Is_bullet_on2 && (RGBboom2 != 24'h230E0E))  //(boom_on111 && Is_bullet_on111 && (RGBboom != 24'h230E0E))
				begin 
					Red <= RGBboom2[23:16];
					Green <= RGBboom2[15:8];
					Blue <= RGBboom2[7:0];
				end
				
			else if (boom_on3 && Is_bullet_on && BulletHittank2 && (RGBboom3 != 24'h230E0E))
				begin 
					Red <= RGBboom3[23:16];
					Green <= RGBboom3[15:8];
					Blue <= RGBboom3[7:0];
				end
			
			else if (boom_on4 && Is_bullet_on2 && Bullet2Hittank && (RGBboom4 != 24'h230E0E))
				begin 
					Red <= RGBboom4[23:16];
					Green <= RGBboom4[15:8];
					Blue <= RGBboom4[7:0];
				end
			
			else if (boom_on3 && Is_bullet_on && BulletHitBoundary && (RGBboom3 != 24'h230E0E)) 
				begin 
					Red <= RGBboom3[23:16];
					Green <= RGBboom3[15:8];
					Blue <= RGBboom3[7:0];
				end
			
			else if (boom_on4 && Is_bullet_on2 && BulletHitBoundary2 && (RGBboom4 != 24'h230E0E))
				begin 
					Red <= RGBboom4[23:16];
					Green <= RGBboom4[15:8];
					Blue <= RGBboom4[7:0];
				end
				
			else if (iron_on)
				begin 
					Red <= RGBiron[23:16];
					Green <= RGBiron[15:8];
					Blue <= RGBiron[7:0];
				end 
				
			else if (iron_on1)
				begin 
					Red <= RGBiron1[23:16];
					Green <= RGBiron1[15:8];
					Blue <= RGBiron1[7:0];
				end 
				
			else if (iron_on2)
				begin 
					Red <= RGBiron2[23:16];
					Green <= RGBiron2[15:8];
					Blue <= RGBiron2[7:0];
				end

			else if (iron_on3)
				begin 
					Red <= RGBiron3[23:16];
					Green <= RGBiron3[15:8];
					Blue <= RGBiron3[7:0];
				end 
				
			else if (iron_on4)
				begin 
					Red <= RGBiron4[23:16];
					Green <= RGBiron4[15:8];
					Blue <= RGBiron4[7:0];
				end 		
				
			else if (iron_on5)
				begin 
					Red <= RGBiron5[23:16];
					Green <= RGBiron5[15:8];
					Blue <= RGBiron5[7:0];
				end

			else if (iron_on6)
				begin 
					Red <= RGBiron6[23:16];
					Green <= RGBiron6[15:8];
					Blue <= RGBiron6[7:0];
				end 
				
			else if (iron_on7)
				begin 
					Red <= RGBiron7[23:16];
					Green <= RGBiron7[15:8];
					Blue <= RGBiron7[7:0];
				end 
				
			else if (wall_on) 
				begin
					Red <= RGBwall[23:16];
					Green <= RGBwall[15:8];
					Blue <= RGBwall[7:0];
				end

			else if (i_on) 
				begin
					Red <= RGBi[23:16];
					Green <= RGBi[15:8];
					Blue <= RGBi[7:0];
				end
				
			else if (hq_on) 
				begin
					Red <= RGBhq[23:16];
					Green <= RGBhq[15:8];
					Blue <= RGBhq[7:0];
				end
				
			else if (hq1_on) 
				begin
					Red <= RGBhq1[23:16];
					Green <= RGBhq1[15:8];
					Blue <= RGBhq1[7:0];
				end
				
			else if (water_on) 
				begin
					Red <= RGBwater[23:16];
					Green <= RGBwater[15:8];
					Blue <= RGBwater[7:0];
				end
			else 
				begin 
					Red <= 8'h00; 
					Green <= 8'h00;
					Blue <= 8'h00;
				end
		end
	
	
	else if (gameend_on)
		begin
		
			if (Player1wins && player1wins_on)
				begin
					Red <= RGBplayer1wins[23:16];
					Green <= RGBplayer1wins[15:8];
					Blue <= RGBplayer1wins[7:0];
				end
				
			else if (Player2wins && player2wins_on)
				begin
					Red <= RGBplayer2wins[23:16];
					Green <= RGBplayer2wins[15:8];
					Blue <= RGBplayer2wins[7:0];
				end
				
			else if (restart_on)
				begin
					Red <= RGBrestart[23:16];
					Green <= RGBrestart[15:8];
					Blue <= RGBrestart[7:0];
				end
				
			else 
				begin 
					Red <= 8'h00; 
					Green <= 8'h00;
					Blue <= 8'h00;
				end
				
		end
	
	else 
		begin 
			Red <= 8'h00; 
			Green <= 8'h00;
			Blue <= 8'h00;
		end

end
 
endmodule















































































































//		  case (Direct)
//				3'b000 : begin
//								Red = RGBtank0left[23:16];      // left
//								Green = RGBtank0left[15:8];
//								Blue = RGBtank0left[7:0];
//							end
//						  
//				3'b001 : begin
//								Red = RGBtank0right[23:16];     // right
//								Green = RGBtank0right[15:8];
//								Blue = RGBtank0right[7:0];
//							end
//						  
//				3'b010 : begin
//								Red = RGBtank0down[23:16];      // down
//								Green = RGBtank0down[15:8];
//								Blue = RGBtank0down[7:0];
//							end
//						  
//				3'b011 : begin
//								Red = RGBtank0up[23:16];        // up
//								Green = RGBtank0up[15:8];  
//								Blue = RGBtank0up[7:0];
//							end
//				default: begin
//								Red = RGBtank0up[23:16];
//								Green = RGBtank0up[15:8];
//								Blue = RGBtank0up[7:0];
//							end
//		  endcase

















//	parameter [9:0] waterX=287;  // Center position on the X axis
//	parameter [9:0] waterY=303;  // Center position on the Y axis
//
//	 parameter [9:0] waterX1=287;  // Center position on the X axis
//	 parameter [9:0] waterY1=271;  // Center position on the Y axis
//	 parameter [9:0] waterX2=255;  // Center position on the X axis
//	 parameter [9:0] waterY2=143;  // Center position on the Y axis
//	 
//	 parameter [9:0] waterX3=319;  // Center position on the X axis
//	 parameter [9:0] waterY3=176;  // Center position on the Y axis	 
//	 
//	 parameter [9:0] waterX4=527;  // Center position on the X axis
//	 parameter [9:0] waterY4=176;  // Center position on the Y axis	 
//	 parameter [9:0] waterX5=559;  // Center position on the X axis
//	 parameter [9:0] waterY5=304;  // Center position on the Y axis	 
//	 parameter [9:0] waterX6=16;  // Center position on the X axis
//	 parameter [9:0] waterY6=207;  // Center position on the Y axis
//	 	 


	 
//always_comb
//begin:water_on_proc
//  if ((DrawX >= waterX - iron_size*5) &&
// (DrawX <= waterX + iron_size) &&
// (DrawY >= waterY - iron_size) &&
// (DrawY <= waterY + iron_size))
//		water_on = 1'b1;
//		
//  else if ((DrawX >= waterX1 - iron_size) &&
// (DrawX <= waterX1 + iron_size) &&
// (DrawY >= waterY1 - iron_size*9) &&
// (DrawY <= waterY1 + iron_size))
//		water_on = 1'b1;
//		
//  else if ((DrawX >= waterX2 - iron_size*8) &&
// (DrawX <= waterX2 + iron_size) &&
// (DrawY >= waterY2 - iron_size) &&
// (DrawY <= waterY2 + iron_size))
//		water_on = 1'b1;
//		
//  else if ((DrawX >= waterX3 - iron_size) &&
// (DrawX <= waterX3 + iron_size*5) &&
// (DrawY >= waterY3 - iron_size) &&
// (DrawY <= waterY3 + iron_size))
//		water_on = 1'b1;
//		
//  else if ((DrawX >= waterX4 - iron_size) &&
// (DrawX <= waterX4 + iron_size) &&
// (DrawY >= waterY4 - iron_size) &&
// (DrawY <= waterY4 + iron_size*7))
//		water_on = 1'b1;
//		
//  else if ((DrawX >= waterX5 - iron_size*3) &&
// (DrawX <= waterX5 + iron_size*3) &&
// (DrawY >= waterY5 - iron_size) &&
// (DrawY <= waterY5 + iron_size))
//		water_on = 1'b1;
//		
//		
//  else if ((DrawX >= waterX6 - iron_size) &&
// (DrawX <= waterX6 + iron_size*5) &&
// (DrawY >= waterY6 - iron_size) &&
// (DrawY <= waterY6 + iron_size))
//		water_on = 1'b1;
//		
//		
//  else 
//		water_on = 1'b0;
//end


	 
	 
//
//
//
////	 parameter [9:0] swX=294;  // Center position on the X axis
////		parameter [9:0] swY=471;  // Center position on the Y axis
////	 parameter [9:0] swX1=16;  // Center position on the X axis
////	 parameter [9:0] swY1=335;  // Center position on the Y axis
////	 
////	 parameter [9:0] swX2=623;  // Center position on the X axis
////	 parameter [9:0] swY2=80;  // Center position on the Y axis
//	 
//	 parameter [9:0] swX3=591;  // Center position on the X axis
//	 parameter [9:0] swY3=112;  // Center position on the Y axis
//	 
//	 parameter [9:0] swX4=591;  // Center position on the X axis
//	 parameter [9:0] swY4=176;  // Center position on the Y axis
//	 
//	 parameter [9:0] swX5=495;  // Center position on the X axis
//	 parameter [9:0] swY5=304;  // Center position on the Y axis
//	 
//	 parameter [9:0] swX6=623;  // Center position on the X axis
//	 parameter [9:0] swY6=431;  // Center position on the Y axis
//	 
//	 parameter [9:0] swX7=639;  // Center position on the X axis
//	 parameter [9:0] swY7=399;  // Center position on the Y axis
//	 
//	 
//	 
//	 parameter [9:0] swX8=495;  // Center position on the X axis
//	 parameter [9:0] swY8=304;  // Center position on the Y axis
//	 
//	 parameter [9:0] swX9=623;  // Center position on the X axis
//	 parameter [9:0] swY9=431;  // Center position on the Y axis
//	 
//	 parameter [9:0] swX10=639;  // Center position on the X axis
//	 parameter [9:0] swY10=399;  // Center position on the Y axis
//	 
////	 always_comb
////    begin:sw_on_proc
////        if ((DrawX >= swX - sw_size) &&
////       (DrawX <= swX + sw_size) &&
////       (DrawY >= swY - sw_size*3) &&
////       (DrawY <= swY + sw_size)) 
////				sw_on = 1'b1;
////				
////		 else if((DrawX >= swX + 48 - sw_size) &&
////       (DrawX <= swX + 48 + sw_size) &&
////       (DrawY >= swY - sw_size*3) &&
////       (DrawY <= swY + sw_size))
////				sw_on = 1'b1;
////				
////		 else if  ((DrawX >= swX - sw_size) &&
////       (DrawX <= swX + sw_size*7) &&
////       (DrawY >= swY - 32 - sw_size) &&
////       (DrawY <= swY - 32 + sw_size)) 
////            sw_on = 1'b1;
//				
////		  else if ((DrawX >= swX1 - sw_size*2) &&
////       (DrawX <= swX1 + sw_size*2) &&
////       (DrawY >= swY1 - sw_size*2) &&
////       (DrawY <= swY1 + sw_size*2))
////				sw_on = 1'b1;
//				
//		 else if ((DrawX >= swX2 - sw_size*6) &&
//       (DrawX <= swX2 + sw_size*2) &&
//       (DrawY >= swY2 - sw_size*2) &&
//       (DrawY <= swY2 + sw_size*2))
//				sw_on = 1'b1;
//				
//		 else if ((DrawX >= swX3 - sw_size*2) &&
//       (DrawX <= swX3 + sw_size*2) &&
//       (DrawY >= swY3 - sw_size*2) &&
//       (DrawY <= swY3 + sw_size*6))
//				sw_on = 1'b1;
//				
//		 else if ((DrawX >= swX4 - sw_size*6) &&
//       (DrawX <= swX4 + sw_size*2) &&
//       (DrawY >= swY4 - sw_size*2) &&
//       (DrawY <= swY4 + sw_size*2))
//				sw_on = 1'b1;
//				
//		 else if ((DrawX >= swX5 - sw_size*2) &&
//       (DrawX <= swX5 + sw_size*2) &&
//       (DrawY >= swY5 - sw_size*6) &&
//       (DrawY <= swY5 + sw_size*2))
//				sw_on = 1'b1;
//				
//		 else if ((DrawX >= swX6 - sw_size*2) &&
//       (DrawX <= swX6 + sw_size*2) &&
//       (DrawY >= swY6 - sw_size*2) &&
//       (DrawY <= swY6 + sw_size*2))
//				sw_on = 1'b1;
//				
//		 else if ((DrawX >= swX7 - sw_size*2) &&
//       (DrawX <= swX7 + sw_size) &&
//       (DrawY >= swY7 - sw_size*2) &&
//       (DrawY <= swY7 + sw_size*2))
//				sw_on = 1'b1;
//				
//				
//				
//				
//		 else if ((DrawX >= swX8 - sw_size*2) &&
//       (DrawX <= swX8 + sw_size*2) &&
//       (DrawY >= swY8 - sw_size*6) &&
//       (DrawY <= swY8 + sw_size*2))
//				sw_on = 1'b1;
//				
//		 else if ((DrawX >= swX8 - sw_size*2) &&
//       (DrawX <= swX8 + sw_size*2) &&
//       (DrawY >= swY8 - sw_size*2) &&
//       (DrawY <= swY8 + sw_size*2))
//				sw_on = 1'b1;
//				
//		 else if ((DrawX >= swX7 - sw_size) &&
//       (DrawX <= swX7 + sw_size) &&
//       (DrawY >= swY7 - sw_size*2) &&
//       (DrawY <= swY7 + sw_size*2))
//				sw_on = 1'b1;
//				
//				
//		 else 
//            sw_on = 1'b0;
//    end 
	 

//
//always_comb
//begin:Iron_on_proc
//	if ((DrawX >= IronX - iron_size) &&
//	(DrawX <= IronX + 80) &&
//	(DrawY >= IronY - iron_size) &&
//	(DrawY <= IronY + iron_size))
//		iron_on = 1'b1;
//		
//	else if ((DrawX >= IronX1 - iron_size) &&
//	(DrawX <= IronX1 + iron_size) &&
//	(DrawY >= IronY1 - iron_size) &&
//	(DrawY <= IronY1 + iron_size))
//		iron_on = 1'b1;
//		
//	else if ((DrawX >= IronX2 - iron_size*3) &&
//	(DrawX <= IronX2 + iron_size) &&
//	(DrawY >= IronY2 - iron_size) &&
//	(DrawY <= IronY2 + iron_size))
//		iron_on = 1'b1;
//		
//	else 
//		iron_on = 1'b0;
//end
//
//always_comb
//begin:Iron_on3_proc
//	if ((DrawX >= IronX3 - iron_size*3) &&
//	(DrawX <= IronX3 + iron_size*3) &&
//	(DrawY >= IronY3 - iron_size) &&
//	(DrawY <= IronY3 + iron_size))
//		iron_on3 = 1'b1;
//	else 
//		iron_on3 = 1'b0;
//end
//
//always_comb
//begin:Iron_on4_proc
//	if ((DrawX >= IronX4 - iron_size) &&
//	(DrawX <= IronX4 + iron_size*3) &&
//	(DrawY >= IronY4 - iron_size) &&
//	(DrawY <= IronY4 + iron_size))
//		iron_on4 = 1'b1;
//	else 
//		iron_on4 = 1'b0;
//end
