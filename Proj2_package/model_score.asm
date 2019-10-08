.data 

score_struct: .word 0

.text

.globl score_get_element

score_get_element:

la t0, score_struct
move v0, t0
jr ra
