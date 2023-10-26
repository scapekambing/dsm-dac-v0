`timescale 1ns / 1ps

module second_order_dsm_dac #(
	parameter WIDTH = 16,
	parameter EXT = 4 // (1 for sign + 1 for accumulating msb output)*2
)
(
  input 								clk      ,
	input									rst			 ,
  input 				[WIDTH-1:0] 	dsm_in   ,
	input  								clk_en   ,
  output logic 					dsm_out   
);

	
	// accumulator with extension
  logic [WIDTH+EXT-1:0] dsm_acc_1st;
	logic [WIDTH+EXT-1:0] dsm_acc_2nd;

	// for sign extension
  logic [WIDTH+EXT-1:0] dsm_in_extended;
	assign dsm_in_extended = {dsm_in[WIDTH-1], dsm_in[WIDTH-1], dsm_in[WIDTH-1], dsm_in[WIDTH-1], dsm_in};

	// operation
  always_ff @(posedge clk) begin
		if (~rst) begin
			// dsm_acc_1st <= 20'd0;
			// dsm_acc_2nd <= 20'd0;
			dsm_acc_1st <= {27{1'b0}};
			dsm_acc_2nd <= {27{1'b0}};
			dsm_out <= 0;
		end
		else begin
			if (clk_en == 1'b1) begin
				if(dsm_out == 1'b1) begin
						// if the last output was 1, then we outputed a more postiive value 
						// then that means we overshot 
						// the desired val, so subtract

						// use blocking
						dsm_acc_1st = dsm_acc_1st + dsm_in_extended // sigma
														- (2**(22-1)); // delta
						dsm_acc_2nd = dsm_acc_2nd + dsm_acc_1st // sigma
														- (2**(22-1)); // delta
				end
				else begin
						// use blocking
						dsm_acc_1st = dsm_acc_1st + dsm_in_extended // sigma
														+ (2**(22-1)); // delta
						dsm_acc_2nd = dsm_acc_2nd + dsm_acc_1st // sigma
														+ (2**(22-1)); // delta
				end

				// When the high bit is set (a negative value) 
				// we need to output a 0 and when it is clear we need to output a 1.
				dsm_out <= ~dsm_acc_2nd[WIDTH+EXT-1];

			end 
		end
	end

endmodule
