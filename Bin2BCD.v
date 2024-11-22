module Bin2BCD(input [11:0] bin, input clk, input en, output [15:0] bcd, output rdy);
    reg [27:0] bcd_data;
    reg [2:0] state;
    reg result_rdy;
    reg [3:0] counter = 4'b00000;
   
    reg busy = 0;

    parameter IDLE = 3'b000;
    parameter SETUP = 3'b001;
    parameter ADD = 3'b010;
    parameter SHIFT = 3'b011;
    parameter DONE = 3'b100;

   
   
   
    always @ (posedge clk) begin
        if (en) begin
            if (~busy) begin
                bcd_data <= {16'b0, bin};
                state <= SETUP;
            end
        end
       
        case(state)
       
            IDLE:
                begin
                    result_rdy <= 0;
                    busy <= 0;
                end
            SETUP:
                begin
                    result_rdy <= 0;
                    busy <= 1;
                    state <= SHIFT;
                end
            ADD:
                begin
                    busy <= 1;
                    if (bcd_data[15:12] > 4)
                        bcd_data[27:12] <= bcd_data[27:12] + 3;
                    if (bcd_data[19:16] > 4)
                        bcd_data[27:16] <= bcd_data[27:16] + 3;
                    if (bcd_data[23:20] > 4)
                        bcd_data[27:20] <= bcd_data[27:20] + 3;
                    if (bcd_data[27:24] > 4)
                        bcd_data[27:24] <= bcd_data[27:24] + 3;
                    state <= SHIFT;
                end
            SHIFT:
                begin
                    busy <= 1;
                    if (counter == 4'b1011)begin
                        state <= DONE;
                        counter <= 4'b0000;
                        bcd_data <= bcd_data << 1;
                    end
                    else begin
                        state <= ADD;
                        counter <= counter + 1;
                        bcd_data <= bcd_data << 1;
                    end
                   
                end
            DONE:
                begin
                    result_rdy <= 1;
                    state <= IDLE;
                end
        endcase
    end
   
    assign bcd = bcd_data[27:12];
    assign rdy = result_rdy;
   
endmodule
