#====================
# Routine
#   Move an led from right to left after a certain delay then reset led
#
#====================
init:
    li s0, 0x1100C000   # led addr
    li a0, 1            # cur led val
    li a1, 0x8000       # max led pos

    li s1, 0x1100C00C   # vram addr // 0x1100_C00C
    li s2, 0x1100C010   # vram data // 0x1100_C010

fill_vram:
    li t6, 30000        # load vram size
fill_loop:
    li t5, 30000       # addr offset
    sub t5, t6, t5      # calculate vram addr
    neg t5, t5          # negate vram addr
    sw t5, 0(s1)        # store vram addr to vram data
    sw t5, 0(s2)      # store 0 to vram data
loop_admin:
    addi t6, t6, -1     # decrement vram size
    bne zero, t6, fill_loop
    
    sw a0, 0(s0)        # store led val to leds
main:
    slli a0, a0, 1      # move led pos to left
    sw a0, 0(s0)        # save to leds
    call delay          # delay
    bne a1, a0, main    # jump back to main if not at max 
    li a0, 1            # reset led pos
    j main              # go back 

delay:
    li t0, 0x2FFFF      # load delay value
delay_loop:
    addi t0, t0, -1     # decrement delay
    bne zero, t0, delay_loop
    ret
