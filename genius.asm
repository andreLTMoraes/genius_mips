.data
# Inicializa��o do bitmap e array
bitmap_address:   .space 0x20000
array_seq: .space 0x14

# Frases
msg_ini: .asciiz "\nAcerte a sequ�ncia. Precione qualquer tecla para come�ar\n"
msg_prox: .asciiz "\n\n\n\n\n\nCerto!! Mais um...\n"
msg_err: .asciiz "\nErrou!! Seu m�ximo foi de: "
msg_ter: .asciiz "\n\n\n\Pouxa!! terminou tudim!!"

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
	addi $s7, $zero, 1
	
	li  $v0, 4
	la $a0, msg_ini		# Acerte a sequ�ncia. Precione qualquer tecla para come�ar
	syscall
	li $v0, 12       
  	syscall

jogar:	
	add $a0, $zero, $s7
	jal apresentar_sequencia
	
	add $a0, $zero, $s7
	jal conferir_sequencia
	beq $v0, 2, terminou
	beq $v0, $zero, acertou
	li  $v0, 4
	la $a0, msg_err		# Errou!! Seu m�ximo foi de:
	syscall
	li  $v0, 1
	add $a0, $zero, $s7
	syscall
	j fim_jogo
	
acertou:
	li  $v0, 4
	la $a0, msg_prox
	syscall
	addi $v0, $zero, 32
	addi $a0, $zero, 1500
	syscall
	addi $s7, $s7, 1
	j jogar
	
terminou:
	li  $v0, 4
	la $a0, msg_ter		# Acerte a sequ�ncia. Precione qualquer tecla para come�ar
	syscall
fim_jogo:	
	li $v0, 10 # termina programa se teclar 0
	syscall

##########################################################################################
#
#	Conferir Sequ�ncia
#
##########################################################################################

conferir_sequencia:
	add $t8, $zero, $ra
	
	add $s0, $zero, $a0	# S0 - N� da rodada
	add $t2, $zero, $zero	# T2 - Qtd j� apresentada

conf_wrd_um:
	addi $s1, $zero, 3
conf_ini_um:
	lb $t3, array_seq($s1)
	li $v0, 12       
  	syscall
  	add $a0, $zero, $v0
  	jal converte
  	bne $v0, $t3, fim_conf_err
	add $a0, $zero, $v0
	jal pisca
	addi $t2, $t2, 1
	beq $t2, $s0, fim_conf
	subi $s1, $s1, 1
	bltz $s1, conf_wrd_dois
	j conf_ini_um

conf_wrd_dois:
	addi $s1, $zero, 3
conf_ini_dois:
	lb $t3, array_seq($s1)
	li $v0, 12       
  	syscall
  	add $a0, $zero, $v0
  	jal converte
  	bne $v0, $t3, fim_conf_err
	add $a0, $zero, $v0
	jal pisca
	addi $t2, $t2, 1
	beq $t2, $s0, fim_conf
	subi $s1, $s1, 1
	bltz $s1, conf_wrd_tres
	j conf_ini_dois
  	
conf_wrd_tres:
	addi $s1, $zero, 3
conf_ini_tres:
	lb $t3, array_seq($s1)
	li $v0, 12       
  	syscall
  	add $a0, $zero, $v0
  	jal converte
  	bne $v0, $t3, fim_conf_err
	add $a0, $zero, $v0
	jal pisca
	addi $t2, $t2, 1
	beq $t2, $s0, fim_conf
	subi $s1, $s1, 1
	bltz $s1, conf_wrd_quatro
	j conf_ini_tres
	
conf_wrd_quatro:
	addi $s1, $zero, 3
conf_ini_quatro:
	lb $t3, array_seq($s1)
	li $v0, 12       
  	syscall
  	add $a0, $zero, $v0
  	jal converte
  	bne $v0, $t3, fim_conf_err
	add $a0, $zero, $v0
	jal pisca
	addi $t2, $t2, 1
	beq $t2, $s0, fim_conf
	subi $s1, $s1, 1
	bltz $s1, conf_wrd_cinco
	j conf_ini_quatro
	
conf_wrd_cinco:
	addi $s1, $zero, 3
conf_ini_cinco:
	lb $t3, array_seq($s1)
	li $v0, 12       
  	syscall
  	add $a0, $zero, $v0
  	jal converte
  	bne $v0, $t3, fim_conf_err
	add $a0, $zero, $v0
	jal pisca
	addi $t2, $t2, 1
	beq $t2, $s0, fim_conf
	subi $s1, $s1, 1
	bltz $s1, fim_conf_seq
	j conf_ini_cinco
	
converte:
	beq $a0, 0x31, ret_um	# Switch case com o argumento
	beq $a0, 0x32, ret_dois
	beq $a0, 0x33, ret_tres
	beq $a0, 0x34, ret_quatro

ret_um:
	addi $v0, $zero, 1
	jr $ra
	
ret_dois:
	addi $v0, $zero, 2
	jr $ra
	
ret_tres:
	addi $v0, $zero, 3
	jr $ra
	
ret_quatro:
	addi $v0, $zero, 4
	jr $ra

fim_conf:
	addi $v0, $zero, 0
	add $ra, $zero, $t8
	jr $ra

fim_conf_err:
	addi $v0, $zero, 1
	add $ra, $zero, $t8
	jr $ra
	
fim_conf_seq:
	addi $v0, $zero, 2
	add $ra, $zero, $t8
	jr $ra
		
	
##########################################################################################
#
#	Apresentar Sequ�ncia
#
##########################################################################################

apresentar_sequencia:
	add $t8, $zero, $ra
	
	add $s0, $zero, $a0	# S0 - N� da rodada
	add $t2, $zero, $zero	# T2 - Qtd j� apresentada

pres_wrd_um:
	addi $s1, $zero, 3
pres_ini_um:
	lb $t3, array_seq($s1)
	add $a0, $zero, $t3
	jal pisca
	addi $t2, $t2, 1
	beq $t2, $s0, fim_apres
	subi $s1, $s1, 1
	bltz $s1, pres_wrd_dois
	j pres_ini_um
	
pres_wrd_dois:
	addi $s1, $zero, 3
pres_ini_dois:
	lb $t3, array_seq + 4($s1)
	add $a0, $zero, $t3
	jal pisca
	addi $t2, $t2, 1
	beq $t2, $s0, fim_apres
	subi $s1, $s1, 1
	bltz $s1, pres_wrd_tres
	j pres_ini_dois

pres_wrd_tres:
	addi $s1, $zero, 3
pres_ini_tres:
	lb $t3, array_seq + 8($s1)
	add $a0, $zero, $t3
	jal pisca
	addi $t2, $t2, 1
	beq $t2, $s0, fim_apres
	subi $s1, $s1, 1
	bltz $s1, pres_wrd_quatro
	j pres_ini_tres

pres_wrd_quatro:
	addi $s1, $zero, 3
pres_ini_quatro:
	lb $t3, array_seq + 12($s1)
	add $a0, $zero, $t3
	jal pisca
	addi $t2, $t2, 1
	beq $t2, $s0, fim_apres
	subi $s1, $s1, 1
	bltz $s1, pres_wrd_cinco
	j pres_ini_quatro
	
pres_wrd_cinco:
	addi $s1, $zero, 3
pres_ini_cinco:
	lb $t3, array_seq + 16($s1)
	add $a0, $zero, $t3
	jal pisca
	addi $t2, $t2, 1
	beq $t2, $s0, fim_apres
	subi $s1, $s1, 1
	bltz $s1, fim_apres
	j pres_ini_cinco
	
fim_apres:
	add $ra, $zero, $t8
	jr $ra
	
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
	add $t9, $zero, $ra	# Salvando o endere�o de retorno dessa fun��o
	
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
	addi $a0, $zero, 700
	syscall
	lw $a0, qdr_1		
	lw $a1, dark_red
	jal pinta_quadrado
	addi $v0, $zero, 32
	addi $a0, $zero, 300
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
	addi $a0, $zero, 700
	syscall
	lw $a0, qdr_2		
	lw $a1, dark_green
	jal pinta_quadrado
	addi $v0, $zero, 32
	addi $a0, $zero, 300
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
	addi $a0, $zero, 700
	syscall
	lw $a0, qdr_3		
	lw $a1, dark_blue
	jal pinta_quadrado
	addi $v0, $zero, 32
	addi $a0, $zero, 300
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
	addi $a0, $zero, 700
	syscall
	lw $a0, qdr_4		
	lw $a1, dark_yellow
	jal pinta_quadrado
	addi $v0, $zero, 32
	addi $a0, $zero, 300
	syscall
	j default

default:
	add $ra, $zero, $t9	# Recuperando o endere�o de retorno dessa fun��o
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
