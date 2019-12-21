
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$12,%15
@main_body:
		MOV 	$15,-8(%14)
		SUBS	-8(%14),$2,%0
		MOV 	%0,-4(%14)
		MOV 	$9,-12(%14)
		MOV 	-4(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET