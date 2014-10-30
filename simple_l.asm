	.file	"simple_l.c"
	.text
	.p2align 4,,15
	.globl	simple_l
	.type	simple_l, @function
simple_l:
.LFB24:
	.cfi_startproc
	movl	4(%esp), %edx
	movl	(%edx), %eax
	addl	8(%esp), %eax
	movl	%eax, (%edx)
	ret
	.cfi_endproc
.LFE24:
	.size	simple_l, .-simple_l
	.ident	"GCC: (Ubuntu 4.8.2-19ubuntu1) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
