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
    input clk, // 50MHz
    input [7:0] data,
    output [15:0] addr,
    output Hsync,  
    output Vsync,
    output in_vis,
    output reg [3:0] vgaRed, vgaGreen, vgaBlue
    );  

    wire [7:0] h_pixel;
    wire [7:0] v_pixel;
    vga my_vga (
        .clk        (clk),
        .h_pixel    (h_pixel),
        .in_h_sync  (Hsync),
        .v_pixel    (v_pixel),
        .in_v_sync  (Vsync),
        .in_vis     (in_vis)
    );

    assign addr = {v_pixel, h_pixel} + 32'h0001_0000;  // first addr is in unused mem
    always @ (posedge clk) begin
        if (in_vis) begin
            vgaRed = data[5:4];
            vgaGreen = data[3:2];
            vgaBlue = data[1:0];
        end
        else begin
            vgaRed = 12'h000;
            vgaGreen = 12'h000;
            vgaBlue = 12'h000;
        end
    end


endmodule
