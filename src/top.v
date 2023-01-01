/*
module blanking_adjustment 
//#(
//    parameter h_active      = 'd1280, // 'd1920     ,
//    parameter h_total       = 'd1650, // 'd2200     ,
//    parameter v_active      = 'd720 , // 'd1080     ,
//    parameter v_total       = 'd750 , // 'd1125    ,
//    parameter H_FRONT_PORCH = 'd110 , //   'd88     ,
//    parameter H_SYNCH       = 'd40  , //   'd44     ,
//    parameter H_BACK_PORCH  = 'd220 , //  'd148     ,
//    parameter V_FRONT_PORCH = 'd5   , //    'd4     ,
//    parameter V_SYNCH       = 'd5   , //    'd5     ,
//    parameter V_BACK_PORCH  = 'd20    //    'd36    ,
//)
( 
    input                     rstn          , 
    input                     clk           , 
    input                     i_mode        ,
    output         reg        lv            , 
    output         reg        fv            , 
    output  [11:0]            pixcnt        ,
    output  [23:0]            data          ,
    output         reg        vsync         ,
    output         reg        hsync         , 
    input   [15:0]            h_active      , //= 'd1280 , // 'd1920  ,
    input   [15:0]            h_total       , //= 'd1650 , // 'd2200  ,
    input   [15:0]            v_active      , //= 'd720  , // 'd1080  ,
    input   [15:0]            v_total       , //= 'd750  , // 'd1125  ,
    input   [15:0]            H_FRONT_PORCH , //= 'd110  , // 'd88    ,
    input   [15:0]            H_SYNCH       , //= 'd40   , // 'd44    ,
    input   [15:0]            H_BACK_PORCH  , //= 'd220  , // 'd148   ,
    input   [15:0]            V_FRONT_PORCH , //= 'd5    , // 'd4     ,
    input   [15:0]            V_SYNCH       , //= 'd5    , // 'd5     ,
    input   [15:0]            V_BACK_PORCH    //= 'd20     // 'd36    ,
); 
 
    
    reg [11:0] linecnt;
    reg [11:0] color_cntr; 
    reg [11:0] pixcnt;
    
    always @(posedge clk or negedge rstn) begin 
       if (!rstn) begin 
          pixcnt    <= 12'd0; 
          linecnt   <= 12'd0;
          lv        <= 1'b0;  
          fv        <= 1'b0;  
          hsync     <= 1'b1;
          vsync     <= 1'b1;         
       end                                   
       else begin 
        pixcnt  <= (pixcnt<h_total-1) ? pixcnt+1 : 0;  
        linecnt <= (linecnt==v_total-1 && pixcnt ==h_total-1)  ? 0         :  
                   (linecnt< v_total-1 && pixcnt ==h_total-1)  ? linecnt+1 : linecnt; 
        lv      <= (pixcnt>= (H_SYNCH+H_BACK_PORCH)) & (pixcnt<(h_active + H_SYNCH + H_BACK_PORCH)) &
                   (linecnt>= (V_SYNCH+V_BACK_PORCH)) & (linecnt<(v_active + V_SYNCH + V_BACK_PORCH));
        hsync   <= (pixcnt < H_SYNCH)? 1'b1:1'b0;
        vsync   <= (linecnt< V_SYNCH)? 1'b1:1'b0;
       end 
    end   
  
   reg vs_r;
   reg [11:0] frm_ctr;
   reg [1:0] rgb_ctr;
   always @(posedge clk or negedge rstn)
      if(!rstn) begin
         color_cntr <= 0;
         vs_r       <= 1'b0;
         frm_ctr    <= 0;
			rgb_ctr    <= 0;
      end
      else begin
         vs_r       <= vsync;
         if(vs_r & (~vsync)) begin
            frm_ctr <= frm_ctr + 1;
			   if(frm_ctr[8:0] == 511) begin
			      rgb_ctr <= (rgb_ctr+1);
			   end
         end
         //color_cntr <= lv ? color_cntr+1 : {frm_ctr[11:4],4'b0000};
         color_cntr <= lv ? color_cntr+1 : {frm_ctr[11:2],2'b00};
       end
            
    //generate
    //    if (mode==1)                            
    //         //assign data = rgb_ctr == 0 ?{color_cntr[7:0],16'd0}: rgb_ctr == 1 ?{8'd0, color_cntr[7:0], 8'd0}: 
    //         //rgb_ctr == 2 ? {16'd0, color_cntr[7:0]}:{color_cntr[7:0], color_cntr[7:0], color_cntr[7:0]};
    //         assign data = {color_cntr[7:0], color_cntr[7:0], color_cntr[7:0]};
    //    else 
    //         assign data =  color_cntr== 0 ? {8'hFF,8'hFF,8'hFF}: color_cntr <240 ? {8'hFF, 8'h00, 8'h00} :
    //      color_cntr<480 ? {8'h00, 8'hFF, 8'h00} : {8'h00, 8'h00, 8'hFF};            
    //endgenerate        
    //assign data = {color_cntr[7:0], color_cntr[7:0], color_cntr[7:0]};
    
    //assign data = color_cntr[7] ? {24{1'b1}}:{24{1'b0}};

    wire [7:0] red, grn, blu;
    wire sel_r, sel_g, sel_b;
    assign sel_r = i_mode ? (frm_ctr[6]): (frm_ctr[6]~^frm_ctr[5]);
    assign sel_g = frm_ctr[5];
    assign sel_b = i_mode ? (frm_ctr[6]~^frm_ctr[5]): frm_ctr[6];
    assign red = {sel_r,sel_r,sel_r,sel_r,sel_r,sel_r,sel_r,sel_r};
    assign grn = {sel_g,sel_g,sel_g,sel_g,sel_g,sel_g,sel_g,sel_g};
    assign blu = {sel_b,sel_b,sel_b,sel_b,sel_b,sel_b,sel_b,sel_b};
    
    assign data = color_cntr[7] ? {24{1'b0}}:{red, grn, blu};
    
endmodule                  
*/

`timescale 1ns / 1ps
module top(
    input             i_clk,        // 100 MHz clock
    input             i_rst,        // reset button
    output  reg       vga_hsync,    // VGA horizontal sync
    output  reg       vga_vsync,    // VGA vertical sync
    output  reg [3:0] vga_r,  // 4-bit VGA red
    output  reg [3:0] vga_g,  // 4-bit VGA green
    output  reg [3:0] vga_b   // 4-bit VGA blue
);
    
// generate pixel clock
/*
wire clk_pix;
clk_wiz_0 clk_wiz(
                  // Clock out ports
                  .clk_out1(clk_pix),   // output clk_out1
                  // Status and control signals
                  .reset(i_rst),       // input reset
                  .locked(1'b1),       // output locked
                  // Clock in ports
                  .clk_in1(i_clk)
                  );      // input clk_in1
*/

    // generate pixel clock
wire clk_pix;
wire clk_pix_locked;
clock_480p clock_pix_inst(
                          .clk_100m       (i_clk),
                          .rst            (!i_rst),  // reset button is active low
                          .clk_pix        (clk_pix),
                          /* verilator lint_off PINCONNECTEMPTY */
                          .clk_pix_5x     (),  // not used for VGA output
                          /* verilator lint_on PINCONNECTEMPTY */
                          .clk_pix_locked (clk_pix_locked)
                          );

// display sync signals and coordinates
localparam CORDW = 10;  // screen coordinate width in bits
wire [CORDW-1:0] sx;
wire [CORDW-1:0] sy;
wire             hsync;
wire             vsync;
wire             de;
simple_480p display_inst (
                          .clk_pix                 (clk_pix),
                          .rst_pix                 (!clk_pix_locked),  // wait for clock lock
                          .sx                      (sx),
                          .sy                      (sy),
                          .hsync                   (hsync),
                          .vsync                   (vsync),
                          .de                      (de)
                          );

// define a square with screen coordinates
reg square;
always @ (*) begin
    square = (sx > 220 && sx < 420) && (sy > 140 && sy < 340);
end

// paint colours: white inside square, blue outside
reg [3:0] paint_r;
reg [3:0] paint_g;
reg [3:0] paint_b;
always @(*) begin
    paint_r = (square) ? 4'hF : 4'h1;
    paint_g = (square) ? 4'hF : 4'h3;
    paint_b = (square) ? 4'hF : 4'h7;
end

// VGA Pmod output
always @(posedge clk_pix) begin
    vga_hsync <= hsync;
    vga_vsync <= vsync;
    if (de) begin
        vga_r <= paint_r;
        vga_g <= paint_g;
        vga_b <= paint_b;
    end else begin  // VGA colour should be black in blanking interval
        vga_r <= 4'h0;
        vga_g <= 4'h0;
        vga_b <= 4'h0;
    end
end

endmodule
