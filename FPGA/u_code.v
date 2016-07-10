
module u_code(// sync input
				sys_clk,
				sys_rst_l,
				xmit_doneH,
				
				// data input
				X_acc,
				X_dec,		
				Y_acc,
				Y_dec,
				
				// code output
				xmit_dataH,
				xmitH
			);
parameter	LO 		= 1'b0,
          	HI		= 1'b1,		

input			sys_clk;
input			sys_rst_l;
input			xmit_doneH;

input			X_acc;
input			X_dec;
input			Y_acc;
input			Y_dec;

output	[7:0]	xmit_dataH;
output			xmitH;

reg				r_xmitH;
reg		[7:0]	r_xmit_dataH;

reg				pre_X_acc;
reg				pre_X_dec;
reg				pre_Y_acc;
reg				pre_Y_dec;

assign	xmitH = r_xmitH;
assign	xmit_dataH = r_xmit_dataH;

always @(posedge sys_clk or negedge sys_rst_l)begin
	if(~sys_rst_l)begin
		r_xmit_dataH <= 0;
		r_xmitH <= LO;
	end
	else begin
		if( (!pre_X_acc) && X_acc ) begin
			r_xmit_dataH <= 1;
			r_xmitH <= HI;
		end
		else if( (!pre_X_dec) && X_dec ) begin
			r_xmit_dataH <= 2;
			r_xmitH <= HI;
		end		
		else if( (!pre_Y_acc) && Y_acc ) begin
			r_xmit_dataH <= 3;
			r_xmitH <= HI;
		end		
		else if( (!pre_Y_dec) && Y_dec ) begin
			r_xmit_dataH <= 4;
			r_xmitH <= HI;
		end
		else begin
			r_xmit_dataH <= 0;
			r_xmitH <= LO;
		end		
		pre_X_acc <= X_acc;
		pre_X_dec <= X_acc;
		pre_Y_acc <= Y_acc;
		pre_Y_dec <= X_dec;
	end
end

/*
always @(posedge xmit_doneH or posedge X_acc or posedge X_dec or posedge Y_acc or posedge Y_dec) begin
	if (xmit_doneH) begin
		r_xmit_dataH <= 0;
		r_xmitH <= LO;
	end
	else begin
		if (X_acc) r_xmit_dataH <= 1;
		else if (X_dec) r_xmit_dataH <= 2;
		else if (Y_acc) r_xmit_dataH <= 3;
		else if (Y_dec) r_xmit_dataH <= 4;
		r_xmitH <= HI;
	end
end	
*/

endmodule
