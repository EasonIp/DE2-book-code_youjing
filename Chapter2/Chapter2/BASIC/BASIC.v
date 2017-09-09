// BASIC.v
module BASIC(
	CLOCK_50,
	KEY,
	LEDG
);

input	CLOCK_50;
input	[3:0]KEY;
output	reg  [8:0]LEDG;
//  输出同时是输入
// 输出信号在后面用在always中过程赋值，所以要定义为reg型


always @(posedge KEY[0])
    LEDG[0] <= ~LEDG[0];

endmodule
// 组合逻辑的always块里面的过程赋值用的是 阻塞赋值  =
// 时序逻辑的always块中，所有的过程赋值需要用 非阻塞赋值   <=