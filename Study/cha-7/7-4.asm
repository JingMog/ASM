assume cs:code,ds:data,ss:stack

data segment
	db 'ibm             '
	db 'dec             '
	db 'dos             '
	db 'vax             '
data ends

stack segment
	dw 0,0,0,0,0,0,0,0	;定义一个段，用来做为栈，容量为16个字节
	
stack ends

code segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,16			;初始化栈寄存器
	
	mov ax,data
	mov ds,ax			;初始化段寄存器
	
	mov bx,0
	mov cx,4			;外层循环，4行
	
s0:	push cx				;将外层循环的cx值入栈
	mov si,0

	mov cx,3			;内层循环，3列
	
s:	mov al,[bx+si]
	and al,11011111b	;转换为大写
	mov [bx+si],al
	inc si
	loop s
	
	add bx,16
	pop cx				;从栈顶弹出原cx的值，恢复cx
	loop s0
	
	mov ax,4c00h
	int 21h
code ends
end start




