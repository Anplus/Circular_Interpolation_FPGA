`timescale 1ns / 1ns
module work_test  ; 
 
  wire   X_acc   ; 
  wire   Y_acc   ; 
  wire   X_dec   ; 
  wire   Y_dec   ; 
  wire   draw_overH   ; 
  reg    pulse_clk   ; 
  reg    sys_rst_l   ; 
  reg    direct   ;
  reg  [15:0] Xs;
  reg  [15:0] Ys;
  reg  [15:0] Xe;
  reg  [15:0] Ye;
  reg   change_readyH   ;
  work  
   DUT  ( 
  	.pulse_clk(pulse_clk),
		.sys_rst_l(sys_rst_l),
		.direct(direct),
		.Xs(Xs),
		.Ys(Ys),
		.Xe(Xe),
		.Ye(Ye),
		.change_readyH(change_readyH),
		// output
		.X_acc(X_acc),
		.Y_acc(Y_acc),
		.X_dec(X_dec),
		.Y_dec(Y_dec),
		.draw_overH(draw_overH)
    );

  initial
  begin
    repeat(100)
    begin
      pulse_clk = 1;
     #50 pulse_clk = 0;
     #50 ;
    end
  end
  initial
  begin
    sys_rst_l = 1;
    #100 sys_rst_l =0;
    #100 sys_rst_l =1;
  end

  initial
  begin
		direct = 1;
		Xs = -10;
		Ys = 0;
		Xe = 10;
		Ye = 0;
  end

  initial
  begin
	   change_readyH = 0;
	   #100 change_readyH = 1;
	   #100 change_readyH = 0;
  end

endmodule
