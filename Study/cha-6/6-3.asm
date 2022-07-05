assume cs:code
;依次用内存0:0-0:15单元中的内容修改程序中的数据
code segment
	dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
	
start:
	mov ax,0
	mov ds,ax
	mov bx,0
	
	mov cx,8
	s:mov ax,[bx]
	mov cs:[bx],ax
	add bx,2
	loop s
	
	mov ax,4c00h
	int 21h
code ends

end start

