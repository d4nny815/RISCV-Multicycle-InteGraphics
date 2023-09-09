.text
init:
    li s0, 0x1100C010               # GPU_DATA_ADDR_OUT
    li s1, 0x1100C00C               # GPU_ADDR_IN addr.  have to output addr to GPU first
    li s2, 0x11008000               # GPU_DATA_IN addr.  load pixel data in from GPU
    li s3, 0x11008004               # BTN_IN addr

    li s11, 200                     # DISPLAY WIDTH
    li s10, 150                     # DISPLAY HEIGHT

    li a7, 0                        # btn press counter

btn_press_poll:
    lb t0, 0(s3)                    # read btn press
    beq zero, t0, btn_press_poll    # wait for btn

    li a6, 0                        # v_pixel
v_loop:
    li a5, 0                        # h_pixel
h_loop:
    call get_addr                   # calculate pixel addr
    sw a1, 0(s1)                    # put addr into GPU VRAM
    lw a0, 0(s2)                    # get pixel data from GPU VRAM

case0:
    bne zero, a7, case1             # btn_presses == 0
    call incrementing_pixels        # pixel transform
    j output_pixel
case1:
    li t0, 1
    bne t0, a7, default             # btn_presses == 1
    call alternate_pixels           # pixel transform
    j output_pixel
default:
    call invert_pixels              # pixel transform

output_pixel:
    slli a0, a0, 12                 # move data to bit position
    or a0, a0, a1                   # combine data and addr
    sw a0, 0(s0)                    # output data

h_loop_admin:
    addi a5, a5, 1                  # increment h_addr
    bne a5, s11, h_loop             # continue h_loop unless at max h_addr
v_loop_admin:
    addi a6, a6, 1                  # increment v_addr
    bne a6, s10, v_loop             # continue v_loop unless at max v_addr


    addi a7, a7, 1
    j btn_press_poll

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

# =================================
#   Program: incrementing pixels
#   Desription: 
#   PARAMS: 
#           a0 - pixel value
#   RETURN:
#           a0 - transformed pixel value
# =================================
incrementing_pixels:            
    slli t0, a6, 3                  # mult by 8
    slli t1, a6, 6                  # mult by 64
    slli t2, a6, 7                  # mult by 128
    add t0, t0, t1
    add t0, t0, t2                  # mult by 200
    add t0, t0, a5                  # add h offset
    li t1, 0xFFF
    and t0, t0, t1                  # mod by 2^12 - 1
    mv a0, t0                       # move pixel to ret reg
    ret

alternate_pixels:
    li a0, 0xAAA
    ret

invert_pixels:
    li t0, 0xFFF
    xor a0, a0, t0 
    ret










