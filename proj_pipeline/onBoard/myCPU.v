`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,
    
    // Interface to IROM
    output wire [15:0]  inst_addr,
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_wen,
    output wire [31:0]  Bus_wdata

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
    wire        npc_op;
    wire        rf_we_ID,rf_we_EX,rf_we_MEM,rf_we_WB;
    wire [1 :0] rf_wsel_ID,rf_wsel_EX,rf_wsel_MEM;
    wire [2 :0] sext_op;
    wire [3 :0] alu_op_ID,alu_op_EX;
    wire        alub_sel_ID,alub_sel_EX;
    wire        ram_we_ID,ram_we_EX,ram_we_MEM;
    wire [2 :0] branch_ID,branch_EX;
    wire        ID_read1;
    wire        ID_read2;
    wire        have_inst_ID, have_inst_EX, have_inst_MEM, have_inst_WB;

    //停顿及清除信�?
    wire        pipeline_stop_PC;
    wire        pipeline_stop_REG_IF_ID;
    wire        flush_REG_IF_ID;
    wire        flush_REG_ID_EX,flush_REG_ID_EX_Control,flush_REG_ID_EX_Data;

    //前�?�信�?
    wire        forward_op1;
    wire        forward_op2;
    wire [31:0] rD1_forward;
    wire [31:0] rD2_forward;

    //数据信号
    wire [31:0] pc_IF,pc_ID,pc_EX,pc_MEM,pc_WB;
    wire [31:0] pc4_IF,pc4_ID,pc4_EX;
    wire [31:0] npc;
    wire [31:0] pc_jump;
    wire [31:0] inst_ID;
    wire [31:0] imm_ID,imm_EX,imm_MEM;
    wire [31:0] wD,wD_EX,wD_MEM,wD_WB;
    wire [4 :0] wR_EX,wR_MEM,wR_WB;
    wire [31:0] rD1_ID,rD1_EX;
    wire [31:0] rD2_ID,rD2_EX,rD2_MEM;
    wire bf;
    wire [31:0] aluc_EX,aluc_MEM;

    assign inst_addr = pc_IF[15:0];

    //*************************************************************************************//
    //***************************************IF********************************************//

    PC u_PC(
        //input
        .rst(cpu_rst),
        .clk(cpu_clk),
        .din(npc),
        .pipeline_stop(pipeline_stop_PC),    
        //output
        .pc(pc_IF)
    );

    NPC u_NPC(
        //input
        .npc_op(npc_op),       
        .pc(pc_IF),
        .pc_jump(pc_jump),
        //output
        .pc4(pc4_IF),
        .npc(npc)
    );

    REG_IF_ID u_REG_IF_ID(
        //input
        .clk(cpu_clk),
        .rst(cpu_rst),
        .pipeline_stop(pipeline_stop_REG_IF_ID),
        .flush(flush_REG_IF_ID),
        .pc_in(pc_IF),
        .pc4_in(pc4_IF),
        .inst_in(inst),
        //output
        .pc_out(pc_ID),
        .pc4_out(pc4_ID),
        .inst_out(inst_ID)
    );

    //***************************************ID********************************************//

    SEXT u_SEXT(
        //input
        .din(inst_ID[31:7]),      
        .sext_op(sext_op),   
        //output
        .ext(imm_ID)
    );

    RF u_RF(
        //input
        .clk(cpu_clk),
        .rst(cpu_rst),
        .rR1(inst_ID[19:15]),       
        .rR2(inst_ID[24:20]),
        .wR(wR_WB),
        .wD(wD_WB),
        .we(rf_we_WB),      
        //output
        .rD1(rD1_ID),
        .rD2(rD2_ID)
    );

    Control u_Control(
        //input
        .inst(inst_ID),
        //output
        .ID_read1(ID_read1),
        .ID_read2(ID_read2),
        .branch(branch_ID),
        .rf_we(rf_we_ID),
        .rf_wsel(rf_wsel_ID),
        .sext_op(sext_op),
        .alu_op(alu_op_ID),
        .alub_sel(alub_sel_ID),
        .ram_we(ram_we_ID),
        .have_inst(have_inst_ID)
    );

    REG_ID_EX u_REG_ID_EX(
        .clk(cpu_clk),
        .rst(cpu_rst),  
        //数据信号
        .rD1_in(rD1_ID),
        .rD2_in(rD2_ID),
        .wR_in(inst_ID[11:7]),
        .pc_in(pc_ID),
        .pc4_in(pc4_ID),
        .imm_in(imm_ID),
        .have_inst_in(have_inst_ID),
        .rD1_out(rD1_EX),
        .rD2_out(rD2_EX),
        .wR_out(wR_EX),
        .pc_out(pc_EX),
        .pc4_out(pc4_EX),
        .imm_out(imm_EX),
        .have_inst_out(have_inst_EX),
        //前�?�相关信�?
        .forward_op1(forward_op1),
        .forward_op2(forward_op2),
        .rD1_forward(rD1_forward),
        .rD2_forward(rD2_forward),
        //清除信号
        .flush(flush_REG_ID_EX),
        //控制信号
        .rf_wsel_in(rf_wsel_ID),
        .branch_in(branch_ID),
        .rf_we_in(rf_we_ID),
        .alu_op_in(alu_op_ID),
        .alub_sel_in(alub_sel_ID),
        .ram_we_in(ram_we_ID),
        .rf_wsel_out(rf_wsel_EX),
        .branch_out(branch_EX),
        .rf_we_out(rf_we_EX),
        .alu_op_out(alu_op_EX),
        .alub_sel_out(alub_sel_EX),
        .ram_we_out(ram_we_EX)
    );

    //***************************************EX********************************************//

    ALU u_ALU(
        //input
        .alub_sel(alub_sel_EX),
        .alu_op(alu_op_EX),
        .rD1(rD1_EX),
        .rD2(rD2_EX),  
        .imm(imm_EX),
        //output
        .C(aluc_EX),
        .bf(bf)        
    );

    Judge_Jump u_Judge_Jump(
        //input
        .branch(branch_EX),   
        .bf(bf),
        .pc(pc_EX),
        .imm(imm_EX),
        .aluc(aluc_EX),
        //output
        .npc_op(npc_op),
        .pc_jump(pc_jump)
    );

    wD_MUX_1 u_wD_MUX_1(
        //input
        .aluc_in(aluc_EX),       
        .sext_in(imm_EX),
        .pc4_in(pc4_EX),
        .rf_wsel(rf_wsel_EX),
        //output
        .wD(wD_EX)
    );

    REG_EX_MEM u_REG_EX_MEM(
        //input
        .clk(cpu_clk),
        .rst(cpu_rst),  
        .wD_in(wD_EX),
        .wR_in(wR_EX),
        .rD2_in(rD2_EX),
        .pc_in(pc_EX),
        .aluc_in(aluc_EX),
        .have_inst_in(have_inst_EX),
        .rf_wsel_in(rf_wsel_EX),
        .rf_we_in(rf_we_EX),
        .ram_we_in(ram_we_EX),
        //output
        .wD_out(wD_MEM),
        .wR_out(wR_MEM),
        .rD2_out(rD2_MEM),
        .pc_out(pc_MEM),
        .aluc_out(aluc_MEM),
        .have_inst_out(have_inst_MEM),
        .rf_wsel_out(rf_wsel_MEM),
        .rf_we_out(rf_we_MEM),
        .ram_we_out(ram_we_MEM)
    );

    //***************************************MEM********************************************//

    wD_MUX_2 u_wD_MUX_2(
        //input
        .wD_in(wD_MEM),       
        .dram_in(Bus_rdata),
        .rf_wsel(rf_wsel_MEM),
        //output
        .wD(wD)
    );

    REG_MEM_WB u_REG_MEM_WB(
        //input
        .clk(cpu_clk),
        .rst(cpu_rst),
        .wR_in(wR_MEM),
        .wD_in(wD),
        .pc_in(pc_MEM),
        .have_inst_in(have_inst_MEM),
        .rf_we_in(rf_we_MEM),
        //output
        .wR_out(wR_WB),
        .wD_out(wD_WB),
        .pc_out(pc_WB),
        .have_inst_out(have_inst_WB),
        .rf_we_out(rf_we_WB)
    );

    //***************************************HazardDetection********************************************//

    assign flush_REG_ID_EX = flush_REG_ID_EX_Control | flush_REG_ID_EX_Data;

    Control_HazardDetection u_Control_HazardDetection(
        //input
        .is_control_hazard(npc_op),       
        //output
        .flush_REG_ID_EX(flush_REG_ID_EX_Control),
        .flush_REG_IF_ID(flush_REG_IF_ID)
    );

    Data_HazardDetection u_Data_HazardDetection(
        //input
        .rR1_ID(inst_ID[19:15]),
        .rR2_ID(inst_ID[24:20]),
        .ID_read1(ID_read1),
        .ID_read2(ID_read2),
        .rf_wsel(rf_wsel_EX),
        .wR_EX(wR_EX),
        .wR_MEM(wR_MEM),
        .wR_WB(wR_WB),
        .wD_EX(wD_EX),
        .wD_MEM(wD),
        .wD_WB(wD_WB),
        .rf_we_EX(rf_we_EX),
        .rf_we_MEM(rf_we_MEM),
        .rf_we_WB(rf_we_MEM),
        //output
        .forward_op1(forward_op1),
        .forward_op2(forward_op2),
        .rD1_forward(rD1_forward),
        .rD2_forward(rD2_forward),
        .pipeline_stop_PC(pipeline_stop_PC),
        .pipeline_stop_REG_IF_ID(pipeline_stop_REG_IF_ID),
        .flush_REG_ID_EX(flush_REG_ID_EX_Data)
    );

    assign Bus_wen = ram_we_MEM;
    assign Bus_addr= aluc_MEM;
    assign Bus_wdata = rD2_MEM;
    
`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = have_inst_WB;
    assign debug_wb_pc        = pc_WB;
    assign debug_wb_ena       = rf_we_WB;
    assign debug_wb_reg       = wR_WB;
    assign debug_wb_value     = wD_WB;
`endif

endmodule
