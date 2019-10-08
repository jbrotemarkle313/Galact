#creates the display for the lives and projectiles left

.include "convenience.asm"
.include "game.asm"
.include "info_bar_struct.asm"

.globl info_bar

.data
heart:	.byte	
	1 1 0 1 1
	1 1 1 1 1
	1 1 1 1 1
	0 1 1 1 0
	0 0 1 0 0
	
missile: .byte
	0 1 1 1 0
	0 3 3 3 0
	0 3 3 3 0
	0 3 3 3 0
	0 1 1 1 0
	
	
x:	.byte
	7 0 0 0 7
	0 7 0 7 0
	0 0 7 0 0
	0 7 0 7 0
	7 0 0 0 7
	
cover:	.byte
	0 0 0 0 0
	0 0 0 0 0
	0 0 0 0 0
	0 0 0 0 0
	0 0 0 0 0

.text

info_bar:
enter s0, s1

	jal get_proj_left
	move a2, v0
	li a0, 17
	li a1, 58
	jal display_draw_int	
	beq a2, 0, no_hearts
	
	li a0, 1
	li a1, 58
	la a2, missile
	jal display_blit_5x5
	
	li a0, 9
	li a1, 58
	la a2, x
	jal display_blit_5x5
	
	
	jal get_lives_left
	move s1, v0

	beq s1, 0, no_hearts
	
	li s0, 58
	heart_loop:
	beq s1, 0, done
	la a2, heart
	move a0, s0
	li a1, 58
	jal display_blit_5x5
	sub s1, s1, 1
	sub s0, s0, 8
	j heart_loop

done:
leave s0, s1

#if lives at 0, do not display the last heart
no_hearts:
	la a2, cover
	li a1, 58
	li a0, 58
	jal display_blit_5x5
	j done
	
