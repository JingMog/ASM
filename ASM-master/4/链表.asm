assume cs:code
;如何实现动态分配空间
name1 segment
	dw 128 dup(0)			
name1 ends

data segment
	init dw 3,10,2,8,7,13,15,20,11,9 ;install时加入的十个数据
	insert_data dw 20,12,15,88,19	   ;要插入的数据
	loc dw 4,5,11,1,8 			       ;插入后的结点位置,首节点位置为1
	del_loc dw 6,8,2,7			       ;删除的结点位置,首结点位置为1
	divisors dw 10000,1000,100,10,1	;用于将数字的每个位分开变成相应的字符串
	results db 0,0,0,0,0,0,0,'$'	;用来显示数据,最后2个0选择换行和空格

    string0 db 10,13,"    With this programme, we will demonstrate the ways of creating a linked list, add new nodes to a linked list and deleting a linked list with the assembly language.",'$'
    string1 db 10,13,"    first, initialize the linked list to create it. Ten numbers will be put into the linked list, the numbers are:3,10,2,8,7,13,15,20,11,9.",'$'
    string2 db 10,13,"    Now, add 5 nodes to the linked list to demonstrate the function of adding new nodes to the list.",'$'
    string2_1 db 10,13,"  In order, 20 will first be added to no.4, 12 will be added to no.5,15 will be added to no.11, 88 will be added to no.1, 19 will be added to no.8. The first node of the list is no.1.",'$'
    string3 db 10,13,"    Last, delete 4 nodes from the list to demonstrate the function of deleting from the list.",'$'
    string3_1 db 10,13,"  In order, first delete no.6, than delete no.8, than delete no.2, than delete no.7.",'$'
    string4 db 10,13,"Thank you for using this product. We wish you a good day.",'$'
    string db 10,13," ","$"

data ends

stack segment
	dw 0,0,0,0,0,0,0,0			;栈用来临时保存数据
stack ends

code segment
main:
    mov ax,data
	mov ds,ax
	lea dx, string0
	mov ah, 09
	int 21H ;显示第一句提示语

    lea dx, string1
	mov ah, 09
	int 21H ;显示第二句提示语

    lea dx, string
	mov ah, 09
	int 21H ;显示第二句提示语

main_list:
    ;mov ax,data
    ;mov ds,ax ;给ds赋值数据段的段地址,注意是数据
    mov ax,name1 
    mov es,ax ;es中存放链表（目的段的段地址），es为辅助数据段的段地址
    mov ax,stack
    mov ss,ax ;ss中存放栈的段地址
    mov sp,10H  ;栈底元素

    mov cx,10 ;cx中存放要插入链表的数据的个数
    mov bx,0 ;bx中存放数据值的偏移地址。每个节点由数据值和下一个节点的地址组成
    mov di,0 ;di中存放数据源的偏移地址

    mov word ptr es:[bx+2],4
    ;一个节点是4个字节，前两个字节中存放数据，后两个字节中存放下一个节点的地址。bx=0，bx+2，为该节点存放下一个节点的位置，则说明这个头节点指向下一个节点的位置为4,下一个节点是首节点，即链表中第一个节点
    mov bx,4 ;bx中存放数据值的偏移值，现在bx要指向下一个节点的数据存放位置，下一个节点在4这个地方，因此存放数据的地址为4，bx赋值为4

    call install ;调用初始化函数初始化函数只会被调用一次
;***************************以上完成了初始化链表并插入了10个数据的操作********************

    push bx ;保存bx,此时bx的值为44
    mov bx,0 ;先清零，准备赋值
    mov bx,es:[bx+2] ;es中存放的是链表的头节点地址，es[bx+2]存放的是链表首节点的地址，为4，则bx被赋值为了4

    call show ;通过show进行数据输出,在此会输出刚刚存入的10个数据3,10,2,8,7,13,15,20,11,9，中间用空格分隔
;***************************以上完成了一次链表的输出操作********************

    lea dx, string2
	mov ah, 09
	int 21H ;显示第一句提示语

    lea dx, string2_1
	mov ah, 09
	int 21H ;显示第一句提示语

    lea dx, string
	mov ah, 09
	int 21H ;显示第二句提示语

    pop si ;刚刚push进入栈的是下一个新的要插入的节点的位置，44，现在si=44
    mov cx,5 ;接下来新插入5个数据
    mov di,20 ;di是指向的数据源的偏移地址，刚刚输出了data中的前10个数，每个数是2个字节。先要从20处开始输出新的data

    call insert ;调用插入的函数

    mov bx,0
    mov bx,es:[bx+2] ;先定位到头节点，利用头节点找到首节点
    call show ;输出刚刚插入操作完成后的链表
;***************************以上完成了链表的插入操作并显示了插入操作完成后的链表********************

    lea dx, string3
	mov ah, 09
	int 21H ;显示第一句提示语

    lea dx, string3_1
	mov ah, 09
	int 21H ;显示第一句提示语

    lea dx, string
	mov ah, 09
	int 21H ;显示第二句提示语

    mov cx,4 ;删除的数据量
    mov bx,0 ;bx指向链表的头节点
    mov di,40 ;data定位到第四行，待删除节点的位置处
    
    call delete ;调用删除的函数

    mov bx,0
    mov bx,es:[bx+2] ;先定位到头节点，利用头节点找到首节点
    call show ;输出刚刚插入操作完成后的链表
;***************************以上完成了链表的删除操作并显示了插入操作完成后的链表********************
    lea dx, string4
	mov ah, 09
	int 21H ;显示第二句提示语

    lea dx, string
	mov ah, 09
	int 21H ;显示第二句提示语

    mov ax,4c00H
    int 21H



;***************************链表初始化********************
install:
    mov ax,[di] ;此时di=0，将data中的第一个数据（3）赋值给ax，现在ax等于3
    mov es:[bx],ax ;现在bx=4,bx中存放数据值的偏移值。现在bx指向的是首节点存放数据的地方。
    ;通过上面两步操作，完成了数据的插入操作

    cmp cx,1 ;比较看cx是否为1，因为cx中存放的是要插入的数据个数，如果要插入的数据只有1个，跳转到judge
    jna judge ;cx等于1的时候跳转到judge

    push bx ;把bx的值压到栈中保存
    add bx,4 
    ;把存放数据的偏移地址后移4个。其实就是在改变指像链表尾的指针，下一次插入时，先插入的是数据，直接在bx处插入即可，然后用es:[bx+2]插入下一个节点的位置
    mov ax,bx ;把下一个要插入新的节点的位置（偏移地址）赋值给ax
    pop bx ;刚刚插入数据的位置（就是第一个节点的数据的位置，4）
    mov es:[bx+2],ax
    ;把ax的值赋值给该节点（现在是第一个节点）的存放下一个节点位置的地方（ax中存放的是下一个节点，第二个节点的数据的偏移地址）
    ;通过上面这几部的操作，完成了指向下一个节点的位置的插入
return:
    add bx,4 ;bx再次指向下一个节点（第二个节点）存放数据的位置
    add di,2 ;di中存放的是数据源data的偏移地址，刚刚输出了第一个数据3，接下来要输出下一个数据，di=di+2
    loop install ;循环install，把初始要加入的10个数据都加入进去
    ret ;循环结束，10个数据都插入到链表中后返回
judge:
    mov word ptr es:[bx+2],0 ;让他指向的下一个节点为0。即最后一个节点的下一个节点为0
    jmp short return ;跳转到return后，再执行return，再返回



;****************插入链表:插入在两个结点之间*****************
insert:
    mov bx,0 ;将bx赋值为0，此时指向头节点的段地址
    push cx; cx中存放的是总共要插入多少数据，先将这个值保存在栈中，为5
    mov ax,[di+10] ;data中的第二行存放的是要插入的数据，data的第三行存放的是这些数据都要插入在哪儿。现在di+10=20+5*2，定位到那里
    mov cx,ax      ;把第一个要插入的位置赋值给cx，第一个要插入的位置是4,要从头节点往后面找这个4的位置，因为不能一次直接伸手去抓
    sub cx,1 ;cx减1，因为data中的是插入后的节点的位置
    cmp cx,0 ;循环到cx=0的时候，就是要插入的位置了，这时候调用insertnode把节点插进去
    je insertnode 
    call searchnode

insertnode:
    mov ax,[di] ;把di处的数据放入ax中，这里的di=20，表示的就是待插入进去的数据值,
    mov es:[si],ax ;在链表偏移了si处那个地方创建一个链表节点，现在si=44，在44处创建了一个新节点,并在此处存入这个新节点的数据值
    push es:[bx+2] ;保存现在这个节点所指向的下一个节点在哪。现在这个位置不是待换掉的那个位置（比如插入的那个节点插入后要在4号，则现在bx指示的是3号节点）
    mov es:[bx+2],si ;将现在bx指向的节点（3号）的下一个节点位置设为新创建的节点的位置（44）（3号节点原来下一个节点的偏移位置为12，现在变成44）
    pop ax ;取出刚刚放进去的下一个节点的偏移位置（3号节点本来的下一个节点的位置12）,并放到ax
    mov es:[si+2],ax ;将新创建的节点的下一个节点的位置设置为ax中的那个位置
    ;完成了链表的插入操作

    add di,2 ;数据源定位后移
    add si,4 ;链表往后移一个
    pop cx ;刚刚前面存进来的，总共要插入多少数据
    loop insert ;重复insert
    ret

searchnode:
    mov ax,es:[bx+2] ;第一次进来是es:[bx+2]中存放着首节点的位置，现在ax中存放下一个节点的位置（首节点）（以此类推）
    mov bx,ax ;将ax赋给bx，现在bx从0移动到4，就是移动到下一个节点

    loop searchnode ;循环，直到找到待插入的位置为止然后返回
    ret

;*****************************删除数据**************************
delete:
    mov bx,0 ;先定位到头节点
    push cx ;cx中存放的是要删除多少个数据
    mov ax,[di] ;把待删除节点的位置存放到ax中
    mov cx,ax
    sub cx,1 ;cx减1（同插入节点原理）
    cmp cx,0 
    je deletenode
    call searchnode ;在上面insert处已写

deletenode:
    mov dx,bx ;bx中存放的是待删除的那个节点的前一个节点
    mov bx,es:[bx+2] ;让bx指向bx的下一个节点，就是待删除的节点
    mov ax,es:[bx+2] ;将待删除节点原本的下一个节点的位置赋值给ax
    mov bx,dx ;再将待删除节点的前一个节点的值赋值给bx
    mov es:[bx+2],ax ;让待删除节点的前一个节点的下一个一个节点值为ax，就是待删除节点的下一个节点
    ;以上就删除了一个节点

    add di,2 ;数据源定位后移
    pop cx ;cx中存放着总共要删除多少节点
    loop delete 
    ret

;*************************显示数据*******************************
show:
	mov si,offset divisors ;对应除数的偏移地址
	mov di,offset results ;对应显示内容ds:dx的偏移地址
	mov cx,7 ;5个因为字节表示的范围是5位数，第6个表示空格，第7个表示换行
	mov ax,es:[bx] ;显示的循环次数为最后的条件
					;cal处理一个数据
fenka:	;进行5次除法把数转换成单独的字符，如650,0,0转换成6,5,0,0,0
	cmp cx,2 ;用来选择是否输出空格，因为第6个表示空格，所以用cx和2（减了5次后剩余2）
	je kongge ;如果cx=2，则跳转以输出空格
	mov dx,0 ;div指令的高16位dx
	div word ptr [si] ;除,结果商放在ax，dx存放余数
	add al,30H ;转换成相应的字符串
	mov byte ptr [di],al
	inc di
	add si,2
	mov ax,dx ;余数给ax
	loop fenka
 
kongge:		;将六个字符设为空格的ASCII码
	mov byte ptr [di],32
	mov bx,es:[bx+2] ;bx是下一个结点的偏移地址
	inc di ;di指向第6个字符
	cmp bx,0 ;当bx为0时决定将第7个字符设置为换行符，否则设置为空格
 
	je huanhang
	mov byte ptr [di],32 ;最后字符选择空格
	jmp short ready
 
huanhang:				;输出换行
	mov byte ptr [di],10 ;最后选择输出结束则换行
 
ready:	
    mov cx,4 ;决定ds:dx输出的内容是否带省略不需要的0
	mov di,offset results
 
jmpzero:	
    cmp byte ptr [di],'0' ;跳过省略的0
	jne print
	inc di
	loop jmpzero
print:					;进行输出
	mov dx,di
	mov ah,9				;当ah=9时,
	int 21h				;int 21h表示将ds:dx内容输出
	cmp bx,0				;bx重定位和选择是否结束
	je ok				;结束循环
	jmp short show
 
ok:ret
    

code ends
end main