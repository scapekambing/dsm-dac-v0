// `default_nettype none

module axis_integrator # (
  parameter WIDTH = 16,
  parameter GROWTH = 7, // (N*$clog2(R*M))
  parameter SIGN = 1,

  parameter CIC_WIDTH = WIDTH + GROWTH + SIGN
)
(
  input        [CIC_WIDTH - 1:0]              s_axis_data_tdata ,
  output                                      s_axis_data_tready,
  input                                       s_axis_data_tvalid,

  input                                       aclk,
  input                                       arst_n,
  
  output       [CIC_WIDTH-1:0]                m_axis_data_tdata,
  output  logic                               m_axis_data_tvalid
);
  

  logic        [CIC_WIDTH - 1:0]             intg_delay;
  logic        [CIC_WIDTH - 1:0]             intg_current;
  logic        [CIC_WIDTH - 1:0]             intg_out;

  logic                                      tready;     
  logic                                      en;

  always_ff @(posedge aclk) begin
    if (~arst_n) begin
      intg_delay    <= 0;
      m_axis_data_tvalid <= 0;
    end 
    else if (en) begin
      intg_delay  <= intg_out; 
      m_axis_data_tvalid <= 1;
    end
    else begin
      m_axis_data_tvalid <= 0;
    end
  end

  // sensitivity list is infered from the expression
  always_comb begin 
    // default
    en  = tready && s_axis_data_tvalid;

    case (m_axis_data_tvalid)
      1'b0    :   intg_out = 0;   
      default :   intg_out = intg_current + intg_delay;
    endcase

  end

  assign tready = 1;

  assign s_axis_data_tready = tready;
  assign m_axis_data_tdata = intg_out;
  assign intg_current = s_axis_data_tdata;

endmodule

// `default_nettype wire