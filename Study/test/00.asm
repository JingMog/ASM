assume cs:code,ds:data

data segment 
	db 'hello world!',0
data ends

code segment
main:
	;ds����ʾ������
	mov ax,0B800h
	mov ds,ax
	
	;es���ַ����̵�ַ
	mov ax,data
	mov es,ax
	
	;ds:di ��ʾ������
	;es:si �ַ���
	mov si,0
	mov di,0
	
	;ʹ��jcxz���ж��ַ��Ƿ����
	;����ʱ�ַ�Ϊ0���ƶ���cx�м����ж�
string:
	mov cx,es:[si]
	jcxz next
	
	mov al,es:[si]
	mov ah,00001010B
	mov ds:[di],ax
	
	add si,1
	add di,2
	
	jmp string
next:
	nop
	mov ax,4c00h
	int 21h
	
code ends
end main







