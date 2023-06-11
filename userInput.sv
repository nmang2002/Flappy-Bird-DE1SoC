/*
Description: This module takes the input of the user through the keys to control Tug of War game. 

Inputs:
			key: Keys 0 and 3 used by users to control LEDs in Tug of War game. 

			Clock: Clock frequency at 50 MHz.
			
			RST: Returns LED pattern back to chosen state. Chosen state is when all LEDS except 
					 center light (LEDR[5]) are off. 

Outputs:
			out: Output of user choices. 
*/

module userInput(Clock, RST, key, out);
	input logic key, Clock, RST;
	output logic out;
	
	enum {none, got_one} ps, ns;
	
	// Next state logic
	always_comb begin
		case(ps)
			none: if (key == 1) ns = none;
					else ns = got_one;
			got_one: if (key == 1) ns = none;
					else ns = got_one;
		endcase
	end
	
	assign out = (ps == none & ns == got_one);

	// DFFs
	always_ff @(posedge Clock) begin
		if (RST)
			ps = got_one;
			else 
				ps <= ns;
	end
endmodule 

module userInput_testbench();
 logic Clock, RST, key;

 logic out;

 userInput dut (.Clock, .RST,.key, .out);
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
                           
						key <= 0; @(posedge Clock); //Running if key = 0 for 3 cycles
                           @(posedge Clock);
                           @(posedge Clock);
						key <= 1; @(posedge Clock); //Running if key = 1 for 3 cycles
                           @(posedge Clock);
                           @(posedge Clock);
						key <= 0; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
						key <= 1; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
						key <= 0; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
						key <= 1; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);		

       $stop; // End the simulation.
   end
endmodule 