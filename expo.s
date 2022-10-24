 .section .data

input_x_prompt  :   .asciz "Please enter x: "
input_y_prompt  :   .asciz "Please enter y: "
input_spec      :   .asciz "%d"
result          :   .asciz "x^y = %d\n"

.section .text

.global main

main:
    // outputting message to enter x
    ldr x0, =input_x_prompt
    bl printf

    // intaking x
    sub sp, sp, 16
    ldr x0, =input_spec
    mov x1, sp
    bl scanf
    ldr x19, [sp, 0]

    // outputting message to enter y
    ldr x0, =input_y_prompt
    bl printf

    // intaking y
    ldr x0, =input_spec
    mov x1, sp
    bl scanf
    ldr x20, [sp, 0]        //storing y in x20

    add sp, sp, 16          //restoring stack pointer
    

    // if x is 0, result will be 0 (branch to else)
    cbz x19, else

    // else if y < 0, result will be 0 (branch to else)
    subs xzr, x20, xzr
    b.lt else

    // else if y is 0, result will be 1 (branch to other)
    cbz x20, other

    // else move into arguments and branch to recursive function
    mov x0, x19             //x
    mov x1, x20             //y
    bl expo
    
    // print result for general case
    ldr x0, =result
    mov x1, x2
    bl printf

    b exit


// return (x * pow(x, y-1))
expo:
    //if y is 0, return 1 (x2 is return register), otherwise call recursive function
    cbnz x1, recursive
    mov x2, 1
    br x30                  // 1 is returned in x2
    
recursive:
    sub sp, sp, 24
    stur x30, [sp, 16]
    stur x1, [sp, 8]        // y
    stur x0, [sp, 0]        // x
    
    sub x1, x1, 1           // decrementing y
        bl expo

    ldr x30, [sp, 16]
    ldr x1, [sp, 8]
    ldr x0, [sp, 0]

    mul x2, x2, x0          // multiply return's value by the value of x in each iteration
    
    add sp, sp, 24
    br x30                  // x2 is returned
    
// branch for a result of 0
else:
    ldr x0, =result
    add x1, x1, 0
    bl printf
    b exit

// branch for a result of 1
other:
    ldr x0, =result
    add x1, x1, 1
    bl printf
    b exit

exit:
	mov x0, 0
	mov x8, 93
	svc 0
	ret
