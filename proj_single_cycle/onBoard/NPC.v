`include "defines.vh"

module NPC(
    input wire  [1:0 ] op,       //from controller
    input wire  [31:0] pc,
    input wire         br,
    input wire  [31:0] alu_result,
    input wire  [31:0] offset,
    output wire [31:0] pc4,
    output reg  [31:0] npc
);

    assign pc4 = pc + 32'd4; 

    always @ (*) begin
        case(op)
            `NPC_PC4: npc = pc + 32'd4;                        //pc+4
            `NPC_BEQ: npc = br? (pc + offset) : (pc + 32'd4);  //branch
            `NPC_JMP: npc = pc + offset;                       //jal:pc+offset
            `NPC_ALU: npc = alu_result;                        //jalr:rd1+offset
            default:  npc = pc + 32'd4;
        endcase
    end

endmodule