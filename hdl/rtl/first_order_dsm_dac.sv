`timescale 1ns / 1ps

module first_order_dsm_dac(
  input 								clk      ,
	input									rst			 ,
  input 				[15:0] 	dsm_in   ,
	input  								clk_en   ,
  output logic 					dsm_out   
);
	localparam WIDTH = 16;
	localparam EXT = 2; // 1 for sign + 1 for accumulating msb output
	
	// accumulator with sign extension
  logic [WIDTH+EXT-1:0] dsm_acc;

	// for sign extension
  logic [WIDTH+EXT-1:0] dsm_in_extended;
	assign dsm_in_extended = {dsm_in[WIDTH-1], dsm_in[WIDTH-1], dsm_in};

	// operation
  always_ff @(posedge clk) begin
		if (~rst) begin
			dsm_acc <= 18'd0;
			dsm_out <= 1'b0;
		end
		else begin
			if (clk_en == 1'b1) begin
				if(dsm_out == 1'b1) begin
						// if the last output was 1, then we outputed a more postiive value 
						// then that means we overshot 
						// the desired val, so subtract
						dsm_acc = dsm_acc + dsm_in_extended // sigma
											- (2**15); // delta
				end
				else begin
						// if the last output was 0, then that means we undershot
						dsm_acc = dsm_acc + dsm_in_extended // sigma
											+ (2**15); // delta
				end

				// When the high bit is set (a negative value) 
				// we need to output a 0 and when it is clear we need to output a 1.
				dsm_out = ~dsm_acc[WIDTH+EXT-1];

			end 
		end
	end

endmodule
