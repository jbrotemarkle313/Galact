.data
	array_of_ship_structs:	.word	0:12 

.text
.globl ship_get_element
ship_get_element:
	la	t0, array_of_ship_structs
	mul	t1, a0, 12	
	add	v0, t0, t1	
	jr	ra

