.include "convenience.asm"
.include "game.asm"
.include "ship_struct.asm"
.include "projectile_struct.asm"
.include "info_bar_struct.asm"

#	Defines the number of frames per second: 16ms -> 60fps
.eqv	GAME_TICK_MS		16

.data
# don't get rid of these, they're used by wait_for_next_frame.
last_frame_time: 	.word 0
frame_counter:    	.word 0
welcome_text:		.asciiz "Welcome"
press_text:		.asciiz "Press Any"
key_text:		.asciiz "Key To"
continue_text:		.asciiz "Continue"
galact_text:		.asciiz "to Galact"
gameover_text_game:	.asciiz "Game"
gameover_text_over:	.asciiz "Over"
gameover_text_score:	.asciiz "Score: "


.text
# --------------------------------------------------------------------------------------------------

.globl main

main:
	#enter screen, checks if up, down, left, right, or b was pressed
	#then enters the game
	input_loop:
	la a2, welcome_text
	li a0, 12
	li a1, 5
	jal display_draw_text
	la a2, galact_text
	li a0, 5
	li a1, 15
	jal display_draw_text	
	la a2, press_text
	li a0, 5
	li a1, 30
	jal display_draw_text
	la a2, key_text
	li a0, 10
	li a1, 40
	jal display_draw_text
	la a2, continue_text
	li a0, 10
	li a1, 50
	jal display_draw_text
	jal display_update
	jal input_get_keys
	move t0, v0
	beq t0, 1, continue
	beq t0, 0, input_loop
	
continue:	
	#starts the ship at (30, 53)
	li a0, 0
	jal ship_get_element
	move t1, v0 #address 0
	
	lw t2, ship_x(t1)
	lw t3, ship_y(t1)
	
	add t2, t2, 30
	sw t2, ship_x(t1)
	
	add t3, t3, 53
	sw t3, ship_y(t1)
	

_main_loop:
	jal handle_input
	jal update_ship
	jal view_ship
	jal info_bar
	lw a0, frame_counter
	jal spawn_enemy
	jal update_enemy
	jal view_enemy
	jal update_projectile
	jal view_projectile
	jal check_collision_projectile
	jal check_collision_ship
	#if projectiles left is 0, game over
	#if projectiles > 0, check if lives is at 0 and if so game over
	#else continue
	jal get_proj_left
	move t0, v0
	bgt t0, 0, check_lives
	jal proj_get_element
	move t0, v0
	lw t2, is_active(t0)
	beq t2, 0, _main_game_over
	
	check_lives:
	jal get_lives_left
	move t0, v0
	bgt t0, 0, game_continue
	j _main_game_over
	
	game_continue:	
	lw a0, frame_counter
	jal	display_update_and_clear
	## This function will block waiting for the next frame!
	jal	wait_for_next_frame
	b	_main_loop

_main_game_over:
jal info_bar
la a2, gameover_text_game
li a0, 20
li a1, 10
jal display_draw_text
la a2, gameover_text_over
li a0, 20
li a1, 20
jal display_draw_text
la a2, gameover_text_score
li a0, 5
li a1, 30
jal display_draw_text
jal get_final_score
move a2, v0
li a0, 42
li a1, 30
jal display_draw_int
jal display_update_and_clear
exit


# --------------------------------------------------------------------------------------------------
# call once per main loop to keep the game running at 60FPS.
# if your code is too slow (longer than 16ms per frame), the framerate will drop.
# otherwise, this will account for different lengths of processing per frame.

wait_for_next_frame:
	enter	s0
	lw	s0, last_frame_time
_wait_next_frame_loop:
	# while (sys_time() - last_frame_time) < GAME_TICK_MS {}
	li	v0, 30
	syscall # why does this return a value in a0 instead of v0????????????
	sub	t1, a0, s0
	bltu	t1, GAME_TICK_MS, _wait_next_frame_loop

	# save the time
	sw	a0, last_frame_time

	# frame_counter++
	lw	t0, frame_counter
	inc	t0
	sw	t0, frame_counter
	leave	s0

# --------------------------------------------------------------------------------------------------
