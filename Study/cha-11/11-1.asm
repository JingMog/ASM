assume cs:code,ds:data

data segment

data ends

code segment
main:
    ;计算1000FFFFH+20000001H
    ;结果应该位30010000H
    mov dx,1000H        ;dx为高位
    mov ax,0FFFFH       ;ax为低位
    add ax,0001H        ;先加低位
    adc ax,2000H        ;再利用带进位加法adc来计算高位

    ;计算10010000H+0000FFFFH
    ;结果应该位10000001H
    mov dx,1001H
    mov ax,0000H
    sub ax,0FFFFH
    sbb dx,0000H        ;带借位标志减法sbb

    mov ax,4c00h
    int 21h
code ends

end main




