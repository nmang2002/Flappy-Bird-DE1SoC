module score(greenpix, redpix, stop, counter2, Clock, RST);

	input logic [15:0] greenpix, redpix;
	input logic Clock, RST;
	integer i;
	output logic stop, counter2;
	logic counter3, end2, lose;
	

	userInput score1(.Clock(Clock), .RST(RST), .key(counter3), .out(counter2));
	userInput score2(.Clock(Clock), .RST(RST), .key(end2), .out(stop));

	always_ff @(posedge Clock) begin
		for (i = 0; i < 16; i++) begin
			if (greenpix[i] & redpix[i]) begin
				lose <= 1;
				break;
			end
			else
				lose <= 0;
		end
	end


	always_ff @(posedge Clock) begin
		if (RST) begin
			counter3 <= 0;
			end2 <= 0;
		end
		else if (lose == 1 | redpix == 0) begin
			end2 <= 1;
			counter3 <= 0;
		end
		else if (greenpix[15] == 1) begin
			end2 <= 0;
			counter3 <= 1;
		end
		else begin
			counter3 <= 0;
			end2 <= 0;
		end
	end
endmodule

 module score_testbench();
	logic [15:0] greenpix, redpix;
	logic Clock, RST;
 	 logic stop, counter2;

 score dut (.greenpix, .redpix, .stop, .counter2, .Clock, .RST);
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
                           
						greenpix <= 16'b0000000000111111; @(posedge Clock); //Running if key = 0 for 3 cycles
                           @(posedge Clock);
                           @(posedge Clock);
						redpix <= 16'b0000000000111111; @(posedge Clock); //Running if key = 1 for 3 cycles
                           @(posedge Clock);
                           @(posedge Clock);
						greenpix <= 16'b0000000000111011; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
						redpix <= 16'b0000000000111011; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
						 greenpix <= 16'b0000000000000011; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
						redpix <= 16'b0000000000000011; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);		

       $stop; // End the simulation.
   end
endmodule