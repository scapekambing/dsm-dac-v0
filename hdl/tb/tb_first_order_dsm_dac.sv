`timescale 1ns/1ns

`include "vunit_defines.svh"

`include "../rtl/clk_div.sv"
`include "../rtl/sin_gen.sv"
`include "../rtl/first_order_dsm_dac.sv"


module tb_first_order_dsm_dac();

  localparam DATA_WIDTH = 16;

  integer i;
  integer n_cycles;
  integer n_pts;
  integer n_complete_waves;

  logic clk;
  logic clk_en;
  logic rst;
  logic [DATA_WIDTH-1:0] sin_out;
  logic dsm_out;

  // clock generation
  localparam clk_period = 5;
  always begin
    #(clk_period/2) clk = ~clk;
  end

  // gen clk for sin_gen
  localparam div_const = 2;
  clk_div # (
    .DIV(div_const)
  )
  clk_en_gen ( 
    .clk_in(clk),
    .rst(rst),
    .clk_en(clk_en)
  );

  sin_gen wave_gen (
    .clk(clk),
    .rst(rst),
    .clk_en(clk_en),
    .out(sin_out)
  );

  first_order_dsm_dac dac (
    .clk(clk),
    .rst(rst),
    .dsm_in(sin_out),
    .clk_en(clk), // follow clk for osr
    .dsm_out(dsm_out)
  );

  `TEST_SUITE begin

    `TEST_CASE("sanity") begin
      $display("This test case is expected to pass");
      `CHECK_EQUAL(1, 1, "woo!");
    end

    `TEST_CASE("clk_en_gen_op") begin
      n_cycles = 10;
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

    `TEST_CASE("wave_gen_op") begin
      // init vals
      n_pts = 50;
      n_complete_waves = 1;

      // reset pulse
      clk = 0;
      rst = 0;
      #clk_period;
      rst = 1;

      $display("divider=%d", div_const);
      $monitor("time=%0t, clk=%b, clk_en=%b, out=%d", $time, clk, clk_en, $signed(sin_out));
      // clk_en alignment
      #(clk_period/2);
      for (i = 0; i <= n_pts*n_complete_waves*div_const; i = i + 1) begin
          #(clk_period);
      end
      `CHECK_EQUAL($signed(sin_out), -1028)
    end

    // python run_first_order_dsm_dac.py -v dsm_dac.tb_first_order_dsm_dac.op -g
    `TEST_CASE("op") begin
      // init vals
      n_pts = 50;
      n_complete_waves = 1;

      // reset pulse
      clk = 0;
      rst = 0;
      #clk_period;
      rst = 1;

      #(clk_period/2);
      for (i = 0; i <= n_pts*n_complete_waves*div_const; i = i + 1) begin
          #(clk_period);
      end

    end

  end
endmodule
