module ex1 (sw,led_red);

	// Input Port(s)
	input [1:0] sw;

	// Output Port(s)
	output [3:0] led_red;

// Variable
reg led;

// Continous Assignment
assign led_red[0] = sw[0] ? 1'b1 : 1'b0;
assign led_red[1] = sw[1] ? 1'b1 : 1'b0;
assign led_red[2] = (sw[0]==sw[1]) ? 1'b1 : 1'b0;
assign led_red[3] = led;    
//最高位的显示 是利用定义的一个reg变量实现；
// assign是连续赋值语句。他的左边必须为wire类型
// 连续赋值语句用来驱动线型变量; 一般output 变量就是wire类型的
// 但是阻塞和非阻塞赋值等过程赋值语句的使用==必须是用来驱动reg型的
// 如下面的always块中的led 变量
// 有时候输出需要过程赋值时，可以直接用output reg [3:0] led_red;

// Always Construct(Combinational)
always@(sw)
begin
	if (sw[0])
	   if (sw[1])
	      led = 1'b1;
	   else
		   led = 1'b0;
	else
	   led = 1'b0;
end
endmodule


// 上面是一个组合逻辑的always块，所以里面的过程赋值用的是 阻塞赋值
//  要是使用在时序逻辑的always块中，所有的过程赋值需要用 非阻塞赋值