`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DFX Company
// Engineer: Daniel Gutierrez
// 
// Create Date: 09/07/2023 07:23:05 PM
// Design Name: vga_driver.v
// Module Name: vga_driver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Outputs VGA signals to VGA port
// 
// 
// Instantiation Template: 
// 
//    vga_driver my_VGA_driver(
//        .clk          (),
//        .pixel_data_o (),
//        .pixel_addr_o (),
//        .hsync_o      (),  
//        .vsync_o      (),
//        .in_disp_o    (),
//        .vgaRed_o     (), 
//        .vgaGreen_o   (), 
//        .vgaBlue_o    ()
//    ); 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_driver(
    input clk,      // 50MHz
    input [7:0] pixel_data_i, // using 8-bit color, top nibble is green, bottom nibble is blue. Could be increased to 12 bit color
    output [15:0] pixel_addr_o,
    output hsync_o,  
    output vsync_o,
    output in_disp_o,
    output [3:0] vgaRed_o, 
    output [3:0] vgaGreen_o, 
    output [3:0] vgaBlue_o
    );  

    vga vga_timing (
        .clk          (clk),
        .h_sync_o     (hsync_o),
        .v_sync_o     (vsync_o),
        .in_disp_o    (in_disp_o),
        .pixel_pos_o  (pixel_addr_o)
    );

    assign vgaRed_o = 8'h00;
    assign vgaGreen_o = pixel_data_i[7:4] & 4'hF;
    assign vgaBlue_o = pixel_data_i[3:0] & 4'hF;
endmodule
