module comb # (
  parameter WIDTH = 16,
  parameter GROWTH = 7, // (N*$clog2(R*M))
  parameter SIGN = 1,

  parameter INTEGRATOR_WIDTH = WIDTH + GROWTH + SIGN
)
(
  input        [WIDTH - 1:0]                  in,
  input                                       rst,
  input                                       clk_en,
  output logic [INTEGRATOR_WIDTH:0]  out
);
  

  logic [COMB_WIDTH - 1:0]    comb_delay_r;
                              in_extended;

  assign in_extended = { {(SIGN+GROWTH){in[WIDTH-1]}} , in};

  always_ff @(posedge clk) begin
    if (~rst) begin
      comb_r <= 0;
      comb_delay_r <= 0;
    end 
    else if (clk_en) begin
      comb_delay_r <= in_extended; 
    end
  end

  always_comb begin
    out = in_extended - comb_delay_r;
  end

endmodule