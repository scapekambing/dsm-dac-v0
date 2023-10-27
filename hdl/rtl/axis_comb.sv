// `default_nettype none

module axis_comb # (
  parameter WIDTH = 16,
  parameter GROWTH = 7, // (N*$clog2(R*M))
  parameter SIGN = 1,

  parameter CIC_WIDTH = WIDTH + GROWTH + SIGN
)
(
  input         [WIDTH - 1:0]                 s_axis_data_tdata ,
  output                                      s_axis_data_tready,
  input                                       s_axis_data_tvalid,

  input                                       aclk,
  input                                       arst_n,
  
  output        [CIC_WIDTH-1:0]                m_axis_data_tdata,
  output  logic                                m_axis_data_tvalid
);
  

  logic        [CIC_WIDTH - 1:0]             comb_delay;
  logic        [CIC_WIDTH - 1:0]             comb_current;
  logic        [CIC_WIDTH - 1:0]             comb_next;
  logic        [CIC_WIDTH - 1:0]             comb_out;
  
  logic                                      tready;

  logic                                      en;

  always_ff @(posedge aclk) begin
    if (~arst_n) begin
      comb_current    <= 0;
      comb_delay    <= 0;
      m_axis_data_tvalid <= 0;
    end 
    else if (en) begin
      comb_current <= comb_next;
      comb_delay  <= comb_current; 
      m_axis_data_tvalid <= 1;
    end
    else begin
      m_axis_data_tvalid <= 0;
    end
  end

  // sensitivity list is infered from the expression
  always_comb begin 
    // default
    en              = tready && s_axis_data_tvalid   ;

    // comb filter logic
    case (m_axis_data_tvalid)
      1'b0    : comb_out = 0;
      default : comb_out = comb_current - comb_delay;
    endcase

  end

  assign tready = 1'b1;
  assign s_axis_data_tready   = tready;

  assign comb_next         = { {(GROWTH+SIGN){s_axis_data_tdata[WIDTH-1]}}, s_axis_data_tdata};
  assign m_axis_data_tdata    = comb_out;

endmodule

// `default_nettype wire