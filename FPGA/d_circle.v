
//逐点比较法圆弧插补

module d_circle(// input
				pulse_clk,
				sys_rst_l,
				direct,
				Xs,
				Ys,
				Xe,
				Ye,
				change_readyH,
				// output
				X_acc,
				Y_acc,
				X_dec,
				Y_dec,
				draw_overH
);

parameter	LO 		= 1'b0,
          	HI		= 1'b1,		
 		  	X		= 1'bx;
			
input			pulse_clk;
input			sys_rst_l;
input			direct;
input	[15:0]	Xs;
input	[15:0]	Ys;
input	[15:0]	Xe;
input	[15:0]	Ye;
input			change_readyH;

output			X_acc;
output			Y_acc;
output			X_dec;
output			Y_dec;
output			draw_overH;

reg				X_acc;
reg				Y_acc;
reg				X_dec;
reg				Y_dec;
reg				draw_overH;


integer			i_Xe;		//终点
integer			i_Ye;
integer			i_Xi;		//动点
integer			i_Yi;
reg		[15:0]	Xi_abs;		//动点坐标绝对值
reg		[15:0]	Yi_abs;

integer			i_sign;		//保存符号
integer			error;		//偏差

always wait (draw_overH) @(posedge change_readyH) begin
	draw_overH = LO;
	i_Xe = Xe;
	i_Ye = Ye;
	i_Xi = Xs;
	i_Yi = Ys;
	actH = LO;
	
	if (i_Xi >= 0)
		Xi_abs = i_Xi;
	else
		Xi_abs = -i_Xi;
		
	if (i_Yi >= 0)
		Yi_abs = i_Yi;
	else
		Yi_abs = -i_Yi;

end

always @(posedge pulse_clk or negedge pulse_clk or negedge sys_rst_l) begin
	if (~sys_rst_l) begin
		draw_overH <= HI;
		X_acc <= 0;
		Y_acc <= 0;
		X_dec <= 0;
		Y_dec <= 0;	
		error <= 0;
		actH <= LO;
	end
	else if (pulse_clk) begin
		if (~draw_overH) begin
			if (error >= 0) begin
				if (direct == 1 && i_Xi >= 0 && i_Yi > 0	//SR1
					||direct == 0 && i_Xi <= 0 && i_Yi > 0	//NR2
					||direct == 1 && i_Xi <= 0 && i_Yi < 0	//SR3
					||direct == 0 && i_Xi >= 0 && i_Yi < 0	//NR4
				) begin
					if (direct == 1 && i_Xi <= 0 && i_Yi < 0	//SR3
						||direct == 0 && i_Xi >= 0 && i_Yi < 0	//NR4
					) begin
						Y_acc <= 1;
						i_Yi <= i_Yi + 1;
					end
					else begin
						Y_dec <= 1;
						i_Yi <= i_Yi - 1;						
					end
					error <= error - {Yi_abs[15:0],1'b0} + 1;
					Yi_abs <= Yi_abs - 16'b1;
				end
				else begin
					if (direct == 1 && i_Xi < 0 && i_Yi >= 0	//SR2
						||direct == 0 && i_Xi < 0 && i_Yi <= 0	//NR3
					) begin	
						X_acc <= 1;
						i_Xi <= i_Xi + 1;
					end
					else begin
						X_dec <= 1;
						i_Xi <= i_Xi + 1;						
					end
					error <= error - {Xi_abs[15:0],1'b0} + 1;
					Xi_abs <= Xi_abs - 16'b1;
				end
			end
			else begin
				if (direct == 0 && i_Xi > 0 && i_Yi >= 0		//NR1
					||direct == 1 && i_Xi < 0 && i_Yi >= 0		//SR2
					||direct == 1 && i_Xi > 0 && i_Yi <= 0		//NR4
					||direct == 0 && i_Xi < 0 && i_Yi <= 0		//SR3
				) begin
					if (direct == 0 && i_Xi > 0 && i_Yi >= 0	//NR1
						||direct == 1 && i_Xi < 0 && i_Yi >= 0	//SR2
					) begin
						Y_acc <= 1;
						i_Yi <= i_Yi + 1;
					end						
					else begin
						Y_dec <= 1;
						i_Yi <= i_Yi - 1;
					end
					error <= error - {Yi_abs[15:0],1'b0} + 1;
					Yi_abs <= Yi_abs + 16'b1;
				end
				else begin
					if (direct == 1 && i_Xi >= 0 && i_Yi > 0	//SR1
						||direct == 0 && i_Xi >= 0 && i_Yi < 0	//NR4
					) begin
						X_acc <= 1;
						i_Xi <= i_Xi + 1;
					end
					else begin
						X_dec <= 1;
						i_Xi <= i_Xi - 1;
					end
					error <= error + {Yi_abs[15:0],1'b0} + 1;
					Yi_abs <= Yi_abs + 16'b1;	
				end		
			end
			actH <= HI;			
		end
	end
	else begin
		if (i_Xi == i_Xe && i_Yi == i_Ye) begin
			if (actH)
				draw_overH <= HI;
		end	
		X_acc <= 0;
		Y_acc <= 0;
		X_dec <= 0;
		Y_dec <= 0;	
	end
end	

endmodule
