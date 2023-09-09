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
// Description: Dedicated GPU for the VGA
//              Outputs to VGA 800x600 60Hz
//              Display Resolution: 200x150
// 
// Instantiation Template:
//
//    GPU my_GPU(
//        .clk        (),
//        .v_we_i     (),
//        .v_data_i   (),
//        .v_addr_i   (),
//        .hsync_o    (),
//        .vsync_o    (),
//        .vgaRed_o   (), 
//        .vgaGreen_o (), 
//        .vgaBlue_o  ()
//    );
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module GPU(
    input clk,              // 50MHz
    input v_we_i,
    input [7:0] v_data_i,   // TODO: plan to convert this to 12b
    input [15:0] v_addr_i,  // top byte is v, bottom byte is
    // TODO: add output data, using addr in
    output hsync_o,         
    output vsync_o,
    output [3:0] vgaRed_o, 
    output [3:0] vgaGreen_o, 
    output [3:0] vgaBlue_o
    );
    

    // wires
    wire in_disp;
    wire [7:0] pixel_data;
    wire [15:0] pixel_addr;

    // data1 is for reading from memory for VGA
    // data2 is for writing to memory from cpu
    VIDEO_MEMORY my_vram (
        .MEM_CLK   (clk),
        .MEM_RDEN1 (in_disp), 
        .MEM_RDEN2 (1'b0),  // Shouldnt need to read from data2
        .MEM_WE2   (v_we_i),
        .MEM_ADDR1 ((pixel_addr[15:8] * 200 + pixel_addr[7:0]) & {15{in_disp}}),  // maps 16b addr from vga_timing to location in MEM for 200x150
        .MEM_ADDR2 (v_addr_i[15:8] * 200 + v_addr_i[7:0]),  // maps 16b addr from cpu to location in MEM
        .MEM_DIN2  (v_data_i),  
        .MEM_DOUT1 (pixel_data),  // vga_data
        .MEM_DOUT2 ()  // no read
    );

    
    vga_driver my_VGA_driver(
        .clk          (clk),
        .pixel_data_i (pixel_data),
        .pixel_addr_o (pixel_addr),
        .hsync_o      (hsync_o),  
        .vsync_o      (vsync_o),
        .in_disp_o    (in_disp),
        .vgaRed_o     (vgaRed_o), 
        .vgaGreen_o   (vgaGreen_o), 
        .vgaBlue_o    (vgaBlue_o)
    ); 


endmodule
