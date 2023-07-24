module REG_IF_ID (
    input wire        clk,
    input wire        rst,
    
    //停顿及清除信号
    input  wire       pipeline_stop,
    input  wire       flush,

    //寄存器所存数据
    input wire [31:0] pc_in,
    input wire [31:0] pc4_in,
    input wire [31:0] inst_in,
    output reg [31:0] pc_out,
    output reg [31:0] pc4_out,
    output reg [31:0] inst_out
);

    always @ (posedge clk or posedge rst) begin
        if (rst)                    pc_out <= 32'b0;
        else if (flush)             pc_out <= 32'b0;
        else if (pipeline_stop)     pc_out <= pc_out;
        else                        pc_out <= pc_in;
    end

    always @ (posedge clk or posedge rst) begin
        if (rst)                    pc4_out <= 32'b0;
        else if (flush)             pc4_out <= 32'b0;
        else if (pipeline_stop)     pc4_out <= pc4_out;
        else                        pc4_out <= pc4_in;
    end

    always @ (posedge clk or posedge rst) begin
        if (rst)                    inst_out <= 32'b0;
        else if (flush)             inst_out <= 32'b0;
        else if (pipeline_stop)     inst_out <= inst_out;
        else                        inst_out <= inst_in;
    end

endmodule