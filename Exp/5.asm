assume cs:code,ds:data

data segment
	
data ends

code segment
start:

	;编写一个累计加法，被加数是0FH，加数是01H，观察Flags的变化
    ;被加数是0FFH，加数是01H，观察Flags的变化
    ;被加数是0FFFH，加数是01H，观察Flags的变化
    ;被加数是0FFFFH，加数是01H，观察Flags的变化
    ;被加数是FFFFFFFFH加数是01H，观察Flags的变化
	mov ax,0FH
    add ax,01H
    ;AX为0010H
    ;AF由NA变成AC,说明产生辅助进位
    mov ax,0FFH
    add ax,01H
    ;AX为0100H
    ;奇偶标志由PO变为PE，说明结果中1的个数为偶数,辅助进位标志仍然为AC
    mov ax,0FFFH
    add ax,01H
    ;AX为1000H
    ;标志寄存器同上
    mov ax,0FFFFH
    add ax,01H
    ;AX为0000H
    ;标志寄存器CF变为CY,说明产生进位,ZF变为ZR,结果应为10000H
    ;32位加法需要使用带进位加法
    mov ax,0FFFFH   ;ax为高位
    mov dx,0FFFFH   ;dx为低位
    add dx,01H      ;低位与加数相加
    adc ax,0        ;保存进位
    ;结果DX为0000H,AX为0000H
    ;进位标志CF为CY,说明产生进位,结果应为100000000H

	mov ax,4c00h
	int 21h
code ends
end start

