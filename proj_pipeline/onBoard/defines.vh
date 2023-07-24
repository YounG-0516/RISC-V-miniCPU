// Annotate this macro before synthesis
//`define RUN_TRACE

// NPC的控制信号npc_op
`define NPC_PC4   2'b00
`define NPC_BEQ   2'b01
`define NPC_JMP   2'b10
`define NPC_ALU   2'b11

// 选择写回寄存器数据来源的控制信号: rf_wsel
`define WB_ALU       2'b00
`define WB_DREM      2'b01
`define WB_EXT       2'b10
`define WB_PC        2'b11

// RF的读写控制信号
`define RF_DISABLE   1'b0
`define RF_ABLE      1'b1

// 选择SEXT中立即数生成方式的控制信号: sext_op
`define EXT_I          3'b000
`define EXT_S          3'b001
`define EXT_B          3'b010
`define EXT_U          3'b011
`define EXT_J          3'b100
`define EXT_SHIFT      3'b101

// 选择 ALU 运算方式: alu_op
`define ADD            4'b0000
`define SUB            4'b0001
`define AND            4'b0010
`define OR             4'b0011
`define XOR            4'b0100
`define SLL            4'b0101
`define SRL            4'b0110
`define SRA            4'b0111
`define BEQ            4'b1000
`define BNE            4'b1001
`define BLT            4'b1010
`define BGE            4'b1011

// 选择ALU.B输入数据来源的控制信号: alub_sel
`define ALUB_RS2       1'b0
`define ALUB_EXT       1'b1

//DRAM的读写控制信号: ram_we
`define READ           1'b0
`define WRITE          1'b1

// 外设I/O接口电路的端口地址
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078


