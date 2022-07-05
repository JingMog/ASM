assume cs:code,ds:data

data segment
    a dw 0001h,0001h,0000h        ;f(n-1),f(n-2),结果
    n dw 10
data ends

code segment
    ;斐波纳契数列：1,1,2,3,5,8,13,21,34,55。通常可以使用递归函数实现，现用汇编实现该过程

; int Fibo(int n){
; 	if (n == 1 || n == 2){
; 		return 1;
; 	}
; 	else{
; 		return Fibo(n - 1) + Fibo(n - 2);
; 	}
; }

main:
	
    mov ax,data
    mov ds,ax
    mov si,0            ;数组下标
    mov bx,a[si]        ;bx存放f(n-1)
    mov dx,a[si+2]      ;dx存放f(n-2)

    mov ax,n            ;ax存放n
	; sub ax,1
    cmp ax,1           ;比较n与1
	; jz get_out1
    jna get_out1        ;小于等于就跳转至get_out1
    cmp ax,2            ;比较n与2
    je get_out2         ;小于等于就跳转至get_out2

    ;大于2
    mov cl,al
    sub cl,2
fun:
    mov ax,0            ;f(n)值从零开始
    add ax,bx           ;f(n)=f(n-1)+f(n-2)
    add ax,dx           ;f(n)=f(n-1)+f(n-2)
    mov dx,bx           ;f(n-2)=f(n-1)
    mov bx,ax           ;f(n-1)=f(n)
    mov a[si],bx        ;更新data中的值
    mov a[si+2],dx      ;更新data中的值
    loop fun            ;循环调用fun

    mov a[si+4],ax      ;保存结果
    jmp quit

get_out1:
    mov a[si+4],ax      ;直接将ax放入结果单元中
    jmp quit
get_out2:
    mov ax,1            ;n==2,结果为1
    mov a[si+4],ax
    jmp quit

quit:
    ;此时结果存放在a[si+4]中
    mov dx,a[si+4]
	call Num2Str
	mov dx,bx
    mov AH,09H
    int 21H


    mov ax,4C00H
    int 21H


;------数字转字符串的子程序-----
;数字在dx,返回结果中buffer开始于bx,且自动加$,长度保存在cx
Num2Str proc near 
	push ax
	push dx
	push bx
	mov ax,dx
	mov cx,0h
  _Div10:
  	mov dl,10d				;除以10
  	div dl					;除10获取个位数和十位数
  	add ah,30h				;加30H转换位ASCII码
  	mov [bx],ah				;将转换的字符串存入buffer
  	mov ah,0h				;高位清零
  	inc bx					;下一个字符
  	inc cx					;length++
  	cmp ax,0				
  	jnz _Div10				;非零就继续除以10,直到ax变为零
  	mov al,'$'				;添加'$'
  	mov [bx],al
  	pop bx					;恢复寄存器值
  	pop dx
	pop ax
	call RevStr				;调用倒置字符串的子程序,先输出高位
	ret
Num2Str endp

;------倒置字符串的子程序-----
;个数为cx,开头在bx;返回结果buffer开始于bx
RevStr proc near
	push bx
	push cx
	push ax
	push dx
	push si					;保存寄存器
	mov ax,bx				;ax为buffer的起始地址
	add ax,cx				;加上长度,变为最后一个字符的下一个地址
	dec ax					;length-1,
	mov si,ax				;si保存最后一个字符
;开始倒置
  _OnRev:
  	push [bx]				;保存bx指向的字符
  	mov al,[si]				;交换
  	mov [bx],al
  	pop ax					;恢复bx指向的字符到ax中
  	mov [si],al
  	inc bx					;i++
  	dec si					;j--
  	cmp bx,si				;比较i和j是否相遇
  	jb _OnRev
  	pop si					;恢复寄存器状态
	pop dx
	pop ax
	pop cx
	pop bx
	ret
RevStr endp

code ends

end main

