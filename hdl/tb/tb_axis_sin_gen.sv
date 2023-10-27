`timescale 1ns/1ns

`include "vunit_defines.svh"
`include "../rtl/sin_gen.sv"
`include "../rtl/axis_sin_gen.sv"

module tb_sin_gen ();

  parameter div_const = 10;
  localparam DATA_WIDTH = 16;

  integer i;
  integer n_pts = 50;
  integer n_complete_waves = 2;

  // signal inst
  logic                     aclk;
  logic                     arst_n;

  logic [DATA_WIDTH-1:0]    m_axis_data_tdata;
  logic                     m_axis_data_tvalid;

  // 100MHz clock generation
  localparam clk_period = 10; // ns 
  always begin
      #(clk_period/2) aclk = ~aclk;
  end
    
  axis_sin_gen # (
    .DIV(div_const)
  )
  dut (
    .aclk(aclk),
    .arst_n(arst_n),
    .m_axis_data_tdata(m_axis_data_tdata),
    .m_axis_data_tvalid(m_axis_data_tvalid)
  );

  `TEST_SUITE begin
    // `TEST_CASE("sanity") begin
    //   $display("This test case is expected to pass");
    //   `CHECK_EQUAL(1, 1, "woo!");
    // end

    `TEST_CASE("op") begin
      // init vals
      aclk = 0;

      // reset pulse
      arst_n = 0;
      #(clk_period);
      arst_n = 1;
      #(clk_period);

      $display("divider=%d", div_const);
      for (i = 0; i <= n_pts*n_complete_waves*div_const; i = i + 1) begin
          #(clk_period);
      end
      `CHECK_EQUAL($signed(m_axis_data_tdata), -1028)
    end

  end


endmodule
