module timer(
    input wire clk,         
    input wire rst,        
    input wire wen,     
    output reg [7:0]led_en      
);  
    
    reg clock_inc;
    wire clock_end;
    reg [24:0]clock;

    always @(posedge clk or posedge rst) begin      
        if(rst)              clock_inc <= 1'b0;
        else if(wen)        clock_inc <= 1'b1;
        else                clock_inc <= clock_inc;
    end

    assign clock_end = clock_inc & (clock==25'd29999);  

    always @(posedge clk or posedge rst) begin      
        if(rst)     clock <= 25'd0;
        else if(clock_end)   clock <= 25'd0;
        else if(clock_inc)     clock <= clock + 25'd1;
        else   clock <= clock;
    end

    always @(posedge clk or posedge rst) begin      //刷新频率设置2ms
        if(rst)   led_en <= 8'b1111_1110;
        else if(clock_end)    led_en <= {led_en[6:0],led_en[7]};  
        else    led_en <= led_en;
    end

endmodule //timer