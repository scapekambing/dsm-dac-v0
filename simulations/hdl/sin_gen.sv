module sin_gen (
    input clk,
    output [15:0] out
);
    reg [15:0] sine [0:96]; // Increase resolution to 100 points

    integer i;
    reg [15:0] data_out;
    assign out = data_out;
 
    initial begin
        i = 0;

        // Define the sine values (scaled to 16 bits)
        sine[0]  = 0;
        sine[1]  = 511;
        sine[2]  = 1019;
        sine[3]  = 1515;
        sine[4]  = 1999;
        sine[5]  = 2470;
        sine[6]  = 2925;
        sine[7]  = 3365;
        sine[8]  = 3786;
        sine[9]  = 4188;
        sine[10] = 4569;
        sine[11] = 4928;
        sine[12] = 5265;
        sine[13] = 5578;
        sine[14] = 5867;
        sine[15] = 6131;
        sine[16] = 6369;
        sine[17] = 6579;
        sine[18] = 6763;
        sine[19] = 6919;
        sine[20] = 7047;
        sine[21] = 7146;
        sine[22] = 7216;
        sine[23] = 7257;
        sine[24] = 7268;
        sine[25] = 7257;
        sine[26] = 7216;
        sine[27] = 7146;
        sine[28] = 7047;
        sine[29] = 6919;
        sine[30] = 6763;
        sine[31] = 6579;
        sine[32] = 6369;
        sine[33] = 6131;
        sine[34] = 5867;
        sine[35] = 5578;
        sine[36] = 5265;
        sine[37] = 4928;
        sine[38] = 4569;
        sine[39] = 4188;
        sine[40] = 3786;
        sine[41] = 3365;
        sine[42] = 2925;
        sine[43] = 2470;
        sine[44] = 1999;
        sine[45] = 1515;
        sine[46] = 1019;
        sine[47] = 511;
        sine[48] = 0;
        sine[49] = -511;
        sine[50] = -1019;
        sine[51] = -1515;
        sine[52] = -1999;
        sine[53] = -2470;
        sine[54] = -2925;
        sine[55] = -3365;
        sine[56] = -3786;
        sine[57] = -4188;
        sine[58] = -4569;
        sine[59] = -4928;
        sine[60] = -5265;
        sine[61] = -5578;
        sine[62] = -5867;
        sine[63] = -6131;
        sine[64] = -6369;
        sine[65] = -6579;
        sine[66] = -6763;
        sine[67] = -6919;
        sine[68] = -7047;
        sine[69] = -7146;
        sine[70] = -7216;
        sine[71] = -7257;
        sine[72] = -7268;
        sine[73] = -7257;
        sine[74] = -7216;
        sine[75] = -7146;
        sine[76] = -7047;
        sine[77] = -6919;
        sine[78] = -6763;
        sine[79] = -6579;
        sine[80] = -6369;
        sine[81] = -6131;
        sine[82] = -5867;
        sine[83] = -5578;
        sine[84] = -5265;
        sine[85] = -4928;
        sine[86] = -4569;
        sine[87] = -4188;
        sine[88] = -3786;
        sine[89] = -3365;
        sine[90] = -2925;
        sine[91] = -2470;
        sine[92] = -1999;
        sine[93] = -1515;
        sine[94] = -1019;
        sine[95] = -511;
        sine[96] = 0;

    end
    
    // after 97 clk ticks, a complete period will be formed
    always @(posedge clk) begin
        data_out <= sine[i];
        i = i + 1;
        if (i == 100)
            i = 0;
    end

endmodule
