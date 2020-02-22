
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@main_body:
		MOV 	$0,-4(%14)
pocetak0:
		MOV 	$7,-8(%14)
petlja0:
		CMPS	-8(%14),$10
		JGES	exit0
		ADDS	-4(%14),$1,%0
		MOV 	%0,-4(%14)
		ADDS	-8(%14),$1,-8(%14)
		JMP	petlja0
exit0:
		MOV 	-4(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET