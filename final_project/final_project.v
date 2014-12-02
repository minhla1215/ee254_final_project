`timescale 1ns / 1ps
module final_project(Clk, Left, Right, Start, Reset, Enter, q_Initial, q_Check, q_P1_Win, q_P2_Win, q_Draw, player, p1Win, p2Win, draw);

input Clk, Left, Right, Start, Reset, Enter;
input player;
output q_Initial, q_Check, q_P1_Win, q_P2_Win, q_Draw;
output reg p1Win, p2Win, draw;


reg [1:0] mapBoard [8:0];

reg [4:0] state;
assign {q_Draw, q_P2_Win, q_P1_Win, q_Check, q_Initial} = state;

reg gameOver, flag;
integer i;
reg [3:0] location;

localparam
INITIAL = 5'b00001,
CHECK   = 5'b00010,
P1WIN   = 5'b00100,
P2WIN   = 5'b01000,
DRAW    = 5'b10000;


reg [6*8:0] state_string; 
// 6-character string for symbolic display of state

always @ (posedge Clk, posedge Reset)
begin
	(* full_case, parallel_case *) 
	// to avoid prioritization (Verilog 2001 standard)
	if(Reset)
	begin
		state <= INITIAL;
		gameOver <= 1'b0;
		location <= 4'b0000;
		p1Win <= 1'b0;
		p2Win <= 1'b0;
		draw <= 1'b0;
		for (i = 0; i < 9; i = i + 1)
		begin
			mapBoard[i] <= 0;
		end
	end
	else
	begin
		case (state)
		INITIAL:
		begin
			if (Start)
				state <= CHECK;
		end
		CHECK:
		begin
			if (Left)
			begin
				if (location == 4'b0000)
					location <= 4'b1000;
				else
					location <= location - 1;
			end
			if (Right)
			begin
				if (location == 4'b1000)
				   	location <= 4'b0000;
				else
				    location <= location + 1;
			end
			if (Enter)
			begin
				if (!player) 
				// player=0 is player1, player=1 is player2
					mapBoard[location] = 1;
				else
					mapBoard[location] = 2;
								
				gameOver = 1'b0;
				for (i = 0; i < 3; i = i + 1)
				begin
					if (mapBoard[i * 3 + 0] 
						== mapBoard[i * 3 + 1] && 
						mapBoard[i * 3 + 1] 
						== mapBoard[i * 3 + 2])
					begin
						if (mapBoard[i * 3 + 0] == 1)
						begin
							gameOver = 1'b1;
							state <= P1WIN;
						end
						if (mapBoard[i * 3 + 0] == 2)
						begin
							gameOver = 1'b1;
							state <= P2WIN;
						end
					end
				end
						
				for (i = 0; i < 3; i = i + 1)
				begin
					if (mapBoard[0 + i] == mapBoard[3 + i] 
						&& mapBoard[3 + i] 
						== mapBoard[6 + i])
					begin
						if (mapBoard[i] == 1)
						begin
							gameOver = 1'b1;
							state <= P1WIN;
						end
						if (mapBoard[i] == 2)
						begin
							gameOver = 1'b1;
							state <= P2WIN;
						end
					end
				end
				if (mapBoard[0] == mapBoard[4] && 
					mapBoard[4] == mapBoard[8])
				begin
					if (mapBoard[0] == 1)
					begin
						gameOver = 1'b1;
						state <= P1WIN;
					end
					if (mapBoard[0] == 2)
					begin
						gameOver = 1'b1;
						state <= P2WIN;
					end
				end
						
				if (mapBoard[2] == mapBoard[4] && 
					mapBoard[4] == mapBoard[6])
				begin
					if (mapBoard[2] == 1)
					begin
						gameOver = 1'b1;
						state <= P1WIN;
					end
					if (mapBoard[2] == 2)
					begin
						gameOver = 1'b1;
						state <= P2WIN;
					end
				end
							
				flag = 1'b1;
				for (i = 0; i < 9; i = i + 1)
				begin
					if (mapBoard[i] == 0)
						flag = 1'b0;
				end
						
				if (flag && !gameOver)
					state <= DRAW;
			end
		end
		P1WIN:
		begin
			p1Win <= 1'b1;
			p2Win <= 1'b0;
			draw  <= 1'b0;
			if (Start)
				state <= INITIAL;
		end
		P2WIN:
		begin
			p1Win <= 1'b0;
			p2Win <= 1'b1;
			draw  <= 1'b0;
			if (Start)
				state <= INITIAL;
		end
		DRAW:
		begin
			p1Win <= 1'b0;
			p2Win <= 1'b0;
			draw  <= 1'b1;
			if (Start)
	 			state <= INITIAL;
		end
		default:
		begin
			draw <= 1'b1;
		end
		endcase
	end
end

always @ (*)
begin
	case ({q_Draw,q_P2_Win,q_P1_Win,q_Check,q_Initial})    
	5'b00001: 
		state_string = "q_Initial "; 
	5'b00010: 
		state_string = "q_Check ";       
	5'b00100: 
		state_string = "q_P1_WIN"; 
	5'b01000: 
		state_string = "q_P2_WIN"; 
	5'b10000: 
		state_string = "q_Draw"; 
	endcase
end

endmodule
