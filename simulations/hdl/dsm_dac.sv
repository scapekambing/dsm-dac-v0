module dsm_dac (
output 			dsm_out,
input 			clk,
input [7:0] dsm_in
);

	reg [8:0] dsm_accumulator = 0;

	always @(posedge clk)
		if (dsm_in != 1'bx)
			dsm_accumulator <= dsm_accumulator[7:0] + dsm_in;

	assign dsm_out = dsm_accumulator[8];

endmodule