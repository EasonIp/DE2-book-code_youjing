module PWM_Led
(
    input clk,
    input rst_n,
    input [4:0] option_key,
    output led
);
    parameter SEGMENT = 8'd195;    //3.9us
    
    reg [7:0] c1;
    
    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            c1 <= 7'd0;
        else if (c1 == SEGMENT)
            c1 <= 7'd0;
        else
            c1 <= c1 + 1'b1;
            
    reg [7:0] system_seg;
	 
    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            system_seg <= 8'd0;
        else if (system_seg == 8'd255)
            system_seg <= 8'd0;
        else if (c1 == SEGMENT)
            system_seg <= system_seg + 1'b1;
            
    reg [7:0] option_seg;

    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            option_seg <= 8'd0;
        else if (option_key[4])    //segment + 10
            if (option_seg < 8'd245) 
                option_seg <= option_seg + 8'd10;
            else 
                option_seg <= 8'd255;
        else if (option_key[3])    //segment - 10
            if (option_seg > 8'd10)
                option_seg <= option_seg - 8'd10;
            else
                option_seg <= 8'd0;
        else if (option_key[2])    //segment + 1
            if (option_seg < 8'd255)
                option_seg <= option_seg + 8'd1;
            else
                option_seg <= 8'd255;
        else if (option_key[1])    //segment - 1
            if (option_seg > 8'd0)
                option_seg <= option_seg - 8'd1;
            else
                option_seg <= 8'd0;
        else if (option_key[0])    //segment = half
            option_seg <= 8'd127;
            
    assign led = (system_seg < option_seg) ? 1'b1: 1'b0;

endmodule
