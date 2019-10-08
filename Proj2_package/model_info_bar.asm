.include "convenience.asm"

.data 

#projectiles start at 50, lives start at 3, score starts at 0
proj_left: .word 50
lives_left: .word 3
curr_score:	.word 0

.text

.globl get_proj_left
.globl set_lives_left
.globl get_lives_left
.globl get_final_score
.globl set_proj_left
.globl set_final_score

get_proj_left:
enter
lw v0, proj_left
leave

set_proj_left:
enter
lw t0, proj_left
dec t0
sw t0, proj_left
leave

get_lives_left:
enter
lw v0, lives_left
leave

set_lives_left:
enter 
lw t0, lives_left
dec t0
sw t0, lives_left
leave

get_final_score:
enter
lw v0, curr_score
leave

set_final_score:
enter
lw t0, curr_score
add t0, t0, 5
sw, t0, curr_score
leave
