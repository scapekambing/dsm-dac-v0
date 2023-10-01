module clk_div # (
    parameter integer DIV =  2 //  
)(
    input clk_in,
    output clk_out
);

    reg [15:0] cnt = 16'd0;
    reg clk_state = 0;

    assign clk_out = clk_state;

    //At every positive edge of the clock, output a sine wave sample.
    always @(posedge(clk_in))
    begin
        if (cnt<DIV/2)
            cnt <= cnt + 1;
        else begin
            clk_state <= ~clk_state;
            cnt <= 0;
        end
    end

endmodule