`timescale 1ns/1ns

`include "vunit_defines.svh"
`include "../rtl/clk_div.sv"

module tb_clk_div();

   // parameterized
  parameter div_const = 4;

  integer i;
  integer n_cycles = 10;

  logic clk;
  logic clk_en;
  logic rst;

  // clock generation
  localparam clk_period = 10 ; 
  always begin
    #(clk_period/2) clk = ~clk;
  end

  // dut
  clk_div # (
    .DIV(div_const)
  )
  dut ( 
    .clk_in(clk),
    .rst(rst),
    .clk_en(clk_en)
  );

  `TEST_SUITE begin
    
    `TEST_CASE("sanity") begin
      $display("This test case is expected to pass");
      `CHECK_EQUAL(1, 1, "woo!");
    end


    `TEST_CASE("operation") begin
      clk = 0;

      // initiate rst pulse to initialize logic
      rst = 0;
      #(clk_period);
      rst = 1;

      $monitor("i=%d, time=%0t, clk_in=%b, clk_out=%b", i, $time, clk, clk_en);
      for (i = 0; i < div_const*n_cycles; i = i + 1) begin
        #(clk_period);
        if (i & div_const == 0) begin
          `CHECK_EQUAL(clk_en, 1, "clk_en should be high");
        end
      end
    end
  end
endmodule