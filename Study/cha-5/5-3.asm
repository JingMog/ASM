assume cs:code

code segment
	mov ax,0ffffh
	mov ds,ax
	mov bx,6    ;����ds:bxָ��ffff:6�ڴ浥Ԫ
	
	mov al,[bx]
	mov ah,0h
	
	mov dx,0    ;��ʼ���ۼ���
	
	mov cx,123  ;ѭ��123��
	s:add dx,ax
	loop s
	
	
	mov ax,4c00h
	int 21h
code ends

end
