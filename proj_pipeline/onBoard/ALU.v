`include "defines.vh"

module ALU(   
    input wire  [31:0] rD1,
    input wire  [31:0] rD2,  
    input wire  [31:0] imm, 
    output reg  [31:0] C,
    output reg         bf,
    
    //控制信号
    input wire        alub_sel,
    input wire  [3:0] alu_op
);

    wire [31:0]A = rD1;
    wire [31:0]B = alub_sel? imm : rD2;
    wire [4 :0]shamt = B[4:0];

    always @(*) begin
        case(alu_op)
            `ADD: C = A+B;
            `SUB: C = A+(~B)+1;
            `AND: C = A & B;
            `OR:  C = A | B;
            `XOR: C = A ^ B;
            `SLL: C = A << shamt;
            `SRL: C = A >> shamt;
            `SRA: C = $signed(A) >>> shamt;
            `BEQ: bf = (A==B)? 1'b1 : 1'b0;
            `BNE: bf = (A!=B)? 1'b1 : 1'b0;
            `BLT: begin
                C = A+(~B)+1;
                bf = (C[31])?  1'b1 : 1'b0;
            end
            `BGE: begin
                C = A+(~B)+1;
                bf = (~C[31])?  1'b1 : 1'b0;
            end
            default: C = 32'd0;
        endcase
    end 

endmodule