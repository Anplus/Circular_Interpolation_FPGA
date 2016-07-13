`timescale 1ns/1ns
module Circularity_DDA(purview,clk,reset,SOrN,Xs,Ys,Xe,Ye,r_Ax,r_Ay,r_fAx,r_fAy,r_start);

input clk;
input reset;
input purview;
input SOrN;
input [31:0] Xs;
input [31:0] Ys;
input [31:0] Xe;
input [31:0] Ye;

output r_Ax;
output r_Ay;
output r_fAx;
output r_fAy;
output r_start;

reg r_Ax;
reg r_Ay;
reg r_fAx;
reg r_fAy;
reg r_start;

integer i_Xe;
integer i_Ye;
integer i_Xi;
integer i_Yi;

reg [30:0] r31_Xi_abs;
reg [30:0] r31_Yi_abs;

reg [31:0] r32_Xr;
reg [31:0] r32_Yr;
reg [31:0] r32_n;
reg [31:0] r32_Max;
integer i_bitNum;
integer i_signXi;
integer i_signYi;
integer i_signXe;
integer i_signYe;
reg r_startX;
reg r_startY;
reg r_SQEX;
reg r_SQEY;
reg r_cnt;

initial wait(purview)
begin
	#10
	i_Xe=Xe;
	i_Ye=Ye;
	i_Xi=Xs;
	i_Yi=Ys;
	if(i_Xi>0)
		i_signXi=1;
	else if(i_Xi<0)
		i_signXi=-1;
	else
		i_signXi=0;
	r31_Xi_abs=i_signXi*i_Xi;
	if(i_Yi>0)
		i_signYi=1;
	else if(i_Yi<0)
		i_signYi=-1;
	else
		i_signYi=0;
	r31_Yi_abs=i_signYi*i_Yi;
	if(i_Xe>0)
		i_signXe=1;
	else if(i_Xe<0)
		i_signXe=-1;
	else
		i_signXe=0;
	if(i_Ye>0)
		i_signYe=1;
	else if(i_Ye<0)
		i_signYe=-1;
	else
		i_signYe=0;
	if(r31_Xi_abs>=r31_Yi_abs)
		r32_Max=r31_Xi_abs;
	else
		r32_Max=r31_Yi_abs;
	i_bitNum=30;
	while(r32_Max[i_bitNum]==0&&i_bitNum>=0)
		begin
			i_bitNum=i_bitNum-1;
		end
	i_bitNum=i_bitNum+2;
	r32_n=32'b0;
	r32_n[i_bitNum]=1'b1;
	r32_Xr=32'b0;
	r32_Yr=32'b0;
	r32_Xr[i_bitNum-1]=1'b1;
	r32_Yr[i_bitNum-1]=1'b1;
	if(i_Xi==i_Xe)
		r_SQEX=1'b1;
	else
		r_SQEY=1'b1;
	if(i_Yi==i_Ye)
		r_SQEY=1'b1;
	else
		r_SQEY=1'b0;
end

always wait(purview)@(posedge clk or posedge reset)
begin
	if(reset==1'b1)
		r_cnt<=1'd0;
	else if(r_start==1'b1)
		r_cnt<=r_cnt+1'd1;
end

always wait(purview)@(posedge clk)
begin
	if(r_SQEX&&(r_Ax+r_fAx))
		r_SQEX<=1'b0;
end

always wait(purview)@(posedge clk)
begin
	if(r_SQEY&&(r_Ay+r_fAy))
		r_SQEY<=1'b0;
end

always wait(purview)@(posedge clk or posedge reset)
begin
	if(reset==1'b1)
		begin
			r_Ax<=1'b0;
			r_fAx<=1'b0;
		end
	else if(r_cnt==1'd0)
		begin
			if(r_startX==1'b1)
				begin
					if((r32_Xr+r31_Yi_abs)>=r32_n)
						begin
							r32_Xr<=r32_Xr+r31_Yi_abs-r32_n;
							if(SOrN==1'b1)
								begin
									if(i_signYi>=0&&i_signXi<0||i_signXi>=0&&i_signYi>0)
										begin
											r_Ax<=1'b1;
											i_Xi<=i_Xi+1;
										end
									else
										begin
											r_fAx<=1'b1;
											i_Xi<=i_Xi-1;
										end
								end
							else
								begin
									if(i_signYi>=0&&i_signXi>0||i_signXi<=0&&i_signYi>0)
										begin
											r_fAx<=1'b1;
											i_Xi<=i_Xi-1;
										end
									else
										begin
											r_Ax<=1'b1;
											i_Xi<=i_Xi+1;
										end
								end
						end
					else
						r32_Xr<=r32_Xr+r31_Yi_abs;
				end
			end
		else if(r_cnt==1'd1)
			begin
				r_Ax<=1'b0;
				r_fAx<=1'b0;
			end
end

always wait(purview)@(posedge clk)
begin
	if(r_start==1'b1&&r_cnt==1'd1)
		begin
			if(i_Xi>0)
				begin
					i_signXi<=1;
					r31_Xi_abs<=i_Xi;
				end
			else if(i_Xi<0)
				begin
					i_signXi=-1;
					r31_Xi_abs<=-1*i_Xi;
				end
			else
				begin
					i_signXi<=0;
					r31_Xi_abs<=0;
				end
		end
end

always wait(purview)@(posedge clk or posedge reset)
begin
	if(reset==1'b1)
		r_startX<=1'b1;
	else if(i_Xi==i_Xe)
		begin
			if(i_signYe!=0&&i_signYi==i_signYe||i_signYe==0)
				begin
					if(r_SQEX==1'b0)
						r_startX<=1'b0;
				end
		end
end

always wait(purview)@(posedge clk or posedge reset)
begin
	if(reset==1'b1)
		begin
			r_Ay<=1'b0;
			r_fAy<=1'b0;
		end
	else if(r_cnt==1'd0)
		begin
			if(r_startY==1'b1)
				begin
					if((r32_Yr+r31_Xi_abs)>=r32_n)
						begin
							r32_Yr<=r32_Yr+r31_Xi_abs-r32_n;
							if(SOrN==1'b1)
								begin
									if(i_signXi>=0&&i_signYi>0||i_signYi<=0&&i_signXi>0)
										begin
											r_fAy<=1'b1;
											i_Yi<=i_Yi-1;
										end
									else
										begin
											r_fAy<=1'b1;
											i_Yi<=i_Yi+1;
										end
								end
							else
								begin
									if(i_signXi>=0&&i_signYi<0||i_signYi>=0&&i_signXi>0)
										begin
											r_Ay<=1'b1;
											i_Yi<=i_Yi+1;
										end
									else
										begin
											r_fAy<=1'b1;
											i_Yi<=i_Yi-1;
										end
								end
						end
					else
						r32_Yr<=r32_Yr+r31_Xi_abs;
				end
			end
		else if(r_cnt==1'd1)
			begin
				r_Ay<=1'b0;
				r_fAy<=1'b0;
			end
end

always wait(purview)@(posedge clk)
begin
	if(r_start==1'b1&&r_cnt==1'd1)
		begin
			if(i_Yi>0)
				begin
					i_signYi<=1;
					r31_Yi_abs<=i_Yi;
				end
			else if(i_Yi<0)
				begin
					i_signYi=-1;
					r31_Yi_abs<=-1*i_Yi;
				end
			else
				begin
					i_signYi<=0;
					r31_Yi_abs<=0;
				end
		end
end

always wait(purview)@(posedge clk or posedge reset)
begin
	if(reset==1'b1)
		r_startY<=1'b1;
	else if(i_Yi==i_Ye)
		begin
			if(i_signXe!=0&&i_signXi==i_signXe||i_signXe==0)
				begin
					if(r_SQEY==1'b0)
						r_startY<=1'b0;
				end
		end
end

always wait(purview)@(posedge clk or posedge reset)
begin
	if(reset==1'b1)
		r_start<=1'b1;
	else if(r_startX==1'b0&&r_startY==1'b0)
		r_start<=1'b0;
end
endmodule