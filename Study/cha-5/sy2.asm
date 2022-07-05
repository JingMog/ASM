assume cs:code

code segment
	mov ax,cs
	mov ds,ax		;这是段寄存器初值
	
	mov ax,0020h
	mov es,ax		;使用扩展段寄存器来辅助复制过程
	
	mov bx,0		;循环变量
	mov cx,17h		;cx值为程序的长度1Bh,而最后的
	;mov ax,4c00h
	;int 21h占5个字节，因此cx应该赋值为1Bh-5h=17h
	
	s:mov al,[bx]
	mov es:[bx],al
	inc bx
	loop s
	
	mov ax,4c00h
	int 21h
	
	

code ends

end

