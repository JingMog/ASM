;将代码段寄存器和代码段关联起来
;将数据段寄存器和数据段关联起来
;这里的关联并没有任何实际操作，相当于给我们自己的注释
;相当于即使不写这一行也没有关系

assume cs:code, ds:data


; 数据段开始
data segment
	;创建字符串
	;汇编打印字符串要在尾部用 $ 标记字符串的结束位置
	;将字符串用hello做一个标记，方便之后使用
	hello db 'Hello world!$'
	dname db 'My name is JsingMog.$'

;数据段结束
data ends


;代码段开始
code segment
;指令执行的起始，相当于Main()函数入口
start:
	;汇编语言不会自动把数据段寄存器指向程序的数据段
	;将数据段寄存器指向数据段
	mov ax, data
	mov ds,ax
	
	;打印字符串的参数
	;DS:DX=串地址，将字符串的偏移地址传入dx寄存器
	;字符串是在数据段起始创建的，它的偏移地址是0H
	;offset hello即找到标记为hello的数据段字符串的编译地址
	;还可以携程mov dx,0H
	
	mov dx, offset hello
	;打印字符串，ah=9H代表打印
	mov aH,9H
	int 21H
	
	mov dx, offset dname
	;打印字符串，ah=9H代表打印
	mov aH,9H
	int 21H
	
	;正常退出程序
	mov ah, 4CH
	int 21H


code ends


end start
