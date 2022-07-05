assume cs:code,ds:data

data segment
    s db 'ababcabcacbab'
    t db 'abcac'            ;要求模式串不超过10个字符
    n db 10 dup(0)
data ends

stack segment
    db 16 dup(0)
stack ends

code segment
    ;实现KMP算法，输入两个字符串（可以直接保存在内存中），实现快速匹配
start:
    mov ax,data
    mov ds,ax           ;初始化数据段段寄存器
    mov ax,stack
    mov ss,ax
    mov sp,16           ;初始化栈
    jmp main


; next函数C语言实现
; while(j<strlen(p)-1)
;     {
;         if(j==0||T[i-1]==T[j-1])
;         {
;             i++;
;             j++;
;             next[i]=j;
;         }
;         else        
;             j=next[j];
;     }



;求next数组，存放在数据段的数据标号n处
; si相当于i
; di相当于j
; ax 当前next[]
next proc near
    mov si,1
    mov di,0
    mov cx,offset n - offset t      ;求next数组长度,即匹配串t的长度
    dec cx                          ;cx--
    mov ah,00h
l1: 
    cmp di,0                        ;j==0
    je i1                           ;就跳转到i1
    dec si                          ;i-1
    dec di                          ;j-1
    mov al,t[si]                    ;得到T[i-1]
    mov bl,t[di]                    ;得到T[j-1]
    inc si                          ;恢复si,di,以便后面继续访问
    inc di
    cmp al,bl                       ;如果T[i-1]!=T[j-1]
    jne e1                          ;就跳转到e1
i1: 
    inc si                          ;i++
    inc di                          ;j++
    mov ax,di                       ;next[i]=j
    mov n[si],al                    
    jmp l2
e1: 
    mov al,n[di]
    mov di,ax                       ;else j=next[j]
    ;i不动，j变为当前测试字符串的next值
    inc cx
l2: 
    loop l1
    ret
next endp
; while (i < S.length && j < T.length) {
;             if (j == 0 || S[i-1] == P[j-1]) {
;                 i++;
;                 j++;
;             } else {
;                 // 匹配失败时，跳转下标
;                 j = next[j];
;             }
;         }
;         // 匹配成功
;         if (j == P.length) {
;             return i - j;
;         }
;kmp算法主函数
main:
    call next                       ;先计算next数组
    mov si,1
    mov di,1
    mov ah,00h
    ;循环判断是否超出长度
l3: 
    mov cx,offset t - offset s      ;cx存放S长度
    cmp si,cx                       ;i<S.length
    ja o1                           ;不满足就跳转到o1
    mov cx,offset n - offset t      ;cx存放T长度
    cmp di,cx                       ;j<T.length
    ja o1                           ;不满足就跳转到o1

    cmp di,0                        ;比较j==0
    je i2                           ;j=0,跳转
    dec si                          ;i-1
    dec di                          ;j-1
    mov al,s[si]                    ;S[i-1]
    mov bl,t[di]                    ;T[i-1]
    inc si                          ;恢复i,j
    inc di
    cmp al,bl                       ;S[i-1]==T[j-1]
    jne e2                          ;不等于就跳转到e2
i2: 
    inc si                          ;i++      
    inc di                          ;j++
    jmp l4                          ;下一次循环
e2: 
    mov al,n[di]                    ;j变为当前测试字符串的next值
    mov di,ax                       ;j=next[j]
l4: 
    loop l3                         ;循环


;退出循环，输出结果
o1: 
    mov cx,offset n - offset t      ;模式串长度
    cmp di,cx                       ;j==T.length
    ja o2                           ;di>cx,匹配成功,跳转o2
    mov dl,23H                      ;未找到匹配字符串，显示#
    jmp o3
o2: 
    sub si,cx                       ;i-T.length，找到匹配字符串，显示匹配位置
    add si,30H                      ;加上30H使得si变为对应数值的ASCII码
    mov dx,si                       ;送至dx中输出
o3: 
    mov ah,2
    int 21H                         ;显示输出,DL为输出字符

    
    mov ax, 4C00H
    int 21H


code ends
end start

