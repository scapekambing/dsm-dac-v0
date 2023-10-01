`timescale 1ns/1ns

`include "vunit_defines.svh"

module tb_clk_div();

  reg clk;
  wire clk_out;

  // clock generation
  localparam clk_period = 10;
  initial clk = 0;
  always begin
    #(clk_period/2) clk = ~clk;
  end

  // dut
  localparam div_const = 10;
  clk_div # (
    .DIV(div_const)
  )
  dut ( 
    .clk_in(clk),
    .clk_out(clk_out)
  );

  `TEST_SUITE begin
    
    `TEST_CASE("sanity") begin
      $display("This test case is expected to pass");
      `CHECK_EQUAL(1, 1, "woo!");
    end

    `TEST_CASE("operation") begin
      integer i;
      integer n_cycles;

      n_cycles = 10;
      $monitor("i=%d, time=%0t, clk_in=%b, clk_out=%b", i, $time, clk, clk_out);
      for (i = 0; i < div_const*n_cycles; i = i + 1) begin
        #(clk_period);
          if (i % div_const+1 == 0) begin
            `CHECK_EQUAL(clk_out, clk)
          end
      end
    end
  end
endmodule