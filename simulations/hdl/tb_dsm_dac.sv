`timescale 1ns/1ns

`include "vunit_defines.svh"

module tb_dsm_dac();

  integer i;
  integer n_cycles;
  integer n_pts;
  integer n_complete_waves;

  reg clk;
  wire clk_1MHz;
  wire [15:0] sin_out;
  wire dsm_out;
  wire n_dsm_out;

  assign n_dsm_out = !dsm_out;

  // clock generation
  localparam clk_period = 10;
  initial begin
    clk = 0;
  end
  always begin
    #(clk_period/2) clk = ~clk;
  end

  // gen clk for sin_gen
  localparam osr = 100;
  localparam div_const = osr;
  clk_div # (
    .DIV(div_const)
  )
  clk_gen ( 
    .clk_in(clk),
    .clk_out(clk_1MHz)
  );

  sin_gen wave_gen (
    .clk(clk_1MHz),
    .out(sin_out) // 1 / n_pts * 10 div_constant * 10 ns = 1MHz / n_pts
  );

  dsm_dac dac (
    .clk(clk),
    .dsm_in(sin_out),
    .dsm_out(dsm_out)
  );

  `TEST_SUITE begin
    
    // `TEST_CASE("sanity") begin
    //   $display("This test case is expected to pass");
    //   `CHECK_EQUAL(1, 1, "woo!");
    // end

    `TEST_CASE("op") begin
      n_pts = 97;
      n_cycles = n_pts;
      n_complete_waves = 1;
      // $monitor("i=%d, time=%0t, clk_in=%b, clk_out=%b", i, $time, clk, clk_1MHz);
      for (i = 0; i < div_const*n_cycles*n_complete_waves; i = i + 1) begin
        #(clk_period);
      end
    end
  end
endmodule