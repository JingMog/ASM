assume cs:code,ds:data,ss:stack

data segment
	a dw 0201H,0102H,0605H,0406H,0704H,0403H    ;12
    b dw 0701H,0409H,0802H,0303H,0508H,0504H    ;24
    res dw 12 dup (0)      ;存放结果
data ends

stack segment
    dw 16 dup(0)
stack ends

code segment
start:
    ;实现压缩BCD码的加减法，用压缩BCD码实现（21+71），（12+49），（65+82），（46-33），（74-58），,（43-54）的十进制加减法。然后又用非压缩BCD实现上述6个式子

    mov ax,data
    mov ds,ax           ;初始化数据段段寄存器
    mov ax,stack
    mov ss,ax
    mov sp,16           ;初始化栈

    mov bx,0            ;循环变量，用于保存结果
    mov di,0            ;变址寻址
    mov cx,3            ;循环3次
ad:
    ;非压缩BCD码加法
    sahf                ;清空标志寄存器
    mov ax,0[di]        ;送加数
    mov dx,12[di]        ;送被加数
    add ah,dh
    add al,dl
    aaa                 ;非压缩BCD码调整
    ;如果AL的低4位大于9或AF=1,则AL=AL+6,AH=AH+1,AF=CF=1,且AL高四位清零
    ;否则CF=AF=0,AL高4位清零
    cmp ah,09H          ;比较AH是否超过9
    jna save1           ;不高于则跳转至下方
    sub ah,0AH          ;减0AH,修正高位
    mov 24[bx],0001H    ;保存结果的进位

save1:
    inc bx
    mov 24[bx],ah       ;保存结果高位
    inc bx
    mov 24[bx],al       ;保存结果低位
    inc bx
    add di,2
    loop ad             ;循环


    mov cx,3            ;循环3次
;非压缩BCD码减法
su:
    sahf                ;清空标志寄存器
    mov ax,0[di]        ;送加数
    mov dx,12[di]       ;送被加数
    sub ah,dh
    sub al,dl
    aas                 ;非压缩BCD码调整
    ;如果AL的低4位大于9或AF=1,则AL=AL-6,AH=AH-1,AF=CF=1,且AL高四位清零
    ;否则CF=AF=0,AL高4位清零

    cmp ah,09H          ;比较AH是否超过9
    jna save2           ;不高于则跳转至下方
    ;如果ah大于09H说明结果为负数，需要反过来
    mov ax,12[di]
    mov dx,0[di]
    sub ah,dh
    sub al,dl
    aas
    mov 24[bx],0001H    ;保存结果的借位,表示负数

save2:
    inc bx
    mov 24[bx],ah       ;保存结果高位
    inc bx
    mov 24[bx],al       ;保存结果低位
    inc bx
    add di,2
    loop su             ;循环


	mov ax,4c00h
	int 21h
code ends
end start

