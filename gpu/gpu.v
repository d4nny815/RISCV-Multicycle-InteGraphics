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
    //    .clk         (),
    //    .vram_we_i   (),
    //    .vram_re_i   (), 
    //    .vram_data_i (),
    //    .vram_addr_i (),
    //    .vram_data_o ()
    //    .hsync_o     (),
    //    .vsync_o     (),
    //    .vgaRed_o    (), 
    //    .vgaGreen_o  (), 
    //    .vgaBlue_o   ()
//    );
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module GPU(
    input clk,              
    input vram_we_i,
    input vram_re_i,
    input [11:0] vram_data_i,
    input [15:0] vram_addr_i,  // top byte is v, bottom byte is h
    output [11:0] vram_data_o, 
    output hsync_o,          
    output vsync_o, 
    output [3:0] vgaRed_o, 
    output [3:0] vgaGreen_o,  
    output [3:0] vgaBlue_o
    );
    

    // wires
    wire in_disp;
    wire [11:0] pixel_data;
    wire [15:0] pixel_addr;
    wire [14:0] vram_read_addr, vram_write_addr;

    VIDEO_MEMORY my_vram (
        .MEM_CLK   (clk),
        .MEM_RDEN1 (in_disp), 
        .MEM_RDEN2 (vram_re_i),  
        .MEM_WE2   (vram_we_i),
        .MEM_ADDR1 (vram_read_addr),  
        .MEM_ADDR2 (vram_write_addr), 
        .MEM_DIN2  (vram_data_i),  
        .MEM_DOUT1 (pixel_data),  
        .MEM_DOUT2 (vram_data_o)  
    );

    assign vram_read_addr = (pixel_addr[15:8] * 200 + pixel_addr[7:0]) & {15{in_disp}};
    assign vram_write_addr = vram_addr_i[15:8] * 200 + vram_addr_i[7:0];

    vga_timing my_VGA_timing(
        .clk            (clk),        
        .h_sync_o       (hsync_o),    
        .v_sync_o       (vsync_o),    
        .in_disp_o      (in_disp),
        .pixel_addr_o   (pixel_addr)
    );

    assign vgaRed_o = pixel_data[11:8] & {4{in_disp}};
    assign vgaGreen_o = pixel_data[7:4] & {4{in_disp}};
    assign vgaBlue_o = pixel_data[3:0] & {{4{in_disp}}};


endmodule
