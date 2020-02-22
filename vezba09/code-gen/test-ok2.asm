
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$12,%15
@main_body:
		MOV 	$0,-8(%14)
priprema0:
		MOV 	$2,-4(%14)
petljaj0:
		CMPS	-4(%14),$5
		JGES	exit0
priprema1:
		MOV 	$2,-12(%14)
petljaj1:
		CMPS	-12(%14),$4
		JGES	exit1
		ADDS	-8(%14),-12(%14),%0
		ADDS	%0,-4(%14),%0
		MOV 	%0,-8(%14)
		ADDS	-12(%14),$1,-12(%14)
		JMP	petljaj1
exit1:
		ADDS	-4(%14),$1,-4(%14)
		JMP	petljaj0
exit0:
		MOV 	-8(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET