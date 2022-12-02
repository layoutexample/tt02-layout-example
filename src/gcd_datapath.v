module gcd_datapath #(parameter DATA_BITS = 4)(
	input	[DATA_BITS-1:0]    x_i,
	input	[DATA_BITS-1:0]    y_i,
    input                      clk_i,
	input                      sx_i,
	input                      sy_i,
	input                      ssub_i,
	input                      enx_i,
	input                      eny_i,
	input                      enobeb_i,
	output reg                 xbig_o,
	output reg                 ybig_o,
	output reg                 eq_o,
	output reg [DATA_BITS-1:0] obeb_o
);

reg [DATA_BITS-1:0] xi;
reg [DATA_BITS-1:0] yi;
reg [DATA_BITS-1:0] to_xi;
reg [DATA_BITS-1:0] to_yi;

reg [DATA_BITS-1:0] sub_res;
reg [DATA_BITS-1:0] to_subA;
reg [DATA_BITS-1:0] to_subB;

//Define Datapath Registers
always @(posedge clk_i)
	begin
		if(enx_i)
			xi <= to_xi;
		if(eny_i)
			yi <= to_yi;
		if(enobeb_i)
			obeb_o <= xi;
	end

//Combinational Datapath	
always @(*)
	begin
		//MUX_SUB
		if(ssub_i)
			begin
			to_subA = yi;
			to_subB = xi;
			end			
		else
			begin			
			to_subA = xi;
			to_subB = yi;
			end
			
		//*******ARITHMETIC COMPONENTS**********
		sub_res 	= to_subA - to_subB; 
		
		//********MUXes**********
		//MUX_XI
		if(sx_i)
			to_xi = sub_res;
		else
			to_xi = x_i;
		
		//MUX_YI
		if(sy_i)
			to_yi = sub_res;
		else
			to_yi = y_i;
		
		//***********OUTPUTS***************
		ybig_o  = sub_res[3];
		
		eq_o    = ~(sub_res[3] | sub_res[2]  | sub_res[1] | sub_res[0]);
		
		xbig_o  = ~(ybig_o | eq_o); 
	end
	
endmodule
