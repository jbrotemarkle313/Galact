.include "convenience.asm"
.include "game.asm"
.include "ship_struct.asm"

.globl view_ship

.data


player:	.byte
	0 0 2 0 0 
	0 2 4 2 0
	2 4 4 4 2
	2 2 2 2 2 
	2 0 1 0 2

.text

enter

jal view_ship

leave

view_ship:

	enter
	# Your code goes in here
	jal check_ship
	
	leave
		
	check_ship:
	enter s0, s1, s2, s3, s4, s5
	
	li s4, 0 #iterative value
	move a0, s4 
	jal ship_get_element
	move t0, v0 #move address into t0
	lw s0, (t0) #load x
	add s1,  t0, ship_y #get to address of y
	lw s2, (s1) #load y
	add s3, t0, ship_selected #get to address of selected
	lw s5, (s3) #load selected

	move a0, s0
	move a1, s2
	la a2, player
	jal display_blit_5x5
		

	leave s0, s1, s2, s3, s4, s5
