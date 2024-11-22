module up_counter_tb();
    reg clk, en;
    wire [11:0] count;
   
    up_counter uut(en, clk, count);
   
    initial begin
        clk = 0;
        en = 1;
    end
   
    always begin
        #1 clk = ~clk;
    end
endmodule
