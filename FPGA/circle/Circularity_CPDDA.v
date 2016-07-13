`timescale 1ns/1ns
module Circularity_CPDDA(purview,clk,reset,SOrN,Xs,Ys,Xe,Ye,r_Ax,r_Ay,r_fAx,r_fAy,r_start);

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
reg r_tAx;
reg r_tAy;
reg r_tfAx;
reg r_tfAy;
reg r_start;

integer i_Xe;
integer i_Ye;
integer i_Xi;
integer i_Yi;

reg [30:0] r31_Xi_abs;
reg [30:0] r31_Yi_abs;

integer i_signXi;
integer i_signYi;
integer i_signXe;
integer i_signYe;

reg r_startX;
reg r_startY;
reg r_SQEX;
reg r_SQEY;
integer i_F;
integer i_Max;
reg [1:0] r2_cnt;

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
	if(i_Xi==i_Xe)
		r_SQEX=1'b0;
	else 
		r_SQEY=1'b0;
	i_F=r31_Xi_abs-r31_Yi_abs;
	i_Max=i_Xe*i_Xe+i_Ye*i_Ye;
end

always wait(purview)@(posedge clk or posedge reset)
begin
	if(reset==1'b1)
		r2_cnt<=2'd0;
	else if(r_start==1'b1)
		begin
			if(2'd2==r2_cnt)
				r2_cnt<=2'd0;
			else 
				r2_cnt<=r2_cnt+2'd1;
		end
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

always wait(purview)@(negedge clk)
begin
	if(2'd2==r2_cnt)
		i_F<=i_F+(r_tAx+r_tfAx)*r31_Xi_abs-(r_tAy+r_tfAy)*r31_Yi_abs;
end

always wait(purview)@(posedge clk or posedge reset)
begin
	if(reset==1'b1)
		begin
			r_Ax<=1'b0;
			r_Ax<=1'b0;
			r_tAx<=1'b0;
			r_tfAx<=1'b0;
		end
	else if(r2_cnt==2'd0)
		begin
			if(r_startX==1'b1)
				begin
					if(i_F<=0||r_startY==1'b0)
						begin
							if(SOrN==1'b1)
								begin
									if(i_signYi>=0&&i_signXi<0||i_signXi>=0&&i_signYi>0)
										begin
											if((i_Xi+1)*(i_Xi+1)<=i_Max)
												begin
													r_Ax<=1'b1;
													i_Xi<=i_Xi+1;
												end
											r_tAx<=1'b1;
										end
									else
										begin
											if((i_Xi-1)*(i_Xi-1)<=i_Max)
												begin
													r_fAx<=1'b1;
													i_Xi<=i_Xi-1;
												end
											r_tfAx<=1'b1;
										end
								end
							else
								begin
									if(i_signYi>=0&&i_signXi>0||i_signXi<=0&&i_signYi>0)
										begin
											if((i_Xi-1)*(i_Xi-1)<=i_Max)
												begin
													r_fAx<=1'b1;
													i_Xi<=i_Xi-1;
												end
											r_tfAx<=1'b1;
										end
									else
										begin
											if((i_Xi+1)*(i_Xi+1)<=i_Max)
												begin
													r_Ax<=1'b1;
													i_Xi<=i_Xi+1;
												end
											r_tAx<=1'b1;
										end
								end
						end
				end
		end
	else if(r2_cnt==2'd1)
		begin
			r_Ax<=1'b0;
			r_fAx<=1'b0;
		end
	else if(r2_cnt==2'd2)
		begin
			r_tAx<=1'b0;
			r_tfAx<=1'b0;
		end
end

always wait(purview)@(posedge clk)
begin
	if(r_start==1'b1&&r2_cnt==2'd1)
		begin
			if(i_Xi>0)
				begin
					i_signXi<=1;
					r31_Xi_abs<=i_Xi;
				end
			else if(i_Xi<0)
				begin
					i_signXi<=-1;
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
			r_Ay<=1'b0;
			r_tAy<=1'b0;
			r_tfAy<=1'b0;
		end
	else if(r2_cnt==2'd0)
		begin
			if(r_startY==1'b1)
				begin
					if(i_F<=0||r_startX==1'b0)
						begin
							if(SOrN==1'b1)
								begin
									if(i_signXi>=0&&i_signYi>0||i_signYi<=0&&i_signXi>0)
										begin
											if((i_Yi-1)*(i_Yi-1)<=i_Max)
												begin
													r_fAy<=1'b1;
													i_Yi<=i_Yi-1;
												end
											r_tfAy<=1'b1;
										end
									else
										begin
											if((i_Yi+1)*(i_Yi+1)<=i_Max)
												begin
													r_Ay<=1'b1;
													i_Yi<=i_Yi+1;
												end
											r_tAy<=1'b1;
										end
								end
							else
								begin
									if(i_signXi>=0&&i_signYi<0||i_signYi>=0&&i_signXi>0)
										begin
											if((i_Yi+1)*(i_Yi+1)<=i_Max)
												begin
													r_Ay<=1'b1;
													i_Yi<=i_Yi+1;
												end
											r_tAy<=1'b1;
										end
									else
										begin
											if((i_Yi-1)*(i_Yi-1)<=i_Max)
												begin
													r_fAy<=1'b1;
													i_Yi<=i_Yi-1;
												end
											r_tfAy<=1'b1;
										end
								end
						end
				end
		end
	else if(r2_cnt==2'd1)
		begin
			r_Ay<=1'b0;
			r_fAy<=1'b0;
		end
	else if(r2_cnt==2'd2)
		begin
			r_tAy<=1'b0;
			r_tfAy<=1'b0;
		end
end

always wait(purview)@(posedge clk)
begin
	if(r_start==1'b1&&r2_cnt==2'd1)
		begin
			if(i_Yi>0)
				begin
					i_signYi<=1;
					r31_Yi_abs<=i_Yi;
				end
			else if(i_Yi<0)
				begin
					i_signYi<=-1;
					r31_Yi_abs<=-1*i_Yi;
				end
			else
				begin
					i_signYi<=0;
					r31_Yi_abs<=0;
				end
		end
end

always wait(purview)@(posedge clk)
begin
	if(r_start==1'b1&&r2_cnt==2'd3)
		r31_Yi_abs<=i_signYi*i_Yi;
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