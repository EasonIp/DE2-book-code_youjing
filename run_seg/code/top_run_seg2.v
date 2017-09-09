module top_run_seg2 (
	input CLOCK_50,    // Clock
	input rst_n,
	input key_in, 
	output	[6:0]	oSEG0,oSEG1,oSEG2,oSEG3,oSEG4,oSEG5,oSEG6,oSEG7
);

 // input [31:0]indata_24bit, 
    reg [31:0]indata_24bit; 

	wire [31:0]outdata_24bit;

	wire  [3:0]sum;

	filter inst_filter
(
	.clk          (CLOCK_50),
	.rst_n        (rst_n),
	.key_in       (key_in),
	.sum          (sum),
	.key_key_flag ()     /* 这里没用到，不写*/
);

		run_seg2  inst_run_seg2 (
			.CLOCK_50      (CLOCK_50),
			.rst_n         (rst_n),
			// .indata_24bit  ({4'd8,sum,sum,sum,sum,sum,sum,4'd0}),
			.indata_24bit  (    YT_system u0 (
        .clk_clk        (<connected-to-clk_clk>),        //     clk.clk
        .reset_reset_n  (<connected-to-reset_reset_n>),  //   reset.reset_n
        .sdram_addr     (<connected-to-sdram_addr>),     //   sdram.addr
        .sdram_ba       (<connected-to-sdram_ba>),       //        .ba
        .sdram_cas_n    (<connected-to-sdram_cas_n>),    //        .cas_n
        .sdram_cke      (<connected-to-sdram_cke>),      //        .cke
        .sdram_cs_n     (<connected-to-sdram_cs_n>),     //        .cs_n
        .sdram_dq       (<connected-to-sdram_dq>),       //        .dq
        .sdram_dqm      (<connected-to-sdram_dqm>),      //        .dqm
        .sdram_ras_n    (<connected-to-sdram_ras_n>),    //        .ras_n
        .sdram_we_n     (<connected-to-sdram_we_n>),     //        .we_n
        .pio_led_export (<connected-to-pio_led_export>), // pio_led.export
        .pio_key_export (<connected-to-pio_key_export>)  // pio_key.export
    );),
			.outdata_24bit (outdata_24bit)
		);


		SEG7_LUT_8 inst_SEG7_LUT_8
		(
			.oSEG0 (oSEG0),
			.oSEG1 (oSEG1),
			.oSEG2 (oSEG2),
			.oSEG3 (oSEG3),
			.oSEG4 (oSEG4),
			.oSEG5 (oSEG5),
			.oSEG6 (oSEG6),
			.oSEG7 (oSEG7),
			.iDIG  (outdata_24bit)
		);




endmodule