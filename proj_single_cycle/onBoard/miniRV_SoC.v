`timescale 1ns / 1ps

`include "defines.vh"

module miniRV_SoC (
    input  wire         fpga_rst,   // High active
    input  wire         fpga_clk,

    input  wire [23:0]  switch,
    input  wire [ 4:0]  button,
    output wire [ 7:0]  dig_en,
    output wire         DN_A,
    output wire         DN_B,
    output wire         DN_C,
    output wire         DN_D,
    output wire         DN_E,
    output wire         DN_F,
    output wire         DN_G,
    output wire         DN_DP,
    output wire [23:0]  led
);

    wire        pll_lock;
    wire        pll_clk;
    wire        cpu_clk;

    // Interface between CPU and IROM
`ifdef RUN_TRACE
    wire [15:0] inst_addr;
`else
    wire [15:0] inst_addr;
`endif
    wire [31:0] inst;

    // Interface between CPU and Bridge
    wire [31:0] Bus_rdata;
    wire [31:0] Bus_addr;
    wire        Bus_wen;
    wire [31:0] Bus_wdata;
    
    // Interface between bridge and DRAM
    // wire         rst_bridge2dram;
    wire         clk_bridge2dram;
    wire [31:0]  addr_bridge2dram;
    wire [31:0]  rdata_dram2bridge;
    wire         wen_bridge2dram;
    wire [31:0]  wdata_bridge2dram;
    
    // Interface between bridge and peripherals?
    // Interface to 7-digs LEDs
    wire         rst_to_dig;
    wire         clk_to_dig;
    wire [11:0]  addr_to_dig;
    wire         wen_to_dig;
    wire [31:0]  wdata_to_dig;

    // Interface to LEDs
    wire         rst_to_led;
    wire         clk_to_led;
    wire [11:0]  addr_to_led;
    wire         wen_to_led;
    wire [31:0]  wdata_to_led;

    // Interface to switches
    wire         rst_to_sw;
    wire         clk_to_sw;
    wire [11:0]  addr_to_sw;
    wire [31:0]  rdata_from_sw;

    // Interface to buttons
    wire         rst_to_btn;
    wire         clk_to_btn;
    wire [11:0]  addr_to_btn;
    wire [31:0]  rdata_from_btn;
    

`ifdef RUN_TRACE
    // Trace调试时，直接使用外部输入时钟
    assign cpu_clk = fpga_clk;
`else
    // 下板时，使用PLL分频后的时钟
    assign cpu_clk = pll_clk & pll_lock;
    cpuclk Clkgen (
        // .resetn     (!fpga_rst),
        .clk_in1    (fpga_clk),
        .clk_out1   (pll_clk),
        .locked     (pll_lock)
    );
`endif
    
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
        .Bus_wdata          (Bus_wdata)
    );
    
    wire [31:0] inst_addr_temp = {16'd0,inst_addr};
    
    IROM Mem_IROM (
        .a          (inst_addr_temp[15:2]),
        .spo        (inst)
    );
    
    Bridge Bridge (       
        // Interface to CPU
        .rst_from_cpu       (fpga_rst),
        .clk_from_cpu       (cpu_clk),
        .addr_from_cpu      (Bus_addr),
        .wen_from_cpu       (Bus_wen),
        .wdata_from_cpu     (Bus_wdata),
        .rdata_to_cpu       (Bus_rdata),
        
        // Interface to DRAM
        // .rst_to_dram    (rst_bridge2dram),
        .clk_to_dram        (clk_bridge2dram),
        .addr_to_dram       (addr_bridge2dram),
        .rdata_from_dram    (rdata_dram2bridge),
        .wen_to_dram        (wen_bridge2dram),
        .wdata_to_dram      (wdata_bridge2dram),
        
        // Interface to 7-seg digital LEDs
        .rst_to_dig         (rst_to_dig),
        .clk_to_dig         (clk_to_dig),
        .addr_to_dig        (addr_to_dig),
        .wen_to_dig         (wen_to_dig),
        .wdata_to_dig       (wdata_to_dig),

        // Interface to LEDs
        .rst_to_led         (rst_to_led),
        .clk_to_led         (clk_to_led),
        .addr_to_led        (addr_to_led),
        .wen_to_led         (wen_to_led),
        .wdata_to_led       (wdata_to_led),

        // Interface to switches
        .rst_to_sw          (rst_to_sw),
        .clk_to_sw          (clk_to_sw),
        .addr_to_sw         (addr_to_sw),
        .rdata_from_sw      (rdata_from_sw),

        // Interface to buttons
        .rst_to_btn         (rst_to_btn),
        .clk_to_btn         (clk_to_btn),
        .addr_to_btn        (addr_to_btn),
        .rdata_from_btn     (rdata_from_btn)
    );

    DRAM Mem_DRAM (
        .clk        (clk_bridge2dram),
        .a          (addr_bridge2dram[15:2]),
        .spo        (rdata_dram2bridge),
        .we         (wen_bridge2dram),
        .d          (wdata_bridge2dram)
    );
    
    //实例化外设I/O接口电路模块
    led u_led(
        .rst(rst_to_led),
        .clk(clk_to_led),
        .addr(addr_to_led),
        .we(wen_to_led),
        .wdata(wdata_to_led),
        .led(led)
    );

    button u_button(
        .rst(rst_to_btn),
        .clk(clk_to_btn),
        .addr(addr_to_btn),
        .button_input(button),
        .rdata(rdata_from_btn)
    );

    switch u_switch(
        .rst(rst_to_sw),
        .clk(clk_to_sw),
        .addr(addr_to_sw),
        .switch(switch),
        .rdata(rdata_from_sw)
    );

    Digital_LEDs u_Digital_LEDs(
        .rst(rst_to_dig),
        .clk(clk_to_dig),
        .addr(addr_to_dig),
        .wen(wen_to_dig),
        .wdata(wdata_to_dig),
        .dig_en(dig_en),
        .DN_A(DN_A),
        .DN_B(DN_B),
        .DN_C(DN_C),
        .DN_D(DN_D),
        .DN_E(DN_E),
        .DN_F(DN_F),
        .DN_G(DN_G),
        .DN_DP(DN_DP)
    );

endmodule
