assume cs:code

code segment
main:
	;编写一个累计减法，被减数是10011000B，减数是01000000B，连续减5次，观察FLAGS的变化
	
    mov ax,10011000B        ;被减数
    mov dx,01000000B        ;减数
    mov cx,5                ;循环5次
s:
    sub ax,dx               ;相减
    loop s                  ;循环相减
    
    ;第一次不变
    ;第二次不变
    ;第三次相减时SF符号位由PL变为NG，表示结果由正数变为负数;CF标志位由NC变为CY，表示借位
    ;第四次时CF标志位由CY变为NC,表示此时不需要借位;奇偶标志位由PE变为PO，即运算后结果中含有奇数个1
    ;第五次不变
    
	mov ax,4c00h    ;正常结束
	int 21h
code ends
end main
