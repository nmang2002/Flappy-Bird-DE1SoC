// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;

	 // Turn off HEX displays
    assign HEX3 = '1;
    assign HEX4 = '1;
	 
	 
	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK;
	 
	 clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
	 //clock_divider divider2 (.clock(SYSTEM_CLOCK), .divided_clocks(Clock2));
	 assign SYSTEM_CLOCK = clk[14];
    //assign newclock = Clock2[8];	
	// 1526 Hz clock signal
	 // assign SYSTEM_CLOCK = CLOCK_50; // Using this for testbench
	 
	 /* If you notice flickering, set SYSTEM_CLOCK faster.
	    However, this may reduce the brightness of the LED board. */
	
	 
	 /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	 logic RST;                   // RST - toggle this on startup
	 
	 assign RST = SW[9];
	 
	 /* Standard LED Driver instantiation - set once and 'forget it'. 
	    See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
	 LEDDriver Driver (.Clock(SYSTEM_CLOCK), .RST, .slowdownCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 
	 
	 /* LED board test submodule - paints the board with a static pattern.
	    Replace with your own code driving RedPixels and GrnPixels.
		 =================================================================== */
		 
	//assign pipecolumn = GrnPixels[2][15:0];
	//assign birdcolumn = RedPixels[2][15:0];
	slowerClock slowpipe(.Clock(SYSTEM_CLOCK), .RST(RST), .slow_Clock(slowdown1));
	logic gameover, counter2;
	logic playerout, playerdown;
	logic key3, key0;
	logic k3, k0;

	userInput up(.Clock(SYSTEM_CLOCK), .RST, .key(~KEY[0]), .out(playerout));
	userInput down(.Clock(SYSTEM_CLOCK), .RST, .key(~KEY[3]), .out(playerdown));
	
	logic hex0out, hex1out, hex2out;
	logic slowdown1;
	

	logic [15:0] pattern;
	logic [15:0][15:0] outcol;
	logic [15:0] outbird;
	

	bird mod1 (.Clock(SYSTEM_CLOCK), .RST, .R(playerout), .L(playerdown), .lights(outbird));
	
	score mod2 (.greenpix(GrnPixels[2][15:0]), .redpix(RedPixels[2][15:0]), .stop(gameover), .counter2, .Clock(SYSTEM_CLOCK), .RST(RST));
	scoreboard hex0 (.counter2, .carry1(hex0out), .hexout(HEX0), .Clock(SYSTEM_CLOCK), .RST(RST));
	scoreboard hex1 (.counter2(hex0out), .carry1(hex1out), .hexout(HEX1), .Clock(SYSTEM_CLOCK), .RST(RST));
	scoreboard hex2 (.counter2(hex1out), .carry1(hex2out), .hexout(HEX2), .Clock(SYSTEM_CLOCK), .RST(RST));
	
	makepipe p1 (.out(pattern), .Clock(SYSTEM_CLOCK), .slowdown(slowdown1), .RST(RST));
	pipeshift p2 (.genPipes(pattern), .out(outcol), .Clock(SYSTEM_CLOCK), .slowdown(slowdown1), .RST(RST));
	ledDisplay led1 (.pipes(outcol), .birdie(outbird), .screenchange(gameover), .redled(RedPixels), .greenled(GrnPixels), .Clock(SYSTEM_CLOCK), .RST(RST));
	
	
endmodule 


module DE1_SoC_testbench();
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [35:0] GPIO_1;

	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR,.SW, .GPIO_1);

	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; 
	end
	

	initial begin
		SW[9] <= 1; SW[2] <= 1; SW[1] <= 1; SW[0] <= 1; KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		SW[9] <= 0;  @(posedge CLOCK_50); 
		
		KEY[3] <= 1; @(posedge CLOCK_50);
		KEY[3] <= 0; @(posedge CLOCK_50);
		KEY[3] <= 1; @(posedge CLOCK_50);
		KEY[3] <= 0; @(posedge CLOCK_50);
		KEY[3] <= 1; @(posedge CLOCK_50);
		KEY[3] <= 0; @(posedge CLOCK_50);
		KEY[3] <= 1; @(posedge CLOCK_50);
		KEY[3] <= 0; @(posedge CLOCK_50);
		KEY[3] <= 1; @(posedge CLOCK_50);
		KEY[3] <= 0; @(posedge CLOCK_50);
		KEY[0] <= 1; @(posedge CLOCK_50);
		KEY[0] <= 0; @(posedge CLOCK_50);
		KEY[0] <= 1; @(posedge CLOCK_50);
		KEY[0] <= 0; @(posedge CLOCK_50);
		KEY[0] <= 1; @(posedge CLOCK_50);
		KEY[0] <= 0; @(posedge CLOCK_50);
		KEY[0] <= 1; @(posedge CLOCK_50);
		KEY[0] <= 0; @(posedge CLOCK_50);
		KEY[0] <= 1; @(posedge CLOCK_50);
		KEY[0] <= 0; @(posedge CLOCK_50);
		
		KEY[3] <= 1; repeat(20) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(20) @(posedge CLOCK_50);
		$stop; // End the simulation.
	end
endmodule
	