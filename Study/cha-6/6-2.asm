assume cs:code

code segment
	;��������
	dw 0123h,0456h,0789h,0abch,0defh,0cbah,0987h
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	;��dw����16���������ݣ��ڳ�����غ󣬽�ȡ��16���ֵ�
	;�ڴ�ռ䣬�����16�����ݡ��ں���ĳ����н����
	;�ռ䵱��ջ��ʹ��
start:
	mov ax,cs
	mov ss,ax
	mov sp,32h			;����ջ��ss:spΪcs:32
	
	mov bx,0
	mov cx,8
	s:push cs:[bx]
	add bx,2
	loop s				;��0-15��Ԫ�е���������һ����ջ
	
	mov bx,0
	mov cx,8
	s0:pop cs:[bx]
	add bx,2
	loop s0				;���γ�ջ
	
	mov ax,4c00h
	int 21h
	

code ends

end start


