/*
      -- 1 --
     |       |
     6       2
     |       |
      -- 7 --
     |       |
     5       3
     |       |
      -- 4 --
*/
module ssd_decoder(
    input  [3:0] ssd_i,
	input        rst_i,
	output [6:0] ssd_o
);          

reg [6:0] decoder_out;

assign ssd_o = decoder_out;

always @(*) begin
    if(rst_i) begin
	     //               7654321
	     decoder_out = 7'b1000000;  // idle state
	 end
	 else begin
	     case(ssd_i)
	         //                        7654321
	         4'b0000: decoder_out = 7'b0111111;  //decimal: 0
			 4'b0001: decoder_out = 7'b0000110;  //decimal: 1
			 4'b0010: decoder_out = 7'b1011011;  //decimal: 2
			 4'b0011: decoder_out = 7'b1001111;  //decimal: 3
			 4'b0100: decoder_out = 7'b1100110;  //decimal: 4
			 4'b0101: decoder_out = 7'b1101101;  //decimal: 5
			 4'b0110: decoder_out = 7'b1111100;  //decimal: 6
			 4'b0111: decoder_out = 7'b0000111;  //decimal: 7
			 4'b1000: decoder_out = 7'b1111111;  //decimal: 8
			 4'b1001: decoder_out = 7'b1100111;  //decimal: 9
			 4'b1010: decoder_out = 7'b1110111;  //decimal: 10 (hex:A)
			 4'b1011: decoder_out = 7'b1111100;  //decimal: 11 (hex:B)
			 4'b1100: decoder_out = 7'b1011000;  //decimal: 12 (hex:C)
			 4'b1101: decoder_out = 7'b1011110;  //decimal: 13 (hex:D)
			 4'b1110: decoder_out = 7'b1111001;  //decimal: 14 (hex:E)
			 4'b1111: decoder_out = 7'b1110001;  //decimal: 15 (hex:F)
			 default: decoder_out = 7'b1000000;
		 endcase
	 end
end
endmodule
