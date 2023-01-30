module  collision    ( input               			 Clk, Reset, 
							  input         [9:0] 			 BallX,  BallY,  BallS,  BallX_Motion,  BallY_Motion,  BulletX,  BulletY,  BulletS,  BulletX_Motion,  BulletY_Motion,
							  input         [9:0] 			 BallX2, BallY2, BallS2, BallX_Motion2, BallY_Motion2, BulletX2, BulletY2, BulletS2, BulletX_Motion2, BulletY_Motion2,
                       output logic 		 		 	 HitIronA,  HitIronS,  HitIronD,  HitIronW,  HitIron,
							  output logic 					 HitIronA2, HitIronS2, HitIronD2, HitIronW2, HitIron2, 
							  output logic 					 HitWaterA,  HitWaterS,  HitWaterD,  HitWaterW,  HitWallA,  HitWallS,  HitWallD,  HitWallW,  HitWall,
							  output logic 					 HitWaterA2, HitWaterS2, HitWaterD2, HitWaterW2, HitWallA2, HitWallS2, HitWallD2, HitWallW2, HitWall2,
							  output logic 					 tankhitA, tankhitD, tankhitS, tankhitW, BulletHittank2, Bullet2Hittank, Player1wins, Player2wins,
							  output logic  [291:0][9:0] 	 WallHitArray_out, WallHitArray_out2);
						  

parameter [9:0] TankBlockWidth = 14;


// tank hit tank

logic tankhitA00, tankhitD00, tankhitS00, tankhitW00;
always_comb
begin
		if ((BallX + BallX_Motion - TankBlockWidth <= BallX2 + BallX_Motion2 + TankBlockWidth)
			&& (BallY + TankBlockWidth > BallY2 + BallY_Motion2 - TankBlockWidth)
			&& (BallY - TankBlockWidth < BallY2 + BallY_Motion2 + TankBlockWidth)
			&& !(BallX + BallX_Motion + TankBlockWidth <= BallX2 + BallX_Motion2 - TankBlockWidth))
			tankhitA00 = 1;
		else 
			tankhitA00 = 0;
		
		if ((BallX + TankBlockWidth + BallX_Motion >= BallX2 + BallX_Motion2 - TankBlockWidth)
			&& (BallY + TankBlockWidth > BallY2 + BallY_Motion2 - TankBlockWidth)
		   && (BallY - TankBlockWidth < BallY2 + BallY_Motion2 + TankBlockWidth)
			&& !(BallX + BallX_Motion - TankBlockWidth >= BallX2 + BallX_Motion2 + TankBlockWidth))
			tankhitD00 = 1;
		else 
			tankhitD00 = 0;

		if ((BallX + TankBlockWidth > BallX2 + BallX_Motion2 - TankBlockWidth)
			&& (BallX - TankBlockWidth < BallX2 + BallX_Motion2 + TankBlockWidth)
			&& (BallY + BallY_Motion + TankBlockWidth >= BallY2 + BallY_Motion2 - TankBlockWidth)
			&& !(BallY + BallY_Motion - TankBlockWidth >= BallY2 + BallY_Motion2 + TankBlockWidth))
			tankhitS00 = 1;
		else 
			tankhitS00 = 0;
			
		if ((BallX + TankBlockWidth > BallX2 + BallX_Motion2 - TankBlockWidth)
			&& (BallY + BallY_Motion - TankBlockWidth <= BallY2 + BallY_Motion2 + TankBlockWidth)
			&& (BallX - TankBlockWidth < BallX2 + BallX_Motion2 + TankBlockWidth) 
			&& !(BallY + BallY_Motion + TankBlockWidth <= BallY2 + BallY_Motion2 - TankBlockWidth))
			tankhitW00 = 1;
		else 
			tankhitW00 = 0;

end


assign tankhitA = tankhitA00;
assign tankhitD = tankhitD00;
assign tankhitS = tankhitS00;
assign tankhitW = tankhitW00;





logic BulletHittank200, Bullet2Hittank00;

always_comb 
begin

	if ((BulletX + BulletX_Motion + BulletS >= BallX2 + BallX_Motion2 - BallS2)
	 && (BulletX + BulletX_Motion - BulletS <= BallX2 + BallX_Motion2 + BallS2)
	 && (BulletY + BulletY_Motion + BulletS >= BallY2 + BallY_Motion2 - BallS2)
	 && (BulletY + BulletY_Motion - BulletS <= BallY2 + BallY_Motion2 + BallS2))
		BulletHittank200 = 1;
	else
		BulletHittank200 = 0;

	if ((BulletX2 + BulletX_Motion2 + BulletS2 >= BallX + BallX_Motion - BallS)
	 && (BulletX2 + BulletX_Motion2 - BulletS2 <= BallX + BallX_Motion + BallS)
	 && (BulletY2 + BulletY_Motion2 + BulletS2 >= BallY + BallY_Motion - BallS)
	 && (BulletY2 + BulletY_Motion2 - BulletS2 <= BallY + BallY_Motion + BallS))
		Bullet2Hittank00 = 1;
	else
		Bullet2Hittank00 = 0;

end 


assign BulletHittank2 = BulletHittank200;
assign Bullet2Hittank = Bullet2Hittank00;









// bullet hit hq

parameter [9:0] hqX=319;  // Center position on the X axis
parameter [9:0] hqY=463;  // Center position on the Y axis

parameter [9:0] hqX2=319;  // Center position on the X axis
parameter [9:0] hqY2=16;  // Center position on the Y axis

parameter [9:0] hqsize=16;  // Center position on the Y axis


logic Player1wins0, Player2wins0;

always_comb 
begin

	if (((BulletX + BulletX_Motion + BulletS >= hqX2 - hqsize)
	  && (BulletX + BulletX_Motion - BulletS <= hqX2 + hqsize)
	  && (BulletY + BulletY_Motion + BulletS >= hqY2 - hqsize)
	  && (BulletY + BulletY_Motion - BulletS <= hqY2 + hqsize))
	 || ((BulletX2 + BulletX_Motion2 + BulletS2 >= hqX2 - hqsize)
	  && (BulletX2 + BulletX_Motion2 - BulletS2 <= hqX2 + hqsize)
	  && (BulletY2 + BulletY_Motion2 + BulletS2 >= hqY2 - hqsize)
	  && (BulletY2 + BulletY_Motion2 - BulletS2 <= hqY2 + hqsize)))
		Player1wins0 = 1;
	else
		Player1wins0 = 0;

	if (((BulletX + BulletX_Motion + BulletS >= hqX - hqsize)
	  && (BulletX + BulletX_Motion - BulletS <= hqX + hqsize)
	  && (BulletY + BulletY_Motion + BulletS >= hqY - hqsize)
	  && (BulletY + BulletY_Motion - BulletS <= hqY + hqsize))
	 || ((BulletX2 + BulletX_Motion2 + BulletS2 >= hqX - hqsize)
	  && (BulletX2 + BulletX_Motion2 - BulletS2 <= hqX + hqsize)
	  && (BulletY2 + BulletY_Motion2 + BulletS2 >= hqY - hqsize)
	  && (BulletY2 + BulletY_Motion2 - BulletS2 <= hqY + hqsize)))
		Player2wins0 = 1;
	else
		Player2wins0 = 0;

end 




assign Player1wins = Player1wins0;
assign Player2wins = Player2wins0;

















						  





//////////// check for Wall Hit //////////////
parameter [9:0] WallSize = 292;
parameter [9:0] WallBlockWidth = 8;
logic [WallSize-1:0][9:0] WallHitArray, WallHitArray2;

always_ff @ (posedge Clk or posedge Reset) 
begin 
	if (Reset) 
	begin 
		for (int i = 0; i < WallSize; i++)
		begin
			WallHitArray[i] <= 0;
			WallHitArray2[i] <= 0;
		end
	end
	
	else 
	begin 
		for (int i = 0; i < WallSize; i++)
		begin
			if (((BulletX + BulletX_Motion + BulletS >= WallXarray[i] - WallBlockWidth)
			&& (BulletX + BulletX_Motion - BulletS <= WallXarray[i] + WallBlockWidth)
			&& (BulletY + BulletY_Motion + BulletS >= WallYarray[i] - WallBlockWidth)
			&& (BulletY + BulletY_Motion - BulletS <= WallYarray[i] + WallBlockWidth)))
				WallHitArray[i] <= 1;
		end
		
		for (int i = 0; i < WallSize; i++)
		begin
			if (((BulletX2 + BulletX_Motion2 + BulletS2 >= WallXarray[i] - WallBlockWidth)
			&& (BulletX2 + BulletX_Motion2 - BulletS2 <= WallXarray[i] + WallBlockWidth)
			&& (BulletY2 + BulletY_Motion2 + BulletS2 >= WallYarray[i] - WallBlockWidth)
			&& (BulletY2 + BulletY_Motion2 - BulletS2 <= WallYarray[i] + WallBlockWidth)))
				WallHitArray2[i] <= 1;
		end
	end
end 

assign WallHitArray_out = WallHitArray;
assign WallHitArray_out2 = WallHitArray2;






// Iron collision check

parameter [9:0] IronSize = 21;
parameter [9:0] IronBlockWidth = 16;


logic AAA,  SSS,  WWW,  DDD,  HHH;
logic AAA2, SSS2, WWW2, DDD2, HHH2;
logic [IronSize-1:0] IroncheckA,  IroncheckS,  IroncheckD,  IroncheckW,  BulletHitIron;
logic [IronSize-1:0] IroncheckA2, IroncheckS2, IroncheckD2, IroncheckW2, BulletHitIron2;
logic [IronSize-1:0][9:0] IronXarray, IronYarray;

assign IronXarray = '{16,  48,  80,  80,  559, 527, 144, 177, 432, 432, 432, 287, 351, 319, 287, 351, 319, 464, 528, 528, 240};

assign IronYarray = '{271, 271, 271, 303, 144, 144, 80,  80,  240, 272, 304,  80,  80,  80, 400, 400, 400, 464, 16,  48, 464};

// tank0 & bullet0
always_comb
begin
		for (int i = 0; i < IronSize; i++)
		begin
			if ((BallX + BallX_Motion - TankBlockWidth <= IronXarray[i] + IronBlockWidth)
			&& (BallY + TankBlockWidth > IronYarray[i] - IronBlockWidth)
			&& (BallY - TankBlockWidth < IronYarray[i] + IronBlockWidth)
			&& !(BallX + BallX_Motion + TankBlockWidth <= IronXarray[i] - IronBlockWidth))
			IroncheckA[i] = 1;
		else 
			IroncheckA[i] = 0;
		end
			
		for (int i = 0; i < IronSize; i++)
		begin
			if ((BallX + TankBlockWidth + BallX_Motion >= IronXarray[i] - IronBlockWidth)
			&& (BallY + TankBlockWidth > IronYarray[i] - IronBlockWidth)
		   && (BallY - TankBlockWidth < IronYarray[i] + IronBlockWidth)
			&& !(BallX + BallX_Motion - TankBlockWidth >= IronXarray[i] + IronBlockWidth))
			IroncheckD[i] = 1;
		else 
			IroncheckD[i] = 0;
		end
		
		for (int i = 0; i < IronSize; i++)
		begin
			if ((BallX + TankBlockWidth > IronXarray[i] - IronBlockWidth)
			&& (BallX - TankBlockWidth < IronXarray[i] + IronBlockWidth)
			&& (BallY + BallY_Motion + TankBlockWidth >= IronYarray[i] - IronBlockWidth)
			&& !(BallY + BallY_Motion - TankBlockWidth >= IronYarray[i] + IronBlockWidth))
			IroncheckS[i] = 1;
		else 
			IroncheckS[i] = 0;
		end
			
		for (int i = 0; i < IronSize; i++)
		begin
			if ((BallX + TankBlockWidth > IronXarray[i] - IronBlockWidth)
			&& (BallY + BallY_Motion - TankBlockWidth <= IronYarray[i] + IronBlockWidth)
			&& (BallX - TankBlockWidth < IronXarray[i] + IronBlockWidth) 
			&& !(BallY + BallY_Motion + TankBlockWidth <= IronYarray[i] - IronBlockWidth))
			IroncheckW[i] = 1;
		else 
			IroncheckW[i] = 0;
		end
			
			
		// bullet collision
		for (int i = 0; i < IronSize; i++)
		begin
			if ((BulletX + BulletX_Motion + BulletS >= IronXarray[i] - IronBlockWidth)
			&& (BulletX + BulletX_Motion - BulletS <= IronXarray[i] + IronBlockWidth)
			&& (BulletY + BulletY_Motion + BulletS >= IronYarray[i] - IronBlockWidth)
			&& (BulletY + BulletY_Motion - BulletS <= IronYarray[i] + IronBlockWidth))
				BulletHitIron[i] = 1;
			else
				BulletHitIron[i] = 0;
		end

end

always_comb
begin
	for (int i = 0; i < IronSize; i++)
	begin
		if (i == 0)
		begin
			AAA = IroncheckA[0];
			SSS = IroncheckS[0];
			WWW = IroncheckW[0];
			DDD = IroncheckD[0];
			HHH = BulletHitIron[0];
		end
		else 
		begin
			AAA = AAA || IroncheckA[i];
			SSS = SSS || IroncheckS[i];
			WWW = WWW || IroncheckW[i];
			DDD = DDD || IroncheckD[i];
			HHH = HHH || BulletHitIron[i];
		end
	end
	HitIronA = AAA;
	HitIronS = SSS;
	HitIronW = WWW;
	HitIronD = DDD;
	HitIron = HHH;
end



// tank2 & bullet2
always_comb
begin
		for (int i = 0; i < IronSize; i++)
		begin
			if ((BallX2 + BallX_Motion2 - TankBlockWidth <= IronXarray[i] + IronBlockWidth)
			&& (BallY2 + TankBlockWidth > IronYarray[i] - IronBlockWidth)
			&& (BallY2 - TankBlockWidth < IronYarray[i] + IronBlockWidth)
			&& !(BallX2 + BallX_Motion2 + TankBlockWidth <= IronXarray[i] - IronBlockWidth))
			IroncheckA2[i] = 1;
		else 
			IroncheckA2[i] = 0;
		end
			
		for (int i = 0; i < IronSize; i++)
		begin
			if ((BallX2 + TankBlockWidth + BallX_Motion2 >= IronXarray[i] - IronBlockWidth)
			&& (BallY2 + TankBlockWidth > IronYarray[i] - IronBlockWidth)
		   && (BallY2 - TankBlockWidth < IronYarray[i] + IronBlockWidth)
			&& !(BallX2 + BallX_Motion2 - TankBlockWidth >= IronXarray[i] + IronBlockWidth))
			IroncheckD2[i] = 1;
		else 
			IroncheckD2[i] = 0;
		end
		
		for (int i = 0; i < IronSize; i++)
		begin
			if ((BallX2 + TankBlockWidth > IronXarray[i] - IronBlockWidth)
			&& (BallX2 - TankBlockWidth < IronXarray[i] + IronBlockWidth)
			&& (BallY2 + BallY_Motion2 + TankBlockWidth >= IronYarray[i] - IronBlockWidth)
			&& !(BallY2 + BallY_Motion2 - TankBlockWidth >= IronYarray[i] + IronBlockWidth))
			IroncheckS2[i] = 1;
		else 
			IroncheckS2[i] = 0;
		end
			
		for (int i = 0; i < IronSize; i++)
		begin
			if ((BallX2 + TankBlockWidth > IronXarray[i] - IronBlockWidth)
			&& (BallY2 + BallY_Motion2 - TankBlockWidth <= IronYarray[i] + IronBlockWidth)
			&& (BallX2 - TankBlockWidth < IronXarray[i] + IronBlockWidth) 
			&& !(BallY2 + BallY_Motion2 + TankBlockWidth <= IronYarray[i] - IronBlockWidth))
			IroncheckW2[i] = 1;
		else 
			IroncheckW2[i] = 0;
		end
			
			
		// bullet collision
		for (int i = 0; i < IronSize; i++)
		begin
			if ((BulletX2 + BulletX_Motion2 + BulletS2 >= IronXarray[i] - IronBlockWidth)
			&& (BulletX2 + BulletX_Motion2 - BulletS2 <= IronXarray[i] + IronBlockWidth)
			&& (BulletY2 + BulletY_Motion2 + BulletS2 >= IronYarray[i] - IronBlockWidth)
			&& (BulletY2 + BulletY_Motion2 - BulletS2 <= IronYarray[i] + IronBlockWidth))
				BulletHitIron2[i] = 1;
			else
				BulletHitIron2[i] = 0;
		end

end


always_comb
begin
	for (int i = 0; i < IronSize; i++)
	begin
		if (i == 0)
		begin
			AAA2 = IroncheckA2[0];
			SSS2 = IroncheckS2[0];
			WWW2 = IroncheckW2[0];
			DDD2 = IroncheckD2[0];
			HHH2 = BulletHitIron2[0];
		end
		else 
		begin
			AAA2 = AAA2 || IroncheckA2[i];
			SSS2 = SSS2 || IroncheckS2[i];
			WWW2 = WWW2 || IroncheckW2[i];
			DDD2 = DDD2 || IroncheckD2[i];
			HHH2 = HHH2 || BulletHitIron2[i];
		end
	end
	HitIronA2 = AAA2;
	HitIronS2 = SSS2;
	HitIronW2 = WWW2;
	HitIronD2 = DDD2;
	HitIron2 = HHH2;
end











// Water collision check

parameter [9:0] WaterSize = 23;
parameter [9:0] WaterBlockWidth = 15;

logic AAA_water, SSS_water, WWW_water, DDD_water;
logic AAA_water2, SSS_water2, WWW_water2, DDD_water2;

logic [WaterSize-1:0] WatercheckA, WatercheckS, WatercheckD, WatercheckW;
logic [WaterSize-1:0] WatercheckA2, WatercheckS2, WatercheckD2, WatercheckW2;

logic [WaterSize-1:0][9:0] WaterXarray, WaterYarray;

assign WaterXarray = '{287, 254, 221, 287, 287, 287, 287, 287, 255, 223, 191, 159, 319, 351, 383, 527, 527, 527, 527, 559, 591, 48,  80};
assign WaterYarray = '{303, 303, 303, 271, 239, 207, 175, 143, 143, 143, 143, 143, 176, 176, 176, 208, 240, 272, 304, 304, 304, 206, 206};

// tank0 & bullet0
always_comb
begin
		for (int i = 0; i < WaterSize; i++)
		begin
			if ((BallX + BallX_Motion - TankBlockWidth <= WaterXarray[i] + WaterBlockWidth)
			&& (BallY + TankBlockWidth > WaterYarray[i] - WaterBlockWidth)
			&& (BallY - TankBlockWidth < WaterYarray[i] + WaterBlockWidth)
			&& !(BallX + BallX_Motion + TankBlockWidth <= WaterXarray[i] - WaterBlockWidth))
			WatercheckA[i] = 1;
		else 
			WatercheckA[i] = 0;
		end
			
		for (int i = 0; i < WaterSize; i++)
		begin
			if ((BallX + TankBlockWidth + BallX_Motion >= WaterXarray[i] - WaterBlockWidth)
			&& (BallY + TankBlockWidth > WaterYarray[i] - WaterBlockWidth)
		   && (BallY - TankBlockWidth < WaterYarray[i] + WaterBlockWidth)
			&& !(BallX + BallX_Motion - TankBlockWidth >= WaterXarray[i] + WaterBlockWidth))
			WatercheckD[i] = 1;
		else 
			WatercheckD[i] = 0;
		end
		
		for (int i = 0; i < WaterSize; i++)
		begin
			if ((BallX + TankBlockWidth > WaterXarray[i] - WaterBlockWidth)
			&& (BallX - TankBlockWidth < WaterXarray[i] + WaterBlockWidth)
			&& (BallY + BallY_Motion + TankBlockWidth >= WaterYarray[i] - WaterBlockWidth)
			&& !(BallY + BallY_Motion - TankBlockWidth >= WaterYarray[i] + WaterBlockWidth))
			WatercheckS[i] = 1;
		else 
			WatercheckS[i] = 0;
		end
			
		for (int i = 0; i < WaterSize; i++)
		begin
			if ((BallX + TankBlockWidth > WaterXarray[i] - WaterBlockWidth)
			&& (BallY + BallY_Motion - TankBlockWidth <= WaterYarray[i] + WaterBlockWidth)
			&& (BallX - TankBlockWidth < WaterXarray[i] + WaterBlockWidth) 
			&& !(BallY + BallY_Motion + TankBlockWidth <= WaterYarray[i] - WaterBlockWidth))
			WatercheckW[i] = 1;
		else 
			WatercheckW[i] = 0;
		end
			
end


always_comb
begin
	for (int i = 0; i < WaterSize; i++)
	begin
		if (i == 0)
		begin
			AAA_water = WatercheckA[0];
			SSS_water = WatercheckS[0];
			WWW_water = WatercheckW[0];
			DDD_water = WatercheckD[0];
		end
		else 
		begin
			AAA_water = AAA_water || WatercheckA[i];
			SSS_water = SSS_water || WatercheckS[i];
			WWW_water = WWW_water || WatercheckW[i];
			DDD_water = DDD_water || WatercheckD[i];
		end
	end
	HitWaterA = AAA_water;
	HitWaterS = SSS_water;
	HitWaterW = WWW_water;
	HitWaterD = DDD_water;
end




// tank2 & bullet2

always_comb
begin
		for (int i = 0; i < WaterSize; i++)
		begin
			if ((BallX2 + BallX_Motion2 - TankBlockWidth <= WaterXarray[i] + WaterBlockWidth)
			&& (BallY2 + TankBlockWidth > WaterYarray[i] - WaterBlockWidth)
			&& (BallY2 - TankBlockWidth < WaterYarray[i] + WaterBlockWidth)
			&& !(BallX2 + BallX_Motion2 + TankBlockWidth <= WaterXarray[i] - WaterBlockWidth))
			WatercheckA2[i] = 1;
		else 
			WatercheckA2[i] = 0;
		end
			
		for (int i = 0; i < WaterSize; i++)
		begin
			if ((BallX2 + TankBlockWidth + BallX_Motion2 >= WaterXarray[i] - WaterBlockWidth)
			&& (BallY2 + TankBlockWidth > WaterYarray[i] - WaterBlockWidth)
		   && (BallY2 - TankBlockWidth < WaterYarray[i] + WaterBlockWidth)
			&& !(BallX2 + BallX_Motion2 - TankBlockWidth >= WaterXarray[i] + WaterBlockWidth))
			WatercheckD2[i] = 1;
		else 
			WatercheckD2[i] = 0;
		end
		
		for (int i = 0; i < WaterSize; i++)
		begin
			if ((BallX2 + TankBlockWidth > WaterXarray[i] - WaterBlockWidth)
			&& (BallX2 - TankBlockWidth < WaterXarray[i] + WaterBlockWidth)
			&& (BallY2 + BallY_Motion2 + TankBlockWidth >= WaterYarray[i] - WaterBlockWidth)
			&& !(BallY2 + BallY_Motion2 - TankBlockWidth >= WaterYarray[i] + WaterBlockWidth))
			WatercheckS2[i] = 1;
		else 
			WatercheckS2[i] = 0;
		end
			
		for (int i = 0; i < WaterSize; i++)
		begin
			if ((BallX2 + TankBlockWidth > WaterXarray[i] - WaterBlockWidth)
			&& (BallY2 + BallY_Motion2 - TankBlockWidth <= WaterYarray[i] + WaterBlockWidth)
			&& (BallX2 - TankBlockWidth < WaterXarray[i] + WaterBlockWidth) 
			&& !(BallY2 + BallY_Motion2 + TankBlockWidth <= WaterYarray[i] - WaterBlockWidth))
			WatercheckW2[i] = 1;
		else 
			WatercheckW2[i] = 0;
		end
			
end


always_comb
begin
	for (int i = 0; i < WaterSize; i++)
	begin
		if (i == 0)
		begin
			AAA_water2 = WatercheckA2[0];
			SSS_water2 = WatercheckS2[0];
			WWW_water2 = WatercheckW2[0];
			DDD_water2 = WatercheckD2[0];
		end
		else 
		begin
			AAA_water2 = AAA_water2 || WatercheckA2[i];
			SSS_water2 = SSS_water2 || WatercheckS2[i];
			WWW_water2 = WWW_water2 || WatercheckW2[i];
			DDD_water2 = DDD_water2 || WatercheckD2[i];
		end
	end
	HitWaterA2 = AAA_water2;
	HitWaterS2 = SSS_water2;
	HitWaterW2 = WWW_water2;
	HitWaterD2 = DDD_water2;
end





// Wall collision check

logic AAA_wall,  SSS_wall,  WWW_wall,  DDD_wall,  HHH_wall;
logic AAA_wall2, SSS_wall2, WWW_wall2, DDD_wall2, HHH_wall2;
logic [WallSize-1:0] WallcheckA,  WallcheckS,  WallcheckD,  WallcheckW,  BulletHitWall;
logic [WallSize-1:0] WallcheckA2, WallcheckS2, WallcheckD2, WallcheckW2, BulletHitWall2;
logic [WallSize-1:0][9:0] WallXarray, WallYarray;


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

// tank0 & bullet0

always_comb
begin
		for (int i = 0; i < WallSize; i++)
		begin
		if ((BallX + BallX_Motion - TankBlockWidth <= WallXarray[i] + WallBlockWidth)
			&& (BallY + TankBlockWidth > WallYarray[i] - WallBlockWidth)
			&& (BallY - TankBlockWidth < WallYarray[i] + WallBlockWidth)
			&& !(BallX + BallX_Motion + TankBlockWidth <= WallXarray[i] - WallBlockWidth))
			begin
				if (WallHitArray[i] || WallHitArray2[i])
					WallcheckA[i] = 0;
				else 
					WallcheckA[i] = 1;
			end
		else 
			WallcheckA[i] = 0;
		end


		for (int i = 0; i < WallSize; i++)
		begin
		if ((BallX + TankBlockWidth + BallX_Motion >= WallXarray[i] - WallBlockWidth)
			&& (BallY + TankBlockWidth > WallYarray[i] - WallBlockWidth)
		   && (BallY - TankBlockWidth < WallYarray[i] + WallBlockWidth)
			&& !(BallX + BallX_Motion - TankBlockWidth >= WallXarray[i] + WallBlockWidth))
			begin
				if (WallHitArray[i] || WallHitArray2[i])
					WallcheckD[i] = 0;
				else 
					WallcheckD[i] = 1;
			end
		else 
			WallcheckD[i] = 0;
		end

			
		for (int i = 0; i < WallSize; i++)
		begin
		if ((BallX + TankBlockWidth > WallXarray[i] - WallBlockWidth)
			&& (BallX - TankBlockWidth < WallXarray[i] + WallBlockWidth)
			&& (BallY + BallY_Motion + TankBlockWidth >= WallYarray[i] - WallBlockWidth)
			&& !(BallY + BallY_Motion - TankBlockWidth >= WallYarray[i] + WallBlockWidth))
			begin
				if (WallHitArray[i] || WallHitArray2[i])
					WallcheckS[i] = 0;
				else 
					WallcheckS[i] = 1;
			end
		else 
			WallcheckS[i] = 0;
		end	

					
		for (int i = 0; i < WallSize; i++)
		begin
		if ((BallX + TankBlockWidth > WallXarray[i] - WallBlockWidth)
			&& (BallY + BallY_Motion - TankBlockWidth <= WallYarray[i] + WallBlockWidth)
			&& (BallX - TankBlockWidth < WallXarray[i] + WallBlockWidth) 
			&& !(BallY + BallY_Motion + TankBlockWidth <= WallYarray[i] - WallBlockWidth))
			begin
				if (WallHitArray[i] || WallHitArray2[i])
					WallcheckW[i] = 0;
				else 
					WallcheckW[i] = 1;
			end
		else 
			WallcheckW[i] = 0;
		end
		
		
		for (int i = 0; i < WallSize; i++)
		begin
			if ((BulletX + BulletX_Motion + BulletS >= WallXarray[i] - WallBlockWidth)
			&& (BulletX + BulletX_Motion - BulletS <= WallXarray[i] + WallBlockWidth)
			&& (BulletY + BulletY_Motion + BulletS >= WallYarray[i] - WallBlockWidth)
			&& (BulletY + BulletY_Motion - BulletS <= WallYarray[i] + WallBlockWidth))
			begin
				if (WallHitArray[i] || WallHitArray2[i])
					BulletHitWall[i] = 0;
				else 
					BulletHitWall[i] = 1;
			end
		else 
			BulletHitWall[i] = 0;
		end

end


always_comb
begin
	for (int i = 0; i < WallSize; i++)
	begin
		if (i == 0)
		begin
			AAA_wall = WallcheckA[0];
			SSS_wall = WallcheckS[0];
			WWW_wall = WallcheckW[0];
			DDD_wall = WallcheckD[0];
			HHH_wall = BulletHitWall[0];
		end
		else 
		begin
			AAA_wall = AAA_wall || WallcheckA[i];
			SSS_wall = SSS_wall || WallcheckS[i];
			WWW_wall = WWW_wall || WallcheckW[i];
			DDD_wall = DDD_wall || WallcheckD[i];
			HHH_wall = HHH_wall || BulletHitWall[i];
		end
	end
	HitWallA = AAA_wall;
	HitWallS = SSS_wall;
	HitWallW = WWW_wall;
	HitWallD = DDD_wall;
	HitWall = HHH_wall;
end



// tank2 & bullet2

always_comb
begin
		for (int i = 0; i < WallSize; i++)
		begin
		if ((BallX2 + BallX_Motion2 - TankBlockWidth <= WallXarray[i] + WallBlockWidth)
			&& (BallY2 + TankBlockWidth > WallYarray[i] - WallBlockWidth)
			&& (BallY2 - TankBlockWidth < WallYarray[i] + WallBlockWidth)
			&& !(BallX2 + BallX_Motion2 + TankBlockWidth <= WallXarray[i] - WallBlockWidth))
			begin
				if (WallHitArray[i] || WallHitArray2[i])
					WallcheckA2[i] = 0;
				else 
					WallcheckA2[i] = 1;
			end
		else 
			WallcheckA2[i] = 0;
		end


		for (int i = 0; i < WallSize; i++)
		begin
		if ((BallX2 + TankBlockWidth + BallX_Motion2 >= WallXarray[i] - WallBlockWidth)
			&& (BallY2 + TankBlockWidth > WallYarray[i] - WallBlockWidth)
		   && (BallY2 - TankBlockWidth < WallYarray[i] + WallBlockWidth)
			&& !(BallX2 + BallX_Motion2 - TankBlockWidth >= WallXarray[i] + WallBlockWidth))
			begin
				if (WallHitArray[i] || WallHitArray2[i])
					WallcheckD2[i] = 0;
				else 
					WallcheckD2[i] = 1;
			end
		else 
			WallcheckD2[i] = 0;
		end

			
		for (int i = 0; i < WallSize; i++)
		begin
		if ((BallX2 + TankBlockWidth > WallXarray[i] - WallBlockWidth)
			&& (BallX2 - TankBlockWidth < WallXarray[i] + WallBlockWidth)
			&& (BallY2 + BallY_Motion2 + TankBlockWidth >= WallYarray[i] - WallBlockWidth)
			&& !(BallY2 + BallY_Motion2 - TankBlockWidth >= WallYarray[i] + WallBlockWidth))
			begin
				if (WallHitArray[i] || WallHitArray2[i])
					WallcheckS2[i] = 0;
				else 
					WallcheckS2[i] = 1;
			end
		else 
			WallcheckS2[i] = 0;
		end	

					
		for (int i = 0; i < WallSize; i++)
		begin
		if ((BallX2 + TankBlockWidth > WallXarray[i] - WallBlockWidth)
			&& (BallY2 + BallY_Motion2 - TankBlockWidth <= WallYarray[i] + WallBlockWidth)
			&& (BallX2 - TankBlockWidth < WallXarray[i] + WallBlockWidth) 
			&& !(BallY2 + BallY_Motion2 + TankBlockWidth <= WallYarray[i] - WallBlockWidth))
			begin
				if (WallHitArray[i] || WallHitArray2[i])
					WallcheckW2[i] = 0;
				else 
					WallcheckW2[i] = 1;
			end
		else 
			WallcheckW2[i] = 0;
		end
		
		
		for (int i = 0; i < WallSize; i++)
		begin
			if ((BulletX2 + BulletX_Motion2 + BulletS2 >= WallXarray[i] - WallBlockWidth)
			&& (BulletX2 + BulletX_Motion2 - BulletS2 <= WallXarray[i] + WallBlockWidth)
			&& (BulletY2 + BulletY_Motion2 + BulletS2 >= WallYarray[i] - WallBlockWidth)
			&& (BulletY2 + BulletY_Motion2 - BulletS2 <= WallYarray[i] + WallBlockWidth))
			begin
				if (WallHitArray[i] || WallHitArray2[i])
					BulletHitWall2[i] = 0;
				else 
					BulletHitWall2[i] = 1;
			end
		else 
			BulletHitWall2[i] = 0;
		end

end


always_comb
begin
	for (int i = 0; i < WallSize; i++)
	begin
		if (i == 0)
		begin
			AAA_wall2 = WallcheckA2[0];
			SSS_wall2 = WallcheckS2[0];
			WWW_wall2 = WallcheckW2[0];
			DDD_wall2 = WallcheckD2[0];
			HHH_wall2 = BulletHitWall2[0];
		end
		else 
		begin
			AAA_wall2 = AAA_wall2 || WallcheckA2[i];
			SSS_wall2 = SSS_wall2 || WallcheckS2[i];
			WWW_wall2 = WWW_wall2 || WallcheckW2[i];
			DDD_wall2 = DDD_wall2 || WallcheckD2[i];
			HHH_wall2 = HHH_wall2 || BulletHitWall2[i];
		end
	end
	HitWallA2 = AAA_wall2;
	HitWallS2 = SSS_wall2;
	HitWallW2 = WWW_wall2;
	HitWallD2 = DDD_wall2;
	HitWall2 = HHH_wall2;
end




endmodule


























































//module  collision    ( input               		 Clk, Reset, 
//							  input         [9:0] 			 BallX, BallY, BallS, BallX_Motion, BallY_Motion, BulletX, BulletY, BulletS, BulletX_Motion, BulletY_Motion,
//							  input		    [293:0][9:0]	 WallHitArray_in,
//                       output logic 		 		 	 HitIronA, HitIronS, HitIronD, HitIronW, HitIron,
//							  output logic 					 HitWaterA, HitWaterS, HitWaterD, HitWaterW, 
//							  output logic 					 HitWallA, HitWallS, HitWallD, HitWallW, HitWall,
//							  output logic  [293:0][9:0] 	 WallHitArray_out);
//
//
//parameter [9:0] WallSize = 294;
//parameter [9:0] WallBlockWidth = 8;
//
////////////// check for Wall Hit //////////////
//logic [WallSize-1:0][9:0] WallHitArray;
//
//always_ff @ (posedge Clk or posedge Reset) 
//begin 
//	if (Reset) 
//	begin 
//		for (int i = 0; i < WallSize; i++)
//		begin
//			WallHitArray[i] <= 0;
//		end
//	end
//	
//	else 
//	begin 
//		for (int i = 0; i < WallSize; i++)
//		begin
//			if ((BulletX + BulletX_Motion + 1 >= WallXarray[i] - WallBlockWidth)
//			&& (BulletX + BulletX_Motion - 1 <= WallXarray[i] + WallBlockWidth)
//			&& (BulletY + BulletY_Motion + 1 >= WallYarray[i] - WallBlockWidth)
//			&& (BulletY + BulletY_Motion - 1 <= WallYarray[i] + WallBlockWidth))
//				WallHitArray[i] <= 1;
//		end
//	end
//end 
//
//assign WallHitArray_out = WallHitArray;
//
//
//
//
//
//
//// Iron collision check
//
//parameter [9:0] IronSize = 21;
//parameter [9:0] IronBlockWidth = 16;
//parameter [9:0] TankBlockWidth = 15;
//
//logic AAA, SSS, WWW, DDD, HHH;
//logic [IronSize-1:0] IroncheckA, IroncheckS, IroncheckD, IroncheckW, BulletHitIron;
//logic [IronSize-1:0][9:0] IronXarray, IronYarray;
//
//assign IronXarray = '{16,  48,  80,  80,  559, 527, 144, 177, 432, 432, 432, 287, 351, 319, 287, 351, 319, 464, 528, 528, 240};
//
//assign IronYarray = '{271, 271, 271, 303, 144, 144, 77,  77,  240, 272, 304,  80,  80,  80, 400, 400, 400, 464, 16,  48, 464};
//
//
//always_comb
//begin
//		for (int i = 0; i < IronSize; i++)
//		begin
//			if ((BallX + BallX_Motion - TankBlockWidth <= IronXarray[i] + IronBlockWidth)
//			&& (BallY + TankBlockWidth > IronYarray[i] - IronBlockWidth)
//			&& (BallY - TankBlockWidth < IronYarray[i] + IronBlockWidth)
//			&& !(BallX + BallX_Motion + TankBlockWidth <= IronXarray[i] - IronBlockWidth))
//			IroncheckA[i] = 1;
//		else 
//			IroncheckA[i] = 0;
//		end
//			
//		for (int i = 0; i < IronSize; i++)
//		begin
//			if ((BallX + TankBlockWidth + BallX_Motion >= IronXarray[i] - IronBlockWidth)
//			&& (BallY + TankBlockWidth > IronYarray[i] - IronBlockWidth)
//		   && (BallY - TankBlockWidth < IronYarray[i] + IronBlockWidth)
//			&& !(BallX + BallX_Motion - TankBlockWidth >= IronXarray[i] + IronBlockWidth))
//			IroncheckD[i] = 1;
//		else 
//			IroncheckD[i] = 0;
//		end
//		
//		for (int i = 0; i < IronSize; i++)
//		begin
//			if ((BallX + TankBlockWidth > IronXarray[i] - IronBlockWidth)
//			&& (BallX - TankBlockWidth < IronXarray[i] + IronBlockWidth)
//			&& (BallY + BallY_Motion + TankBlockWidth >= IronYarray[i] - IronBlockWidth)
//			&& !(BallY + BallY_Motion - TankBlockWidth >= IronYarray[i] + IronBlockWidth))
//			IroncheckS[i] = 1;
//		else 
//			IroncheckS[i] = 0;
//		end
//			
//		for (int i = 0; i < IronSize; i++)
//		begin
//			if ((BallX + TankBlockWidth > IronXarray[i] - IronBlockWidth)
//			&& (BallY + BallY_Motion - TankBlockWidth <= IronYarray[i] + IronBlockWidth)
//			&& (BallX - TankBlockWidth < IronXarray[i] + IronBlockWidth) 
//			&& !(BallY + BallY_Motion + TankBlockWidth <= IronYarray[i] - IronBlockWidth))
//			IroncheckW[i] = 1;
//		else 
//			IroncheckW[i] = 0;
//		end
//			
//			
//		// bullet collision
//		for (int i = 0; i < IronSize; i++)
//		begin
//			if ((BulletX + BulletX_Motion + BulletS >= IronXarray[i] - IronBlockWidth)
//			&& (BulletX + BulletX_Motion - BulletS <= IronXarray[i] + IronBlockWidth)
//			&& (BulletY + BulletY_Motion + BulletS >= IronYarray[i] - IronBlockWidth)
//			&& (BulletY + BulletY_Motion - BulletS <= IronYarray[i] + IronBlockWidth))
//				BulletHitIron[i] = 1;
//			else
//				BulletHitIron[i] = 0;
//		end
//
//end
//
//
//
//
//
//
//always_comb
//begin
//	for (int i = 0; i < IronSize; i++)
//	begin
//		if (i == 0)
//		begin
//			AAA = IroncheckA[0];
//			SSS = IroncheckS[0];
//			WWW = IroncheckW[0];
//			DDD = IroncheckD[0];
//			HHH = BulletHitIron[0];
//		end
//		else 
//		begin
//			AAA = AAA || IroncheckA[i];
//			SSS = SSS || IroncheckS[i];
//			WWW = WWW || IroncheckW[i];
//			DDD = DDD || IroncheckD[i];
//			HHH = HHH || BulletHitIron[i];
//		end
//	end
//	HitIronA = AAA;
//	HitIronS = SSS;
//	HitIronW = WWW;
//	HitIronD = DDD;
//	HitIron = HHH;
//end
//
//
//
//
//
//
//
//
//
//
//
//parameter [9:0] WaterSize = 24;
//parameter [9:0] WaterBlockWidth = 15;
//
//logic AAA_water, SSS_water, WWW_water, DDD_water;
//logic [WaterSize-1:0] WatercheckA, WatercheckS, WatercheckD, WatercheckW;
//logic [WaterSize-1:0][9:0] WaterXarray, WaterYarray;
//
//
//
//assign WaterXarray = '{287, 254, 221, 287, 287, 287, 287, 287, 255, 223, 191, 159, 319, 351, 383, 527, 527, 527, 527, 559, 591, 16,  48,  80};
//assign WaterYarray = '{303, 303, 303, 271, 239, 207, 175, 143, 143, 143, 143, 143, 176, 176, 176, 208, 240, 272, 304, 304, 304, 206, 206, 206};
//
//
//
//always_comb
//begin
//		for (int i = 0; i < WaterSize; i++)
//		begin
//			if ((BallX + BallX_Motion - TankBlockWidth <= WaterXarray[i] + WaterBlockWidth)
//			&& (BallY + TankBlockWidth > WaterYarray[i] - WaterBlockWidth)
//			&& (BallY - TankBlockWidth < WaterYarray[i] + WaterBlockWidth)
//			&& !(BallX + BallX_Motion + TankBlockWidth <= WaterXarray[i] - WaterBlockWidth))
//			WatercheckA[i] = 1;
//		else 
//			WatercheckA[i] = 0;
//		end
//			
//		for (int i = 0; i < WaterSize; i++)
//		begin
//			if ((BallX + TankBlockWidth + BallX_Motion >= WaterXarray[i] - WaterBlockWidth)
//			&& (BallY + TankBlockWidth > WaterYarray[i] - WaterBlockWidth)
//		   && (BallY - TankBlockWidth < WaterYarray[i] + WaterBlockWidth)
//			&& !(BallX + BallX_Motion - TankBlockWidth >= WaterXarray[i] + WaterBlockWidth))
//			WatercheckD[i] = 1;
//		else 
//			WatercheckD[i] = 0;
//		end
//		
//		for (int i = 0; i < WaterSize; i++)
//		begin
//			if ((BallX + TankBlockWidth > WaterXarray[i] - WaterBlockWidth)
//			&& (BallX - TankBlockWidth < WaterXarray[i] + WaterBlockWidth)
//			&& (BallY + BallY_Motion + TankBlockWidth >= WaterYarray[i] - WaterBlockWidth)
//			&& !(BallY + BallY_Motion - TankBlockWidth >= WaterYarray[i] + WaterBlockWidth))
//			WatercheckS[i] = 1;
//		else 
//			WatercheckS[i] = 0;
//		end
//			
//		for (int i = 0; i < WaterSize; i++)
//		begin
//			if ((BallX + TankBlockWidth > WaterXarray[i] - WaterBlockWidth)
//			&& (BallY + BallY_Motion - TankBlockWidth <= WaterYarray[i] + WaterBlockWidth)
//			&& (BallX - TankBlockWidth < WaterXarray[i] + WaterBlockWidth) 
//			&& !(BallY + BallY_Motion + TankBlockWidth <= WaterYarray[i] - WaterBlockWidth))
//			WatercheckW[i] = 1;
//		else 
//			WatercheckW[i] = 0;
//		end
//			
//end
//
//
//always_comb
//begin
//	for (int i = 0; i < WaterSize; i++)
//	begin
//		if (i == 0)
//		begin
//			AAA_water = WatercheckA[0];
//			SSS_water = WatercheckS[0];
//			WWW_water = WatercheckW[0];
//			DDD_water = WatercheckD[0];
//		end
//		else 
//		begin
//			AAA_water = AAA_water || WatercheckA[i];
//			SSS_water = SSS_water || WatercheckS[i];
//			WWW_water = WWW_water || WatercheckW[i];
//			DDD_water = DDD_water || WatercheckD[i];
//		end
//	end
//	HitWaterA = AAA_water;
//	HitWaterS = SSS_water;
//	HitWaterW = WWW_water;
//	HitWaterD = DDD_water;
//end
//
//
//
//
//
//
//
//
//
//
//
//
//
//logic AAA_wall, SSS_wall, WWW_wall, DDD_wall, HHH_wall;
//logic [WallSize-1:0] WallcheckA, WallcheckS, WallcheckD, WallcheckW, BulletHitWall;
//logic [WallSize-1:0][9:0] WallXarray, WallYarray;
//logic wall_on;
//
//assign WallXarray = '{294, 294, 294, 310, 326, 342, 342, 342, 8,   24,  8,   24,
//							 631, 615, 599, 583, 631, 615, 599, 583, 599, 599, 599, 599, 599, 599, 583, 583, 583, 583, 583, 583,
//							 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 471, 455, 503, 487, 503, 487,
//							 631, 615, 631, 615, 631, 631, 182, 182, 197, 197, 213, 213, 229, 229, 182, 182, 197, 197, 213, 213, 229, 229,
//							 40, 40, 56, 56, 40, 40, 56, 56, 8, 8, 24, 24, 8, 8, 24, 24, 40, 40, 56, 56, 72, 72, 88, 88, 104, 104, //108 so far
//							 72,  72,  72,  72,  72,  72,  72,  72,  72,  72,  88,  88,  88,  88,  88,  88,  88,  88,  88,  88,  //128 so far
//							 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 152, 152, 152, 152, 152, 152, 152, 152, 152, 152, //148 so far
//							 343, 343, 343, 343, 343, 343, 343, 343, 359, 359, 359, 359, 359, 359, 359, 359,
//							 488, 488, 488, 488, 488, 488, 488, 488, 504, 504, 504, 504, 504, 504, 504, 504, // 184 so far
//							 424, 424, 424, 424, 424, 424, 440, 440, 440, 440, 440, 440, // 192 so far
//							 392, 392, 392, 392, 392, 392, 408, 408, 408, 408, 408, 408,
//							 200, 200, 200, 200, 200, 200, 216, 216, 216, 216, 216, 216, // 216
//							 200, 200, 200, 200, 200, 200, 216, 216, 216, 216, 216, 216, // 228
//							 200, 200, 200, 200, 216, 216, 216, 216, // 236 
//							 488, 488, 488, 488, 488, 488, 504, 504, 504, 504, 504, 504,
//							 568, 552, 536, 520, 568, 552, 536, 520, //256
//							 104, 120, 104, 120, 104, 120, 104, 120, //264
//							 584, 600, 584, 600, 568, 552, 568, 552, //272
//							 568, 568, 568, 568, 552, 552, 552, 552, // 280
//							 343, 359, 343, 359, 295, 295, 295, 343, 343, 343, 327, 311, 343, 359};
//// 351, 368
//assign WallYarray = '{471, 455, 439, 439, 439, 439, 455, 471, 327, 327, 343, 343,
//							 88,  88,  88,  88,  72,  72,  72,  72,  104, 120, 136, 152, 168, 184, 104, 120, 136, 152, 168, 184, 
//							 280, 280, 264, 264, 312, 312, 296, 296, 152, 152, 136, 136, 184, 184, 168, 168, 216, 216, 200, 200, 248, 248, 232, 232, 136, 136, 152, 152,
//							 440, 440, 424, 424, 408, 392, 201, 217, 201, 217, 201, 217, 201, 217, 233, 249, 233, 249, 233, 249, 233, 249,
//							 8, 23, 8, 23, 39, 55, 39, 55, 102, 118, 102, 118, 134, 150, 134, 150, 134, 150, 134, 150, 134, 150, 134, 150, 134, 150, //108 so far
//							 327, 343, 359, 375, 391, 407, 423, 439, 455, 471, 327, 343, 359, 375, 391, 407, 423, 439, 455, 471,   
//							 327, 343, 359, 375, 391, 407, 423, 439, 455, 471, 327, 343, 359, 375, 391, 407, 423, 439, 455, 471, 
//							 354, 338, 322, 306, 290, 274, 258, 242, 354, 338, 322, 306, 290, 274, 258, 242,
//							 359, 375, 391, 407, 423, 439, 455, 471, 359, 375, 391, 407, 423, 439, 455, 471, 
//							 391, 407, 423, 439, 455, 471, 391, 407, 423, 439, 455, 471,
//							 8,   24,  40,  56,  72,  88,  8,   24,  40,  56,  72,  88,
//							 8,   24,  40,  56,  72,  86,  8,   24,  40,  56,  72,  86,
//							 472, 456, 440, 424, 408, 392, 472, 456, 440, 424, 408, 392, 
//							 472, 456, 440, 424, 472, 456, 440, 424, 
//							 8,   24,  40,  56,  72,  88,  8,   24,  40,  56,  72,  88,
//							 72,  72,  72,  72,  88,  88,  88,  88,
//							 472, 472, 456, 456, 440, 440, 424, 424,
//							 424, 424, 440, 440, 424, 424, 440, 440,
//							 408, 392, 376, 360, 408, 392, 376, 360,
//							 376, 376, 392, 392, 8,   24,  40,  8,   24,  40,  40,  40, 370, 370};
//always_comb
//begin
//		for (int i = 0; i < WallSize; i++)
//		begin
//		if ((BallX + BallX_Motion - TankBlockWidth <= WallXarray[i] + WallBlockWidth)
//			&& (BallY + TankBlockWidth > WallYarray[i] - WallBlockWidth)
//			&& (BallY - TankBlockWidth < WallYarray[i] + WallBlockWidth)
//			&& !(BallX + BallX_Motion + TankBlockWidth <= WallXarray[i] - WallBlockWidth))
//			begin
//				if (WallHitArray[i] || WallHitArray_in[i])
//					WallcheckA[i] = 0;
//				else 
//					WallcheckA[i] = 1;
//			end
//		else 
//			WallcheckA[i] = 0;
//		end
//
//
//		for (int i = 0; i < WallSize; i++)
//		begin
//		if ((BallX + TankBlockWidth + BallX_Motion >= WallXarray[i] - WallBlockWidth)
//			&& (BallY + TankBlockWidth > WallYarray[i] - WallBlockWidth)
//		   && (BallY - TankBlockWidth < WallYarray[i] + WallBlockWidth)
//			&& !(BallX + BallX_Motion - TankBlockWidth >= WallXarray[i] + WallBlockWidth))
//			begin
//				if (WallHitArray[i] || WallHitArray_in[i])
//					WallcheckD[i] = 0;
//				else 
//					WallcheckD[i] = 1;
//			end
//		else 
//			WallcheckD[i] = 0;
//		end
//
//			
//		for (int i = 0; i < WallSize; i++)
//		begin
//		if ((BallX + TankBlockWidth > WallXarray[i] - WallBlockWidth)
//			&& (BallX - TankBlockWidth < WallXarray[i] + WallBlockWidth)
//			&& (BallY + BallY_Motion + TankBlockWidth >= WallYarray[i] - WallBlockWidth)
//			&& !(BallY + BallY_Motion - TankBlockWidth >= WallYarray[i] + WallBlockWidth))
//			begin
//				if (WallHitArray[i] || WallHitArray_in[i])
//					WallcheckS[i] = 0;
//				else 
//					WallcheckS[i] = 1;
//			end
//		else 
//			WallcheckS[i] = 0;
//		end	
//
//					
//		for (int i = 0; i < WallSize; i++)
//		begin
//		if ((BallX + TankBlockWidth > WallXarray[i] - WallBlockWidth)
//			&& (BallY + BallY_Motion - TankBlockWidth <= WallYarray[i] + WallBlockWidth)
//			&& (BallX - TankBlockWidth < WallXarray[i] + WallBlockWidth) 
//			&& !(BallY + BallY_Motion + TankBlockWidth <= WallYarray[i] - WallBlockWidth))
//			begin
//				if (WallHitArray[i] || WallHitArray_in[i])
//					WallcheckW[i] = 0;
//				else 
//					WallcheckW[i] = 1;
//			end
//		else 
//			WallcheckW[i] = 0;
//		end
//		
//		
//		for (int i = 0; i < WallSize; i++)
//		begin
//			if ((BulletX + BulletX_Motion + 1 >= WallXarray[i] - WallBlockWidth)
//			&& (BulletX + BulletX_Motion - 1 <= WallXarray[i] + WallBlockWidth)
//			&& (BulletY + BulletY_Motion + 1 >= WallYarray[i] - WallBlockWidth)
//			&& (BulletY + BulletY_Motion - 1 <= WallYarray[i] + WallBlockWidth))
//			begin
//				if (WallHitArray[i] || WallHitArray_in[i])
//					BulletHitWall[i] = 0;
//				else 
//					BulletHitWall[i] = 1;
//			end
//		else 
//			BulletHitWall[i] = 0;
//		end
//
//end
//
//
//always_comb
//begin
//	for (int i = 0; i < WallSize; i++)
//	begin
//		if (i == 0)
//		begin
//			AAA_wall = WallcheckA[0];
//			SSS_wall = WallcheckS[0];
//			WWW_wall = WallcheckW[0];
//			DDD_wall = WallcheckD[0];
//			HHH_wall = BulletHitWall[0];
//		end
//		else 
//		begin
//			AAA_wall = AAA_wall || WallcheckA[i];
//			SSS_wall = SSS_wall || WallcheckS[i];
//			WWW_wall = WWW_wall || WallcheckW[i];
//			DDD_wall = DDD_wall || WallcheckD[i];
//			HHH_wall = HHH_wall || BulletHitWall[i];
//		end
//	end
//	HitWallA = AAA_wall;
//	HitWallS = SSS_wall;
//	HitWallW = WWW_wall;
//	HitWallD = DDD_wall;
//	HitWall = HHH_wall;
//end
//
//
//
//
//
//endmodule
//
//
//
//
//
//
//
//

