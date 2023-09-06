`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2023 12:51:57 AM
// Design Name: 
// Module Name: gpu_rom
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


module gpu_rom(
    input [15:0] addr,   // address
    output [11:0] data,  // data
    input rd_en         // read enable
    );
 
    reg [11:0] ROM [0:65536];  // ROM definition     

    initial begin
        $readmemh("gpu_rom2.mem", ROM, 0, 65536); // pixel data must be in hex format
    end

   assign data = (rd_en) ? ROM[addr] : 12'h000;
endmodule
