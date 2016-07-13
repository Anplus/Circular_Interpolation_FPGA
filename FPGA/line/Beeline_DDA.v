module d_line(//input
			pulse_clk,
			sys_rst_l,
			Xe,
			Ye,
			change_readyH,
			//output
			X_acc,
			Y_acc,
			X_dec,
			Y_dec,
			draw_overH
);

module Beeline_DDA(pulse_clk,
				sys_rst_l,
				Xe,
				Ye,
				X_acc,
				Y_acc,
				X_dec,
				Y_dec,
				r_start);

input pulse_clk;
input sys_rst_l;
input [31:0] Xe;
input [31:0] Ye;

output X_acc;
output Y_acc;
output X_dec;
output Y_dec;
output r_start;

reg X_acc;
reg Y_acc;
reg X_dec;
reg Y_dec;
reg r_start;

reg r_Sx;
reg r_fSx;
reg r_Sy;
reg r_fSy;
integer i_Xe;
integer i_Ye;

reg r_Sx;
reg r_fSx;
reg r_Sy;
reg r_fSy;
integer i_Xe;
integer i_Ye;
reg [30:0] r31_Xe_abs;
reg [30:0] r31_Ye_abs;
reg [31:0] r32_Max;
integer i_Xe_sign;
integer i_Ye_sign;
integer i_bitNum;
reg [31:0] r32_n;
reg [31:0] r32_Xr;
reg [31:0] r32_Yr;
reg r_start1;

always @(posedge pulse_clk or negedge pulse_clk or posedge sys_rst_l)
begin
	if(sys_rst_l==1'b1)
		begin
			X_acc<=1'b0;
			X_dec<=1'b0;
		end
	else if(pulse_clk==1'b1)
		begin
			if(r_start1==1'b1)
				begin
					if((r32_Xr+r31_Xe_abs)>=r32_n)
						begin
							r32_Xr<=r32_Xr+r31_Xe_abs-r32_n;
							X_acc<=r_Sx;
							X_dec<=r_fSx;
						end
					else
						r32_Xr<=r32_Xr+r31_Xe_abs;
				end
		end
	else if(pulse_clk==1'b0)
		begin
			X_acc<=1'b0;
			X_dec<=1'b0;
		end
end

always @(posedge pulse_clk or negedge pulse_clk or posedge sys_rst_l)
begin
	if(sys_rst_l==1'b1)
		begin
			Y_acc<=1'b0;
			Y_dec<=1'b0;
		end
	else if(pulse_clk==1'b1)
		begin
			if(r_start1==1'b1)
				begin
					if((r32_Yr+r31_Ye_abs)>=r32_n)
						begin
							r32_Yr<=r32_Yr+r31_Ye_abs-r32_n;
							Y_acc<=r_Sy;
							Y_dec<=r_fSy;
						end
					else
						r32_Yr<=r32_Yr+r31_Ye_abs;
				end
		end
	else if(pulse_clk==1'b0)
		begin
			Y_acc<=1'b0;
			Y_dec<=1'b0;
		end
end

always @(posedge pulse_clk)
begin
	if(r_start1==1'b1)
		r32_Max<=r32_Max-32'b1;
end

always @(posedge pulse_clk or posedge sys_rst_l)
begin
	if(sys_rst_l==1'b1)
		r_start1<=1'b1;
	else if(r32_Max<=32'b1)
		r_start1<=1'b0;
end

always @(posedge pulse_clk or sys_rst_l)
begin
	if(sys_rst_l==1'b1)
		r_start<=1'b1;
	else
		r_start<=r_start1;
end

endmodule