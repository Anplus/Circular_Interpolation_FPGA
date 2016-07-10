
module speed_clk(// sync input	
				sys_clk,
				sys_rst_l,
				
				// data input
				speed,
				accelerate,		
				change_readyH,				
				
				// pulse output
				pulse_clk
				
			);

parameter		XTAL_CLK = 20000000;
parameter		CLK_DIV = 5000000;

input			sys_rst_l;	// async reset
input			sys_clk;	// main clock

input	[7:0]	init_speed;
input	[7:0]	accelerate;
input			change_readyH;

output			pulse_clk;

reg				div;
reg				cnt;
reg				r_pulse_clk;

assign pulse_clk = r_pulse_clk;

always @(posedge sys_clk) begin
	if (!sys_rst_l) begin
		cnt <= 0;
		r_pulse_clk = 0;
	end
	else begin
		if (cnt == CLK_DIV) begin
			cnt <= 0;
			r_pulse_clk <= ~r_pulse_clk;
		end
		else begin
			cnt <= cnt + 1;
		end
	end
end

endmodule
