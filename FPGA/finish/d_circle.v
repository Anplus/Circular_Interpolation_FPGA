
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

parameter	r_IDLE 		= 3'b001,
			r_INIT		= 3'b010,
         	r_WORK  	= 3'b011,
			r_JUDGE		= 3'b100,
			r_0VER		= 3'b101;

reg		[2:0]		state;
reg		[2:0]		next_state;
			
input					pulse_clk;
input					sys_rst_l;
input					direct;
input	signed [15:0]	Xs;
input	signed [15:0]	Ys;
input	signed [15:0]	Xe;
input	signed [15:0]	Ye;
input					change_readyH;

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
reg		[30:0]	Xi_abs;		//动点坐标绝对值
reg		[30:0]	Yi_abs;
reg				i_direct;
integer			i_sign;		//保存符号
integer			error;		//偏差

///
always @ (posedge pulse_clk or negedge sys_rst_l) begin //异步复位
	if(~sys_rst_l)
		state <= r_IDLE;
	else
		state <= next_state;
end

always @ (state or change_readyH or i_Xi or i_Yi) begin
	
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
				next_state = r_JUDGE;
		end
		
		r_JUDGE: begin
			if (i_Xi == i_Xe && i_Yi == i_Ye)
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

		r_IDLE: begin//
			draw_overH = LO;	
			X_acc = 0;
			Y_acc = 0;
			X_dec = 0;
			Y_dec = 0;	
			error = 0;
		end
		
		r_INIT: begin	//
			draw_overH = LO;
			i_Xe = Xe;
			i_Ye = Ye;
			i_Xi = Xs;
			i_Yi = Ys;
			i_direct = direct;
			
			if (i_Xi >= 0)
				Xi_abs = i_Xi;
			else
				Xi_abs = -i_Xi;
				
			if (i_Yi >= 0)
				Yi_abs = i_Yi;
			else
				Yi_abs = -i_Yi;
		end
		
		r_WORK: begin
			if (error >= 0) begin
				if (i_direct == 1 && i_Xi >= 0 && i_Yi > 0			//SR1
					||i_direct == 0 && i_Xi <= 0 && i_Yi > 0		//NR2
					||i_direct == 1 && i_Xi <= 0 && i_Yi < 0		//SR3
					||i_direct == 0 && i_Xi >= 0 && i_Yi < 0		//NR4
				) begin
					if (i_direct == 1 && i_Xi <= 0 && i_Yi < 0		//SR3
						||i_direct == 0 && i_Xi >= 0 && i_Yi < 0	//NR4
					) begin
						Y_acc = 1;
						i_Yi = i_Yi + 1;
					end
					else begin										//SR1
						Y_dec = 1;									//NR2
						i_Yi = i_Yi - 1;						
					end
					error = error - {Yi_abs[30:0],1'b0} + 1;
					Yi_abs = Yi_abs - 31'b1;
				end
				else begin
					if (i_direct == 1 && i_Xi < 0 && i_Yi >= 0		//SR2
						||i_direct == 0 && i_Xi < 0 && i_Yi <= 0	//NR3
					) begin	
						X_acc = 1;
						i_Xi = i_Xi + 1;
					end
					else begin										//NR3
						X_dec = 1;									//SR4
						i_Xi = i_Xi - 1;						
					end
					error = error - {Xi_abs[30:0],1'b0} + 1;
					Xi_abs = Xi_abs - 31'b1;
				end
			end
			else begin
				if (i_direct == 0 && i_Xi > 0 && i_Yi >= 0			//NR1
					||i_direct == 1 && i_Xi < 0 && i_Yi >= 0		//SR2
					||i_direct == 1 && i_Xi > 0 && i_Yi <= 0		//SR4
					||i_direct == 0 && i_Xi < 0 && i_Yi <= 0		//NR3
				) begin
					if (i_direct == 0 && i_Xi > 0 && i_Yi >= 0		//NR1
						||i_direct == 1 && i_Xi < 0 && i_Yi >= 0	//SR2
					) begin
						Y_acc = 1;
						i_Yi = i_Yi + 1;
					end						
					else begin										//NR3
						Y_dec = 1;									//SR4
						i_Yi = i_Yi - 1;
					end
					error = error + {Yi_abs[30:0],1'b0} + 1;
					Yi_abs = Yi_abs + 31'b1;
				end
				else begin
					if (i_direct == 1 && i_Xi >= 0 && i_Yi > 0		//SR1
						||i_direct == 0 && i_Xi >= 0 && i_Yi < 0	//NR4
					) begin
						X_acc = 1;
						i_Xi = i_Xi + 1;
					end
					else begin										//NR2
						X_dec = 1;									//SR3
						i_Xi = i_Xi - 1;
					end
					error = error + {Xi_abs[30:0],1'b0} + 1;
					Xi_abs = Xi_abs + 31'b1;	
				end		
			end
		end
		
		r_JUDGE: begin
			X_acc = 0;
			X_dec = 0;
			Y_acc = 0;
			Y_dec = 0;	
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
		end
	endcase

end


endmodule
