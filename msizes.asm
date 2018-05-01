	.file	"msizes.c"
	.section	.rodata
.LC0:
	.string	"Size of char"
.LC1:
	.string	"%40s: %4lu\n"
.LC2:
	.string	"Size of unsigned char"
.LC3:
	.string	"Size of short int"
.LC4:
	.string	"Size of unsigned short int"
.LC5:
	.string	"Size of int"
.LC6:
	.string	"Size of unsigned int"
.LC7:
	.string	"Size of long int"
.LC8:
	.string	"Size of unsigned long int"
.LC9:
	.string	"Size of long long int"
	.align 8
.LC10:
	.string	"Size of unsigned long long int"
.LC11:
	.string	"Size of float"
.LC12:
	.string	"Size of double"
.LC13:
	.string	"Size of long double"
.LC14:
	.string	"Size of pointer"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$1, %edx
	movl	$.LC0, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$1, %edx
	movl	$.LC2, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$2, %edx
	movl	$.LC3, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$2, %edx
	movl	$.LC4, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$4, %edx
	movl	$.LC5, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$4, %edx
	movl	$.LC6, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$8, %edx
	movl	$.LC7, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$8, %edx
	movl	$.LC8, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$8, %edx
	movl	$.LC9, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$8, %edx
	movl	$.LC10, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$4, %edx
	movl	$.LC11, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$8, %edx
	movl	$.LC12, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$16, %edx
	movl	$.LC13, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$8, %edx
	movl	$.LC14, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.8.2-19ubuntu1) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
