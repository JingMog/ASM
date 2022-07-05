assume cs:code,ds:data,ss:stack

data segment
	arr dw 12,34,2,4,1,38,60,47,99,55			;待排序数组	
	num dw 20									;数据长度
	wel db 'welcome to the qucik sort program!', 13, 10, '$'
    str1 db 'before sort:', 13, 10, '$'
    str2 db 'after sort:', 13, 10, '$'
data ends

stack segment
	db 200h dup(?)
stack ends

code segment

;main 子程序
main proc far

; void quick_sort(int *arr, int begin, int end){
;     if(begin > end)
;         return;
;     int tmp = arr[begin];
;     int i = begin;
;     int j = end;
;     while(i != j){
;         while(arr[j] >= tmp && j > i)
;             j--;
;         while(arr[i] <= tmp && j > i)
;             i++;
;         if(j > i){

;             int t = arr[i];
;             arr[i] = arr[j];
;             arr[j] = t;
;         }
;     }
;     arr[begin] = arr[i];
;     arr[i] = tmp;
;     quick_sort(arr, begin, i-1);
;     quick_sort(arr, i+1, end);
; }


start:
	mov  ax,stack
	mov  ss,ax	
	mov  sp,200h						;初始化栈	
	
	push dx
	mov ax,0
	push ax
	
	mov  ax,data  
	mov  ds,ax							;初始化ds数据段寄存器

	mov dx,offset wel          		 	;欢迎语句
    mov ah, 09h
    int 21h

    mov dx,offset str1          		;排序前语句
    mov ah,09h
    int 21h
	
	call  disp							;输出排序结果
	call  print_crlf 					;换行
	call  print_crlf 					;换行

	call  call_quick_sort    			;调用快速排序

	;显示字符串"after sort"
    mov dx, offset str2         		;输出"after sort:"字符串
    mov ah, 09h
    int 21h

	call  disp							;
	call  print_crlf 					;换行
	ret
main endp


;快速排序
;准备左侧指针和右侧指针
call_quick_sort proc near
	mov  si, offset arr  				;si为左侧指针,i
	mov  di, num						;di为arr长度
	sub  di, 2    						;di为右侧指针,j

	call quicksort						;调用quicksort

	ret
call_quick_sort endp	

;quicksort子程序
;si,di相当于i和j
quicksort proc near
	cmp  si,di					;先判断是否结束
	jnl  end_quicksort       	;如果左侧不小于右侧,说明程序结束,跳转
	push di                  	;保存右侧指针
	push si			 		 	;保存左侧指针
	call quickpass				;调用quickpass

	pop  di             		;恢复寄存器
	pop  si		         		
	push di                	    ;保存基准数

	sub  di, 2   				;i-1
	cmp  si, di					;比较i,j
	jl   if_to					;小于
	jnl  else_to				;不小于
if_to:
	call quicksort              ;quicksort(arr,begin,i-1)
else_to:						;不小于
	pop  si 	             	
	pop  di                  	
	add  si, 2  				;i+1
	cmp  si, di					;
	jnl  end_quicksort
	
	call quicksort           	;quickaort(arr,i+1,end) 
end_quicksort : 
	ret
quicksort endp	


;quickpass程序
quickpass proc near 
	pop  bx					
	mov  dx,word ptr[si]   		;dx存储左侧值,即arr[i]

loop_out :
	cmp  si,di              	;50
	jnb  end_quickpass	    	;while(i!=j)

;相当于第一个while循环
loop_in1:
	cmp  si,di
	jnb  ignore_loop_in1		;j<=i就跳出while循环
	cmp  dx,word ptr[di]		;arr[j]和temp		
	ja   ignore_loop_in1		;arr[j]<tmp就跳出while循环
	sub  di, 2					;j--
	jmp  loop_in1				;继续while循环

ignore_loop_in1: 
	cmp  si,di					
	jnl  loop_in2             	;i>=j就跳转到下一个循环
	mov  ax, word ptr[di]		;否则交换arr[i]和arr[j]
	mov  [si],ax

;相当于第二个while循环
loop_in2:	
	cmp  si,di					;比较i和j
	jnb  ignore_loop_in2		;j<=i就跳出while循环
	cmp  word ptr[si],dx
	ja   ignore_loop_in2		;arr[i]>tmp就跳出while循环
	add  si, 2 					;i++
	jmp  loop_in2				;继续while循环
ignore_loop_in2: 
	cmp  si,di                
	jnl  ignore_swap  			;i>=j就跳转到下一个循环
	mov  ax,word ptr[si] 		;否则交换arr[i]和arr[j]
	mov  [di],ax

ignore_swap:
	jmp  loop_out
end_quickpass:	
	mov  [si],dx         	 	;arr[begin] = arr[i]
	push si	
	push bx		
	ret
quickpass endp


;disp子程序
;循环输出排序结果
disp proc near

	mov  bx, offset arr   ;循环变量,i
	
loop_outer:
	cmp  bx, num						
	jnb  end_outer_loop
	mov  bp, sp
	mov  ax, [bx]
loop_in:
	cmp  ax, 00h
	je   loop_disp
	mov  dx, 0000h
	mov  cx, 0ah 
	div  cx
	add  dl, 30h
	push dx
	jmp loop_in
		
loop_disp:	
	cmp  sp,bp
	jnb  end_loop_disp
	pop  dx
	mov  ah, 02h
	int  21h
	jmp  loop_disp
end_loop_disp:
	mov  dl, 20h         ;空格的ascii码,20h
	mov  ah, 02h
	int  21h

	add  bx, type arr
	jmp  loop_outer

end_outer_loop:
	ret
disp endp



;输出换行
print_crlf proc
		push 	ax
		push	bx
		push	dx
		
		mov 	ah, 02h
		mov		dx, 0dh
		int 	21h
		mov		dx, 0ah
		int 	21h
		
		pop		dx
		pop		bx
		pop		ax
		ret
print_crlf endp

;输出空白
print_space proc
		push 	ax
		push	dx
		mov 	ah, 02h
		mov		dl, 32
		int		21h
		pop		dx
		pop		ax
		ret
print_space endp




code ends
end start
