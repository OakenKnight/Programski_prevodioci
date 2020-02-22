
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@main_body:
		MOV 	$0,-4(%14)
		MOV 	$0,-8(%14)
priprema0:
		MOV 	$1,-4(%14)
petlja0:
		CMPS	-4(%14),$5
		JGES	exit0
		ADDS	-8(%14),$1,%0
		MOV 	%0,-8(%14)
		ADDS	$1,-4(%14),-4(%14)
		JMP	petlja0
exit0:
		MOV 	-8(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET