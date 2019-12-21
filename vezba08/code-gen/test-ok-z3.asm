
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$20,%15
@main_body:
		MOV 	$5,-16(%14)
		MOV 	$2,-4(%14)
		MOV 	$3,-8(%14)
		CMPS 	-4(%14),-8(%14)
		JLES	@false0
		@true0:
		MOV 	-4(%14),%0
		JMP	@exit0
		@false0:
		MOV 	-8(%14),%0
		@exit0:
		MOV 	%0,-20(%14)
		CMPS 	-16(%14),-4(%14)
		JLES	@false1
		@true1:
		MOV 	-20(%14),%0
		JMP	@exit1
		@false1:
		MOV 	-16(%14),%0
		@exit1:
		MOV 	%0,-12(%14)
		MOV 	-12(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET