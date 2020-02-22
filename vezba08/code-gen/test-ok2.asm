
f:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$4,%15
@f_body:
		ADDS	8(%14),-4(%14),%0
		MOV 	%0,%13
		JMP 	@f_exit
@f_exit:
		MOV 	%14,%15
		POP 	%14
		RET
y:
		PUSH	%14
		MOV 	%15,%14
@y_body:
		MOV 	$2147483647,%13
		JMP 	@y_exit
@y_exit:
		MOV 	%14,%15
		POP 	%14
		RET
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@main_body:
		MOV 	$0,-4(%14)
@if0:
		CMPS 	-4(%14),$-10
		JGES	@false0
@true0:
		ADDS	-4(%14),$3,%0
			PUSH	%0
			CALL	f
			ADDS	%15,$4,%15
		MOV 	%13,%0
		MOV 	%0,-4(%14)
		JMP 	@exit0
@false0:
			CALL	y
		MOV 	%13,%0
		MOV 	%0,-4(%14)
@exit0:
		MOV 	$-556,-4(%14)
		ADDS	-4(%14),$666,%0
		MOV 	%0,%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET
z:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$4,%15
@z_body:
		MOV 	$16,-4(%14)
@if1:
		CMPU 	-4(%14),$10
		JGEU	@false1
@true1:
		MOV 	$3,-4(%14)
		JMP 	@exit1
@false1:
@exit1:
		ADDU	-4(%14),$4,%0
		MOV 	%0,%13
		JMP 	@z_exit
@z_exit:
		MOV 	%14,%15
		POP 	%14
		RET