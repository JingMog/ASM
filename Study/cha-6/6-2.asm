assume cs:code

code segment
	;定义数据
	dw 0123h,0456h,0789h,0abch,0defh,0cbah,0987h
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	;用dw定义16个字型数据，在程序加载后，将取得16个字的
	;内存空间，存放这16个数据。在后面的程序中将这段
	;空间当作栈来使用
start:
	mov ax,cs
	mov ss,ax
	mov sp,32h			;设置栈顶ss:sp为cs:32
	
	mov bx,0
	mov cx,8
	s:push cs:[bx]
	add bx,2
	loop s				;将0-15单元中的字型数据一次入栈
	
	mov bx,0
	mov cx,8
	s0:pop cs:[bx]
	add bx,2
	loop s0				;依次出栈
	
	mov ax,4c00h
	int 21h
	

code ends

end start


