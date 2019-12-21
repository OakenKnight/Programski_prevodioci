
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$20,%15
@main_body:
		MOV 	$0,-16(%14)
PRIPREMA0:
		MOV 	$0,-12(%14)
FOR0:
		CMPS 	-12(%14),$5
		JGES EXIT0
PRIPREMA1:
		MOV 	$0,-20(%14)
FOR1:
		CMPS 	-20(%14),$5
		JGES EXIT1
		ADDS	-16(%14),$1,%2
		MOV 	%2,-16(%14)
			ADDS	 $1,-20(%14),-20(%14)
		JMP FOR1
EXIT1:
			ADDS	 $1,-12(%14),-12(%14)
		JMP FOR0
EXIT0:
		MOV 	-16(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET