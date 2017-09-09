module part1 (SW, LEDR);
input [17:0] SW; // toggle switches
output [17:0] LEDR; // red LEDs


assign LEDR = SW;
endmodule // part1

// 18个拨码开关控制18个灯
// 因为input和output的名字于svc文件中的名字一样，所以
// 可以直接导入pin文档
