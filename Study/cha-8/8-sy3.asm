assume cs:code,ds:data

data segment 
	db 'hello world!',0	;以0结尾的字符串，需要将其高亮显示
data ends

code segment
main:
	;ds 显示缓冲区的段地址
	mov ax,0B800h
	mov ds,ax

	;es 字符串的段地址
	mov ax,data
	mov es,ax

	;ds:di 显示缓冲区
	;es:si 字符串
	mov si,0
	mov di,320

string:
	mov cx,es:[si]
	jcxz next

	mov al,es:[si]
	mov ah,00001010B
	mov ds:[di],ax
	
	add si,1
	add di,2

	jmp short string

next:
	nop
	mov ax,4c00h
	int 21h


code ends
end main







