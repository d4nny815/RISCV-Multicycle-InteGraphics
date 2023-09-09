//////////////////////////////////////////////////////////////////////////////////
// Company: DFX Company     <---- TODO Replace with Better Name and elsewhere 
// Engineer: Daniel Gutierrez
// 
// Create Date: 09/07/2023 07:08:48 PM
// Design Name: vga.v
// Module Name: vga
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: VGA Timing for 800x600 @ 72Hz
//              Uses 50MHz clock
// 
// 
// 
// Instantiation Template: 
//
//     vga my_vga (
//         .clk          (),
//         .h_sync_o     (),
//         .v_sync_o     (),
//         .in_disp_o    (),
//         .pixel_pos_o  ()
//     );
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
// // instanciate 

//  

module vga_timing ( 
    input clk,          // 50MHz
    output h_sync_o,    // active low
    output v_sync_o,    // active low
    output in_disp_o,
    output [15:0] pixel_addr_o
    );

    reg [10:0] h_pixel_800;   
    reg [9:0] v_pixel_600;
    reg v_clk;
    always @(posedge clk)
    begin 
        if (h_pixel_800 < 1040 - 1) begin
            h_pixel_800 <= h_pixel_800 + 1;
            v_clk <= 0;
        end
        else begin
            h_pixel_800 <= 0;
            v_clk <= 1;
        end
    end
    assign h_sync_o = ~((h_pixel_800 >= 800 + 56) && (h_pixel_800 < 800 + 56 + 120));

    always @(posedge v_clk)
    begin
        if (v_pixel_600 < 666 - 1)
            v_pixel_600 <= v_pixel_600 + 1;
        else
            v_pixel_600 <= 0;
    end
    assign v_sync_o = ~((v_pixel_600 >= 600 + 37) && (v_pixel_600 < 600 + 37 + 6));

    assign in_disp_o = (h_pixel_800 >= 0) && (h_pixel_800 <= 799) && (v_pixel_600 >= 0) && (v_pixel_600 <= 599);   
    assign pixel_addr_o = {v_pixel_600[9:2], h_pixel_800[9:2]};          // top byte is y, bottom byte is x
endmodule