`timescale 1ns / 1ps
module dsm_dac(
  input logic clk,
  input logic [7:0] dsm_in,
	input logic enb, 
  output logic dsm_out
);

  logic this_bit;
	
	// accumulator
  logic [9:0] dsm_acc  = 0;
	logic [9:0] intermediate = 0;

	// for sign extension
  logic  [9:0] dsm_in_extended;
	always @(*) begin
		dsm_in_extended <= {dsm_in[7], dsm_in[7], dsm_in};
	end

	// dac output
  assign dsm_out = this_bit;
    
  always @(posedge clk) begin
		if (enb == 1)
			if(this_bit == 1'b1) begin
					intermediate <= dsm_in_extended + (2**7);
					dsm_acc <= dsm_acc + intermediate;
			end
			else begin
					intermediate <= dsm_in_extended - (2**7);
					dsm_acc <= dsm_acc + intermediate;
			end

		// When the high bit is set (a negative value) we need to output a 0 and when it is clear we need to output a 1.
		this_bit <= ~dsm_acc[9];
	end 
endmodule