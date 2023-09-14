#include <stdio.h>
#include <stdint.h>

int32_t gpu_vram[200][150] = {0}; // simulated display

void print_ram(){
    printf("[\n");
    for(int y=0; y<150;y++){
        for(int x=0; x<200;x++){
            printf("%X", gpu_vram[x][y]);
        }
        printf("\n");
    }
    printf("]\n");
}

int32_t calc_addr(int32_t x_pos, int32_t y_pos){
    return (y_pos << 8 | x_pos) & 0xFFFF;
}

void output_pixel(int32_t pixel_data, int32_t vram_addr){
    int32_t x = vram_addr & 0xff;
    int32_t y = (vram_addr >> 8) & 0xff;
    gpu_vram[x][y] = pixel_data;
    return;
}

void draw_Hline(int32_t y_pos, int32_t x_pos, int32_t length){
    for(int i=0; i<=length;i++){
        int32_t addr = calc_addr(x_pos + i, y_pos);
        output_pixel(1, addr);
    }
    return;
}

void draw_Vline(int32_t x_pos, int32_t y_pos, int32_t height){
    for(int i=0; i<=height;i++){
        int32_t addr = calc_addr(x_pos, y_pos + i);
        output_pixel(1, addr);
    }
    return;
}

void draw_rect_outline(int32_t x_pos, int32_t y_pos, int32_t length, int32_t height){
    int32_t cur_x, cur_y, end_x, end_y;
    cur_x = x_pos;
    cur_y = y_pos;
    draw_Hline(cur_y, cur_x, length);
    cur_x = cur_x + length;
    draw_Vline(cur_x, cur_y, height);
    cur_y = cur_y + height;
    cur_x = cur_x - length;
    draw_Hline(cur_y, cur_x, length);
    cur_y = cur_y - height;
    draw_Vline(cur_x, cur_y, height);
    return;
}

void draw_rect(int32_t x_pos, int32_t y_pos, int32_t length, int32_t height){
    for(int i=0;i<=height;i++){
        draw_Hline(y_pos + i, x_pos, length);
    }
    return;
}

void blank_out_screen(){
    for(int y=0; y<150;y++){
        for(int x=0; x<200;x++){
           gpu_vram[x][y] = 0;
        }
        printf("\n");
    }
}


int32_t* BTN_ADDR = (int32_t*)0x11008000;
int main() {
    int8_t btn_presses = 0;
    while(1){
        int8_t btn_press = *BTN_ADDR;
        if (btn_press){
            btn_presses %= 4;
            blank_out_screen();
            switch (btn_presses) {
                case (0):
                    draw_rect_outline(2, 3, 50, 100);
                    break;
                case(1):
                    draw_Hline(100, 50, 5);
                    break;
                case(2):
                    draw_rect(0, 0, 200, 150);
                    break;
                case(3):
                    draw_Vline(200/2, 0, 100);
                    break;
            }
            btn_presses += 1;
        }
    }
    


    // print_ram();

    // test calc_addr
    // int32_t output_addr_top_left = calc_addr(0, 0);
    // int32_t output_addr_top_right = calc_addr(199, 0);
    // int32_t output_addr_bottom_left = calc_addr(0, 149);
    // int32_t output_addr_bottom_right = calc_addr(199, 149);
    // if (output_addr_top_left != 0x0000 | 
    //     output_addr_top_right != 0x00c7 |
    //     output_addr_bottom_left != 0x9500 |
    //     output_addr_bottom_right != 0x95c7) {
    //         printf("FAILED calc_addr1 test, %X\n", output_addr_top_left);
    //         printf("FAILED calc_addr2 test, %X\n", output_addr_top_right);
    //         printf("FAILED calc_addr3 test, %X\n", output_addr_bottom_left);
    //         printf("FAILED calc_addr4 test, %X\n", output_addr_bottom_right);
    //         return 1;
    // }

    // // test output_pixel
    // output_pixel(0xa, calc_addr(0, 0));
    // output_pixel(0xb, calc_addr(199, 0));
    // output_pixel(0xc, calc_addr(0, 149));
    // output_pixel(0xd, calc_addr(199, 149));
    // if (gpu_vram[0][0] != 0xa | 
    //     gpu_vram[199][0] != 0xb |
    //     gpu_vram[0][149] != 0xc |
    //     gpu_vram[199][149]!= 0xd) {
    //     printf("FAILED output_pixel_topleft test, %d\n", gpu_vram[0][0]);
    //     printf("FAILED output_pixel_topright test, %d\n", gpu_vram[199][0]);
    //     printf("FAILED output_pixel_bottomleft test, %d\n", gpu_vram[0][149]);
    //     printf("FAILED output_pixel_bottomright test, %d\n", gpu_vram[199][149]);
    //     return 1;
    // }

    // // testing geometry
    // int32_t x, y, length, height;
    // // test draw horizontal line
    // x = 2;
    // y = 0;
    // length = 20;
    // draw_Hline(y, x, length);
    // if (gpu_vram[2][0] != 1 | 
    //     gpu_vram[22][0] != 1){
    //         printf("FAILED draw horizontal line");
    // }

    // // test draw vertical line
    // x = 4;
    // y = 50;
    // height = 84;
    // draw_Vline(x, y, height);
    // if (gpu_vram[4][50] != 1 | 
    //     gpu_vram[4][134] != 1){
    //         printf("FAILED draw vertical line");
    // }

    // // test draw rect
    // x = 50;
    // y = 45;
    // length = 10;
    // height = 5;
    // draw_rect(x, y, length, height);
    // x += length + 2;
    // draw_rect_outline(x, y, length, height);
    // if (gpu_vram[50][45] != 0x1 |  // top left 
    //     gpu_vram[60][45] != 0x1 |  // top right
    //     gpu_vram[50][45] != 0x1 |  // bottom left 
    //     gpu_vram[60][50] != 0x1)   // bottom right
    //     {
    //         printf("FAILED drawing rect");
    //     }
    print_ram();


    printf("PASSED ALL TESTS\n");
    return 0;
}