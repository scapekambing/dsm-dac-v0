`timescale 1ns / 1ps

module axis_second_order_dsm_dac #(
	parameter WIDTH = 16,
	parameter EXT = 4 // (1 for sign + 1 for accumulating msb output)*2
)
(
  input 												aclk      				,
	input													arst_n,

  input 				[WIDTH-1:0] 		s_axis_data_tdata	,
	input 							 					s_axis_data_tvalid,
	output 							 					s_axis_data_tready,
  
	output 							          m_axis_data_tdata	,
	output 												m_axis_data_tvalid	 // unused
);

	localparam SIGN = 1;

	// accumulator with extension
  logic [WIDTH+EXT-1:0] dsm_acc_1st;
	logic [WIDTH+EXT-1:0] dsm_acc_2nd;

	
	// for sign extension
  logic [WIDTH+EXT-1:0] dsm_in_extended;
	assign dsm_in_extended = {{EXT{s_axis_data_tdata[WIDTH-1]}}, s_axis_data_tdata};

	
	// output
	logic dsm_out;

	
	// axis
	logic en;
	logic tready;
	assign tready = 1'b1;
	logic tvalid;


	// operation
  always_ff @(posedge aclk) begin
		if (~arst_n) begin
			// dsm_acc_1st <= 20'd0;
			// dsm_acc_2nd <= 20'd0;
			dsm_acc_1st <= {(WIDTH+EXT){1'b0}};
			dsm_acc_2nd <= {(WIDTH+EXT){1'b0}};
			dsm_out <= 0;
			tvalid <= 0;
		end
		else if (en) begin
			if(dsm_out == 1'b1) begin
					// if the last output was 1, then we outputed a more postiive value 
					// then that means we overshot 
					// the desired val, so subtract

					// use blocking
					dsm_acc_1st = dsm_acc_1st + dsm_in_extended // sigma
													- (2**(WIDTH-1)); // delta
					dsm_acc_2nd = dsm_acc_2nd + dsm_acc_1st // sigma
													- (2**(WIDTH-1)); // delta
			end
			else begin
					// use blocking
					dsm_acc_1st = dsm_acc_1st + dsm_in_extended // sigma
													+ (2**(WIDTH-1)); // delta
					dsm_acc_2nd = dsm_acc_2nd + dsm_acc_1st // sigma
													+ (2**(WIDTH-1)); // delta
			end

			// When the high bit is set (a negative value) 
			// we need to output a 0 and when it is clear we need to output a 1.
			tvalid 	<=	1;
			dsm_out <= ~dsm_acc_2nd[WIDTH+EXT-1];
		end 
	end

	always_comb begin
		en = s_axis_data_tvalid && tready;
	end

	assign s_axis_data_tready = tready;
	assign m_axis_data_tdata = dsm_out;
	assign m_axis_data_tvalid = tvalid;

endmodule
