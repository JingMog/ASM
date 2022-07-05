assume cs:code


code segment
	mov ax,0ffffh
	mov ds,ax   ;设置ds为ffffh
	mov bx,0    ;bx作为地址变量
	
	mov dx,0    ;初始化累加寄存器
	mov cx,12   ;初始化循环计数寄存器
	
	s:mov al,[bx];循环体
	mov ah,0    ;使用ax来中转
	add dx,ax	;
	inc bx      ;bx指向下一个单元
	loop s

	
	mov ax,4c00h
	int 21h
code ends

end
