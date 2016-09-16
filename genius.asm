.data
# Inicializa��o do bitmap e array
bitmap_address:   .space 0x20000
array_seq: .space 0x14

# Frases
msg_ini: .asciiz "Vamos come�ar, acerte a sequ�ncia\n"
msg_prox: .asciiz "Certo!! Mais um...\n"
msg_err: .asciiz "Errou!! Seu m�ximo foi de: "

# Posicao no bitmap
qdr_1:	.word 0x001424
qdr_2:	.word 0x001510
qdr_3:	.word 0x008A24
qdr_4:	.word 0x008B10

# Cores
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

main:
	jal seq_aleatoria	# Chama "fun��o" para definir a sequ�ncia aleat�ria
	jal pinta_tela		# Chama "fun��o" para pintar tela
	
	nop
	nop
	
	
	add $a0, $zero, 3
	jal pisca
	add $a0, $zero, 1
	jal pisca
	add $a0, $zero, 2
	jal pisca
	add $a0, $zero, 2
	jal pisca
	
	li  $v0, 4
	la $a0, msg_ini
	syscall
	
	break

##########################################################################################
#
#	Apresentar Sequ�ncia
#
##########################################################################################

apresentar_sequencia:
	#add $t8, $zero, $ra
	
	#addi $t0, $zero, $zero
	#addi $t1, $zero, 3	# Deslocamento do array
	#addi $t2, $zero, $a0	# T2 - N� da rodada
	#addi $t3, $zero, $zero	# T3 - Qtd j� apresentada


	#sub $t1, $t1, $t0
	#lb $t4, array_seq($t1)
	#add $a0, $zero, $t4
	#jal pisca
	#addi $t3, $t3, 1
	#beq $t3, $t2, fim_apres

fim_apres:
	#add $ra, $zero, $t8
	#jr $ra
	
##########################################################################################
#
#	Sequ�ncia aleat�ria
#
##########################################################################################

seq_aleatoria:
	add $t8, $zero, $ra
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
	add $ra, $zero, $t8
	jr $ra

##########################################################################################
#
#	Pinta Tela
#
##########################################################################################

pinta_tela:
	add $t8, $zero, $ra	# Salvando o endere�o de retorno dessa fun��o

	lw $a0, qdr_1		
	lw $a1, dark_red
	jal pinta_quadrado	# void pinta_quadrado(Word posi��o, Word cor)
	
	lw $a0, qdr_2
	lw $a1, dark_green
	jal pinta_quadrado	
	
	lw $a0, qdr_3
	lw $a1, dark_blue
	jal pinta_quadrado
	
	lw $a0, qdr_4
	lw $a1, dark_yellow
	jal pinta_quadrado
	
	add $ra, $zero, $t8	# Recuperando o endere�o de retorno dessa fun��o
	jr $ra

##########################################################################################
#
#	Pisca quadrado
#
##########################################################################################

pisca:
	add $t8, $zero, $ra	# Salvando o endere�o de retorno dessa fun��o
	
	add $t0, $zero, $a0
	
	beq $t0, 1, pisca_red	# Switch case com o argumento
	beq $t0, 2, pisca_green
	beq $t0, 3, pisca_blue
	beq $t0, 4, pisca_yellow

pisca_red:
	addi $v0, $zero, 31
	addi $a0, $zero, 60
	addi $a1, $zero, 1000
	addi $a2, $zero, 1
	addi $a3, $zero, 100
	syscall
	lw $a0, qdr_1		
	lw $a1, red
	jal pinta_quadrado
	addi $v0, $zero, 32
	addi $a0, $zero, 500
	syscall
	lw $a0, qdr_1		
	lw $a1, dark_red
	jal pinta_quadrado
	addi $v0, $zero, 32
	addi $a0, $zero, 500
	syscall
	j default
	
pisca_green:
	addi $v0, $zero, 31
	addi $a0, $zero, 62
	addi $a1, $zero, 1000
	addi $a2, $zero, 1
	addi $a3, $zero, 100
	syscall
	lw $a0, qdr_2		
	lw $a1, green
	jal pinta_quadrado
	addi $v0, $zero, 32
	addi $a0, $zero, 500
	syscall
	lw $a0, qdr_2		
	lw $a1, dark_green
	jal pinta_quadrado
	addi $v0, $zero, 32
	addi $a0, $zero, 500
	syscall
	j default
	
pisca_blue:
	addi $v0, $zero, 31
	addi $a0, $zero, 64
	addi $a1, $zero, 1000
	addi $a2, $zero, 1
	addi $a3, $zero, 100
	syscall
	lw $a0, qdr_3		
	lw $a1, blue
	jal pinta_quadrado
	addi $v0, $zero, 32
	addi $a0, $zero, 500
	syscall
	lw $a0, qdr_3		
	lw $a1, dark_blue
	jal pinta_quadrado
	addi $v0, $zero, 32
	addi $a0, $zero, 500
	syscall
	j default
	
pisca_yellow:
	addi $v0, $zero, 31
	addi $a0, $zero, 65
	addi $a1, $zero, 1000
	addi $a2, $zero, 1
	addi $a3, $zero, 100
	syscall
	lw $a0, qdr_4		
	lw $a1, yellow
	jal pinta_quadrado
	addi $v0, $zero, 32
	addi $a0, $zero, 500
	syscall
	lw $a0, qdr_4		
	lw $a1, dark_yellow
	jal pinta_quadrado
	addi $v0, $zero, 32
	addi $a0, $zero, 500
	syscall
	j default

default:
	add $ra, $zero, $t8	# Recuperando o endere�o de retorno dessa fun��o
	jr $ra
		
##########################################################################################
#
#	Pinta quadrado
#
##########################################################################################

pinta_quadrado:
	add $s2, $zero, $a0	# posicao da primeira linha
	addi $s3, $zero, 49	# largura da primeira linha horizontal
	addi $t0, $zero, 49	# numero de linhas
	add $t1, $zero,  $a1	# cor da linha
	
linha:
	sw $t1, bitmap_address($s2)
	addi $s2, $s2, 4 	# muda para a proxima posicao do bitmap
	subi $s3, $s3, 1 	# subitrai contador de largura
	beq $s3, $zero, prox_linha # verifica fim
	j linha

prox_linha:
	addi $s3, $zero, 49
	addi $s2, $s2, 316
	subi $t0, $t0, 1
	beq $t0, $zero, fim
	j linha
	
fim:
	jr $ra
