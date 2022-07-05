assume cs:code,ds:data

data segment 
	db 'hello world'
data ends

code segment
start:
	mov ax,data
	mov ds,ax			;��ʼ�����ݶμĴ���
	mov ax,0B800h		;��ɫ�ַ���ʾ��
	mov es,ax
	
	mov cx,12			;�ַ�����Ϊ12
	mov bx,0			;ѭ������
	mov si,320
s:
	mov ah,00h	
	mov al,02h

	mov es:[si],al		;��al��data���ַ�����al���е��ַ������ɫ��ʾ������

	
	inc si
	inc bx
	loop s
	
	mov ax,4c00H
	int 21H

code ends
end start








