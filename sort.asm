.macro swap(%a, %b, %c)
  addi %c, %a, 0
  addi %a, %b, 0
  addi %b, %c, 0
.end_macro
.macro print_int(%a)
  li $a0, %a
  li $v0, 3
  syscall
.end_macro

#4cadena, 1int, 2float, 3double

.text
  .globl _start
  _start:
    la $a0, text
    li $v0, 4
    syscall
    la $a1, array
    la $a2, sizeArray
    lw $t0, array
    addi $a0, $t0, 0
    li $v0, 1
    syscall
    
    
    
    
    
.data
  array: .word 6, 8, 3, 4, 1, 9, 0, 3, 6, 2
  sizeArray: .word 10
  arraySorted: .space 40 #El tamaño debe ser 4 veces la longitud del array, porque un elemento ocupa 4-byte
  text: .asciiz "La lista ordenada es: "
