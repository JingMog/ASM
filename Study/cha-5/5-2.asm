assume cs:code

code segment
	mov ax,0ffffh
	mov ds,ax
	mov bx,6   ;设置ds:bx指向ffff:0006h
	
	mov al,[bx]
	mov ah,0    ;设置ax的值为ffff:6内存单元的值
	
	mov dx,0   ;累加寄存器清零
	
	mov cx,3
	s:add dx,ax
	loop s
	
	mov ax,4c00h
	int 21h
	
code ends

end
