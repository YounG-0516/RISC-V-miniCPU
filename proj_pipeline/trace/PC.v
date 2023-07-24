`timescale 1ns / 1ps

module PC(
    input wire        rst,
    input wire        clk,
    input wire [31:0] din,
    input wire        pipeline_stop,     //停顿
    output reg [31:0] pc
);

    always @ (posedge clk or posedge rst) begin
        if(rst)                 pc <= 32'h0000_0000;
        else if(pipeline_stop)  pc <= pc;
        else                    pc <= din;
    end

endmodule