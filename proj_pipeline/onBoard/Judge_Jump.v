`include "defines.vh"

module Judge_Jump(
    //input
    input wire [2 :0] branch,       //只有B/jal/jalr指令才会出现分支跳转
    input wire        bf,
    input wire [31:0] pc,
    input wire [31:0] imm,
    input wire [31:0] aluc,
    //output
    output reg        npc_op,
    output reg [31:0] pc_jump
);

    always @(*) begin
        if(branch[2] & bf)      pc_jump = pc+imm;      //是B型指令且跳转
        else if(branch[1])      pc_jump = pc+imm;      //JAL
        else if(branch[0])      pc_jump = aluc;        //JALR
        else                    pc_jump = pc+32'd4;
    end

    always @(*) begin
        if(branch[2] & bf)          npc_op = 1'b1;          //是B型指令且跳转
        else if(branch[2] & !bf)    npc_op = 1'b0;          //是B型指令但不跳转
        else if(branch[1])          npc_op = 1'b1;          //JAL
        else if(branch[0])          npc_op = 1'b1;          //JALR
        else                        npc_op = 1'b0; 
    end
    
endmodule