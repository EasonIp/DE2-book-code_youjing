module display8 (
	input [3:0]q,    
	input clk_dis,  // Asynchronous reset active low
	input rst_n, 
	output reg [7:0]out_display8
);

always @(posedge clk_dis or negedge rst_n) 
begin : proc_
	if(~rst_n) 
		begin
			out_display8 <= 8'd0;
		end 
	else 
		begin
			case (q)
					4'd0	: 	out_display8 <= 8'b1100_0000;//0
					4'd1	:	out_display8 <= 8'b11111001; //1
					4'd2	:	out_display8 <= 8'b10100100; //2
					4'd3	:	out_display8 <= 8'b10110000; //3
					4'd4	:	out_display8 <= 8'b10011001; //4
					4'd5	:	out_display8 <= 8'b10010010; //5

					4'd6	:	out_display8 <= 8'b10000010; //6
					4'd7	:	out_display8 <= 8'b11111000; //7
					4'd8	:	out_display8 <= 8'b10000000; //8
					4'd9	:	out_display8 <= 8'b10010000; //9
					4'd10	:	out_display8 <= 8'b10001000; //a
					4'd11	:	out_display8 <= 8'b10000011; //b
					4'd12	:	out_display8 <= 8'b10000110; //c
					4'd13	:	out_display8 <= 8'b10100001; //d
					4'd14	:	out_display8 <= 8'b10000110; //e
					4'd15	:	out_display8 <= 8'b10001110; //f
			endcase
		end
end

endmodule
