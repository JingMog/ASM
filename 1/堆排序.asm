datas segment
    ;此处输入数据段代码 
    num db '?'                      ;输入数据个数
    tmp dw 0                        ;暂存数字
    buf dw 200 dup('?')             ;输入数据
    sae dw 4   dup('?')
    str1 db 'input number, the range is 1 to 65534, and divided by blank$'
    str2 db 'input error! you must input again$'
    arr db 47,49,48,50,46,88,81,43,42,41
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
    call crlf               ;换行
    call input

    mov di,offset buf       ;di存放数组的位置
    mov cl,num              ;cx存放数组长度
    mov ch,0                    
    call heapsort            ;调用排序算法

    call crlf               ;换行

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
    mov bx, ax                      ;把高位寄存到bl    
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


heapsort proc near
	push bx
	push di
	mov cx, bx
fori:  
	push cx                     ;保存外层循环次数
    ;注意到外层第1次循环，内循环执行CX-1次，外层第2次循环，内循环执行CX-2次，...控制外循环的cx值恰就是内层循环次数
    push di


forj:;内层循环
	mov ax, [di]                ;(ax)即a[j]
    cmp ax, [di + 2]            ;a[j]与a[j+1]比较
    jbe nextnum                 ;a[j]<=a[j+1]时,跳到下一步nextnum不交换
    xchg ax, [di + 2]           ;交换
    mov [di], ax                ;最终效果是a[j]与a[j+1]交换了

;循环控制和转跳部分
nextnum: 
	add di, 2                   ;下一个数,j++
    loop forj	                ;内层循环,使得CX--，然后再次执行，直到CX=0
    pop cx                      ;恢复外层循环的CX，相当于当前的内层for（j）结束了，执行外层的fori
    pop di
    loop fori                   ;外层循环	
	pop di
	pop bx
heapsort endp



;子程序,数字转化为字符串
num2str proc near               ;将buf整型数字转换为字符型并保存再sae中
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
  
;子程序,将一位转化为字符
disp proc near                      ;一位转换为字符型
    push ax
    push cx 
    push dx
    mov ax, bx                      ;把bx存储的十六进制送到ax做除法
    xor dx, dx
    div cx
    mov bx, dx                      ;把余数送到bx
    mov [si], ax                    ;把商送到sae中 
    pop dx
    pop cx
    pop ax
    ret
disp endp

;子程序,将sae中暂存的字符输出
print proc near                     ;将sae中存的字符串输出
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

;输出错误处理
error proc near;处理输入错误
    call crlf                       ;换行
    mov dx, offset str1
    mov ah, 9
    int 21h
    call crlf
    call crlf
    call crlf
    jmp start
    ret   
error endp

;子程序,输出换行符
crlf proc near                      ;回车换行
    mov dl, 0dh
    mov ah, 2
    int 21h
    mov dl, 0ah
    mov ah, 2
    int 21h
    ret
crlf endp

;子程序,输出空格符
blank proc near                     ;空格符
    mov dl, ' '
    mov ah, 2
    int 21h
    ret
blank endp


; for(int i=arr.length/2-1;i>=0;i--)
;         {
;             // 从第一个非叶子节点从下到上，从右往左调整结构
;             adjustheap(arr,i,arr.length);
;         }
;子程序,建堆
bulidheap proc near
    mov cx,25                   ;外循环循环25次,即调用25次sift
	mov si,24
	mov bx,49                   ;子程序sift循环49次

buildheaploop:
	push si                     ;保存寄存器值
	call sift                   ;调整堆
	pop si                      ;恢复寄存器值
	dec si                      ;寻址变量--,i--
	loop buildheaploop          ;以上建堆过程，以下调整堆

    ret
bulidheap endp

; // 2.调整堆结构+交换堆顶元素与末尾元素
;         for(int j=arr.length-1;j>0;j--)
;         {
;             // 将堆顶元素与末尾元素进行交换
;             swap(arr,0,j);
;             // 重新对堆进行调整
;             adjustheap(arr, 0, j);
;         }
;子程序,调整堆
adjustheap proc near
	mov cx,49                   ;外循环循环49次,即调用49次sift,每一个节点都要交换
	mov si,0                    ;变址寻址
	mov bx,48                   ;子程序sift循环48次
    ;最后一次手动调整

adjustheaploop:
;调整堆

	mov al,arr[si]              ;arr[i]
	mov ah,arr[bx][1]           ;末尾元素
	mov arr[si],ah              ;交换堆顶元素与末尾元素
	mov arr[bx][1],al

	push si                     ;保存i值
	call sift                   ;adjustheap(arr,0,i);
	pop si                      ;恢复i值
	dec bx
	loop adjustheaploop

    ;最后一次调整
    mov al,arr[si]
	mov ah,arr[1]
	mov arr[si],ah
	mov arr[1],al

    ret
adjustheap endp


; void adjustheap(int[] arr, int i, int length) {
;     int temp=arr[i];
;     // 从i节点的左子节点开始，也就是2*i+1 然后继续往下调整 就是保证以他为首的树是大根堆
;     for(int k=i*2+1;k<length;k=k*2+1)
;     {
;         // 如果左子节点小于右子节点，k指向右子节点
;         if(k+1<length&&arr[k]<arr[k+1]){
;             k++;
;         }
;         // 如果子节点大于父节点，将子节点值赋给父节点（不用进行交换）
;         if(arr[k]>temp) {
;             arr[i]=arr[k];
;             i=k;
;         }else {
;             break;
;         }
;     }
;     arr[i]=temp;//将temp值放到最终的位置
; }

;子程序,调整堆
;以si为根调整堆
sift proc near

siftloop:
    ;从i节点的左子节点开始，也就是2*i+1 然后继续往下调整 就是保证以他为首的树是大根堆
    mov ax,si                   ;ax存放i
    add si,si                   ;2i+1
    mov dl,arr[si][1]           ;dl存放2i+1,即左孩子
    mov si,ax                   ;si再次恢复i

    mov ax,si                   ;i
    add al,al
    add al,2                    ;2i+2,右孩子
    cmp al,bl
    jnbe swap                   ;判断2i+2是否超出比较范围即没有右子树

;比较左右孩子的值,如果左孩子大于右孩子,则交换
    mov ax,si                   ;i
    add si,si
    cmp dl,arr[si][2]           ;判断左孩子是否小于右孩子
    mov si,ax
    jge swap                ;如果左孩子大于右孩子，则交换左孩子和右孩子的值

;比较右孩子和根节点的值,如果右孩子小于根节点的值,就交换
    mov ax,si
    add si,si                   ;2i+1
    mov dl,arr[si][2]           ;dl存放2i+2,即右孩子
    mov si,ax
    cmp arr[si],dl              ;判断右孩子是否小于根节点
    jge quit                    ;大于等于就跳转

;交换根节点和右孩子
    xchg dl,arr[si]             ;交换右孩子和根节点的值
    mov ax,si
    add si,si
    mov arr[si][2],dl           ;将右孩子的值放到2i+2
    mov si,ax
    add si,1
    add si,si
    jmp continue2

swap:
;交换根节点和左孩子
    cmp arr[si],dl              ;比较左孩子和右孩子的值
    jge quit                    ;大于等于就跳转
    xchg dl,arr[si]             ;交换左孩子和右孩子的值
    mov ax,si
    add si,si
    mov arr[si][1],dl           ;将右孩子的值放到2i+1
    mov si,ax
    add si,si
    add si,1

continue2:
    ;循环变量自加
    mov ax,si
    add si,si
    add si,1                    ;往下移动
    cmp si,bx                   ;判断循环是否结束
    mov si,ax
    jbe siftloop                ;继续循环

quit:
    ret
sift endp




codes ends
    end start










