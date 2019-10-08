#this file spawns an enemy every 57 frames at a random x location
.data 
.include "convenience.asm"
.include "game.asm"
.include "enemy_struct.asm"

.globl spawn_enemy

.text

spawn_enemy:
	enter s0
	move s0, a0
	
	#spawn an enemy every 57 frames
	li t0, 57
	div t1, s0, t0
	mfhi t1
	beq t1, 0, continue
	leave s0
	
	#find an inactive enemy and spawn a new one, if all enemies are active do not spawn any new enemies
	continue:
	jal check_active
	move t8, v0 	
	lw t4, select_active(t8)
	beq t4, 0, spawn
	bne t4, 1, do_not_spawn
	
	do_not_spawn:
	leave s0
	
	spawn:
	li t5, 1
	sw t5, select_active(t8)
	
	li t0, 0
	sw t0, enemy_y(t8)
	
	li v0, 42
	li a0, 0
	li a1, 60
	syscall
	move t0, a0
	
	sw t0, enemy_x(t8)
	
	leave s0
	
	check_active: 
	enter s0, s1
	li a0, 0
	jal get_enemy_element
	move s1, v0 
	li s0, 0 
	
	check_active_loop:
	beq s0, 5, all_active
	move a0, s0
	jal get_enemy_element
	move t0, v0 
	lw t1, select_active(t0)
		
	beq t1, 0, not_active
	inc s0
	j check_active_loop
	
	not_active: 
	move v0, t0
	leave s0, s1
	
	all_active: 
	move v0, s1
	leave s0, s1
	

