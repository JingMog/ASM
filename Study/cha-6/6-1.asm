assume cs:code

code segment
	dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
	;定义字型数据
	;此时必须在debug中修改IP的值跳过dw
	;使用start可以指定程序入口
start:
	mov bx,0
	mov ax,0
	
	mov cx,8
	s:add ax,cs:[bx]
	add bx,2
	loop s
	
	mov ax,4c00h
	int 21h

code ends

end start
