assume cs:code,ds:data

data segment

data ends

code segment
start:
	;mov dx,1
	;mov ax,86A1h
	;mov bx,100
	;div bx
	
	mov ax,1001
	mov bl,100
	div bl
	
	mov ax,4c00h
	
	int 21h
code ends
end start





