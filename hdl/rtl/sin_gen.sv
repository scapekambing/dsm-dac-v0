module sin_gen (
    input               clk,
    input               rst,
    input               clk_en,
    output logic [15:0] out
);
    localparam POINTS = 50;
    logic [15:0] sine [0:POINTS-1];

    integer i;  
 
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
    
    // frequency = clk_freq/n_pts
    always @(posedge(clk)) begin
        if (~rst) begin
            i = 0;
            out <= sine[0];
        end
        else if (clk_en) begin
            out <= sine[i];
            if (i == POINTS-1) begin
                i = 0;
            end 
            else begin
                i = i + 1;
            end
        end
        
    end

endmodule
