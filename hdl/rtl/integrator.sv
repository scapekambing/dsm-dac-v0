// `default_nettype none

module integrator # (
  parameter WIDTH = 16,
  parameter GROWTH = 7, // (N*$clog2(R*M))
  parameter SIGN = 1,

  parameter INTEGRATOR_WIDTH = WIDTH + GROWTH + SIGN
)
(
  input        [INTEGRATOR_WIDTH - 1:0]       in,
  input                                       clk,
  input                                       rst,
  input                                       clk_en,
  output  logic [INTEGRATOR_WIDTH-1:0]              out
);
  

  logic [INTEGRATOR_WIDTH - 1:0]    integrator_delay_r,
                              integrator_current_r;

  always_ff @(posedge clk) begin
    if (~rst) begin
      integrator_delay_r <= 0;
      integrator_current_r <= 0;
      out <= 0;
    end 
    else begin
        integrator_delay_r <= out;
        integrator_current_r <= in;
        out <= integrator_current_r + integrator_delay_r;
    end
  end

  // // sensitivity list is infered from the expression
  // always_comb begin 
  //   out <= integrator_current_r + integrator_delay_r;
  // end

endmodule

// `default_nettype none