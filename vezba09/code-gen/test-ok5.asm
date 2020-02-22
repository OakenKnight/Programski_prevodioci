
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@main_body:
		MOV 	$0,-4(%14)
		MOV 	$0,-8(%14)
switch0:
		JMP	switches0
case0:
		MOV 	$5,-4(%14)
		JMP	exit0
case2:
		MOV 	$10,-4(%14)
default0:
		MOV 	$5,-4(%14)
		JMP	exit0
		switches0:
		CMPS 	$0,-8(%14)
		JEQ	case0
		CMPS 	$2,-8(%14)
		JEQ	case2
		JMP	default0
exit0:
		MOV 	-4(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET