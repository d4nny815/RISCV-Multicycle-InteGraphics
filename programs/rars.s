.text
init:
    li sp, 0xFFFC                   # set stack pointer
    li s0, 0x1100C010               # 12b(data), 16b(v_pixel, h_pixel)
    li s1, 0x1100C00C               # GPU_ADDR_IN addr.  have to output addr to GPU first
    li s2, 0x11008000               # GPU_DATA_IN addr.  load pixel data in from GPU

setup_intr_tc:
    # INIT interrupts
    la t0, ISR                      # load ISR address into t0
    csrrw zero, mtvec, t0           # set mtvec to ISR address
    li a7, 0                        # clear intr flag

# Main program goes here
    li a7, 1
unmask:
    li t0, 0x8                      # enable interrupts
    csrrs zero, mstatus, t0         # enable interrupts

btn_press:
    beq a7, zero, btn_press
work:
    
    li a6, 0x3f
    li a5, 0xf
    call get_addr
    mv a6, a1
    li a5, 0x3f
    li a4, 0x7
    call draw_rect    

    li a7, 0                        # clear interrupt flag
    j unmask

# =================================
#   Program: draw_rect
#   Desription: 
#   PARAMS: 
#            a6 - start_pt, y value << 8 | x value
#            a5 - length
#            a4 - width
#   RETURN:
#            void
# =================================
draw_rect:
    addi sp, sp, -20                # allocate space for 5 registers
    sw ra, 0(sp)                    # save return address
    sw a4, 4(sp)                    # save width
    sw a5, 8(sp)                    # save length
    sw a2, 12(sp)                   # save a2
    sw a3, 16(sp)                   # save a3

    andi a2, a6, 0xFF               # a2 = cur_x value
    srli a3, a6, 8                  # a3 = cur_y value
h1:
    add a4, a2, a4                  # end_x = x + width
    mv a6, a3                       # a6 = y value
    mv a5, a2                       # a5 = x value

    mv a2, a4                       # a2 = end_x
    # at top left corner
    call draw__horizontal_line      # draw top line
v1:
    lw t0, 8(sp)                    # restore length
    add a4, a3, t0                  # end_y = y + length
    mv a6, a2                       # a6 = x value
    mv a5, a3                       # a5 = y value
    mv a3, a4                       # a3 = end_y
    # at top right corner
    call draw__vertical_line        # draw left line
h2:
    lw t0, 4(sp)                    # restore width    
    sub a5, a2, t0                  # start_x = x - width
    mv a6, a3                       # a6 = y value
    mv a4, a2                       # a4 = end_x
    mv a2, a5                       # a3 = start_x
    # at bottom right corner
    call draw__horizontal_line      # draw bottom line
v2:
    lw t0, 8(sp)                    # restore length
    sub a5, a3, t0                  # start_y = y - length
    mv a6, a2                       # a6 = x value
    mv a4, a3                       # a4 = end_y

    # at bottom left corner
    call draw__vertical_line        # draw right line
draw_rect_restore:
    lw a3, 16(sp)                   # restore a3
    lw a2, 12(sp)                   # restore a2
    lw a4, 4(sp)                    # restore width
    lw a5, 8(sp)                    # restore length
    lw ra, 0(sp)                    # restore return address
    addi sp, sp, 12                 # restore stack pointer
    ret


# =================================
#   Program: draw_h_line 
#   Desription: draw a horizontal line from start_x to end_x at y value. SAVE/RESTORE a5
#   PARAMS: 
#            a6 - y value
#            a5 - start x value
#            a4 - end x value
#   RETURN:
#            void
# =================================
draw__horizontal_line:
draw_HLine_save:
    addi sp, sp, -8                  # allocate space for 2 registers
    sw ra, 0(sp)                     # save return address
    sw a5, 4(sp)                     # save a5

for_loop_hline:
    call get_addr                   # get addr from v_pixel and h_pixel
    li a0, 0x0000                   # set pixel data, black
    call output_pixel               # output pixel to GPU
for_loop_hline_admin:
    addi a5, a5, 1                  # x = start_x + x
    bne a5, a4, for_loop_hline      # if x != x_length, loop
draw_HLine_restore:
    lw a5, 4(sp)                    # restore a5
    lw ra, 0(sp)                    # restore return address
    addi sp, sp, 8                  # restore stack pointer
    ret

# =================================
#   Program: draw_v_line 
#   Desription: draw a vertical line from start_y to end_y at x value.
#   PARAMS: 
#            a6 - x value
#            a5 - start y value
#            a4 - end y value
#   RETURN:
#            void
# =================================
draw__vertical_line:
draw_VLine_save:
    addi sp, sp, -12                # allocate space for 3 registers
    sw ra, 0(sp)                    # save return address
    sw a5, 4(sp)                    # save a5
    sw a6, 8(sp)                    # save a6

    mv t6, a5                       # t6 = start_y
    mv a5, a6                       # a5 = x
    mv a6, t6                       # a6 = start_y
for_loop_vline:
    call get_addr                   # get addr from v_pixel and h_pixel
    li a0, 0x0000                   # set pixel data, black
    call output_pixel               # output pixel to GPU
for_loop_vline_admin:
    addi a6, a6, 1                  # x = start_x + x
    bne a6, a4, for_loop_vline      # if x != x_length, loop
draw_VLine_restore:
    lw a6, 8(sp)                    # restore a6
    lw a5, 4(sp)                    # restore a5
    lw ra, 0(sp)                    # restore return address
    addi sp, sp, 12                 # restore stack pointer
    ret


# =================================
#   Program: get_addr
#   Desription: calculates 16 bit addr from v_pixel and h_pixel values
#   PARAMS: 
#           a6 - current v_pixel
#           a5 - current h_pixel
#   RETURN:
#           a1 - 16 bit addr
# =================================
get_addr:
    slli a1, a6, 8                  # top byte is v_pixel
    or a1, a1, a5                   # bottom byte is h_pixel
    ret

# =================================
#   Program: output_pixel
#   Desription: outputs pixel data in a0 to GPU at addr in a1
#   PARAMS: 
#           a0 - pixel data
#           a1 - 16 bit addr           
#   RETURN:
#           void
# =================================
output_pixel:
    slli a0, a0, 16     
    or a0, a0, a1
    sw a0, 0(s0)
    ret

#--------------------------------------------------------------
# Interrupt Service Routine
#  desc: blinks LED
#--------------------------------------------------------------
ISR:
    li a7, 1                    # set interrupt flag
    li t2, 0x80                 # clear MPIE
    csrrc zero, mstatus, t2     # clear MPIE
    mret                        # return from interrupt











