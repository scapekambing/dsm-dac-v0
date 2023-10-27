// `default_nettype none

module axis_zoh # (
  parameter WIDTH = 16,
  parameter GROWTH = 7, // (N*$clog2(R*M))
  parameter SIGN = 1,

  parameter R = 100,

  parameter CIC_WIDTH = WIDTH + GROWTH + SIGN

)
(
  input        [CIC_WIDTH - 1:0]              s_axis_data_tdata ,
  output                                      s_axis_data_tready,
  input                                       s_axis_data_tvalid,

  input                                       aclk,
  input                                       arst_n,
  
  output       [CIC_WIDTH-1:0]               m_axis_data_tdata,
  output  logic                              m_axis_data_tvalid
);
  

  logic        [CIC_WIDTH - 1:0]             current_state;
  logic        [CIC_WIDTH - 1:0]             next_state;
  logic        [CIC_WIDTH - 1:0]             zoh_out;
  logic                                       en;
  logic                                      tready;


  always_ff @(posedge aclk) begin
    if (~arst_n) begin
      current_state  <= 0;
      m_axis_data_tvalid <= 0;
    end 
    else if (en) begin
      current_state <= next_state;
      m_axis_data_tvalid <= 1;
    end
  end

  // sensitivity list is infered from the expression
  always_comb begin 
    // enable logic
    en                  = tready && s_axis_data_tvalid;
    zoh_out             = current_state;
  end

  assign tready = 1;

  assign s_axis_data_tready = tready;
  assign m_axis_data_tdata = zoh_out;
  assign next_state = s_axis_data_tdata;
  
endmodule

// `default_nettype wire