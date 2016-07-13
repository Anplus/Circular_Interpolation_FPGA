
//逐点比较法直线插补

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

parameter	LO 		= 1'b0,
          	HI		= 1'b1,		
 		  	X		= 1'bx;
			
input				pulse_clk;
input				sys_rst_l;
input	[15:0]		Xe;
input	[15:0]		Ye;
input				change_readyH;

output				X_acc;		//x+
output				Y_acc;		//y+
output				X_dec;		//x-
output				Y_dec;		//y-
output				draw_overH;	//插补完成

reg					X_acc;
reg					Y_acc;
reg					X_dec;
reg					Y_dec;
reg					draw_overH;

integer				i_Xe;		//终点坐标
integer				i_Ye;
reg		[15:0]		Xe_abs;		//终点坐标绝对值
reg		[15:0]		Ye_abs;
integer				i_Xe_sign;	//符号
integer				i_Ye_sign;
reg					r_e;		//x=0时补偿
integer				error;		//偏差
integer				steps;		//总步数

always @(posedge change_readyH) begin
	r_e = 0;
	i_Xe = Xe;
	if(Xe > 0) begin
		i_Xe_sign = 1;
		Xe_abs = Xe;
	end
	else if (Xe < 0) begin
		i_Xe_sign = -1;
		Xe_abs = - Xe;
	end
	else begin
		i_Xe_sign = 0;
		Xe_abs = 0;
		r_e = 1;
	end
	i_Ye = Ye;
	if(Ye > 0) begin
		i_Ye_sign = 1;
		Ye_abs = Ye;
	end
	else if (Ye < 0) begin
		i_Ye_sign = -1;
		Ye_abs = - Ye;
	end
	else begin
		i_Ye_sign = 0;
		Ye_abs = 0;
	end
	steps = Xe_abs + Ye_abs + r_e;
end

always @(posedge pulse_clk or negedge pulse_clk or negedge sys_rst_l) begin
	if (~sys_rst_l) begin
		X_acc <= 0;
		Y_acc <= 0;
		X_dec <= 0;
		Y_dec <= 0;	
		error <= 0;
	end
	else if (pulse_clk) begin
		if (~draw_overH) begin
			if (error >= 0) begin
				if (i_Xe_sign > 0)
					X_acc <= 1;
				else
					X_dec <= 1;
				error <= error - Ye_abs;
			end
			else begin
				if (i_Ye_sign > 0)
					Y_acc <= 1;
				else
					Y_dec <= 1;
				error <= error + Xe_abs;
			end
			steps <= steps - 1;
		end
	end
	else begin
		X_acc <= 0;
		Y_acc <= 0;
		X_dec <= 0;
		Y_dec <= 0;	
	end
end

always @(posedge sys_clk or negedge sys_rst) begin
	if (~sys_rst)
		r_draw_overH <= LO;
	else if (steps <= 1)
		r_draw_overH <= HI;		
end

always @(posedge sys_clk or negedge sys_rst) begin
	if (~sys_rst)
		draw_overH <= LO;
	else if
		draw_overH <= r_draw_overH;	
end
endmodule
