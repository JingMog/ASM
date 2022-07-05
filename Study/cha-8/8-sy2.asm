assume cs:codesg

data segment
	db 'welcome to masm!'	;操作字符串
data ends

codesg segment
start:
	mov ax,data 
	mov ds,ax			;段寄存器DS指向数据段
	mov ax,0B800h	
	mov es,ax			;段寄存器ES指向彩色模式区域
	mov bx,0			;控制字符的读取
	mov si,1952			;控制字符的写入，起始偏移地址为1946
	mov cx,16			;循环次数
s:
	mov al,ds:[bx]		;将当前处理字符放到寄存器AL中
	
	mov es:[si],al		;当前字符的第一个位置
	mov ah,02h			;第一种属性，绿色字体
	mov es:[si+1],ah	;当前字符的第一个属性
 	
	mov es:[si+32],al	;当前字符的第二个位置，相对于第一个字符串偏移32
	mov ah,24h			;第二种属性，绿底红色
	mov es:[si+32+1],ah	;当前字符的第二种属性
	
	mov es:[si+64],al	;当前字符的第三个位置，相对于第一个字符串偏移64
	mov ah,71h			;第三种属性，白底蓝色
	mov es:[si+64+1],ah	;当前字符的第三种属性
	
	add bx,1			;每次偏移1个字节处理1个字符
	add si,2			;每次偏移2个字节写入1个字符
	loop s 
	
	mov ax,4c00h
	int 21h
codesg ends 
end start


