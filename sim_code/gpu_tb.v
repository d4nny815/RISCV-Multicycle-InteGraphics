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
// Description: Testbench for VGA
//              
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gpu_tb();
    // Inputs
    reg clk;
    
    // Outputs
    wire hsync, vsync;
    wire [3:0] vgaRed, vgaGreen, vgaBlue;

   GPU my_GPU(
       .clk        (clk),
       .v_we_i     (),
       .v_data_i   (),
       .v_addr_i   (),
       .hsync_o    (hsync),
       .vsync_o    (vsync),
       .vgaRed_o   (vgaRed), 
       .vgaGreen_o (vgaGreen), 
       .vgaBlue_o  (vgaBlue)
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
