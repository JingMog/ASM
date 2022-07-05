assume cs:code,ds:data

data segment para 'data'
	arr db 47,49,48,50,46,88,81,43,42,41
	db 40,39,38,37,36,35,74,33,32,61
	db 30,59,74,27,26,25,94,23,22,21
	db 20,19,68,17,16,15,14,13,12,94
	db 10, 89, 58, 57, 6,65,54, 73, 11, 22        ;待排序数组
    wel db 'welcome to the heap sort program!', 13, 10, '$'
	str1 db 'before sort:',13,10,'$'                ;提示信息
    str2 db 'after sort:',13,10,'$'                 ;结果提示信息
    buf db 5 dup(10 dup(?,?,20h,20h),0dh,0ah),'$'      
    ;暂存输入数组,转化为ascii码的形式
data ends


code segment
;main函数
main proc far
start:
	push ds
	sub ax,ax
	push ax

	mov ax,data
	mov ds,ax                   ;初始化ds数据段寄存器

	call numtoascii             ;将数组转化为ascii码的形式,存放在buf中

    mov dx,offset wel          		 	;欢迎语句
    mov ah, 09h
    int 21h

    mov dx,offset str1          ;输出"before sort:"字符串
    mov ah, 09h
    int 21h

	mov dx,offset buf           ;输出排序前数组
    mov ah,09h
	int 21h


    call bulidheap              ;建堆
    call adjustheap             ;调整堆

    call numtoascii             ;将数组转化为ascii码的形式,存放在buf中

    mov dx,offset str2          ;输出"after sort:"字符串
    mov ah,09h
	int 21h

    mov dx,offset buf           ;输出排序后数组
    mov ah,09h
	int 21h
	ret
main endp



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


;void adjustheap(int[] arr, int i, int length) {
;     int temp=arr[i];
;     // 从i节点的左子节点开始，也就是2*i+1 然后继续往下调整 就是保证以他为首的树是大根堆
;     for(int k=i*2+1;k<length;k=k*2+1)
;     {
;         // 如果左子节点小于右子节点，k指向右子节点
;         if(k+1<length&&arr[k]<arr[k+1]){
;             k++;
;         }

;         // 如果子节点大于父节点，将子节点值赋给父节点（不用进行交换）
;         //找到第一个需要交换的点
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


;将数据每一位依次转化为ascii码,存放在buf中
;将输入数据显示在屏幕上
;数据之间存放一个空格,方便显示
numtoascii proc near
    mov bx,0                        ;基址寻址,访问数组
    mov cx,50                       ;50个数据,循环50次

beginshift:
    mov al,arr[bx]                  ;获取数组中的数据
    mov ah,0
    mov dl,10                       ;dl=10
    div dl                          ;除以10来获取十位和个位
    add al,30h                      ;al为商,加30
    add ah,30h                      ;ah为余数,加30转化为ascii码
    push bx                         ;保存bx寄存器,下面要用bx

    add bx,bx                       ;
    add bx,bx


;下方相当于一个switch语句,依次判断bx落在哪一段区间内
;0-40,40-80,80-120,120-160,160-200
    cmp bx,40                       ;i<40
    jge l1                          ;i>=40时跳出循环,即超出数组范围

    mov buf[bx],al                  ;将对应的ascii码存放在input_buf中
    mov buf[bx][1],ah               ;上面存放十位,这里存放个位
    jmp next
l1:
    cmp bx,80                 ;40<=i<80
    jge l2                    ;i>=80时跳出循环,即超出数组范围
    mov buf[bx][2],al         ;将对应的ascii码存放在input_buf中
    mov buf[bx][3],ah         ;上面存放十位,这里存放个位
    jmp next
l2:
    cmp bx,120                      
    jge l3                          ;80<=i<120
    mov buf[bx][4],al         ;将对应的ascii码存放在input_buf中
    mov buf[bx][5],ah
    jmp next
l3:
    cmp bx,160                      ;120<=i<160
    jge l4                      
    mov buf[bx][6],al         ;将对应的ascii码存放在input_buf中
    mov buf[bx][7],ah
    jmp next
l4:
    mov buf[bx][8],al         ;160<=i<200
    mov buf[bx][9],ah         ;将对应的ascii码存放在input_buf中
next:
    pop bx                          ;恢复bx寄存器
    add bx,1                        ;i++
    loop beginshift
    ret
numtoascii endp


code ends
end start
