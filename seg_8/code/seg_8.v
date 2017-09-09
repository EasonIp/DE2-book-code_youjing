
module seg_8(

	//////// CLOCK //////////
	CLOCK_50,
  
	//////// KEY //////////
	KEY,

	//////// SEG7 //////////
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,

);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input		          		CLOCK_50;


//////////// KEY //////////
input		      [3:0]		KEY;


//////////// SEG7 //////////
output		   [6:0]		HEX0;
output		   [6:0]		HEX1;
output		   [6:0]		HEX2;
output		   [6:0]		HEX3;
output		   [6:0]		HEX4;
output		   [6:0]		HEX5;
output		   [6:0]		HEX6;
output		   [6:0]		HEX7;


//	7 segment LUT
SEG7_LUT_8 			u0	(	.oSEG0(HEX0),
							.oSEG1(HEX1),
							.oSEG2(HEX2),
							.oSEG3(HEX3),
							.oSEG4(HEX4),
							.oSEG5(HEX5),
							.oSEG6(HEX6),
							.oSEG7(HEX7),
							.iDIG({	4'd0,4'd1,4'd2,4'd3,4'd4,4'd5,4'd6,4'd7	}) );
							// .iDIG(mSEG7_DIG) );
// 最后一位参数是各个位上显示的值
endmodule
