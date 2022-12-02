module gcd_control(
	input      okey_i,
	input	   rst_i,
	input	   clk_i,
	input      xbig_i,
	input      ybig_i,
	input      eq_i,
	output reg sx_o,
	output reg sy_o,
	output reg ssub_o,
	output reg enx_o,
	output reg eny_o,
	output reg enobeb_o
);

localparam 	S0 = 3'd0,
			S1 = 3'd1,
			S2 = 3'd2,
			S3 = 3'd3,
			S4 = 3'd4,
			S5 = 3'd5;
				
reg	[2:0] present_state;
reg	[2:0] next_state = S0;

//State Register
always @(posedge clk_i)
	begin
	    if(rst_i)
		    present_state <= S0;
	    else
		    present_state <= next_state;
	end

//Next State Logic
always @(*)
	begin
		next_state = S0;
		case(present_state)
				
				S0:
					begin
					if(okey_i)
						next_state = S1;			
					end
					
				
				S1:
					begin
						next_state = S2;
					end
					
				
				S2:
					begin
					if(eq_i)
						next_state = S5;
					else if(xbig_i)
						next_state = S3;
					else
						next_state = S4;
					end
					
				
				S3:
					begin
					    next_state = S2;
					end
					
				
				S4:
					begin			
					    next_state = S2;
					end
					
				
				S5:
					begin
					    next_state = S0;
					end
				
			endcase
	end

//Outputs
always @(*)
		begin
			sx_o 	 = 1'b0;
			sy_o 	 = 1'b0;
			enx_o 	 = 1'b0;
			eny_o 	 = 1'b0;
			ssub_o 	 = 1'b0;
			enobeb_o = 1'b0;
			case(present_state)
							
				S1:
					begin
					    enx_o = 1'b1;
					    eny_o = 1'b1;
					end
								
				S3:
					begin
					    enx_o  = 1'b1;
					    sx_o   = 1'b1;
					    ssub_o = 1'b0;
					end
					
				S4:
					begin			
					    eny_o  = 1'b1;
					    sy_o   = 1'b1;
					    ssub_o = 1'b1;
					end
					
				S5:
					begin
					    enobeb_o = 1'b1;
					end
				
				default:
					begin
					    sx_o 	 = 1'b0;
					    sy_o 	 = 1'b0;
					    enx_o 	 = 1'b0;
					    eny_o 	 = 1'b0;
					    ssub_o 	 = 1'b0;
					    enobeb_o = 1'b0;
					end
				
			endcase
			
		end				
		
endmodule


