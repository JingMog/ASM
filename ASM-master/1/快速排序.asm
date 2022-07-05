datas segment
    ;此处输入数据段代码 
    num db '?'                      ;输入数据个数
    tmp dw 0                        ;暂存数字
    buf dw 200 dup('?')             ;存储输入数据
    sae dw 4   dup('?')
    str1 db 'input number, the range is 1 to 65534, and divided by blank$'
    str2 db 'input error! you must input again$'
datas ends

stacks segment
    ;此处输入堆栈段代码
stacks ends

codes segment
    assume cs:codes,ds:datas,ss:stacks
start:
    mov ax,datas
    mov ds,ax
    ;此处输入代码段代码
    mov dx, offset str1
    mov ah, 9
    int 21h
    call crlf                           ;换行
    call input

                                    
    call call_quick_sort                ;调用排序算法

    call crlf

    xor cx, cx
    mov cl, [num]
    mov di, offset buf
show:
    mov bx, [di]  
    call num2str            ;一个数整型转换为字符型                                        
    call print              ;打印一个数据
    call blank              ;输出空格
    add di, 2               ;对下一个数据进行操作
    loop show                                 

    mov ah, 4ch                                    
    int 21h                


input proc near       ;输入数据将数据保存至buf中，数据个数保存至num中
    mov di, offset buf
    mov cl, 0                   ;cl记录一共输入了多少个数
first:
    mov ax, tmp
    mov bx, 10                  ;从高位到低位输入
    mul bx                      ;每输入一个低位，高位数要乘10
    mov bx, ax                  ;把高位寄存到bl    
    mov ah, 1                   ;输入一个字符
    int 21h
    cmp al, ' '                 ;判断输入是否为空格，若是则保存这个数
    jz  save_num
    cmp al, 0dh                 ;判断输入是否为回车，若是，跳到exit
    jz exit0
    cmp al, '0'                 ;输入字符要在0-9内
    jb  input_error
    cmp al, '9'
    ja  input_error
    sub al, 30h                 ;转化为数字
    xor ah, ah
    add bx, ax                  ;高位和低位相加
    mov tmp, bx                 ;把结果存储到tmp
    jmp first;下一个字符
save_num:
	mov bx, tmp                 ;把输入的数存储到buf中
    mov [di], bx
    add di, 2                   ;di指针指向下一个位置
    inc cl                      ;个数加一
    mov tmp, 0                  ;tmp清零
    jmp first
exit0:
    mov bx, tmp                 ;把输入的数存储到buf中
    mov [di], bx
    inc di                      ;di指针指向下一个位置
    inc cl                                          
    mov [num], cl               ;把个数储存到num
    mov tmp, 0                                      
    ret
input_error:
    call error
    ret
input endp


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


;快速排序
;准备左侧指针和右侧指针
call_quick_sort proc near
	mov  si, offset buf  				;si为左侧指针,i
    push ax
    mov  al, num                        ;num
    mov  ah, 0
    add  ax, ax                         ;2*num,表示字节数
	mov  di, ax						    ;di为arr长度
    pop  ax

    add  di, si
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








num2str proc near;将buf整型数字转换为字符型并保存再sae中
    push cx
    mov si, offset sae
    mov cx, 10000
    call disp 
    
    mov cx, 1000
    add si, 2
    call disp 
     
    mov cx, 100
    add si, 2
    call disp 
    
    mov cx, 10
    add si, 2                                       
    call disp 
    
    mov cx, 1
    add si, 2                                        
    call disp
    pop cx
    ret
num2str endp
  
disp proc near;一位转换为字符型
    push ax
    push cx 
    push dx
    mov ax, bx;把bx存储的十六进制送到ax做除法
    xor dx, dx
    div cx
    mov bx, dx;把余数送到bx
    mov [si], ax;把商送到sae中 
    pop dx
    pop cx
    pop ax
    ret
disp endp
   
print proc near;将sae中存的字符串输出
    push cx;去0
    xor cx, cx
    mov cl, 6 
    mov si, offset sae
    dec si
    dec si
first1:
    dec cl
    add si, 2
    cmp [si], byte ptr 0
    jz  first1
write:                                
    mov dl, [si]
    add dl, 30h
    mov ah, 2
    int 21h
    add si, 2
    loop write
    pop cx
    ret
print endp 

error proc near;处理输入错误
    call crlf               ;换行
    mov dx, offset str1
    mov ah, 9
    int 21h
    call crlf
    call crlf
    call crlf
    jmp start
    ret   
error endp
  
crlf proc near;回车换行
    mov dl, 0dh
    mov ah, 2
    int 21h
    mov dl, 0ah
    mov ah, 2
    int 21h
    ret
crlf endp
  
blank proc near;空格符
    mov dl, ' '
    mov ah, 2
    int 21h
    ret
blank endp

codes ends
    end start

