module top (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	output [15:0]out_top
	
);

	wire clk_c4;
	wire clk_dis;
	wire [3:0]q1;
	wire [3:0]q2;


	freq #(.counter_num(50_000_000 / 1_000 / 2 -1)) 
	// freq #(.counter_num(50))     //simulation
		inst_freq_1 (
			.clk(clk),
			.rst_n(rst_n),
			.clk_1k(clk_c4)
			);
	freq #(.counter_num(50_000_000 / 1_000 / 2 -1)) 
		// freq #(.counter_num(50))     //simulation
		inst_freq_2 (
			.clk(clk), 
			.rst_n(rst_n), 
			.clk_1k(clk_dis)
			);
	display8 inst_display8_1 (.q(q1),.rst_n(rst_n), .clk_dis(clk_dis), .out_display8(out_display8));
	display8 inst_display8_2 (.q(q2),.rst_n(rst_n), .clk_dis(clk_dis), .out_display8(out_display8));
	counter4 inst_counter4_1 (.clk_c4(clk_c4), .ena(ena), .rst_n(rst_n), .carry_out(carry_out1), .q(q1));
	counter4 inst_counter4_2 (.clk_c4(clk_c4), .ena(carry_out1), .rst_n(rst_n), .carry_out(carry_out2), .q(q2));

	assign out_top = {q1,q2};

endmodule