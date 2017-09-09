module Counter10
	(
		iclk,
		rst_n,
		q,
		overflow
	);
input iclk;
input rst_n;
output reg [3:0] q;
output overflow;
always @(posedge iclk or negedge rst_n)
	begin
		if(~rst_n) q <= 4'h0;
		else
		begin
		if(4'h9 == q) q <= 4'h0;
		else q <= q + 4'h1;
		end
	end
assign overflow = 4'h9 == q;
endmodule