
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$16,%15
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
		CMPS 	-12(%14),$2
		JGES	exit1
priprema2:
		MOV 	$0,-16(%14)
for2:
		CMPS 	-16(%14),$2
		JGES	exit2
		ADDS	-4(%14),$1,%0
		MOV 	%0,-4(%14)
		ADDS	$1,-16(%14),-16(%14)
		JMP	for2
exit2:
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