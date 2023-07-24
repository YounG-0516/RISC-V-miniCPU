module button(
    input  wire         rst,
    input  wire         clk,
    input  wire [11:0]  addr,
    input  wire [4 :0]  button_input,
    output reg  [31:0]  rdata
);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rdata <= 32'd0;
        end else begin
            rdata <= {27'd0,button_input};
        end
    end

endmodule