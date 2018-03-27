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
	sw	$8		($sp)	#cona<--0
	subi	$sp	$sp	4
	li	$8	97
	sw	$8		($sp)	#conb<---4
	subi	$sp	$sp	4
	li	$8	54
	sw	$8		($sp)	#conc<---8
	subi	$sp	$sp	4
	sw	$8		($sp)	#_cha<---12
	subi	$sp	$sp	4
	sw	$8		($sp)	#chb#0<---16
	subi	$sp	$sp	4
	sw	$8		($sp)	#chb#1<---20
	subi	$sp	$sp	4
	sw	$8		($sp)	#chb#2<---24
	subi	$sp	$sp	4
	sw	$8		($sp)	#chb#3<---28
	subi	$sp	$sp	4
	sw	$8		($sp)	#chb#4<---32
	subi	$sp	$sp	4
	sw	$8		($sp)	#chb#5<---36
	subi	$sp	$sp	4
	sw	$8		($sp)	#chc<---40
	subi	$sp	$sp	4
	sw	$8		($sp)	#chd<---44
	subi	$sp	$sp	4
	move	$fp	$sp

#%goto	LABEL_MAIN		
	j	LABEL_MAIN
	nop

#LABEL_f	:		
LABEL_f:

#int	f	()	

#%para	int	x	

#%para	int	y	

#const int	z	=	1
	li	$8	1
	sw	$8		($sp)	#z<---8
	subi	$sp	$sp	4

#%endvardef			

#%li	$t0	1	
	li	$8	1

#$t1	x	>	$t0
	lw	$9	0($fp)	#x-->0
	sw	$9	0($fp)
	sw	$8		($sp)	#$t0<---12
	subi	$sp	$sp	4
	sub	$10	$9	$8
	blez	$10	LABEL_0

#$t2	x	+	z
	lw	$8	0($fp)	#x-->0
	lw	$9	-8($fp)	#z-->-8
	sw	$8	0($fp)
	sw	$9	-8($fp)
	add	$11	$8	$9

#%ret	$t2		
	move	$v0	$11
	sw	$11		($sp)	#$t2<---16
	subi	$sp	$sp	4
	move	$sp	$fp
	jr	$ra
	nop

#%goto	LABEL_1		
	j	LABEL_1
	nop

#LABEL_0	:		
	sw	$10		($sp)	#$t1<---20
	subi	$sp	$sp	4
LABEL_0:

#LABEL_1	:		
LABEL_1:

#%li	$t3	1	
	li	$8	1

#$t4	x	+	$t3
	lw	$9	0($fp)	#x-->0
	sw	$9	0($fp)
	sw	$8		($sp)	#$t3<---24
	subi	$sp	$sp	4
	add	$10	$9	$8

#x		=	$t4
	lw	$8	0($fp)	#x-->0
	sw	$10		($sp)	#$t4<---28
	subi	$sp	$sp	4
	add	$8	$10	$0
	sw	$8	0($fp)

#%call	f		
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
	jal	LABEL_f
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t5	x	+	y
	lw	$8	0($fp)	#x-->0
	lw	$9	-4($fp)	#y-->-4
	sw	$8	0($fp)
	sw	$9	-4($fp)
	add	$10	$8	$9

#%ret	$t5		
	move	$v0	$10
	sw	$10		($sp)	#$t5<---32
	subi	$sp	$sp	4
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

#$t0	a	>	b
	lw	$8	0($fp)	#a-->0
	lw	$9	-4($fp)	#b-->-4
	sw	$8	0($fp)
	sw	$9	-4($fp)
	sub	$10	$8	$9
	blez	$10	LABEL_2

#%li	$t1	1	
	li	$8	1

#%ret	$t1		
	move	$v0	$8
	sw	$8		($sp)	#$t1<---8
	subi	$sp	$sp	4
	move	$sp	$fp
	jr	$ra
	nop

#%goto	LABEL_3		
	j	LABEL_3
	nop

#LABEL_2	:		
	sw	$10		($sp)	#$t0<---12
	subi	$sp	$sp	4
LABEL_2:

#LABEL_3	:		
LABEL_3:

#$t2	a	<=	b
	lw	$8	0($fp)	#a-->0
	lw	$9	-4($fp)	#b-->-4
	sw	$8	0($fp)
	sw	$9	-4($fp)
	sub	$10	$8	$9
	bgtz	$10	LABEL_4

#%li	$t3	1	
	li	$8	1

#$t4		-	$t3
	sw	$8		($sp)	#$t3<---16
	subi	$sp	$sp	4
	sub	$9	$0	$8

#%ret	$t4		
	move	$v0	$9
	sw	$9		($sp)	#$t4<---20
	subi	$sp	$sp	4
	move	$sp	$fp
	jr	$ra
	nop

#%goto	LABEL_5		
	j	LABEL_5
	nop

#LABEL_4	:		
	sw	$10		($sp)	#$t2<---24
	subi	$sp	$sp	4
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
	sw	$8		($sp)	#i<---8
	subi	$sp	$sp	4

#%var	int	j	
	sw	$8		($sp)	#j<---12
	subi	$sp	$sp	4

#%var	int	stpos	100
	sw	$8		($sp)	#stpos#0<---16
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#1<---20
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#2<---24
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#3<---28
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#4<---32
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#5<---36
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#6<---40
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#7<---44
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#8<---48
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#9<---52
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#10<---56
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#11<---60
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#12<---64
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#13<---68
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#14<---72
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#15<---76
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#16<---80
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#17<---84
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#18<---88
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#19<---92
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#20<---96
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#21<---100
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#22<---104
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#23<---108
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#24<---112
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#25<---116
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#26<---120
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#27<---124
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#28<---128
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#29<---132
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#30<---136
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#31<---140
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#32<---144
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#33<---148
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#34<---152
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#35<---156
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#36<---160
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#37<---164
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#38<---168
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#39<---172
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#40<---176
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#41<---180
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#42<---184
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#43<---188
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#44<---192
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#45<---196
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#46<---200
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#47<---204
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#48<---208
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#49<---212
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#50<---216
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#51<---220
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#52<---224
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#53<---228
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#54<---232
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#55<---236
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#56<---240
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#57<---244
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#58<---248
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#59<---252
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#60<---256
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#61<---260
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#62<---264
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#63<---268
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#64<---272
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#65<---276
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#66<---280
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#67<---284
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#68<---288
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#69<---292
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#70<---296
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#71<---300
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#72<---304
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#73<---308
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#74<---312
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#75<---316
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#76<---320
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#77<---324
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#78<---328
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#79<---332
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#80<---336
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#81<---340
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#82<---344
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#83<---348
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#84<---352
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#85<---356
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#86<---360
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#87<---364
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#88<---368
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#89<---372
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#90<---376
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#91<---380
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#92<---384
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#93<---388
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#94<---392
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#95<---396
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#96<---400
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#97<---404
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#98<---408
	subi	$sp	$sp	4
	sw	$8		($sp)	#stpos#99<---412
	subi	$sp	$sp	4

#%var	int	posst	100
	sw	$8		($sp)	#posst#0<---416
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#1<---420
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#2<---424
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#3<---428
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#4<---432
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#5<---436
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#6<---440
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#7<---444
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#8<---448
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#9<---452
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#10<---456
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#11<---460
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#12<---464
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#13<---468
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#14<---472
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#15<---476
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#16<---480
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#17<---484
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#18<---488
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#19<---492
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#20<---496
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#21<---500
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#22<---504
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#23<---508
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#24<---512
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#25<---516
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#26<---520
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#27<---524
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#28<---528
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#29<---532
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#30<---536
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#31<---540
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#32<---544
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#33<---548
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#34<---552
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#35<---556
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#36<---560
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#37<---564
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#38<---568
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#39<---572
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#40<---576
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#41<---580
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#42<---584
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#43<---588
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#44<---592
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#45<---596
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#46<---600
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#47<---604
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#48<---608
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#49<---612
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#50<---616
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#51<---620
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#52<---624
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#53<---628
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#54<---632
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#55<---636
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#56<---640
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#57<---644
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#58<---648
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#59<---652
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#60<---656
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#61<---660
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#62<---664
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#63<---668
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#64<---672
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#65<---676
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#66<---680
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#67<---684
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#68<---688
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#69<---692
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#70<---696
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#71<---700
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#72<---704
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#73<---708
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#74<---712
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#75<---716
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#76<---720
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#77<---724
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#78<---728
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#79<---732
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#80<---736
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#81<---740
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#82<---744
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#83<---748
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#84<---752
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#85<---756
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#86<---760
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#87<---764
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#88<---768
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#89<---772
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#90<---776
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#91<---780
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#92<---784
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#93<---788
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#94<---792
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#95<---796
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#96<---800
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#97<---804
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#98<---808
	subi	$sp	$sp	4
	sw	$8		($sp)	#posst#99<---812
	subi	$sp	$sp	4

#%var	int	p	
	sw	$8		($sp)	#p<---816
	subi	$sp	$sp	4

#%var	int	q	
	sw	$8		($sp)	#q<---820
	subi	$sp	$sp	4

#%var	int	move	
	sw	$8		($sp)	#move<---824
	subi	$sp	$sp	4

#%var	int	end	
	sw	$8		($sp)	#end<---828
	subi	$sp	$sp	4

#%var	int	po1	
	sw	$8		($sp)	#po1<---832
	subi	$sp	$sp	4

#%var	int	po2	
	sw	$8		($sp)	#po2<---836
	subi	$sp	$sp	4

#%var	int	st2	
	sw	$8		($sp)	#st2<---840
	subi	$sp	$sp	4

#%endvardef			

#%li	$t0	1	
	li	$8	1

#i		=	$t0
	lw	$9	-8($fp)	#i-->-8
	sw	$8		($sp)	#$t0<---844
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-8($fp)

#%li	$t1	1	
	li	$8	1

#j		=	$t1
	lw	$9	-12($fp)	#j-->-12
	sw	$8		($sp)	#$t1<---848
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-12($fp)

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

#%li	$t2	1	
	li	$8	1

#$t3	i	+	$t2
	lw	$9	-8($fp)	#i-->-8
	sw	$9	-8($fp)
	sw	$8		($sp)	#$t2<---852
	subi	$sp	$sp	4
	add	$10	$9	$8

#i		=	$t3
	lw	$8	-8($fp)	#i-->-8
	sw	$10		($sp)	#$t3<---856
	subi	$sp	$sp	4
	add	$8	$10	$0
	sw	$8	-8($fp)

#LABEL_6	:		
LABEL_6:

#$t4	i	<=	n
	lw	$8	-8($fp)	#i-->-8
	lw	$9	0($fp)	#n-->0
	sw	$8	-8($fp)
	sw	$9	0($fp)
	sub	$10	$8	$9
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
	sw	$9	-8($fp)
	sw	$8		($sp)	#$t5<---860
	subi	$sp	$sp	4
	add	$11	$9	$8

#i		=	$t6
	lw	$8	-8($fp)	#i-->-8
	sw	$11		($sp)	#$t6<---864
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-8($fp)

#%goto	LABEL_6		
	j	LABEL_6
	nop

#LABEL_7	:		
	sw	$10		($sp)	#$t4<---868
	subi	$sp	$sp	4
LABEL_7:

#%li	$t7	1	
	li	$8	1

#i		=	$t7
	lw	$9	-8($fp)	#i-->-8
	sw	$8		($sp)	#$t7<---872
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-8($fp)

#%li	$t8	1	
	li	$8	1

#$t9	i	==	$t8
	lw	$9	-8($fp)	#i-->-8
	sw	$9	-8($fp)
	sw	$8		($sp)	#$t8<---876
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_8

#%li	$t10	3	
	li	$8	3

#p		=	$t10
	lw	$9	-816($fp)	#p-->-816
	sw	$8		($sp)	#$t10<---880
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-816($fp)

#%li	$t11	2	
	li	$8	2

#q		=	$t11
	lw	$9	-820($fp)	#q-->-820
	sw	$8		($sp)	#$t11<---884
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-820($fp)

#%goto	LABEL_9		
	j	LABEL_9
	nop

#LABEL_8	:		
	sw	$10		($sp)	#$t9<---888
	subi	$sp	$sp	4
LABEL_8:

#LABEL_9	:		
LABEL_9:

#%li	$t12	2	
	li	$8	2

#$t13	i	==	$t12
	lw	$9	-8($fp)	#i-->-8
	sw	$9	-8($fp)
	sw	$8		($sp)	#$t12<---892
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_10

#%li	$t14	8	
	li	$8	8

#p		=	$t14
	lw	$9	-816($fp)	#p-->-816
	sw	$8		($sp)	#$t14<---896
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-816($fp)

#%li	$t15	3	
	li	$8	3

#$t16		-	$t15
	sw	$8		($sp)	#$t15<---900
	subi	$sp	$sp	4
	sub	$9	$0	$8

#q		=	$t16
	lw	$8	-820($fp)	#q-->-820
	sw	$9		($sp)	#$t16<---904
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-820($fp)

#%goto	LABEL_11		
	j	LABEL_11
	nop

#LABEL_10	:		
	sw	$10		($sp)	#$t13<---908
	subi	$sp	$sp	4
LABEL_10:

#LABEL_11	:		
LABEL_11:

#%li	$t17	3	
	li	$8	3

#$t18	i	==	$t17
	lw	$9	-8($fp)	#i-->-8
	sw	$9	-8($fp)
	sw	$8		($sp)	#$t17<---912
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_12

#%li	$t19	3	
	li	$8	3

#p		=	$t19
	lw	$9	-816($fp)	#p-->-816
	sw	$8		($sp)	#$t19<---916
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-816($fp)

#%li	$t20	2	
	li	$8	2

#$t21		-	$t20
	sw	$8		($sp)	#$t20<---920
	subi	$sp	$sp	4
	sub	$9	$0	$8

#q		=	$t21
	lw	$8	-820($fp)	#q-->-820
	sw	$9		($sp)	#$t21<---924
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-820($fp)

#%goto	LABEL_13		
	j	LABEL_13
	nop

#LABEL_12	:		
	sw	$10		($sp)	#$t18<---928
	subi	$sp	$sp	4
LABEL_12:

#LABEL_13	:		
LABEL_13:

#%li	$t22	0	
	li	$8	0

#$t23	q	!=	$t22
	lw	$9	-820($fp)	#q-->-820
	sw	$9	-820($fp)
	sw	$8		($sp)	#$t22<---932
	subi	$sp	$sp	4
	sub	$10	$9	$8
	beq	$10	$0	LABEL_14

#%call	compare		
	sw	$10		($sp)	#$t23<---936
	subi	$sp	$sp	4
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
	sw	$8		($sp)	#$t25<---940
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-824($fp)

#$t26	move	*	q
	lw	$8	-824($fp)	#move-->-824
	lw	$9	-820($fp)	#q-->-820
	sw	$8	-824($fp)
	sw	$9	-820($fp)
	mult	$8	$9
	mflo	$10

#end		=	$t26
	lw	$8	-828($fp)	#end-->-828
	sw	$10		($sp)	#$t26<---944
	subi	$sp	$sp	4
	add	$8	$10	$0
	sw	$8	-828($fp)

#$t27	=	stpos	p
	lw	$8	-816($fp)	#p-->-816
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$9	$9	$fp
	lw	$10	-16($9)
	move	$9	$10

#po1		=	$t27
	lw	$8	-832($fp)	#po1-->-832
	sw	$9		($sp)	#$t27<---948
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-832($fp)

#$t28	po1	+	move
	lw	$8	-832($fp)	#po1-->-832
	lw	$9	-824($fp)	#move-->-824
	sw	$8	-832($fp)
	sw	$9	-824($fp)
	add	$10	$8	$9

#$t29	=	posst	$t28
	li	$8	-4
	mul	$8	$10	$8
	lw	$9	-416($fp)	#posst#0-->-416
	add	$8	$8	$fp
	lw	$10	-416($8)
	move	$8	$10

#st2		=	$t29
	lw	$9	-840($fp)	#st2-->-840
	sw	$8		($sp)	#$t29<---952
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-840($fp)

#$t30	=	stpos	st2
	lw	$8	-840($fp)	#st2-->-840
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$9	$9	$fp
	lw	$10	-16($9)
	move	$9	$10

#po2		=	$t30
	lw	$8	-836($fp)	#po2-->-836
	sw	$9		($sp)	#$t30<---956
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-836($fp)

#posst	po1	=	st2
	lw	$8	-840($fp)	#st2-->-840
	lw	$9	-832($fp)	#po1-->-832
	li	$10	-4
	mul	$10	$9	$10
	lw	$9	-416($fp)	#posst#0-->-416
	add	$10	$10	$fp
	sw	$8	-416($10)

#stpos	st2	=	po1
	lw	$9	-832($fp)	#po1-->-832
	li	$10	-4
	mul	$10	$8	$10
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$10	$10	$fp
	sw	$9	-16($10)

#po1		=	po2
	lw	$8	-836($fp)	#po2-->-836
	sw	$8	-836($fp)
	add	$9	$8	$0
	sw	$9	-832($fp)

#%li	$t31	1	
	li	$8	1

#$t32	j	+	$t31
	lw	$9	-12($fp)	#j-->-12
	sw	$9	-12($fp)
	sw	$8		($sp)	#$t31<---960
	subi	$sp	$sp	4
	add	$10	$9	$8

#j		=	$t32
	lw	$8	-12($fp)	#j-->-12
	sw	$10		($sp)	#$t32<---964
	subi	$sp	$sp	4
	add	$8	$10	$0
	sw	$8	-12($fp)

#LABEL_16	:		
LABEL_16:

#$t33	j	<=	end
	lw	$8	-12($fp)	#j-->-12
	lw	$9	-828($fp)	#end-->-828
	sw	$8	-12($fp)
	sw	$9	-828($fp)
	sub	$10	$8	$9
	bgtz	$10	LABEL_17

#$t34	po1	+	move
	lw	$8	-832($fp)	#po1-->-832
	lw	$9	-824($fp)	#move-->-824
	sw	$8	-832($fp)
	sw	$9	-824($fp)
	add	$11	$8	$9

#$t35	=	posst	$t34
	li	$8	-4
	mul	$8	$11	$8
	lw	$9	-416($fp)	#posst#0-->-416
	add	$8	$8	$fp
	lw	$11	-416($8)
	move	$8	$11

#st2		=	$t35
	lw	$9	-840($fp)	#st2-->-840
	sw	$8		($sp)	#$t35<---968
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-840($fp)

#$t36	=	stpos	st2
	lw	$8	-840($fp)	#st2-->-840
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$9	$9	$fp
	lw	$11	-16($9)
	move	$9	$11

#po2		=	$t36
	lw	$8	-836($fp)	#po2-->-836
	sw	$9		($sp)	#$t36<---972
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-836($fp)

#posst	po1	=	st2
	lw	$8	-840($fp)	#st2-->-840
	lw	$9	-832($fp)	#po1-->-832
	li	$11	-4
	mul	$11	$9	$11
	lw	$9	-416($fp)	#posst#0-->-416
	add	$11	$11	$fp
	sw	$8	-416($11)

#stpos	st2	=	po1
	lw	$9	-832($fp)	#po1-->-832
	li	$11	-4
	mul	$11	$8	$11
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$11	$11	$fp
	sw	$9	-16($11)

#po1		=	po2
	lw	$8	-836($fp)	#po2-->-836
	sw	$8	-836($fp)
	add	$9	$8	$0
	sw	$9	-832($fp)

#%li	$t37	1	
	li	$8	1

#$t38	j	+	$t37
	lw	$9	-12($fp)	#j-->-12
	sw	$9	-12($fp)
	sw	$8		($sp)	#$t37<---976
	subi	$sp	$sp	4
	add	$11	$9	$8

#j		=	$t38
	lw	$8	-12($fp)	#j-->-12
	sw	$11		($sp)	#$t38<---980
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-12($fp)

#%goto	LABEL_16		
	j	LABEL_16
	nop

#LABEL_17	:		
	sw	$10		($sp)	#$t33<---984
	subi	$sp	$sp	4
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
	sw	$9		($sp)	#$t39<---988
	subi	$sp	$sp	4
	sw	$8	-820($fp)
	add	$10	$9	$8

#stpos	p	=	$t40
	lw	$8	-816($fp)	#p-->-816
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$9	$9	$fp
	sw	$10	-16($9)

#%goto	LABEL_15		
	j	LABEL_15
	nop

#LABEL_14	:		
	sw	$10		($sp)	#$t40<---992
	subi	$sp	$sp	4
LABEL_14:

#LABEL_15	:		
LABEL_15:

#%li	$t41	1	
	li	$8	1

#$t42	i	+	$t41
	lw	$9	-8($fp)	#i-->-8
	sw	$9	-8($fp)
	sw	$8		($sp)	#$t41<---996
	subi	$sp	$sp	4
	add	$10	$9	$8

#i		=	$t42
	lw	$8	-8($fp)	#i-->-8
	sw	$10		($sp)	#$t42<---1000
	subi	$sp	$sp	4
	add	$8	$10	$0
	sw	$8	-8($fp)

#LABEL_18	:		
LABEL_18:

#$t43	i	<=	m
	lw	$8	-8($fp)	#i-->-8
	lw	$9	-4($fp)	#m-->-4
	sw	$8	-8($fp)
	sw	$9	-4($fp)
	sub	$10	$8	$9
	bgtz	$10	LABEL_19

#%li	$t44	1	
	li	$8	1

#$t45	i	==	$t44
	lw	$9	-8($fp)	#i-->-8
	sw	$9	-8($fp)
	sw	$8		($sp)	#$t44<---1004
	subi	$sp	$sp	4
	sub	$11	$9	$8
	bne	$11	$0	LABEL_20

#%li	$t46	3	
	li	$8	3

#p		=	$t46
	lw	$9	-816($fp)	#p-->-816
	sw	$8		($sp)	#$t46<---1008
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-816($fp)

#%li	$t47	2	
	li	$8	2

#q		=	$t47
	lw	$9	-820($fp)	#q-->-820
	sw	$8		($sp)	#$t47<---1012
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-820($fp)

#%goto	LABEL_21		
	j	LABEL_21
	nop

#LABEL_20	:		
	sw	$10		($sp)	#$t43<---1016
	subi	$sp	$sp	4
	sw	$11		($sp)	#$t45<---1020
	subi	$sp	$sp	4
LABEL_20:

#LABEL_21	:		
LABEL_21:

#%li	$t48	2	
	li	$8	2

#$t49	i	==	$t48
	lw	$9	-8($fp)	#i-->-8
	sw	$9	-8($fp)
	sw	$8		($sp)	#$t48<---1024
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_22

#%li	$t50	8	
	li	$8	8

#p		=	$t50
	lw	$9	-816($fp)	#p-->-816
	sw	$8		($sp)	#$t50<---1028
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-816($fp)

#%li	$t51	3	
	li	$8	3

#$t52		-	$t51
	sw	$8		($sp)	#$t51<---1032
	subi	$sp	$sp	4
	sub	$9	$0	$8

#q		=	$t52
	lw	$8	-820($fp)	#q-->-820
	sw	$9		($sp)	#$t52<---1036
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-820($fp)

#%goto	LABEL_23		
	j	LABEL_23
	nop

#LABEL_22	:		
	sw	$10		($sp)	#$t49<---1040
	subi	$sp	$sp	4
LABEL_22:

#LABEL_23	:		
LABEL_23:

#%li	$t53	3	
	li	$8	3

#$t54	i	==	$t53
	lw	$9	-8($fp)	#i-->-8
	sw	$9	-8($fp)
	sw	$8		($sp)	#$t53<---1044
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_24

#%li	$t55	3	
	li	$8	3

#p		=	$t55
	lw	$9	-816($fp)	#p-->-816
	sw	$8		($sp)	#$t55<---1048
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-816($fp)

#%li	$t56	2	
	li	$8	2

#$t57		-	$t56
	sw	$8		($sp)	#$t56<---1052
	subi	$sp	$sp	4
	sub	$9	$0	$8

#q		=	$t57
	lw	$8	-820($fp)	#q-->-820
	sw	$9		($sp)	#$t57<---1056
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-820($fp)

#%goto	LABEL_25		
	j	LABEL_25
	nop

#LABEL_24	:		
	sw	$10		($sp)	#$t54<---1060
	subi	$sp	$sp	4
LABEL_24:

#LABEL_25	:		
LABEL_25:

#%li	$t58	0	
	li	$8	0

#$t59	q	!=	$t58
	lw	$9	-820($fp)	#q-->-820
	sw	$9	-820($fp)
	sw	$8		($sp)	#$t58<---1064
	subi	$sp	$sp	4
	sub	$10	$9	$8
	beq	$10	$0	LABEL_26

#%call	compare		
	sw	$10		($sp)	#$t59<---1068
	subi	$sp	$sp	4
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
	sw	$8		($sp)	#$t61<---1072
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-824($fp)

#$t62	move	*	q
	lw	$8	-824($fp)	#move-->-824
	lw	$9	-820($fp)	#q-->-820
	sw	$8	-824($fp)
	sw	$9	-820($fp)
	mult	$8	$9
	mflo	$10

#end		=	$t62
	lw	$8	-828($fp)	#end-->-828
	sw	$10		($sp)	#$t62<---1076
	subi	$sp	$sp	4
	add	$8	$10	$0
	sw	$8	-828($fp)

#$t63	=	stpos	p
	lw	$8	-816($fp)	#p-->-816
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$9	$9	$fp
	lw	$10	-16($9)
	move	$9	$10

#po1		=	$t63
	lw	$8	-832($fp)	#po1-->-832
	sw	$9		($sp)	#$t63<---1080
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-832($fp)

#$t64	po1	+	move
	lw	$8	-832($fp)	#po1-->-832
	lw	$9	-824($fp)	#move-->-824
	sw	$8	-832($fp)
	sw	$9	-824($fp)
	add	$10	$8	$9

#$t65	=	posst	$t64
	li	$8	-4
	mul	$8	$10	$8
	lw	$9	-416($fp)	#posst#0-->-416
	add	$8	$8	$fp
	lw	$10	-416($8)
	move	$8	$10

#st2		=	$t65
	lw	$9	-840($fp)	#st2-->-840
	sw	$8		($sp)	#$t65<---1084
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-840($fp)

#$t66	=	stpos	st2
	lw	$8	-840($fp)	#st2-->-840
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$9	$9	$fp
	lw	$10	-16($9)
	move	$9	$10

#po2		=	$t66
	lw	$8	-836($fp)	#po2-->-836
	sw	$9		($sp)	#$t66<---1088
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-836($fp)

#posst	po1	=	st2
	lw	$8	-840($fp)	#st2-->-840
	lw	$9	-832($fp)	#po1-->-832
	li	$10	-4
	mul	$10	$9	$10
	lw	$9	-416($fp)	#posst#0-->-416
	add	$10	$10	$fp
	sw	$8	-416($10)

#stpos	st2	=	po1
	lw	$9	-832($fp)	#po1-->-832
	li	$10	-4
	mul	$10	$8	$10
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$10	$10	$fp
	sw	$9	-16($10)

#po1		=	po2
	lw	$8	-836($fp)	#po2-->-836
	sw	$8	-836($fp)
	add	$9	$8	$0
	sw	$9	-832($fp)

#%li	$t67	1	
	li	$8	1

#$t68	j	+	$t67
	lw	$9	-12($fp)	#j-->-12
	sw	$9	-12($fp)
	sw	$8		($sp)	#$t67<---1092
	subi	$sp	$sp	4
	add	$10	$9	$8

#j		=	$t68
	lw	$8	-12($fp)	#j-->-12
	sw	$10		($sp)	#$t68<---1096
	subi	$sp	$sp	4
	add	$8	$10	$0
	sw	$8	-12($fp)

#LABEL_28	:		
LABEL_28:

#$t69	j	<=	end
	lw	$8	-12($fp)	#j-->-12
	lw	$9	-828($fp)	#end-->-828
	sw	$8	-12($fp)
	sw	$9	-828($fp)
	sub	$10	$8	$9
	bgtz	$10	LABEL_29

#$t70	po1	+	move
	lw	$8	-832($fp)	#po1-->-832
	lw	$9	-824($fp)	#move-->-824
	sw	$8	-832($fp)
	sw	$9	-824($fp)
	add	$11	$8	$9

#$t71	=	posst	$t70
	li	$8	-4
	mul	$8	$11	$8
	lw	$9	-416($fp)	#posst#0-->-416
	add	$8	$8	$fp
	lw	$11	-416($8)
	move	$8	$11

#st2		=	$t71
	lw	$9	-840($fp)	#st2-->-840
	sw	$8		($sp)	#$t71<---1100
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-840($fp)

#$t72	=	stpos	st2
	lw	$8	-840($fp)	#st2-->-840
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$9	$9	$fp
	lw	$11	-16($9)
	move	$9	$11

#po2		=	$t72
	lw	$8	-836($fp)	#po2-->-836
	sw	$9		($sp)	#$t72<---1104
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-836($fp)

#posst	po1	=	st2
	lw	$8	-840($fp)	#st2-->-840
	lw	$9	-832($fp)	#po1-->-832
	li	$11	-4
	mul	$11	$9	$11
	lw	$9	-416($fp)	#posst#0-->-416
	add	$11	$11	$fp
	sw	$8	-416($11)

#stpos	st2	=	po1
	lw	$9	-832($fp)	#po1-->-832
	li	$11	-4
	mul	$11	$8	$11
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$11	$11	$fp
	sw	$9	-16($11)

#po1		=	po2
	lw	$8	-836($fp)	#po2-->-836
	sw	$8	-836($fp)
	add	$9	$8	$0
	sw	$9	-832($fp)

#%li	$t73	1	
	li	$8	1

#$t74	j	+	$t73
	lw	$9	-12($fp)	#j-->-12
	sw	$9	-12($fp)
	sw	$8		($sp)	#$t73<---1108
	subi	$sp	$sp	4
	add	$11	$9	$8

#j		=	$t74
	lw	$8	-12($fp)	#j-->-12
	sw	$11		($sp)	#$t74<---1112
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-12($fp)

#%goto	LABEL_28		
	j	LABEL_28
	nop

#LABEL_29	:		
	sw	$10		($sp)	#$t69<---1116
	subi	$sp	$sp	4
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
	sw	$9		($sp)	#$t75<---1120
	subi	$sp	$sp	4
	sw	$8	-820($fp)
	add	$10	$9	$8

#stpos	p	=	$t76
	lw	$8	-816($fp)	#p-->-816
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-16($fp)	#stpos#0-->-16
	add	$9	$9	$fp
	sw	$10	-16($9)

#%goto	LABEL_27		
	j	LABEL_27
	nop

#LABEL_26	:		
	sw	$10		($sp)	#$t76<---1124
	subi	$sp	$sp	4
LABEL_26:

#LABEL_27	:		
LABEL_27:

#%li	$t77	1	
	li	$8	1

#$t78	i	+	$t77
	lw	$9	-8($fp)	#i-->-8
	sw	$9	-8($fp)
	sw	$8		($sp)	#$t77<---1128
	subi	$sp	$sp	4
	add	$10	$9	$8

#i		=	$t78
	lw	$8	-8($fp)	#i-->-8
	sw	$10		($sp)	#$t78<---1132
	subi	$sp	$sp	4
	add	$8	$10	$0
	sw	$8	-8($fp)

#%goto	LABEL_18		
	j	LABEL_18
	nop

#LABEL_19	:		
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
	sw	$8		($sp)	#$t81<---1136
	subi	$sp	$sp	4
	add	$10	$8	$0
	sw	$10	-8($fp)

#$t82	=	posst	i
	lw	$8	-8($fp)	#i-->-8
	li	$10	-4
	mul	$10	$8	$10
	lw	$8	-416($fp)	#posst#0-->-416
	add	$10	$10	$fp
	lw	$11	-416($10)
	move	$10	$11

#%printf	number	$t82	
	li	$v0	1
	move	$a0	$10
	syscall

#%li	$t83	1	
	li	$8	1

#$t84	i	+	$t83
	lw	$11	-8($fp)	#i-->-8
	sw	$11	-8($fp)
	sw	$8		($sp)	#$t83<---1140
	subi	$sp	$sp	4
	add	$12	$11	$8

#i		=	$t84
	lw	$8	-8($fp)	#i-->-8
	sw	$12		($sp)	#$t84<---1144
	subi	$sp	$sp	4
	add	$8	$12	$0
	sw	$8	-8($fp)

#LABEL_30	:		
	sw	$9		($sp)	#$t80<---1148
	subi	$sp	$sp	4
	sw	$10		($sp)	#$t82<---1152
	subi	$sp	$sp	4
LABEL_30:

#$t85	i	<=	n
	lw	$8	-8($fp)	#i-->-8
	lw	$9	0($fp)	#n-->0
	sw	$8	-8($fp)
	sw	$9	0($fp)
	sub	$10	$8	$9
	bgtz	$10	LABEL_31

#$t86	=	posst	i
	lw	$8	-8($fp)	#i-->-8
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-416($fp)	#posst#0-->-416
	add	$9	$9	$fp
	lw	$11	-416($9)
	move	$9	$11

#%printf	number	$t86	
	li	$v0	1
	move	$a0	$9
	syscall

#%li	$t87	1	
	li	$8	1

#$t88	i	+	$t87
	lw	$11	-8($fp)	#i-->-8
	sw	$11	-8($fp)
	sw	$8		($sp)	#$t87<---1156
	subi	$sp	$sp	4
	add	$12	$11	$8

#i		=	$t88
	lw	$8	-8($fp)	#i-->-8
	sw	$12		($sp)	#$t88<---1160
	subi	$sp	$sp	4
	add	$8	$12	$0
	sw	$8	-8($fp)

#%goto	LABEL_30		
	j	LABEL_30
	nop

#LABEL_31	:		
	sw	$9		($sp)	#$t86<---1164
	subi	$sp	$sp	4
	sw	$10		($sp)	#$t85<---1168
	subi	$sp	$sp	4
LABEL_31:

#%ret	$t88		
	lw	$8	-1160($fp)	#$t88-->-1160
	move	$v0	$8
	sw	$8	-1160($fp)
	move	$sp	$fp
	jr	$ra
	nop

#%end			

#LABEL_f2	:		
LABEL_f2:

#char	f2	()	

#%para	char	x	

#%var	int	z2	
	sw	$8		($sp)	#z2<---4
	subi	$sp	$sp	4

#%endvardef			

#%li	$t0	1	
	li	$8	1

#z2		=	$t0
	lw	$9	-4($fp)	#z2-->-4
	sw	$8		($sp)	#$t0<---8
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-4($fp)

#$t1	x	+	z2
	lw	$8	0($fp)	#x-->0
	lw	$9	-4($fp)	#z2-->-4
	sw	$8	0($fp)
	sw	$9	-4($fp)
	add	$10	$8	$9

#x		=	$t1
	lw	$8	0($fp)	#x-->0
	sw	$10		($sp)	#$t1<---12
	subi	$sp	$sp	4
	add	$8	$10	$0
	sw	$8	0($fp)

#%ret	x		
	lw	$8	0($fp)	#x-->0
	move	$v0	$8
	sw	$8	0($fp)
	move	$sp	$fp
	jr	$ra
	nop

#%end			

#LABEL_fib	:		
LABEL_fib:

#int	fib	()	

#%para	int	n	

#%var	int	result	
	sw	$8		($sp)	#result<---4
	subi	$sp	$sp	4

#%endvardef			

#%li	$t0	0	
	li	$8	0

#$t1	n	==	$t0
	lw	$9	0($fp)	#n-->0
	sw	$9	0($fp)
	sw	$8		($sp)	#$t0<---8
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_32

#%li	$t2	0	
	li	$8	0

#%ret	$t2		
	move	$v0	$8
	sw	$8		($sp)	#$t2<---12
	subi	$sp	$sp	4
	move	$sp	$fp
	jr	$ra
	nop

#%goto	LABEL_33		
	j	LABEL_33
	nop

#LABEL_32	:		
	sw	$10		($sp)	#$t1<---16
	subi	$sp	$sp	4
LABEL_32:

#LABEL_33	:		
LABEL_33:

#%li	$t3	1	
	li	$8	1

#$t4	n	==	$t3
	lw	$9	0($fp)	#n-->0
	sw	$9	0($fp)
	sw	$8		($sp)	#$t3<---20
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_34

#%li	$t5	1	
	li	$8	1

#%ret	$t5		
	move	$v0	$8
	sw	$8		($sp)	#$t5<---24
	subi	$sp	$sp	4
	move	$sp	$fp
	jr	$ra
	nop

#%goto	LABEL_35		
	j	LABEL_35
	nop

#LABEL_34	:		
	sw	$10		($sp)	#$t4<---28
	subi	$sp	$sp	4
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
	sw	$9	0($fp)
	sw	$8		($sp)	#$t6<--0
	subi	$sp	$sp	4
	sub	$10	$9	$8

#%push	$t7		
	addi	$sp	$sp	4
	sw	$10	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_fib		
	move	$fp	$k0
	jal	LABEL_fib
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t8	=	RET	
	move	$8	$v0

#%call	fib		
	sw	$8		($sp)	#$t8<---32
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
	sw	$9	0($fp)
	sw	$8		($sp)	#$t9<--0
	subi	$sp	$sp	4
	sub	$10	$9	$8

#%push	$t10		
	addi	$sp	$sp	4
	sw	$10	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_fib		
	move	$fp	$k0
	jal	LABEL_fib
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#$t11	=	RET	
	move	$8	$v0

#$t12	$t8	+	$t11
	lw	$9	-32($fp)	#$t8-->-32
	sw	$9	-32($fp)
	sw	$8		($sp)	#$t11<---36
	subi	$sp	$sp	4
	add	$10	$9	$8

#result		=	$t12
	lw	$8	-4($fp)	#result-->-4
	sw	$10		($sp)	#$t12<---40
	subi	$sp	$sp	4
	add	$8	$10	$0
	sw	$8	-4($fp)

#%ret	result		
	lw	$8	-4($fp)	#result-->-4
	move	$v0	$8
	sw	$8	-4($fp)
	move	$sp	$fp
	jr	$ra
	nop

#%end			

#LABEL_nest	:		
LABEL_nest:

#void	nest	()	

#%var	int	a	15
	sw	$8		($sp)	#a#0<--0
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#1<---4
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#2<---8
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#3<---12
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#4<---16
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#5<---20
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#6<---24
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#7<---28
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#8<---32
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#9<---36
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#10<---40
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#11<---44
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#12<---48
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#13<---52
	subi	$sp	$sp	4
	sw	$8		($sp)	#a#14<---56
	subi	$sp	$sp	4

#%var	int	b	15
	sw	$8		($sp)	#b#0<---60
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#1<---64
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#2<---68
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#3<---72
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#4<---76
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#5<---80
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#6<---84
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#7<---88
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#8<---92
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#9<---96
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#10<---100
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#11<---104
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#12<---108
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#13<---112
	subi	$sp	$sp	4
	sw	$8		($sp)	#b#14<---116
	subi	$sp	$sp	4

#%endvardef			

#%li	$t0	1	
	li	$8	1

#a	0	=	$t0
	lw	$9	0($fp)	#a#0-->0
	sw	$8		($sp)	#$t0<---120
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	0($fp)

#%li	$t1	3	
	li	$8	3

#b	1	=	$t1
	lw	$9	-64($fp)	#b#1-->-64
	sw	$8		($sp)	#$t1<---124
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-64($fp)

#%li	$t2	4	
	li	$8	4

#a	3	=	$t2
	lw	$9	-12($fp)	#a#3-->-12
	sw	$8		($sp)	#$t2<---128
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-12($fp)

#%li	$t3	6	
	li	$8	6

#b	4	=	$t3
	lw	$9	-76($fp)	#b#4-->-76
	sw	$8		($sp)	#$t3<---132
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-76($fp)

#%li	$t4	8	
	li	$8	8

#a	6	=	$t4
	lw	$9	-24($fp)	#a#6-->-24
	sw	$8		($sp)	#$t4<---136
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-24($fp)

#%li	$t5	0	
	li	$8	0

#$t6	=	a	$t5
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	0($fp)	#a#0-->0
	add	$9	$9	$fp
	lw	$10	0($9)
	move	$9	$10

#$t7	=	b	$t6
	li	$8	-4
	mul	$8	$9	$8
	lw	$9	-60($fp)	#b#0-->-60
	add	$8	$8	$fp
	lw	$10	-60($8)
	move	$8	$10

#$t8	=	a	$t7
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	0($fp)	#a#0-->0
	add	$9	$9	$fp
	lw	$10	0($9)
	move	$9	$10

#$t9	=	b	$t8
	li	$8	-4
	mul	$8	$9	$8
	lw	$9	-60($fp)	#b#0-->-60
	add	$8	$8	$fp
	lw	$10	-60($8)
	move	$8	$10

#$t10	=	a	$t9
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	0($fp)	#a#0-->0
	add	$9	$9	$fp
	lw	$10	0($9)
	move	$9	$10

#%li	$t11	2333	
	li	$8	2333

#b	$t10	=	$t11
	li	$10	-4
	mul	$10	$9	$10
	lw	$9	-60($fp)	#b#0-->-60
	add	$10	$10	$fp
	sw	$8	-60($10)

#%li	$t12	0	
	li	$9	0

#$t13	=	a	$t12
	li	$10	-4
	mul	$10	$9	$10
	lw	$9	0($fp)	#a#0-->0
	add	$10	$10	$fp
	lw	$11	0($10)
	move	$10	$11

#%li	$t14	8	
	li	$9	8

#$t15	=	b	$t14
	li	$11	-4
	mul	$11	$9	$11
	lw	$9	-60($fp)	#b#0-->-60
	add	$11	$11	$fp
	lw	$12	-60($11)
	move	$11	$12

#$t16	$t13	+	$t15
	sw	$10		($sp)	#$t13<---140
	subi	$sp	$sp	4
	sw	$11		($sp)	#$t15<---144
	subi	$sp	$sp	4
	add	$9	$10	$11

#%printf	number	$t16	
	li	$v0	1
	move	$a0	$9
	syscall

#%ret	$t16		
	move	$v0	$9
	sw	$9		($sp)	#$t16<---148
	subi	$sp	$sp	4
	move	$sp	$fp
	jr	$ra
	nop

#%end			

#LABEL_t	:		
LABEL_t:

#void	t	()	

#%para	char	x	

#%endvardef			

#%li	$t0	99	
	li	$8	99

#$t1	x	>	$t0
	lw	$9	0($fp)	#x-->0
	sw	$9	0($fp)
	sw	$8		($sp)	#$t0<---4
	subi	$sp	$sp	4
	sub	$10	$9	$8
	blez	$10	LABEL_36

#%ret	$t1		
	move	$v0	$10
	sw	$10		($sp)	#$t1<---8
	subi	$sp	$sp	4
	move	$sp	$fp
	jr	$ra
	nop

#%goto	LABEL_37		
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
	sw	$9	0($fp)
	sw	$8		($sp)	#$t2<---12
	subi	$sp	$sp	4
	add	$10	$9	$8

#x		=	$t3
	lw	$8	0($fp)	#x-->0
	sw	$10		($sp)	#$t3<---16
	subi	$sp	$sp	4
	add	$8	$10	$0
	sw	$8	0($fp)

#%printf	number	x	
	lw	$8	0($fp)	#x-->0
	li	$v0	11
	move	$a0	$8
	syscall

#%call	t		
	sw	$8	0($fp)
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
	jal	LABEL_t
	nop
	addi	$sp	$sp	12
	lw	$k0	($sp)
	lw	$fp	-4($sp)
	lw	$ra	-8($sp)

#%ret	x		
	lw	$8	0($fp)	#x-->0
	move	$v0	$8
	sw	$8	0($fp)
	move	$sp	$fp
	jr	$ra
	nop

#%end			

#LABEL_MAIN	:		
LABEL_MAIN:

#void	main	()	

#const int	coz	=	3
	li	$8	3
	sw	$8		($sp)	#coz<--0
	subi	$sp	$sp	4

#%var	int	a	
	sw	$8		($sp)	#a<---4
	subi	$sp	$sp	4

#%var	int	b	
	sw	$8		($sp)	#b<---8
	subi	$sp	$sp	4

#%var	int	c	
	sw	$8		($sp)	#c<---12
	subi	$sp	$sp	4

#%var	int	d	
	sw	$8		($sp)	#d<---16
	subi	$sp	$sp	4

#%var	int	key	
	sw	$8		($sp)	#key<---20
	subi	$sp	$sp	4

#%var	int	i	
	sw	$8		($sp)	#i<---24
	subi	$sp	$sp	4

#%var	int	sz2	5
	sw	$8		($sp)	#sz2#0<---28
	subi	$sp	$sp	4
	sw	$8		($sp)	#sz2#1<---32
	subi	$sp	$sp	4
	sw	$8		($sp)	#sz2#2<---36
	subi	$sp	$sp	4
	sw	$8		($sp)	#sz2#3<---40
	subi	$sp	$sp	4
	sw	$8		($sp)	#sz2#4<---44
	subi	$sp	$sp	4

#%var	int	cho	
	sw	$8		($sp)	#cho<---48
	subi	$sp	$sp	4

#%var	char	sz	5
	sw	$8		($sp)	#sz#0<---52
	subi	$sp	$sp	4
	sw	$8		($sp)	#sz#1<---56
	subi	$sp	$sp	4
	sw	$8		($sp)	#sz#2<---60
	subi	$sp	$sp	4
	sw	$8		($sp)	#sz#3<---64
	subi	$sp	$sp	4
	sw	$8		($sp)	#sz#4<---68
	subi	$sp	$sp	4

#%var	char	e	
	sw	$8		($sp)	#e<---72
	subi	$sp	$sp	4

#%endvardef			

#%li	$t0	43	
	li	$8	43

#chc		=	$t0
	lw	$9	-40($gp)	#chc-->-40
	sw	$8		($sp)	#$t0<---76
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-40($gp)

#%li	$t1	45	
	li	$8	45

#chd		=	$t1
	lw	$9	-44($gp)	#chd-->-44
	sw	$8		($sp)	#$t1<---80
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-44($gp)

#%li	$t2	3	
	li	$8	3

#b		=	$t2
	lw	$9	-8($fp)	#b-->-8
	sw	$8		($sp)	#$t2<---84
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-8($fp)

#%li	$t3	0	
	li	$8	0

#i		=	$t3
	lw	$9	-24($fp)	#i-->-24
	sw	$8		($sp)	#$t3<---88
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-24($fp)

#%li	$t4	2	
	li	$8	2

#$t5		-	$t4
	sw	$8		($sp)	#$t4<---92
	subi	$sp	$sp	4
	sub	$9	$0	$8

#c		=	$t5
	lw	$8	-12($fp)	#c-->-12
	sw	$9		($sp)	#$t5<---96
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-12($fp)

#%li	$t6	1	
	li	$8	1

#key		=	$t6
	lw	$9	-20($fp)	#key-->-20
	sw	$8		($sp)	#$t6<---100
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-20($fp)

#%scanf	cho		
	lw	$8	-48($fp)	#cho-->-48
	li	$v0	5
	syscall
	move	$8	$v0
	sw	$8	-48($fp)

#%li	$t7	0	
	li	$8	0

#$t8	cho	==	$t7
	lw	$9	-48($fp)	#cho-->-48
	sw	$9	-48($fp)
	sw	$8		($sp)	#$t7<---104
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_39

#%printf	string	test line:	
	li	$v0	4
	la	$a0	string0
	syscall

#%call	line		
	sw	$10		($sp)	#$t8<---108
	subi	$sp	$sp	4
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
	sw	$9	-48($fp)
	sw	$8		($sp)	#$t11<---112
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_40

#%printf	string	test fib:	
	li	$v0	4
	la	$a0	string1
	syscall

#%call	fib		
	sw	$10		($sp)	#$t12<---116
	subi	$sp	$sp	4
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
	sw	$8		($sp)	#$t13<---120
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-16($fp)

#%printf	string	fib=	
	li	$v0	4
	la	$a0	string2
	syscall

#%printf	number	d	
	lw	$8	-16($fp)	#d-->-16
	li	$v0	1
	move	$a0	$8
	syscall

#%goto	LABEL_38		
	j	LABEL_38
	nop

#LABEL_40	:		
	sw	$8	-16($fp)
LABEL_40:

#%li	$t14	2	
	li	$8	2

#$t15	cho	==	$t14
	lw	$9	-48($fp)	#cho-->-48
	sw	$9	-48($fp)
	sw	$8		($sp)	#$t14<---124
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_41

#%li	$t16	97	
	li	$8	97

#sz	i	=	$t16
	lw	$9	-24($fp)	#i-->-24
	li	$11	-4
	mul	$11	$9	$11
	lw	$9	-52($fp)	#sz#0-->-52
	add	$11	$11	$fp
	sw	$8	-52($11)

#sz2	i	=	i
	lw	$9	-24($fp)	#i-->-24
	li	$11	-4
	mul	$11	$9	$11
	lw	$9	-28($fp)	#sz2#0-->-28
	add	$11	$11	$fp
	sw	$9	-28($11)

#%li	$t17	1	
	li	$9	1

#$t18	i	+	$t17
	lw	$11	-24($fp)	#i-->-24
	sw	$11	-24($fp)
	sw	$9		($sp)	#$t17<---128
	subi	$sp	$sp	4
	add	$12	$11	$9

#i		=	$t18
	lw	$9	-24($fp)	#i-->-24
	sw	$12		($sp)	#$t18<---132
	subi	$sp	$sp	4
	add	$9	$12	$0
	sw	$9	-24($fp)

#LABEL_42	:		
	sw	$8		($sp)	#$t16<---136
	subi	$sp	$sp	4
	sw	$10		($sp)	#$t15<---140
	subi	$sp	$sp	4
LABEL_42:

#%li	$t19	5	
	li	$8	5

#$t20	i	<	$t19
	lw	$9	-24($fp)	#i-->-24
	sw	$9	-24($fp)
	sw	$8		($sp)	#$t19<---144
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bgez	$10	LABEL_43

#%li	$t21	97	
	li	$8	97

#sz	i	=	$t21
	lw	$9	-24($fp)	#i-->-24
	li	$11	-4
	mul	$11	$9	$11
	lw	$9	-52($fp)	#sz#0-->-52
	add	$11	$11	$fp
	sw	$8	-52($11)

#sz2	i	=	i
	lw	$9	-24($fp)	#i-->-24
	li	$11	-4
	mul	$11	$9	$11
	lw	$9	-28($fp)	#sz2#0-->-28
	add	$11	$11	$fp
	sw	$9	-28($11)

#%li	$t22	1	
	li	$9	1

#$t23	i	+	$t22
	lw	$11	-24($fp)	#i-->-24
	sw	$11	-24($fp)
	sw	$9		($sp)	#$t22<---148
	subi	$sp	$sp	4
	add	$12	$11	$9

#i		=	$t23
	lw	$9	-24($fp)	#i-->-24
	sw	$12		($sp)	#$t23<---152
	subi	$sp	$sp	4
	add	$9	$12	$0
	sw	$9	-24($fp)

#%goto	LABEL_42		
	j	LABEL_42
	nop

#LABEL_43	:		
	sw	$8		($sp)	#$t21<---156
	subi	$sp	$sp	4
	sw	$10		($sp)	#$t20<---160
	subi	$sp	$sp	4
LABEL_43:

#%scanf	key		
	lw	$8	-20($fp)	#key-->-20
	li	$v0	5
	syscall
	move	$8	$v0
	sw	$8	-20($fp)

#%scanf	a		
	lw	$8	-4($fp)	#a-->-4
	li	$v0	5
	syscall
	move	$8	$v0
	sw	$8	-4($fp)

#%li	$t24	3	
	li	$8	3

#$t25	key	<	$t24
	lw	$9	-20($fp)	#key-->-20
	sw	$9	-20($fp)
	sw	$8		($sp)	#$t24<---164
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bgez	$10	LABEL_44

#$t26	a	+	b
	lw	$8	-4($fp)	#a-->-4
	lw	$9	-8($fp)	#b-->-8
	sw	$8	-4($fp)
	sw	$9	-8($fp)
	add	$11	$8	$9

#a		=	$t26
	lw	$8	-4($fp)	#a-->-4
	sw	$11		($sp)	#$t26<---168
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-4($fp)

#%printf	number	a	
	lw	$8	-4($fp)	#a-->-4
	li	$v0	1
	move	$a0	$8
	syscall

#%goto	LABEL_45		
	j	LABEL_45
	nop

#LABEL_44	:		
	sw	$8	-4($fp)
	sw	$10		($sp)	#$t25<---172
	subi	$sp	$sp	4
LABEL_44:

#LABEL_45	:		
LABEL_45:

#%li	$t27	3	
	li	$8	3

#$t28	key	<=	$t27
	lw	$9	-20($fp)	#key-->-20
	sw	$9	-20($fp)
	sw	$8		($sp)	#$t27<---176
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bgtz	$10	LABEL_46

#$t29	b	-	a
	lw	$8	-8($fp)	#b-->-8
	lw	$9	-4($fp)	#a-->-4
	sw	$8	-8($fp)
	sw	$9	-4($fp)
	sub	$11	$8	$9

#b		=	$t29
	lw	$8	-8($fp)	#b-->-8
	sw	$11		($sp)	#$t29<---180
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-8($fp)

#%li	$t30	0	
	li	$8	0

#$t31	=	sz2	$t30
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-28($fp)	#sz2#0-->-28
	add	$9	$9	$fp
	lw	$11	-28($9)
	move	$9	$11

#$t32	$t31	+	b
	lw	$8	-8($fp)	#b-->-8
	sw	$9		($sp)	#$t31<---184
	subi	$sp	$sp	4
	sw	$8	-8($fp)
	add	$11	$9	$8

#sz2	0	=	$t32
	lw	$8	-28($fp)	#sz2#0-->-28
	sw	$11		($sp)	#$t32<---188
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-28($fp)

#%li	$t33	0	
	li	$8	0

#$t34	=	sz	$t33
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-52($fp)	#sz#0-->-52
	add	$9	$9	$fp
	lw	$11	-52($9)
	move	$9	$11

#%li	$t35	1	
	li	$8	1

#$t36	$t34	+	$t35
	sw	$9		($sp)	#$t34<---192
	subi	$sp	$sp	4
	sw	$8		($sp)	#$t35<---196
	subi	$sp	$sp	4
	add	$11	$9	$8

#sz	0	=	$t36
	lw	$8	-52($fp)	#sz#0-->-52
	sw	$11		($sp)	#$t36<---200
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-52($fp)

#%printf	number	b	
	lw	$8	-8($fp)	#b-->-8
	li	$v0	1
	move	$a0	$8
	syscall

#%li	$t37	0	
	li	$9	0

#$t38	=	sz	$t37
	li	$11	-4
	mul	$11	$9	$11
	lw	$9	-52($fp)	#sz#0-->-52
	add	$11	$11	$fp
	lw	$12	-52($11)
	move	$11	$12

#%printf	number	$t38	
	li	$v0	11
	move	$a0	$11
	syscall

#%li	$t39	0	
	li	$9	0

#$t40	=	sz2	$t39
	li	$12	-4
	mul	$12	$9	$12
	lw	$9	-28($fp)	#sz2#0-->-28
	add	$12	$12	$fp
	lw	$13	-28($12)
	move	$12	$13

#%printf	number	$t40	
	li	$v0	1
	move	$a0	$12
	syscall

#%goto	LABEL_47		
	j	LABEL_47
	nop

#LABEL_46	:		
	sw	$8	-8($fp)
	sw	$10		($sp)	#$t28<---204
	subi	$sp	$sp	4
	sw	$11		($sp)	#$t38<---208
	subi	$sp	$sp	4
	sw	$12		($sp)	#$t40<---212
	subi	$sp	$sp	4
LABEL_46:

#LABEL_47	:		
LABEL_47:

#%li	$t41	6	
	li	$8	6

#$t42	key	>	$t41
	lw	$9	-20($fp)	#key-->-20
	sw	$9	-20($fp)
	sw	$8		($sp)	#$t41<---216
	subi	$sp	$sp	4
	sub	$10	$9	$8
	blez	$10	LABEL_48

#$t43	a	*	b
	lw	$8	-4($fp)	#a-->-4
	lw	$9	-8($fp)	#b-->-8
	sw	$8	-4($fp)
	sw	$9	-8($fp)
	mult	$8	$9
	mflo	$11

#c		=	$t43
	lw	$8	-12($fp)	#c-->-12
	sw	$11		($sp)	#$t43<---220
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-12($fp)

#%li	$t44	1	
	li	$8	1

#$t45	=	sz2	$t44
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-28($fp)	#sz2#0-->-28
	add	$9	$9	$fp
	lw	$11	-28($9)
	move	$9	$11

#$t46	$t45	+	c
	lw	$8	-12($fp)	#c-->-12
	sw	$9		($sp)	#$t45<---224
	subi	$sp	$sp	4
	sw	$8	-12($fp)
	add	$11	$9	$8

#sz2	1	=	$t46
	lw	$8	-32($fp)	#sz2#1-->-32
	sw	$11		($sp)	#$t46<---228
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-32($fp)

#%li	$t47	1	
	li	$8	1

#$t48	=	sz	$t47
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-52($fp)	#sz#0-->-52
	add	$9	$9	$fp
	lw	$11	-52($9)
	move	$9	$11

#%li	$t49	1	
	li	$8	1

#$t50	$t48	+	$t49
	sw	$9		($sp)	#$t48<---232
	subi	$sp	$sp	4
	sw	$8		($sp)	#$t49<---236
	subi	$sp	$sp	4
	add	$11	$9	$8

#sz	1	=	$t50
	lw	$8	-56($fp)	#sz#1-->-56
	sw	$11		($sp)	#$t50<---240
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-56($fp)

#%printf	number	c	
	lw	$8	-12($fp)	#c-->-12
	li	$v0	1
	move	$a0	$8
	syscall

#%li	$t51	1	
	li	$9	1

#$t52	=	sz	$t51
	li	$11	-4
	mul	$11	$9	$11
	lw	$9	-52($fp)	#sz#0-->-52
	add	$11	$11	$fp
	lw	$12	-52($11)
	move	$11	$12

#%printf	number	$t52	
	li	$v0	11
	move	$a0	$11
	syscall

#%li	$t53	1	
	li	$9	1

#$t54	=	sz2	$t53
	li	$12	-4
	mul	$12	$9	$12
	lw	$9	-28($fp)	#sz2#0-->-28
	add	$12	$12	$fp
	lw	$13	-28($12)
	move	$12	$13

#%printf	number	$t54	
	li	$v0	1
	move	$a0	$12
	syscall

#%goto	LABEL_49		
	j	LABEL_49
	nop

#LABEL_48	:		
	sw	$8	-12($fp)
	sw	$10		($sp)	#$t42<---244
	subi	$sp	$sp	4
	sw	$11		($sp)	#$t52<---248
	subi	$sp	$sp	4
	sw	$12		($sp)	#$t54<---252
	subi	$sp	$sp	4
LABEL_48:

#LABEL_49	:		
LABEL_49:

#%li	$t55	6	
	li	$8	6

#$t56	key	>=	$t55
	lw	$9	-20($fp)	#key-->-20
	sw	$9	-20($fp)
	sw	$8		($sp)	#$t55<---256
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bltz	$10	LABEL_50

#$t57	a	/	b
	lw	$8	-4($fp)	#a-->-4
	lw	$9	-8($fp)	#b-->-8
	sw	$8	-4($fp)
	sw	$9	-8($fp)
	div	$8	$9
	mflo	$11

#d		=	$t57
	lw	$8	-16($fp)	#d-->-16
	sw	$11		($sp)	#$t57<---260
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-16($fp)

#%li	$t58	2	
	li	$8	2

#$t59	=	sz2	$t58
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-28($fp)	#sz2#0-->-28
	add	$9	$9	$fp
	lw	$11	-28($9)
	move	$9	$11

#$t60	$t59	+	d
	lw	$8	-16($fp)	#d-->-16
	sw	$9		($sp)	#$t59<---264
	subi	$sp	$sp	4
	sw	$8	-16($fp)
	add	$11	$9	$8

#sz2	2	=	$t60
	lw	$8	-36($fp)	#sz2#2-->-36
	sw	$11		($sp)	#$t60<---268
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-36($fp)

#%li	$t61	2	
	li	$8	2

#$t62	=	sz	$t61
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-52($fp)	#sz#0-->-52
	add	$9	$9	$fp
	lw	$11	-52($9)
	move	$9	$11

#%li	$t63	1	
	li	$8	1

#$t64	$t62	+	$t63
	sw	$9		($sp)	#$t62<---272
	subi	$sp	$sp	4
	sw	$8		($sp)	#$t63<---276
	subi	$sp	$sp	4
	add	$11	$9	$8

#sz	2	=	$t64
	lw	$8	-60($fp)	#sz#2-->-60
	sw	$11		($sp)	#$t64<---280
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-60($fp)

#%printf	number	d	
	lw	$8	-16($fp)	#d-->-16
	li	$v0	1
	move	$a0	$8
	syscall

#%li	$t65	2	
	li	$9	2

#$t66	=	sz	$t65
	li	$11	-4
	mul	$11	$9	$11
	lw	$9	-52($fp)	#sz#0-->-52
	add	$11	$11	$fp
	lw	$12	-52($11)
	move	$11	$12

#%printf	number	$t66	
	li	$v0	11
	move	$a0	$11
	syscall

#%li	$t67	2	
	li	$9	2

#$t68	=	sz2	$t67
	li	$12	-4
	mul	$12	$9	$12
	lw	$9	-28($fp)	#sz2#0-->-28
	add	$12	$12	$fp
	lw	$13	-28($12)
	move	$12	$13

#%printf	number	$t68	
	li	$v0	1
	move	$a0	$12
	syscall

#%goto	LABEL_51		
	j	LABEL_51
	nop

#LABEL_50	:		
	sw	$8	-16($fp)
	sw	$10		($sp)	#$t56<---284
	subi	$sp	$sp	4
	sw	$11		($sp)	#$t66<---288
	subi	$sp	$sp	4
	sw	$12		($sp)	#$t68<---292
	subi	$sp	$sp	4
LABEL_50:

#LABEL_51	:		
LABEL_51:

#%li	$t69	4	
	li	$8	4

#$t70	key	!=	$t69
	lw	$9	-20($fp)	#key-->-20
	sw	$9	-20($fp)
	sw	$8		($sp)	#$t69<---296
	subi	$sp	$sp	4
	sub	$10	$9	$8
	beq	$10	$0	LABEL_52

#%li	$t71	1	
	li	$8	1

#$t72	$t71	/	coz
	lw	$9	0($fp)	#coz-->0
	sw	$8		($sp)	#$t71<---300
	subi	$sp	$sp	4
	sw	$9	0($fp)
	div	$8	$9
	mflo	$11

#$t73	a	-	$t72
	lw	$8	-4($fp)	#a-->-4
	sw	$8	-4($fp)
	sw	$11		($sp)	#$t72<---304
	subi	$sp	$sp	4
	sub	$9	$8	$11

#a		=	$t73
	lw	$8	-4($fp)	#a-->-4
	sw	$9		($sp)	#$t73<---308
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-4($fp)

#%li	$t74	3	
	li	$8	3

#$t75	=	sz2	$t74
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-28($fp)	#sz2#0-->-28
	add	$9	$9	$fp
	lw	$11	-28($9)
	move	$9	$11

#$t76	$t75	+	a
	lw	$8	-4($fp)	#a-->-4
	sw	$9		($sp)	#$t75<---312
	subi	$sp	$sp	4
	sw	$8	-4($fp)
	add	$11	$9	$8

#%li	$t77	99	
	li	$8	99

#$t78	$t76	+	$t77
	sw	$11		($sp)	#$t76<---316
	subi	$sp	$sp	4
	sw	$8		($sp)	#$t77<---320
	subi	$sp	$sp	4
	add	$9	$11	$8

#sz2	3	=	$t78
	lw	$8	-40($fp)	#sz2#3-->-40
	sw	$9		($sp)	#$t78<---324
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-40($fp)

#%li	$t79	3	
	li	$8	3

#$t80	=	sz	$t79
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-52($fp)	#sz#0-->-52
	add	$9	$9	$fp
	lw	$11	-52($9)
	move	$9	$11

#%li	$t81	1	
	li	$8	1

#$t82	$t80	+	$t81
	sw	$9		($sp)	#$t80<---328
	subi	$sp	$sp	4
	sw	$8		($sp)	#$t81<---332
	subi	$sp	$sp	4
	add	$11	$9	$8

#sz	3	=	$t82
	lw	$8	-64($fp)	#sz#3-->-64
	sw	$11		($sp)	#$t82<---336
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-64($fp)

#%printf	number	a	
	lw	$8	-4($fp)	#a-->-4
	li	$v0	1
	move	$a0	$8
	syscall

#%li	$t83	3	
	li	$9	3

#$t84	=	sz	$t83
	li	$11	-4
	mul	$11	$9	$11
	lw	$9	-52($fp)	#sz#0-->-52
	add	$11	$11	$fp
	lw	$12	-52($11)
	move	$11	$12

#%printf	number	$t84	
	li	$v0	11
	move	$a0	$11
	syscall

#%li	$t85	3	
	li	$9	3

#$t86	=	sz2	$t85
	li	$12	-4
	mul	$12	$9	$12
	lw	$9	-28($fp)	#sz2#0-->-28
	add	$12	$12	$fp
	lw	$13	-28($12)
	move	$12	$13

#%printf	number	$t86	
	li	$v0	1
	move	$a0	$12
	syscall

#%goto	LABEL_53		
	j	LABEL_53
	nop

#LABEL_52	:		
	sw	$8	-4($fp)
	sw	$10		($sp)	#$t70<---340
	subi	$sp	$sp	4
	sw	$11		($sp)	#$t84<---344
	subi	$sp	$sp	4
	sw	$12		($sp)	#$t86<---348
	subi	$sp	$sp	4
LABEL_52:

#LABEL_53	:		
LABEL_53:

#%li	$t87	4	
	li	$8	4

#$t88	key	==	$t87
	lw	$9	-20($fp)	#key-->-20
	sw	$9	-20($fp)
	sw	$8		($sp)	#$t87<---352
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_54

#$t89		-	a
	lw	$8	-4($fp)	#a-->-4
	sw	$8	-4($fp)
	sub	$9	$0	$8

#%li	$t90	2	
	li	$8	2

#$t91	$t90	*	coz
	lw	$11	0($fp)	#coz-->0
	sw	$8		($sp)	#$t90<---356
	subi	$sp	$sp	4
	sw	$11	0($fp)
	mult	$8	$11
	mflo	$12

#$t92	$t89	+	$t91
	sw	$9		($sp)	#$t89<---360
	subi	$sp	$sp	4
	sw	$12		($sp)	#$t91<---364
	subi	$sp	$sp	4
	add	$8	$9	$12

#a		=	$t92
	lw	$9	-4($fp)	#a-->-4
	sw	$8		($sp)	#$t92<---368
	subi	$sp	$sp	4
	add	$9	$8	$0
	sw	$9	-4($fp)

#%li	$t93	4	
	li	$8	4

#$t94	=	sz	$t93
	li	$9	-4
	mul	$9	$8	$9
	lw	$8	-52($fp)	#sz#0-->-52
	add	$9	$9	$fp
	lw	$11	-52($9)
	move	$9	$11

#%li	$t95	1	
	li	$8	1

#$t96	$t94	+	$t95
	sw	$9		($sp)	#$t94<---372
	subi	$sp	$sp	4
	sw	$8		($sp)	#$t95<---376
	subi	$sp	$sp	4
	add	$11	$9	$8

#sz	4	=	$t96
	lw	$8	-68($fp)	#sz#4-->-68
	sw	$11		($sp)	#$t96<---380
	subi	$sp	$sp	4
	add	$8	$11	$0
	sw	$8	-68($fp)

#%printf	number	a	
	lw	$8	-4($fp)	#a-->-4
	li	$v0	1
	move	$a0	$8
	syscall

#%li	$t97	4	
	li	$9	4

#$t98	=	sz	$t97
	li	$11	-4
	mul	$11	$9	$11
	lw	$9	-52($fp)	#sz#0-->-52
	add	$11	$11	$fp
	lw	$12	-52($11)
	move	$11	$12

#%printf	number	$t98	
	li	$v0	11
	move	$a0	$11
	syscall

#%li	$t99	4	
	li	$9	4

#$t100	=	sz2	$t99
	li	$12	-4
	mul	$12	$9	$12
	lw	$9	-28($fp)	#sz2#0-->-28
	add	$12	$12	$fp
	lw	$13	-28($12)
	move	$12	$13

#%printf	number	$t100	
	li	$v0	1
	move	$a0	$12
	syscall

#%goto	LABEL_55		
	j	LABEL_55
	nop

#LABEL_54	:		
	sw	$8	-4($fp)
	sw	$10		($sp)	#$t88<---384
	subi	$sp	$sp	4
	sw	$11		($sp)	#$t98<---388
	subi	$sp	$sp	4
	sw	$12		($sp)	#$t100<---392
	subi	$sp	$sp	4
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
	j	LABEL_57
	nop

#LABEL_56	:		
	sw	$8	-20($fp)
	sw	$9	-4($fp)
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
	sw	$9	-48($fp)
	sw	$8		($sp)	#$t101<---396
	subi	$sp	$sp	4
	sub	$10	$9	$8
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
	sw	$10		($sp)	#$t102<---400
	subi	$sp	$sp	4
	subi	$sp	$sp	12
	sw	$k0	12($sp)
	sw	$fp	8($sp)
	sw	$ra	4($sp)
	move	$k0	$sp

#%li	$t103	2	
	li	$8	2

#$t104		-	$t103
	sw	$8		($sp)	#$t103<--0
	subi	$sp	$sp	4
	sub	$9	$0	$8

#%push	$t104		
	addi	$sp	$sp	4
	sw	$9	($sp)
	subi	$sp	$sp	4

#%li	$t105	3	
	li	$8	3

#%push	$t105		
	sw	$8	($sp)
	subi	$sp	$sp	4

#%jal	LABEL_f		
	move	$fp	$k0
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
	sw	$9		($sp)	#$t107<---404
	subi	$sp	$sp	4
	sw	$10		($sp)	#$t108<---408
	subi	$sp	$sp	4
	add	$11	$9	$10

#$t110	$t109	*	coz
	lw	$9	0($fp)	#coz-->0
	sw	$11		($sp)	#$t109<---412
	subi	$sp	$sp	4
	sw	$9	0($fp)
	mult	$11	$9
	mflo	$10

#$t111	$t106	+	$t110
	sw	$8		($sp)	#$t106<---416
	subi	$sp	$sp	4
	sw	$10		($sp)	#$t110<---420
	subi	$sp	$sp	4
	add	$9	$8	$10

#sz2	4	=	$t111
	lw	$8	-44($fp)	#sz2#4-->-44
	sw	$9		($sp)	#$t111<---424
	subi	$sp	$sp	4
	add	$8	$9	$0
	sw	$8	-44($fp)

#%goto	LABEL_60		
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
	j	LABEL_38
	nop

#LABEL_58	:		
	sw	$8		($sp)	#$t113<---428
	subi	$sp	$sp	4
	sw	$10		($sp)	#$t115<---432
	subi	$sp	$sp	4
LABEL_58:

#%li	$t116	4	
	li	$8	4

#$t117	cho	==	$t116
	lw	$9	-48($fp)	#cho-->-48
	sw	$9	-48($fp)
	sw	$8		($sp)	#$t116<---436
	subi	$sp	$sp	4
	sub	$10	$9	$8
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
	li	$8	1

#$t119	key	*	$t118
	lw	$9	-20($fp)	#key-->-20
	sw	$9	-20($fp)
	sw	$8		($sp)	#$t118<---440
	subi	$sp	$sp	4
	mult	$9	$8
	mflo	$11

#%li	$t120	0	
	li	$8	0

#$t121	$t119	==	$t120
	sw	$11		($sp)	#$t119<---444
	subi	$sp	$sp	4
	sw	$8		($sp)	#$t120<---448
	subi	$sp	$sp	4
	sub	$9	$11	$8
	bne	$9	$0	LABEL_63

#%printf	string	key is 0	
	li	$v0	4
	la	$a0	string5
	syscall

#%goto	LABEL_62		
	j	LABEL_62
	nop

#LABEL_63	:		
	sw	$9		($sp)	#$t121<---452
	subi	$sp	$sp	4
	sw	$10		($sp)	#$t117<---456
	subi	$sp	$sp	4
LABEL_63:

#%li	$t122	1	
	li	$8	1

#$t123	$t119	==	$t122
	lw	$9	-444($fp)	#$t119-->-444
	sw	$9	-444($fp)
	sw	$8		($sp)	#$t122<---460
	subi	$sp	$sp	4
	sub	$10	$9	$8
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
	j	LABEL_62
	nop

#LABEL_64	:		
	sw	$8	-20($fp)
	sw	$10		($sp)	#$t123<---464
	subi	$sp	$sp	4
LABEL_64:

#%li	$t124	2	
	li	$8	2

#$t125	$t119	==	$t124
	lw	$9	-444($fp)	#$t119-->-444
	sw	$9	-444($fp)
	sw	$8		($sp)	#$t124<---468
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_65

#%printf	string	key is 2	
	li	$v0	4
	la	$a0	string7
	syscall

#%goto	LABEL_62		
	j	LABEL_62
	nop

#LABEL_65	:		
	sw	$10		($sp)	#$t125<---472
	subi	$sp	$sp	4
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
	li	$8	97

#$t127	e	==	$t126
	lw	$9	-72($fp)	#e-->-72
	sw	$9	-72($fp)
	sw	$8		($sp)	#$t126<---476
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_67

#%li	$t128	2	
	li	$8	2

#%printf	number	$t128	
	li	$v0	1
	move	$a0	$8
	syscall

#%goto	LABEL_66		
	j	LABEL_66
	nop

#LABEL_67	:		
	sw	$8		($sp)	#$t128<---480
	subi	$sp	$sp	4
	sw	$10		($sp)	#$t127<---484
	subi	$sp	$sp	4
LABEL_67:

#%li	$t129	98	
	li	$8	98

#$t130	e	==	$t129
	lw	$9	-72($fp)	#e-->-72
	sw	$9	-72($fp)
	sw	$8		($sp)	#$t129<---488
	subi	$sp	$sp	4
	sub	$10	$9	$8
	bne	$10	$0	LABEL_68

#%li	$t131	2	
	li	$8	2

#%li	$t132	2	
	li	$9	2

#$t133		-	$t132
	sw	$9		($sp)	#$t132<---492
	subi	$sp	$sp	4
	sub	$11	$0	$9

#$t134	$t131	+	$t133
	sw	$8		($sp)	#$t131<---496
	subi	$sp	$sp	4
	sw	$11		($sp)	#$t133<---500
	subi	$sp	$sp	4
	add	$9	$8	$11

#%printf	number	$t134	
	li	$v0	1
	move	$a0	$9
	syscall

#%goto	LABEL_66		
	j	LABEL_66
	nop

#LABEL_68	:		
	sw	$9		($sp)	#$t134<---504
	subi	$sp	$sp	4
	sw	$10		($sp)	#$t130<---508
	subi	$sp	$sp	4
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
