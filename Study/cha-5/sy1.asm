;向内存0:200h~0:23Fh一次传送数据0~63(3Fh)
assume cs:code

code segment
	mov ax,0020h  
	mov ds,ax		;设置段寄存器
	mov bx,0		;设置循环变量
	
	mov cx,64		;设置循环计数器
	
	s:mov [bx],bx
	inc bx
	loop s
	
	mov ax,4c00h
	int 21h
code ends

end
