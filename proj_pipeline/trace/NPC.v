`include "defines.vh"

module NPC(
    //input
    input wire         npc_op,       
    input wire  [31:0] pc,
    input wire  [31:0] pc_jump,
    //output
    output wire [31:0] pc4,
    output wire [31:0] npc
);

    assign pc4 = pc + 32'd4; 
    assign npc = npc_op? pc_jump : pc + 32'd4;

endmodule