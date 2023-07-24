`include "defines.vh"

module Control_HazardDetection(
    input wire        is_control_hazard,       //1为产生控制冒险

    //清除信号
    output wire       flush_REG_ID_EX,
    output wire       flush_REG_IF_ID
);
    
    //静态分支预测:总是预测不跳转，一旦预测错误即清除flush IF/ID, ID/EX
    assign flush_REG_ID_EX = is_control_hazard? 1'b1 :1'b0;
    assign flush_REG_IF_ID = is_control_hazard? 1'b1 :1'b0;

endmodule
