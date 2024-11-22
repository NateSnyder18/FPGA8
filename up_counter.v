module up_counter(input en, input clk, output [11:0] bin_cnt, output done);
   reg [11:0] bin;
   reg rdy;
   
   initial begin
       bin <= 12'b0;
   end
   
   always@(posedge clk)
       begin
           rdy <= 1'b0;
           if(en)begin
               bin <= bin + 1;
               rdy <= 1'b1;
           end
       end
   assign bin_cnt = bin;
   assign done = rdy;
endmodule
