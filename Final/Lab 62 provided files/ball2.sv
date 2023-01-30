//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball2 (input  				  Reset, frame_clk, HitIronA, HitIronD, HitIronS, HitIronW, gamebegin_on, gaming_on, gameend_on, BulletHittank,
					input  				  HitWaterA, HitWaterS, HitWaterD, HitWaterW, HitWallA, HitWallS, HitWallD, HitWallW, Is_bullet_on,
			      input			 		  tankhitA, tankhitD, tankhitS, tankhitW,
					input  [7:0]   	  keycode, keycode2, keycode3, keycode4,
               output logic [9:0]  BallX, BallY, BallS, BallX_Motion, BallY_Motion );
    
logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;

parameter [9:0] Ball_X_Center=561;  // Center position on the X axis
parameter [9:0] Ball_Y_Center=17;  // Center position on the Y axis
parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis

assign Ball_Size = 16;

always_ff @ (posedge Reset or posedge frame_clk )
begin: Move_Ball

	if (Reset)  // Asynchronous Reset
	begin 
		Ball_Y_Motion <= 10'd0;
		Ball_X_Motion <= 10'd0;
		Ball_Y_Pos <= Ball_Y_Center;
		Ball_X_Pos <= Ball_X_Center;
	end
	
	else if (gaming_on)
	begin 
		if (tankhitA || tankhitD || tankhitS || tankhitW || (BulletHittank && Is_bullet_on))
			begin 
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
			end
			
		else if (keycode == 8'h50 || keycode2 == 8'h50 || keycode3 == 8'h50 || keycode4 == 8'h50)  //A
			begin
				if (HitWallA || HitIronA || (!((Ball_X_Pos + Ball_X_Motion) > (Ball_X_Min + Ball_Size))))
					begin
						Ball_X_Motion <= 0;
						Ball_Y_Motion <= 0;
					end
				else
					begin
						if (HitWaterA)
							begin
									Ball_X_Motion <= -2;
									Ball_Y_Motion <= 0;
							end
						else 
							begin
									Ball_X_Motion <= -1;
									Ball_Y_Motion <= 0;
							end
					end				
			end
		
		else if (keycode == 8'h4F || keycode2 == 8'h4F || keycode3 == 8'h4F || keycode4 == 8'h4F) 	   //D
			begin
				if (HitWallD || HitIronD || (!((Ball_X_Pos + Ball_X_Motion) < (Ball_X_Max - Ball_Size))))
					begin
						Ball_X_Motion <= 0;
						Ball_Y_Motion <= 0;
					end
				else
					begin
						if (HitWaterD)
							begin
									Ball_X_Motion <= 2;
									Ball_Y_Motion <= 0;
							end
						else 
							begin
									Ball_X_Motion <= 1;
									Ball_Y_Motion <= 0;
							end
					end	
			end

		else if (keycode == 8'h51 || keycode2 == 8'h51 || keycode3 == 8'h51 || keycode4 == 8'h51)  //S
			begin
				if (HitWallS || HitIronS || (!((Ball_Y_Pos + Ball_Y_Motion) < (Ball_Y_Max - Ball_Size))))
					begin
						Ball_Y_Motion <= 0;
						Ball_X_Motion <= 0;
					end
				else
					begin
						if (HitWaterS)
							begin
									Ball_X_Motion <= 0;
									Ball_Y_Motion <= 2;
							end
						else 
							begin
									Ball_X_Motion <= 0;
									Ball_Y_Motion <= 1;
							end
					end
			end
			
		else if (keycode == 8'h52 || keycode2 == 8'h52 || keycode3 == 8'h52 || keycode4 == 8'h52)  //W
			begin
				if (HitWallW || HitIronW || (!((Ball_Y_Pos + Ball_Y_Motion) > (Ball_Y_Min + Ball_Size))))
					begin
						Ball_Y_Motion <= 0;
						Ball_X_Motion <= 0;
					end
				else
					begin
						if (HitWaterW)
							begin
									Ball_X_Motion <= 0;
									Ball_Y_Motion <= -2;
							end
						else 
							begin
									Ball_X_Motion <= 0;
									Ball_Y_Motion <= -1;
							end
					end
			end
		
		else 
			begin
				Ball_X_Motion <= 0;
				Ball_Y_Motion <= 0;
			end 
			
	   if (!(tankhitA || tankhitD || tankhitS || tankhitW || (BulletHittank && Is_bullet_on)))
			begin
				Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			end
	end  
end
 
assign BallX = Ball_X_Pos;

assign BallY = Ball_Y_Pos;

assign BallS = Ball_Size;

assign BallX_Motion = Ball_X_Motion;

assign BallY_Motion = Ball_Y_Motion;

endmodule














































////-------------------------------------------------------------------------
////    Ball.sv                                                            --
////    Viral Mehta                                                        --
////    Spring 2005                                                        --
////                                                                       --
////    Modified by Stephen Kempf 03-01-2006                               --
////                              03-12-2007                               --
////    Translated by Joe Meng    07-07-2013                               --
////    Fall 2014 Distribution                                             --
////                                                                       --
////    For use with ECE 298 Lab 7                                         --
////    UIUC ECE Department                                                --
////-------------------------------------------------------------------------
//
//
//module  ball ( input  Reset, frame_clk, HitIronA, HitIronD, HitIronS, HitIronW,
//			      input  [7:0]   keycode, keycode2,
//               output logic [9:0]  BallX, BallY, BallS, BallX_Motion, BallY_Motion, Ball_X_future, Ball_Y_future );
//    
//    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
//	 logic [2:0] LastDirect;
//    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
//    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
//    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
//    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
//    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
//    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
//	 parameter [9:0] IronX3=80;  // Center position on the X axis
//	 parameter [9:0] IronY3=303;  // Center position on the Y axis
//
//
//	 
//
//    assign Ball_Size = 16;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
//    
//    always_ff @ (posedge Reset or posedge frame_clk )
//    begin: Move_Ball
//        if (Reset)  // Asynchronous Reset
//        begin 
//         Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
//			Ball_X_Motion <= 10'd0; //Ball_X_Step;
//			Ball_Y_Pos <= Ball_Y_Center;
//			Ball_X_Pos <= Ball_X_Center;
//			LastDirect <= 3'h0;
//        end
//        else 
//        begin 
//			
//			if ((keycode == 8'h04) || (keycode2 == 8'h04))  //A
//				begin
//					if (HitIronA)
//					begin
//						Ball_X_Motion <= 0;
//						Ball_Y_Motion <= 0;
//
//					end
//					
//					else if ((Ball_X_Pos + Ball_X_Motion) > (Ball_X_Min + Ball_Size))
//					begin
//						Ball_X_Motion <= -1;//A
//						Ball_Y_Motion <= 0;
//					end
//					
//					else
//					begin
//						Ball_X_Motion <= 0;
//						Ball_Y_Motion <= 0;
//					end				
//				end
//			
//			else if ((keycode == 8'h07) || (keycode2 == 8'h07)) 	   //D
//				begin
////					if ((Ball_X_Pos + Ball_Size + Ball_X_Motion >= IronX3 - Ball_Size)
////						&& (Ball_Y_Pos + Ball_Size > IronY3 - Ball_Size)
////						&& (Ball_Y_Pos - Ball_Size < IronY3 + Ball_Size)
////						&& !(Ball_X_Pos + Ball_X_Motion - Ball_Size >= IronX3 + Ball_Size))
//					if (HitIronD)
//					begin
//						Ball_X_Motion <= 0;
//						Ball_Y_Motion <= 0;
//					end
//					
//					else if ((Ball_X_Pos + Ball_X_Motion) < (Ball_X_Max - Ball_Size))
//					begin
//						Ball_X_Motion <= 1;//D
//						Ball_Y_Motion <= 0;
//					end	
//					else
//					begin
//						Ball_X_Motion <= 0;
//						Ball_Y_Motion <= 0;
//					end
//					
//				end
//
//				
//				
//			else if ((keycode == 8'h16) || (keycode2 == 8'h16))   //S
//				begin
////					if ((Ball_X_Pos + Ball_Size > IronX3 - Ball_Size)
////						&& (Ball_X_Pos - Ball_Size < IronX3 + Ball_Size)
////						&& (Ball_Y_Pos + Ball_Y_Motion + Ball_Size >= IronY3 - Ball_Size)
////						&& !(Ball_Y_Pos + Ball_Y_Motion - Ball_Size >= IronY3 + Ball_Size))
//					if (HitIronS)
//					begin
//						Ball_Y_Motion <= 0;
//						Ball_X_Motion <= 0;
//					end
//					
//					else if ((Ball_Y_Pos + Ball_Y_Motion) < (Ball_Y_Max - Ball_Size))
//					begin
//						Ball_Y_Motion <= 1;//S
//						Ball_X_Motion <= 0;
//					end
//					else
//					begin
//						Ball_X_Motion <= 0;
//						Ball_Y_Motion <= 0;
//					end
//					
//				end
//
//				
//				
//			else if ((keycode == 8'h1A) || (keycode2 == 8'h1A))  //W
//				begin
////					if ((Ball_X_Pos + Ball_Size > IronX3 - Ball_Size)
////						&& (Ball_Y_Pos + Ball_Y_Motion - Ball_Size <= IronY3 + Ball_Size)
////						&& (Ball_X_Pos - Ball_Size < IronX3 + Ball_Size) 
////						&& !(Ball_Y_Pos + Ball_Y_Motion + Ball_Size <= IronY3 - Ball_Size))
//					if (HitIronW)
//					begin
//						Ball_Y_Motion <= 0;
//						Ball_X_Motion <= 0;
//					end
//						
//					else if ((Ball_Y_Pos + Ball_Y_Motion) > (Ball_Y_Min + Ball_Size)) 
//					begin
//						Ball_Y_Motion <= -1;//W
//						Ball_X_Motion <= 0;
//					end
//					else
//					begin
//						Ball_X_Motion <= 0;
//						Ball_Y_Motion <= 0;
//					end
//					
//				end
//			
//			else 
//				begin
//					Ball_X_Motion <= 0;
//					Ball_Y_Motion <= 0;
//				end 
//				
//				
//				
//			Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
//			Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
//			
//			
//			
//		end  
//    end
//       
//    assign BallX = Ball_X_Pos;
//   
//    assign BallY = Ball_Y_Pos;
//   
//    assign BallS = Ball_Size;
//	 
//	 assign BallX_Motion = Ball_X_Motion;
//    
//	 assign BallY_Motion = Ball_Y_Motion;
//
//endmodule


