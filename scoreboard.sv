module scoreboard (counter2, carry1, hexout, Clock, RST);
 
	input logic counter2, RST, Clock;
	output logic [6:0] hexout;
	output logic carry1;
	
	enum {zero, one, two, three, four, five, six, seven, eight, nine} ps, ns;

	always_comb begin
		case(ps)
			zero: if (counter2 == 1) ns = one;
					else ns = zero;
			one: if (counter2 == 1) ns = two;
					else ns = one;
			two: if (counter2 == 1) ns = three;
					else ns = two;
			three: if (counter2 == 1) ns = four;
					else ns = three;
			four: if (counter2 == 1) ns = five;
					else ns = four;
			five: if (counter2 == 1) ns = six;
					else ns = five;
			six: if (counter2 == 1) ns = seven;
					else ns = six;
			seven: if (counter2 == 1) ns = eight;
					else ns = seven;
			eight: if (counter2 == 1) ns = nine;
					else ns = eight;
			nine: if (counter2 == 1) ns = zero;
					else ns = nine;
		endcase
	end
	
	always_comb begin
		case(ps)
			zero: hexout = 7'b1000000;
			one: hexout = 7'b1111001;
			two: hexout = 7'b1111001;
			three: hexout = 7'bb0110000;
			four: hexout = 7'b0011001;
			five: hexout = 7'b0010010;
			six: hexout = 7'b0000010;
			seven: hexout = 7'b1111000;
			eight: hexout = 7'b0000000;
			nine: hexout = 7'b0010000;
		endcase
	end
 
 assign carry1 = (ps == nine & counter2 == 1);

	//DFF
	always_ff @(posedge Clock) begin
		if (RST)
			ps <= zero;
		else
			ps <= ns;
	end
 
 endmodule 
 
 module scoreboard_testbench();
 	 logic counter2, RST, Clock;
	 logic [6:0] hexout;
	 logic carry1;

 scoreboard dut (.counter2, .carry1, .hexout, .Clock, .RST);
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
                           
						counter2 <= 0; @(posedge Clock); //Running if key = 0 for 3 cycles
                           @(posedge Clock);
                           @(posedge Clock);
						counter2 <= 1; @(posedge Clock); //Running if key = 1 for 3 cycles
                           @(posedge Clock);
                           @(posedge Clock);
						counter2 <= 0; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
						counter2 <= 1; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
						 counter2 <= 0; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
						counter2 <= 1; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);		

       $stop; // End the simulation.
   end
endmodule 