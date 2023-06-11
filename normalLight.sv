/*
Description: This module describes the states and transitions associated with the state machRe
				 State machRe has four Rput (L, R, NL, NR), and one output (lightOn). State machRes shows the next 
				 and present states of the LEDs accordRg to the states of the keys beRg pressed and present states of 
				 LEDs surroundRg center light (LEDR[5]).

Rputs:
			L, R: State of keys beRg pressed. L corresponds to left key (L = 1 when left key is pressed)
					 and R corresponds to right key (R = 1 when right key is pressed.)
 
			NL, NR: State of lights. NL is right to the left of center light and NR is light to the right. 
					  (NL =1 when left light is on and NR = 1 when right light is on).
			
			Clock: Clock frequency at 50 MHz.
			
			RST: Returns LED pattern back to chosen state. Chosen state is when all LEDS except 
					 center light (LEDR[5]) are off. 

Outputs:
			lightOn: State of center right (LEDR[5]). lightOn = 1 when center light is on. 
*/

module normalLight(Clock, RST, R, L, NR, NL, lightOn);

	input logic R, L, NR, NL, Clock, RST;
	output logic lightOn;
	
	enum {on, off} ps, ns;
	
	// This logic describes all the possible state transitions from ps to ns
	always_comb begin
		case(ps)
		
			on: if (R == 1 & L == 0 | L == 1 & R == 0) ns = off;
				  else ns = on;
				  
			off: if (R == 1 & NL == 1 | L == 1 & NR == 1) ns = on;

				  else ns = off;
		endcase
	end
	
	assign lightOn = (ps == on);
	
	always_ff @(posedge Clock) begin
		if (RST)
			ps <= off;
		else
			ps <= ns;
	end
	
endmodule
module normalLight_testbench();
 logic Clock, RST;

 logic L, R, NL, NR;
 logic lightOn;

 normalLight dut (.Clock, .RST,.L, .R, .NL, .NR, .lightOn);
// Set up a simulated clock to toggle (from low to high or high to low)
// every 50 time steps
parameter CLOCK_PERIOD=100;
initial begin
   Clock <= 0;
   forever #(CLOCK_PERIOD/2) Clock <= ~Clock;//toggle the clock indefinitely
end 
   
// Set up the inputs to the design.  Each line represents a clock cycle 
// Simulation sends the state machine into all three possible states
   initial begin
                           @(posedge Clock);
       RST <= 1;    @(posedge Clock); // Always RST FSMs at start
       RST <= 0;  @(posedge Clock);
                           
						NR <= 1; L <= 1; R<=0;NL <=0; @(posedge Clock); //Running button and led pattern for 3 cycles
                           @(posedge Clock);
                           @(posedge Clock);
									
                   NR <= 1; L <= 0; R<=1;NL <=0;  @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
                   NR <= 0; L <= 1; R<=0;NL <=1;  @(posedge Clock);
                           @(posedge Clock);
									@(posedge Clock);
						NR <= 0; L <= 0; R<=1;NL <=0;  @(posedge Clock); 
                           @(posedge Clock);
									@(posedge Clock);
						NR <= 0; L <= 0; R<=0;NL <=1;  @(posedge Clock); 
                           @(posedge Clock);
									@(posedge Clock);
						NR <= 0; L <= 1; R<=1;NL <=0;  @(posedge Clock); 
                           @(posedge Clock);
									@(posedge Clock);
						NR <= 1; L <= 0; R<=0;NL <=1;  @(posedge Clock); 
                           @(posedge Clock);
									@(posedge Clock);
						NR <= 0; NL <=1;  @(posedge Clock); //Running different LED patterns
                           @(posedge Clock);
									@(posedge Clock);
						NR <= 1; NL <=0;  @(posedge Clock); 
                           @(posedge Clock);
									@(posedge Clock);
						R <= 1; L <=0;  @(posedge Clock); //Running different key patterns
                           @(posedge Clock);
									@(posedge Clock);
						R <= 0; L <=1;  @(posedge Clock); 
                           @(posedge Clock);
									@(posedge Clock);
       $stop; // End the simulation.
   end
endmodule 