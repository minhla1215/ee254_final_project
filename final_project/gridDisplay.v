`timescale 1ns / 1ps


module vga_display_grid(ClkPort, vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b,
	Sw0, btnU, btnD, btnL, btnR, btnC,
	q_G00, q_G10, q_G20, q_G01, q_G11, q_G21, q_G02, q_G12, q_G22);

input ClkPort, Sw0, btnU, btnD, btnL, btnR, btnC;

output vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b;
output q_G00, q_G10, q_G20, q_G01, q_G11, q_G21, q_G02, q_G12, q_G22;
reg vga_r, vga_g, vga_b;


/* LOCAL SIGNALS */

wire reset, start, ClkPort, board_clk, clk, button_clk, left, right, enter;

BUF BUF1 (board_clk, ClkPort);
BUF BUF2 (reset, Btn_U);
BUF BUF3 (start, Btn_D);
BUF BUF4 (left, Btn_L);
BUF BUF5 (right, Btn_R);
BUF BUF6 (enter, Btn_C);




reg[8:0] state;
assign {q_G00, q_G10, q_G20, q_G01, q_G11, q_G21, q_G02, q_G12, q_G22} 
	= state;

localparam
G00 = 9'b000000001,
G10 = 9'b000000010,
G20 = 9'b000000100,
G01 = 9'b000001000,
G11 = 9'b000010000,
G21 = 9'b000100000,
G02 = 9'b001000000,
G12 = 9'b010000000,
G22 = 9'b100000000;




reg[27:0] DIV_CLK;
always @ (posedge board_clk, posedge reset)
	begin : CLOCK_DIVIDER
		if (reset)
			DIV_CLK <= 0;
		else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	
		assign button_clk = DIV_CLK[18];
		assign clk = DIV_CLK[1];
		

		
	wire inDisplayArea;
	wire [9:0] CounterX;
	wire [9:0] CounterY;
		hvsync_generator syncgen(.clk(clk), .reset(reset),
			.vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync),
			.inDisplayArea(inDisplayArea),
			.CounterX(CounterX), .CounterY(CounterY));
			
			
			
	reg [9:0] position;
	
		
		/*wire R = ((CounterY == 60 || CounterY == 180 || CounterY == 300
			|| CounterY == 420) && CounterX >= 60 && CounterX <= 420)
			|| ((CounterX == 60 || CounterX == 180 || CounterX == 300
			|| CounterX == 420) && CounterY >= 60 && CounterY <= 420);*/
			/*
		wire R = CounterY >= 100 && CounterY <= 200 && CounterX >= 100 && CounterX <= 200;
*/	


		wire R = 0;
		wire G = 0;
		wire B = 0;


/*
	
	always @(posedge DIV_CLK[21])
		begin
			if(reset)
				position<=240;
			else if(btnD && ~btnU)
				position<=position+2;
			else if(btnU && ~btnD)
				position<=position-2;	
		end

	wire R = CounterY>=(position-10) && CounterY<=(position+10) && CounterX[8:5]==7;
	wire G = CounterX>100 && CounterX<200 && CounterY[5:3]==7;
	wire B = 0;
*/
/*
		always @ (posedge DIV_CLK[21])
		begin
			(* full_case, parallel_case *)
			if (reset)
				begin
					state <= G00;
				end
			else
				begin
					case (state)
					G00:
					begin
						if (left)
							state <= G22;
						if (right)
							state <= G10;
					end
					G10:
					begin
						if (left)
							state <= G00;
						if (right)
							state <= G20;
					end
					G20:
					begin
						if (left)
							state <= G10;
						if (right)
							state <= G01;
					end
					G01:
					begin
						if (left)
							state <= G20;
						if (right)
							state <= G11;
					end
					G11:
					begin
						if (left)
							state <= G01;
						if (right)
							state <= G21;
					end
					G21:
					begin
						if (left)
							state <= G11;
						if (right)
							state <= G02;
					end
					G02:
					begin
						if (left)
							state <= G21;
						if (right)
							state <= G12;
					end
					G12:
					begin
						if (left)
							state <= G02;
						if (right)
							state <= G22;
					end
					G22:
					begin
						if (left)
							state <= G12;
						if (right)
							state <= G00;
					end
					default:
					begin
					end
					endcase
				end
			end
			*/
		always @ (posedge clk)
			begin
				vga_r <= R & inDisplayArea;
				vga_g <= G & inDisplayArea;
				vga_b <= B & inDisplayArea;
			end
endmodule


