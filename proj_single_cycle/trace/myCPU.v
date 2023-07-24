`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
    output wire [15:0]  inst_addr,
    input  wire [31:0]  inst,

    // Interface to DRAM
    input  wire [31:0]  dram,
    output wire [31:0]  aluc,
    output wire [31:0]  rD2,
    output wire         ram_we
    
`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    //控制信号
    wire [1 :0] npc_op;
    wire        rf_we;
    wire [1 :0] rf_wsel;
    wire [2 :0] sext_op;
    wire [3 :0] alu_op;
    wire        alub_sel;
   
    //数据信号
    wire [31:0] pc;
    wire [31:0] npc; 
    wire [31:0] imm;
    wire [31:0] pc4;
    wire [31:0] wD;
    wire [31:0] rD1;
    wire bf;

    assign inst_addr = pc[15:0];

    control u_control(
        //input
        .inst(inst),
        .bf(bf),
        //output
        .npc_op(npc_op),
        .rf_we(rf_we),
        .rf_wsel(rf_wsel),
        .sext_op(sext_op),
        .alu_op(alu_op),
        .alub_sel(alub_sel),
        .ram_we(ram_we)
    );

    NPC u_NPC(
        //input
        .op(npc_op),       
        .pc(pc),
        .br(bf),
        .alu_result(aluc),
        .offset(imm),
        //output
        .pc4(pc4),
        .npc(npc)
    );

    PC u_PC(
        //input
        .rst(cpu_rst),
        .clk(cpu_clk),
        .din(npc),
        //output
        .pc(pc)
    );

    SEXT u_SEXT(
        //input
        .din(inst[31:7]),      
        .sext_op(sext_op),   
        //output
        .ext(imm)
    );

    RF u_RF(
        //input
        .clk(cpu_clk),
        .rst(cpu_rst),
        .rR1(inst[19:15]),       
        .rR2(inst[24:20]),
        .wR(inst[11:7]),
        .from_alu(aluc),       
        .from_dram(dram),
        .from_imm(imm),
        .from_pc4(pc4),
        .rf_wsel(rf_wsel),
        .we(rf_we),      
        //output
        .rD1(rD1),
        .rD2(rD2),
        .wD(wD)
    );

    ALU u_ALU(
        //input
        .sel(alub_sel),
        .op(alu_op),
        .data1(rD1),
        .data2(rD2),  
        .imm(imm),
        //output
        .C(aluc),
        .bf(bf)        
    );

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1;
    assign debug_wb_pc        = pc;
    assign debug_wb_ena       = rf_we;
    assign debug_wb_reg       = inst[11:7];
    assign debug_wb_value     = wD;
`endif

endmodule
