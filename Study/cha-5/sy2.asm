assume cs:code

code segment
	mov ax,cs
	mov ds,ax		;���ǶμĴ�����ֵ
	
	mov ax,0020h
	mov es,ax		;ʹ����չ�μĴ������������ƹ���
	
	mov bx,0		;ѭ������
	mov cx,17h		;cxֵΪ����ĳ���1Bh,������
	;mov ax,4c00h
	;int 21hռ5���ֽڣ����cxӦ�ø�ֵΪ1Bh-5h=17h
	
	s:mov al,[bx]
	mov es:[bx],al
	inc bx
	loop s
	
	mov ax,4c00h
	int 21h
	
	

code ends

end

