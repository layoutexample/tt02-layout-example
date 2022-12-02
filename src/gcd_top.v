module gcd_top #(parameter DATA_BITS_TOP = 4)(
	input 			            okey_i,
	input			            rst_i,
	input			            clk_i,
	input 	[DATA_BITS_TOP-1:0]	x_i,
	input 	[DATA_BITS_TOP-1:0]	y_i,
	output	[DATA_BITS_TOP-1:0] result_o
);
	
wire w_sx;
wire w_sy;
wire w_ssub;
wire w_enx;
wire w_eny;
wire w_enobeb;
wire w_xbig;
wire w_ybig;
wire w_eq;

//Datapath Instantiation: 
gcd_datapath #(.DATA_BITS(DATA_BITS_TOP)) data(
                                               .x_i      (x_i),
                                               .y_i      (y_i),
                                               .sx_i     (w_sx),
                                               .sy_i     (w_sy),
                                               .ssub_i   (w_ssub),
                                               .enx_i    (w_enx),
                                               .eny_i    (w_eny),
                                               .enobeb_i (w_enobeb),
                                               .clk_i    (clk_i),
                                               .obeb_o   (result_o),
                                               .xbig_o   (w_xbig),
                                               .ybig_o   (w_ybig),
                                               .eq_o     (w_eq)
                                               );
//Control Unit Instantiation:                                                
gcd_control control(
			        .okey_i   (okey_i),
			        .rst_i    (rst_i),
			        .xbig_i   (w_xbig),
			        .ybig_i   (w_ybig),
			        .eq_i     (w_eq),
			        .clk_i    (clk_i),
			        .sx_o     (w_sx),
			        .sy_o     (w_sy),
			        .ssub_o   (w_ssub),
			        .enx_o    (w_enx),
			        .eny_o    (w_eny),
			        .enobeb_o (w_enobeb)	
	                );
	                
endmodule

