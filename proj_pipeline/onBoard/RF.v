`include "defines.vh"

module RF(
    //时钟和复位信号
    input wire  clk,
    input wire  rst,
    //输入信号
    input wire  [4 :0] rR1,       
    input wire  [4 :0] rR2,
    input wire  [4 :0] wR,
    input wire  [31:0] wD,
    //控制信号
    input wire         we,       //1 is write
    //输出信号
    output wire [31:0] rD1,
    output wire [31:0] rD2
);

    
    //寄存器数组 
    reg [31:0] regfile[31:0];
    
    //异步读：组合逻辑
    assign rD1 = regfile[rR1];
    assign rD2 = regfile[rR2];

    //同步写：时序逻辑
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
        end else if(we && (wR!=5'd0)) begin     //向x0中写入数据无效
            regfile[wR] <= wD;
        end else begin
            regfile[0] <= 32'd0;    
        end
    end

endmodule