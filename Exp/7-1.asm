
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

    ;此处可以使用.386来使用80386的双精度移位指令
    .386
    mov ax,71D2H
    mov cx,5DF1H
    SHRD ax,cx,1
    SHRD ax,cx,1
    SHLD cx,ax,1
    SHLD cx,ax,1
    SHLD cx,ax,1
    SHLD cx,ax,1

	mov ax,4c00h
	int 21h
code ends
end start

