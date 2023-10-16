`timescale 1ns/1ns

`include "vunit_defines.svh"
`include "../rtl/sin_gen.sv"

module tb_sin_gen ();

  parameter div_const = 2;
  localparam DATA_WIDTH = 16;

  integer i;
  integer n_pts;
  integer n_complete_waves;
  integer cnt;

  // signal inst
  logic       clk;
  logic       rst;
  logic       clk_en;
  logic [DATA_WIDTH-1:0] out;

  // 100MHz clock generation
  localparam clk_period = 10; // ns 
  always begin
      #(clk_period/2) clk = ~clk;
  end
    
  sin_gen dut (
    .clk(clk),
    .rst(rst),
    .clk_en(clk_en),
    .out(out)
  );

  `TEST_SUITE begin
    `TEST_CASE("sanity") begin
      $display("This test case is expected to pass");
      `CHECK_EQUAL(1, 1, "woo!");
    end

    `TEST_CASE("op") begin
      // init vals
      clk_en = 0;
      n_pts = 50;
      n_complete_waves = 1;
      cnt = 0;

      // reset pulse
      clk = 0;
      clk_en = 0;
      rst = 0;
      #clk_period;
      rst = 1;

      $display("divider=%d", div_const);
      $monitor("time=%0t, clk=%b, clk_en=%b, out=%d", $time, clk, clk_en, $signed(out));
      // clk_en alignment
      #(clk_period/2);
      for (i = 0; i <= n_pts*n_complete_waves*div_const; i = i + 1) begin
          #(clk_period);
          if (cnt==div_const-1) begin
              clk_en = 1;
              cnt = 0;
          end else begin
              clk_en = 0;
              cnt = cnt + 1;
          end 
      end
      `CHECK_EQUAL($signed(out), -1028)
    end

  end


endmodule
