
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@main_body:
		MOV 	$0,-4(%14)
		MOV 	$0,-8(%14)
while0:
		CMPS 	-8(%14),$5
		JGES	exit0
		ADDS	-4(%14),-8(%14),%0
		MOV 	%0,-4(%14)
		ADDS	$1,-8(%14),-8(%14)
		JMP	while0
exit0:
		MOV 	-4(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET