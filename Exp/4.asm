assume cs:code,ds:data

data segment
	
data ends

code segment
start:
	;编写一个16位的除法，被除数是100H，除数是100H，观察Flags的变化，编写一个32位的除法，被除数是0F0FH，除数是00FFH，观察Flags的变化
	
    ;16位除法,被除数存放在AX中
	mov ax,100H			;被除数存放在AX中
	mov bx,100H			;除数存放在BX中
	div bx
	;结果AH为00，AL为01
	;即商为1，余数为0
	;标志寄存器无变化，未发生溢出，结果为正，非零

	
	;32位除法,被除数高位存放在DX中,低位存放在AX中
	mov dx,0000H
	mov ax,0F0FH
	mov bx,00FFH
	div bx
	;结果AX为000FH,DX为001EH
	;即商为FH,余数为1EH
	;标志寄存器无变化，未发生溢出，结果为正，非零


	mov ax,4c00h
	int 21h
code ends
end start

