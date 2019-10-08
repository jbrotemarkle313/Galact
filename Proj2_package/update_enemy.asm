#moves enemy down and takes one player life if the enemy reaches the bottom

.include "convenience.asm"
.include "game.asm"
.include "enemy_struct.asm"
.include "info_bar_struct.asm"

.data 
# This function needs to be called by other files, so it needs to be global
.globl update_enemy

.text
update_enemy:
	enter s0, s1, s2, s3
	move s0, a0
	
	#move enemy every 7 frames
	li t0, 7
	div t1, s0, t0
	mfhi t1
	beq t1, 0, continue_loop
	leave s2, s1, s0
	
	done_updating:
	leave s3, s2, s1, s0
	
	do_not_update:
	inc s1
	
	continue_loop:
	beq s1, 5, done_updating
	move a0, s1
	jal get_enemy_element
	move t0, v0 
	lw t9, select_active(t0)
	beq t9, 0, do_not_update
	lw s2, enemy_y(t0)
	add s2,  s2, 1
	#if enemy reaches the bottom, decrement a life
	beq s2, 53, dec_life
	sw s2, enemy_y(t0)
	inc s1
	j continue_loop
	
	dec_life:
	li v0, 31
	li a0, 40
	li a1, 650
	li a2, 121
	li a3, 115
	syscall
	li t2, 0
	sw t2, select_active(t0)
	jal set_lives_left
	inc s1
	j continue_loop
	
