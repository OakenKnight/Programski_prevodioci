
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$12,%15
@main_body:
		MOV 	$0,-8(%14)
		MOV 	$0,-4(%14)
		MOV 	$0,-12(%14)
priprema0:
		MOV 	$1,-4(%14)
petlja0:
		CMPS	-4(%14),$5
		JGES	exit0
priprema1:
		MOV 	$1,-8(%14)
petlja1:
		CMPS	-8(%14),$3
		JGES	exit1
		ADDS	-12(%14),$1,%0
		MOV 	%0,-12(%14)
		ADDS	$1,-8(%14),-8(%14)
		JMP	petlja1
exit1:
		ADDS	$1,-4(%14),-4(%14)
		JMP	petlja0
exit0:
		MOV 	-12(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET