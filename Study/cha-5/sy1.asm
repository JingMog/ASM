;���ڴ�0:200h~0:23Fhһ�δ�������0~63(3Fh)
assume cs:code

code segment
	mov ax,0020h  
	mov ds,ax		;���öμĴ���
	mov bx,0		;����ѭ������
	
	mov cx,64		;����ѭ��������
	
	s:mov [bx],bx
	inc bx
	loop s
	
	mov ax,4c00h
	int 21h
code ends

end
