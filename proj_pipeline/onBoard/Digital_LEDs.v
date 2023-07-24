module Digital_LEDs (
   input wire        clk,
   input wire        rst,
   input wire [31:0] addr,
   input wire        wen,
   input wire [31:0] wdata,
   
   output wire[ 7:0] dig_en,
   output reg        DN_A,
   output reg        DN_B,
   output reg        DN_C,
   output reg        DN_D,
   output reg        DN_E,
   output reg        DN_F,
   output reg        DN_G,
   output reg        DN_DP
);
   
    wire [63:0] r;
    reg  [31:0] wD;
    
    always @(posedge clk or posedge rst) begin      
        if(rst)                             wD <= 32'b0;
        else if(wen && addr == 12'h000)     wD <= wdata;      
        else                                wD <= wD;
    end
    
    wire [31:0] wdata_pro = wD;
    
    Nixie_tube u_Nixie_tube_7(.clk(clk),.rst(rst),.DIG(wdata_pro[31:28]),.SEGMENT(r[7:0]));
    Nixie_tube u_Nixie_tube_6(.clk(clk),.rst(rst),.DIG(wdata_pro[27:24]),.SEGMENT(r[15:8]));
    Nixie_tube u_Nixie_tube_5(.clk(clk),.rst(rst),.DIG(wdata_pro[23:20]),.SEGMENT(r[23:16]));
    Nixie_tube u_Nixie_tube_4(.clk(clk),.rst(rst),.DIG(wdata_pro[19:16]),.SEGMENT(r[31:24]));
    Nixie_tube u_Nixie_tube_3(.clk(clk),.rst(rst),.DIG(wdata_pro[15:12]),.SEGMENT(r[39:32]));
    Nixie_tube u_Nixie_tube_2(.clk(clk),.rst(rst),.DIG(wdata_pro[11:8]),.SEGMENT(r[47:40]));
    Nixie_tube u_Nixie_tube_1(.clk(clk),.rst(rst),.DIG(wdata_pro[7:4]),.SEGMENT(r[55:48]));
    Nixie_tube u_Nixie_tube_0(.clk(clk),.rst(rst),.DIG(wdata_pro[3:0]),.SEGMENT(r[63:56]));
 
    always @(*) begin
        case(dig_en) 
            8'b1111_1110:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = r[63:56];
            8'b1111_1101:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = r[55:48];
            8'b1111_1011:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = r[47:40];
            8'b1111_0111:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = r[39:32];
            8'b1110_1111:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = r[31:24];
            8'b1101_1111:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = r[23:16];
            8'b1011_1111:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = r[15:8];
            8'b0111_1111:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = r[7:0];
            default:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = 8'b1111_1111;
        endcase
    end

    timer u_timer(.clk(clk),.rst(rst),.wen(wen),.led_en(dig_en));

endmodule //Digital_LEDs