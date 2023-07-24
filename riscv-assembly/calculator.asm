INITIAL:
	lui  s1, 0xFFFFF

MAIN:
	lw   s0, 0x70(s1)		# read switch
	sw   s0, 0x60(s1)			# write led
	andi s3, s0, 0xFF			# numB:SW[7:0]
	srli s0, s0, 8
	andi s2, s0, 0xFF			# numA:SW[15:8]
	srli s0, s0, 13
	andi s4, s0, 0x7			# op:SW[23:21]

	#��������
	#addi s2, x0, 0x12
	#addi s3, x0, 0x34
	#addi s4, x0, 1

PRETREATMENT:					#����Ԥ����
	andi  s6,  s2,  0x7F			#��ȡA������λ
	srli  s7,  s2,  7			#��ȡA�ķ���λ
	andi  s7,  s7,  1
	andi  s8,  s3,  0x7F			#��ȡB������λ
	srli  s9,  s3,  7			#��ȡB�ķ���λ
	andi  s9,  s9,  1

JUDGE:
	addi a0, x0, 0				# param
	addi a1, x0, 1
	addi a2, x0, 2
	addi a3, x0, 3
	addi a4, x0, 4
	addi a5, x0, 5
	addi a6, x0, 6

	beq  a0, s4, OPT_and
	beq  a1, s4, OPT_or
	beq  a2, s4, OPT_xor
	beq  a3, s4, OPT_left
	beq  a4, s4, OPT_right
	beq  a5, s4, OPT_comp
	beq  a6, s4, OPT_division

SHOW:						#�������ʾ���
	addi   t1, x0, 0
	addi   t2, x0, 0
	addi   t4, x0, 4
	addi   a7, x0, 7
	andi   t0, s5, 0x1
	srai   t3, s5, 1

	FOR_show:				#16����ת����2����
		add   t1, t1, t0
		andi  t0, t3, 0x1
		sll   t0, t0, t4
		srai  t3, t3, 1
		addi  t2, t2, 1
		addi  t4, t4, 4
		bge   a7, t2, FOR_show
		jal   x0, END

	END:
		sw   t1, 0x00(s1)
		#sw   s5, 0x00(s1)
		jal  x0, MAIN

OPT_and:					#�����
	and  s5, s2, s3
	jal  x0, SHOW

OPT_or:						#�����
	or   s5, s2, s3
	jal  x0, SHOW

OPT_xor:					#������
	xor  s5, s2, s3
	jal  x0, SHOW

OPT_left:					#����sllָ���д���Ʋ���
	sll  s5, s2, s3
	andi s5, s5, 0x7F			#��ȡ���ƺ��ĩ7λ
	slli t0, s7, 7
	add  s5, s5, t0
	jal  x0, SHOW

OPT_right:					#����sraָ���д�������Ʋ���
	sra  s5, s6, s3
	andi s5, s5, 0x7F			#��ȡ���ƺ��ĩ7λ
	slli t0, s7, 7
	add  s5, s5, t0
	jal  x0, SHOW

	#addi a7, x0, 7
	#sra  s5, s6, s3
	#sub  t0, a7, s3

	#FOR_right:
		#sll  t2, s7, t0
		#add  s5, s5, t2
		#beq  a7, t0, EXIT
		#addi t0, t0, 1
		#jal  x0, FOR_right

	#EXIT:
		#jal  x0, SHOW

OPT_comp:
	bne  x0, s2, COMPLENMENT
	add  s5, x0, s3
	jal  x0, SHOW

	COMPLENMENT:
		beq   s9, x0, ELSE_comp
		xori  s5, s8, 0x7F		#������λ�⣬��λȡ����ĩλ��һ
		addi  s5, s5, 1
		slli  t0, s9, 7
		add   s5, s5, t0
		jal   x0, SHOW

	ELSE_comp:
		add   s5, x0, s3
		jal   x0, SHOW

OPT_division:
	addi  t1,  x0,  0			#������λ����
	add   t4,  x0,  s6
	FOR_pre:
		addi  t1, t1,  1
		srli  t4, t4,  1
		or    t5, x0,  t4
		bne   t5, x0,  FOR_pre
		add   t5, x0,  t1

	DEAL_DATA:
		sll   s11, s8,  t5		#[B]��
		xori  s10, s8,  0xFF   		#[-B]��
		addi  s10, s10, 1
		sll   s10, s10, t5

	FIRST_OPERATION:
		addi  s5,  x0,  0		#��ʼ��Ϊ0
		addi  t1,  x0,  1 		#��ʼ��λ����Ϊ1
		add   t6,  t5,  t5
		addi  t6,  t6,  1

		add   t2,  x0,  s6
		slli  t2,  t2,  1
		add   t2,  t2,  s10

	FOR_div:
		srl  t3, t2, t6		#��ȡ����λ
		andi  t3, t3, 1
		bne   t3, x0, ELSE_div

		addi  s5, s5, 1		#����1
		beq   t1, t5, RESULT	#���̺��жϳ����Ƿ����
		slli  s5, s5, 1		#����һλ
		slli  t2, t2, 1
		add   t2, t2, s10
		addi  t1, t1, 1
		jal   x0, FOR_div

	ELSE_div:
		addi  s5, s5, 0		#����0
		beq   t1, t5, RESULT	#���̺��жϳ����Ƿ����
		slli  s5, s5, 1		#����һλ
		slli  t2, t2, 1
		add   t2, t2, s11
		addi  t1, t1, 1
		jal   x0, FOR_div

	RESULT:
		xor   t0, s7,  s9	#�жϽ���ķ���λ
		#bne   t0, x0,  COMP
		slli  t0, t0,  7
		add   s5, s5,  t0
		jal   x0, SHOW

		#COMP:
			#xori  s5, s5,  0x7F	#���Ϊ����������λ�⣬��λȡ����ĩλ��һ
			#addi  s5, s5,  1
			#slli  t0, t0,  7
			#add   s5, s5,  t0
			#jal   x0, SHOW



