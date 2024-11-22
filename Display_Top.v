module Display_Top(input mclk, output wire[6:0] seg, output wire [3:0] an);

reg [15:0] stat_bcd = 16'b0;

wire [11:0] bin;
wire [15:0] bcd;
wire count_en, en, rdy;

strobe uut0(mclk, count_en);
up_counter uut1(count_en, mclk, bin, en);
Bin2BCD uut2(bin, mclk, en, bcd, rdy);
multidigit uut3(mclk, stat_bcd, an, seg);



always @(posedge mclk)
    begin
        if(rdy)
         begin
            stat_bcd<=bcd;
         end
    end

endmodule


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

module strobe(input clk, output rdy);
    parameter width = 23;
    parameter max = 23'b11111111111111111111111;
    reg[width-1:0] counter = 0;
    reg ready;
    always@(posedge clk)begin
        counter <= counter + 1;
        if (counter == max) begin
            ready <= 1'b1;
        end
        else begin
            ready <= 1'b0;
        end
    end
    assign rdy = ready;
endmodule



module multidigit(input clk, input [15:0] bcd_in, output [3:0] sseg_a_o, output [6:0] sseg_c_o);

    parameter g_s = 7;
    parameter gt = 6;
   
    wire [6:0] sseg_o;
    reg [3:0] anode =4'b1000;
    reg [3:0] bcd_seg =4'b0000;
    reg [g_s-1:0] g_count =0;
   
   
    segConv uut1(clk, bcd_seg,sseg_o);
   
    always @(posedge clk)
    begin

            g_count = g_count+1;
            if(g_count == 0)
                begin

                if(anode == 4'b0001)
                    begin
                    anode = 4'b1000;
                    end  
                else
                    begin
                    anode = anode >> 1;
                    end
                end
       
            if(&g_count[g_s-1:gt])            
                begin
               
                case (anode) //case statement
           
                    4'b1000: bcd_seg  = bcd_in[15:12];
                    4'b0100: bcd_seg  = bcd_in[11:8];
                    4'b0010: bcd_seg  = bcd_in[7:4];
                    4'b0001: bcd_seg  = bcd_in[3:0];
               
                    default : bcd_seg = 4'b1111;
                endcase
                end
                 
            else
                begin
                bcd_seg = 4'b1111;
                end
    end
   
    assign  sseg_a_o = ~anode;
    assign  sseg_c_o = sseg_o;  

endmodule

module segConv(clk, bcd, seg);
    input clk;
    input [3:0] bcd;
    output reg[6:0] seg;//


    always @(posedge clk)    
    begin        
    case (bcd) //case statement                  
        0: seg = 7'b0000001;
        1: seg=7'b1001111;
        2: seg=7'b0010010;
        3: seg=7'b0000110;
        4: seg=7'b1001100;
        5: seg=7'b0100100;
        6: seg=7'b0100000;
        7: seg=7'b0001111;
        8: seg=7'b0000000;
        9: seg=7'b0000100;

        default : seg = 7'b1111111;                    
    endcase              
    end                

endmodule
