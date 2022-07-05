assume cs:code,ds:data

data segment

data ends


code segment
main:
    ;编写一个16位的乘法，被乘数是100H，乘数是100H，观察Flags的变化，编写一个32位的乘法，被乘数是0F0FH，乘数是FF00H，观察Flags的变化
    mov ax,data
    mov ds,ax               ;初始化段寄存器
    
    ;16位乘法一个乘数存放的ax中，另一个在指令中给出,结果存放在dx(高位)和ax(低位)中
    mov ax,100H
    mov dx,100H
    mul dx
    ;结果为0001 0000H

	mov ax,4c00h    ;正常结束
	int 21h
code ends
end main
