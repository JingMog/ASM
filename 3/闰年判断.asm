assume cs:code,ds:data

data segment
    ;辅助数字输入
    buf db 8
    db 9 dup(?)
    num dw ?                     ;存放输入     
    yes db 10,13,'Yes','$'       ;待输出的yes和no
    no db 10,13,'No','$'
data ends

code segment
main:
    ;输入数据
start:
    mov  ax,data
    mov  ds,ax 

    ;输入数字字符串，数字小于65536
    ;中断输入
    mov  dx,offset buf          ;输入数字
    mov  ah,0ah
    int  21h

    call transform              ;ASCII码转换成数字
    jmp start_estimate          ;判断是否位闰年


;年份的输入,并转化为数字
transform proc near
    sub ch, ch                  ;ch清零
    mov cl, buf[1]              ;保存输入数据
    xor dx, dx                  ;dx清零
    mov si, 0                   ;si清零
lop:
    push cx                     
    mov  ax, dx                 
    mov  cl, 3
    ;使用乘法麻烦，左移3位+左移1位
    shl  dx, cl 
    shl  ax, 1
    add  dx, ax 
    xor  ah, ah 
    mov  al, buf[2+si]
    inc  si 
    sub  al, '0'
    add  dx, ax             ;dx=dx*10+ax 
    pop  cx 
    loop lop 
    mov  num, dx 
    ret
transform endp

;以上步骤用于将键盘输入的数据转化为数字，并存放在num中。下面进行闰年和非闰年的判断

;闰年的判断方法：year%4==0 && year%100!=0 ||year%400==0
;整除4，并且不能整除100
;整除400

start_estimate:
    mov dx,0                ;dx中存放着被除数的高位，先将dx置0
    mov ax,num              ;将刚刚输入的数据赋值给ax
    mov bx,04               ;bx赋值为4
    div bx                  ;进行除法，将余数保存在dx中
    cmp dx,0                ;判断余数是否为0
    je step_2               ;余数为0，跳转到step_2
    jne step_3              ;余数不为0，跳转到step_3
    
step_2:
    mov dx,0                ;dx中存放着被除数的高位，先将dx置0
    mov ax,num              ;需要重新给ax赋值num，因为刚刚ax中存了商
    mov bx,100H             ;bx赋值为100H
    div bx                  ;进行除法，将余数保存在dx中
    cmp dx,0                ;判断余数是否为0
    je cout_no              ;余数为0，输出no
    jne cout_yes            ;余数不为0，输出yes

step_3:
    mov dx,0                ;dx中存放着被除数的高位，先将dx置0
    mov ax,num              ;需要重新给ax赋值num，因为刚刚ax中存了商
    mov bx,400H             ;bx赋值为400
    div bx                  ;进行除法，将余数保存在dx中
    cmp dx,0                ;判断余数是否为0
    je cout_yes             ;余数不为0，输出yes
    jne cout_no             ;余数为0，输出no

;是闰年，输出yes
cout_yes:    
    mov ah,09h              ;ah=9
    mov dx,offset yes       ;把字符内容赋给dx
    int 21h ;调用21h号中断

    jmp next ;跳转到结束指令

;不是闰年输出no
cout_no:
    
    mov ah,09h ;ah=9
    mov dx,offset no ;把字符内容赋给dx
    int 21h ;调用21h号中断

next:
    mov ax,4c00H
    int 21H


code ends
end main