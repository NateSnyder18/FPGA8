module up_counter(input en, input clk, output reg [11:0] count);
   
    initial begin
        count <= 12'b000000000000;
    end
   
    always @ (posedge clk) begin
        if (en) begin
            count <= count + 1;
        end
    end
endmodule
