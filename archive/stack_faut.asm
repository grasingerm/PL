	.file	"stack_p.c"
	.section	.rodata
.LC0:
	.string	"%d\n"
	.text
	.globl	g
	.type	g, @function
g:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	leave
	ret
	.size	g, .-g
	.globl	f
	.type	f, @function
f:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$7, -4(%rbp)
	popq	%rbp
	ret
	.size	f, .-f
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$0, %eax
	call	f
	movl	$0, %eax
	call	g
	movl	$0, %eax
	popq	%rbp
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.8.2-19ubuntu1) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
