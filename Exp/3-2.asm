assume cs:code,ds:data

data segment

    xl dw 0F0FH         ;被乘数低位 
    xh dw 0000H         ;被乘数高位
    yl dw 0FF00H        ;乘数低位     
    yh dw 0000H         ;乘数高位
    xy dw 8 dup(?)      ;存放结果

data ends


code segment
main:
    ;编写一个16位的乘法，被乘数是100H，乘数是100H，观察Flags的变化，编写一个32位的乘法，被乘数是0F0FH，乘数是FF00H，观察Flags的变化
    
    mov ax,data
    mov ds,ax               ;初始化段寄存器

    ;32位乘法可以分解为4个16位乘法来进行
    mov ax,xl
    mov dx,yl
    mul dx
    mov [xy],ax
    mov [xy+2],dx
    ;x低位和y低位相乘结果高位存放在xy+2中，低位存放在xy中

    mov ax,xh
    mov dx,yl
    mul dx
    add [xy+2],ax
    adc [xy+4],dx                       ;带进位加法
    adc [xy+6],0                        ;保存进位
    ;x高位和y低位相乘结果低位累加到xy+2中，高位累加到xy+4中

    mov ax,xl
    mov dx,yh
    mul dx
    add [xy+2],ax
    adc [xy+4],dx
    adc [xy+6],0                        ;将进位保存到xy+6
    ;x低位和y高位相乘结果低位累加到xy+2中，高位带进位累加到xy+4中，产生的进位保存到xy+6中

    mov ax,xh
    mov dx,yh
    mul dx
    add [xy+4],ax
    adc [xy+6],dx                       ;带进位加法
    ;x高位和y高位相乘结果低位累加到xy+4中，高位带进位累加到xy+6中
    
    ;最后的结果存放在data段的xy+6,xy+4,xy+2,xy中
    ;分别为00 00 00 00 0E FF F1 00
    ;即结果为0EFFF100H

	mov ax,4c00h    ;正常结束
	int 21h
code ends
end main
