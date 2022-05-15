`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2022 02:33:21 PM
// Design Name: 
// Module Name: merge_ip_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module merge_ip_core(
input clk,
input reset,
input start,
input [31:0] fifo_wr_data,
input fifo_wr_en_1,
input fifo_wr_en_2,

input fifo_rd_en_merge,
output [31:0] fifo_rd_data_merge,
output reg done
);

wire[31:0] fifo_rd_data_1, fifo_rd_data_2;
reg [31:0] fifo_wr_data_merge;
reg fifo_rd_en_1, fifo_rd_en_2;
reg fifo_wr_en_merge;

localparam IDLE = 'd0,
    COMPARE = 'd1,
    FLUSH='d2,
    WRITE='d3,
    DONE='d4;
reg [2:0] state=0;

always @(posedge clk)
begin
    if(reset)
    begin
        state<=IDLE;
        fifo_rd_en_1 <= 0;
        fifo_rd_en_2 <= 0;
        fifo_wr_en_merge <= 0;
        done <= 0;
    end
    else
    begin
        case(state)
            IDLE:
            begin
                if(start)
                    state<=COMPARE;
            end 
            COMPARE:
            begin
                if(!fifo_empty_1 && !fifo_empty_2)
                begin
                    if(fifo_rd_data_1<fifo_rd_data_2)
                    begin
                        fifo_wr_data_merge <= fifo_rd_data_1;
                        fifo_wr_en_merge<=1;
                        fifo_rd_en_1<=1;
                    end
                    else 
                    begin
                        fifo_wr_data_merge<=fifo_rd_data_2;
                        fifo_wr_en_merge<=1;
                        fifo_rd_en_2<=1;
                    end
                    state<=WRITE;
                end
                else if(fifo_empty_1 && fifo_empty_2)
                    state<=DONE;
                else if(fifo_empty_1)
                begin
                    state<=FLUSH;
                    fifo_rd_en_2<=1;
                end
                else if(fifo_empty_2)
                begin
                    state<=FLUSH;
                    fifo_rd_en_1<=1;
                end
            end
            WRITE:
            begin
                fifo_rd_en_1<=0;
                fifo_rd_en_2<=0;
                fifo_wr_en_merge<=0;
                state<=COMPARE;
            end
            FLUSH:
            begin
                if(fifo_empty_1 && fifo_empty_2)
                begin
                    state<=DONE;
                    fifo_rd_en_1<=0;
                    fifo_rd_en_2<=0;
                    fifo_wr_en_merge<=0;
                end
                else if(fifo_empty_1)
                begin
                    fifo_rd_en_2<=1;
                    fifo_wr_en_merge<=1;
                    fifo_wr_data_merge<=fifo_rd_data_2;
                end
                else if(fifo_empty_2)
                begin
                    fifo_rd_en_1<=1;
                    fifo_wr_en_merge<=1;
                    fifo_wr_data_merge<=fifo_rd_data_1;
                end
            end
            DONE:
            begin
                done<=1;
                if(!start)
                begin
                    done<=0;
                    state<=IDLE;
                end
            end
        endcase
    end
end
fifo_generator_0 fifo_inst1 (
  .clk(clk),      // input wire clk
  .srst(reset),    // input wire srst
  .din(fifo_wr_data),      // input wire [31 : 0] din
  .wr_en(fifo_wr_en_1),  // input wire wr_en
  .rd_en(fifo_rd_en_1),  // input wire rd_en
  .dout(fifo_rd_data_1),    // output wire [31 : 0] dout
  .full(),    // output wire full
  .empty(fifo_empty_1)  // output wire empty
);

fifo_generator_0 fifo_inst2 (
  .clk(clk),      // input wire clk
  .srst(reset),    // input wire srst
  .din(fifo_wr_data),      // input wire [31 : 0] din
  .wr_en(fifo_wr_en_2),  // input wire wr_en
  .rd_en(fifo_rd_en_2),  // input wire rd_en
  .dout(fifo_rd_data_2),    // output wire [31 : 0] dout
  .full(),    // output wire full
  .empty(fifo_empty_2)  // output wire empty
);

fifo_generator_1 merger_fifo_inst (
  .clk(clk),      // input wire clk
  .srst(reset),    // input wire srst
  .din(fifo_wr_data_merge),      // input wire [31 : 0] din
  .wr_en(fifo_wr_en_merge),  // input wire wr_en
  .rd_en(fifo_rd_en_merge),  // input wire rd_en
  .dout(fifo_rd_data_merge),    // output wire [31 : 0] dout
  .full(),    // output wire full
  .empty()  // output wire empty
);

endmodule
