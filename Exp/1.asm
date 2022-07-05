assume cs:code

code segment
main:
	;编写一个累计加法，从1加到5，将结果保存至AX中
	
    mov ax,0        ;初始化ax寄存器
    mov cx,5        ;循环5次
    mov bx,1        ;循环变量
s:
    add ax,bx       ;ax+bx，结果保存在ax中
    inc bx          ;bx自加
    loop s          ;循环相加
    
    ;相加之后AX结果为000FH
    
	mov ax,4c00h    ;正常结束
	int 21h
code ends
end main
