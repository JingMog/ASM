assume cs:code, ds:data


;数据段
data segment
	hello db 'Hello world.I am JsingMog!$'
	
data ends


;代码段
code segment
start:
	mov ax,data
	mov ds,ax
	
	;调用print函数
	call print
	
	mov ah,4CH
	int 21H
	
	
;print函数
print:
	mov dx,offset hello
	mov ah, 9H
	int 21H
	ret

code ends



end start
