`timescale 1ns / 1ps
module layout_vga_controller(
    input             i_clk,        // 100 MHz clock
    input             i_rst,        // reset button
    output  reg       vga_hsync,    // VGA horizontal sync
    output  reg       vga_vsync,    // VGA vertical sync
    output  reg [3:0] vga_r,  // 4-bit VGA red
    output  reg [3:0] vga_g,  // 4-bit VGA green
    output  reg [3:0] vga_b   // 4-bit VGA blue
);
    
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
