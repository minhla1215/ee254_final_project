`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:35:58 11/12/2014
// Design Name:   final_project
// Module Name:   C:/Xilinx_projects/final_project/final_project_test.v
// Project Name:  final_project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: final_project
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
	wire q_Initial;
	wire q_Check;
	wire q_P1_Win;
	wire q_P2_Win;
	wire q_Draw;
	wire p1Win;
	wire p2Win;
	wire draw;
	reg location;
	reg [6*8:0] state_string; // 6-character string for symbolic display of state

	// Instantiate the Unit Under Test (UUT)
	final_project uut (
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

	initial 
		  begin
			Clk = 0; // Initialize clock
		  end
		
		always  begin #10; Clk = ~ Clk; end
		

	initial begin
		// Initialize Inputs
		Clk = 0;
		location = 4'b0000;
		player = 0;
		Left = 0;
		Right = 0;
		Start = 0;
		Reset = 0;
		Enter = 0;

		// Wait 100 ns for global reset to finish
		#100;
      Reset = 1;

		/* XO-
			X--
			X-- PLAYER 1 WINS
		*/
		#20;
		Start = 1;
		#20;
		Start = 0;
		Enter = 1;
		
		#20;
		player = 1;
		Right = 1;
		
		#20;
		Right = 0;
		Enter = 1;
		
		#20;
		Enter = 0;
		player = 0;
		Right = 1;
		
		#20;
		Right = 1;
		
		#20;
		Enter = 1;
		
		#20;
		Enter = 0;
		Right = 1;
		
		#20;
		#20;
		#20;
		Right = 0;
		Enter = 1;
		
		
		
		// Add stimulus here

	end
      
		always @(*)
		begin
			case ({q_Initial, q_Check, q_P1_Win, q_P2_Win, q_Draw})    // Note the concatenation operator {}
				5'b00001: state_string = "q_Initial ";  // ****** TODO ******
				5'b00010: state_string = "q_Check ";       // Fill-in the three lines
				5'b00100: state_string = "q_P1_WIN"; 
				5'b01000: state_string = "q_P2_WIN"; 
				5'b10000: state_string = "q_Draw"; 


				endcase
		end
		
endmodule

