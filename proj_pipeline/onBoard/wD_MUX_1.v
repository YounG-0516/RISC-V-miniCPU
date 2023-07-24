module wD_MUX_1 (
    //输入信号
    input wire  [31:0] aluc_in,       
    input wire  [31:0] sext_in,
    input wire  [31:0] pc4_in,
    //输出信号
    output reg  [31:0] wD,
    //控制信号
    input wire  [1 :0] rf_wsel
);

    always @(*) begin
        case(rf_wsel)
            `WB_ALU:    wD = aluc_in;
            `WB_EXT:    wD = sext_in;  
            `WB_PC:     wD = pc4_in;
            default:    wD = 32'd0;
        endcase
    end

endmodule //MEM_MUX