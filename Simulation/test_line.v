
//逐点比较法直线插补

module test(//input
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
			
parameter	r_IDLE 		= 3'b001,
			r_INIT		= 3'b010,
         	r_WORK  	= 3'b011,
			r_0VER		= 3'b100;

reg		[2:0]		state;
reg		[2:0]		next_state;

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


always @ (posedge pulse_clk or negedge sys_rst_l) begin //异步复位
	if(~sys_rst_l)
		state <= r_IDLE;
	else
		state <= next_state;
end

always @ (state or change_readyH or steps) begin
	
	next_state = X;
		
    case(state)
	
		r_IDLE: begin
			if (change_readyH)
				next_state = r_INIT;
			else
				next_state = r_IDLE;	
		end
		
		r_INIT: begin
			next_state = r_WORK;
		
		end
		
		r_WORK: begin
			if (steps <= 1)
				next_state = r_0VER;
			else
				next_state = r_WORK;
		end
		
		r_0VER: begin
				next_state = r_IDLE;	
		end
    endcase
end


always @ (posedge pulse_clk) begin

	case(state)

		r_IDLE: begin
			draw_overH = LO;	
			X_acc = 0;
			Y_acc = 0;
			X_dec = 0;
			Y_dec = 0;
			error = 0;
			steps = 0;
		end
		
		r_INIT: begin
			r_e = 0;
			
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
		
		r_WORK: begin
			if (pulse_clk) begin
				if (error >= 0) begin
					if (i_Xe_sign > 0) begin
						X_acc = 1;
						X_dec = 0;
						Y_acc = 0;
						Y_dec = 0;	
					end					
					else if (i_Xe_sign < 0) begin
						X_acc = 0;
						X_dec = 1;
						Y_acc = 0;
						Y_dec = 0;
					end
					error = error - Ye_abs;
				end
				else begin
					if (i_Ye_sign > 0) begin
						X_acc = 0;
						X_dec = 0;
						Y_acc = 1;
						Y_dec = 0;
					end
					else if (i_Xe_sign < 0) begin
						X_acc = 0;
						X_dec = 0;
						Y_acc = 0;
						Y_dec = 1;
					end
					error = error + Xe_abs;
				end
				steps = steps - 1;
			end
		end
		
		r_0VER: begin
			draw_overH = HI;
			X_acc = 0;
			X_dec = 0;
			Y_acc = 0;
			Y_dec = 0;	
		end

		default: begin
			draw_overH = X;	
			X_acc = X;
			Y_acc = X;
			X_dec = X;
			Y_dec = X;
			error = X;
			steps = X;
		end
	endcase

end


endmodule