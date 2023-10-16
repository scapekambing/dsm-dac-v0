module clk_div # (
    parameter DIV           =  2,
    parameter COUNTER_WIDTH = 16
)(
    input           clk_in,
    input           rst,
    output logic    clk_en
);

    logic [COUNTER_WIDTH-1:0]    cnt;

    // clk_en generator
    always_ff @(posedge clk_in) begin    
      // Reset   
      if (~rst) begin
          clk_en     <= 1'b0;
          cnt        <= 16'd0;      
      end
    
      // Operation
      else begin
          clk_en  <= 1'b0; 
          cnt     <= cnt + 1'b1;       

          if (cnt == (DIV-1)) begin         
            clk_en <= 1'b1;
            cnt    <= 16'd0;
          end
      end
    end // clk_en generator

endmodule