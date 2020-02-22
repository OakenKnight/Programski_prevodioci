
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@main_body:
		MOV 	$0,-8(%14)
priprema0:
		MOV 	$2,-4(%14)
petljaj0:
		CMPS	-4(%14),$5
		JGES	exit0
		ADDS	-8(%14),-4(%14),%0
		MOV 	%0,-8(%14)
		ADDS	-4(%14),$1,-4(%14)
		JMP	petljaj0
exit0:
		MOV 	-8(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET