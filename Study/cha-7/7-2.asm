assume cs:code,ds:data

data segment
	db 'ibm             '
	db 'dec             '
	db 'dos             '
	db 'vax             '
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	
	mov bx,0
	mov cx,4	;外层循环，4行
	
s0:	mov dx,cx	;将外层循环的cx值保存在dx中
	mov si,0

	mov cx,3	;内层循环，3列
	
s:	mov al,[bx+si]
	and al,11011111b	;转换为大写
	mov [bx+si],al
	inc si
	loop s
	
	add bx,16
	mov cx,dx
	loop s0
	
	mov ax,4c00h
	int 21h
code ends
end start




