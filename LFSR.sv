module LFSR(Clock, RST, out);
	input logic Clock, RST;
	output logic [9:0] out;
	
	always_ff @(posedge Clock)begin
		if (RST)
			out <= 10'b0000000000;
			else begin
				out <= out >> 1;
				out[9] <= ~(out[3] ^ out[0]);
			end
		end
endmodule

module LFSR_testbench();

 logic Clock, RST;
 logic [9:0] out;
 
 LFSR dut(Clock, RST, out);
 
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
                           @(posedge Clock);
                           @(posedge Clock);
                           @(posedge Clock);
                     @(posedge Clock);
                     @(posedge Clock);
                     @(posedge Clock);
                           @(posedge Clock);
                           @(posedge Clock);
                           @(posedge Clock);
                     @(posedge Clock);
                           @(posedge Clock);
       $stop; // End the simulation.
   end
endmodule 
