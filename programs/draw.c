int* GPU_WRITE_DATA_ADDR = (int*)0x1100C00C;

int get_addr(int x, int y) {
    return y << 8 | x;
}

void output_pixel(int pixel, int addr){
    int data_n_addr = pixel << 16 | addr;
    *GPU_WRITE_DATA_ADDR = data_n_addr;
    return;
}

void draw_horizontal_line(int start_x, int end_x, int y) {
    for (int i = start_x; i < end_x; i++) {
        int addr = get_addr(i, y);
        output_pixel(0x00000000, addr);
    }
    return;
}

void draw_vertical_line(int start_y, int end_y, int x) {
    for (int i = start_y; i < end_y; i++) {
        int addr = get_addr(x, i);
        output_pixel(0x00000000, addr);
    }
    return;
}

void draw_rect(int start_pt, int length, int width){
    int x = start_pt & 0x000000FF;
    int y = (start_pt & 0x0000FF00) >> 8;

    int end_x = x + length;
    draw_horizontal_line(x, end_x, y);
    x = end_x;
    int end_y = y + width;
    draw_vertical_line(y, end_y, x);
    y = end_y;
    int start_x = x - length;
    draw_horizontal_line(start_x, x, y);
    x = start_x;
    int start_y = y - width;
    draw_vertical_line(start_y, y, x);    
    return;
}

int main() {
    int start_pt = 0x00003f0f;
    int length = 30;
    int width = 30;
    draw_rect(start_pt, length, width);
    return 0;
}

