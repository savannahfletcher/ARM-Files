.section .data

input_prompt    :   .asciz  "Input a string: "
input_spec		:   .asciz	"%[^\n]"
length_spec 	:   .asciz	"String length: %d\n"
palindrome_spec :   .asciz  "String is a palindrome (T/F): %c\n"
input			:   .space	255

.section .text

.global main

main:
	ldr x0, =input_prompt
	bl printf //outputting initial message

	ldr x0, =input_spec
	ldr x1, =input
	bl scanf //intaking string input

    ldr x0, =length_spec
    ldr x9, =input
    add x19, xzr, xzr   //variable for char index
    add x20, xzr, xzr   //variable for string length
    L1:     add x10, x19, x9
            ldurb w11, [x10, 0]
            cbz x11, L2
            add x19, x19, 1    //increment index at end of loop
            add x20, x20, 1    //increment length at end of loop
            b L1
    L2:     mov x1, x20    //printing length of string
            bl printf
    cbz x20, L4    //if the length of string is 0, branch to L4 (true)
    sub x25, x20, 1
    cbz x25, L4    //if the length of string is 1, branch to L4 (true)
    ldr x9, =input
    add x18, xzr, xzr    //lower index
    sub x19, x20, 1    //upper index: length - 1
    L3:     add x12, x18, x9    //new var, lower lim, input
            ldrb w13, [x12, 0]
            add x14, x19, x9    //new var, upper lim, input
            ldrb w15, [x14, 0]
            sub x17, x13, x15
            cbnz x17, else    //if they are not the same char, branch to Else
            sub x23, x19, x18
            sub x23, x23, 1
            cbz x23, L4    //if the difference in lims is 1, branch to L4 (string of even length)
            add x18, x18, 1
            sub x19, x19, 1
            sub x21, x19, x18
            cbz x21, L4    //if the difference in lims is 0, branch to L4 (string of odd length)
            b L3
            else:   ldr x0, =palindrome_spec    //branch for false case
                    add w1, w1, 'F'
                    bl printf
                    b exit
    L4:     ldr x0, =palindrome_spec    //branch for true case
            add w1, w1, 'T'
            bl printf
            b exit

exit:
	mov x0, 0
	mov x8, 93
	svc 0
	ret
