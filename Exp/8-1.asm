assume cs:code,ds:data

data segment
	a db 21H,12H,65H,46H,74H,43H
    b db 71H,49H,82H,33H,58H,54H
    res db 12 dup (0)      ;存放结果
data ends

code segment

    ;实现压缩BCD码的加减法，用压缩BCD码实现（21+71），（12+49），（65+82），（46-33），（74-58），,（43-54）的十进制加减法。然后又用非压缩BCD实现上述6个式子
	
start:
    mov ax,data
    mov ds,ax           ;初始化数据段段寄存器

    mov bx,0            ;循环变量，用于保存结果
    mov di,0            ;变址寻址
    mov cx,3            ;循环3次
;压缩BCD码加法
ad:
    sahf                ;清空标志寄存器
    mov ah,0H           ;清空高位
    mov al,0[di]        ;送加数
    mov dl,6[di]        ;送加数
    add al,dl
    daa                 ;daa指令来进行十进制调整,
    ;如果AL寄存器中低4位大于9或者辅助进位AF=1,则AL=AL+6,且AF=1
    ;如果AL>=0A0H或CF=1,则AL=AL+60H,且CF=1
    adc ah,0            ;保存进位
    
    mov 12[bx],ah       ;存放结果高位
    inc bx
    mov 12[bx],al       ;存放结果低位
    inc bx
    inc di              ;变址寻址
    loop ad

    mov cx,3
;压缩BCD码减法
su:
    sahf                ;清空标志寄存器
    mov ah,0H           ;高位置零
    mov al,0[di]        ;送被减数
    mov dl,6[di]        ;送减数
    sub al,dl
    das                 ;BCD码调整
    ;如果AF=1或AL寄存器中低4位大于9,则AL=AL-6,且AF=1
    ;如果AL>=0A0H或CF=1,则AL=AL-60H,且CF=1
    
    ;可能会出现负数的情况
    jnc next                ;不借位则跳转至next
    ;如果借位，则说明结果为负数，此时变换为bl-al
    mov al,6[di]
    mov dl,0[di]
    sub al,dl
    das                     ;调整BCD码,大于9则AL=AL-6，高四位-60，都不成立则清除标志位
    mov ah,10h              ;最高位置为1，表示结果为负数
next:
    ;保存结果
    mov 12[bx],ah           ;保存结果高位
    inc bx
    mov 12[bx],al           ;保存结果低位
    inc bx                  ;bx自加
    inc di                  ;变址寻址变量自加
    loop su

	mov ax,4c00h
	int 21h
code ends
end start

