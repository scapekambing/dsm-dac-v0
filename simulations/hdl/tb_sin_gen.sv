`timescale 1ns/1ns

`include "vunit_defines.svh"

module tb_sin_gen ();

  integer i;
  integer n_pts;

  // signal inst
  reg clk;
  wire [7:0] out;

  sin_gen dut (
    .clk(clk),
    .out(out)
  );

  // clock generation
  localparam clk_period = 10;
  initial clk = 0;
  always begin
      #(clk_period/2) clk = ~clk;
  end

  `TEST_SUITE begin
    `TEST_CASE("sanity") begin
      $display("This test case is expected to pass");
      `CHECK_EQUAL(1, 1, "woo!");
    end
    `TEST_CASE("operation") begin
      n_pts = 97;
      $monitor("time=%0t, clk=%b, out=%b", $time, clk, out);
      for (i = 0; i < n_pts; i = i + 1) begin
          #(clk_period);
      end
      //$finish;
      `CHECK_EQUAL(out, 16'b0)
    end
  end


endmodule
