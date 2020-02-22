
fja:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$24,%15
@fja_body:
		MOV 	$0,-24(%14)
		MOV 	$2,-4(%14)
		MOV 	$4,-8(%14)
		MOV 	$6,-12(%14)
		MOV 	$8,-16(%14)
		MOV 	$10,-20(%14)
		ADDS	-16(%14),-20(%14),%0
		SUBS	-12(%14),%0,%0
		ADDS	-12(%14),-16(%14),%1
		ADDS	-20(%14),$1,%2
		ADDS	-8(%14),$1,%3
		ADDS	-16(%14),-8(%14),%4
		SUBS	-8(%14),-16(%14),%5
		SUBS	%4,%5,%4
		SUBS	%3,%4,%3
		ADDS	%2,%3,%2
		SUBS	%1,%2,%1
		SUBS	%0,%1,%0
		ADDS	-8(%14),%0,%0
		MOV 	%0,-4(%14)
		MOV 	-4(%14),%13
		JMP 	@fja_exit
@fja_exit:
		MOV 	%14,%15
		POP 	%14
		RET
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$4,%15
@main_body:
			CALL	fja
		MOV 	%13,%0
		MOV 	%0,-4(%14)
		ADDS	-4(%14),$42,%0
		MOV 	%0,%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET