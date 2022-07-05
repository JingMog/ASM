assume cs:code,ds:data,ss:stack

data segment
	dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
data ends


stack segment
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
stack ends


code segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,20h		;设置栈顶ss:sp指向stack:20
	
	mov ax,data
	mov ds,ax		;ds指向data段
	
	mov bx,0		;ds:bx指向data段中的第一个单元
	
	mov cx,8
s:	push [bx]
	add bx,2
	loop s
	
	mov bx,0
	mov cx,8
s1:	pop [bx]
	add bx,2
	loop s1
	
	mov ax,4c00h
	int 21h
code ends

end start

