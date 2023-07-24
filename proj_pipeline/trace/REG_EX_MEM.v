module REG_EX_MEM (
    input wire        clk,
    input wire        rst,

    //数据信号
    input wire [31:0] wD_in,
    input wire [4 :0] wR_in,
    input wire [31:0] rD2_in,
    input wire [31:0] pc_in,
    input wire [31:0] aluc_in,
    input wire        have_inst_in,

    output reg [31:0] wD_out,
    output reg [4 :0] wR_out,
    output reg [31:0] rD2_out,
    output reg [31:0] pc_out,
    output reg [31:0] aluc_out,
    output reg        have_inst_out,

    //控制信号
    input wire [1 :0] rf_wsel_in,
    input wire        rf_we_in,
    input wire        ram_we_in,
    output reg [1 :0] rf_wsel_out,
    output reg        rf_we_out,
    output reg        ram_we_out
);
    
    //数据信号寄存
    always @(posedge clk or posedge rst) begin
        if(rst)           wD_out <= 32'b0;
        else              wD_out <= wD_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           wR_out <= 5'b0;
        else              wR_out <= wR_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           rD2_out <= 32'b0;
        else              rD2_out <= rD2_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           pc_out <= 32'b0;
        else              pc_out <= pc_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           aluc_out <= 32'b0;
        else              aluc_out <= aluc_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           have_inst_out <= 1'b0;
        else              have_inst_out <= have_inst_in;
    end

    //控制信号寄存
    always @(posedge clk or posedge rst) begin
        if(rst)           rf_wsel_out <= 2'b0;
        else              rf_wsel_out <= rf_wsel_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           rf_we_out <= 1'b0;
        else              rf_we_out <= rf_we_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           ram_we_out <= 1'b0;
        else              ram_we_out <= ram_we_in;
    end

endmodule