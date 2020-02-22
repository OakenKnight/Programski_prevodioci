
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$12,%15
@main_body:
		MOV 	$0,-4(%14)
priprema0:
		MOV 	$0,-8(%14)
for0:
		CMPS 	-8(%14),$5
		JGES	exit0
priprema1:
		MOV 	$0,-12(%14)
for1:
		CMPS 	-12(%14),$5
		JGES	exit1
		ADDS	-4(%14),$1,%0
		MOV 	%0,-4(%14)
		ADDS	$1,-12(%14),-12(%14)
		JMP	for1
exit1:
		ADDS	$1,-8(%14),-8(%14)
		JMP	for0
exit0:
		MOV 	-4(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET