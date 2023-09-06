#====================
# Routine
#   Move an led from right to left after a certain delay then reset led
#
#====================
init:
    li s0, 0x1100C000   # led addr

    la t0, ISR              # load ISR address into t0
    csrrw zero, mtvec, t0   # set mtvec to ISR address

    li t6, 0x1100D000       # TC CSR port address
    li t5, 0x1100D004       # TC count port address
    li t0, 0xFFFFFF         # blink rate
    sw t0, 0(t5)            # init TC count 
    li t0, 0x01             # init TC CSR
    sw t0, 0(t6)            # no prescale, turn on TC

    li a0, 1                # cur led val
    li a1, 0x8000           # max led pos
    sw s0, 0(a0)            # store led val to leds

unmask:
    li t0, 0x8              # enable interrupts
    csrrs zero, mstatus, t0 # enable interrupts

main:
    j main                  # wait for intr 
#--------------------------------------------------------------
# Interrupt Service Routine
#  desc: move led to left
#--------------------------------------------------------------
ISR:
    slli a0, a0, 1          # move led pos to left
    bne a1, a0, ISR_ret     # return if not max
    li a0, 1                # reset led pos
ISR_ret:
    mret                    # bring it home