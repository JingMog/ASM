	.model small
	.data
		buf db 100,0,100 dup('$'),'$',13,10
	.code
start:
	mov ax,@data
	mov ds,ax
main:
	mov ah,0ah
	mov dx,offset buf
	int 21h
	mov cl,buf+1
	mov bx,offset buf+2
	call Str2Num
	call EndLine
	push bx
	call Num2Str
	pop dx
	mov ah,09h
	int 21h
	jmp endd
Str2Num: ;长度保存于cl,buffer开始于bx,结果返回在dx
	push cx
	push bx
	push ax
	mov ch,0h
	mov dx,0h
  _CalcNum:
  	mov ax,10d
  	mul dx
  	mov dx,ax
  	mov al,[bx]
  	sub al,30h
  	mov ah,0h
  	add dx,ax
  	add bx,1
	loop _CalcNum
	pop ax
	pop bx
	pop cx
	ret 
Num2Str: ;数字在dx,返回结果中buffer开始于bx,且自动加$,长度保存在cx
	push ax
	push dx
	push bx
	mov ax,dx
	mov cx,0h
  _Div10:
  	mov dl,10d
  	div dl
  	add ah,30h
  	mov [bx],ah
  	mov ah,0h
  	inc bx
  	inc cx
  	cmp ax,0
  	jnz _Div10
  	mov al,'$'
  	mov [bx],al;即$
  	pop bx
  	pop dx
	pop ax
	call RevStr
	ret
RevStr: ;个数为cx,开头在bx;返回结果buffer开始于bx
	push bx
	push cx
	push ax
	push dx
	push si
	mov ax,bx
	add ax,cx
	dec ax
	mov si,ax
  _OnRev:
  	push [bx]
  	mov al,[si]
  	mov [bx],al
  	pop ax
  	mov [si],al
  	inc bx
  	dec si
  	cmp bx,si
  	jb _OnRev
  	pop si
	pop dx
	pop ax
	pop cx
	pop bx
	ret
EndLine: ;回车换行
	push dx
	push ax
	mov dl,0ah
	mov ah,02h
	int 21h
	pop ax
	pop dx
	ret
endd:
	MOV AH,4CH
    INT 21H
end start

