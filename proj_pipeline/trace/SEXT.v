`include "defines.vh"

module SEXT(
    input wire [24:0] din,       //inst[31:7]
    input wire [2 :0] sext_op,   //from controller
    output reg [31:0] ext
);
    
    always @(*) begin
        case(sext_op)
            `EXT_I: ext = din[24]? {20'hFFFFF,din[24:13]} : {20'h00000,din[24:13]};       
            `EXT_S: ext = din[24]? {20'hFFFFF,din[24:18],din[4:0]} : {20'h00000,din[24:18],din[4:0]};      
            `EXT_B: ext = din[24]? {20'hFFFFF,din[0],din[23:18],din[4:1],1'b0} : {20'h00000,din[0],din[23:18],din[4:1],1'b0};
            `EXT_U: ext = {din[24:5],12'h000};    
            `EXT_J: ext = din[24]? {12'hFFF,din[12:5],din[13],din[23:14],1'b0} : {12'h000,din[12:5],din[13],din[23:14],1'b0};
            `EXT_SHIFT: ext = {27'd0,din[17:13]};    
            default: ext =32'h0000_0000;
        endcase
    end

endmodule