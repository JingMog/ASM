datas segment
	;此处输入数据段代码
    tip1 db "input the first number(please input a positive number):",13,10,"$"
    tip2 db "input the second number(please input a positive number):",13,10,"$"
    ans db "the added answer is:",13,10,"$"
	;ans2 db "the subed answer is(subtract the small data with the big data):$"
    num1_len dw 0
    num1 db 100 dup(0)
    num2_len dw 0
    num2 db 100 dup(0)
datas ends

stacks segment
    ;此处输入堆栈段代码
stacks ends

codes segment
	assume cs:codes,ds:datas,ss:stacks
start:
;----------------------
      mov ax,datas
	  mov ds,ax
	  ;此处输入代码段代码
	  lea dx, tip1 ;lea取源操作数地址的偏移量，并把它传送到目的操作数所在的单元。
	  mov ah, 09
	  int 21h ;显示第一句提示语

	  lea bx, num1 ;输入第一个数，bx指向num1
	  call input ;调用input函数进行输入

	  lea dx, tip2
	  mov ah, 09
	  int 21h ;显示第二句提示语

	  lea bx, num2 ;输入第二个数
	  call input

	  call numadd ;调用相加的函数，将两个数加起来

	  lea dx, ans
	  mov ah, 09
	  int 21h ;显示结果提示语

	  lea bx, num1 ;bx再次指向num1，num1中现在存放着结果

	  call output ;调用output输出结果
	  
exit:
      mov ah,4ch
	  int 21h
	  ret
	  

input proc near ;bx:数组首地址,第一个元素方长度
      push ds ;ds中存放的是段地址，先放入栈中保存
	  push ax ;ax中的值也暂时放入栈中保存
	  push dx ;dx的值也先放到栈中保存
	  mov si, 0; si记录输入的位数
	  inc si ;输入的位数至少为1位
	  
next:
      cmp si, 100
	  je over	

	  mov ah, 01
	  int 21h

	  ;输入的字符存放在al中，一个字符一个字符的输入
	  cmp al, " "
	  je over
	  cmp al, 0dh	
	  je over ;输入的值当超过100或者出现空格或者回车则输入结束

	  cmp al, "0"
	  jb next	
	  cmp al, "9"
	  ja next	 ;当输入的值小于0或大于9则跳过

	  sub al, 30h ;转换为十进制
	  mov [bx + si], al;将数据输入数组中，bx指向的是num1，bx+si逐个往后推进
	  inc si ;(si)=(si)+1，数据的大小（长度）+1
	  jmp next ;循环到next继续输入
	  
over:
      dec si ;把刚刚空格那一位减掉
	  mov word ptr [bx - 1], si ;保存输入数据的大小，把数据的大小保存在bx-1，也就是numlen里面
	  pop dx
	  pop ax
	  pop ds
	  ret
input endp
;-------------------------
output proc near
      push ds
	  push ax
	  push dx
	  mov cx, [bx - 1] ;num1len也就是bx-1中存放着数据的长度，cx中现在存放着数据的长度
	  mov si, 0
	  inc si ;si=1
	  
show:
      mov ah, 02 
	  mov dl, byte ptr [bx + si] ;从结果的第一个高位开始输出
	  add dl, 30h ;转换为ascii码
	  int 21h ; 输出

	  inc si ;si往后移动一位

	  loop show ;循环输出直到全部都输出了，cx=0

	  pop dx
	  pop ax
	  pop ds
	  ret
output endp










numadd proc near
      push ds
	  push ax
	  push dx
	  mov si, word ptr [num1 - 1] ;si存放第一个数据的长度
	  mov cx, si 		;把si移动到cx，现在cx存放第一个数据的长度
	  mov di, word ptr [num2 - 1] ;di存放第二个数据的长度
	  mov dl, 0 ;dl清零
	  cmp cx, di ;比较判断第一个数据和第二个数据哪个数据更长
	  jae continue ;如果cx不低于（大于等于）di的时候，跳转到continue
	  mov cx, word ptr [num2 - 1] ;若cx中的数据小于di中的数据，则把cx赋值为第二个数据的长度，让cx中保存的是这两个数中较大的一个数的值
      ;add cx,8
	  ;cx中保存最大的数据长度
	  mov word ptr [num1 - 1], cx ;修改结果的长度，现在num1len里面存储的是结果的长度

continue:
      mov al, dl ;dl中保存的是刚刚前两位的进位
	  mov dl, 0  ;dl再赋值为0
	
	  cmp si, 0  ;si中存放的是一开始的输入时num1的长度，si等于0，现在已经没有数要相加了
	  je finish_1	;等于0则已完成加法

	  add al, [num1 + si] ;从最后一个低位开始加，现在al=刚刚前面给的进位+num1的一位
	  dec si ;这一位加完后，往前推一位，加下一位
	  jmp finish_2;未完成加法则判断小的数是否完成
	  
finish_1:
      add al, 0
	  
finish_2:
      cmp di, 0 ;第二个数也没有位数要相加了
	  je finish_3 ;较小的那个数完成加法	

	  add al, byte ptr [num2 + di] ;加上第二个数的一位，也是从低位开始加，现在al=刚刚前面给的进位+num1的一位+num2的一位

	  dec di ;di=di-1，第二个数往前推一位
	  aaa
	  ;aaa指令用于调整ascii码，aaa指令做两件事情：
	  ;如果al的低4位是在0到9之间，保留低4位，清除高4位，如果al的低4位在10到15之间，则通过加6，来使得低4位在0到9之间，然后再对高4位清零。
	  ;如果al的低4位是在0到9之间，ah值不变，cf和af标志清零，否则，ah=ah+1，并设置cf和af标志。
	  adc dl, 0 ;将进位标志值1加入到dx
	  jmp finish_4

finish_3:
      add al, 0
	  aaa
	  adc dl, 0  

finish_4:
      mov bx, cx ;cx中存放着结果的长度，现在bx中存放着结果的长度
	  mov [num1 + bx], al ;al中存放着两位相加的结果，把他移动到结果的bx位中，现在时结果的低位

	  loop continue ;重复相加的操作，cx=cx-1

	  pop dx
	  pop ax
	  pop ds
	  ret
numadd endp



codes ends
	end start
