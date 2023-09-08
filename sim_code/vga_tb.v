`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2023 07:08:48 PM
// Design Name: 
// Module Name: vga_tb
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


module vga_tb();
    reg clk;
    
    wire h_sync, v_sync, in_disp;
    wire [7:0] v_pixel, h_pixel;


    vga my_vga (
        .clk          (clk),
        .h_sync_o     (h_sync),
        .v_sync_o     (v_sync),
        .in_disp_o    (in_disp),
        .pixel_pos_o  ({v_pixel, h_pixel})
    );
 
    //- Generate 50MHz clock signal    
    initial begin       
            clk = 1;   //- init signal        
            forever  #10 clk = ~clk;    
        end 

    initial begin
        #1000;
        $finish;
    end
endmodule
