assume cs:code

code segment
	mov ax,0ffffh
	mov ds,ax
	mov bx,6   ;����ds:bxָ��ffff:0006h
	
	mov al,[bx]
	mov ah,0    ;����ax��ֵΪffff:6�ڴ浥Ԫ��ֵ
	
	mov dx,0   ;�ۼӼĴ�������
	
	mov cx,3
	s:add dx,ax
	loop s
	
	mov ax,4c00h
	int 21h
	
code ends

end
