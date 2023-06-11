module makepipe (out, Clock, slowdown, RST);
	input logic slowdown, Clock, RST;
	output logic [15:0] out;
	logic [9:0] in;
	
	LFSR l1 (.Clock(Clock), .RST(RST), .out(in));
	
	integer a, count, i; 

	always_ff @(posedge Clock) begin
		if (RST) begin
			out <= '0;
			count <= 3'b111; //gap between each pipe,
		end
		else if (slowdown == 0 & count == 0) begin
			count <= 3'b111;
			for (i = 0; i < 16; i++) begin
				if (i < a | i > (a + 4)) 
					out[i] <= 1'b1;
				else
					out[i] <= 1'b0;
			end
		end

		else if (slowdown == 1 & count == 1) begin 
			a <= in % (i-2);
			count <= count - 1;
		end
		else if (slowdown == 1) begin
			count <= count - 1;
			out <= '0;
		end
	end
endmodule 


module makepipe_testbench();
	logic RST, slowdown;
	logic [15:0] out;
	logic CLOCK_50;
	
	makepipe dut ( .out, .Clock(CLOCK_50), .slowdown, .RST);
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
		RST <= 1; slowdown <= 0; repeat(10) @(posedge CLOCK_50); // RST the module
		
		RST <= 0; slowdown <= 1; repeat (5) @(posedge CLOCK_50)
		
		RST <= 1; slowdown <= 0; repeat(10) @(posedge CLOCK_50); // RST the module
		
		RST <= 0; slowdown <= 1; repeat (5) @(posedge CLOCK_50)
		
		RST <= 1; repeat(10) @(posedge CLOCK_50); // RST the module
		$stop;
	end
endmodule 