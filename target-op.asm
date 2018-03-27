.data
	string0:	.asciiz	"test line:"
	string1:	.asciiz	"test fib:"
	string2:	.asciiz	"fib="
	string3:	.asciiz	"test function:"
	string4:	.asciiz	"test switch:"
	string5:	.asciiz	"key is 0"
	string6:	.asciiz	"key is "
	string7:	.asciiz	"key is 2"
.text
	move	$fp	$sp
	move	$gp	$sp
	li	$8	10
	li	$9	97
	li	$10	54
	sw	$16	-32($gp)	#chb#4<---32
	sw	$17	-36($gp)	#chb#5<---36
	sw	$18	-40($gp)	#chc<---40
	sw	$19	-44($gp)	#chd<---44
	subi	$sp	$sp	48
	move	$fp	$sp

#%goto	LABEL_MAIN		
	sw	$8	0($gp)	#cona<--0
	j	LABEL_MAIN
	nop

#LABEL_f	:		
	sw	$9	-4($gp)	#conb<---4
	sw	$10	-8($gp)	#conc<---8
	sw	$11	-12($gp)	#_cha<---12
	sw	$12	-16($gp)	#chb#0<---16
	sw	$13	-20($gp)	#chb#1<---20
	sw	$14	-24($gp)	#chb#2<---24
	sw	$15	-28($gp)	#chb#3<---28
LABEL_f:

#int	f	()	

#%para	int	x	

#%para	int	y	

#const int	z	=	1
	li	$8	1

#%endvardef			
	subi	$sp	$sp	12

#%li	$t0	1	
	li	$9	1

#$t1	x	>	$t0
	lw	$10	0($fp)	#x-->0
	sub	$11	$10	$9
	sw	$8	-8($fp)
	sw	$10	0($fp)
	sw	$11		($sp)	#$t1<---12
	subi	$sp	$sp	4
	blez	$11	LABEL_0

#$t2	x	+	z
	lw	$8	0($fp)	#x-->0
	lw	$9	-8($fp)	#z-->-8
	add	$10	$8	$9

#%ret	$t2		
	move	$v0	$10
	move	$sp	$fp
	jr	$ra
	nop

#%goto	LABEL_1		
	sw	$8	0($fp)
	j	LABEL_1
	nop

#LABEL_0	:		
LABEL_0:

#LABEL_1	:		
LABEL_1:

#%li	$t3	1	
	li	$8	1

#$t4	x	+	$t3
	lw	$9	0($fp)	#x-->0
	add	$10	$9	$8

#x		=	$t4
	add	$9	$10	$0
	sw	$9	0($fp)

#%call	f		
	sw	$8		($sp)	#$t3<---16
	subi	$sp	$sp	4
	sw	$9	0($fp)
	sw	$10		($sp)	#$t4<---20
	subi	$sp	$sp	4
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%push	x		
	lw	$8	0($fp)	#x-->0
	sw	$8	($sp)
	subi	$sp	$sp	4

#%push	y		
	lw	$8	-4($fp)	#y-->-4
	sw	$8	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_f		
	move	$fp	$k0
	move	$sp	$k0
	jal	LABEL_f
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t5	x	+	y
	lw	$8	0($fp)	#x-->0
	lw	$9	-4($fp)	#y-->-4
	add	$10	$8	$9

#%ret	$t5		
	move	$v0	$10
	move	$sp	$fp
	jr	$ra
	nop

#%end			

#LABEL_compare	:		
LABEL_compare:

#int	compare	()	

#%para	int	a	

#%para	int	b	

#%endvardef			
	subi	$sp	$sp	8

#$t0	a	>	b
	lw	$8	0($fp)	#a-->0
	lw	$9	-4($fp)	#b-->-4
	sub	$10	$8	$9
	sw	$8	0($fp)
	sw	$9	-4($fp)
	sw	$10		($sp)	#$t0<---8
	subi	$sp	$sp	4
	blez	$10	LABEL_2

#%li	$t1	1	
	li	$8	1

#%ret	$t1		
	move	$v0	$8
	move	$sp	$fp
	jr	$ra
	nop

#%goto	LABEL_3		
	sw	$8		($sp)	#$t1<---12
	subi	$sp	$sp	4
	j	LABEL_3
	nop

#LABEL_2	:		
LABEL_2:

#LABEL_3	:		
LABEL_3:

#$t2	a	<=	b
	lw	$8	0($fp)	#a-->0
	lw	$9	-4($fp)	#b-->-4
	sub	$10	$8	$9
	sw	$10		($sp)	#$t2<---16
	subi	$sp	$sp	4
	bgtz	$10	LABEL_4

#%li	$t3	1	
	li	$8	1

#$t4		-	$t3
	sub	$9	$0	$8

#%ret	$t4		
	move	$v0	$9
	move	$sp	$fp
	jr	$ra
	nop

#%goto	LABEL_5		
	sw	$8		($sp)	#$t3<---20
	subi	$sp	$sp	4
	j	LABEL_5
	nop

#LABEL_4	:		
LABEL_4:

#LABEL_5	:		
LABEL_5:

#%end			

#LABEL_line	:		
LABEL_line:

#void	line	()	

#%para	int	n	

#%para	int	m	

#%var	int	i	

#%var	int	j	

#%var	int	stpos	100
	sw	$21	-60($fp)
	sw	$18	-48($fp)
	sw	$8	-8($fp)
	sw	$22	-64($fp)
	sw	$9	-12($fp)
	sw	$13	-28($fp)
	sw	$16	-40($fp)
	sw	$11	-20($fp)
	sw	$15	-36($fp)
	sw	$10	-16($fp)
	sw	$12	-24($fp)
	sw	$23	-68($fp)
	sw	$19	-52($fp)
	sw	$20	-56($fp)
	sw	$14	-32($fp)
	sw	$17	-44($fp)
	sw	$21	-72($fp)
	sw	$18	-76($fp)
	sw	$8	-80($fp)
	sw	$22	-84($fp)
	sw	$9	-88($fp)
	sw	$13	-92($fp)
	sw	$16	-96($fp)
	sw	$11	-100($fp)
	sw	$15	-104($fp)
	sw	$10	-108($fp)
	sw	$12	-112($fp)
	sw	$23	-116($fp)
	sw	$19	-120($fp)
	sw	$20	-124($fp)
	sw	$14	-128($fp)
	sw	$17	-132($fp)
	sw	$21	-136($fp)
	sw	$18	-140($fp)
	sw	$8	-144($fp)
	sw	$22	-148($fp)
	sw	$9	-152($fp)
	sw	$13	-156($fp)
	sw	$16	-160($fp)
	sw	$11	-164($fp)
	sw	$15	-168($fp)
	sw	$10	-172($fp)
	sw	$12	-176($fp)
	sw	$23	-180($fp)
	sw	$19	-184($fp)
	sw	$20	-188($fp)
	sw	$14	-192($fp)
	sw	$17	-196($fp)
	sw	$21	-200($fp)
	sw	$18	-204($fp)
	sw	$8	-208($fp)
	sw	$22	-212($fp)
	sw	$9	-216($fp)
	sw	$13	-220($fp)
	sw	$16	-224($fp)
	sw	$11	-228($fp)
	sw	$15	-232($fp)
	sw	$10	-236($fp)
	sw	$12	-240($fp)
	sw	$23	-244($fp)
	sw	$19	-248($fp)
	sw	$20	-252($fp)
	sw	$14	-256($fp)
	sw	$17	-260($fp)
	sw	$21	-264($fp)
	sw	$18	-268($fp)
	sw	$8	-272($fp)
	sw	$22	-276($fp)
	sw	$9	-280($fp)
	sw	$13	-284($fp)
	sw	$16	-288($fp)
	sw	$11	-292($fp)
	sw	$15	-296($fp)
	sw	$10	-300($fp)
	sw	$12	-304($fp)
	sw	$23	-308($fp)
	sw	$19	-312($fp)
	sw	$20	-316($fp)
	sw	$14	-320($fp)
	sw	$17	-324($fp)
	sw	$21	-328($fp)
	sw	$18	-332($fp)
	sw	$8	-336($fp)
	sw	$22	-340($fp)
	sw	$9	-344($fp)
	sw	$13	-348($fp)

#%var	int	posst	100
	sw	$16	-352($fp)
	sw	$11	-356($fp)
	sw	$15	-360($fp)
	sw	$10	-364($fp)
	sw	$12	-368($fp)
	sw	$23	-372($fp)
	sw	$19	-376($fp)
	sw	$20	-380($fp)
	sw	$14	-384($fp)
	sw	$17	-388($fp)
	sw	$21	-392($fp)
	sw	$18	-396($fp)
	sw	$8	-400($fp)
	sw	$22	-404($fp)
	sw	$9	-408($fp)
	sw	$13	-412($fp)
	sw	$16	-416($fp)
	sw	$11	-420($fp)
	sw	$15	-424($fp)
	sw	$10	-428($fp)
	sw	$12	-432($fp)
	sw	$23	-436($fp)
	sw	$19	-440($fp)
	sw	$20	-444($fp)
	sw	$14	-448($fp)
	sw	$17	-452($fp)
	sw	$21	-456($fp)
	sw	$18	-460($fp)
	sw	$8	-464($fp)
	sw	$22	-468($fp)
	sw	$9	-472($fp)
	sw	$13	-476($fp)
	sw	$16	-480($fp)
	sw	$11	-484($fp)
	sw	$15	-488($fp)
	sw	$10	-492($fp)
	sw	$12	-496($fp)
	sw	$23	-500($fp)
	sw	$19	-504($fp)
	sw	$20	-508($fp)
	sw	$14	-512($fp)
	sw	$17	-516($fp)
	sw	$21	-520($fp)
	sw	$18	-524($fp)
	sw	$8	-528($fp)
	sw	$22	-532($fp)
	sw	$9	-536($fp)
	sw	$13	-540($fp)
	sw	$16	-544($fp)
	sw	$11	-548($fp)
	sw	$15	-552($fp)
	sw	$10	-556($fp)
	sw	$12	-560($fp)
	sw	$23	-564($fp)
	sw	$19	-568($fp)
	sw	$20	-572($fp)
	sw	$14	-576($fp)
	sw	$17	-580($fp)
	sw	$21	-584($fp)
	sw	$18	-588($fp)
	sw	$8	-592($fp)
	sw	$22	-596($fp)
	sw	$9	-600($fp)
	sw	$13	-604($fp)
	sw	$16	-608($fp)
	sw	$11	-612($fp)
	sw	$15	-616($fp)
	sw	$10	-620($fp)
	sw	$12	-624($fp)
	sw	$23	-628($fp)
	sw	$19	-632($fp)
	sw	$20	-636($fp)
	sw	$14	-640($fp)
	sw	$17	-644($fp)
	sw	$21	-648($fp)
	sw	$18	-652($fp)
	sw	$8	-656($fp)
	sw	$22	-660($fp)
	sw	$9	-664($fp)
	sw	$13	-668($fp)
	sw	$16	-672($fp)
	sw	$11	-676($fp)
	sw	$15	-680($fp)
	sw	$10	-684($fp)
	sw	$12	-688($fp)
	sw	$23	-692($fp)
	sw	$19	-696($fp)
	sw	$20	-700($fp)
	sw	$14	-704($fp)
	sw	$17	-708($fp)
	sw	$21	-712($fp)
	sw	$18	-716($fp)
	sw	$8	-720($fp)
	sw	$22	-724($fp)
	sw	$9	-728($fp)
	sw	$13	-732($fp)
	sw	$16	-736($fp)
	sw	$11	-740($fp)
	sw	$15	-744($fp)
	sw	$10	-748($fp)

#%var	int	p	
	sw	$12	-752($fp)

#%var	int	q	
	sw	$23	-756($fp)

#%var	int	move	
	sw	$19	-760($fp)

#%var	int	end	
	sw	$20	-764($fp)

#%var	int	po1	
	sw	$14	-768($fp)

#%var	int	po2	
	sw	$17	-772($fp)

#%var	int	st2	
	sw	$21	-776($fp)

#%endvardef			
	subi	$sp	$sp	844

#%li	$t0	1	
	sw	$18	-780($fp)
	li	$18	1

#i		=	$t0
	sw	$8	-784($fp)
	lw	$8	-8($fp)	#i-->-8
	add	$8	$18	$0
	sw	$8	-8($fp)

#%li	$t1	1	
	sw	$22	-788($fp)
	li	$22	1

#j		=	$t1
	sw	$9	-792($fp)
	lw	$9	-12($fp)	#j-->-12
	add	$9	$22	$0
	sw	$9	-12($fp)

#stpos	i	=	i
	sw	$11	-804($fp)
	li	$11	-4
	mul	$11	$8	$11
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$11	$11	$fp
	sw	$8	-16($11)

#posst	i	=	i
	lw	$8	-8($fp)	#i-->-8
	li	$11	-4
	mul	$11	$8	$11
	lw	$8	-416($fp)	#posst#0-->-416
	add	$11	$11	$fp
	sw	$8	-416($11)

#%li	$t2	1	
	li	$8	1

#$t3	i	+	$t2
	lw	$11	-8($fp)	#i-->-8
	sw	$21	-840($fp)
	add	$21	$11	$8

#i		=	$t3
	add	$11	$21	$0
	sw	$11	-8($fp)

#LABEL_6	:		
	sw	$9	-12($fp)
	sw	$11	-8($fp)
	sw	$12	-816($fp)
	sw	$14	-832($fp)
	sw	$17	-836($fp)
	sw	$19	-824($fp)
	sw	$20	-828($fp)
	sw	$23	-820($fp)
LABEL_6:

#$t4	i	<=	n
	lw	$8	-8($fp)	#i-->-8
	lw	$9	0($fp)	#n-->0
	sub	$10	$8	$9
	sw	$8	-8($fp)
	sw	$9	0($fp)
	sw	$10		($sp)	#$t4<---844
	subi	$sp	$sp	4
	bgtz	$10	LABEL_7

#stpos	i	=	i
	lw	$8	-8($fp)	#i-->-8
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$9	$9	$fp
	sw	$8	-16($9)

#posst	i	=	i
	lw	$8	-8($fp)	#i-->-8
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-416($fp)	#posst#0-->-416
	add	$9	$9	$fp
	sw	$8	-416($9)

#%li	$t5	1	
	li	$8	1

#$t6	i	+	$t5
	lw	$9	-8($fp)	#i-->-8
	add	$10	$9	$8

#i		=	$t6
	add	$9	$10	$0
	sw	$9	-8($fp)

#%goto	LABEL_6		
	sw	$8		($sp)	#$t5<---848
	subi	$sp	$sp	4
	j	LABEL_6
	nop

#LABEL_7	:		
	sw	$9	-8($fp)
LABEL_7:

#%li	$t7	1	
	li	$8	1

#i		=	$t7
	lw	$9	-8($fp)	#i-->-8
	add	$9	$8	$0
	sw	$9	-8($fp)

#%li	$t8	1	
	li	$10	1

#$t9	i	==	$t8
	sub	$11	$9	$10
	sw	$9	-8($fp)
	sw	$11		($sp)	#$t9<---852
	subi	$sp	$sp	4
	bne	$11	$0	LABEL_8

#%li	$t10	3	
	li	$8	3

#p		=	$t10
	lw	$9	-816($fp)	#p-->-816
	add	$9	$8	$0
	sw	$9	-816($fp)

#%li	$t11	2	
	li	$10	2

#q		=	$t11
	lw	$11	-820($fp)	#q-->-820
	add	$11	$10	$0
	sw	$11	-820($fp)

#%goto	LABEL_9		
	sw	$8		($sp)	#$t10<---856
	subi	$sp	$sp	4
	j	LABEL_9
	nop

#LABEL_8	:		
	sw	$9	-816($fp)
	sw	$11	-820($fp)
LABEL_8:

#LABEL_9	:		
LABEL_9:

#%li	$t12	2	
	li	$8	2

#$t13	i	==	$t12
	lw	$9	-8($fp)	#i-->-8
	sub	$10	$9	$8
	sw	$9	-8($fp)
	sw	$10		($sp)	#$t13<---860
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_10

#%li	$t14	8	
	li	$8	8

#p		=	$t14
	lw	$9	-816($fp)	#p-->-816
	add	$9	$8	$0
	sw	$9	-816($fp)

#%li	$t15	3	
	li	$10	3

#$t16		-	$t15
	sub	$11	$0	$10

#q		=	$t16
	lw	$12	-820($fp)	#q-->-820
	add	$12	$11	$0
	sw	$12	-820($fp)

#%goto	LABEL_11		
	sw	$8		($sp)	#$t14<---864
	subi	$sp	$sp	4
	j	LABEL_11
	nop

#LABEL_10	:		
	sw	$9	-816($fp)
	sw	$12	-820($fp)
LABEL_10:

#LABEL_11	:		
LABEL_11:

#%li	$t17	3	
	li	$8	3

#$t18	i	==	$t17
	lw	$9	-8($fp)	#i-->-8
	sub	$10	$9	$8
	sw	$9	-8($fp)
	sw	$10		($sp)	#$t18<---868
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_12

#%li	$t19	3	
	li	$8	3

#p		=	$t19
	lw	$9	-816($fp)	#p-->-816
	add	$9	$8	$0
	sw	$9	-816($fp)

#%li	$t20	2	
	li	$10	2

#$t21		-	$t20
	sub	$11	$0	$10

#q		=	$t21
	lw	$12	-820($fp)	#q-->-820
	add	$12	$11	$0
	sw	$12	-820($fp)

#%goto	LABEL_13		
	sw	$8		($sp)	#$t19<---872
	subi	$sp	$sp	4
	j	LABEL_13
	nop

#LABEL_12	:		
	sw	$9	-816($fp)
	sw	$12	-820($fp)
LABEL_12:

#LABEL_13	:		
LABEL_13:

#%li	$t22	0	
	li	$8	0

#$t23	q	!=	$t22
	lw	$9	-820($fp)	#q-->-820
	sub	$10	$9	$8
	sw	$9	-820($fp)
	sw	$10		($sp)	#$t23<---876
	subi	$sp	$sp	4
	beq	$10	$0	LABEL_14

#%call	compare		
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%push	q		
	lw	$8	-820($fp)	#q-->-820
	sw	$8	($sp)
	subi	$sp	$sp	4

#%li	$t24	0	
	li	$8	0

#%push	$t24		
	sw	$8	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_compare		
	move	$fp	$k0
	move	$sp	$k0
	jal	LABEL_compare
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t25	=	RET	
	move	$8	$v0

#move		=	$t25
	lw	$9	-824($fp)	#move-->-824
	add	$9	$8	$0
	sw	$9	-824($fp)

#$t26	move	*	q
	lw	$10	-820($fp)	#q-->-820
	mult	$9	$10
	mflo	$11

#end		=	$t26
	lw	$12	-828($fp)	#end-->-828
	add	$12	$11	$0
	sw	$12	-828($fp)

#$t27	=	stpos	p
	lw	$13	-816($fp)	#p-->-816
	li	$14	-4
	mul	$14	$13	$14
	lw	$13	-16($fp)	#stpos#0-->-16
	add	$14	$14	$fp
	lw	$15	-16($14)
	move	$14	$15

#po1		=	$t27
	lw	$13	-832($fp)	#po1-->-832
	add	$13	$14	$0
	sw	$13	-832($fp)

#$t28	po1	+	move
	add	$15	$13	$9

#$t29	=	posst	$t28
	li	$16	-4
	mul	$16	$15	$16
	lw	$15	-416($fp)	#posst#0-->-416
	add	$16	$16	$fp
	lw	$17	-416($16)
	move	$16	$17

#st2		=	$t29
	lw	$15	-840($fp)	#st2-->-840
	add	$15	$16	$0
	sw	$15	-840($fp)

#$t30	=	stpos	st2
	li	$17	-4
	mul	$17	$15	$17
	lw	$15	-16($fp)	#stpos#0-->-16
	add	$17	$17	$fp
	lw	$18	-16($17)
	move	$17	$18

#po2		=	$t30
	lw	$15	-836($fp)	#po2-->-836
	add	$15	$17	$0
	sw	$15	-836($fp)

#posst	po1	=	st2
	lw	$18	-840($fp)	#st2-->-840
	li	$19	-4
	mul	$19	$13	$19
	lw	$13	-416($fp)	#posst#0-->-416
	add	$19	$19	$fp
	sw	$18	-416($19)

#stpos	st2	=	po1
	lw	$13	-832($fp)	#po1-->-832
	li	$19	-4
	mul	$19	$18	$19
	lw	$18	-16($fp)	#stpos#0-->-16
	add	$19	$19	$fp
	sw	$13	-16($19)

#po1		=	po2
	add	$13	$15	$0
	sw	$13	-832($fp)

#%li	$t31	1	
	li	$18	1

#$t32	j	+	$t31
	lw	$19	-12($fp)	#j-->-12
	add	$20	$19	$18

#j		=	$t32
	add	$19	$20	$0
	sw	$19	-12($fp)

#LABEL_16	:		
	sw	$9	-824($fp)
	sw	$10	-820($fp)
	sw	$12	-828($fp)
	sw	$13	-832($fp)
	sw	$15	-836($fp)
	sw	$19	-12($fp)
LABEL_16:

#$t33	j	<=	end
	lw	$8	-12($fp)	#j-->-12
	lw	$9	-828($fp)	#end-->-828
	sub	$10	$8	$9
	sw	$8	-12($fp)
	sw	$9	-828($fp)
	sw	$10		($sp)	#$t33<---880
	subi	$sp	$sp	4
	bgtz	$10	LABEL_17

#$t34	po1	+	move
	lw	$8	-832($fp)	#po1-->-832
	lw	$9	-824($fp)	#move-->-824
	add	$10	$8	$9

#$t35	=	posst	$t34
	li	$11	-4
	mul	$11	$10	$11
	lw	$10	-416($fp)	#posst#0-->-416
	add	$11	$11	$fp
	lw	$12	-416($11)
	move	$11	$12

#st2		=	$t35
	lw	$10	-840($fp)	#st2-->-840
	add	$10	$11	$0
	sw	$10	-840($fp)

#$t36	=	stpos	st2
	li	$12	-4
	mul	$12	$10	$12
	lw	$10	-16($fp)	#stpos#0-->-16
	add	$12	$12	$fp
	lw	$13	-16($12)
	move	$12	$13

#po2		=	$t36
	lw	$10	-836($fp)	#po2-->-836
	add	$10	$12	$0
	sw	$10	-836($fp)

#posst	po1	=	st2
	lw	$13	-840($fp)	#st2-->-840
	li	$14	-4
	mul	$14	$8	$14
	lw	$8	-416($fp)	#posst#0-->-416
	add	$14	$14	$fp
	sw	$13	-416($14)

#stpos	st2	=	po1
	lw	$8	-832($fp)	#po1-->-832
	li	$14	-4
	mul	$14	$13	$14
	lw	$13	-16($fp)	#stpos#0-->-16
	add	$14	$14	$fp
	sw	$8	-16($14)

#po1		=	po2
	add	$8	$10	$0
	sw	$8	-832($fp)

#%li	$t37	1	
	li	$13	1

#$t38	j	+	$t37
	lw	$14	-12($fp)	#j-->-12
	add	$15	$14	$13

#j		=	$t38
	add	$14	$15	$0
	sw	$14	-12($fp)

#%goto	LABEL_16		
	sw	$8	-832($fp)
	j	LABEL_16
	nop

#LABEL_17	:		
	sw	$9	-824($fp)
	sw	$10	-836($fp)
	sw	$14	-12($fp)
LABEL_17:

#posst	po2	=	p
	lw	$8	-816($fp)	#p-->-816
	lw	$9	-836($fp)	#po2-->-836
	li	$10	-4
	mul	$10	$9	$10
	lw	$9	-416($fp)	#posst#0-->-416
	add	$10	$10	$fp
	sw	$8	-416($10)

#$t39	=	stpos	p
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$9	$9	$fp
	lw	$10	-16($9)
	move	$9	$10

#$t40	$t39	+	q
	lw	$8	-820($fp)	#q-->-820
	add	$10	$9	$8

#stpos	p	=	$t40
	lw	$11	-816($fp)	#p-->-816
	li	$12	-4
	mul	$12	$11	$12
	lw	$11	-16($fp)	#stpos#0-->-16
	add	$12	$12	$fp
	sw	$10	-16($12)

#%goto	LABEL_15		
	sw	$8	-820($fp)
	j	LABEL_15
	nop

#LABEL_14	:		
LABEL_14:

#LABEL_15	:		
LABEL_15:

#%li	$t41	1	
	li	$8	1

#$t42	i	+	$t41
	lw	$9	-8($fp)	#i-->-8
	add	$10	$9	$8

#i		=	$t42
	add	$9	$10	$0
	sw	$9	-8($fp)

#LABEL_18	:		
	sw	$9	-8($fp)
LABEL_18:

#$t43	i	<=	m
	lw	$8	-8($fp)	#i-->-8
	lw	$9	-4($fp)	#m-->-4
	sub	$10	$8	$9
	sw	$8	-8($fp)
	sw	$10		($sp)	#$t43<---884
	subi	$sp	$sp	4
	bgtz	$10	LABEL_19

#%li	$t44	1	
	li	$8	1

#$t45	i	==	$t44
	lw	$9	-8($fp)	#i-->-8
	sub	$10	$9	$8
	sw	$9	-8($fp)
	sw	$10		($sp)	#$t45<---888
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_20

#%li	$t46	3	
	li	$8	3

#p		=	$t46
	lw	$9	-816($fp)	#p-->-816
	add	$9	$8	$0
	sw	$9	-816($fp)

#%li	$t47	2	
	li	$10	2

#q		=	$t47
	lw	$11	-820($fp)	#q-->-820
	add	$11	$10	$0
	sw	$11	-820($fp)

#%goto	LABEL_21		
	sw	$8		($sp)	#$t46<---892
	subi	$sp	$sp	4
	j	LABEL_21
	nop

#LABEL_20	:		
	sw	$9	-816($fp)
	sw	$11	-820($fp)
LABEL_20:

#LABEL_21	:		
LABEL_21:

#%li	$t48	2	
	li	$8	2

#$t49	i	==	$t48
	lw	$9	-8($fp)	#i-->-8
	sub	$10	$9	$8
	sw	$9	-8($fp)
	sw	$10		($sp)	#$t49<---896
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_22

#%li	$t50	8	
	li	$8	8

#p		=	$t50
	lw	$9	-816($fp)	#p-->-816
	add	$9	$8	$0
	sw	$9	-816($fp)

#%li	$t51	3	
	li	$10	3

#$t52		-	$t51
	sub	$11	$0	$10

#q		=	$t52
	lw	$12	-820($fp)	#q-->-820
	add	$12	$11	$0
	sw	$12	-820($fp)

#%goto	LABEL_23		
	sw	$8		($sp)	#$t50<---900
	subi	$sp	$sp	4
	j	LABEL_23
	nop

#LABEL_22	:		
	sw	$9	-816($fp)
	sw	$12	-820($fp)
LABEL_22:

#LABEL_23	:		
LABEL_23:

#%li	$t53	3	
	li	$8	3

#$t54	i	==	$t53
	lw	$9	-8($fp)	#i-->-8
	sub	$10	$9	$8
	sw	$9	-8($fp)
	sw	$10		($sp)	#$t54<---904
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_24

#%li	$t55	3	
	li	$8	3

#p		=	$t55
	lw	$9	-816($fp)	#p-->-816
	add	$9	$8	$0
	sw	$9	-816($fp)

#%li	$t56	2	
	li	$10	2

#$t57		-	$t56
	sub	$11	$0	$10

#q		=	$t57
	lw	$12	-820($fp)	#q-->-820
	add	$12	$11	$0
	sw	$12	-820($fp)

#%goto	LABEL_25		
	sw	$8		($sp)	#$t55<---908
	subi	$sp	$sp	4
	j	LABEL_25
	nop

#LABEL_24	:		
	sw	$9	-816($fp)
	sw	$12	-820($fp)
LABEL_24:

#LABEL_25	:		
LABEL_25:

#%li	$t58	0	
	li	$8	0

#$t59	q	!=	$t58
	lw	$9	-820($fp)	#q-->-820
	sub	$10	$9	$8
	sw	$9	-820($fp)
	sw	$10		($sp)	#$t59<---912
	subi	$sp	$sp	4
	beq	$10	$0	LABEL_26

#%call	compare		
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%push	q		
	lw	$8	-820($fp)	#q-->-820
	sw	$8	($sp)
	subi	$sp	$sp	4

#%li	$t60	0	
	li	$8	0

#%push	$t60		
	sw	$8	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_compare		
	move	$fp	$k0
	move	$sp	$k0
	jal	LABEL_compare
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t61	=	RET	
	move	$8	$v0

#move		=	$t61
	lw	$9	-824($fp)	#move-->-824
	add	$9	$8	$0
	sw	$9	-824($fp)

#$t62	move	*	q
	lw	$10	-820($fp)	#q-->-820
	mult	$9	$10
	mflo	$11

#end		=	$t62
	lw	$12	-828($fp)	#end-->-828
	add	$12	$11	$0
	sw	$12	-828($fp)

#$t63	=	stpos	p
	lw	$13	-816($fp)	#p-->-816
	li	$14	-4
	mul	$14	$13	$14
	lw	$13	-16($fp)	#stpos#0-->-16
	add	$14	$14	$fp
	lw	$15	-16($14)
	move	$14	$15

#po1		=	$t63
	lw	$13	-832($fp)	#po1-->-832
	add	$13	$14	$0
	sw	$13	-832($fp)

#$t64	po1	+	move
	add	$15	$13	$9

#$t65	=	posst	$t64
	li	$16	-4
	mul	$16	$15	$16
	lw	$15	-416($fp)	#posst#0-->-416
	add	$16	$16	$fp
	lw	$17	-416($16)
	move	$16	$17

#st2		=	$t65
	lw	$15	-840($fp)	#st2-->-840
	add	$15	$16	$0
	sw	$15	-840($fp)

#$t66	=	stpos	st2
	li	$17	-4
	mul	$17	$15	$17
	lw	$15	-16($fp)	#stpos#0-->-16
	add	$17	$17	$fp
	lw	$18	-16($17)
	move	$17	$18

#po2		=	$t66
	lw	$15	-836($fp)	#po2-->-836
	add	$15	$17	$0
	sw	$15	-836($fp)

#posst	po1	=	st2
	lw	$18	-840($fp)	#st2-->-840
	li	$19	-4
	mul	$19	$13	$19
	lw	$13	-416($fp)	#posst#0-->-416
	add	$19	$19	$fp
	sw	$18	-416($19)

#stpos	st2	=	po1
	lw	$13	-832($fp)	#po1-->-832
	li	$19	-4
	mul	$19	$18	$19
	lw	$18	-16($fp)	#stpos#0-->-16
	add	$19	$19	$fp
	sw	$13	-16($19)

#po1		=	po2
	add	$13	$15	$0
	sw	$13	-832($fp)

#%li	$t67	1	
	li	$18	1

#$t68	j	+	$t67
	lw	$19	-12($fp)	#j-->-12
	add	$20	$19	$18

#j		=	$t68
	add	$19	$20	$0
	sw	$19	-12($fp)

#LABEL_28	:		
	sw	$9	-824($fp)
	sw	$10	-820($fp)
	sw	$12	-828($fp)
	sw	$13	-832($fp)
	sw	$15	-836($fp)
	sw	$19	-12($fp)
LABEL_28:

#$t69	j	<=	end
	lw	$8	-12($fp)	#j-->-12
	lw	$9	-828($fp)	#end-->-828
	sub	$10	$8	$9
	sw	$8	-12($fp)
	sw	$10		($sp)	#$t69<---916
	subi	$sp	$sp	4
	bgtz	$10	LABEL_29

#$t70	po1	+	move
	lw	$8	-832($fp)	#po1-->-832
	lw	$9	-824($fp)	#move-->-824
	add	$10	$8	$9

#$t71	=	posst	$t70
	li	$11	-4
	mul	$11	$10	$11
	lw	$10	-416($fp)	#posst#0-->-416
	add	$11	$11	$fp
	lw	$12	-416($11)
	move	$11	$12

#st2		=	$t71
	lw	$10	-840($fp)	#st2-->-840
	add	$10	$11	$0
	sw	$10	-840($fp)

#$t72	=	stpos	st2
	li	$12	-4
	mul	$12	$10	$12
	lw	$10	-16($fp)	#stpos#0-->-16
	add	$12	$12	$fp
	lw	$13	-16($12)
	move	$12	$13

#po2		=	$t72
	lw	$10	-836($fp)	#po2-->-836
	add	$10	$12	$0
	sw	$10	-836($fp)

#posst	po1	=	st2
	lw	$13	-840($fp)	#st2-->-840
	li	$14	-4
	mul	$14	$8	$14
	lw	$8	-416($fp)	#posst#0-->-416
	add	$14	$14	$fp
	sw	$13	-416($14)

#stpos	st2	=	po1
	lw	$8	-832($fp)	#po1-->-832
	li	$14	-4
	mul	$14	$13	$14
	lw	$13	-16($fp)	#stpos#0-->-16
	add	$14	$14	$fp
	sw	$8	-16($14)

#po1		=	po2
	add	$8	$10	$0
	sw	$8	-832($fp)

#%li	$t73	1	
	li	$13	1

#$t74	j	+	$t73
	lw	$14	-12($fp)	#j-->-12
	add	$15	$14	$13

#j		=	$t74
	add	$14	$15	$0
	sw	$14	-12($fp)

#%goto	LABEL_28		
	sw	$8	-832($fp)
	j	LABEL_28
	nop

#LABEL_29	:		
	sw	$10	-836($fp)
LABEL_29:

#posst	po2	=	p
	lw	$8	-816($fp)	#p-->-816
	lw	$9	-836($fp)	#po2-->-836
	li	$10	-4
	mul	$10	$9	$10
	lw	$9	-416($fp)	#posst#0-->-416
	add	$10	$10	$fp
	sw	$8	-416($10)

#$t75	=	stpos	p
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$9	$9	$fp
	lw	$10	-16($9)
	move	$9	$10

#$t76	$t75	+	q
	lw	$8	-820($fp)	#q-->-820
	add	$10	$9	$8

#stpos	p	=	$t76
	lw	$11	-816($fp)	#p-->-816
	li	$12	-4
	mul	$12	$11	$12
	lw	$11	-16($fp)	#stpos#0-->-16
	add	$12	$12	$fp
	sw	$10	-16($12)

#%goto	LABEL_27		
	sw	$8	-820($fp)
	j	LABEL_27
	nop

#LABEL_26	:		
LABEL_26:

#LABEL_27	:		
LABEL_27:

#%li	$t77	1	
	li	$8	1

#$t78	i	+	$t77
	lw	$9	-8($fp)	#i-->-8
	add	$10	$9	$8

#i		=	$t78
	add	$9	$10	$0
	sw	$9	-8($fp)

#%goto	LABEL_18		
	sw	$8		($sp)	#$t77<---920
	subi	$sp	$sp	4
	j	LABEL_18
	nop

#LABEL_19	:		
	sw	$9	-8($fp)
LABEL_19:

#%li	$t79	1	
	li	$8	1

#$t80	=	posst	$t79
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-416($fp)	#posst#0-->-416
	add	$9	$9	$fp
	lw	$10	-416($9)
	move	$9	$10

#%printf	number	$t80	
	li	$v0	1
	move	$a0	$9
	syscall

#%li	$t81	2	
	li	$8	2

#i		=	$t81
	lw	$10	-8($fp)	#i-->-8
	add	$10	$8	$0
	sw	$10	-8($fp)

#$t82	=	posst	i
	li	$11	-4
	mul	$11	$10	$11
	lw	$10	-416($fp)	#posst#0-->-416
	add	$11	$11	$fp
	lw	$12	-416($11)
	move	$11	$12

#%printf	number	$t82	
	li	$v0	1
	move	$a0	$11
	syscall

#%li	$t83	1	
	li	$10	1

#$t84	i	+	$t83
	lw	$12	-8($fp)	#i-->-8
	add	$13	$12	$10

#i		=	$t84
	add	$12	$13	$0
	sw	$12	-8($fp)

#LABEL_30	:		
	sw	$12	-8($fp)
LABEL_30:

#$t85	i	<=	n
	lw	$8	-8($fp)	#i-->-8
	lw	$9	0($fp)	#n-->0
	sub	$10	$8	$9
	sw	$8	-8($fp)
	sw	$10		($sp)	#$t85<---924
	subi	$sp	$sp	4
	bgtz	$10	LABEL_31

#$t86	=	posst	i
	lw	$8	-8($fp)	#i-->-8
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-416($fp)	#posst#0-->-416
	add	$9	$9	$fp
	lw	$10	-416($9)
	move	$9	$10

#%printf	number	$t86	
	li	$v0	1
	move	$a0	$9
	syscall

#%li	$t87	1	
	li	$8	1

#$t88	i	+	$t87
	lw	$10	-8($fp)	#i-->-8
	add	$11	$10	$8

#i		=	$t88
	add	$10	$11	$0
	sw	$10	-8($fp)

#%goto	LABEL_30		
	sw	$8		($sp)	#$t87<---928
	subi	$sp	$sp	4
	j	LABEL_30
	nop

#LABEL_31	:		
	sw	$11		($sp)	#$t88<---932
	subi	$sp	$sp	4
LABEL_31:

#%ret	$t88		
	lw	$8	-932($fp)	#$t88-->-932
	move	$v0	$8
	move	$sp	$fp
	jr	$ra
	nop

#%end			

#LABEL_f2	:		
LABEL_f2:

#char	f2	()	

#%para	char	x	

#%var	int	z2	

#%endvardef			
	subi	$sp	$sp	8

#%li	$t0	1	
	li	$9	1

#z2		=	$t0
	add	$8	$9	$0
	sw	$8	-4($fp)

#$t1	x	+	z2
	lw	$10	0($fp)	#x-->0
	add	$11	$10	$8

#x		=	$t1
	add	$10	$11	$0
	sw	$10	0($fp)

#%ret	x		
	move	$v0	$10
	move	$sp	$fp
	jr	$ra
	nop

#%end			

#LABEL_fib	:		
LABEL_fib:

#int	fib	()	

#%para	int	n	

#%var	int	result	

#%endvardef			
	subi	$sp	$sp	8

#%li	$t0	0	
	li	$9	0

#$t1	n	==	$t0
	lw	$10	0($fp)	#n-->0
	sub	$11	$10	$9
	sw	$8	-4($fp)
	sw	$10	0($fp)
	sw	$11		($sp)	#$t1<---8
	subi	$sp	$sp	4
	bne	$11	$0	LABEL_32

#%li	$t2	0	
	li	$8	0

#%ret	$t2		
	move	$v0	$8
	move	$sp	$fp
	jr	$ra
	nop

#%goto	LABEL_33		
	sw	$8		($sp)	#$t2<---12
	subi	$sp	$sp	4
	j	LABEL_33
	nop

#LABEL_32	:		
LABEL_32:

#LABEL_33	:		
LABEL_33:

#%li	$t3	1	
	li	$8	1

#$t4	n	==	$t3
	lw	$9	0($fp)	#n-->0
	sub	$10	$9	$8
	sw	$9	0($fp)
	sw	$10		($sp)	#$t4<---16
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_34

#%li	$t5	1	
	li	$8	1

#%ret	$t5		
	move	$v0	$8
	move	$sp	$fp
	jr	$ra
	nop

#%goto	LABEL_35		
	sw	$8		($sp)	#$t5<---20
	subi	$sp	$sp	4
	j	LABEL_35
	nop

#LABEL_34	:		
LABEL_34:

#LABEL_35	:		
LABEL_35:

#%call	fib		
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%li	$t6	1	
	li	$8	1

#$t7	n	-	$t6
	lw	$9	0($fp)	#n-->0
	sub	$10	$9	$8

#%push	$t7		
	sw	$10	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_fib		
	move	$fp	$k0
	move	$sp	$k0
	jal	LABEL_fib
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t8	=	RET	
	move	$8	$v0

#%call	fib		
	sw	$8		($sp)	#$t8<---24
	subi	$sp	$sp	4
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%li	$t9	2	
	li	$8	2

#$t10	n	-	$t9
	lw	$9	0($fp)	#n-->0
	sub	$10	$9	$8

#%push	$t10		
	sw	$10	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_fib		
	move	$fp	$k0
	move	$sp	$k0
	jal	LABEL_fib
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t11	=	RET	
	move	$8	$v0

#$t12	$t8	+	$t11
	lw	$9	-24($fp)	#$t8-->-24
	add	$10	$9	$8

#result		=	$t12
	lw	$11	-4($fp)	#result-->-4
	add	$11	$10	$0
	sw	$11	-4($fp)

#%ret	result		
	move	$v0	$11
	move	$sp	$fp
	jr	$ra
	nop

#%end			

#LABEL_nest	:		
LABEL_nest:

#void	nest	()	

#%var	int	a	15

#%var	int	b	15
	sw	$14	-24($fp)
	sw	$17	-36($fp)
	sw	$22	-56($fp)
	sw	$19	-44($fp)
	sw	$20	-48($fp)
	sw	$8	0($fp)
	sw	$13	-20($fp)
	sw	$9	-4($fp)
	sw	$11	-12($fp)
	sw	$23	-60($fp)
	sw	$16	-32($fp)
	sw	$12	-16($fp)
	sw	$15	-28($fp)
	sw	$10	-8($fp)

#%endvardef			
	subi	$sp	$sp	120

#%li	$t0	1	
	sw	$21	-52($fp)
	li	$21	1

#a	0	=	$t0
	sw	$18	-40($fp)
	lw	$18	0($fp)	#a#0-->0
	add	$18	$21	$0
	sw	$18	0($fp)

#%li	$t1	3	
	sw	$14	-64($fp)
	li	$14	3

#b	1	=	$t1
	sw	$17	-68($fp)
	lw	$17	-64($fp)	#b#1-->-64
	add	$17	$14	$0
	sw	$17	-64($fp)

#%li	$t2	4	
	sw	$22	-72($fp)
	li	$22	4

#a	3	=	$t2
	sw	$19	-76($fp)
	lw	$19	-12($fp)	#a#3-->-12
	add	$19	$22	$0
	sw	$19	-12($fp)

#%li	$t3	6	
	sw	$20	-80($fp)
	li	$20	6

#b	4	=	$t3
	sw	$8	-84($fp)
	lw	$8	-76($fp)	#b#4-->-76
	add	$8	$20	$0
	sw	$8	-76($fp)

#%li	$t4	8	
	sw	$13	-88($fp)
	li	$13	8

#a	6	=	$t4
	sw	$11	-96($fp)
	lw	$11	-24($fp)	#a#6-->-24
	add	$11	$13	$0
	sw	$11	-24($fp)

#%li	$t5	0	
	sw	$23	-100($fp)
	li	$23	0

#$t6	=	a	$t5
	sw	$16	-104($fp)
	li	$16	-4
	mul	$16	$23	$16
	add	$16	$16	$fp
	lw	$23	0($16)
	move	$16	$23

#$t7	=	b	$t6
	li	$18	-4
	mul	$18	$16	$18
	lw	$16	-60($fp)	#b#0-->-60
	add	$18	$18	$fp
	lw	$23	-60($18)
	move	$18	$23

#$t8	=	a	$t7
	li	$16	-4
	mul	$16	$18	$16
	lw	$18	0($fp)	#a#0-->0
	add	$16	$16	$fp
	lw	$23	0($16)
	move	$16	$23

#$t9	=	b	$t8
	li	$18	-4
	mul	$18	$16	$18
	lw	$16	-60($fp)	#b#0-->-60
	add	$18	$18	$fp
	lw	$23	-60($18)
	move	$18	$23

#$t10	=	a	$t9
	li	$16	-4
	mul	$16	$18	$16
	lw	$18	0($fp)	#a#0-->0
	add	$16	$16	$fp
	lw	$23	0($16)
	move	$16	$23

#%li	$t11	2333	
	li	$18	2333

#b	$t10	=	$t11
	li	$23	-4
	mul	$23	$16	$23
	lw	$16	-60($fp)	#b#0-->-60
	add	$23	$23	$fp
	sw	$18	-60($23)

#%li	$t12	0	
	li	$16	0

#$t13	=	a	$t12
	li	$23	-4
	mul	$23	$16	$23
	lw	$16	0($fp)	#a#0-->0
	sw	$12	-108($fp)
	add	$23	$23	$fp
	lw	$12	0($23)
	move	$23	$12

#%li	$t14	8	
	li	$12	8

#$t15	=	b	$t14
	li	$16	-4
	mul	$16	$12	$16
	lw	$12	-60($fp)	#b#0-->-60
	sw	$10	-116($fp)
	add	$16	$16	$fp
	lw	$10	-60($16)
	move	$16	$10

#$t16	$t13	+	$t15
	add	$10	$23	$16

#%printf	number	$t16	
	li	$v0	1
	move	$a0	$10
	syscall

#%ret	$t16		
	move	$v0	$10
	move	$sp	$fp
	jr	$ra
	nop

#%end			

#LABEL_t	:		
LABEL_t:

#void	t	()	

#%para	char	x	

#%endvardef			
	subi	$sp	$sp	4

#%li	$t0	99	
	li	$8	99

#$t1	x	>	$t0
	lw	$9	0($fp)	#x-->0
	sub	$10	$9	$8
	sw	$9	0($fp)
	sw	$10		($sp)	#$t1<---4
	subi	$sp	$sp	4
	blez	$10	LABEL_36

#%ret	$t1		
	lw	$8	-4($fp)	#$t1-->-4
	move	$v0	$8
	move	$sp	$fp
	jr	$ra
	nop

#%goto	LABEL_37		
	sw	$8	-4($fp)
	j	LABEL_37
	nop

#LABEL_36	:		
LABEL_36:

#LABEL_37	:		
LABEL_37:

#%li	$t2	1	
	li	$8	1

#$t3	x	+	$t2
	lw	$9	0($fp)	#x-->0
	add	$10	$9	$8

#x		=	$t3
	add	$9	$10	$0
	sw	$9	0($fp)

#%printf	number	x	
	li	$v0	11
	move	$a0	$9
	syscall

#%call	t		
	sw	$8		($sp)	#$t2<---8
	subi	$sp	$sp	4
	sw	$9	0($fp)
	sw	$10		($sp)	#$t3<---12
	subi	$sp	$sp	4
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%push	x		
	lw	$8	0($fp)	#x-->0
	sw	$8	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_t		
	move	$fp	$k0
	move	$sp	$k0
	jal	LABEL_t
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#%ret	x		
	lw	$8	0($fp)	#x-->0
	move	$v0	$8
	move	$sp	$fp
	jr	$ra
	nop

#%end			

#LABEL_MAIN	:		
LABEL_MAIN:

#void	main	()	

#const int	coz	=	3
	li	$8	3

#%var	int	a	

#%var	int	b	

#%var	int	c	

#%var	int	d	

#%var	int	key	

#%var	int	i	

#%var	int	sz2	5

#%var	int	cho	

#%var	char	sz	5
	sw	$15	-28($fp)
	sw	$18	-40($fp)

#%var	char	e	
	sw	$9	-4($fp)

#%endvardef			
	subi	$sp	$sp	76

#%li	$t0	43	
	sw	$22	-56($fp)
	li	$22	43

#chc		=	$t0
	sw	$17	-36($fp)
	lw	$17	-40($gp)	#chc-->-40
	add	$17	$22	$0
	sw	$17	-40($gp)

#%li	$t1	45	
	sw	$20	-48($fp)
	li	$20	45

#chd		=	$t1
	sw	$14	-24($fp)
	lw	$14	-44($gp)	#chd-->-44
	add	$14	$20	$0
	sw	$14	-44($gp)

#%li	$t2	3	
	sw	$8	0($fp)
	li	$8	3

#b		=	$t2
	add	$10	$8	$0
	sw	$10	-8($fp)

#%li	$t3	0	
	sw	$16	-32($fp)
	li	$16	0

#i		=	$t3
	sw	$13	-20($fp)
	lw	$13	-24($fp)	#i-->-24
	add	$13	$16	$0
	sw	$13	-24($fp)

#%li	$t4	2	
	sw	$12	-16($fp)
	li	$12	2

#$t5		-	$t4
	sw	$10	-8($fp)
	sub	$10	$0	$12

#c		=	$t5
	add	$11	$10	$0
	sw	$11	-12($fp)

#%li	$t6	1	
	sw	$23	-60($fp)
	li	$23	1

#key		=	$t6
	sw	$11	-12($fp)
	lw	$11	-20($fp)	#key-->-20
	add	$11	$23	$0
	sw	$11	-20($fp)

#%scanf	cho		
	sw	$9	-72($fp)
	lw	$9	-48($fp)	#cho-->-48
	li	$v0	5
	syscall
	move	$9	$v0
	sw	$9	-48($fp)

#%li	$t7	0	
	sw	$22		($sp)	#$t0<---76
	subi	$sp	$sp	4
	li	$22	0

#$t8	cho	==	$t7
	sw	$14	-44($gp)	#chd<---44
	sub	$14	$9	$22
	sw	$9	-48($fp)
	sw	$11	-20($fp)
	sw	$13	-24($fp)
	sw	$14		($sp)	#$t8<---80
	subi	$sp	$sp	4
	sw	$17	-40($gp)	#chc<---40
	bne	$14	$0	LABEL_39

#%printf	string	test line:	
	li	$v0	4
	la	$a0	string0
	syscall

#%call	line		
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%li	$t9	8	
	li	$8	8

#%push	$t9		
	sw	$8	($sp)
	subi	$sp	$sp	4

#%li	$t10	3	
	li	$8	3

#%push	$t10		
	sw	$8	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_line		
	move	$fp	$k0
	move	$sp	$k0
	jal	LABEL_line
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#%goto	LABEL_38		
	j	LABEL_38
	nop

#LABEL_39	:		
LABEL_39:

#%li	$t11	1	
	li	$8	1

#$t12	cho	==	$t11
	lw	$9	-48($fp)	#cho-->-48
	sub	$10	$9	$8
	sw	$9	-48($fp)
	sw	$10		($sp)	#$t12<---84
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_40

#%printf	string	test fib:	
	li	$v0	4
	la	$a0	string1
	syscall

#%call	fib		
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%push	coz		
	lw	$8	0($fp)	#coz-->0
	sw	$8	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_fib		
	move	$fp	$k0
	move	$sp	$k0
	jal	LABEL_fib
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t13	=	RET	
	move	$8	$v0

#d		=	$t13
	lw	$9	-16($fp)	#d-->-16
	add	$9	$8	$0
	sw	$9	-16($fp)

#%printf	string	fib=	
	li	$v0	4
	la	$a0	string2
	syscall

#%printf	number	d	
	li	$v0	1
	move	$a0	$9
	syscall

#%goto	LABEL_38		
	sw	$8		($sp)	#$t13<---88
	subi	$sp	$sp	4
	j	LABEL_38
	nop

#LABEL_40	:		
	sw	$9	-16($fp)
LABEL_40:

#%li	$t14	2	
	li	$8	2

#$t15	cho	==	$t14
	lw	$9	-48($fp)	#cho-->-48
	sub	$10	$9	$8
	sw	$9	-48($fp)
	sw	$10		($sp)	#$t15<---92
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_41

#%li	$t16	97	
	li	$8	97

#sz	i	=	$t16
	lw	$9	-24($fp)	#i-->-24
	li	$10	-4
	mul	$10	$9	$10
	lw	$9	-52($fp)	#sz#0-->-52
	add	$10	$10	$fp
	sw	$8	-52($10)

#sz2	i	=	i
	lw	$9	-24($fp)	#i-->-24
	li	$10	-4
	mul	$10	$9	$10
	lw	$9	-28($fp)	#sz2#0-->-28
	add	$10	$10	$fp
	sw	$9	-28($10)

#%li	$t17	1	
	li	$9	1

#$t18	i	+	$t17
	lw	$10	-24($fp)	#i-->-24
	add	$11	$10	$9

#i		=	$t18
	add	$10	$11	$0
	sw	$10	-24($fp)

#LABEL_42	:		
	sw	$10	-24($fp)
LABEL_42:

#%li	$t19	5	
	li	$8	5

#$t20	i	<	$t19
	lw	$9	-24($fp)	#i-->-24
	sub	$10	$9	$8
	sw	$9	-24($fp)
	sw	$10		($sp)	#$t20<---96
	subi	$sp	$sp	4
	bgez	$10	LABEL_43

#%li	$t21	97	
	li	$8	97

#sz	i	=	$t21
	lw	$9	-24($fp)	#i-->-24
	li	$10	-4
	mul	$10	$9	$10
	lw	$9	-52($fp)	#sz#0-->-52
	add	$10	$10	$fp
	sw	$8	-52($10)

#sz2	i	=	i
	lw	$9	-24($fp)	#i-->-24
	li	$10	-4
	mul	$10	$9	$10
	lw	$9	-28($fp)	#sz2#0-->-28
	add	$10	$10	$fp
	sw	$9	-28($10)

#%li	$t22	1	
	li	$9	1

#$t23	i	+	$t22
	lw	$10	-24($fp)	#i-->-24
	add	$11	$10	$9

#i		=	$t23
	add	$10	$11	$0
	sw	$10	-24($fp)

#%goto	LABEL_42		
	sw	$8		($sp)	#$t21<---100
	subi	$sp	$sp	4
	j	LABEL_42
	nop

#LABEL_43	:		
LABEL_43:

#%scanf	key		
	lw	$8	-20($fp)	#key-->-20
	li	$v0	5
	syscall
	move	$8	$v0
	sw	$8	-20($fp)

#%scanf	a		
	lw	$9	-4($fp)	#a-->-4
	li	$v0	5
	syscall
	move	$9	$v0
	sw	$9	-4($fp)

#%li	$t24	3	
	li	$10	3

#$t25	key	<	$t24
	sub	$11	$8	$10
	sw	$8	-20($fp)
	sw	$9	-4($fp)
	sw	$11		($sp)	#$t25<---104
	subi	$sp	$sp	4
	bgez	$11	LABEL_44

#$t26	a	+	b
	lw	$8	-4($fp)	#a-->-4
	lw	$9	-8($fp)	#b-->-8
	add	$10	$8	$9

#a		=	$t26
	add	$8	$10	$0
	sw	$8	-4($fp)

#%printf	number	a	
	li	$v0	1
	move	$a0	$8
	syscall

#%goto	LABEL_45		
	sw	$8	-4($fp)
	j	LABEL_45
	nop

#LABEL_44	:		
	sw	$9	-8($fp)
LABEL_44:

#LABEL_45	:		
LABEL_45:

#%li	$t27	3	
	li	$8	3

#$t28	key	<=	$t27
	lw	$9	-20($fp)	#key-->-20
	sub	$10	$9	$8
	sw	$9	-20($fp)
	sw	$10		($sp)	#$t28<---108
	subi	$sp	$sp	4
	bgtz	$10	LABEL_46

#$t29	b	-	a
	lw	$8	-8($fp)	#b-->-8
	lw	$9	-4($fp)	#a-->-4
	sub	$10	$8	$9

#b		=	$t29
	add	$8	$10	$0
	sw	$8	-8($fp)

#%li	$t30	0	
	li	$11	0

#$t31	=	sz2	$t30
	li	$12	-4
	mul	$12	$11	$12
	lw	$11	-28($fp)	#sz2#0-->-28
	add	$12	$12	$fp
	lw	$13	-28($12)
	move	$12	$13

#$t32	$t31	+	b
	add	$11	$12	$8

#sz2	0	=	$t32
	lw	$13	-28($fp)	#sz2#0-->-28
	add	$13	$11	$0
	sw	$13	-28($fp)

#%li	$t33	0	
	li	$14	0

#$t34	=	sz	$t33
	li	$15	-4
	mul	$15	$14	$15
	lw	$14	-52($fp)	#sz#0-->-52
	add	$15	$15	$fp
	lw	$16	-52($15)
	move	$15	$16

#%li	$t35	1	
	li	$14	1

#$t36	$t34	+	$t35
	add	$16	$15	$14

#sz	0	=	$t36
	lw	$17	-52($fp)	#sz#0-->-52
	add	$17	$16	$0
	sw	$17	-52($fp)

#%printf	number	b	
	li	$v0	1
	move	$a0	$8
	syscall

#%li	$t37	0	
	li	$18	0

#$t38	=	sz	$t37
	li	$19	-4
	mul	$19	$18	$19
	add	$19	$19	$fp
	lw	$18	-52($19)
	move	$19	$18

#%printf	number	$t38	
	li	$v0	11
	move	$a0	$19
	syscall

#%li	$t39	0	
	li	$17	0

#$t40	=	sz2	$t39
	li	$18	-4
	mul	$18	$17	$18
	add	$18	$18	$fp
	lw	$17	-28($18)
	move	$18	$17

#%printf	number	$t40	
	li	$v0	1
	move	$a0	$18
	syscall

#%goto	LABEL_47		
	sw	$8	-8($fp)
	j	LABEL_47
	nop

#LABEL_46	:		
	sw	$9	-4($fp)
LABEL_46:

#LABEL_47	:		
LABEL_47:

#%li	$t41	6	
	li	$8	6

#$t42	key	>	$t41
	lw	$9	-20($fp)	#key-->-20
	sub	$10	$9	$8
	sw	$9	-20($fp)
	sw	$10		($sp)	#$t42<---112
	subi	$sp	$sp	4
	blez	$10	LABEL_48

#$t43	a	*	b
	lw	$8	-4($fp)	#a-->-4
	lw	$9	-8($fp)	#b-->-8
	mult	$8	$9
	mflo	$10

#c		=	$t43
	lw	$11	-12($fp)	#c-->-12
	add	$11	$10	$0
	sw	$11	-12($fp)

#%li	$t44	1	
	li	$12	1

#$t45	=	sz2	$t44
	li	$13	-4
	mul	$13	$12	$13
	lw	$12	-28($fp)	#sz2#0-->-28
	add	$13	$13	$fp
	lw	$14	-28($13)
	move	$13	$14

#$t46	$t45	+	c
	add	$12	$13	$11

#sz2	1	=	$t46
	lw	$14	-32($fp)	#sz2#1-->-32
	add	$14	$12	$0
	sw	$14	-32($fp)

#%li	$t47	1	
	li	$15	1

#$t48	=	sz	$t47
	li	$16	-4
	mul	$16	$15	$16
	lw	$15	-52($fp)	#sz#0-->-52
	add	$16	$16	$fp
	lw	$17	-52($16)
	move	$16	$17

#%li	$t49	1	
	li	$15	1

#$t50	$t48	+	$t49
	add	$17	$16	$15

#sz	1	=	$t50
	lw	$18	-56($fp)	#sz#1-->-56
	add	$18	$17	$0
	sw	$18	-56($fp)

#%printf	number	c	
	li	$v0	1
	move	$a0	$11
	syscall

#%li	$t51	1	
	li	$19	1

#$t52	=	sz	$t51
	li	$20	-4
	mul	$20	$19	$20
	lw	$19	-52($fp)	#sz#0-->-52
	add	$20	$20	$fp
	lw	$21	-52($20)
	move	$20	$21

#%printf	number	$t52	
	li	$v0	11
	move	$a0	$20
	syscall

#%li	$t53	1	
	li	$19	1

#$t54	=	sz2	$t53
	li	$21	-4
	mul	$21	$19	$21
	lw	$19	-28($fp)	#sz2#0-->-28
	add	$21	$21	$fp
	lw	$22	-28($21)
	move	$21	$22

#%printf	number	$t54	
	li	$v0	1
	move	$a0	$21
	syscall

#%goto	LABEL_49		
	sw	$8	-4($fp)
	j	LABEL_49
	nop

#LABEL_48	:		
	sw	$9	-8($fp)
LABEL_48:

#LABEL_49	:		
LABEL_49:

#%li	$t55	6	
	li	$8	6

#$t56	key	>=	$t55
	lw	$9	-20($fp)	#key-->-20
	sub	$10	$9	$8
	sw	$9	-20($fp)
	sw	$10		($sp)	#$t56<---116
	subi	$sp	$sp	4
	bltz	$10	LABEL_50

#$t57	a	/	b
	lw	$8	-4($fp)	#a-->-4
	lw	$9	-8($fp)	#b-->-8
	div	$8	$9
	mflo	$10

#d		=	$t57
	lw	$11	-16($fp)	#d-->-16
	add	$11	$10	$0
	sw	$11	-16($fp)

#%li	$t58	2	
	li	$12	2

#$t59	=	sz2	$t58
	li	$13	-4
	mul	$13	$12	$13
	lw	$12	-28($fp)	#sz2#0-->-28
	add	$13	$13	$fp
	lw	$14	-28($13)
	move	$13	$14

#$t60	$t59	+	d
	add	$12	$13	$11

#sz2	2	=	$t60
	lw	$14	-36($fp)	#sz2#2-->-36
	add	$14	$12	$0
	sw	$14	-36($fp)

#%li	$t61	2	
	li	$15	2

#$t62	=	sz	$t61
	li	$16	-4
	mul	$16	$15	$16
	lw	$15	-52($fp)	#sz#0-->-52
	add	$16	$16	$fp
	lw	$17	-52($16)
	move	$16	$17

#%li	$t63	1	
	li	$15	1

#$t64	$t62	+	$t63
	add	$17	$16	$15

#sz	2	=	$t64
	lw	$18	-60($fp)	#sz#2-->-60
	add	$18	$17	$0
	sw	$18	-60($fp)

#%printf	number	d	
	li	$v0	1
	move	$a0	$11
	syscall

#%li	$t65	2	
	li	$19	2

#$t66	=	sz	$t65
	li	$20	-4
	mul	$20	$19	$20
	lw	$19	-52($fp)	#sz#0-->-52
	add	$20	$20	$fp
	lw	$21	-52($20)
	move	$20	$21

#%printf	number	$t66	
	li	$v0	11
	move	$a0	$20
	syscall

#%li	$t67	2	
	li	$19	2

#$t68	=	sz2	$t67
	li	$21	-4
	mul	$21	$19	$21
	lw	$19	-28($fp)	#sz2#0-->-28
	add	$21	$21	$fp
	lw	$22	-28($21)
	move	$21	$22

#%printf	number	$t68	
	li	$v0	1
	move	$a0	$21
	syscall

#%goto	LABEL_51		
	sw	$8	-4($fp)
	j	LABEL_51
	nop

#LABEL_50	:		
LABEL_50:

#LABEL_51	:		
LABEL_51:

#%li	$t69	4	
	li	$8	4

#$t70	key	!=	$t69
	lw	$9	-20($fp)	#key-->-20
	sub	$10	$9	$8
	sw	$9	-20($fp)
	sw	$10		($sp)	#$t70<---120
	subi	$sp	$sp	4
	beq	$10	$0	LABEL_52

#%li	$t71	1	
	li	$8	1

#$t72	$t71	/	coz
	lw	$9	0($fp)	#coz-->0
	div	$8	$9
	mflo	$10

#$t73	a	-	$t72
	lw	$11	-4($fp)	#a-->-4
	sub	$12	$11	$10

#a		=	$t73
	add	$11	$12	$0
	sw	$11	-4($fp)

#%li	$t74	3	
	li	$13	3

#$t75	=	sz2	$t74
	li	$14	-4
	mul	$14	$13	$14
	lw	$13	-28($fp)	#sz2#0-->-28
	add	$14	$14	$fp
	lw	$15	-28($14)
	move	$14	$15

#$t76	$t75	+	a
	add	$13	$14	$11

#%li	$t77	99	
	li	$15	99

#$t78	$t76	+	$t77
	add	$16	$13	$15

#sz2	3	=	$t78
	lw	$17	-40($fp)	#sz2#3-->-40
	add	$17	$16	$0
	sw	$17	-40($fp)

#%li	$t79	3	
	li	$18	3

#$t80	=	sz	$t79
	li	$19	-4
	mul	$19	$18	$19
	lw	$18	-52($fp)	#sz#0-->-52
	add	$19	$19	$fp
	lw	$20	-52($19)
	move	$19	$20

#%li	$t81	1	
	li	$18	1

#$t82	$t80	+	$t81
	add	$20	$19	$18

#sz	3	=	$t82
	lw	$21	-64($fp)	#sz#3-->-64
	add	$21	$20	$0
	sw	$21	-64($fp)

#%printf	number	a	
	li	$v0	1
	move	$a0	$11
	syscall

#%li	$t83	3	
	li	$22	3

#$t84	=	sz	$t83
	li	$23	-4
	mul	$23	$22	$23
	lw	$22	-52($fp)	#sz#0-->-52
	sw	$10		($sp)	#$t72<---124
	subi	$sp	$sp	4
	add	$23	$23	$fp
	lw	$10	-52($23)
	move	$23	$10

#%printf	number	$t84	
	li	$v0	11
	move	$a0	$23
	syscall

#%li	$t85	3	
	li	$10	3

#$t86	=	sz2	$t85
	li	$22	-4
	mul	$22	$10	$22
	lw	$10	-28($fp)	#sz2#0-->-28
	sw	$8		($sp)	#$t71<---128
	subi	$sp	$sp	4
	add	$22	$22	$fp
	lw	$8	-28($22)
	move	$22	$8

#%printf	number	$t86	
	li	$v0	1
	move	$a0	$22
	syscall

#%goto	LABEL_53		
	j	LABEL_53
	nop

#LABEL_52	:		
	sw	$9	0($fp)
	sw	$11	-4($fp)
LABEL_52:

#LABEL_53	:		
LABEL_53:

#%li	$t87	4	
	li	$8	4

#$t88	key	==	$t87
	lw	$9	-20($fp)	#key-->-20
	sub	$10	$9	$8
	sw	$9	-20($fp)
	sw	$10		($sp)	#$t88<---132
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_54

#$t89		-	a
	lw	$8	-4($fp)	#a-->-4
	sub	$9	$0	$8

#%li	$t90	2	
	li	$10	2

#$t91	$t90	*	coz
	lw	$11	0($fp)	#coz-->0
	mult	$10	$11
	mflo	$12

#$t92	$t89	+	$t91
	add	$13	$9	$12

#a		=	$t92
	add	$8	$13	$0
	sw	$8	-4($fp)

#%li	$t93	4	
	li	$14	4

#$t94	=	sz	$t93
	li	$15	-4
	mul	$15	$14	$15
	lw	$14	-52($fp)	#sz#0-->-52
	add	$15	$15	$fp
	lw	$16	-52($15)
	move	$15	$16

#%li	$t95	1	
	li	$14	1

#$t96	$t94	+	$t95
	add	$16	$15	$14

#sz	4	=	$t96
	lw	$17	-68($fp)	#sz#4-->-68
	add	$17	$16	$0
	sw	$17	-68($fp)

#%printf	number	a	
	li	$v0	1
	move	$a0	$8
	syscall

#%li	$t97	4	
	li	$18	4

#$t98	=	sz	$t97
	li	$19	-4
	mul	$19	$18	$19
	lw	$18	-52($fp)	#sz#0-->-52
	add	$19	$19	$fp
	lw	$20	-52($19)
	move	$19	$20

#%printf	number	$t98	
	li	$v0	11
	move	$a0	$19
	syscall

#%li	$t99	4	
	li	$18	4

#$t100	=	sz2	$t99
	li	$20	-4
	mul	$20	$18	$20
	lw	$18	-28($fp)	#sz2#0-->-28
	add	$20	$20	$fp
	lw	$21	-28($20)
	move	$20	$21

#%printf	number	$t100	
	li	$v0	1
	move	$a0	$20
	syscall

#%goto	LABEL_55		
	sw	$8	-4($fp)
	j	LABEL_55
	nop

#LABEL_54	:		
	sw	$11	0($fp)
LABEL_54:

#LABEL_55	:		
LABEL_55:

#BZ	key	LABEL_56	
	lw	$8	-20($fp)	#key-->-20
	beq	$8	$0	LABEL_56
	nop

#%printf	number	a	
	lw	$9	-4($fp)	#a-->-4
	li	$v0	1
	move	$a0	$9
	syscall

#%goto	LABEL_57		
	sw	$8	-20($fp)
	j	LABEL_57
	nop

#LABEL_56	:		
LABEL_56:

#LABEL_57	:		
LABEL_57:

#%goto	LABEL_38		
	j	LABEL_38
	nop

#LABEL_41	:		
LABEL_41:

#%li	$t101	3	
	li	$8	3

#$t102	cho	==	$t101
	lw	$9	-48($fp)	#cho-->-48
	sub	$10	$9	$8
	sw	$9	-48($fp)
	sw	$10		($sp)	#$t102<---136
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_58

#%printf	string	test function:	
	li	$v0	4
	la	$a0	string3
	syscall

#BZ	key	LABEL_59	
	lw	$8	-20($fp)	#key-->-20
	beq	$8	$0	LABEL_59
	nop

#%call	f		
	sw	$8	-20($fp)
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%li	$t103	2	
	li	$8	2

#$t104		-	$t103
	sub	$9	$0	$8

#%push	$t104		
	sw	$9	($sp)
	subi	$sp	$sp	4

#%li	$t105	3	
	li	$8	3

#%push	$t105		
	sw	$8	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_f		
	move	$fp	$k0
	move	$sp	$k0
	jal	LABEL_f
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t106	=	RET	
	move	$8	$v0

#%li	$t107	5	
	li	$9	5

#%li	$t108	1	
	li	$10	1

#$t109	$t107	+	$t108
	add	$11	$9	$10

#$t110	$t109	*	coz
	lw	$12	0($fp)	#coz-->0
	mult	$11	$12
	mflo	$13

#$t111	$t106	+	$t110
	add	$14	$8	$13

#sz2	4	=	$t111
	lw	$15	-44($fp)	#sz2#4-->-44
	add	$15	$14	$0
	sw	$15	-44($fp)

#%goto	LABEL_60		
	sw	$8		($sp)	#$t106<---140
	subi	$sp	$sp	4
	j	LABEL_60
	nop

#LABEL_59	:		
LABEL_59:

#LABEL_60	:		
LABEL_60:

#%call	t		
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%push	conb		
	lw	$8	-4($gp)	#conb-->-4
	sw	$8	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_t		
	move	$fp	$k0
	move	$sp	$k0
	jal	LABEL_t
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#%call	f2		
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%li	$t112	97	
	li	$8	97

#%push	$t112		
	sw	$8	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_f2		
	move	$fp	$k0
	move	$sp	$k0
	jal	LABEL_f2
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t113	=	RET	
	move	$8	$v0

#%printf	number	$t113	
	li	$v0	1
	move	$a0	$8
	syscall

#%li	$t114	4	
	li	$9	4

#$t115	=	sz2	$t114
	li	$10	-4
	mul	$10	$9	$10
	lw	$9	-28($fp)	#sz2#0-->-28
	add	$10	$10	$fp
	lw	$11	-28($10)
	move	$10	$11

#%printf	number	$t115	
	li	$v0	1
	move	$a0	$10
	syscall

#%goto	LABEL_38		
	sw	$8		($sp)	#$t113<---144
	subi	$sp	$sp	4
	j	LABEL_38
	nop

#LABEL_58	:		
LABEL_58:

#%li	$t116	4	
	li	$8	4

#$t117	cho	==	$t116
	lw	$9	-48($fp)	#cho-->-48
	sub	$10	$9	$8
	sw	$10		($sp)	#$t117<---148
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_61

#%printf	string	test switch:	
	li	$v0	4
	la	$a0	string4
	syscall

#%scanf	key		
	lw	$8	-20($fp)	#key-->-20
	li	$v0	5
	syscall
	move	$8	$v0
	sw	$8	-20($fp)

#%li	$t118	1	
	li	$9	1

#$t119	key	*	$t118
	mult	$8	$9
	mflo	$10

#%li	$t120	0	
	li	$11	0

#$t121	$t119	==	$t120
	sub	$12	$10	$11
	sw	$8	-20($fp)
	sw	$10		($sp)	#$t119<---152
	subi	$sp	$sp	4
	sw	$12		($sp)	#$t121<---156
	subi	$sp	$sp	4
	bne	$12	$0	LABEL_63

#%printf	string	key is 0	
	li	$v0	4
	la	$a0	string5
	syscall

#%goto	LABEL_62		
	j	LABEL_62
	nop

#LABEL_63	:		
LABEL_63:

#%li	$t122	1	
	li	$8	1

#$t123	$t119	==	$t122
	lw	$9	-152($fp)	#$t119-->-152
	sub	$10	$9	$8
	sw	$9	-152($fp)
	sw	$10		($sp)	#$t123<---160
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_64

#%printf	string	key is 	
	li	$v0	4
	la	$a0	string6
	syscall

#%printf	number	key	
	lw	$8	-20($fp)	#key-->-20
	li	$v0	1
	move	$a0	$8
	syscall

#%goto	LABEL_62		
	sw	$8	-20($fp)
	j	LABEL_62
	nop

#LABEL_64	:		
LABEL_64:

#%li	$t124	2	
	li	$8	2

#$t125	$t119	==	$t124
	lw	$9	-152($fp)	#$t119-->-152
	sub	$10	$9	$8
	sw	$10		($sp)	#$t125<---164
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_65

#%printf	string	key is 2	
	li	$v0	4
	la	$a0	string7
	syscall

#%goto	LABEL_62		
	j	LABEL_62
	nop

#LABEL_65	:		
LABEL_65:

#LABEL_62	:		
LABEL_62:

#%scanf	e		
	lw	$8	-72($fp)	#e-->-72
	li	$v0	12
	syscall
	move	$8	$v0
	sw	$8	-72($fp)

#%li	$t126	97	
	li	$9	97

#$t127	e	==	$t126
	sub	$10	$8	$9
	sw	$8	-72($fp)
	sw	$10		($sp)	#$t127<---168
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_67

#%li	$t128	2	
	li	$8	2

#%printf	number	$t128	
	li	$v0	1
	move	$a0	$8
	syscall

#%goto	LABEL_66		
	sw	$8		($sp)	#$t128<---172
	subi	$sp	$sp	4
	j	LABEL_66
	nop

#LABEL_67	:		
LABEL_67:

#%li	$t129	98	
	li	$8	98

#$t130	e	==	$t129
	lw	$9	-72($fp)	#e-->-72
	sub	$10	$9	$8
	sw	$10		($sp)	#$t130<---176
	subi	$sp	$sp	4
	bne	$10	$0	LABEL_68

#%li	$t131	2	
	li	$8	2

#%li	$t132	2	
	li	$9	2

#$t133		-	$t132
	sub	$10	$0	$9

#$t134	$t131	+	$t133
	add	$11	$8	$10

#%printf	number	$t134	
	li	$v0	1
	move	$a0	$11
	syscall

#%goto	LABEL_66		
	sw	$8		($sp)	#$t131<---180
	subi	$sp	$sp	4
	j	LABEL_66
	nop

#LABEL_68	:		
LABEL_68:

#LABEL_66	:		
LABEL_66:

#%goto	LABEL_38		
	j	LABEL_38
	nop

#LABEL_61	:		
LABEL_61:

#LABEL_38	:		
LABEL_38:

#%call	nest		
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%jal	LABEL_nest		
	move	$fp	$k0
	move	$sp	$k0
	jal	LABEL_nest
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#%goto	ENDOFPROGRAM		
	j	ENDOFPROGRAM
	nop

#ENDOFPROGRAM	:		
ENDOFPROGRAM:
