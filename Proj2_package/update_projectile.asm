#moves the projectile up

.include "convenience.asm"
.include "game.asm"
.include "projectile_struct.asm"

.data 
# This function needs to be called by other files, so it needs to be global
.globl update_projectile

.text

update_projectile:
	enter s0, s1, s2
	move s0, a0
	jal continue
	
	done_updating:
	leave s2, s1, s0
	
	do_not_update:
	li t1, 0
	sw t1, is_active(t0)
	j done_updating
	
	continue:
	li s1, 0
	move a0, s1
	jal proj_get_element
	move t0, v0 
	lw s2, is_active(t0)
	beq s2, 0, do_not_update
	lw s2, proj_y(t0)
	sub s2,  s2, 2
	blt s2, 0, do_not_update
	sw s2, proj_y(t0)
	j done_updating
	
