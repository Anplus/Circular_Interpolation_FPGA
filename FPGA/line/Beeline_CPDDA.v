`timescale 1ns/1ns
module Beeline_CPDDA(purview,clk,reset,Xe,Ye,r_Ax,r_Ay,r_fAx,r_fAy,r_start);

input clk;
input reset;
input purview;
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
reg r_startX;
reg r_startY;
reg r_Sx;
reg r_Sy;
reg r_fSx;
reg r_fSy;
integer i_Xe;
integer i_Ye;
reg [30:0] r31_Xe_abs;
reg [30:0] r31_Ye_abs;
reg [30:0] r31_X_End;
reg [30:0] r31_Y_End;
integer i_Xe_sign;
integer i_Ye_sign;
integer i_F;

initial wait(purview)
begin
	#10
	r_Sx=1'b0;
	r_fSx=1'b0;
	r_Sy=1'b0;
	r_fSy=1'b0;
	i_Xe=Xe;
	i_Ye=Ye;
	if(i_Xe>0)
		begin
			i_Xe_sign=1;
			r_Sx=1'b1;
		end
	else if(i_Xe<0)
		begin 
			i_Xe_sign=-1;
			r_fSx=1'b1;
		end
	else
		i_Xe_sign=0;
	r31_Xe_abs=i_Xe_sign*i_Xe;
	r31_X_End=r31_Xe_abs;
	if(i_Ye>0)
		begin
			i_Ye_sign=1;
			r_Sy=1'b1;
		end
	else if(i_Ye<0)
		begin 
			i_Ye_sign=-1;
			r_fSy=1'b1;
		end
	else
		i_Ye_sign=0;
	r31_Ye_abs=i_Ye_sign*i_Ye;
	r31_Y_End=r31_Ye_abs;
end

always wait(purview)@(negedge clk or posedge reset)
begin
	if(reset==1'b1)
		i_F<=0;
	else
		i_F<=i_F+(r_Ax+r_fAx)*r31_Ye_abs-(r_Ay+r_fAy)*r31_Xe_abs;
end

always wait(purview)@(negedge clk or posedge reset)
begin
	if(reset==1'b1)
		r_startX<=1'b1;
	else if(r31_X_End==0)
		r_startX<=1'b0;
end

always wait(purview)@(negedge clk or posedge reset)
begin
	if(reset==1'b1)
		r_startY<=1'b1;
	else if(r31_Y_End==0)
		r_startY<=1'b0;
end

always wait(purview)@(posedge clk or negedge clk or posedge reset)
begin
	if(reset==1'b1)
		begin
			r_Ax<=1'b0;
			r_fAx<=1'b0;
		end
	else if(clk==1'b1)
		begin
			if(r_startX==1'b1)
				begin
					if(i_F<=0)
						begin
							r_Ax<=r_Sx;
							r_fAx<=r_fSx;
							r31_X_End<=r31_X_End-1;
						end
				end
		end
	else if(clk==1'b0)
		begin
			r_Ax<=1'b0;
			r_fAx<=1'b0;
		end
end

always wait(purview)@(posedge clk or negedge clk or posedge reset)
begin
	if(reset==1'b1)
		begin
			r_Ay<=1'b0;
			r_fAy<=1'b0;
		end
	else if(clk==1'b1)
		begin
			if(r_startY==1'b1)
				begin
					if(i_F>=0)
						begin
							r_Ay<=r_Sy;
							r_fAy<=r_fSy;
							r31_Y_End<=r31_Y_End-1;
						end
				end
		end
	else if(clk==1'b0)
		begin
			r_Ay<=1'b0;
			r_fAy<=1'b0;
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
