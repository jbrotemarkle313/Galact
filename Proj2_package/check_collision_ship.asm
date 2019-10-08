#checks if the ship collided with the enemy

.include "convenience.asm"
.include "game.asm"
.include "ship_struct.asm"
.include "info_bar_struct.asm"
.include "enemy_struct.asm"

.globl check_collision_ship

.text

check_collision_ship:

enter 

jal check_ship_enemy

leave 


check_ship_enemy:
enter s0, s1
li s0, 0
li s1, 0
move a0, s1
jal ship_get_element
move t4, v0
lw t5, ship_x(t4)
lw t6, ship_y(t4)

check_ship_enemy_loop:
beq s0, 5, no_collision
move a0, s0
jal get_enemy_element
move t1, v0
#make sure an enemy is active
lw t0, select_active(t1)
beq t0, 0, no_collision
lw t0, enemy_x(t1)
lw t3, enemy_y(t1)


#if (ship's right-most x < enemy's left-most x) skip
add t9, t5, 4
blt t9, t0, skip
#if (ship's left-most x > enemy's right-most x) skip
add t9, t0, 4
bgt t5, t9, skip
#if (ship's top y > enemy's bottom y) skip
add t9, t3, 4
bgt t6, t9, skip
#if (ship's bottom y < enemy's top y) skip
add t9, t6, 4
blt t9, t3, skip
#there was a collision
#the enemy is no longer active, decrement lives
li t7, 0
sw t7, select_active(t1)
jal set_lives_left
#sound effect for collision
li v0, 31
li a0, 40
li a1, 750
li a2, 127
li a3, 100
syscall	
leave s0, s1


skip:
inc s0
j check_ship_enemy_loop

no_collision:
leave s0, s1
