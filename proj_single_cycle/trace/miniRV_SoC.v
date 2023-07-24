`timescale 1ns / 1ps

`include "defines.vh"

module miniRV_SoC (
    input  wire         fpga_rst,   // High active
    input  wire         fpga_clk,

    // Debug Interface
    output wire         debug_wb_have_inst, // 当前时钟周期是否有指令写回 (对单周期CPU，可在复位后恒置1)
    output wire [31:0]  debug_wb_pc,        // 当前写回的指令的PC (若wb_have_inst=0，此项可为任意值)
    output              debug_wb_ena,       // 指令写回时，寄存器堆的写使能 (若wb_have_inst=0，此项可为任意值)
    output wire [ 4:0]  debug_wb_reg,       // 指令写回时，写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output wire [31:0]  debug_wb_value      // 指令写回时，写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)

);

    wire        cpu_clk;
    assign cpu_clk = fpga_clk;

    // Interface between CPU and IROM
    wire [31:0] inst;
    wire [15:0] inst_addr;
    wire [31:0] inst_addr_pro={16'b0,inst_addr};

    // Interface between CPU and DRAM
    wire [31:0] aluc;
    wire [31:0] rD2;
    wire [31:0] dram_rd;
    wire        dram_we;
    
    myCPU Core_cpu (
        .cpu_rst            (fpga_rst),
        .cpu_clk            (cpu_clk),

        // Interface to IROM
        .inst_addr          (inst_addr),
        .inst               (inst),
        
        // Interface to DRAM
        .dram               (dram_rd),
        .rD2                (rD2),
        .aluc               (aluc),
        .ram_we             (dram_we)

`ifdef RUN_TRACE
        ,// Debug Interface
        .debug_wb_have_inst (debug_wb_have_inst),
        .debug_wb_pc        (debug_wb_pc),
        .debug_wb_ena       (debug_wb_ena),
        .debug_wb_reg       (debug_wb_reg),
        .debug_wb_value     (debug_wb_value)
`endif
    );
    
    IROM Mem_IROM (
        .a          (inst_addr_pro[17:2]),
        .spo        (inst)
    );

    DRAM Mem_DRAM (
        .clk        (cpu_clk),
        .a          (aluc[15:2]),
        .spo        (dram_rd),
        .we         (dram_we),
        .d          (rD2)
    );

endmodule
