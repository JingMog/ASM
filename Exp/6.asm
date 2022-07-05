assume cs:code,ds:data

data segment
	
data ends

code segment
start:
    
    ;编写一个移位运算，将8F1DH存至AX，然后用指令右移1位然后左移1位，显示结果并观察Flags的变化。将8F1DH存至AX中，然后带CF位左移5位，并右移7位，观察Flags的变化，并给出结果
	mov ax,8F1DH      ;1000 1111 0001 1101
    SHR ax,1          ;逻辑右移一位
    ;逻辑右移之后ax变为478E
    ;移位后最后一位移入CF中,因此CF变为CY
    ;移动一位后，CF与最高位相反，溢出，因为OF变为OV
    ;移位时向低字节移入1，因此AF变为AC
    SHL ax,1          ;逻辑左移一位
    ;逻辑左移一位后由于最低位移丢，AX变为8F1CH
    ;最高位的0移入CF中,因此CF变为NC
    ;移位时向低字节移入1，因此AF变为AC
    ;CF为0，最高位为1，因此OF变为OV

    mov ax,8F1DH
    mov cl,5h
    RCL ax,cl            ;带进位的循环左移5次
    ;循环移位前0 1000 1111 0001 1101
    ;循环移位后1 1110 0011 1010 1000
    ;带CF进位循环左移5次之后AX为E3A8H
    ;最高有效位和CF均为1，未溢出
    ;CF为1，产生进位

    mov cl,7h
    RCR ax,cl            ;带进位的循环右移7次
    ;循环移位前1 1110 0011 1010 1000
    ;循环移位后0 1010 0011 1100 0111
    ;带CF进位循环右移7次之后AX为A3C7H
    ;最高有效位为1，CF为0，溢出
    ;CF为0，未产生进位

	mov ax,4c00h
	int 21h
code ends
end start



