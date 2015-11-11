.text
.globl objc_msgSend_fixup
.globl objc_msgSendSuper2_fixup
.globl objc_msgSendSuper2_stret_fixup
.globl objc_msgSend_fpret_fixup
.globl objc_msgSend_fp2ret_fixup
.globl objc_msgSend_stret_fixup

#ifdef __x86_64__

objc_msgSend_fp2ret_fixup:
objc_msgSend_fpret_fixup:
	movq 8(%rsi), %rsi
	jmp objc_msgSend_fpret@PLT

objc_msgSend_fixup:
	movq 8(%rsi), %rsi
	jmp objc_msgSend@PLT

objc_msgSendSuper2_fixup:
	movq 8(%rsi), %rsi
	jmp objc_msgSendSuper2@PLT

objc_msgSend_stret_fixup:
	movq 8(%rdx), %rdx
	jmp objc_msgSend_stret@PLT
	
objc_msgSendSuper2_stret_fixup:
	movq 8(%rdx), %rdx
	jmp objc_msgSendSuper2_stret@PLT

#endif

.section ".note.GNU-stack","",@progbits

