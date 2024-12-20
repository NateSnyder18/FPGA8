module up_counter_tb();
    reg clk, en;
    wire done;
    wire [11:0] count;
   
    up_counter uut(en, clk, count, done);
   
    initial begin
        clk = 0;
        en = 1;
    end
   
    always begin
        #1 clk = ~clk;
    end
endmodule
