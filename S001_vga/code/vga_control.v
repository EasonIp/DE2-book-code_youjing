module vga_control (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	output reg vga_hs,
	output reg vga_vs,
	output  vga_blank_n,
	output clk_40M,
	output clk_syn,
	output reg [7:0]vga_rgb_r,
	output reg [7:0]vga_rgb_g,
	output reg [7:0]vga_rgb_b

);

 parameter H_FRONT = 128;     //行同步前沿信号周期长
 parameter H_SYNC = 88;     //行同步信号周期长
 parameter H_BACK = 40;      //行同步后沿信号周期长
 parameter H_ACT = 800;      //行显示周期长
 parameter H_BLANK = H_FRONT+H_SYNC+H_BACK;        //行空白信号总周期长
 parameter H_TOTAL = H_FRONT+H_SYNC+H_BACK+H_ACT;  //行总周期长耗时
 parameter V_FRONT = 4;     //场同步前沿信号周期长
 parameter V_SYNC = 23;       //场同步信号周期长
 parameter V_BACK = 1;      //场同步后沿信号周期长
 parameter V_ACT = 600;      //场显示周期长
 parameter V_BLANK = V_FRONT+V_SYNC+V_BACK;        //场空白信号总周期长
 parameter V_TOTAL = V_FRONT+V_SYNC+V_BACK+V_ACT;  //场总周期长耗时





//  40Mhz   25ns

	vga_pll inst_vga_pll (
		.areset(!rst_n),
		.inclk0(clk), 
		.c0(clk_40M)
		);

	reg [11:0] hs_counter;  //1056   
	reg [11:0] vs_counter;   //行628
	assign clk_syn = 1'b0;

	assign vga_blank_n = ~((hs_counter<H_BLANK)||(vs_counter<V_BLANK));  //当行计数器小于行空白总长或场计数器小于场空白总长时，空白信号低电平


	//先进行列计数(行扫描)  然后行计数(列扫描)  
	//列计数1055后行才开始计数
	always @(posedge clk_40M or negedge rst_n) 
	begin : proc_x
		if(~rst_n) begin
			hs_counter <= 12'b0;
		end else begin
			if(hs_counter == (H_TOTAL-1) ) begin
				hs_counter <= 12'd0;
				end
			else 
				begin
				hs_counter <= hs_counter + 1;
				end
		end
	end

	always @(posedge clk_40M or negedge rst_n) 
	begin : proc_2
		if(~rst_n) begin
			vs_counter <= 12'b0;
		end else begin
			if(vs_counter <= ( V_FRONT+V_SYNC+V_ACT -1) ) begin
				if(hs_counter == (H_TOTAL-1) ) begin
				vs_counter <= vs_counter + 1;
				end
				else
				vs_counter <= vs_counter;
			end
			else
				vs_counter <= 0;
		end
	end


	// always @(posedge clk_40M or negedge rst_n) 
	// begin : proc_x
	// 	if(~rst_n) begin
	// 		hs_counter <= 12'b0;
	// 		vs_counter <= 12'b0;
	// 	end else begin
	// 		if(hs_counter == 1055) begin
	// 			vs_counter <= vs_counter + 1;
	// 			if(vs_counter == 627) begin
	// 				hs_counter <= 12'd0;
	// 				vs_counter <= 12'd0;
	// 			end
	// 		end else 
	// 			begin
	// 				hs_counter <= hs_counter + 1;
	// 				// if(vs_counter == 628) begin
	// 				// 	vs_counter <= 12'd1;
	// 				// end else begin
	// 				// 	vs_counter <= vs_counter;
	// 				// end
	// 			end
	// 	end
	// end


// 时序划分abcd，并给行列输出值

	always @(posedge clk_40M or negedge rst_n) 
	begin : proc_hsvs
		if(~rst_n) begin
			vga_hs <= 1;
			vga_vs <= 1;
		end else begin
			if(hs_counter <= (H_FRONT-1) ) begin
				vga_hs <= 0;
			end else if( (hs_counter == (H_TOTAL-1) ) && vs_counter == (V_FRONT-1 )  ) begin
				vga_vs <= 0;
			end else begin
				vga_hs <= 1;
				vga_vs <= 1;
			end
		end
	end

//显示区域的内容
//行 列同时在c段时显示rgb数据

// //彩条赋值
// always @(posedge clk_40M or negedge rst_n)
// begin : proc_disp1
// 	if(~rst_n) begin
// 		vga_rgb_r <= 8'd0;
// 		vga_rgb_g <= 8'd0;
// 		vga_rgb_b <= 8'd0;
// 		vga_blank_n <= 1'b1;

// 	end else begin
			
// 			// if( (hs_counter >=217 && hs_counter <=1015) && (vs_counter >27 && vs_counter < 627) ) begin
// 			if( (hs_counter >= (H_FRONT+H_SYNC) && hs_counter <=515) && (vs_counter >27 && vs_counter < 227) ) begin
// 				vga_rgb_r<= 8'd1;
// 				vga_rgb_g<= 8'd0;
// 				vga_rgb_b<= 8'd0;
// 				vga_blank_n <= 1'b0;
// 			end else
// 			if( (hs_counter >515 && hs_counter <=815) && (vs_counter >=227 && vs_counter < 427) ) begin

// 				vga_rgb_r<= 8'd0;
// 				vga_rgb_g<= 8'd0;
// 				vga_rgb_b<= 8'd1;
// 				vga_blank_n <= 1'b0;
// 			end else
// 			if( (hs_counter >815 && hs_counter <=1015) && (vs_counter >=427 && vs_counter < 627) ) begin

// 				vga_rgb_r<= 8'd0;
// 				vga_rgb_g<= 8'd1;
// 				vga_rgb_b<= 8'd0;
// 				vga_blank_n <= 1'b0;
// 			end else
// 			begin
// 				vga_rgb_r<= 8'b000_000_00;
// 				vga_rgb_g<= 8'b000_000_00;
// 				vga_rgb_b<= 8'b000_000_00;
// 				vga_blank_n <= 1'b1;
// 			end
// 	end
// end


// // 纯色赋值
always @(posedge clk_40M or negedge rst_n)
begin : proc_disp
	if(~rst_n) begin
		vga_rgb_r <= 8'd0;
		vga_rgb_g <= 8'd0;
		vga_rgb_b <= 8'd0;
		// vga_blank_n <= 1'b0; 
	end else begin
			// if( (hs_counter >=( H_FRONT+H_SYNC -1 ) ) && (hs_counter <= (H_FRONT+H_SYNC+H_ACT-1) ) && (vs_counter >= ( V_FRONT+V_SYNC -1)) && (vs_counter <= ( V_FRONT+V_SYNC+V_ACT -1 ) )  )begin
				if( (hs_counter >=217 && hs_counter <=1015) && (vs_counter >27 && vs_counter < 627) ) begin
				vga_rgb_r <= 8'd255;
				vga_rgb_g <= 8'd48;
				vga_rgb_b <= 8'd48;
				// vga_blank_n <= 1'b1;  //给值不正确会显示黑屏
			end
			else
			begin
				vga_rgb_r <= 8'd0;
				vga_rgb_g <= 8'd0;
				vga_rgb_b <= 8'd0;
				// vga_blank_n <= 1'b0;
			end
	end
end





// always @(posedge clk_40M or negedge rst_n)
// begin : proc_disp
// 	if(~rst_n) begin
// 		vga_rgb <= 8'd0;
// 	end else begin
// 			if( (hs_counter >=217 && hs_counter <=1015) || (vs_counter >=27 && vs_counter <= 627) ) begin
// 				vga_rgb<= 8'b111_100_00;
// 			end
// 			else
// 			begin
// 				vga_rgb<= 8'b000_000_00;
// 			end
// 	end
// end

endmodule