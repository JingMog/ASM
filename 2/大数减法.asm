datas segment
	;此处输入数据段代码
    tip1 db "input the first number(please input a positive number):",13,10,"$"
    tip2 db "input the second number(please input a positive number):",13,10,"$"
    ;ans1 db "the added answer is:$"
    ans2 db 10,13,"the subed answer is:$"
    ans3 db 10,13,"the subed answer is:-$"
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

      call numsub ;调用相加的函数，将两个数加起来

	  
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



numsub proc near
      push ds
      push ax
      push dx
      mov si, word ptr [num1 - 1] ;si存放第一个数据的长度
      mov cx, si ;把si移动到cx，现在cx存放第一个数据的长度
      mov di, word ptr [num2 - 1] ;di存放第二个数据的长度
      mov cx,1  
      cmp si,di
      ja continue1_first ;num1的位数大于num2的位数，直接调用continue1
      jl continue2_first ;num1的位数小于num2的位数，直接调用continue2
      mov di,0
      je compare ;位数相等，还要再比较
    

continue1_first: ;如果num1大于num2则调用它
      mov di, word ptr [num2 - 1]         ;
yi1:
      jcxz yi2                            ;cx=0就跳转
      mov    al,[num1+si]                 ;获取num1的高位
      cmp    al,[num2+di]                 ;获取num2的高位
      jl     yi4                          ;num1高位小于num2高位,跳转
yi5:          
      sub    al,[num2+di]                 ;num1大于num2高位
      mov    [num1+si],al                 ;存储相减的结果
      dec    si                           ;继续往低位移动
      dec    di
      cmp    si,0                         ;比较是否所有位全都移动完
      je     yi3                          ;是,跳转到yi3
      jne    yi1                          ;否,跳转到yi1,继续比较
yi2:          
      sub    [num1+si],1                  ;
      mov    cx,1
      jmp    yi1
yi4:          
      mov    cx,0                         ;
      add    al,0ah                       ;BCD码调整
      jmp    yi5
yi3:
      pop    cx                           ;恢复寄存器
      pop    ax
      pop    di
      pop    si
      jmp sub1_cout
      
sub1_cout:
      lea dx, ans2
      mov ah, 09
      int 21h           ;显示结果提示语

      lea bx, num1      ;bx再次指向num1，num1中现在存放着结果

      call output       ;调用output输出结果

      jmp exit



compare:
      ;现在num1中保存的时第一个数据，num2中保存的是第二个数据，对两个数据进行比较，现在两个数据的长度是相等的，则从高位比较，只要大于则马上跳出。第一个大于的二个，则跳到continue1，第二个大于第一个，则跳到continue2 (类似于74LS85)
      ;push di 
      ;mov di,0 
      mov bl,[num1 + di]            ;获取num1的高位
      mov dl,[num2 + di]            ;获取num2的高位
      inc di                        ;di自加，往后继续比较
      cmp bl,dl  
      je compare                    ;如果现在两位相等，就继续往后比较
      ja continue1_first ;num1的这一位高于num2的这一位，说明num1更大
      jl continue2_first ;num2的这一位高于num1的这一位，说明num2更大
    

continue2_first: ;如果num2大于num1则调用这个函数
      mov di, word ptr [num2 - 1]   ;di存放num2的高位
yi1_2:
      jcxz yi2_2 
      mov    al,[num2+di]
      cmp    al,[num1+si]
      jl     yi4_2
yi5_2:          
      sub    al,[num1+si]
      mov    [num2+di],al
      dec    di
      dec    si
      cmp    di,0
      je     yi3_2
      jne    yi1_2
yi2_2:          
      sub    [num2+di],1
      mov    cx,1
      jmp    yi1_2
yi4_2:          
      mov    cx,0
      add    al,0ah
      jmp    yi5_2
yi3_2:          
      pop    cx
      pop    ax
      pop    si
      pop    di
      jmp sub2_cout
      
sub2_cout:
      lea dx, ans3
      mov ah, 09
      int 21h ;显示结果提示语

      lea bx, num2 ;bx再次指向num1，num1中现在存放着结果

      call output ;调用output输出结果

      jmp exit



numsub endp

exit:
      mov ah,4ch
      int 21h
      ret

codes ends
end start
