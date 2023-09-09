.text
init:
    li sp, 0xFFFC               # init stack
    li s0, 0x1100C000           # led addr
    li s1, 0x11008004           # button addr

loop:
    # lb t0, 0(s1)                # read button data
    # beq t0, zero, loop          # wait for button

    call fill_mem
    call read_vram
    j loop


# ====================================
# Registers in use: s0, a0, a1, a2
# Program: Fill 200x150 VRAM with 0xFF
#           Output format:
#               16 bits for addr
#               8 bits for data
#               24 bits = data << 16 | addr
# Params: 
# Return: void
# ====================================    

fill_mem:
fill_vram_save_context:
    addi sp, sp, -16
    sw s0, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)

fill_vram_init:
    li s0, 0x1100C010               # GPU out addr
    li a0, 0                        # data reg
    li a1, 150                      # v_pixels
    li a2, 200                      # h_pixels
    
    li t0, 0                        # init v_addr counter
fill_vram_v_loop:
    li t1, 0                        # init h_addr counter
fill_vram_h_loop:
    li t3, 0xFFF
    addi a0, a0, 1                  # increment data pixel
    and a0, a0, t3              # mod 2^12 - 1

    li t2, 0                        # clear working reg   
    slli t2, a0, 8                  # make room for v_addr
    or t2, t2, t0                   # combine pixel_data and v_pixel_addr
    slli t2, t2, 8                  # make room for h_addr
    or t2, t2, t1                   # combine with h_addr
    sw t2, 0(s0)                    # output data and addr to GPU
fill_vram_h_loop_admin:
    addi t1, t1, 1                  # increment h_addr
    bne t1, a2, fill_vram_h_loop    # continue h_loop unless at max h_addr
fill_vram_v_loop_admin:
    addi t0, t0, 1                  # increment v_addr
    bne t0, a1, fill_vram_v_loop    # continue v_loop unless at max v_addr

fill_vram_restore_context:
    lw s0, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

fill_vram_end:
    ret

read_vram:
read_vram_init:
    li t6, 0x1100C014               # GPU out addr
    li t5, 0x1100C00C               # GPU IN addr
    li a1, 150                      # v_pixels
    li a2, 200                      # h_pixels

    li t0, 0                        # init v_addr counter
read_vram_v_loop:
    li t1, 0                        # init h_addr counter
read_vram_h_loop:
    li t2, 0                        # clear working reg   
    slli t2, t0, 8                  # v_pixel
    or t2, t2, t1                   # h_pixel
    sw t2, 0(t6)                    # output addr to GPU

    lh t2, 0(t5)                    # read data
    li t3, 0xFFF
    and t2, t2, t3                  # get bottom 3 nibbles 


read_vram_h_loop_admin:
    addi t1, t1, 1                  # increment h_addr
    bne t1, a2, read_vram_h_loop    # continue h_loop unless at max h_addr
read_vram_v_loop_admin:
    addi t0, t0, 1                  # increment v_addr
    bne t0, a1, read_vram_v_loop    # continue v_loop unless at max v_addr



