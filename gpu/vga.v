// // instanciate 
// vga my_vga (
//     .clk        (),
//     .h_pixel    (),
//     .in_h_sync  (),
//     .v_pixel    (),
//     .in_v_sync  ()
//     .in_vis     ()
// );
//  

module vga ( 
    input clk,
    output in_h_sync , 
    output [7:0] h_pixel,
    output in_v_sync,
    output [7:0] v_pixel,
    output in_vis
    );

    reg [10:0] h_pixel_800;   
    reg [9:0] v_pixel_600;
    reg v_clk;
    always @(posedge clk)
    begin 
        if (h_pixel_800 != 1039) begin
            h_pixel_800 <= h_pixel_800 + 1;
            v_clk <= 0;
        end
        else begin
            h_pixel_800 <= 0;
            v_clk <= 1;
        end
    end
    assign in_h_sync = ~((h_pixel_800 >= 800 + 56) && (h_pixel_800 < 800 + 56 + 120));

    always @(posedge v_clk)
    begin
        if (v_pixel_600 != 665)
            v_pixel_600 <= v_pixel_600 + 1;
        else
            v_pixel_600 <= 0;
    end
    assign in_v_sync = ~((v_pixel_600 >= 600 + 37) && (v_pixel_600 < 600 + 37 + 6));

    assign in_vis = (h_pixel_800 >= 0) && (h_pixel_800 < 800) && (v_pixel_600 >= 0) && (v_pixel_600 < 600); // visible area
    assign h_pixel = h_pixel_800[9:2];  // mapped to 8 bits
    assign v_pixel = v_pixel_600[9:2];  // mapped to 8 bits
endmodule