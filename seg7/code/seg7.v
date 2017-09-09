module seg7(clk, rst_n，/* data_in, */sel, seg);

	input clk;
	input rst_n;
	// input [23:0] data_in;    //6个位 4*6  每位数码管4位，范围0-15；还可以通过不同的译码显示16种符号或字母
	output reg [7:0] sel;
	output reg [7:0] seg;
	parameter data_in = 32'h12345678;
	reg [3:0] data_temp;
	reg [31:0] count;
	reg clk_1khz;
	
	parameter T = 50_000_000/1000/2 - 1;   // 1000 Hz 是同时显示得静态效果；1Hz是静态显示
	

	// 计数产生数码管扫屏的频率
	always @ (posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				count <= 32'd0;
				clk_1khz <= 0;
			end
		else
			begin
				if(count < T)
					count <= count + 1;
				else
					begin
						count <= 0;
						clk_1khz <= ~clk_1khz;
					end
			end
	end
	
	
	// ********段选信号,依次选择8个数码管**********
	always @ (posedge clk_1khz or negedge rst_n)
	begin
		if(!rst_n)
			sel <= 8'd0;
		else
			if(sel < 3'd8)
				sel <= sel + 1;
			else
				sel <= 8'd0;
	end



	always @ (*)
	begin
		if(!rst_n)
			data_temp = 4'd0;
		else 
			case(sel)
				3'd0	:	data_temp = data_in[23:20];
				3'd1	:	data_temp = data_in[19:16];
				3'd2	:	data_temp = data_in[15:12];
				3'd3	:	data_temp = data_in[11:8];
				3'd4	:	data_temp = data_in[7:4];
				3'd5	:	data_temp = data_in[3:0];
				default	:	data_temp = data_in[23:20];
			endcase
	end
	
	/*********位选信号，译码信号***********/
	always @ (*)
	begin
		if(!rst_n)
			seg = 8'b1100_0000;
		else
			begin
				case(data_temp)
//					4'd0	:	seg = 8'b1000_1001;
//					4'd1	:	seg = 8'b1000_0110;
//					4'd2	:	seg = 8'b1100_0111;
//					4'd3	:	seg = 8'b1100_0111;
//					4'd4	:	seg = 8'b1100_0000;
//					4'd5	:	seg = 8'b1111_1111;
					
//					4'd4	:	seg <= 8'b1001_1001;
//					4'd5	:	seg <= 8'b1001_0010;
					// 4'd0	:	seg = 8'b1100_0000;
					// 4'd1	:	seg = 8'b1111_1001;
					// 4'd2	:	seg = 8'b1010_0100;
					// 4'd3	:	seg = 8'b1011_0000;
					
					// 4'd4	:	seg <= 8'b1001_1001;
					// 4'd5	:	seg <= 8'b1001_0010;
					// 4'd6	:	seg <= 8'b1000_0010;
					// 4'd7	:	seg <= 8'b1111_1000;
					
					// 4'd8	:	seg = 8'b1000_0000;
					// 4'd9	:	seg = 8'b1001_0000;
					// 4'd10	:	seg = 8'b1000_1000;
					// 4'd11	:	seg = 8'b1000_0011;
					
					// 4'd12	:	seg = 8'b1100_0110;
					// 4'd13	:	seg = 8'b1010_0001;
					// 4'd14	:	seg = 8'b1000_0110;
					// 4'd15	:	seg = 8'b1000_1110;


					4'd0	: 	seg = 8'b11000000;//0
					4'd1	:	seg = 8'b11111001; //1
					4'd2	:	seg = 8'b10100100; //2
					4'd3	:	seg = 8'b10110000; //3
					4'd4	:	seg = 8'b10011001; //4
					4'd5	:	seg = 8'b10010010; //5
					4'd6	:	seg = 8'b10000010; //6
					4'd7	:	seg = 8'b11111000; //7
					4'd8	:	seg = 8'b10000000; //8
					4'd9	:	seg = 8'b10010000; //9
					4'd10	:	seg = 8'b10001000; //a
					4'd11	:	seg = 8'b10000011; //b
					4'd12	:	seg = 8'b10000110; //c
					4'd13	:	seg = 8'b10100001; //d
					4'd14	:	seg = 8'b10000110; //e
					4'd15	:	seg = 8'b10001110; //f

				endcase
			end
	end

endmodule 



module scan_led(clk,rst,sm_seg,sm_bit);
input clk,rst;
output[7:0] sm_seg; //数码管段选择输出
output[7:0] sm_bit; //数码管位选择输出
reg[7:0] sm_seg; //数码管段选择输出寄存器
reg[7:0] sm_bit; //数码管位选择输出寄存器

reg[15:0] cnt_scan;//扫描频率计数器
reg[4:0] dataout_buf;
always@(posedge clk or negedge rst)
begin
if(!rst) begin
cnt_scan<=0;
end
else begin
cnt_scan<=cnt_scan+1'b1;
end
end
always @(cnt_scan)
begin
case(cnt_scan[15:13])
3'b000 :
sm_bit = 8'b1111_1110;

3'b001 :
sm_bit = 8'b1111_1101;
3'b010 :
sm_bit = 8'b1111_1011;
3'b011 :
sm_bit = 8'b1111_0111;
3'b100 :
sm_bit = 8'b1110_1111;
3'b101 :
sm_bit = 8'b1101_1111;
3'b110 :
sm_bit = 8'b1011_1111;
3'b111 :
sm_bit = 8'b0111_1111;
default :
sm_bit = 8'b1111_1110;
endcase
end

always@(sm_bit)
begin
case(sm_bit)
8'b1111_1110:
dataout_buf=0;
8'b1111_1101:
dataout_buf=1;
8'b1111_1011:
dataout_buf=2;
8'b1111_0111:
dataout_buf=3;
8'b1110_1111:
dataout_buf=4;
8'b1101_1111:
dataout_buf=5;
8'b1011_1111:
dataout_buf=6;
8'b0111_1111:
dataout_buf=7;
default:

dataout_buf=8;
endcase
end
always@(dataout_buf)
begin
case(dataout_buf)
4'h0: sm_seg = 8'hc0; // "0"
4'h1 : sm_seg = 8'hf9; // "1"
4'h2 : sm_seg = 8'ha4; // "2"
4'h3 : sm_seg = 8'hb0; // "3"
4'h4 : sm_seg = 8'h99; // "4"
4'h5 : sm_seg = 8'h92; // "5"
4'h6 : sm_seg = 8'h82; // "6"
4'h7 : sm_seg = 8'hf8; // "7"
4'h8 : sm_seg = 8'h80; // "8"
4'h9 : sm_seg = 8'h90; // "9"
4'ha : sm_seg = 8'h88; // "a"
4'hb : sm_seg = 8'h83; // "b"

4'hc : sm_seg = 8'hc6; // "c"
4'hd : sm_seg = 8'ha1; // "d"
4'he : sm_seg = 8'h86; // "e"
4'hf : sm_seg = 8'h8e; // "f"
endcase
end
endmodule