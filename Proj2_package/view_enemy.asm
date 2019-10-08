.include "convenience.asm"
.include "game.asm"
.include "enemy_struct.asm"

.globl view_enemy

.data
enemy:	.byte
	6 0 0 0 6 
	0 6 5 6 0
	0 5 4 5 0
	0 6 5 6 0
	6 0 0 0 6

.text

enter

jal view_enemy

leave

view_enemy:

	enter
	jal check_pixel
	
	leave
		
	check_pixel:
	enter s0, s1, s2, s3, s4, s5
	li s4, 0
	
	check_pixel_loop:
	beq s4, 5, exit_loop
	move a0, s4
	jal get_enemy_element
	move t0, v0 
	lw s0, (t0) 
	add s1,  t0, enemy_y
	lw s2, (s1) 
	add s3, t0, select_active
	lw s5, (s3) 

	beq s5, 1, print
	beq, s5, 0, skip
	
	print:
	move a0, s0 #move x
	move a1, s2 #move y
	la a2, enemy
	jal display_blit_5x5
	inc s4 #i++
	j check_pixel_loop
	
	skip:
	inc s4
	j check_pixel_loop
	
	exit_loop:
	leave s0, s1, s2, s3, s4, s5
