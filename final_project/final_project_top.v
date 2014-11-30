`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:04:04 11/12/2014 
// Design Name: 
// Module Name:    final_project_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module final_project_top(
		vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b,
		MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS, // Disable the three memory chips
		ClkPort,                           // the 100 MHz incoming clock signal
		
		BtnL, BtnU, BtnD, BtnR,            // the Left, Up, Down, and the Right buttons BtnL, BtnR,
		BtnC,                              // the center button (this is our reset in most of our designs)
		Sw0,
		Ld4, Ld3, Ld2, Ld1, Ld0, 			// 5 LEDs
		An3, An2, An1, An0,			       // 4 anodes
		Ca, Cb, Cc, Cd, Ce, Cf, Cg,        // 7 cathodes
		Dp                                 // Dot Point Cathode on SSDs
	  );

	
	  /*  INPUTS */
		// Clock & Reset I/O
		input		ClkPort;	
		// Project Specific Inputs
		input		BtnL, BtnU, BtnR, BtnD, BtnC;	
		input 	Sw0;
		
		

		/*  OUTPUTS */
		// Control signals on Memory chips 	(to disable them)
		output 	MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS;
		// Project Specific Outputs
		// LEDs
		output 	Ld0, Ld1, Ld2, Ld3, Ld4;
		// SSD Outputs
		output 	Cg, Cf, Ce, Cd, Cc, Cb, Ca, Dp;
		output 	An0, An1, An2, An3;
		
		output vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b;
		// SSD (Seven Segment Display)
		reg [3:0]	SSD;
		wire [3:0]	SSD3, SSD2, SSD1, SSD0;
		reg [7:0]  	SSD_CATHODES;
		
		/*  LOCAL SIGNALS */
		wire		Reset, ClkPort;
		wire		board_clk, sys_clk;
		wire [1:0] 	ssdscan_clk;
		reg [26:0]	DIV_CLK;
		wire Left, Right;
		wire Enter;
		wire player;
		wire p1Win, p2Win, draw;
	
		
		wire q_Initial, q_Check, q_P1_Win, q_P2_Win, q_Draw;
		reg [4:0] state;
		assign {q_Draw, q_P2_Win, q_P1_Win, q_Check, q_Initial} = state;
		
		wire q_G00,q_G10,q_G20,q_G01,q_G11,q_G21,q_G02,q_G12,q_G22;
		


	//------------	
	// Disable the three memories so that they do not interfere with the rest of the design.
	assign {MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS} = 5'b11111;
	
	//------------THE CLOCK-----------
	BUFGP BUFGP1 (board_clk, ClkPort); 	
	
	always @(posedge board_clk, posedge Reset) 	
    begin							
        if (Reset)
		DIV_CLK <= 0;
        else
		DIV_CLK <= DIV_CLK + 1'b1;
    end
	assign	sys_clk = DIV_CLK[25];
	
	//INPUT INTO STATE MACHINE
	assign {Left, Right, Start, Reset, Enter} = {BtnL, BtnR, BtnD, BtnU, BtnC};
	assign player = Sw0;
	
	//-----------------MODULE---------------
	final_project fp(
	.Clk(sys_clk), 
	.Left(Left), 
	.Right(Right),
	.Start(Start),
	.Reset(Reset),
	.Enter(Enter),
	.q_Initial(q_Initial),
	.q_Check(q_Check),
	.q_P1_Win(q_P1_Win),
	.q_P2_Win(q_P2_Win),
	.q_Draw(q_Draw),
	.player(player),
	.p1Win(p1Win),
	.p2Win(p2Win),
	.draw(draw)
	);
	
	
	//------------FGA MODULE--------------
	
	vga_display_grid display(
	.ClkPort(sys_clk),
	.vga_h_sync(vga_h_sync),
	.vga_v_sync(vga_v_sync),
	.vga_r(vga_r),
	.vga_g(vga_g),
	.vga_b(vga_b),
	.Sw0(Sw0),
	.btnU(Reset),
	.btnD(Start),
	.btnL(Left),
	.btnR(Right),
	.btnC(Enter),
	.q_G00(q_G00),
	.q_G10(q_G10),
	.q_G20(q_G20),
	.q_G01(q_G01),
	.q_G11(q_G11),
	.q_G21(q_G21),
	.q_G02(q_G02),
	.q_G12(q_G12),
	.q_G22(q_G22));
	
	
	//------------PLAYER DISPLAY----------
	assign {Ld4,Ld3, Ld2, Ld1, Ld0} = {BtnL, BtnR, BtnD, BtnU, BtnC}; 
	assign SSD0 = player;
	assign SSD1 = draw;
	assign SSD2 = p2Win;
	assign SSD3 = p1Win;
	
	assign ssdscan_clk = DIV_CLK[19:18];
	assign An0	= !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	assign An1	= !(~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 01
	assign An2	=  !((ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 10
	assign An3	=  !((ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11
	
	always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk) 
				  2'b00: SSD = SSD0;
				  2'b01: SSD = SSD1;
				  2'b10: SSD = SSD2;
				  2'b11: SSD = SSD3;
		endcase 
	end
	
	// Following is Hex-to-SSD conversion
	always @ (SSD) 
	begin : HEX_TO_SSD
		case (SSD) // in this solution file the dot points are made to glow by making Dp = 0
		    //                                                                abcdefg,Dp
			4'b0000: SSD_CATHODES = 8'b00000010; // 0
			4'b0001: SSD_CATHODES = 8'b10011110; // 1
			4'b0010: SSD_CATHODES = 8'b00100100; // 2
			4'b0011: SSD_CATHODES = 8'b00001100; // 3
			4'b0100: SSD_CATHODES = 8'b10011000; // 4
			4'b0101: SSD_CATHODES = 8'b01001000; // 5
			4'b0110: SSD_CATHODES = 8'b01000000; // 6
			4'b0111: SSD_CATHODES = 8'b00011110; // 7
			4'b1000: SSD_CATHODES = 8'b00000000; // 8
			4'b1001: SSD_CATHODES = 8'b00001000; // 9
			4'b1010: SSD_CATHODES = 8'b00010000; // A
			4'b1011: SSD_CATHODES = 8'b11000000; // B
			4'b1100: SSD_CATHODES = 8'b01100010; // C
			4'b1101: SSD_CATHODES = 8'b10000100; // D
			4'b1110: SSD_CATHODES = 8'b01100000; // E
			4'b1111: SSD_CATHODES = 8'b01110000; // F    
			default: SSD_CATHODES = 8'bXXXXXXXX; // default is not needed as we covered all cases
		endcase
	end	
	
	// reg [7:0]  SSD_CATHODES;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES};
	
endmodule
