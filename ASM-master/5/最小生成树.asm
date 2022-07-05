assume cs:code,ds:data,ss:stack

;数据段
data segment
    chain db 9 dup(3 dup(?))            ;chain数组存放临界表
    ;chain[i][j] = i和j顶点之间的权值
    neighbor db 4 dup(4 dup(0))         ;临界表的二维数组
    ;neighbor=w[i][j]
    lowcost  db 10 dup(?)               ;用来记录U中所有点到其余点的最小代价，最大值为99（无边）
    mst db 10 dup(?)                    ;用来记录已经访问过的边
    vertex db 3                         ;顶点数
    edge db 3                           ;边数
    tips_input db "input the neighbor list",13,10,"$"   ;输入提示信息
    tips_res db 13,10,"the shortest branch:","$"    ;结果提示信息
data ends

;栈段
stack segment
    db 50 dup(?)
stack ends


code segment
start:
    mov ax,data
    mov ds,ax
    ;此处输入代码段代码

    ;输出字符串"input the neighbor list"
    mov dx,offset tips_input            ;取有效地址
    mov ah,09h
    int 21h                             ;输出提示信息

    call make_graph                     ;生成图
    call make_neighbor                  ;生成邻接表
    
    mov bx,offset vertex                ;获得vertex的偏移地址
    mov cx,[bx]                         ;cx存放顶点个数
    sub ch,ch                           ;高位清零
    dec cx                              ;低位--,循环n-1次
    mov di,2                            ;i,循环变量,初值为2

; for(size_t i = 1; i <= n; ++i)
;     lowcost[i] = map[1][i];
;   int min;
;   bool visited[n + 1];// index begin from 1 not 0
;   int ans = -1;
;   memset(visited, false, sizeof(visited));
;   lowcost[1] = 0;
;   visited[1] = true;
;   for(size_t i = 1; i < n; ++i)//loop n - 1 times
;   {
;     min = inf;
;     int k;
;     for(size_t j = 1; j <= n; ++j)// find the minimun edge between two edge set
;     {
;       if(!visited[j] && min > lowcost[j])
;       {
;         min = lowcost[j];
;         k = j;
;       }
;     }
;     visited[k] = true;
;     ans = ans > min ? ans : min; 
;     for(size_t j = 1; j <= n; ++j)// update the array of lowcost 
;     {
;       if(!visited[j] && lowcost[j] > map[k][j])
;         lowcost[j] = map[k][j];
;     }
;   }
;   return ans;




;初始化lowcost
l1:                             
    lea si,neighbor[4][di]      ;si指向邻接表的第一个顶点的邻接表
    lodsb                       ;取出顶点i的邻接表的第一个顶点的编号
    mov [lowcost+di],al         ;将顶点i的最小代价存入lowcost[i]
    mov [mst+di],1              ;
    inc di                      ;i++
    loop l1                     ;循环


    mov di,1                    ;重置循环变量
    mov [mst+di],0              

	mov bx,2                    ;i
	mov bp,2                    ;j
l2:
	mov ax,99                   ;初始化最小代价为99
	mov cx,0                    ;初始化最小代价的顶点下标为0
	mov bp,2

;寻找最小代价的边
l3:	
	mov dl,[lowcost+bp]         ;取出bp对应的最小代价
	sub dh,dh                   ;清空高位
	cmp dx,ax                   ;比较最小代价与ax
	jge next0                   ;若最小代价大于等于ax,则跳转到next0
	cmp dx,0                    ;比较最小代价与0
	je next0                    ;若最小代价等于0,则跳转到next0
	mov al,[lowcost+bp]         
	xor ah,ah
	mov cx,bp
next0:
	mov di,offset vertex        ;获得vertex的偏移地址
    mov dl,[di]                 ;取出顶点个数
    xor dh,dh
    cmp bp,dx                   ;比较bp与顶点个数
    jg next1                    ;若bp大于顶点个数,则跳转到next1
    inc bp
    jmp l3                      ;bp小于顶点个数跳转
next1:
	push ax                     ;保存寄存器
	push si

	;lea si,[mst+cx]
	;lodsb
	;mov dl,al
	mov si,cx                   
	mov dl,[mst+si]
	xor dh,dh

	pop si                      ;恢复寄存器
	pop ax
	mov dh,cl
	call print_res              ;输出最终结果
	
	mov si,cx
	mov [lowcost+si],0
	mov bp,2;don't put it in l4

;每次计算完一个节点,将其加入到最小生成树中,就需要重新更新lowcost数组
;更新lowcost
;一共有三条边,每次更新一条边
;内层
l4:	
	push ax	
	mov al,4
	xor ah,ah
	mul cl                      
	mov di,ax
	mov al,neighbor[di][bp]     ;neighbor[i][j]
	xor ah,ah
	mov di,ax                   ;di:graph[minid][j]
	pop ax
	
	mov dl,[lowcost+bp]         ;取出bp对应的最小代价
	xor dh,dh;in dx:lowcost[j]
	cmp di,dx                   ;对比最小代价
	jge next2                   ;若最小代价大于等于dx,则跳转到next2
	
	mov dx,di
	mov [lowcost+bp],dl
	mov [mst+bp],cl

next2:	
	lea di,vertex               ;获得vertex的偏移地址
    mov dl,[di]
    xor dh,dh
    cmp bp,dx                   ;if(j < vertexnum)
    jg next3                    ;j>vertexnum,则跳转到next3
    inc bp                      ;j<vertexnum,则bp++
    jmp l4                      ;继续遍历
;外层
next3:
	lea di,vertex               ;获得vertex的偏移地址
    mov dl,[di]                 ;取出顶点个数
    xor dh,dh
    cmp bx,dx                   ;if(j < vertexnum)
    jge exit                    ;j>=vertexnum,则跳转到exit
    inc bx                      
    jmp l2                      ;继续下一个顶点,直到所有顶点全部在生成树中为止
    
exit:
    mov ah,4ch                 ;程序结束
    int 21h



;子程序:输出最终结果
print_res proc near
	push ax                             ;保存寄存器
	push cx
	push dx

	mov dx,offset tips_res              ;取偏移地址
    mov ah,09h                          ;输出结果提示信息
    int 21h

    pop dx
	mov cx,dx                           ;cx=dx
	xor dh,dh                           ;dx高位清零
	add dx,030h	                        ;数字转化为对应的ascii码输出
	mov ah,02h                          ;输出
	int 21h

	mov dx," "                          ;输出空格
	mov ah,02h
	int 21h

	mov dl,ch                           ;输出第二条边
	xor dh,dh                           ;dx高位清零
	add dx,030h                         ;数字转化为对应的ascii码输出
	mov ah,02h                          ;输出
	int 21h

	mov dx," "                          ;输出空格
	mov ah,02h
	int 21h
	pop cx                              ;恢复寄存器状态
	pop ax
	ret
print_res endp


;子程序:生成图
;从键盘读取权值并生成邻接表
make_graph proc near
    mov cx,9                        ;循环次数
    mov si,0                        ;si置零,相当于i
    sub si,2                        ;si-2=0fffeh

make:
    add si,2                        ;i后移,用来访问数组元素
error:
    mov ah,01h                      ;从键盘中读取一个字符,从到al中
    int 21h                         ;中断

    cmp al,'0'                      ;输入下届
    jl error                        ;小于就跳转至error处,重新输入
    cmp al,'9'                      ;输入上界
    jg error                        ;大于就跳转至error处,重新输入

    sub al,30h                      ;转化为数值,-30h

    lea bx,chain                    ;获取chain数组偏移地址
    mov [bx+si],al                  ;存放输入数据到chain数组中
    add si,2                        ;si后移,即i++
    mov [bx+si+1],si                ;存放si
    sub si,2                        

    mov dx," "                      ;输出空格
    mov ah,02h                      ;每次输入一个字符就输出一个空格
    int 21h

    loop make                       ;循环调用

    ret
make_graph endp


;子程序:生成
make_neighbor proc near

    lea di,chain                    ;di存放邻接表偏移地址
    mov bp,1                        ;循环变量,用来基址寻址

make1:
    mov al,[di]                     ;获取当前权值
    mov [neighbor+4+bp],al          ;al转移到neighbor数组中
    inc bp
    add di,2

    cmp bp,4
    jl make1                        ;bp小于4就继续,相当于while(i<4)

    mov bp,1                        ;重置bp

make2:
    mov al,[di]                     ;第二条边,重复上述操作,转移到neighbor数组中
    mov [neighbor+8+bp],al
    inc bp
    add di,2

    cmp bp,4
    jl make2                        ;bp小于4就继续,相当于while(i<4)

    mov bp,1                        ;重置bp
make3:                              
    mov al,[di]                     ;第二条边,重复上述操作,转移到neighbor数组中
    mov [neighbor+12+bp],al
    inc bp
    add di,2

    cmp bp,4
    jl make3                        ;bp小于4就继续,相当于while(i<4)
    
    ret
make_neighbor endp

code ends
end start




