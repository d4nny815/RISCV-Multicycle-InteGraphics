`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2023 07:50:05 PM
// Design Name: 
// Module Name: vga_driver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_driver(
    input clk,                      // 50MHz
    input [7:0] pixel_data,
    output [15:0] pixel_addr,
    output Hsync,  
    output Vsync,
    output in_vis,
    output reg [3:0] vgaRed, vgaGreen, vgaBlue
    );  

    wire [7:0] v_pixel, h_pixel; 

    vga my_vga (
        .clk        (clk),
        .h_pixel    (h_pixel),
        .in_h_sync  (Hsync),
        .v_pixel    (v_pixel),
        .in_v_sync  (Vsync),
        .in_vis     (in_vis)
    );

    assign pixel_addr = {v_pixel, h_pixel};

    always @ (posedge clk) begin
        if (in_vis) begin
            vgaRed = 8'h00;
            vgaGreen = pixel_data[3:0];
            vgaBlue = pixel_data[7:4];
        end
        else begin
            vgaRed = 8'h00;
            vgaGreen = 8'h00;
            vgaBlue = 8'h00;
        end
    end


endmodule
