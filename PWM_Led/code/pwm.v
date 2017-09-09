module pwm(clk,rst_n,led);

input clk;//clk=50M=50 000 000
input rst_n;
output reg led;   //led

reg [15:0] pwm,count;  //PMW脉宽计数，周期计数


//  计数实现脉宽调整
 always @(posedge clk)
	 begin
	 	count=count+1;
	   	if(count[15] == 1)    //打到周期预设定的数值，就清零
		  count=0;
		if(count < pwm)        //如果本周期中，周期小于PWM脉宽计数，那么LED就=1
	  		led=1;
	 	else 
	 		led=0;            //PWM的低脉冲时候，就为0
	end

// 计数到 2**14*20ns pwm加上1，实现pwm界限增加；最终脉宽调整
always @(posedge count[14])          //一个周期前面一点，产生PWM加/减 信号
	 begin
	  pwm =pwm + 1'b1;                                //PWM 在一个周期完成之前加1，用于下一个周期的信号宽度
	  if(pwm[13] == 1)                               //脉宽达到预设定的数值
	   pwm = 0;
	 end 
 
endmodule 