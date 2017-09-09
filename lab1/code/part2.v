module part2 (SW, HEX0,HEX1);
input [15:0] SW; // toggle switches
// output [17:0] LEDR; // red LEDs
output [7:0] HEX0; 
output [7:0] HEX1; 



assign HEX0 = SW[15:8];
assign HEX1 = SW[7:0];
endmodule // part1


// 低电位点亮，SW0-6 依次为HEX1的abcdefg
//             SW8-14依次为HEX0的abcdefg
//             SW7为  HEX2的b