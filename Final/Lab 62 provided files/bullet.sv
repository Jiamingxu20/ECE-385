module  bullet ( input         Reset,  frame_clk, gamebegin_on, gaming_on, gameend_on, 
					  input         HitIron, HitWall, BulletHittank,
					  input [7:0]   keycode, keycode2, keycode3, keycode4,
					  input [9:0]   BallX, BallY,
					  output        Is_bullet_on,
					  output [9:0]  BulletX, BulletY, BulletS, BulletX_Motion, BulletY_Motion );

		  

logic Shoot;
logic [2:0] Direct;
logic [9:0] Bullet_X_Pos, Bullet_X_Motion, Bullet_Y_Pos, Bullet_Y_Motion, Bullet_Size, directionx, directiony, x_location, y_location;



parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
parameter [9:0] Ball_X_Center2=600;  // Center position on the X axis
parameter [9:0] Ball_Y_Center2=400;  // Center position on the Y axis
parameter [9:0] Bullet_X_Min=0;       // Leftmost point on the X axis
parameter [9:0] Bullet_X_Max=639;     // Rightmost point on the X axis
parameter [9:0] Bullet_Y_Min=0;       // Topmost point on the Y axis
parameter [9:0] Bullet_Y_Max=479;     // Bottommost point on the Y axis



assign Bullet_Size = 2;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"


always_comb
begin 
	if (keycode == 8'h0D || keycode2 == 8'h0D || keycode3 == 8'h0D || keycode4 == 8'h0D)
		Shoot = 1'h1;
	else 
		Shoot = 1'h0;
end 


always_comb
begin
	if (keycode == 8'h04 || keycode2 == 8'h04 || keycode3 == 8'h04 || keycode4 == 8'h04)	//A
		Direct = 3'b000;
	else if (keycode == 8'h07 || keycode2 == 8'h07 || keycode3 == 8'h07 || keycode4 == 8'h07) //D
		Direct = 3'b001;
	else if (keycode == 8'h16 || keycode2 == 8'h16 || keycode3 == 8'h16 || keycode4 == 8'h16)   //S
		Direct = 3'b010;
	else if (keycode == 8'h1A || keycode2 == 8'h1A || keycode3 == 8'h1A || keycode4 == 8'h1A)   //W
		Direct = 3'b011;
	else 
		Direct = 3'b111;
end



always_ff @ (posedge Reset or posedge frame_clk )
begin: ReleaseBullet
	if (Reset)   // Asynchronous Reset
		begin 
			Bullet_Y_Motion <= 10'h0;
			Bullet_X_Motion <= 10'h0;
			Bullet_Y_Pos <= BallY;
			Bullet_X_Pos <= BallX;
			directionx <= 10'h0;
			directiony <= 10'h0;
		end
		
	else if (gaming_on)
		begin
			case (Direct)
				3'b000 : begin
								directionx <= -5;			//A
								directiony <= 0;
							end
						  
				3'b001 : begin
								directionx <= 5;
								directiony <= 0;
							end
						  
				3'b010 : begin
								directionx <= 0;
								directiony <= 5;
							end
						  
				3'b011 : begin
								directionx <= 0;
								directiony <= -5;
							end
				default:;
				endcase
			
			if (Shoot)  // Shoot keycode received
						begin
							// already set direction; in motion
							if ((Bullet_X_Motion != 10'h0) || (Bullet_Y_Motion != 10'h0))
							begin
								if (((Bullet_X_Pos + Bullet_X_Motion) <= (Bullet_X_Min + Bullet_Size))
								|| ((Bullet_X_Pos + Bullet_X_Motion) >= (Bullet_X_Max - Bullet_Size))
								|| ((Bullet_Y_Pos + Bullet_Y_Motion) >= (Bullet_Y_Max - Bullet_Size))
								|| ((Bullet_Y_Pos + Bullet_Y_Motion) <= (Bullet_Y_Min + Bullet_Size))
								|| HitIron || HitWall || BulletHittank)
									begin 
										Bullet_X_Motion <= 10'h0;
										Bullet_Y_Motion <= 10'h0;
									end 
								else 
									begin 
										Bullet_X_Motion <= Bullet_X_Motion;
										Bullet_Y_Motion <= Bullet_Y_Motion;
										Bullet_Y_Pos <= (Bullet_Y_Pos + Bullet_Y_Motion);  				// Update bullet position
										Bullet_X_Pos <= (Bullet_X_Pos + Bullet_X_Motion);
									end 
							end
							
							// have not set direction; not in motion
							else if ((Bullet_X_Motion == 10'h0) && (Bullet_Y_Motion == 10'h0))
								begin
									Bullet_X_Motion <= directionx;
									Bullet_Y_Motion <= directiony;
									Bullet_X_Pos <= BallX;
									Bullet_Y_Pos <= BallY;
								end
						 end
			else if (((Bullet_X_Pos + Bullet_X_Motion) <= (Bullet_X_Min + Bullet_Size))
						|| ((Bullet_X_Pos + Bullet_X_Motion) >= (Bullet_X_Max - Bullet_Size))
						|| ((Bullet_Y_Pos + Bullet_Y_Motion) >= (Bullet_Y_Max - Bullet_Size))
						|| ((Bullet_Y_Pos + Bullet_Y_Motion) <= (Bullet_Y_Min + Bullet_Size))
						|| HitIron || HitWall || BulletHittank)
						begin 
							Bullet_X_Motion <= 10'h0;
							Bullet_Y_Motion <= 10'h0;
						end
			else 
						begin
							Bullet_Y_Pos <= (Bullet_Y_Pos + Bullet_Y_Motion);  							// Update bullet position
							Bullet_X_Pos <= (Bullet_X_Pos + Bullet_X_Motion);
						end
		end 
end


always_comb
begin
	if ((Bullet_X_Motion != 10'h0) || (Bullet_Y_Motion != 10'h0))
		Is_bullet_on <= 1'h1;
	else
		Is_bullet_on <= 1'h0;
end


assign BulletX = Bullet_X_Pos;

assign BulletY = Bullet_Y_Pos;

assign BulletS = Bullet_Size;

assign BulletX_Motion = Bullet_X_Motion;

assign BulletY_Motion = Bullet_Y_Motion;

endmodule


