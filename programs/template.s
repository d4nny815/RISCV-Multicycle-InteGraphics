init:
    # SETUP saved registers


setup_intr_tc:
    # INIT interrupts
    la t0, ISR                      # load ISR address into t0
    csrrw zero, mtvec, t0           # set mtvec to ISR address
    li a7, 0                        # clear intr flag
    # INIT TC
    li t6, 0x1100D000               # TC CSR port address
    li t5, 0x1100D004               # TC count port address
    li t0, 50000000                 # blink rate, 1Hz
    sw t0, 0(t5)                    # init TC count
    li t0, 0x01                     # init TC CSR
    sw t0, 0(t6)                    # no prescale, turn on TC