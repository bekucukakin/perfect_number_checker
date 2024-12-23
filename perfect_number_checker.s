.data
prompt: .asciiz "Enter a number (or 0 to exit): "
result_msg: .asciiz " is a perfect number.\n"
not_perfect_msg: .asciiz " is not a perfect number.\n"
newline: .asciiz "\n"
num: .word 0

.text
.globl main

main:
    # Start of the loop
input_loop:
    # Print prompt
    li $v0, 4            # Print string syscall code
    la $a0, prompt       # Load the address of prompt string
    syscall

    # Read integer from user
    li $v0, 5            # Read integer syscall code
    syscall
    move $t2, $v0        # Move the input number to $t2

    # Check if the input number is 0 (exit condition)
    beq $t2, $zero, exit_program

    # Store the input number in memory
    sw $t2, num          # Store the input number in the num variable

    # Start checking if the number is perfect
    li $t0, 1            # Start divisor from 1
    li $t1, 0            # Initialize sum of divisors to 0

check_divisors:
    lw $t3, num          # Load the input number from memory

    div $t3, $t0         # Divide the input number by the divisor
    mfhi $t4             # Get the remainder

    bnez $t4, not_divisor  # If remainder is not 0, it's not a divisor

    add $t1, $t1, $t0    # Add the divisor to the sum of divisors

not_divisor:
    addi $t0, $t0, 1     # Increment the divisor
    blt $t0, $t3, check_divisors  # Continue checking until divisor is less than the number

    # Check if the number is perfect or not
    beq $t1, $t3, perfect_number  # If the sum of divisors equals the number, it's perfect

    # If the program reaches here, the number is not perfect
    # Print result
    li $v0, 1            # Print integer syscall code
    move $a0, $t2        # Move the input number to $a0
    syscall

    li $v0, 4            # Print string syscall code
    la $a0, not_perfect_msg  # Load the address of not_perfect_msg string
    syscall

    j input_loop        # Jump back to input loop

perfect_number:
    # Print result
    li $v0, 1            # Print integer syscall code
    move $a0, $t2        # Move the input number to $a0
    syscall

    li $v0, 4            # Print string syscall code
    la $a0, result_msg   # Load the address of result_msg string
    syscall

    j input_loop        # Jump back to input loop

exit_program:
    # Exit the program
    li $v0, 10           # Exit syscall code
    syscall