`timescale 1ns/1ns

`include "vunit_defines.svh"
`include "../rtl/axis_sin_gen.sv"
`include "../rtl/axis_comb.sv"
`include "../rtl/axis_integrator.sv"
`include "../rtl/axis_zoh.sv"
`include "../rtl/axis_first_order_dsm_dac.sv"
`include "../rtl/axis_second_order_dsm_dac.sv"



module tb_axis_second_order_dsm_dac_cic();

  localparam WIDTH = 16;
  localparam R = 100;
  localparam M = 1;
  localparam N = 1;
  localparam GROWTH = N*$clog2(R*M);
  localparam SIGN = 1;
  localparam CIC_WIDTH = WIDTH + GROWTH + SIGN;

  integer i;
  integer n_pts = 50;
  integer n_cycles = 1;
  integer n_complete_waves = 20;
  integer freq = 100_000_000/R/n_pts;
 

  logic aclk;
  logic arst_n;


  // sine wave gneerator 
  logic [WIDTH-1:0] tx_data; 
  logic             tx_data_tvalid; 


  // cic filter 
  logic [CIC_WIDTH-1:0] comb_data; 
  logic                 comb_data_tvalid;

  logic [CIC_WIDTH-1:0] zoh_data;
  logic                 zoh_data_tvalid; 
 
  logic [CIC_WIDTH-1:0] intg_data;
  logic                 intg_data_tvalid; 
  

  // 1st order dsm
  logic dsm1_data;
  logic dsm1_data_tvalid;

  // 2nd order dsm
  logic dsm2_data;
  logic dsm2_data_tvalid;


  // clock generation
  localparam clk_period = 10;
  always begin
    #(clk_period/2) aclk = ~aclk;
  end

  // f = 100MHz/n_pts/div_const
  axis_sin_gen # ( 
    .DIV(R) 
  ) 
  wave_gen ( 
    .aclk(aclk),
    .arst_n(arst_n),
    .m_axis_data_tdata(tx_data),
    .m_axis_data_tvalid(tx_data_tvalid)
  ); 

  axis_comb # (
    .CIC_WIDTH(CIC_WIDTH),
    .GROWTH(GROWTH)
  )
  comb_filter (
    .aclk(aclk),
    .arst_n(arst_n),

    // inputs
    .s_axis_data_tdata(tx_data),
    .s_axis_data_tvalid(tx_data_tvalid),
    .s_axis_data_tready(),
    
    // outputs
    .m_axis_data_tdata(comb_data),
    .m_axis_data_tvalid(comb_data_tvalid)
  );

  axis_zoh # (
    .CIC_WIDTH(CIC_WIDTH),
    .R(R)
  )
  zoh_filter (
    .aclk(aclk),
    .arst_n(arst_n),

    // inputs
    .s_axis_data_tdata(comb_data),
    .s_axis_data_tvalid(comb_data_tvalid),
    .s_axis_data_tready(), // always ready
    
    // outputs
    .m_axis_data_tdata(zoh_data),
    .m_axis_data_tvalid(zoh_data_tvalid)
  );

  axis_integrator # (
    .CIC_WIDTH(CIC_WIDTH)
  )
  integrator_filter (
    .aclk(aclk),
    .arst_n(arst_n),

    // inputs
    .s_axis_data_tdata(zoh_data),
    .s_axis_data_tvalid(zoh_data_tvalid),
    .s_axis_data_tready(),
    
    // outputs
    .m_axis_data_tdata(intg_data),
    .m_axis_data_tvalid(intg_data_tvalid)
  );

  // FIRST ORDER DSM
  axis_first_order_dsm_dac # (
    .WIDTH(CIC_WIDTH-SIGN) // this modules assumes a width without sign bit
  )
  first_order_dsm (
    .aclk(aclk),
    .arst_n(arst_n),

    // inputs
    .s_axis_data_tdata(intg_data),
    .s_axis_data_tvalid(intg_data_tvalid),
    .s_axis_data_tready(),
    
    // outputs
    .m_axis_data_tdata(dsm1_data),
    .m_axis_data_tvalid(dsm1_data_tvalid)
  );

  // SECOND ORDER DSM
  axis_second_order_dsm_dac # (
    .WIDTH(CIC_WIDTH-SIGN) // this modules assumes a width without sign bit
  )
  second_order_dsm (
    .aclk(aclk),
    .arst_n(arst_n),

    // inputs
    .s_axis_data_tdata(intg_data),
    .s_axis_data_tvalid(intg_data_tvalid),
    .s_axis_data_tready(),
    
    // outputs
    .m_axis_data_tdata(dsm2_data),
    .m_axis_data_tvalid(dsm2_data_tvalid)
  );

`TEST_SUITE begin

  `TEST_CASE("op") begin
    // init vals
    aclk = 0;

    // reset pulse
    arst_n = 0;
    #(clk_period);
    arst_n = 1;
    #(clk_period);

    $display("divider=%d", R);
    $display("f=%d", freq);
    for (i = 0; i <= n_pts*n_complete_waves*R; i = i + 1) begin
         $display("%d, %d, %b, %b", i, $signed(tx_data), dsm1_data, dsm2_data);
        #(clk_period);
    end
    `CHECK_EQUAL($signed(tx_data), 0)
    end

  end
endmodule
