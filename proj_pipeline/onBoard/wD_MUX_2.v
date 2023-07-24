module wD_MUX_2 (
    //输入信号
    input wire  [31:0] wD_in,       
    input wire  [31:0] dram_in,
    //输出信号
    output reg  [31:0] wD,
    //控制信号
    input wire  [1 :0] rf_wsel
);

    always @(*) begin
        case(rf_wsel)
            `WB_ALU:    wD = wD_in;
            `WB_EXT:    wD = wD_in;  
            `WB_PC:     wD = wD_in;
            `WB_DREM:   wD = dram_in; 
            default:    wD = 32'd0;
        endcase
    end

endmodule //MEM_MUX