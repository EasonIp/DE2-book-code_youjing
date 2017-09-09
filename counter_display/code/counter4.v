module counter4 (
	input clk_c4,
	input ena,
	input rst_n,
	output carry_out,
	output reg [3:0]q
);

always @(posedge clk_c4 or negedge rst_n) 
begin : proc_
	if(~rst_n)
		begin
			q <= 'b0000;
		end
	else
		if(ena)
			begin
				q <= q + 1;
			end
		else
			begin
				q <= 'bx;
			end
end  //proc_

assign carry_out = &q;

endmodule