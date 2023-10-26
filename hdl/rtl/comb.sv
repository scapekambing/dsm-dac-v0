// `default_nettype none

module comb # (
  parameter WIDTH = 16,
  parameter GROWTH = 7, // (N*$clog2(R*M))
  parameter SIGN = 1,

  parameter COMB_WIDTH = WIDTH + GROWTH + SIGN
)
(
  input        [WIDTH - 1:0]                  in,
  input                                       clk,
  input                                       rst,
  input                                       clk_en,
  output  logic [COMB_WIDTH-1:0]              out
);
  

  logic [COMB_WIDTH - 1:0]    comb_delay_r,
                              comb_current_r;

  always_ff @(negedge clk_en) begin
    if (~rst) begin
      comb_delay_r <= 0;
      comb_current_r <= { {(GROWTH+SIGN){in[WIDTH-1]}}, in};
    end 
    else begin
        comb_delay_r <= comb_current_r; 
        comb_current_r <= { {(GROWTH+SIGN){in[WIDTH-1]}}, in};
    end
  end

  // sensitivity list is infered from the expression
  always_comb begin 
    out <= comb_current_r - comb_delay_r;
  end

endmodule

// `default_nettype none