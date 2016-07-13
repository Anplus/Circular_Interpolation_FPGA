
module u_change (// system connections
				sys_rst_l,
				sys_clk,

				// data input
				rec_dataH,
				
				// sync input
				rec_readyH,
				
				// data output
				shape,		//1bit
				method,		//2bits
				Xs,			//2Bytes
				Ys,			//2Bytes
				Xe,			//2Bytes
				Ye,			//2Bytes
				direct,		//1bit
				max_speed,	//1Byte
				accelerate,	//1Byte
				
				// sync output
				change_readyH

				);

parameter	TOTAL_BYTES = 13;

parameter	LO 		= 1'b0,
          	HI		= 1'b1;	

input			sys_clk;
input			sys_rst_l;	// async reset

input	[7:0]	rec_dataH;	// parallel received data
input			rec_readyH;	// when high,read a byte of new data

output			shape;
output	[1:0]	method;
output	[15:0] 	Xs;
output	[15:0] 	Ys;
output	[15:0] 	Xe;
output	[15:0] 	Ye;
output			direct;
output 	[7:0] 	max_speed;
output 	[7:0] 	accelerate;

output			change_readyH;


reg 	[7:0] 	rec_byte[TOTAL_BYTES-1:0];
reg 	[3:0] 	count;

reg				r_change_readyH;
reg				pre_rec_readyH;
//
//
//

assign	shape = rec_byte[0][0];
assign	method = rec_byte[1][1:0];
assign	Xs = {rec_byte[3],rec_byte[2]};
assign	Ys = {rec_byte[5],rec_byte[4]};
assign	Xe = {rec_byte[7],rec_byte[6]};
assign	Ye = {rec_byte[9],rec_byte[8]};
assign	direct = rec_byte[10][0];
assign	max_speed = rec_byte[11];
assign	accelerate = rec_byte[12];


/*
always @(posedge rec_readyH or negedge sys_rst_l )begin
	if(~sys_rst_l)begin
		count <= 0;
		change_readyH <= LO;
	end
	else begin
		if(count == (TOTAL_BYTES-1) )begin
			rec_byte[count] <= rec_dataH;			
			count <= 0;
			change_readyH <= HI;
		end
		else begin
			rec_byte[count] <= rec_dataH;
			count <= count + 1;
			change_readyH <= LO;
		end
	end
end
*/
assign change_readyH = r_change_readyH;

always @(posedge sys_clk or negedge sys_rst_l )begin
	if(~sys_rst_l)begin
		count <= 0;
		rec_byte[0] <= 0;rec_byte[1] <= 0;rec_byte[2] <= 0;rec_byte[3] <= 0;
		rec_byte[4] <= 0;rec_byte[5] <= 0;rec_byte[6] <= 0;rec_byte[7] <= 0;
		rec_byte[8] <= 0;rec_byte[9] <= 0;rec_byte[10] <= 0;rec_byte[11] <= 0;
		rec_byte[12] <= 0;	
		pre_rec_readyH <= LO;
		r_change_readyH <= LO;
	end
	else begin
		if((~pre_rec_readyH)&& rec_readyH ) begin
			if(count == 12)begin
				count <= 0;
				r_change_readyH <= HI;	
			end
			else begin
				count <= count + 4'b0001;
				r_change_readyH <= LO;
			end
		rec_byte[count] <= rec_dataH;
		end	
		pre_rec_readyH <= rec_readyH;
	end
end


endmodule

