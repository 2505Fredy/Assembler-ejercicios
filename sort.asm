.macro swap(%a, %b) #Cambia los valores en memoria de los punteros a y b
  lw $t2, 0(%a)
  lw $t3, 0(%b)
  sw $t3, 0(%a)
  sw $t2, 0(%b)
.end_macro


.macro printArray(%array, %sizeArray) #Imprime una lista de enteros de longitud sizeArray
  add $t1, $zero, %sizeArray
  add $t6, $zero, %array
  li $t2, 0
  while0:
    beq $t2, $t1, endwhile0
    add $t3, $t2, $t2
    add $t3, $t3, $t3
    addi $t2, $t2, 1
    add $t4, $t6, $t3
    lw $t5, 0($t4)
    addi $a0, $t5, 0
    li $v0, 1
    syscall
    la $a0, space
    li $v0, 4
    syscall
    j while0
  endwhile0:
  la $a0, enter
  li $v0, 4
  syscall
.end_macro


.macro maxInArray(%beggin, %sizeArray, %max)#Se obtiene en max el puntero al valor máximo de la lista que comienza en beggin y es de longitud sizeArray
  add $t0, $zero, %beggin
  add $t1, $zero, %sizeArray
  li $t2, 0
  add %max, $zero, $t0
  lw $t8, (%max) # $t8=valor máximo
  while:
    addi $t2, $t2, 1 #p++
    beq $t1, $t2, endWhile #if p==sizeArray => endWhile
    add $t3, $t2, $t2
    add $t3, $t3, $t3 #Multiplica por 4 el valor de $t2, para evaluar en formato word(4-byte)
    add $t3, $t3, $t0 #apunta a la variable array[$t2]
    lw $t4, 0($t3)
    slt $t5, $t8, $t4 # $t8 < $t4? $t5=1 : $t5=0
    beq $t5, $zero, while #Si ~($t8 < $t4) el valor máximo sigue siendo $t8, el puntero no se modifica, regresa al bucle
    add %max, $zero, $t3 #Caso contrario, el valor del puntero al max cambia a la dirección de $t4
    lw $t8, (%max)
    j while
  endWhile:
.end_macro


.text
  .globl _start
  _start:
    la $s0, array # $s0= puntero a beggin del array
    la $s1, sizeArray 
    lw $s2, 0($s1) #$s2= tamanho del array
    addi $s4, $s2, 0
    li $s3, 0
    la $a0, text1
    li $v0, 4
    syscall
    printArray($s0, $s2)
    for:
      beq $s3, $s2, endfor
      maxInArray($s0, $s4, $s5) #Se obtiene en $s5 el puntero al valor máximo del array de tamanho $s4
      addi $t1, $s4, -1 #Se obtiene en $t1 el índice al último valor del array evaluado de tamanho $s4
      add $t0, $t1, $t1
      add $t0, $t0, $t0
      add $s7, $t0, $s0 # $t7= puntero al último valor del array evaluado de tamanho $s4
      swap($s5, $s7) #Intercambia los valores del puntero al máximo($s5) y del puntero al último elemento del array($s7) evaluado en longitud $s4
      addi $s4, $s4, -1 #Se disminuye el tamanho del array para seguir evaluando; puesto que, en la última posición del array ya está el valor máximo
      addi $s3, $s3, 1 
      j for
    endfor:
    la $a0, text
    li $v0, 4
    syscall
    printArray($s0, $s2)
    
    
    
.data
  array: .word 56, 45, 75, 23, 32, 10, 78, 40, 32, 48
  sizeArray: .word 10
  text: .asciiz "La lista ordenada es:\n"
  text1: .asciiz "La lista antes de ordenar es:\n"
  enter: .asciiz "\n"
  space: .asciiz " "
