module Bin2BCD_tb();
    reg [11:0] bin;
    reg clk, en;
    wire [15:0] bcd;
    wire rdy;
    Bin2BCD uut(bin, clk, en, bcd, rdy);
   
    initial begin
        clk = 0;
        en = 1;
        bin = 189;
        #700 bin = 1234;
        #700 bin = 16'd2574;
        #700 $stop;
    end
   
    always begin
        #5 clk = ~clk;
    end
endmodule
