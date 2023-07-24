module REG_ID_EX (
    input wire        clk,
    input wire        rst,  
    
    //数据信号
    input wire [31:0] rD1_in,
    input wire [31:0] rD2_in,
    input wire [4 :0] wR_in,
    input wire [31:0] pc_in,
    input wire [31:0] pc4_in,
    input wire [31:0] imm_in,
    input wire        have_inst_in,

    output reg [31:0] rD1_out,
    output reg [31:0] rD2_out,
    output reg [4 :0] wR_out,
    output reg [31:0] pc_out,
    output reg [31:0] pc4_out,
    output reg [31:0] imm_out,
    output reg        have_inst_out,

    //前递相关信号
    input wire        forward_op1,
    input wire        forward_op2,
    input wire [31:0] rD1_forward,
    input wire [31:0] rD2_forward,

    //清除信号
    input wire        flush,

    //控制信号
    input wire [1 :0] rf_wsel_in,
    input wire [2 :0] branch_in,
    input wire        rf_we_in,
    input wire [3 :0] alu_op_in,
    input wire        alub_sel_in,
    input wire        ram_we_in,
    output reg [1 :0] rf_wsel_out,
    output reg [2 :0] branch_out,
    output reg        rf_we_out,
    output reg [3 :0] alu_op_out,
    output reg        alub_sel_out,
    output reg        ram_we_out
);

    //数据信号寄存
    always @(posedge clk or posedge rst) begin
        if(rst)           wR_out <= 5'b0;
        else if(flush)    wR_out <= 5'b0;
        else              wR_out <= wR_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           pc4_out <= 32'b0;
        else if(flush)    pc4_out <= 32'b0;
        else              pc4_out <= pc4_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           pc_out <= 32'b0;
        else if(flush)    pc_out <= 32'b0;
        else              pc_out <= pc_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           imm_out <= 32'b0;
        else if(flush)    imm_out <= 32'b0;
        else              imm_out <= imm_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           have_inst_out <= 1'b0;
        else if(flush)    have_inst_out <= 1'b0;
        else              have_inst_out <= have_inst_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)                 rD1_out <= 32'b0;
        else if(forward_op1)    rD1_out <= rD1_forward;     //前递
        else                    rD1_out <= rD1_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)                 rD2_out <= 32'b0;
        else if(forward_op2)    rD2_out <= rD2_forward;     //前递
        else                    rD2_out <= rD2_in;
    end

    //控制信号寄存
    always @(posedge clk or posedge rst) begin
        if(rst)           rf_wsel_out <= 2'b0;
        else if(flush)    rf_wsel_out <= 2'b0;
        else              rf_wsel_out <= rf_wsel_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           rf_we_out <= 1'b0;
        else if(flush)    rf_we_out <= 1'b0;
        else              rf_we_out <= rf_we_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           branch_out <= 3'b0;
        else if(flush)    branch_out <= 3'b0;
        else              branch_out <= branch_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           alu_op_out <= 4'b0;
        else if(flush)    alu_op_out <= 4'b0;
        else              alu_op_out <= alu_op_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           alub_sel_out <= 1'b0;
        else if(flush)    alub_sel_out <= 1'b0;
        else              alub_sel_out <= alub_sel_in;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)           ram_we_out <= 1'b0;
        else if(flush)    ram_we_out <= 1'b0;
        else              ram_we_out <= ram_we_in;
    end


endmodule