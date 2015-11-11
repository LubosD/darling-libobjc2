.text
.global objc_msgSend_noarg

#ifdef __x86_64__

objc_msgSend_noarg:
	jmp objc_msgSend@PLT

#endif
.section ".note.GNU-stack","",@progbits

