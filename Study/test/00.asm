assume cs:code,ds:data

data segment 
	db 'hello world!',0
data ends

code segment
main:
	;ds，显示缓冲区
	mov ax,0B800h
	mov ds,ax
	
	;es，字符串短地址
	mov ax,data
	mov es,ax
	
	;ds:di 显示缓冲区
	;es:si 字符串
	mov si,0
	mov di,0
	
	;使用jcxz来判断字符是否结束
	;结束时字符为0，移动到cx中即可判断
string:
	mov cx,es:[si]
	jcxz next
	
	mov al,es:[si]
	mov ah,00001010B
	mov ds:[di],ax
	
	add si,1
	add di,2
	
	jmp string
next:
	nop
	mov ax,4c00h
	int 21h
	
code ends
end main







