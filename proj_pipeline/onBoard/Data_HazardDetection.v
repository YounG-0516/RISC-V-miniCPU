`include "defines.vh"

module Data_HazardDetection(
    input wire [4 :0] rR1_ID,
    input wire [4 :0] rR2_ID,

    input wire        ID_read1,
    input wire        ID_read2,
    input wire [1 :0] rf_wsel,

    input wire [4 :0] wR_EX,
    input wire [4 :0] wR_MEM,
    input wire [4 :0] wR_WB,

    input wire [31:0] wD_EX,
    input wire [31:0] wD_MEM,
    input wire [31:0] wD_WB,

    input wire        rf_we_EX,
    input wire        rf_we_MEM,
    input wire        rf_we_WB,
    
    //前�?�相关信�?
    output wire       forward_op1,
    output wire       forward_op2,
    output reg [31:0] rD1_forward,
    output reg [31:0] rD2_forward,

    //停顿及清除信�?
    output reg        pipeline_stop_PC,
    output reg        pipeline_stop_REG_IF_ID,
    output reg        flush_REG_ID_EX
);

    /**
     * 数据冒险�?测：核心条件：EX/MEM/WB_wR==rR1/rR2；附加的条件：此阶段RF可写，rD1/rD2必须被使用，wR不能为x0�?
     */

    //RAW-A 
    wire RAW_A_rR1 = (wR_EX == rR1_ID) && rf_we_EX && ID_read1 && (wR_EX != 5'b0);
    wire RAW_A_rR2 = (wR_EX == rR2_ID) && rf_we_EX && ID_read2 && (wR_EX != 5'b0);

    //RAW-B
    wire RAW_B_rR1 = (wR_MEM == rR1_ID) && rf_we_MEM && ID_read1 && (wR_MEM != 5'b0);
    wire RAW_B_rR2 = (wR_MEM == rR2_ID) && rf_we_MEM && ID_read2 && (wR_MEM != 5'b0);

    //RAW-C
    wire RAW_C_rR1 = (wR_WB == rR1_ID) && rf_we_WB && ID_read1 && (wR_WB != 5'b0);
    wire RAW_C_rR2 = (wR_WB == rR2_ID) && rf_we_WB && ID_read2 && (wR_WB != 5'b0);

    //load_use
    wire load_use_hazard = (RAW_A_rR1 || RAW_A_rR2) && (rf_wsel == `WB_DREM);


    /**
     * 数据冒险解决：前�?+停顿
     */

    //判断是否�?要前�?:RAW任意冒险出现即需要前�?
    assign forward_op1 = RAW_A_rR1 | RAW_B_rR1 | RAW_C_rR1;
    assign forward_op2 = RAW_A_rR2 | RAW_B_rR2 | RAW_C_rR2;

    //计算前�?�数�?
    always @ (*) begin
        if (RAW_A_rR1)      rD1_forward = wD_EX;
        else if (RAW_B_rR1) rD1_forward = wD_MEM;
        else if (RAW_C_rR1) rD1_forward = wD_WB;
        else                rD1_forward = 32'b0;
    end

    always @ (*) begin
        if (RAW_A_rR2)      rD2_forward = wD_EX;
        else if (RAW_B_rR2) rD2_forward = wD_MEM;
        else if (RAW_C_rR2) rD2_forward = wD_WB;
        else                rD2_forward = 32'b0;
    end

    //load_use冒险�?要特殊处理：停顿(PC及IF/ID不变+ID/EX�?0)+前�??
    always @ (*) begin
        if(load_use_hazard)  begin
            pipeline_stop_PC = 1'b1;
            pipeline_stop_REG_IF_ID = 1'b1;
            flush_REG_ID_EX = 1'b1;
        end
        else begin
            pipeline_stop_PC = 1'b0;
            pipeline_stop_REG_IF_ID = 1'b0;
            flush_REG_ID_EX = 1'b0;
        end
    end


endmodule