`include "defines.vh"

module RF(
    //时钟和复位信�?
    input wire  clk,
    input wire  rst,
    //输入信号
    input wire  [4 :0] rR1,       
    input wire  [4 :0] rR2,
    input wire  [4 :0] wR,
    input wire  [31:0] from_alu,       
    input wire  [31:0] from_dram,
    input wire  [31:0] from_imm,
    input wire  [31:0] from_pc4,
    //控制信号
    input wire  [1 :0] rf_wsel,
    input wire         we,       //1 is write
    //输出信号
    output wire [31:0] rD1,
    output wire [31:0] rD2
);
    
    reg [31:0] wD;
    
    //寄存器数�? 
    reg [31:0] regfile[31:0];
    
    //异步读：组合逻辑
    assign rD1 = regfile[rR1];
    assign rD2 = regfile[rR2];

    //同步写：时序逻辑
    always @(*) begin
        case(rf_wsel)
            `WB_ALU:    wD = from_alu;
            `WB_DREM:   wD = from_dram; 
            `WB_EXT:    wD = from_imm;  
            `WB_PC:     wD = from_pc4;
            default:    wD = 32'd0;
        endcase
    end

    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            regfile[0] <= 32'd0; 
            regfile[1] <= 32'd0; 
            regfile[2] <= 32'd0; 
            regfile[3] <= 32'd0; 
            regfile[4] <= 32'd0; 
            regfile[5] <= 32'd0; 
            regfile[6] <= 32'd0; 
            regfile[7] <= 32'd0; 
            regfile[8] <= 32'd0; 
            regfile[9] <= 32'd0; 
            regfile[10] <= 32'd0;
            regfile[11] <= 32'd0;
            regfile[12] <= 32'd0;
            regfile[13] <= 32'd0;
            regfile[14] <= 32'd0;
            regfile[15] <= 32'd0;
            regfile[16] <= 32'd0;
            regfile[17] <= 32'd0;
            regfile[18] <= 32'd0;
            regfile[19] <= 32'd0;
            regfile[20] <= 32'd0;
            regfile[21] <= 32'd0;
            regfile[22] <= 32'd0;
            regfile[23] <= 32'd0;
            regfile[24] <= 32'd0;
            regfile[25] <= 32'd0;
            regfile[26] <= 32'd0;
            regfile[27] <= 32'd0;
            regfile[28] <= 32'd0;
            regfile[29] <= 32'd0;
            regfile[30] <= 32'd0;
            regfile[31] <= 32'd0;
        end else if(we && (wR!=5'd0)) begin     //向x0中写入数据无�?
            regfile[wR] <= wD;
        end else begin
            regfile[0] <= 32'd0;    
        end
    end

endmodule