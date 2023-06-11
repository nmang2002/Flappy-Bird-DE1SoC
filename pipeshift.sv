module pipeshift (genPipes, out, Clock, slowdown, RST);

	input logic slowdown, Clock, RST;
	input logic [15:0] genPipes;
	output logic [15:0][15:0] out;
	
	always_ff @(posedge Clock) begin
		if (RST)
			out <= 16'b0;
		else if (slowdown == 1) begin
				out <= {genPipes, out[15:1]};
		end
		else
			out <= out;
	end
endmodule 

module pipeshift_testbench();
 logic Clock, RST, slowdown, gen;
  logic [15:0] genPipes;
	 logic [15:0][15:0] out;

 pipeshift dut (.genPipes, .out, .Clock, .slowdown, .RST);
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
                           
						slowdown <= 0; @(posedge Clock); //Running if key = 0 for 3 cycles
                           @(posedge Clock);
                           @(posedge Clock);
						slowdown <= 1; genPipes <= 16'b0000000000010111; @(posedge Clock); //Running if key = 1 for 3 cycles
                           @(posedge Clock);
                           @(posedge Clock);
						slowdown <= 0; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
						slowdown <= 1; genPipes <= 16'b0000000000011111; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
						slowdown <= 0; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);
						slowdown <= 1; genPipes <= 16'b0000000000011101; @(posedge Clock); 
                           @(posedge Clock);
                           @(posedge Clock);		

       $stop; // End the simulation.
   end
endmodule 