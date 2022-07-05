
assume cs:code,ds:data,ss:stack

data segment
	x dw 71D2H
    y dw 5DF1H
data ends

stack segment
    dw 8 dup(0) 
stack ends

code segment
start:

	;将71D2H存至AX中，5DF1H存至CX中，DST(目的操作数)为71D2H，REG(源操作数)为5DF1H，实现双精度右移2次，交换DST与REG，然后左移4次，分别查看结果
	mov ax,data
    mov ds,ax           ;初始化ds段寄存器
    mov ax,stack
    mov ss,ax
    mov sp,16           ;初始化栈


    mov ax,0F171H       ;用ax存放cx的低8位和ax的高8位
    mov cl,2
    shr ax,cl           ;实现ax的逻辑右移两次
    mov bx,ax           ;用bx来暂存ax

    mov ax,x
    mov cl,2
    shr ax,cl           ;对x进行逻辑右移
    mov ah,bl
    ;最后ax为05C74H

    ;交换源操作数和目的操作数，左移4位
    mov ax,0F171H
    mov cl,4
    shl ax,cl           ;实现ax的逻辑右移两次
    mov bx,ax           ;用bx来暂存ax

    mov ax,y
    mov cl,4
    shl ax,cl
    mov al,bh
    ;结果为DF17H
    ;1101 1111 0001 0111B

    ;AX为0111 0001 1101 0010
    ;CX为0101 1101 1111 0001


    ;此处可以使用.386来使用80386的双精度移位指令
	mov ax,4c00h
	int 21h
code ends
end start

