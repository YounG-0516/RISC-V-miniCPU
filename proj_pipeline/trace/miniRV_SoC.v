`timescale 1ns / 1ps

`include "defines.vh"

module miniRV_SoC (
    input  wire         fpga_rst,           // High active
    input  wire         fpga_clk,

    // Debug Interface
    output wire         debug_wb_have_inst, // 当前时钟周期是否有指令执行到WB阶段
    output wire [31:0]  debug_wb_pc,        // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output              debug_wb_ena,       // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output wire [ 4:0]  debug_wb_reg,       // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output wire [31:0]  debug_wb_value      // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);

    wire cpu_clk = fpga_clk;

    // Interface between CPU and IROM
    wire [15:0] inst_addr;
    wire [31:0] inst;

    wire [31:0] Bus_rdata;
    wire [31:0] Bus_addr;
    wire        Bus_wen;
    wire [31:0] Bus_wdata;

    myCPU Core_cpu (
        .cpu_rst            (fpga_rst),
        .cpu_clk            (cpu_clk),

        // Interface to IROM
        .inst_addr          (inst_addr),
        .inst               (inst),

        // Interface to Bridge
        .Bus_addr           (Bus_addr),
        .Bus_rdata          (Bus_rdata),
        .Bus_wen            (Bus_wen),
        .Bus_wdata          (Bus_wdata),

        .debug_wb_have_inst (debug_wb_have_inst),
        .debug_wb_pc        (debug_wb_pc),
        .debug_wb_ena       (debug_wb_ena),
        .debug_wb_reg       (debug_wb_reg),
        .debug_wb_value     (debug_wb_value)
    );

    wire[31:0]  inst_addr_temp = inst_addr;
    
    IROM Mem_IROM (
        .a          (inst_addr_temp[17:2]),
        .spo        (inst)
    );

    DRAM Mem_DRAM (
        .clk        (cpu_clk),
        .a          (Bus_addr[15:2]),
        .spo        (Bus_rdata),
        .we         (Bus_wen),
        .d          (Bus_wdata)
    );

endmodule
