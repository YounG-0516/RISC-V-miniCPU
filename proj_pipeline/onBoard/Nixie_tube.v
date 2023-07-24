module Nixie_tube (
    input  wire clk,
    input  wire rst,
    input  wire [3:0]DIG,
    output reg  [7:0]SEGMENT 
);
   
    always @(*) begin
        case (DIG)
            4'd0: SEGMENT=8'b00000011;
            4'd1: SEGMENT=8'b10011111;
            4'd2: SEGMENT=8'b00100101;
            4'd3: SEGMENT=8'b00001101;
            4'd4: SEGMENT=8'b10011001;
            4'd5: SEGMENT=8'b01001001;
            4'd6: SEGMENT=8'b01000001;
            4'd7: SEGMENT=8'b00011111;
            4'd8: SEGMENT=8'b00000001;
            4'd9: SEGMENT=8'b00011001;
            4'd10: SEGMENT=8'b00010001;
            4'd11: SEGMENT=8'b11000001;
            4'd12: SEGMENT=8'b11100101;
            4'd13: SEGMENT=8'b10000101;
            4'd14: SEGMENT=8'b01100001;
            4'd15: SEGMENT=8'b01110001;
            default: SEGMENT=8'b11111111;
        endcase
    end

endmodule //Nixie_tube