.data
	array_of_enemy:	.word	0:25 #25 is the only number that did not cause an error

.text

.globl get_enemy_element

get_enemy_element:
	
	la	t0, array_of_enemy				
	mul	t1, a0, 20					
	add	v0, t0, t1	
	jr ra
