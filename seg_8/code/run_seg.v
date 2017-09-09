
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


///////////////////////////////////////////////////////////////////
//=============================================================================
// REG/WIRE declarations
//=============================================================================

// parameter  counter_num = 50_000_000 / 1000 / 2 -1;



// wire [31:0]	mSEG7_DIG;
// reg  [31:0]	Cont;

//=============================================================================
// Structural coding
//=============================================================================
// initial //
//

// always@(posedge CLOCK_50 or negedge KEY[0])
//     begin
//         if(!KEY[0])
// 			 Cont	<=	0;
//         else
//         	begin
// 	        	if(Cont < counter_num)
// 	        		Cont	<=	Cont+1;
// 	        	else
// 				 Cont	<=	0;
//     		end
//     end


// assign	mSEG7_DIG	=	{	4'd0,4'd0,4'd0,4'd0,
// 							4'd0,4'd0,4'd0,4'd0	};

		//8个数码管上显示一样的信息；
		//选择27：24的原因是计数延时，（2**24 -1）计数一次   次数乘以20 ns= 0.33s

//	7 segment LUT
SEG7_LUT_8 			u0	(	.oSEG0(HEX0),
							.oSEG1(HEX1),
							.oSEG2(HEX2),
							.oSEG3(HEX3),
							.oSEG4(HEX4),
							.oSEG5(HEX5),
							.oSEG6(HEX6),
							.oSEG7(HEX7),
							.iDIG({	4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0	}) );
							// .iDIG(mSEG7_DIG) );
// 最后一位参数是各个位上显示的值
endmodule