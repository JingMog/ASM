assume cs:code,ds:data

data segment

    db 'Welcome to masm!'
    db 16 dup(0)

data ends

code segment
main:
    mov ax,data
    mov ds,ax           ;ds初始化

    mov si,0
    mov es,ax
    mov di,16           ;es指向16个空字节

    cld                 ;将DF清零，即右移
    mov cx,16           ;循环16次
    rep movsb


    mov ax,4c00h
    int 21h


code ends

end main