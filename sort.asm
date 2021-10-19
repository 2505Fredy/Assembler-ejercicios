.macro swap(%a, %b)
  lw $t2, 0(%a)
  lw $t3, 0(%b)
  sw $t3, 0(%a)
  sw $t2, 0(%b)
.end_macro
.macro print_list(%list, %sizeList)
  add $t1, $zero, %sizeList
  li $t2, 0
  while0:
    beq $t2, $t1, endwhile0
    add $t3, $t2, $t2
    add $t3, $t3, $t3
    addi $t2, $t2, 1
    lw $t4, %list($t3)
    addi $a0, $t4, 0
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
.macro maxInList(%beggin, %sizeList, %max)
  add $t0, $zero, %beggin
  add $t1, $zero, %sizeList
  li $t2, 0
  add %max, $zero, $t0
  lw $t8, (%max)
  while:
    addi $t2, $t2, 1 #p++
    beq $t1, $t2, endWhile #if p==sizeList => end
    add $t3, $t2, $t2
    add $t3, $t3, $t3
    add $t3, $t3, $t0
    lw $t4, 0($t3)
    slt $t5, $t8, $t4
    beq $t5, $zero, while
    add %max, $zero, $t3
    j while
  endWhile:
.end_macro

#4cadena, 1int, 2float, 3double

.text
  .globl _start
  _start:
    la $s0, array
    la $s1, sizeArray 
    lw $s2, 0($s1) #$s2= tamanho del array
    add $s4, $zero, $s2
    li $s3, 0
    la $s5, array #variable maxima
    la $a0, text1
    li $v0, 4
    syscall
    print_list(array, $s2)
    while2:
      beq $s3, $s2, endwhile2
      maxInList($s0, $s4, $s5)
      add $t0, $s4, $s4
      add $t0, $t0, $t0
      add $s7, $t0, $s0
      swap($s5, $s7)
      add $s4, $s4, -1
      addi $s3, $s3, 1
      j while2
    endwhile2:
    
    la $a0, text
    li $v0, 4
    syscall
    print_list(array, $s2)
    
    
    
.data
  array: .word 6, 8, 3, 4, 1, 9, 0, 3, 6, 2
  sizeArray: .word 10
  text: .asciiz "La lista ordenada es:\n"
  text1: .asciiz "La lista antes de ordenar es:\n"
  enter: .asciiz "\n"
  space: .asciiz " "