`timescale 1ns / 1ps

`include "defines.vh"

module control #(
    parameter OP_R =    7'b0110011,
    parameter OP_I =    7'b0010011,
    parameter OP_LW =   7'b0000011,
    parameter OP_JALR = 7'b1100111,
    parameter OP_SW =   7'b0100011,
    parameter OP_B =    7'b1100011,
    parameter OP_U =    7'b0110111,
    parameter OP_J =    7'b1101111
)(
    input wire [31:0] inst,
    input wire        bf,

    output reg [1 :0] npc_op,
    output reg        rf_we,
    output reg [1 :0] rf_wsel,
    output reg [2 :0] sext_op,
    output reg [3 :0] alu_op,
    output reg        alub_sel,
    output reg        ram_we
);

    wire [6:0]opcode = inst[6:0];
    wire [2:0]func3 = inst[14:12];
    wire [6:0]func7 = inst[31:25];

    //选择NPC的控制信号npc_op
    always @(*) begin
        case(opcode)
            OP_R:    npc_op = `NPC_PC4;
            OP_I:    npc_op = `NPC_PC4;
            OP_LW:   npc_op = `NPC_PC4;
            OP_JALR: npc_op = `NPC_ALU;
            OP_SW:   npc_op = `NPC_PC4;
            OP_B:    npc_op = bf? `NPC_BEQ : `NPC_PC4;   
            OP_U:    npc_op = `NPC_PC4;
            OP_J:    npc_op = `NPC_JMP;
            default: npc_op = `NPC_PC4;
        endcase
    end

    
    //选择写回寄存器数据来源的控制信号: rf_wsel
    always @(*) begin
        case(opcode)
            OP_R:    rf_wsel = `WB_ALU;
            OP_I:    rf_wsel = `WB_ALU;
            OP_LW:   rf_wsel = `WB_DREM;
            OP_JALR: rf_wsel = `WB_PC;  
            OP_U:    rf_wsel = `WB_EXT;
            OP_J:    rf_wsel = `WB_PC;
            default: rf_wsel = `WB_PC;
        endcase
    end

    //选择RF的读写控制信号
    always @(*) begin
        case(opcode)
            OP_B:    rf_we = `RF_DISABLE;
            OP_SW:   rf_we = `RF_DISABLE;
            default: rf_we = `RF_ABLE;
        endcase
    end

    //选择SEXT中立即数生成方式的控制信号: sext_op
    always @(*) begin
        case(opcode)
            OP_I: begin
                case(func3)
                    3'b000:  sext_op = `EXT_I;
                    3'b111:  sext_op = `EXT_I;
                    3'b110:  sext_op = `EXT_I; 
                    3'b100:  sext_op = `EXT_I;
                    3'b010:  sext_op = `EXT_I;
                    3'b001:  sext_op = `EXT_SHIFT;
                    3'b101:  sext_op = `EXT_SHIFT;
                    default: sext_op = `EXT_I;
                endcase
            end
            OP_LW:   sext_op = `EXT_I;
            OP_JALR: sext_op = `EXT_I; 
            OP_SW:   sext_op = `EXT_S;
            OP_B:    sext_op = `EXT_B;
            OP_U:    sext_op = `EXT_U;
            OP_J:    sext_op = `EXT_J;
            default: sext_op = `EXT_I;
        endcase
    end

    //选择 ALU 运算方式: alu_op
    always @(*) begin
        case(opcode)
            OP_R:    
                case(func3)
                    3'b000:  alu_op = (func7==7'b00000000)? `ADD : `SUB;
                    3'b111:  alu_op = `AND;
                    3'b110:  alu_op = `OR; 
                    3'b100:  alu_op = `XOR;
                    3'b001:  alu_op = `SLL;
                    3'b101:  alu_op = (func7==7'b00000000)? `SRL : `SRA;
                    default: alu_op = `ADD;
                endcase
            OP_I:  
                case(func3)
                    3'b000:  alu_op = `ADD;
                    3'b111:  alu_op = `AND;
                    3'b110:  alu_op = `OR; 
                    3'b100:  alu_op = `XOR;
                    3'b001:  alu_op = `SLL;
                    3'b101:  alu_op = (func7==7'b00000000)? `SRL : `SRA;
                    default: alu_op = `ADD;
                endcase  
            OP_LW:   alu_op = `ADD;
            OP_JALR: alu_op = `ADD;
            OP_SW:   alu_op = `ADD;
            OP_B:  begin
                case(func3)
                    3'b000:  alu_op = `BEQ;
                    3'b001:  alu_op = `BNE; 
                    3'b100:  alu_op = `BLT;
                    3'b101:  alu_op = `BGE;
                    default: alu_op = `ADD;
                endcase
            end
            default: alu_op = `ADD;
        endcase
    end

    //选择ALU.B输入数据来源的控制信号: alub_sel
    always @(*) begin
        case(opcode)
            OP_R:    alub_sel = `ALUB_RS2;
            OP_I:    alub_sel = `ALUB_EXT;
            OP_LW:   alub_sel = `ALUB_EXT;
            OP_JALR: alub_sel = `ALUB_EXT;
            OP_SW:   alub_sel = `ALUB_EXT;
            OP_B:    alub_sel = `ALUB_RS2;   
            default: alub_sel = `ALUB_RS2;
        endcase
    end
    
    
    //选择DRAM的读写控制信号: ram_we
    always @(*) begin
        if(opcode == OP_SW) begin
            ram_we = `WRITE;
        end else begin
            ram_we = `READ;
        end
    end

endmodule