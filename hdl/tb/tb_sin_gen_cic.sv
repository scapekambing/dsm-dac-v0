`timescale 1ns/1ns

`include "vunit_defines.svh"
`include "../rtl/sin_gen.sv"
`include "../rtl/sin_gen_zoh.sv"
`include "../rtl/comb.sv"
`include "../rtl/integrator.sv"
`include "../rtl/clk_div.sv"

module tb_sin_gen_cic();

  localparam WIDTH = 16;
  localparam R = 100;
  localparam M = 1;
  localparam N = 1;
  localparam GROWTH = 7; // (N*$clog2(R*M))
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
  logic [WIDTH-1:0] sin_out_zoh;
  logic [CIC_WIDTH-1:0] comb_out;
  logic [CIC_WIDTH-1:0] cic_out;
  
  // clock generation
  localparam clk_period = 10;
  always begin
    #(clk_period/2) clk = ~clk;
  end

  // gen clk for sin_gen
  localparam div_const = 5;
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

  sin_gen_zoh wave_gen_zoh (
    .clk(clk),
    .rst(rst),
    .clk_en(clk_en),
    .out(sin_out_zoh)
  );

  comb comb_inst (
    .in(sin_out),
    .out(comb_out),
    .rst(rst),
    .clk(clk),
    .clk_en(clk_en)
  );

  integrator integrator_inst (
    .in(comb_out),
    .out(cic_out),
    .rst(rst),
    .clk(clk),
    .clk_en(clk_en)
  );
  


  `TEST_SUITE begin

    `TEST_CASE("wave_gen_op") begin
      // init vals
      n_pts = 50;
      n_complete_waves = 1;

      // reset pulse
      clk = 0;
      rst = 0;
      #(clk_period);
      rst = 1;

      $display("divider=%d", div_const);
      $monitor("time=%0t, clk=%b, clk_en=%b, out=%d", $time, clk, clk_en, $signed(sin_out));
      for (i = 0; i <= n_pts*n_complete_waves*div_const; i = i + 1) begin
          #(clk_period);
      end
      `CHECK_EQUAL($signed(sin_out), -1029)
    end

  end
endmodule
