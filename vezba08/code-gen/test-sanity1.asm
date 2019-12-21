
f:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$4,%15
@f_body:
		ADDS	8(%14),$2,%0
		SUBS	%0,-4(%14),%0
		MOV 	%0,%13
		JMP 	@f_exit
@f_exit:
		MOV 	%14,%15
		POP 	%14
		RET
f2:
		PUSH	%14
		MOV 	%15,%14
@f2_body:
		MOV 	$2,%13
		JMP 	@f2_exit
@f2_exit:
		MOV 	%14,%15
		POP 	%14
		RET
ff:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$4,%15
@ff_body:
			CALL	f2
		MOV 	%13,%0
		ADDU	8(%14),%0,%0
		SUBU	%0,-4(%14),%0
		MOV 	%0,%13
		JMP 	@ff_exit
@ff_exit:
		MOV 	%14,%15
		POP 	%14
		RET
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$40,%15
@main_body:
			PUSH	$3
			CALL	f
			ADDS	%15,$4,%15
		MOV 	%13,%0
		MOV 	%0,-4(%14)
@if0:
		CMPS 	-4(%14),-8(%14)
		JGES	@false0
@true0:
		MOV 	$1,-4(%14)
		JMP 	@exit0
@false0:
		MOV 	$-2,-4(%14)
@exit0:
@if1:
		ADDS	-4(%14),-20(%14),%0
		ADDS	-8(%14),-24(%14),%1
		SUBS	%1,$4,%1
		CMPS 	%0,%1
		JNE 	@false1
@true1:
		MOV 	$1,-4(%14)
		JMP 	@exit1
@false1:
		MOV 	$2,-4(%14)
@exit1:
@if2:
		CMPU 	-28(%14),-32(%14)
		JNE 	@false2
@true2:
			PUSH	$1
			CALL	ff
			ADDS	%15,$4,%15
		MOV 	%13,%0
		MOV 	%0,-28(%14)
			PUSH	$11
			CALL	f
			ADDS	%15,$4,%15
		MOV 	%13,%0
		MOV 	%0,-4(%14)
		JMP 	@exit2
@false2:
		MOV 	$2,-32(%14)
@exit2:
@if3:
		ADDS	-4(%14),-20(%14),%0
		SUBS	-8(%14),-24(%14),%1
		SUBS	%1,$-4,%1
		CMPS 	%0,%1
		JNE 	@false3
@true3:
		MOV 	$1,-4(%14)
		JMP 	@exit3
@false3:
		MOV 	$2,-4(%14)
@exit3:
			PUSH	$42
			CALL	f
			ADDS	%15,$4,%15
		MOV 	%13,%0
		MOV 	%0,-4(%14)
@if4:
		SUBS	-12(%14),-20(%14),%0
		ADDS	-4(%14),%0,%0
		SUBS	%0,-24(%14),%0
		SUBS	-16(%14),-4(%14),%1
		ADDS	-8(%14),%1,%1
		CMPS 	%0,%1
		JGES	@false4
@true4:
		SUBU	-32(%14),-28(%14),%0
		ADDU	%0,-36(%14),%0
		MOV 	%0,-36(%14)
		JMP 	@exit4
@false4:
		ADDS	-12(%14),-16(%14),%0
		SUBS	%0,-20(%14),%0
		MOV 	%0,-24(%14)
@exit4:
@if5:
		CMPS 	-4(%14),-8(%14)
		JGES	@false5
@true5:
		MOV 	$1,-4(%14)
		JMP 	@exit5
@false5:
@exit5:
@if6:
		ADDS	-4(%14),-20(%14),%0
		SUBS	-8(%14),$+4,%1
		CMPS 	%0,%1
		JNE 	@false6
@true6:
		MOV 	$1,-4(%14)
		JMP 	@exit6
@false6:
@exit6:
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET