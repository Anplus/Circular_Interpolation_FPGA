
module d_line_init(//input
			sys_rst_l,
			Xe,
			Ye,
			change_readyH,
			//output
			Xe_abs;
			Ye_abs;
			i_Xe_sign;
			i_Ye_sign;
			r_e;
			steps;
			
);

parameter	r_IDLE 		= 3'b001,
			r_INIT		= 3'b010,
         	r_WORK  	= 3'b011,
			r_0VER		= 3'b100,

reg		[2:0]	state;
reg		[2:0]	next_state



always @ (posedge pulse_clk or negedge sys_rst_l)  //异步复位
	if(sys_rst_l)
		state <= r_IDLE;
	else
		state <= next_state;


always @ (state or start or step) begin
	
		next_state = x;  //要初始化，使得系统复位后能进入正确的状态
		
    case(state)
	
		r_IDLE: begin
			if (start)
				next_state = r_INIT;
			else
				next_state = r_IDLE;	
		end
		
		r_INIT: begin
			next_state = r_WORK;
		
		end
		
		r_WORK: begin
			if (steps <= 1)
				next_state = r_OVER;
			else
				next_state = r_WORK;
		end
		
		r_0VER: begin
				next_state = r_IDLE;	
		end
    endcase
end


always @ (posedge pulse_clk or negedge sys_rst_l) begin

//初始化

	case(next_state)

		r_IDLE: begin
			if (start)
				next_state = r_INIT;
			else
				next_state = r_IDLE;	
		end
		
		r_INIT: begin
			next_state = r_WORK;
		
		end
		
		r_WORK: begin
			if (steps <= 1)
				next_state = r_OVER;
			else
				next_state = r_WORK;
		end
		
		r_0VER: begin
				next_state = r_IDLE;	
		end

	default://default的作用是免除综合工具综合出锁存器。

	endcase

end


endmodule
