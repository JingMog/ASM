assume cs:code,ds:data

data segment
    buf db 16 dup(0), 13, 10, '$'                ;暂存字符串
    wel db 'welcome to the bubblesort program!', 13, 10, '$'
    str1 db 'before sort:', 13, 10, '$'
    str2 db 'after sort:', 13, 10, '$'
	arr db 53, 79, -2, 4, 0                   ;待排序数据
    ;有符号数,符号位占最高位,范围为-128~127
    cnt db $-arr                                 ;buf个数
data ends

code segment
start:
    mov al,cnt
    mov ax,data
    mov ds,ax
    mov si,offset arr           ;buf位置
    mov cl,cnt                  ;循环次数
    dec cl                      ;遍历n-1次
    mov ch,0                    ;高位置零

    mov dx,offset wel           ;欢迎语句
    mov ah, 09h
    int 21h

    mov dx,offset str1          ;排序前语句
    mov ah,09h
    int 21h

    ;显示排序前数字
    mov si, offset arr          ;arr位置
    mov di, offset buf          ;buf位置
    mov cl, cnt                 ;个数
    mov ch, 0
    call printarr               ;显示所有的数字

    ;排序
    mov si, offset arr          ;arr位置
    mov cl, cnt                 ;个数
    mov ch, 0       
    call bubblesort             ;调用冒泡排序子程序


    ;显示字符串"after sort"
    mov dx, offset str2         ;输出"after sort:"字符串
    mov ah, 09h
    int 21h

    ;显示排序后数字
    mov si, offset arr          ;arr位置
    mov di, offset buf          ;buf位置
    mov cl, cnt                 ;个数
    mov ch, 0
    call printarr               ;显示所有的数字


    mov ah, 4ch
    int 21h


;冒泡排序子程序
bubblesort proc near
    push ax                     ;保存寄存器值
    push bx
    push cx
    push dx
    push si
    push di

    dec cx
;si为外循环变量,di为内存换变量
;循环交换[si]与[di]的值
outer:                          ;外循环
    mov al,[si]                 ;al为比较的值,内循环依次与al比较,小于或等于就交换其值
    push cx                     ;cx入栈，保存寄存器状态
    mov di,si                   ;内存换变量di

inner:                          ;内循环
    inc di                      ;di=si+1
    mov dl,[di]                 ;依次遍历数组元素
    cmp al,dl                   ;if (buf[si] > buf[di])
    jle cont                    ;小于或等于时跳转到cont
    xchg ax,dx                  ;交换ax,dx,实现冒泡
    mov [si],al                 ;保存交换的值到内存中
    mov [di],dl

cont:   
    loop inner                  ;内循环
    pop cx                      ;恢复cx的值
    inc si                      ;si后移
    loop outer                  ;外循环

    pop di                      ;恢复寄存器值
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
bubblesort endp



;子程序,将整数转换为字符串
printarr proc near
    push si                     ;保存寄存器值
    push di

    mov dx,di
iterat: 
    mov al,[si]                 ;al=ds[si]
    mov ah, 0
    inc si
    call ntoc                   ;将ax转化为字符串
    mov ah, 09h
    int 21h                     ;输出ax
    call clrbuf                 ;清空缓冲区
    loop iterat                 ;循环输出

    pop di
    pop si
    ret
printarr endp


;数字转化为字符串
;ax->ds[di]中
ntoc proc near
    push bx                 ;保存寄存器值
    push cx
    push dx
    push di

    mov bx, 10              ;
    mov cx, 0
    cmp ax, 127             ;如果ax>127,ax = -ax
    jle modlp               ;小于或等于跳转
    neg al                  ;负数用补码表示,求补
    mov byte ptr [di], '-'  ;负数的话前面加上-号
    inc di                  
modlp:
    xor dx, dx
    div bx                  ;ax=ax/bx;dx=ax%bx.高位余数低位商
    add dx, 30h             ;+30h转化为ascii码
    push dx
    inc cx
    cmp ax, 0
    jg modlp                ;
    mov ax, cx              ;返回的ax:数字的长度
stolp:  
    pop dx
    mov [di], dl            ;保存数字到缓冲区
    inc di
    loop stolp

    pop di                  ;恢复寄存器值
    pop dx
    pop cx
    pop bx
    ret
ntoc    endp



;清空缓冲区
clrbuf  proc near
    push cx
    push di

    mov cx, 16                  ;缓冲区长度
bufcls: 
    mov byte ptr [di], 0        ;0移动到[di]中
    inc di
    loop bufcls

    pop di
    pop cx
    ret
clrbuf  endp

    
	mov ax,4c00h
	int 21h


code ends
end start



