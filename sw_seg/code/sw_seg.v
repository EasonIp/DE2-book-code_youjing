module sw_seg (
	input CLOCK_50,
	input [1:0]KEY, 
	// input KEY[0], 
	output [6:0]HEX0,
	output [6:0]HEX1,
	output [6:0]HEX2,
	output [6:0]HEX3,
	output [6:0]HEX4,
	output [6:0]HEX5,
	output [6:0]HEX6,
	output [6:0]HEX7
	
);

	wire [7:0]sum;
	wire [3:0]hundreds;
	wire [3:0]tens;
	wire [3:0]ones;
	pulse_8bit inst_pulse_8bit (
		.clk(CLOCK_50), 
		.rst_n(KEY[1]), 
		.key_in(KEY[0]), 
		.sum(sum));
	B2BCD inst_B2BCD (
		.binary_in(sum), 
		.hundreds(hundreds), 
		.tens(tens), 
		.ones(ones));
	SEG7_LUT_8 inst_SEG7_LUT_8
		(
			.oSEG0 (HEX0),
			.oSEG1 (HEX1),
			.oSEG2 (HEX2),
			.oSEG3 (HEX3),
			.oSEG4 (HEX4),
			.oSEG5 (HEX5),
			.oSEG6 (HEX6),
			.oSEG7 (HEX7),
			.iDIG  ({hundreds,tens,ones,4'd0,hundreds,tens,ones,4'd0,})
		);




endmodule