`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:45:05 09/24/2014
// Design Name:   ee254_numlock_sm
// Module Name:   C:/Documents and Settings/Administrator/Desktop/EE254/Xilinx Lab6 Number Lock/lab6_num_lock/ee254_numlock_sm_tb.v
// Project Name:  lab6_num_lock
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ee254_numlock_sm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module final_project_test;

	// Inputs
	reg Clk;
	reg Left;
	reg Right;
	reg Start;
	reg Reset;
	reg Enter;
	reg player;

	// Outputs
	wire q_Initial;
	wire q_Check;
	wire q_P1_Win;
	wire q_P2_Win;
	wire q_Draw;
	wire p1Win;
	wire p2Win;
	wire draw;
	
	reg [6*8:0] state_string; // 6-character string for symbolic display of state


	// Instantiate the Unit Under Test (UUT)
	final_project uut (
	.Clk(Clk), 
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


	initial begin
		// Initialize Inputs
		Clk = 0;
		player = 0;
		Left = 0;
		Right = 0;
		Start = 0;
		Reset = 1;
		Enter = 0;
		
		#100;
		Reset = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		#50;
		Start = 1;
		#50;
		Start = 0;
		Enter = 1;
		#50;
		Right = 1;
		Enter = 0;
		#50;
		Right = 0;
		Enter = 1;
		#50;
		Right = 1;
		Enter = 0;
		#50;
		Enter = 1;
		Right = 0;
		#50;
		Enter = 0;
		
		
		
		// SECOND CASE
		#100;
		Reset = 1;
		#100;
		Reset = 0;
		#100;
		Start = 1;
		player = 1;
		#50;
		Start = 0;
		Enter = 1;
		#50;
		Enter = 0;
		Right = 1;
		#150;
		Right = 0;
		Enter = 1;
		#50;
		Enter = 0;
		Right = 1;
		#150;
		Enter = 1;
		Right = 0;
		#50;
		Enter = 0;
		
		
		// Add stimulus here

	end
    
	always #25 begin Clk = ~Clk; end
endmodule

