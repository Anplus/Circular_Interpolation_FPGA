
module speed_clk(//sync input
				sys_rst_l,
				//clock input
				ms_clk,
				s_clk,
				//data input
				init_speed,
				accelerate,
				change_readyH_all,
				draw_overH,
				//clock output
				pulse_clk
);

parameter	CLK		= 20000;
parameter	FREQ	= CLK / 4;

parameter	IDLE_SPEED = 10;
parameter	MAX_SPEED = 200;

parameter	LO 		= 1'b0,
          	HI		= 1'b1,
 		  	X		= 1'bx;
			
parameter	r_IDLE 		= 3'b001,
			r_INIT		= 3'b010,
         	r_WORK  	= 3'b011;

reg		[2:0]		state;
reg		[2:0]		next_state;

input			sys_rst_l;

input			ms_clk;
input			s_clk;

input	[7:0]	init_speed;
input	[7:0]	accelerate;
input			change_readyH_all;
input			draw_overH;

output			pulse_clk;

reg				pulse_clk;
reg		[7:0]	speed;
reg		[7:0]	r_acc;
reg		[15:0]	r_clk_div;
reg		[15:0]	clk_div;
reg		[15:0]	div_cnt;
reg				pre_s_clk;

always @ (posedge ms_clk or negedge sys_rst_l) begin //异步复位
	if(~sys_rst_l)
		state <= r_IDLE;
	else
		state <= next_state;
end

always @ ( state or change_readyH_all or draw_overH ) begin
	
	next_state = X;
		
    case(state)
	
		r_IDLE: begin
			if ( change_readyH_all )
				next_state = r_INIT;
			else
				next_state = r_IDLE;
		end
		
		r_INIT: begin
			next_state = r_WORK;
		end
		
		r_WORK: begin
			if ( draw_overH )
				next_state = r_IDLE;
			else
				next_state = r_WORK;
		end

    endcase
end

 
always @ (posedge ms_clk) begin

	case(state)

		r_IDLE: begin
			speed = IDLE_SPEED;
		end
		
		r_INIT: begin
			speed = init_speed;
			r_acc = accelerate;
		end
		
		r_WORK: begin
			if ( (!pre_s_clk) && s_clk ) begin 
				speed = speed + r_acc;
				if (speed >= MAX_SPEED)
					speed = MAX_SPEED;
			else
				speed = speed;
			end	
		end
		
		default: begin
			speed = IDLE_SPEED;
		end
	endcase
	
	pre_s_clk <= s_clk; 

end

always @ (speed) begin
	r_clk_div <= FREQ / speed;
end

always @(posedge ms_clk or negedge sys_rst_l)begin
	if (~sys_rst_l) begin
		div_cnt  <= 0;
		pulse_clk <= 0; 
	end 
	else if (div_cnt >= clk_div) begin
		div_cnt  <= 0;
		pulse_clk <= ~pulse_clk;
		clk_div	<=	r_clk_div;
	end 
	else begin
		div_cnt  <= div_cnt + 1;
		pulse_clk <= pulse_clk;
	end
end


endmodule


