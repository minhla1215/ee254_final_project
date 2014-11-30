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
		ClkPort,                           // the 100 MHz incoming clock signal
		
		BtnL, BtnU, BtnD, BtnR,            // the Left, Up, Down, and the Right buttons BtnL, BtnR,
		BtnC,                              // the center button (this is our reset in most of our designs)
		Ld7, Ld6, Ld5, Ld4, Ld3, // 8 LEDs
		LCD_data, LCD_e, LCD_rs, LCD_rw, LCD_bl,
		An3, An2, An1, An0,			       // 4 anodes
		Ca, Cb, Cc, Cd, Ce, Cf, Cg,        // 7 cathodes
		Dp                                 // Dot Point Cathode on SSDs
	  );

	
	  /*  INPUTS */
		// Clock & Reset I/O
		input		ClkPort;	
		// Project Specific Inputs
		input		BtnL, BtnU, BtnR, BtnD, BtnC;	
		
		// LEDs
		output 	Ld3, Ld4, Ld5, Ld6, Ld7;
		// SSD Outputs
		output 	Cg, Cf, Ce, Cd, Cc, Cb, Ca, Dp;
		output 	An0, An1, An2, An3;	
		// LCD outputs
		output [7:0] LCD_data;
		output LCD_e, LCD_rs, LCD_rw, LCD_bl;
		
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
		reg [3:0]	SSD;
		
		
		wire     [3:0]	SSD3, SSD2, SSD1, SSD0; // ****** TODO  in Part 2 ******  reg or wire?
		reg     [7:0]  SSD_CATHODES; // ****** TODO  in Part 2 ******  reg or wire?
		
		//--------------------LCD----------------------
		wire [7:0]  data1, data2, data3, data4, data5, data6, data7, data8,
				   data9, data10, data11, data12, data13, data14, data15, data16,
					data17, data18, data19, data20, data21, data22, data23, data24,
					data25, data26, data27, data28, data29, data30, data31, data32;	
	
		assign {MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS} = 5'b11111;
	
	//------------THE CLOCK-----------
	BUFGP BUFGP1 (board_clk, ClkPort); 	
	
	assign Reset = BtnU;
	
	always @(posedge board_clk, posedge Reset) 	
    begin							
        if (Reset)
		DIV_CLK <= 0;
        else
		DIV_CLK <= DIV_CLK + 1'b1;
    end
	assign	sys_clk = DIV_CLK[25];
	
	//INPUT INTO STATE MACHINE
	assign {Left, Right, Start, Reset, Enter} = {BtnL, BtnR, BtnU, BtnD, BtnC};
	
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
	
endmodule
