module ledDisplay (pipes, birdie, screenchange, redled, greenled, Clock, RST);
	input logic screenchange, Clock, RST;
	input logic [15:0] birdie;
	logic [15:0][15:0] start, gameover, gameplay;
	input logic [15:0][15:0] pipes;
	output logic [15:0][15:0] redled, greenled;
	
	enum {on, got_one} ps, ns;
	
		always_comb begin
		case(ps)
			on: if (screenchange == 1) ns = got_one; 
				 else ns = on;
			got_one: ns = got_one;
		endcase
	end
	
	assign start[00] = 16'b0000000000000000;
	assign start[01] = 16'b0000000000000000;
	assign start[02] = 16'b1110100111001111;
	assign start[03] = 16'b1000100101001001;
	assign start[04] = 16'b1110100111001011;
	assign start[05] = 16'b1000100101001000;
	assign start[06] = 16'b1000110101001000;
	assign start[07] = 16'b0000000000000000;
	assign start[08] = 16'b0000000000000000;
	assign start[09] = 16'b1110100111001110;
   assign start[10] = 16'b1010100101001001;
	assign start[11] = 16'b1110100111001001;
	assign start[12] = 16'b1010100100101001;
	assign start[13] = 16'b1110100100101110;
	assign start[14] = 16'b0000000000000000;
	assign start[15] = 16'b0000000000000000;

	assign gameplay[00] = 0;
	assign gameplay[01] = 0;
	assign gameplay[02] = birdie;
	assign gameplay[03] = 0;
	assign gameplay[04] = 0;
	assign gameplay[05] = 0;
	assign gameplay[06] = 0;
	assign gameplay[07] = 0;
	assign gameplay[08] = 0;
	assign gameplay[09] = 0;
   assign gameplay[10] = 0;
	assign gameplay[11] = 0;
	assign gameplay[12] = 0;
	assign gameplay[13] = 0;
	assign gameplay[14] = 0;
	assign gameplay[15] = 0;

	
	always_comb begin
		case(ps)
			on: begin
				redled = gameplay;
				greenled = pipes;
			end
			got_one: begin
				redled = start;
				  greenled = 0;
			end
			default: begin
				  redled = start;
				  greenled = 0;
			end
		endcase
	end
	always_ff @(posedge Clock) begin
		if (RST)
			ps <= on;
		else
			ps <= ns;
	end
endmodule 