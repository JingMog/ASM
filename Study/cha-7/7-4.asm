assume cs:code,ds:data,ss:stack

data segment
	db 'ibm             '
	db 'dec             '
	db 'dos             '
	db 'vax             '
data ends

stack segment
	dw 0,0,0,0,0,0,0,0	;����һ���Σ�������Ϊջ������Ϊ16���ֽ�
	
stack ends

code segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,16			;��ʼ��ջ�Ĵ���
	
	mov ax,data
	mov ds,ax			;��ʼ���μĴ���
	
	mov bx,0
	mov cx,4			;���ѭ����4��
	
s0:	push cx				;�����ѭ����cxֵ��ջ
	mov si,0

	mov cx,3			;�ڲ�ѭ����3��
	
s:	mov al,[bx+si]
	and al,11011111b	;ת��Ϊ��д
	mov [bx+si],al
	inc si
	loop s
	
	add bx,16
	pop cx				;��ջ������ԭcx��ֵ���ָ�cx
	loop s0
	
	mov ax,4c00h
	int 21h
code ends
end start




