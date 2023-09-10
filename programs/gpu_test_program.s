.text
init:
    li s0, 0x1100C010               # 12b(data), 16b(v_pixel, h_pixel)
    li s1, 0x1100C00C               # GPU_ADDR_IN addr.  have to output addr to GPU first
    li s2, 0x11008000               # GPU_DATA_IN addr.  load pixel data in from GPU
    li s3, 0x11008004               # btn addr

    li s10, 150                     # display height
    li s9, 200                      # display width


setup_intr_tc:
    # INIT interrupts
    la t0, ISR                      # load ISR address into t0
    csrrw zero, mtvec, t0           # set mtvec to ISR address
    li a7, 0                        # clear intr flag

    li t6, 0x1100D000               # TC CSR port address
    li t5, 0x1100D004               # TC count port address
    # INIT TCs
    li t0, 50000000                 # blink rate, 1Hz
    sw t0, 0(t5)                    # init TC count
    li t0, 0x01                     # init TC CSR
    sw t0, 0(t6)                    # no prescale, turn on TC

unmask:
    li t0, 0x8                      # enable interrupts
    csrrs zero, mstatus, t0         # enable interrupts

btn_press:
    beq a7, zero, btn_press


work:
    li a6, 0                        # v_pixel
v_loop:
    li a5, 0                        # h_pixel
h_loop:
    call get_addr                   # calculate pixel addr
    sw a1, 0(s1)                    # put addr into GPU VRAM
    lh a0, 0(s2)                    # get pixel data from GPU VRAM
    call invert_pixel               # pixel transformation
    call output_pixel               # store pixel data in GPU VRAM

h_loop_admin:
    addi a5, a5, 1                  # increment h_addr
    bne a5, s9, h_loop              # continue h_loop unless at max h_addr
v_loop_admin:
    addi a6, a6, 1                  # increment v_addr
    bne a6, s10, v_loop

    li a7, 0                        # clear interrupt flag
    j unmask


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
    ret   

# =================================
#   Program: 
#   Desription: 
#   PARAMS: 
#           
#   RETURN:
#           
# =================================
invert_pixel:
    li t0, 0xFFF                    # pixel is 12 bits
    and a0, a0, t0                  # get bottom 12 bits
    xor a0, a0, t0                  # invert every bit
    ret

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