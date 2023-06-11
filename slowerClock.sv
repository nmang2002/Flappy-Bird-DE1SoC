

//Making a slower clock so that the pipes dont move fast and 
//make the user lose by default.

module slowerClock (Clock, RST, slow_Clock);
		input logic Clock, RST;
	output logic slow_Clock;
	
	logic [32:0] counter; //counter for dividing clock
	
	always_ff @(posedge Clock) begin
		if (RST) begin //hitting RST also makes the counter go back to 0
			counter <= 0;
			slow_Clock <= 0; //sets the clock back to 0
		end else if (counter == 8'b11111111) begin //if counter reaches 8'b11111111, it RSTs
			counter <= 0;
			slow_Clock <= ~slow_Clock; //clock is equal to 1 here
		end else begin
			counter <= counter + 1; //counter counter2ements by one
			slow_Clock <= 0; 
		end
	end
	

endmodule
