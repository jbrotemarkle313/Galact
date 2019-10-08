.data 

proj_struct: .word 0:3

.text

.globl proj_get_element

proj_get_element:

la t0, proj_struct
move v0, t0
jr ra