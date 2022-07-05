assume cs:code,ds:data

data segment

data ends

code segment
main:

    ;分支结构
    mov ax,1
    mov bx,2
    cmp ax,bx
    je equal        ;等于
    jb below        ;小于
    jnb above       ;不等于，不小于，即大于
    jmp next

equal:
    mov ax,10h
    jmp next
below:
    mov ax,20h
    jmp next
above:
    mov ax,30h
    jmp next

next:
    nop
    mov ax,4c00h
    int 21h
code ends

end main




