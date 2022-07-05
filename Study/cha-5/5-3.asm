assume cs:code

code segment
	mov ax,0ffffh
	mov ds,ax
	mov bx,6    ;设置ds:bx指向ffff:6内存单元
	
	mov al,[bx]
	mov ah,0h
	
	mov dx,0    ;初始化累加器
	
	mov cx,123  ;循环123次
	s:add dx,ax
	loop s
	
	
	mov ax,4c00h
	int 21h
code ends

end
