.data
#inicialização do bitmap
bitmap_address:   .space 0x20000
array_seq: .space 0x14

#posicao no bitmap
qdr_1:	.word 0x001424
qdr_2:	.word 0x001510
qdr_3:	.word 0x008A24
qdr_4:	.word 0x008B10

# cores
black:      	.word 0x0
white:      	.word 0xffffff

dark_red:      	.word 0x330000
dark_green:     .word 0x003300
dark_blue:	.word 0x000033
dark_yellow:    .word 0x333300

red:      	.word 0xff0000
green:      	.word 0x00ff00
blue:		.word 0x0000ff
yellow:      	.word 0xffff00

.text

##########################################################################################
#
#	Main
#
##########################################################################################

##########################################################################################
#
#	Sequência aleatória
#
##########################################################################################

word_um:
	addi $t2, $zero, 3
ini_um:
	bltz $t2, word_dois
	jal sorteia
	sb $t1, array_seq($t2)
	subi $t2, $t2, 1
	j ini_um
	
word_dois:
	addi $t2, $zero, 3
ini_dois:
	bltz $t2, word_tres
	jal sorteia
	sb $t1, array_seq + 4($t2)
	subi $t2, $t2, 1
	j ini_dois
	
word_tres:
	addi $t2, $zero, 3
ini_tres:
	bltz $t2, word_quatro
	jal sorteia
	sb $t1, array_seq + 8($t2)
	subi $t2, $t2, 1
	j ini_tres
	
word_quatro:
	addi $t2, $zero, 3
ini_quatro:
	bltz $t2, word_cinco
	jal sorteia
	sb $t1, array_seq + 12($t2)
	subi $t2, $t2, 1
	j ini_quatro

word_cinco:
	addi $t2, $zero, 3
ini_cinco:
	bltz $t2, fim_seq
	jal sorteia
	sb $t1, array_seq + 16($t2)
	subi $t2, $t2, 1
	j ini_cinco
			
sorteia:
	li $v0, 42
	li $a0,1
	li $a1, 4         
	syscall
	addi $t1, $a0, 1
	jr $ra
	
fim_seq:

##########################################################################################
#
#	Pinta Tela
#
##########################################################################################

pinta_tela:	
	lw $a0, qdr_1
	lw $a1, dark_red
	jal pinta_quadrado
	
	lw $a0, qdr_2
	lw $a1, dark_green
	jal pinta_quadrado	
	
	lw $a0, qdr_3
	lw $a1, dark_blue
	jal pinta_quadrado
	
	lw $a0, qdr_4
	lw $a1, dark_yellow
	jal pinta_quadrado
		
	break
	
##########################################################################################
#
#	Pinta quadrado
#
##########################################################################################

pinta_quadrado:
	add $s2, $zero, $a0	# posicao da primeira linha
	addi $s3, $zero, 49	# largura da primeira linha horizontal
	addi $t0, $zero, 49	# numero de linhas
	add $a2, $zero,  $a1	# cor da linha
	
linha:
	sw $a2, bitmap_address($s2)
	addi $s2, $s2, 4 #muda para a proxima posicao do bitmap
	subi $s3, $s3, 1 #subitrai contador de largura
	beq $s3, $zero, prox_linha #verifica fim
	j linha

prox_linha:
	addi $s3, $zero, 49
	addi $s2, $s2, 316
	subi $t0, $t0, 1
	beq $t0, $zero, fim
	j linha
	
fim:
	jr $ra