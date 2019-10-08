# Include the convenience file so that we save some typing! :)
.include "convenience.asm"
# Include the game settings file with the board settings! :)
.include "game.asm"
# We will need to access the pixel model, include the structure offset definitions
.include "projectile_struct.asm"

.globl view_projectile

.text

view_projectile:
	enter
	# Your code goes in here
	jal check_pixel
	
	leave
		
	check_pixel:
	enter s0, s1, s2, s3, s4, s5
	
	li s4, 0 #iterative value
	move a0, s4
	jal proj_get_element
	move t0, v0 #move address into t0
	lw s0, (t0) #load x
	add s1,  t0, proj_y #get to address of y
	lw s2, (s1) #load y
	add s3, t0, is_active#get to address of selected
	lw s5, (s3) #load selected
	
	beq s5, 0, not_active
	beq s5, 1, active
		
	not_active:
	leave s0, s1, s2, s3, s4, s5
	
	active:
	move a0, s0 #move x
	move a1, s2 #move y
	li a2, COLOR_ORANGE
	jal display_set_pixel
	leave s0, s1, s2, s3, s4, s5
	
