module bird (Clock, RST, R, L, lights);

	input logic R, L, Clock, RST;
	output logic [15:0] lights;
	
	normalLight bl0 (.Clock, .RST, .R, .L, .NR(1'b0), .NL(lights[1]), .lightOn(lights[0]));
	normalLight bl1 (.Clock, .RST, .R, .L, .NR(lights[0]), .NL(lights[2]), .lightOn(lights[1]));
	normalLight bl2 (.Clock, .RST, .R, .L, .NR(lights[1]), .NL(lights[3]), .lightOn(lights[2]));
	normalLight bl3 (.Clock, .RST, .R, .L, .NR(lights[2]), .NL(lights[4]), .lightOn(lights[3]));
	
	normalLight bl4 (.Clock, .RST, .R, .L, .NR(lights[3]), .NL(lights[5]), .lightOn(lights[4]));
	normalLight bl5 (.Clock, .RST, .R, .L, .NR(lights[4]), .NL(lights[6]), .lightOn(lights[5]));
	normalLight bl6 (.Clock, .RST, .R, .L, .NR(lights[5]), .NL(lights[7]), .lightOn(lights[6]));
	normalLight bl7 (.Clock, .RST, .R, .L, .NR(lights[6]), .NL(lights[8]), .lightOn(lights[7]));
	
	centerLight bl8 (.Clock, .RST, .R, .L, .NR(lights[7]), .NL(lights[9]), .lightOn(lights[8]));
	normalLight bl9 (.Clock, .RST, .R, .L, .NR(lights[8]), .NL(lights[10]), .lightOn(lights[9]));
	normalLight blA (.Clock, .RST, .R, .L, .NR(lights[9]), .NL(lights[11]), .lightOn(lights[10]));
	normalLight blB (.Clock, .RST, .R, .L, .NR(lights[10]), .NL(lights[12]), .lightOn(lights[11]));
	
	normalLight blC (.Clock, .RST, .R, .L, .NR(lights[11]), .NL(lights[13]), .lightOn(lights[12]));
	normalLight blD (.Clock, .RST, .R, .L, .NR(lights[12]), .NL(lights[14]), .lightOn(lights[13]));
	normalLight blE (.Clock, .RST, .R, .L, .NR(lights[13]), .NL(lights[15]), .lightOn(lights[14]));
	normalLight blF (.Clock, .RST, .R, .L, .NR(lights[14]), .NL(1'b0), .lightOn(lights[15]));

endmodule 



module bird_testbench();
	logic R, L, RST;
	logic [15:0] lights;
	logic CLOCK_50;
	
	bird dut (.lights, .R, .L, .Clock(CLOCK_50), .RST);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	initial begin
		// RST the module
		RST <= 1; repeat(5) @(posedge CLOCK_50);
		RST <= 0; L <= 0; R <= 0; @(posedge CLOCK_50);
		
		L <= 1; @(posedge CLOCK_50);
		L <= 0; @(posedge CLOCK_50);
		L <= 1; @(posedge CLOCK_50);
		L <= 0; @(posedge CLOCK_50);
		L <= 1; @(posedge CLOCK_50);
		L <= 0; @(posedge CLOCK_50);
		
		R <= 1; @(posedge CLOCK_50);
		R <= 0; @(posedge CLOCK_50);
		R <= 1; @(posedge CLOCK_50);
		R <= 0; @(posedge CLOCK_50);
		R <= 1; @(posedge CLOCK_50);
		R <= 0; @(posedge CLOCK_50);
		
		$stop;
	end
endmodule 