assume cs:code


code segment
	mov ax,0ffffh
	mov ds,ax   ;����dsΪffffh
	mov bx,0    ;bx��Ϊ��ַ����
	
	mov dx,0    ;��ʼ���ۼӼĴ���
	mov cx,12   ;��ʼ��ѭ�������Ĵ���
	
	s:mov al,[bx];ѭ����
	mov ah,0    ;ʹ��ax����ת
	add dx,ax	;
	inc bx      ;bxָ����һ����Ԫ
	loop s

	
	mov ax,4c00h
	int 21h
code ends

end
