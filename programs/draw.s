	.file	"draw.c"
	.option nopic
	.attribute arch, "rv32i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	GPU_WRITE_DATA_ADDR
	.section	.sdata,"aw"
	.align	2
	.type	GPU_WRITE_DATA_ADDR, @object
	.size	GPU_WRITE_DATA_ADDR, 4
GPU_WRITE_DATA_ADDR:
	.word	285261836
	.text
	.align	2
	.globl	get_addr
	.type	get_addr, @function
get_addr:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a5,-24(s0)
	slli	a4,a5,8
	lw	a5,-20(s0)
	or	a5,a4,a5
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	get_addr, .-get_addr
	.align	2
	.globl	output_pixel
	.type	output_pixel, @function
output_pixel:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-36(s0)
	slli	a5,a5,16
	lw	a4,-40(s0)
	or	a5,a4,a5
	sw	a5,-20(s0)
	lui	a5,%hi(GPU_WRITE_DATA_ADDR)
	lw	a5,%lo(GPU_WRITE_DATA_ADDR)(a5)
	lw	a4,-20(s0)
	sw	a4,0(a5)
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	output_pixel, .-output_pixel
	.align	2
	.globl	draw_horizontal_line
	.type	draw_horizontal_line, @function
draw_horizontal_line:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	j	.L6
.L7:
	lw	a1,-44(s0)
	lw	a0,-20(s0)
	call	get_addr
	sw	a0,-24(s0)
	lw	a1,-24(s0)
	li	a0,0
	call	output_pixel
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L6:
	lw	a4,-20(s0)
	lw	a5,-40(s0)
	blt	a4,a5,.L7
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	draw_horizontal_line, .-draw_horizontal_line
	.align	2
	.globl	draw_vertical_line
	.type	draw_vertical_line, @function
draw_vertical_line:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	j	.L10
.L11:
	lw	a1,-20(s0)
	lw	a0,-44(s0)
	call	get_addr
	sw	a0,-24(s0)
	lw	a1,-24(s0)
	li	a0,0
	call	output_pixel
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L10:
	lw	a4,-20(s0)
	lw	a5,-40(s0)
	blt	a4,a5,.L11
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	draw_vertical_line, .-draw_vertical_line
	.align	2
	.globl	draw_rect
	.type	draw_rect, @function
draw_rect:
	addi	sp,sp,-64
	sw	ra,60(sp)
	sw	s0,56(sp)
	addi	s0,sp,64
	sw	a0,-52(s0)
	sw	a1,-56(s0)
	sw	a2,-60(s0)
	lw	a5,-52(s0)
	andi	a5,a5,255
	sw	a5,-20(s0)
	lw	a5,-52(s0)
	srai	a5,a5,8
	andi	a5,a5,255
	sw	a5,-24(s0)
	lw	a4,-20(s0)
	lw	a5,-56(s0)
	add	a5,a4,a5
	sw	a5,-28(s0)
	lw	a2,-24(s0)
	lw	a1,-28(s0)
	lw	a0,-20(s0)
	call	draw_horizontal_line
	lw	a5,-28(s0)
	sw	a5,-20(s0)
	lw	a4,-24(s0)
	lw	a5,-60(s0)
	add	a5,a4,a5
	sw	a5,-32(s0)
	lw	a2,-20(s0)
	lw	a1,-32(s0)
	lw	a0,-24(s0)
	call	draw_vertical_line
	lw	a5,-32(s0)
	sw	a5,-24(s0)
	lw	a4,-20(s0)
	lw	a5,-56(s0)
	sub	a5,a4,a5
	sw	a5,-36(s0)
	lw	a2,-24(s0)
	lw	a1,-20(s0)
	lw	a0,-36(s0)
	call	draw_horizontal_line
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	lw	a4,-24(s0)
	lw	a5,-60(s0)
	sub	a5,a4,a5
	sw	a5,-40(s0)
	lw	a2,-20(s0)
	lw	a1,-24(s0)
	lw	a0,-40(s0)
	call	draw_vertical_line
	nop
	lw	ra,60(sp)
	lw	s0,56(sp)
	addi	sp,sp,64
	jr	ra
	.size	draw_rect, .-draw_rect
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,16384
	addi	a5,a5,-241
	sw	a5,-20(s0)
	li	a5,30
	sw	a5,-24(s0)
	li	a5,30
	sw	a5,-28(s0)
	lw	a2,-28(s0)
	lw	a1,-24(s0)
	lw	a0,-20(s0)
	call	draw_rect
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (g2ee5e430018) 12.2.0"
