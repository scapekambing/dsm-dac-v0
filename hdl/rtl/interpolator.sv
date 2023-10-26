`default_nettype none

module interpolator (
    input               clk,
    input               rst,
    input               clk_en,
    output logic [15:0] out
);

    // if clk_en = 0

    // frequency = clk_freq/n_pts
    always_ff @(posedge(clk)) begin
        if (~rst) begin
            
        end
        else if (clk_en) begin
            case

            endcase
    end

endmodule

`default_nettype wire