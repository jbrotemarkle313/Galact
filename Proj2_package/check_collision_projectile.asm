#this checks if the projectile hit the enemy ship

.include "convenience.asm"
.include "game.asm"
.include "projectile_struct.asm"
.include "info_bar_struct.asm"
.include "enemy_struct.asm"

.globl check_collision_projectile
.data
explosion:	.byte
	1 1 1 1 1
	1 2 2 2 1
	1 2 3 2 1
	1 2 2 2 1 
	1 1 1 1 1

.text

check_collision_projectile:

enter s0

jal check_proj_enemy

leave s0


check_proj_enemy:

#check if the projectile is active, if it is not then there is no collision
enter s0
li s0, 0
move a0, s0
jal proj_get_element
move t1, v0
lw t4, proj_x(t1)
lw t5, proj_y(t1)
#make sure a projectile is active
lw t9, is_active(t1)
beq t9, 0, no_collision

check_proj_enemy_loop:
beq s0, 5, no_collision
move a0, s0
jal get_enemy_element
move t0, v0
#make sure an enemy is active
lw t2, select_active(t0)
beq t2, 0, no_collision
lw t2, enemy_x(t0)
lw t3, enemy_y(t0)

#projectile is one pixel so there is no need to check for left or right x coordinates or top and bottom y coordinates
#if (projectile x < enemy's left-most x) skip
blt t4, t2, skip
#if (enemy's right-most x < projectile x) skip
add t6, t2, 4
blt t6, t4, skip
#if (projectile y > enemy's bottom y) skip
add t6, t3, 4
bgt t5, t6, skip
#if (projectile y < enemy's top y) skip
blt t3, t5, skip
#there was a collision
#the enemy and projectile are both no longer active
#increase score by 5
li t7, 0
sw t7, select_active(t0)
move a0, t7
jal proj_get_element
move t1, v0
li t7, 0
sw t7, is_active(t1)
jal set_final_score
#display and make a sound effect for collision
move a0, t2
move a1, t3
la a2, explosion
jal display_blit_5x5
li v0, 31
li a0, 40
li a1, 750
li a2, 127
li a3, 100
syscall
leave s0


skip:
inc s0
j check_proj_enemy_loop

no_collision:
leave s0
