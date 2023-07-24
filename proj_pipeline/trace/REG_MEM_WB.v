module REG_MEM_WB (
    input wire        clk,
    input wire        rst,  
    
    //数据信号
    input wire [4 :0] wR_in,
    input wire [31:0] wD_in,
    input wire [31:0] pc_in,
    input wire        have_inst_in,

    output reg [4 :0] wR_out,
    output reg [31:0] wD_out,
    output reg [31:0] pc_out,
    output reg        have_inst_out,

    //控制信号
    input wire        rf_we_in,
    output reg        rf_we_out
);

    //数据信号寄存
    always @ (posedge clk or posedge rst) begin
        if(rst)      wR_out <= 5'b0;
        else         wR_out <= wR_in;
    end

    always @ (posedge clk or posedge rst) begin
        if(rst)      wD_out <= 32'b0;
        else         wD_out <= wD_in;
    end

    always @ (posedge clk or posedge rst) begin
        if(rst)      pc_out <= 32'b0;
        else         pc_out <= pc_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)      have_inst_out <= 1'b0;
        else         have_inst_out <= have_inst_in;
    end

    //控制信号寄存
    always @ (posedge clk or posedge rst) begin
        if(rst)      rf_we_out <= 1'b0;
        else         rf_we_out <= rf_we_in;
    end

endmodule