module led(
    input wire        rst,
    input wire        clk,
    input wire [11:0] addr,
    input wire        we,
    input wire [31:0] wdata,
    output reg [23:0] led
);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            led <= 24'd0;
        end else if(we && addr == 12'h060) begin
            led <= wdata[23:0];
        end else begin
            led <= led;
        end
    end



endmodule