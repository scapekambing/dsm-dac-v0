// `default_nettype none

module axis_sin_gen #(
    parameter DIV = 50
)
(
    input               aclk,
    input               arst_n,

    output [15:0]       m_axis_data_tdata,
    output              m_axis_data_tvalid
);
    
    localparam POINTS = 50;
    localparam PHASE_WIDTH = 8;
    localparam DATA_WIDTH = 16;

    // sine generator signals
    logic [DATA_WIDTH-1:0]      sine [0:POINTS-1];
    logic [PHASE_WIDTH-1:0]     current_i;
    logic [PHASE_WIDTH-1:0]     next_i;
    logic                       sample;

    // frequency control signals
    logic [DATA_WIDTH-1:0]      current_cnt; 
    logic [DATA_WIDTH-1:0]      next_cnt;
    logic inc;
    
 
    initial begin
       sine[0]   =     1029;
       sine[1]   =     3070;
       sine[2]   =     5063;
       sine[3]   =     6976;
       sine[4]   =     8779;
       sine[5]   =    10444;
       sine[6]   =    11943;
       sine[7]   =    13255;
       sine[8]   =    14357;
       sine[9]   =    15233;
       sine[10]   =    15869;
       sine[11]   =    16255;
       sine[12]   =    16384;
       sine[13]   =    16255;
       sine[14]   =    15869;
       sine[15]   =    15233;
       sine[16]   =    14357;
       sine[17]   =    13255;
       sine[18]   =    11943;
       sine[19]   =    10444;
       sine[20]   =     8779;
       sine[21]   =     6976;
       sine[22]   =     5063;
       sine[23]   =     3070;
       sine[24]   =     1029;
       sine[25]   =    -1029;
       sine[26]   =    -3070;
       sine[27]   =    -5063;
       sine[28]   =    -6976;
       sine[29]   =    -8779;
       sine[30]   =   -10444;
       sine[31]   =   -11943;
       sine[32]   =   -13255;
       sine[33]   =   -14357;
       sine[34]   =   -15233;
       sine[35]   =   -15869;
       sine[36]   =   -16255;
       sine[37]   =   -16384;
       sine[38]   =   -16255;
       sine[39]   =   -15869;
       sine[40]   =   -15233;
       sine[41]   =   -14357;
       sine[42]   =   -13255;
       sine[43]   =   -11943;
       sine[44]   =   -10444;
       sine[45]   =    -8779;
       sine[46]   =    -6976;
       sine[47]   =    -5063;
       sine[48]   =    -3070;
       sine[49]   =    -1029;
    end
    
    // sine wave generator
    always_ff @(posedge aclk) begin
        if (~arst_n) begin
            current_i <= 0;
            current_cnt <= 0;
        end
        else begin
            current_i <= next_i;
            current_cnt <= next_cnt;
        end
    end

    // valid signals
    // if 1 then sample sine[current_i], else 0
    assign sample = (current_cnt == DIV-1)? 1 : 0;
    assign m_axis_data_tvalid = sample;

    // next i
    assign next_i = (current_i == POINTS)? 0 : current_i + inc;
    assign inc = (sample)? 1 : 0;

    // next_cnt
    assign next_cnt = (current_cnt == DIV-1)? 0 : current_cnt + 1;

    // output signals
    assign m_axis_data_tdata = (sample)? sine[current_i] : 0;
    
endmodule

// `default_nettype wire
