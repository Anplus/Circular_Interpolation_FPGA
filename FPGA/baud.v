
// 波特率发生器

module baud(
			sys_clk,
			sys_rst_l,
		
			baud_clk				
		);

parameter	XTAL_CLK = 20000000;
parameter	BAUD = 9600;
parameter	CLK_DIV = XTAL_CLK / (BAUD * 16 * 2);
parameter	CW = 9;		// CW >= log2(CLK_DIV)

input 			sys_clk;
input			sys_rst_l;
output			baud_clk;

reg		[CW-1:0]	clk_div;
reg				baud_clk;

//
// 时钟分频
//

always @(posedge sys_clk or negedge sys_rst_l)
	if (~sys_rst_l) begin
		clk_div  <= 0;
		baud_clk <= 0; 
	end 
	else if (clk_div == CLK_DIV) begin
		clk_div  <= 0;
		baud_clk <= ~baud_clk;
	end 
	else begin
		clk_div  <= clk_div + 1;
		baud_clk <= baud_clk;
	end
endmodule
