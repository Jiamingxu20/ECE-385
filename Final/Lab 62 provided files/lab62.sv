//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode, keycode2, keycode3, keycode4;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	lab62_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode),
		.keycode2_export(keycode2),
		.keycode3_export(keycode3),
		.keycode4_export(keycode4)
		
	 );

logic        Is_bullet_on,  HitIronA,  HitIronS,  HitIronD,  HitIronW,  HitWaterA,  HitWaterS,  HitWaterD,  HitWaterW,  HitWallA,  HitWallS,  HitWallD,  HitWallW;
logic 		 Is_bullet_on2, HitIronA2, HitIronS2, HitIronD2, HitIronW2, HitWaterA2, HitWaterS2, HitWaterD2, HitWaterW2, HitWallA2, HitWallS2, HitWallD2, HitWallW2;
logic 		 HitIron, HitIron2, HitWall, HitWall2;
logic        tankhitA, tankhitD, tankhitS, tankhitW;
logic  [9:0] DrawX, DrawY;
logic  [9:0] BallX,  BallY,  BallS,  BulletX,  BulletY,  BulletS,  BallX_Motion,  BallY_Motion,  BulletX_Motion,  BulletY_Motion;
logic  [9:0] BallX2, BallY2, BallS2, BulletX2, BulletY2, BulletS2, BallX_Motion2, BallY_Motion2, BulletX_Motion2, BulletY_Motion2;
logic  [291:0][9:0] WallHitArray_out, WallHitArray_out2;

logic        Enter, gamebegin_on, gaming_on, gameend_on, reset0, Esc, pause;
logic			 BulletHittank2, Bullet2Hittank, Player1wins, Player2wins;


always_comb
begin
	if (keycode == 8'h28 || keycode2 == 8'h28 || keycode3 == 8'h28 || keycode4 == 8'h28)    		//A
		Enter = 1'h1;
	else if (keycode == 8'h58 || keycode2 == 8'h58 || keycode3 == 8'h58 || keycode4 == 8'h58)    		//A
		Enter = 1'h1;
	else 
		Enter = 1'h0;
end


always_comb
begin
	if (keycode == 8'h29 || keycode2 == 8'h29 || keycode3 == 8'h29 || keycode4 == 8'h29)    		//A
		Esc = 1'h1;
	else 
		Esc = 1'h0;
end





Statemachine Statemachine_0 (.Clk(MAX10_CLK1_50),
									  .Reset(Reset_h || reset0),
									  .Enter(Enter),
									  .Esc(Esc),
									  .Player1wins(Player1wins),
									  .Player2wins(Player2wins),
									  .gamebegin_on(gamebegin_on),
									  .gaming_on(gaming_on),
									  .gameend_on(gameend_on),
									  .pause(pause),
									  .reset0(reset0) );





color_mapper color_mapper_0 (.Clk(MAX10_CLK1_50),
									  .frame_clk(VGA_VS),
									  .Reset(Reset_h || reset0),
									  .keycode(keycode),
									  .keycode2(keycode2),
									  .keycode3(keycode3),
									  .keycode4(keycode4),
									  .DrawX(DrawX),
									  .DrawY(DrawY),
									  .WallHitArray_out(WallHitArray_out),
									  .WallHitArray_out2(WallHitArray_out2),
									  .gamebegin_on(gamebegin_on),
									  .gaming_on(gaming_on),
									  .gameend_on(gameend_on),
									  .pause(pause),
									  .BulletHittank2(BulletHittank2),
									  .Bullet2Hittank(Bullet2Hittank),
									  .Player1wins(Player1wins),
									  .Player2wins(Player2wins),
									  
									  // tank1
									  .BallX(BallX),
									  .BallY(BallY),
									  .BallS(BallS),
									  
									  // bullet1
									  .BulletX(BulletX),
									  .BulletY(BulletY),
									  .BulletS(BulletS),
									  .Is_bullet_on(Is_bullet_on),									  
									  .HitIron(HitIron),
									  .HitWall(HitWall),
									  .BulletX_Motion(BulletX_Motion),
									  .BulletY_Motion(BulletY_Motion),
									  
									  // tank2
									  .BallX2(BallX2),
									  .BallY2(BallY2),
									  .BallS2(BallS2),
									  
									  // bullet2
									  .BulletX2(BulletX2),
									  .BulletY2(BulletY2),
									  .BulletS2(BulletS2),
									  .Is_bullet_on2(Is_bullet_on2),									  
									  .HitIron2(HitIron2),
									  .HitWall2(HitWall2),
									  .BulletX_Motion2(BulletX_Motion2),
									  .BulletY_Motion2(BulletY_Motion2),
									  
									  // output
									  .Red(Red),
									  .Green(Green),
									  .Blue(Blue));

									  
									  
									  
									  
									  
vga_controller vga_controller_0 (.Clk(MAX10_CLK1_50),
											.Reset(Reset_h || reset0),
											// output
											.hs(VGA_HS),
											.vs(VGA_VS),
											.pixel_clk(VGA_Clk),
											.blank(blank),
											.sync(sync),
											.DrawX(DrawX),
											.DrawY(DrawY) );


											


collision collision_0 (.Clk(VGA_VS),
							  .Reset(Reset_h || reset0),
							  // input 
							  .BallX(BallX),
							  .BallY(BallY),
							  .BallS(BallS),
							  .BallX_Motion(BallX_Motion),
							  .BallY_Motion(BallY_Motion),
							  .BulletX(BulletX),
							  .BulletY(BulletY),
							  .BulletS(BulletS),
							  .BulletX_Motion(BulletX_Motion),
							  .BulletY_Motion(BulletY_Motion),
							  // input2
							  .BallX2(BallX2),
							  .BallY2(BallY2),
							  .BallS2(BallS2),
							  .BallX_Motion2(BallX_Motion2),
							  .BallY_Motion2(BallY_Motion2),
							  .BulletX2(BulletX2),
							  .BulletY2(BulletY2),
							  .BulletS2(BulletS2),
							  .BulletX_Motion2(BulletX_Motion2),
							  .BulletY_Motion2(BulletY_Motion2),
							  // output
							  .HitIronA(HitIronA),
							  .HitIronS(HitIronS),
							  .HitIronD(HitIronD),
							  .HitIronW(HitIronW),
							  .HitIron(HitIron),
							  .HitWaterA(HitWaterA),
							  .HitWaterS(HitWaterS),
							  .HitWaterD(HitWaterD),
							  .HitWaterW(HitWaterW),
							  .HitWallA(HitWallA),
							  .HitWallS(HitWallS),
							  .HitWallD(HitWallD),
							  .HitWallW(HitWallW),
							  .HitWall(HitWall),
							  // output2
							  .HitIronA2(HitIronA2),
							  .HitIronS2(HitIronS2),
							  .HitIronD2(HitIronD2),
							  .HitIronW2(HitIronW2),
							  .HitIron2(HitIron2),
							  .HitWaterA2(HitWaterA2),
							  .HitWaterS2(HitWaterS2),
							  .HitWaterD2(HitWaterD2),
							  .HitWaterW2(HitWaterW2),
							  .HitWallA2(HitWallA2),
							  .HitWallS2(HitWallS2),
							  .HitWallD2(HitWallD2),
							  .HitWallW2(HitWallW2),
							  .HitWall2(HitWall2), 
							  // wallhitarray
							  .WallHitArray_out(WallHitArray_out),
							  .WallHitArray_out2(WallHitArray_out2),
							  .tankhitA(tankhitA), 
							  .tankhitD(tankhitD),  
							  .tankhitS(tankhitS),  
							  .tankhitW(tankhitW),
							  .BulletHittank2(BulletHittank2),
							  .Bullet2Hittank(Bullet2Hittank),
							  .Player1wins(Player1wins),
							  .Player2wins(Player2wins) );

 

							  
							  
							  
							  
ball ball_0 (.Reset(Reset_h || reset0),
				 .frame_clk(VGA_VS),
				 .keycode(keycode),
				 .keycode2(keycode2),
				 .keycode3(keycode3),
				 .keycode4(keycode4),
				 .HitIronA(HitIronA),
				 .HitIronS(HitIronS),
				 .HitIronD(HitIronD),
				 .HitIronW(HitIronW),
				 .HitWaterA(HitWaterA),
				 .HitWaterS(HitWaterS),
				 .HitWaterD(HitWaterD),
				 .HitWaterW(HitWaterW),
				 .HitWallA(HitWallA),
				 .HitWallS(HitWallS),
				 .HitWallD(HitWallD),
				 .HitWallW(HitWallW),
				 .gamebegin_on(gamebegin_on),
				 .gaming_on(gaming_on),
				 .gameend_on(gameend_on),
				 .tankhitA(tankhitA), 
				 .tankhitD(tankhitD),  
				 .tankhitS(tankhitS),  
				 .tankhitW(tankhitW),
				 .Is_bullet_on(Is_bullet_on2),
				 // output
				 .BallX(BallX),
				 .BallY(BallY),
				 .BallS(BallS),
				 .BallX_Motion(BallX_Motion),
			    .BallY_Motion(BallY_Motion),
				 .BulletHittank(Bullet2Hittank));
	


ball2 ball_20 (.Reset(Reset_h || reset0),
				 .frame_clk(VGA_VS),
				 .keycode(keycode),
				 .keycode2(keycode2),
				 .keycode3(keycode3),
				 .keycode4(keycode4),
				 .HitIronA(HitIronA2),
				 .HitIronS(HitIronS2),
				 .HitIronD(HitIronD2),
				 .HitIronW(HitIronW2),
				 .HitWaterA(HitWaterA2),
				 .HitWaterS(HitWaterS2),
				 .HitWaterD(HitWaterD2),
				 .HitWaterW(HitWaterW2),
				 .HitWallA(HitWallA2),
				 .HitWallS(HitWallS2),
				 .HitWallD(HitWallD2),
				 .HitWallW(HitWallW2),
				 .gamebegin_on(gamebegin_on),
				 .gaming_on(gaming_on),
				 .gameend_on(gameend_on),
				 .tankhitA(tankhitA), 
				 .tankhitD(tankhitD),  
				 .tankhitS(tankhitS),  
				 .tankhitW(tankhitW),
				 .Is_bullet_on(Is_bullet_on),
				 // output
				 .BallX(BallX2),
				 .BallY(BallY2),
				 .BallS(BallS2),
				 .BallX_Motion(BallX_Motion2),
			    .BallY_Motion(BallY_Motion2),
				 .BulletHittank(BulletHittank2) );

	
bullet bullet_0 (.Reset(Reset_h || reset0),
				 .frame_clk(VGA_VS),
				 .keycode(keycode),
				 .keycode2(keycode2),
				 .keycode3(keycode3),
				 .keycode4(keycode4),
				 .BallX(BallX),
				 .BallY(BallY),
				 .HitIron(HitIron),
				 .HitWall(HitWall),
				 .gamebegin_on(gamebegin_on),
				 .gaming_on(gaming_on),
				 .gameend_on(gameend_on),
				 .BulletHittank(BulletHittank2),
				 // output
				 .BulletX(BulletX),
				 .BulletY(BulletY),
				 .BulletS(BulletS),
				 .Is_bullet_on(Is_bullet_on),
				 .BulletX_Motion(BulletX_Motion),
				 .BulletY_Motion(BulletY_Motion) );
				 
bullet2 bullet_20 (.Reset(Reset_h || reset0),
				 .frame_clk(VGA_VS),
				 .keycode(keycode),
				 .keycode2(keycode2),
				 .keycode3(keycode3),
				 .keycode4(keycode4),
				 .BallX(BallX2),
				 .BallY(BallY2),
				 .HitIron(HitIron2),
				 .HitWall(HitWall2),
				 .gamebegin_on(gamebegin_on),
				 .gaming_on(gaming_on),
				 .gameend_on(gameend_on),
				 .BulletHittank(Bullet2Hittank),
				 // output
				 .BulletX(BulletX2),
				 .BulletY(BulletY2),
				 .BulletS(BulletS2),
				 .Is_bullet_on(Is_bullet_on2),
				 .BulletX_Motion(BulletX_Motion2),
				 .BulletY_Motion(BulletY_Motion2) );
				 
				 
				 
endmodule
