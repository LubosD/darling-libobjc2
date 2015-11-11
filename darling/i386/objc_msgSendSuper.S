.globl objc_msgSendSuper
.globl objc_msgSendSuper2 // requires extracting superclass from Class
.globl objc_msgSendSuper2_stret

#ifdef __i386__

#define DereferenceArgument(idx) \
	movl 4*idx+8(%ebp), %ecx ;\
	movl (%ecx), %ecx ;\
	movl %ecx, 4*idx+8(%ebp)

// NOT USED
objc_msgSendSuper2:
	movl 4(%esp), %eax // get objc_super*
	// make a copy on the stack
	movl (%eax), %ecx // 1st elem
	movl %ecx, -8(%esp)
	movl 4(%eax), %ecx // 2nd elem
	movl 4(%ecx), %ecx // get superclass from objc_class
	movl %ecx, -4(%esp)

	subl %esp, 8
	movl 16(%esp), %eax // SEL (2nd argument)
	pushl %eax
	leal 4(%esp), %eax // fixed objc_super (1st argument)
	pushl %eax

	call objc_msg_lookup_super@PLT

	addl %esp, 16 // remove args & struct from the stack

	DereferenceArgument(0)

	jmpl *%eax
	
objc_msgSendSuper:

	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	calll 1f
1:
	popl %ebx
2:
	addl $_GLOBAL_OFFSET_TABLE_+(2b-1b), %ebx

	movl 12(%ebp), %eax
	pushl %eax
	movl 8(%ebp), %eax
	pushl %eax
	call objc_msg_lookup_super@PLT
	addl %esp, 8

	DereferenceArgument(0)

	movl -4(%ebp), %ebx
	movl %ebp, %esp
	popl %ebp

	jmpl *%eax

objc_msgSendSuper2_stret:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	call 1f
1:
	popl %ebx
2:
	addl $_GLOBAL_OFFSET_TABLE_+(2b-1b), %ebx

	movl 16(%ebp), %eax
	pushl %eax
	movl 12(%ebp), %eax
	pushl %eax
	
	call objc_msg_lookup_super@PLT
	subl %esp, 8

	DereferenceArgument(1)

	movl -4(%ebp), %ebx
	movl %ebp, %esp
	popl %ebp
	
	jmpl *%eax

#endif

.section ".note.GNU-stack","",@progbits

