#checks for user input to move the ship and create projectiles
.include "convenience.asm"
.include "game.asm"
.include "ship_struct.asm"
.include "projectile_struct.asm"
.include "info_bar_struct.asm"

.data 

pressed: .word 0

.globl update_ship

.text
update_ship:
	enter s0
	move s0, a0
	jal find_selected
	move t8, v0 
	 
	lw t0, left_pressed
	lw t5, right_pressed
	lw t2, up_pressed
	lw t3, down_pressed
	lw t4, action_pressed
	
	
	
	lw t6, ship_x(t8)
	lw t7, ship_y(t8)
	lw t9, ship_selected(t8)
	
	
	beq t0, 1, left_true
	beq t5, 1, right_true
	beq t2, 1, up_true
	beq t3, 1, down_true
	
	
	left_true:
	sub t6, t6, t0
	blt t6, 0, action_pressed_true
	sw t6, ship_x(t8)
	j action_pressed_true
	
	right_true:
	add t6, t6, t5
	bge t6, 60, action_pressed_true
	sw t6, ship_x(t8)
	j action_pressed_true
	
	up_true:
	sub t7, t7, t2
	blt t7, 0, action_pressed_true
	sw t7, ship_y(t8)	
	j action_pressed_true
	
	down_true:
	add t7, t7, t3
	bge t7, 53, action_pressed_true
	sw t7, ship_y(t8)
	j action_pressed_true
	
	action_pressed_true:
	move a0, s0
	beq t4, 1, create_projectile
	leave s0
	
	create_projectile:
	move a0, s0
	jal proj_get_element
	move t9, v0
	
	lw t5, is_active(t9)
	beq t5, 1, end
	
	jal set_proj_left
	
	
	li t5, 1
	sw t5, is_active(t9)
	
	dec t7
	add t6, t6, 2

	sw t6, proj_x(t9)
	
	sw t7, proj_y(t9)
	
	li v0, 31
	li a0, 60
	li a1, 500
	li a2, 127
	li a3, 100
	syscall
	
	end:
	leave s0
	
	find_selected: 
	enter s0, s1
	li a0, 0
	jal ship_get_element
	move s1, v0 #address 0
	li s0, 0 #counter
	move a0, s0
	jal ship_get_element
	move t0, v0 
	lw t1, ship_selected(t0)
		
	beq t1, 1, found
	beq t1, 0, none_found
	
	
	found: 
	move v0, t0
	leave s0, s1
	
	none_found:
	move v0, s1
	leave s0, s1
	

