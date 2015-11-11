.text
.globl objc_msgSend_noarg

#ifdef __i386__

objc_msgSend_noarg:
	pushl %ebx
	calll .get_GOT 
.get_GOT: 
	popl %ebx 
.get_GOT2:
	addl $_GLOBAL_OFFSET_TABLE_+(.get_GOT2-.get_GOT), %ebx
	movl objc_msgSend@GOT(%ebx), %eax
	popl %ebx

	jmpl *%eax

#endif

.section ".note.GNU-stack","",@progbits

