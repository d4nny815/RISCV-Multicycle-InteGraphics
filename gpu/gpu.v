`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2023 07:14:08 PM
// Design Name: 
// Module Name: gpu
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


module GPU(
    input clk,
    input v_we_i,
    input [7:0] v_data_i,
    input [14:0] v_addr_i,
    output Hsync,
    output Vsync,
    output [3:0] vgaRed, 
    output [3:0] vgaGreen, 
    output [3:0] vgaBlue
    );
    

    // wires
    wire in_vis;
    wire [7:0] pixel_data;
    wire [15:0] pixel_addr;
    wire [14:0] mapped_pixel_addr;

    // data1 is for reading from memory for VGA
    // data2 is for writing to memory from cpu
    VIDEO_MEMORY my_vram (
        .MEM_CLK   (clk),
        .MEM_RDEN1 (in_vis), 
        .MEM_RDEN2 (1'b0),  // Shouldnt need to read from data2
        .MEM_WE2   (v_we_i),
        .MEM_ADDR1 (mapped_pixel_addr),  // some transformation of pixel_addr
        .MEM_ADDR2 (v_addr_i),
        .MEM_DIN2  (v_data_i),  
        .MEM_DOUT1 (pixel_data),  // vga_data
        .MEM_DOUT2 ()  // no read
    );

    assign mapped_pixel_addr = {pixel_addr[15:8] * 200 + pixel_addr[7:0]};
    vga_driver my_VGA_driver(
        .clk        (clk),
        .pixel_data (pixel_data),
        .pixel_addr (pixel_addr),
        .Hsync      (Hsync),  
        .Vsync      (Vsync),
        .in_vis     (in_vis),
        .vgaRed     (vgaRed), 
        .vgaGreen   (vgaGreen), 
        .vgaBlue    (vgaBlue)
    );  


endmodule
