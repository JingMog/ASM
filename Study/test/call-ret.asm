assume cs:code, ds:data


;���ݶ�
data segment
	hello db 'Hello world.I am JsingMog!$'
	
data ends


;�����
code segment
start:
	mov ax,data
	mov ds,ax
	
	;����print����
	call print
	
	mov ah,4CH
	int 21H
	
	
;print����
print:
	mov dx,offset hello
	mov ah, 9H
	int 21H
	ret

code ends



end start
