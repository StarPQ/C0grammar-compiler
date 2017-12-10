.data
	string0:	.asciiz	"aaa: "
	string1:	.asciiz	"hello "
	string2:	.asciiz	"\n"
	string3:	.asciiz	"\n"
	string4:	.asciiz	"branch 1"
	string5:	.asciiz	"branch 2"
	string6:	.asciiz	"branch 3"
.text
	move	$fp	$sp
	move	$gp	$sp
	li	$8	101
	sw	$8		($sp)	#a0<--0
	subi	$sp	$sp	4
	li	$8	2
	sw	$8		($sp)	#b0<---4
	subi	$sp	$sp	4
	li	$8	97
	sw	$8		($sp)	#c0<---8
	subi	$sp	$sp	4
	li	$8	54
	sw	$8		($sp)	#d0<---12
	subi	$sp	$sp	4
	sw	$8		($sp)	#inx<---16
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#0<---20
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#1<---24
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#2<---28
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#3<---32
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#4<---36
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#5<---40
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#6<---44
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#7<---48
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#8<---52
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#9<---56
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#10<---60
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#11<---64
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#12<---68
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#13<---72
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#14<---76
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#15<---80
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#16<---84
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#17<---88
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#18<---92
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#19<---96
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#20<---100
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#21<---104
	subi	$sp	$sp	4
	sw	$8		($sp)	#inarr#22<---108
	subi	$sp	$sp	4
	sw	$8		($sp)	#charx<---112
	subi	$sp	$sp	4
	sw	$8		($sp)	#chararr#0<---116
	subi	$sp	$sp	4
	sw	$8		($sp)	#chararr#1<---120
	subi	$sp	$sp	4
	move	$fp	$sp

#goto	LABEL_MAIN		
	j	LABEL_MAIN
	nop

#LABEL_fun1	:		
LABEL_fun1:

#int	fun1	()	

#para	int	a	

#para	char	b	

#li	$t0	0	
	li	$8	0

#$t1	a	>	$t0
	lw	$9	0($fp)	#a-->0
	sub	$10	$9	$8
	blez	$10	LABEL_0

#call	fun1		
	subi	$sp	$sp	12
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$fp	$sp

#$t2		-	a
	sub	$11	$0	$9

#push	$t2		
	sw	$11	($sp)
	subi	$sp	$sp	4

#push	b		
	lw	$8	-4($fp)	#b-->-4
	sw	$8	($sp)
	subi	$sp	$sp	4

#jal	LABEL_fun1		
	jal	LABEL_fun1
	nop
	addi	$sp	$sp	12
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#goto	LABEL_1		
	j	LABEL_1
	nop

#LABEL_0	:		
LABEL_0:

#printf	number	b	
	lw	$8	-4($fp)	#b-->-4
	li	$v0	11
	move	$a0	$8
	syscall

#LABEL_1	:		
LABEL_1:

#$t3		-	a
	lw	$9	0($fp)	#a-->0
	sub	$10	$0	$9

#ret	$t3		
	move	$v0	$10
	move	$sp	$fp
	jr	$ra
	nop

#end			

#LABEL_fun2	:		
LABEL_fun2:

#char	fun2	()	

#var	int	q	
	sw	$8		($sp)	#q<--0
	subi	$sp	$sp	4

#var	int	p	
	sw	$8		($sp)	#p<---4
	subi	$sp	$sp	4

#li	$t0	3	
	li	$8	3

#li	$t1	2	
	li	$9	2

#$t2	$t0	*	$t1
	mult	$8	$9
	mflo	$10

#q		=	$t2
	lw	$11	0($fp)	#q-->0
	add	$11	$10	$0
	sw	$11	0($fp)

#li	$t3	2	
	li	$12	2

#$t4	q	-	$t3
	sub	$13	$11	$12

#p		=	$t4
	lw	$14	-4($fp)	#p-->-4
	add	$14	$13	$0
	sw	$14	-4($fp)

#$t5	q	!=	p
	sub	$15	$11	$14
	beq	$15	$0	LABEL_2

#li	$t6	3	
	li	$16	3

#li	$t7	3	
	li	$17	3

#$t8	$t6	/	$t7
	div	$16	$17
	mflo	$18

#q		=	$t8
	add	$11	$18	$0
	sw	$11	0($fp)

#goto	LABEL_3		
	j	LABEL_3
	nop

#LABEL_2	:		
LABEL_2:

#li	$t9	1	
	li	$19	1

#q		=	$t9
	add	$11	$19	$0
	sw	$11	0($fp)

#LABEL_3	:		
LABEL_3:

#li	$t10	116	
	li	$20	116

#$t11	q	<	$t10
	sub	$21	$11	$20
	bgez	$21	LABEL_4

#li	$t12	233	
	li	$22	233

#p		=	$t12
	add	$14	$22	$0
	sw	$14	-4($fp)

#goto	LABEL_5		
	j	LABEL_5
	nop

#LABEL_4	:		
LABEL_4:

#li	$t13	2	
	li	$23	2

#q		=	$t13
	add	$11	$23	$0
	sw	$11	0($fp)

#LABEL_5	:		
LABEL_5:

#li	$t14	3	
	sw	$8		($sp)	#$t0<---8
	subi	$sp	$sp	4
	li	$8	3

#li	$t15	500	
	sw	$13		($sp)	#$t4<---12
	subi	$sp	$sp	4
	li	$13	500

#$t16	$t14	==	$t15
	sw	$14	-4($fp)
	sub	$14	$8	$13
	bne	$14	$0	LABEL_6

#printf	number	p	
	sw	$22		($sp)	#$t12<---16
	subi	$sp	$sp	4
	lw	$22	-4($fp)	#p-->-4
	li	$v0	1
	move	$a0	$22
	syscall

#goto	LABEL_7		
	j	LABEL_7
	nop

#LABEL_6	:		
LABEL_6:

#li	$t17	3	
	sw	$18		($sp)	#$t8<---20
	subi	$sp	$sp	4
	li	$18	3

#q		=	$t17
	add	$11	$18	$0
	sw	$11	0($fp)

#LABEL_7	:		
LABEL_7:

#li	$t18	95	
	sw	$9		($sp)	#$t1<---24
	subi	$sp	$sp	4
	li	$9	95

#ret	$t18		
	move	$v0	$9
	move	$sp	$fp
	jr	$ra
	nop

#end			

#LABEL_fun3	:		
LABEL_fun3:

#void	fun3	()	

#para	char	b	

#para	int	c	

#const int	maa	=	201
	li	$8	201
	sw	$8		($sp)	#maa<---8
	subi	$sp	$sp	4

#const int	mbb	=	-99
	li	$8	-99
	sw	$8		($sp)	#mbb<---12
	subi	$sp	$sp	4

#const char	chh	=	43
	li	$8	43
	sw	$8		($sp)	#chh<---16
	subi	$sp	$sp	4

#const char	chn	=	47
	li	$8	47
	sw	$8		($sp)	#chn<---20
	subi	$sp	$sp	4

#const char	chj	=	106
	li	$8	106
	sw	$8		($sp)	#chj<---24
	subi	$sp	$sp	4

#var	int	aaa	
	sw	$8		($sp)	#aaa<---28
	subi	$sp	$sp	4

#var	int	bbb	
	sw	$8		($sp)	#bbb<---32
	subi	$sp	$sp	4

#var	char	ccc	4
	sw	$8		($sp)	#ccc#0<---36
	subi	$sp	$sp	4
	sw	$8		($sp)	#ccc#1<---40
	subi	$sp	$sp	4
	sw	$8		($sp)	#ccc#2<---44
	subi	$sp	$sp	4
	sw	$8		($sp)	#ccc#3<---48
	subi	$sp	$sp	4

#var	char	ddd	
	sw	$8		($sp)	#ddd<---52
	subi	$sp	$sp	4

#scanf	aaa		
	lw	$8	-28($fp)	#aaa-->-28
	li	$v0	5
	syscall
	move	$8	$v0
	sw	$8	-28($fp)

#scanf	bbb		
	lw	$9	-32($fp)	#bbb-->-32
	li	$v0	5
	syscall
	move	$9	$v0
	sw	$9	-32($fp)

#$t0		-	bbb
	sub	$10	$0	$9

#BZ	$t0	LABEL_8	
	beq	$10	$0	LABEL_8
	nop

#LABEL_10	:		
LABEL_10:

#$t1	aaa	>=	bbb
	sub	$11	$8	$9
	bltz	$11	LABEL_11

#li	$t2	10	
	li	$12	10

#$t3	aaa	-	$t2
	sub	$13	$8	$12

#aaa		=	$t3
	add	$8	$13	$0
	sw	$8	-28($fp)

#goto	LABEL_10		
	j	LABEL_10
	nop

#LABEL_11	:		
LABEL_11:

#li	$t4	100	
	li	$14	100

#ccc	2	=	$t4
	lw	$15	-44($fp)	#ccc#2-->-44
	add	$15	$14	$0
	sw	$15	-44($fp)

#goto	LABEL_9		
	j	LABEL_9
	nop

#LABEL_8	:		
LABEL_8:

#printf	string	aaa: 	
	li	$v0	4
	la	$a0	string0
	syscall

#printf	number	aaa	
	li	$v0	1
	move	$a0	$8
	syscall

#LABEL_9	:		
LABEL_9:

#printf	string	hello 	
	li	$v0	4
	la	$a0	string1
	syscall

#$t5	aaa	+	bbb
	add	$16	$8	$9

#printf	number	$t5	
	li	$v0	1
	move	$a0	$16
	syscall

#ret	$t5		
	move	$v0	$16
	move	$sp	$fp
	jr	$ra
	nop

#end			

#LABEL_fun4	:		
LABEL_fun4:

#void	fun4	()	

#var	int	tmp	
	sw	$8		($sp)	#tmp<--0
	subi	$sp	$sp	4

#var	int	t	10
	sw	$8		($sp)	#t#0<---4
	subi	$sp	$sp	4
	sw	$8		($sp)	#t#1<---8
	subi	$sp	$sp	4
	sw	$8		($sp)	#t#2<---12
	subi	$sp	$sp	4
	sw	$8		($sp)	#t#3<---16
	subi	$sp	$sp	4
	sw	$8		($sp)	#t#4<---20
	subi	$sp	$sp	4
	sw	$8		($sp)	#t#5<---24
	subi	$sp	$sp	4
	sw	$8		($sp)	#t#6<---28
	subi	$sp	$sp	4
	sw	$8		($sp)	#t#7<---32
	subi	$sp	$sp	4
	sw	$8		($sp)	#t#8<---36
	subi	$sp	$sp	4
	sw	$8		($sp)	#t#9<---40
	subi	$sp	$sp	4

#var	int	_as	
	sw	$8		($sp)	#_as<---44
	subi	$sp	$sp	4

#li	$t0	0	
	li	$8	0

#_as		=	$t0
	lw	$9	-44($fp)	#_as-->-44
	add	$9	$8	$0
	sw	$9	-44($fp)

#t	2	=	_as
	lw	$10	-12($fp)	#t#2-->-12
	add	$10	$9	$0
	sw	$10	-12($fp)

#li	$t1	2	
	li	$11	2

#$t2	=	t	$t1
	li	$12	-4
	mul	$12	$11	$12
	lw	$13	-4($fp)	#t#0-->-4
	add	$12	$12	$fp
	lw	$14	-4($fp)
	move	$12	$14

#tmp		=	$t2
	lw	$13	0($fp)	#tmp-->0
	add	$13	$12	$0
	sw	$13	0($fp)

#li	$t3	2	
	li	$15	2

#li	$t4	2	
	li	$16	2

#$t5	$t3	+	$t4
	add	$17	$15	$16

#li	$t6	5	
	li	$18	5

#$t7		-	$t6
	sub	$19	$0	$18

#$t8	$t5	*	$t7
	mult	$17	$19
	mflo	$20

#t	1	=	$t8
	lw	$21	-8($fp)	#t#1-->-8
	add	$21	$20	$0
	sw	$21	-8($fp)

#ret	$t8		
	move	$v0	$20
	move	$sp	$fp
	jr	$ra
	nop

#end			

#LABEL_MAIN	:		
LABEL_MAIN:

#void	main	()	

#var	int	z	
	sw	$8		($sp)	#z<--0
	subi	$sp	$sp	4

#var	char	x	
	sw	$8		($sp)	#x<---4
	subi	$sp	$sp	4

#var	char	y	
	sw	$8		($sp)	#y<---8
	subi	$sp	$sp	4

#scanf	y		
	lw	$8	-8($fp)	#y-->-8
	li	$v0	12
	syscall
	move	$8	$v0
	sw	$8	-8($fp)

#printf	number	y	
	li	$v0	11
	move	$a0	$8
	syscall

#call	fun1		
	subi	$sp	$sp	12
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$fp	$sp

#li	$t0	2	
	li	$9	2

#push	$t0		
	sw	$9	($sp)
	subi	$sp	$sp	4

#li	$t1	55	
	li	$8	55

#push	$t1		
	sw	$8	($sp)
	subi	$sp	$sp	4

#jal	LABEL_fun1		
	jal	LABEL_fun1
	nop
	addi	$sp	$sp	12
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t2	=	RET	
	move	$8	$v0

#z		=	$t2
	lw	$9	0($fp)	#z-->0
	add	$9	$8	$0
	sw	$9	0($fp)

#printf	number	z	
	li	$v0	1
	move	$a0	$9
	syscall

#call	fun2		
	subi	$sp	$sp	12
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$fp	$sp

#jal	LABEL_fun2		
	jal	LABEL_fun2
	nop
	addi	$sp	$sp	12
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t3	=	RET	
	move	$8	$v0

#x		=	$t3
	lw	$9	-4($fp)	#x-->-4
	add	$9	$8	$0
	sw	$9	-4($fp)

#printf	number	y	
	lw	$10	-8($fp)	#y-->-8
	li	$v0	11
	move	$a0	$10
	syscall

#call	fun3		
	subi	$sp	$sp	12
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$fp	$sp

#li	$t4	114	
	li	$11	114

#push	$t4		
	sw	$11	($sp)
	subi	$sp	$sp	4

#li	$t5	5	
	li	$8	5

#li	$t6	6	
	li	$9	6

#$t7	$t5	+	$t6
	add	$10	$8	$9

#push	$t7		
	sw	$10	($sp)
	subi	$sp	$sp	4

#jal	LABEL_fun3		
	jal	LABEL_fun3
	nop
	addi	$sp	$sp	12
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#printf	number	y	
	lw	$8	-8($fp)	#y-->-8
	li	$v0	11
	move	$a0	$8
	syscall

#call	fun4		
	subi	$sp	$sp	12
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$fp	$sp

#jal	LABEL_fun4		
	jal	LABEL_fun4
	nop
	addi	$sp	$sp	12
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#printf	number	y	
	lw	$8	-8($fp)	#y-->-8
	li	$v0	11
	move	$a0	$8
	syscall

#printf	string	\n	
	li	$v0	4
	la	$a0	string2
	syscall

#printf	number	y	
	li	$v0	11
	move	$a0	$8
	syscall

#printf	string	\n	
	li	$v0	4
	la	$a0	string3
	syscall

#li	$t8	99	
	li	$9	99

#$t9	y	==	$t8
	sub	$10	$8	$9
	bne	$10	$0	LABEL_13

#printf	string	branch 1	
	li	$v0	4
	la	$a0	string4
	syscall

#goto	LABEL_12		
	j	LABEL_12
	nop

#LABEL_13	:		
LABEL_13:

#li	$t10	118	
	li	$11	118

#$t11	y	==	$t10
	sub	$12	$8	$11
	bne	$12	$0	LABEL_14

#printf	string	branch 2	
	li	$v0	4
	la	$a0	string5
	syscall

#goto	LABEL_12		
	j	LABEL_12
	nop

#LABEL_14	:		
LABEL_14:

#printf	string	branch 3	
	li	$v0	4
	la	$a0	string6
	syscall

#LABEL_12	:		
LABEL_12:

#ret	$t11		
	move	$v0	$12
	move	$sp	$fp
	jr	$ra
	nop
