.text
init:
    li s10, 0x1100C000           # addr for leds
    li s0, 0x1100D000           # TC CSR port address
    li s1, 0x1100D004           # TC count port address

    # INIT interrupts
    la t0, ISR                  # load ISR address into t0
    csrrw zero, mtvec, t0       # set mtvec to ISR address
    li a7, 0                    # clear intr flag

    # INIT TC
    li t0, 25000000             # blink rate, 2Hz
    sw t0, 0(s1)                # init TC count
    li t0, 0x01                 # init TC CSR
    sw t0, 0(s0)                # no prescale, turn on TC

    li a0, 0                    # LED state

unmask:
    li t0, 0x8                  # enable interrupts
    csrrs zero, mstatus, t0     # enable interrupts

wait:
    beq a7, zero, wait          # wait for interrupt

blink:
    xori a0, a0,  1             # toggle LED
    sw a0, 0(s10)                # output LED    

    li a7, 0                    # clear interrupt flag
    j unmask                    # unmask interrupts


#--------------------------------------------------------------
# Interrupt Service Routine
#  desc: mulitplexes the 7-seg display
#--------------------------------------------------------------
ISR:
    li a7, 1                    # set interrupt flag
    li t2, 0x80                 # clear MPIE
    csrrc zero, mstatus, t2     # clear MPIE
    mret                        # return from interrupt
ISR_ret:
    mret                   # returns with interrupts unmasked