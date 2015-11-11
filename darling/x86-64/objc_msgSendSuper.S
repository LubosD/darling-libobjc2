.text
.globl objc_msgSendSuper
.globl objc_msgSendSuper2 // requires extracting superclass from Class
.globl objc_msgSendSuper2_stret

#ifdef __x86_64__

#define SaveRegisters \
	pushq %rdi ;\
	pushq %rsi ;\
	pushq %rdx ;\
	pushq %rcx ;\
	pushq %r8 ;\
	pushq %r9

#define  RestoreRegisters \
	popq %r9 ;\
	popq %r8 ;\
	popq %rcx ;\
	popq %rdx ;\
	popq %rsi ;\
	popq %rdi

objc_msgSendSuper2:
	SaveRegisters
	
	// Make a copy of the struct on stack
	movq (%rdi), %rax
	movq %rax, -16(%rsp)
	movq 8(%rdi), %rax
	movq 8(%rax), %rax // load superclass
	movq %rax, -8(%rsp)

	subq %rsp, 16
	movq %rsp, %rdi
	
	call objc_msg_lookup_super@PLT
	
	addq %rsp, 16
	
	RestoreRegisters
	
	movq (%rdi), %rdi
	jmpq *%rax
	
objc_msgSendSuper:
	SaveRegisters
	
	call objc_msg_lookup_super@PLT
	
	RestoreRegisters
	
	movq (%rdi), %rdi
	jmpq *%rax

objc_msgSendSuper2_stret:
	SaveRegisters
	
	// Make a copy of the struct on stack
	movq (%rsi), %rax
	movq %rax, -16(%rsp)
	movq 8(%rsi), %rax
	movq 8(%rax), %rax // load superclass
	movq %rax, -8(%rsp)

	subq %rsp, 16
	movq %rsp, %rdi
	movq %rdx, %rsi
	
	call objc_msg_lookup_super@PLT
	
	addq %rsp, 16
	
	RestoreRegisters
	
	movq (%rsi), %rsi
	jmpq *%rax

objc_msgSendSuper_stret:
	SaveRegisters
	
	movq %rsi, %rdi
	movq %rdx, %rsi
	
	call objc_msg_lookup_super@PLT
	
	RestoreRegisters
	
	movq (%rsi), %rsi
	jmpq *%rax

#endif
.section ".note.GNU-stack","",@progbits

