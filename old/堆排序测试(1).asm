DATAS SEGMENT
    ;此处输入数据段代码
    num DB '?';输入数据个数
    tmp DW 0;暂存数字
    num_tmp DB '?';暂存最大值所在位置
    buf DW 200 DUP('?');存储输入数据
    sae DW 4   DUP('?')
    str1 DB 'Input number, the range is 1 to 65534, and divided by blank$'
    str2 DB 'Input error! You must input again$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS


CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    mov dx, offset str1
    mov ah, 9
    int 21H
    call crlf
    call input

    xor dh, dh;获得BUF数组的头尾指针
    mov dl, [num]
    mov di, offset buf ;头指针                                          


    mov di,offset buf       ;di存放数组的位置
    mov cl,num              ;cx存放数组长度
    mov ch,0                
    call bubsort            ;调用排序算法
	; mov dx, bx ;dx内存空间大小
	; add dx, bx
	; ;mov bx, 2;bx位置
    ; call heapsort


    call crlf


    xor cx, cx
    mov cl, [num]
    mov di, offset buf
show:
    mov bx, [di]  
    call num2str;一个数整型转换为字符型                                        
    call print;打印一个数据
    call blank;输出空格
    add di, 2;对下一个数据进行操作
    loop show 
                            
    MOV AH,4CH
    INT 21H


bubsort proc near
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
bubsort endp





heapsort proc near;数组长度dx
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	push bx
	
	mov ax, dx
	mov bl, 4
	push dx
	div bl
	pop dx
	mov ah, 0
	mov cx, ax
	
	pop bx
loop1:;循环 n / 2次 i = cx - 1
	mov bx, cx
	add bx, cx
	dec bx
	dec bx
	call heapadjust
	loop loop1

	mov ax, dx
	mov bl, 2
	push dx
	div bl
	pop dx
	mov ah, 0
	mov cx, ax
	dec cx  ;循环n - 1次
loop2:
	
	push dx
	mov dx, cx
	add dx, cx ;dx = i
	
	push si
	push di
	mov si, offset buf
	mov di, offset buf
	add di, dx
	push ax
	mov ax, [si]
	xchg ax, [di]
	mov [si], ax
	pop ax
	pop di
	pop si;交换
	
	mov bx, 0
	call heapadjust
	pop dx

	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
heapsort endp

heapadjust proc near;参数为dx代表数组长度,bx代表当前节点位置输入的应该是两倍
    push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	;bx为 index
	;dx为数组长度
	push bx;保存当前结点 ;push1当前节点位置
left_cmp:
	mov ax, bx
	add ax, bx
	inc ax
	inc ax;两倍加2
	
	cmp ax, dx;ax记录2*index+1比较是否越界
	jnb exit_adjust;越界则结束
	
	mov di, offset buf
	add di, bx;di指向index的值
	mov si, offset buf
	add si, ax;si指向2*index+1的值
	
	push dx;保存最大长度  ;push2 最大长度
	mov dx, [si]
	cmp dx, [di]
	jna notleft;不高于则最大结点为当前节点
storleft:
	pop dx;保存最大长度   ;pop1最大长度
	push ax;保存大值结点  ;push3 最大结点位置
	jmp right_cmp
notleft:
	pop dx;保存最大长度   ;pop1最大长度
	push bx               ;push3 最大结点位置
	
right_cmp:
	mov ax, bx
	add ax, bx
	inc ax
	inc ax
	inc ax
	inc ax;两倍加四
	
	cmp ax, dx;ax记录2*index+4比较是否越界
	jnb cmp_index;越界则结束
	
	pop bx;最大值结点     ;pop2最大结点位置
	mov di, offset buf
	add di, bx;di指向maxindex的值
	mov si, offset buf
	add si, ax;si指向2*index+2的值
	
	push dx;保存最大长度  ;push4最大长度
	mov dx, [si]
	cmp dx, [di]
	jna notright;不高于则跳转比较最大值结点是否为当前结点
storright:
	pop dx;保存最大长度   ;pop3最大长度
	push ax               ;push5最大结点位置
	jmp cmp_index
notright:  
	pop dx;保存最大长度   ;pop3最大长度
	push bx	              ;push5最大结点位置
cmp_index:
	pop ax;存最大值所在结点 ;pop4最大结点位置
	pop bx;存当前结点       ;pop5当前节点位置
	cmp ax, bx
	jz exit_adjust
swap:
	mov di, offset buf
	mov si, offset buf
	add di, ax;指向最大值
	add si, bx;指向当前值
	push ax
	mov ax, [di]
	xchg ax, [si]
	mov [di], ax
	pop ax;最大值所在节点
	
	;push bx
	;push dx
	;mov bx, ax
	;call heapadjust
	;pop dx
	;pop bx
	
exit_adjust:
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
heapadjust endp

input proc near;输入数据将数据保存至buf中，数据个数保存至num中
    mov di, offset buf
    mov cl, 0;CL记录一共输入了多少个数
first:
    mov ax, tmp
    mov bx, 10;从高位到低位输入
    mul bx;每输入一个低位，高位数要乘10
    mov bx, ax;把高位寄存到BL    
    mov ah, 1;输入一个字符
    int 21H
    cmp al, ' ';判断输入是否为空格，若是则保存这个数
    jz  save_num
    cmp al, 0DH;判断输入是否为回车，若是，跳到EXIT
    jz EXIT0
    cmp al, '0';输入字符要在0-9内
    jb  INPUT_ERROR
    CMP AL, '9'
    ja  INPUT_ERROR
    sub al, 30H
    XOR AH, AH
    add bx, ax;高位和低位相加
    mov tmp, bx;把结果存储到TMP
    jmp first;下一个字符
save_num:
	mov bx, tmp;把输入的数存储到BUF中
    mov [di], bx
    add di, 2;DI指针指向下一个位置
    inc cl;个数加一
    mov tmp, 0;TMP清零
    jmp first
exit0:
    mov bx, tmp;把输入的数存储到buf中
    mov [di], bx
    inc di;di指针指向下一个位置
    inc cl                                          
    mov [NUM], cl;把个数储存到NUM
    mov tmp, 0                                      
    ret
INPUT_ERROR:
    CALL ERROR
    RET
INPUT endp

num2str proc near;将buf整型数字转换为字符型并保存再sae中
    push cx
    mov si, offset sae
    mov cx, 10000
    call DISP 
    
    mov cx, 1000
    add si, 2
    CALL DISP 
     
    mov cx, 100
    add si, 2
    CALL DISP 
    
    mov cx, 10
    add si, 2                                       
    CALL DISP 
    
    mov cx, 1
    add si, 2                                        
    CALL DISP
    pop cx
    ret
num2str endp
  
disp proc near;一位转换为字符型
    push ax
    push cx 
    push dx
    mov ax, bx;把BX存储的十六进制送到AX做除法
    XOR dx, dx
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
    XOR cx, cx
    mov cl, 6 
    mov si, OFFSET sae
    dec si
    dec si
first1:
    dec cl
    add si, 2
    cmp [si], byte ptr 0
    jz  first1
write:                                
    mov dl, [si]
    add dl, 30H
    mov ah, 2
    int 21H
    add si, 2
    loop WRITE
    pop cx
    ret
print endp 

error proc near;处理输入错误
    call crlf
    mov dx, offset str1
    mov ah, 9
    int 21H
    call CRLF
    call CRLF
    call CRLF
    jmp START
    ret   
error endp
  
crlf proc near;回车换行
    mov dl, 0DH
    mov ah, 2
    int 21H
    mov dl, 0AH
    mov AH, 2
    int 21H
    ret
crlf endp
  
blank proc near;空格符
    mov dl, ' '
    mov ah, 2
    int 21H
    ret
blank endp
;void HeapAdjust(vector<int> &nums,int len,int index) {
;        int left = 2 * index + 1;
;        int right = 2 * index + 2;
;        int maxIdx = index;
;       if (left < len && nums[left] > nums[maxIdx]) {
;            maxIdx = left;
;        }
;        if (right < len && nums[right] > nums[maxIdx]) {
;            maxIdx = right;
;        }
;        if (maxIdx != index) {
;            swap(nums[maxIdx], nums[index]);
;            HeapAdjust(nums,len,maxIdx);
;        }
;    }

;void HeapSort(vector<int>&nums,int size) {
;for (int i = size/2 - 1;i >= 0;i--) {
;    HeapAdjust(nums,size,i);
;}//大顶堆
;for (int i = size -1;i >= 1;i--) {
;     swap(nums[0],nums[i]);
;     HeapAdjust(nums,i,0);
;}

CODES ENDS
    END START



