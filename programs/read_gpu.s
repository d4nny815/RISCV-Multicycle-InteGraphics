.text
init:
    li sp, 0xFFFC                   # init sp
    li s1, 0x1100C00C               # GPU_ADDR_IN addr.  have to output addr to GPU first
    li s2, 0x11008000               # GPU_DATA_IN addr.  load pixel data in from GPU

    li s3, 0xFFF                    # test
    li s4, 0                        # accum

    li s11, 200
    li s10, 150

    li a6, 0                        # v_pixel
v_loop:
    li a5, 0                        # h_pixel
h_loop:
    call get_addr                   # calculate pixel addr
    sw a1, 0(s1)                    # put addr into GPU VRAM
    lh a0, 0(s2)                    # get pixel data from GPU VRAM
    li t0, 0xFFF                    # pixel is 12 bits
    and a0, a0, t0                  # get bottom 12 bits

    addi sp, sp, -4                 # allocate space for half word
    sh a0, 0(sp)                    # place pixel data on stack

    addi s4, s4, 1
    beq s4, s3, loop


h_loop_admin:
    addi a5, a5, 1                  # increment h_addr
    bne a5, s11, h_loop             # continue h_loop unless at max h_addr
v_loop_admin:
    addi a6, a6, 1                  # increment v_addr
    bne a6, s10, v_loop


loop: j loop                       # FINISH LINE


# =================================
#   Program: get_addr
#   Desription: calculates 16 bit addr from v_pixel and h_pixel values
#   PARAMS: 
#           a6 - current v_pixel
#           a6 - current h_pixel
#   RETURN:
#           a1 - 16 bit addr
# =================================
get_addr:
    li a1, 0                        # clear addr reg
    slli a1, a6, 8                  # top byte is v_pixel
    or a1, a1, a5                   # bottom byte is h_pixel
    ret                             # getting there
