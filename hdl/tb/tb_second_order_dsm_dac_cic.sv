`timescale 1ns/1ns

`include "vunit_defines.svh"
`include "../rtl/sin_gen.sv"
`include "../rtl/first_order_dsm_dac.sv"
`include "../rtl/second_order_dsm_dac.sv"
`include "../rtl/comb.sv"
`include "../rtl/integrator.sv"
`include "../rtl/clk_div.sv"

module tb_second_order_dsm_dac_cic();

  localparam WIDTH = 16;
  localparam R = 50;
  localparam M = 1;
  localparam N = 1;
  localparam GROWTH = N*$clog2(R*M);
  localparam SIGN = 1;
  localparam CIC_WIDTH = WIDTH + GROWTH + SIGN;

  integer i;
  integer n_pts;
  integer n_cycles;
  integer n_complete_waves;
  integer i_clk_en;

  logic clk;
  logic clk_en;
  logic rst;
  logic [WIDTH-1:0] sin_out;
  logic [CIC_WIDTH-1:0] comb_out;
  logic [CIC_WIDTH-1:0] cic_out;
  logic dsm_out_1st;
  logic dsm_out_2nd;
  
  // clock generation
  localparam clk_period = 10;
  always begin
    #(clk_period/2) clk = ~clk;
  end

  // gen clk for sin_gen
  localparam div_const = R;
  clk_div # (
    .DIV(div_const)
  )
  clk_en_gen ( 
    .clk_in(clk),
    .rst(rst),
    .clk_en(clk_en)
  );

  // f = 100MHz/n_pts/div_const
  sin_gen wave_gen (
    .clk(clk),
    .rst(rst),
    .clk_en(clk_en),
    .out(sin_out)
  );

  comb #(
    .WIDTH(WIDTH),
    .GROWTH(GROWTH)
  ) comb_inst (
    .in(sin_out),
    .out(comb_out),
    .rst(rst),
    .clk(clk),
    .clk_en(clk_en)
  );

  integrator #(
    .WIDTH(WIDTH),
    .GROWTH(GROWTH)
  ) integrator_inst (
    .in(comb_out),
    .out(cic_out),
    .rst(rst),
    .clk(clk),
    .clk_en(clk_en)
  );

  first_order_dsm_dac # (
    .WIDTH(CIC_WIDTH-SIGN)
  )
  dac_1st_order (
    .clk(clk),
    .rst(rst),
    .dsm_in(cic_out),
    .clk_en(clk), // follow clk for osr
    .dsm_out(dsm_out_1st)
  );

  second_order_dsm_dac # (
    .WIDTH(CIC_WIDTH-SIGN)
  )
  dac_2nd_order (
    .clk(clk),
    .rst(rst),
    .dsm_in(cic_out),
    .clk_en(clk), // follow clk for osr
    .dsm_out(dsm_out_2nd)
  );


  `TEST_SUITE begin

    `TEST_CASE("op") begin
      // init vals
      n_pts = 50;
      n_cycles = 10;

      // reset pulse
      clk = 0;
      rst = 0;
      #(clk_period);
      rst = 1;

      // clk_en alignment
      #(clk_period/2);

      for (i = 0; i <= 50_000; i = i + 1) begin
          $display("%d, %d, %b, %b", i, $signed(sin_out), dsm_out_1st, dsm_out_2nd);
          #(clk_period);
      end

    end

  end
endmodule
