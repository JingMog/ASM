assume cs:code,ds:data

data segment
	db 'ibm             '
	db 'dec             '
	db 'dos             '
	db 'vax             '
	db 0					;����һ���֣������ݴ�cx
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	
	mov bx,0
	mov cx,4			;���ѭ����4��
	
s0:	mov ds:[40h],cx		;�����ѭ����cxֵ������dx��
	mov si,0

	mov cx,3			;�ڲ�ѭ����3��
	
s:	mov al,[bx+si]
	and al,11011111b	;ת��Ϊ��д
	mov [bx+si],al
	inc si
	loop s
	
	add bx,16
	mov cx,ds:[40h]		;��data:40h��Ԫ���ָ�cx
	loop s0
	
	mov ax,4c00h
	int 21h
code ends
end start




