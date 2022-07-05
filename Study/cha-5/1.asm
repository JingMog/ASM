
;----------------------宏定义--------------------
;               换行
;参数：无
;功能：输出换行符
ENDL MACRO
    PUSH DX
    MOV DL,0AH
    PUTC
    POP DX
ENDM

;               输出空格
;参数：无
;功能：输出空格
SPACE MACRO
    PUSH DX
    MOV DL,' '
    PUTC
    POP DX
ENDM

;               从键盘读入一个字符
;参数：无
;功能：字符存放到AL中
GETC MACRO        
    MOV AH,01H
    INT 21H
ENDM

;               从键盘读入一个字符串
;参数：无
;功能：字符存放到AL中
GETS MACRO   
    PUSH AX       
    MOV AH,0AH
    INT 21H
    POP AX
ENDM

;               输出一个字符到显示屏
;参数：DL存放待输出字符
;功能：输出DL中的字符
PUTC MACRO    
    PUSH AX      
    MOV AH,02H
    INT 21H
    POP AX
ENDM

;               输出一个字符串到显示屏
;参数：DS:DX为字符串基址
;功能：
PUTS MACRO    
    PUSH AX      
    MOV AH,09H
    INT 21H
    POP AX
ENDM

;               结束进程
;参数：无
;功能：结束中断
EXIT MACRO          
    MOV AH,4CH
    INT 21H
ENDM

;               段地址初始化
;参数：无
;功能：初始化DS,SS,ES
INIT MACRO
    MOV AX,DATA     ;初始化DS
    MOV DS,AX
    MOV AX,ST       ;初始化SS
    MOV SS,AX
    MOV SP,0F000H      ;初始化SP，0F000H为栈长
    MOV AX,0B800H   ;初始化ES为显存段地址
    MOV ES,AX
ENDM

;               清屏
;参数：无
;结果：清空显示屏
CLEAR MACRO
    PUSH AX    
    PUSH BX
    PUSH CX
    PUSH DX

    ;清屏
    MOV AH,06H 
    MOV AL,0    
    mov CH,0   ;左上角的行号
    mov CL,0   ;左上角的列号
    mov DH,25  ;右下角的行号
    mov DL,80  ;右下角的列号
    mov BH,17H ;属性为蓝底白字
    INT 10H     
    ;光标设置到左上角
    MOV AH,02H          
    MOV BH,0            ;页号，一般设置为0
    MOV DH,0            ;行号
    MOV DL,0            ;列号
    INT 10H             

    POP DX
    POP CX
    POP BX
    POP AX
ENDM

;------------------------------------------------


DATA SEGMENT
    NUM1_INPUT_INFO:DB 'INPUT THE NUM1: ','$'
    NUM2_INPUT_INFO:DB 'INPUT THE NUM2: ','$'
    RESULT_INFO:DB 'RESULT: ','$'
    NUM1:DB 300 DUP (0)
    NUM2:DB 300 DUP (0)
    NUM3:DB 300 DUP (0)
    DEBUG_INFO:DB 'DEBUG','$'
    RETURN_INFO:DB '(ENTER ESC TO RETURN)',0AH,'$'
    MENU_STR:DB '1.BIG NUM ADD',0AH
             DB '2.BIG NUM SUB',0AH
             DB '3.EXIT',0AH,'$'
DATA ENDS

ST SEGMENT          ;60KB的栈段
    DB 0F000H DUP (0)
ST ENDS

CODE SEGMENT
ASSUME DS:DATA,SS:ST,CS:CODE
;--------------------------------子程序--------------------
;                      十进制形式打印数字
;输入参数：PUSH待打印的数作为唯一参数
;输出参数：无
;说明：待打印数字小于65535
PRINT_NUM_DEC PROC
    PUSH AX
    PUSH BX
    PUSH DX
    PUSH BP
    
    ;初始化参数
    MOV BP,SP
    MOV AX,[BP+10]

    SUB DX,DX
    MOV BX,10
    DIV BX
    CMP AX,0
    JE PRINT_REMAIN
    PUSH AX
    CALL PRINT_NUM_DEC    ;先递归输出商
    
    PRINT_REMAIN:
        ADD DL,'0'
        PUTC         ;再输出余数

    POP BP
    POP DX
    POP BX
    POP AX
    RET 2
PRINT_NUM_DEC ENDP
;---------------------------大数模板-------------------------
;               读入大数
;参数：POS:大数的偏移位移
;功能：将键盘输入的大数读入到从DS:POS开始的数据段中
READ_BIGNUM PROC
READ_BIGNUM_INI:
    PUSH BP             ;因为用到BP，需要保存与恢复
    MOV BP,SP           ;BP存栈顶指针
    ADD BP,4            ;BP跳过刚刚暂存的BP以及call所压栈的IP，指向POS参数
    PUSH BX             ;因为用到BX、CX,所以需要保存和恢复
    PUSH CX
    MOV BX,[BP]         ;BX存POS
    MOV CX,0            ;CX记录输入的字符个数

    PUSH BX
    PUSH CX
    MOV CX,300
    READ_BIGNUM_INI_LOOP:
        MOV BYTE PTR [BX],0
        INC BX
        LOOP READ_BIGNUM_INI_LOOP
    POP CX
    POP BX

READ_BIGNUM_READ:       ;连续读入若干字符，直到回车为止
    GETC
    CMP AL,0DH          ;与回车比较
    JE READ_BIGNUM_FORM ;输入了回车则终止读入循环
    INC CX              ;否则字符个数加一
    SUB AL,'0'          ;减去0转化为数
    PUSH AX             ;整个AX PUSH进去，到时候只取AL即可
    JMP READ_BIGNUM_READ ;继续读入字符

READ_BIGNUM_FORM:        ;从低位到高位依次存放每一位
    POP AX
    MOV [BX],AL         ;放置数位
    INC BX              ;移向下一数位
    LOOP READ_BIGNUM_FORM
    
READ_BIGNUM_END:
    POP CX              ;寄存器值的恢复
    POP BX              
    POP BP
    RET 2               ;弹出一个参数
READ_BIGNUM ENDP

;               输出大数
;参数：POS:大数的偏移位移
;功能：显示DS:POS的大数
PRINT_BIGNUM PROC
PRINT_BIGNUM_INI:
    PUSH BP             ;因为用到BP，需要保存与恢复
    MOV BP,SP           ;BP存栈顶指针
    ADD BP,4            ;BP跳过刚刚暂存的BP以及call所压栈的IP，指向POS参数
    PUSH BX             ;因为用到BX、CX,所以需要保存和恢复
    PUSH CX
    MOV BX,[BP]         ;BX存POS
    MOV CX,300          ;CX记录大数的有效位数

ADD BX,299                  ;倒着遍历
PRINT_BIGNUM_SKIP_ZERO:     ;跳过前导零
    CMP CX,0
    JE PRINT_BIGNUM_SKIP_ZERO_LEFT
    CMP BYTE PTR [BX],0
    JNE PRINT_BIGNUM_PRINT  ;当前位非0则进入输出阶段
    DEC BX                  ;否则BX前移
    DEC CX                  ;有效位数减一
    JMP PRINT_BIGNUM_SKIP_ZERO  ;继续跳过前导零

PRINT_BIGNUM_SKIP_ZERO_LEFT:
    ;特判：全为0
    CMP CX,0
    JNE PRINT_BIGNUM_PRINT
    PUSH DX
    MOV DL,'0'
    PUTC
    POP DX
    JMP PRINT_BIGNUM_END

PRINT_BIGNUM_PRINT:        ;输出剩余的有效数位
    MOV DL,[BX]            ;取出数位
    ADD DL,'0'             ;数转化为字符
    PUTC
    DEC BX
    LOOP PRINT_BIGNUM_PRINT
    
PRINT_BIGNUM_END:
    POP CX              ;寄存器值的恢复
    POP BX              
    POP BP
    RET 2               ;弹出一个参数
PRINT_BIGNUM ENDP

;               大数复制
;参数：POS1:大数1的偏移地址 POS2：大数2的偏移地址
;功能：将大数2传输给大数1
MOV_BIGNUM PROC
MOV_BIGNUM_INI:
    PUSH BP             ;因为用到BP，需要保存与恢复
    MOV BP,SP           ;BP存栈顶指针
    ADD BP,4            ;BP跳过刚刚暂存的BP以及call所压栈的IP，指向POS2参数
    PUSH BX             ;因为用到BX、CX,所以需要保存和恢复
    PUSH CX
    PUSH SI

    MOV BX,[BP+2]       ;BX存POS1
    MOV SI,[BP]         ;SI存POS2

MOV CX,300              ;传输300个字节单元
MOV_BIGNUM_MOV:
    MOV AX,[SI]         ;以AX为中介进行传输
    MOV [BX],AX
    INC BX              ;移向下一个数位
    INC SI
    LOOP MOV_BIGNUM_MOV

MOV_BIGNUM_END:
    POP SI              ;寄存器值的恢复
    POP CX              
    POP BX              
    POP BP
    RET 4               ;弹出两个参数
MOV_BIGNUM ENDP

;               大数相加
;参数：POS1:大数1的偏移地址 POS2：大数2的偏移地址 POS3:结果大数的偏移地址
;功能：大数1与大数2相加并将结果存放到DS:POS3中
ADD_BIGNUM PROC
ADD_BIGNUM_INI:
    PUSH BP             ;因为用到BP，需要保存与恢复
    MOV BP,SP           ;BP存栈顶指针
    ADD BP,4            ;BP跳过刚刚暂存的BP以及call所压栈的IP，指向POS3参数
    PUSH BX             ;因为用到BX、CX,所以需要保存和恢复
    PUSH CX
    PUSH SI
    PUSH DI

    MOV BX,[BP+4]         ;BX存POS1
    MOV SI,[BP+2]         ;SI存POS2
    MOV DI,[BP]           ;DI存POS3

MOV CX,300          ;清零NUM3的300个数位
PUSH DI             ;保存POS3
ADD_BIGNUM_CLEAR:
    MOV BYTE PTR [DI],0      ;数位清零
    INC DI          ;移向下一个数位
    LOOP ADD_BIGNUM_CLEAR
POP DI              ;恢复DI为POS3

MOV CX,299          ;考虑前299位相加
ADD_BIGNUM_ADD:
    MOV AL,[BX]
    ADD AL,[SI]     ;AL为NUM1和NUM2的当前数位和
    ADD [DI],AL       ;加到NUM3的数位上去
    ;考虑进位
    CMP BYTE PTR [DI],9
    JNA ADD_BIGNUM_ADD_NEXT ;小于等于9直接进入下一个数位
    SUB BYTE PTR [DI],10               ;否则向高位进位
    INC BYTE PTR [DI+1]
    ADD_BIGNUM_ADD_NEXT:
    INC BX          ;移向下一个数位
    INC SI
    INC DI
    LOOP ADD_BIGNUM_ADD

ADD_BIGNUM_END:
    POP DI
    POP SI
    POP CX              ;寄存器值的恢复
    POP BX              
    POP BP
    RET 6               ;弹出三个参数
ADD_BIGNUM ENDP

;大数相减
;参数：无
;功能：大数1与大数2相加并将结果存放到DS:POS3中
;-------------------------------------------------------------------
SUB_BIGNUM PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    ;预处理:当NUM1小于NUM2时，交换NUM1和NUM2,并输出符号
    MOV CX,300
    MOV SI,299
    SUB_BIGNUM_PRE_LOOP:
        MOV BX,OFFSET NUM1
        MOV DL,[BX+SI]
        MOV BX,OFFSET NUM2
        CMP DL,[BX+SI]
        JNE SUB_BIGNUM_PRE_SWAP
        DEC SI
        LOOP SUB_BIGNUM_PRE_LOOP
    
    SUB_BIGNUM_PRE_SWAP:
        CMP CX,0
        JE SUB_BIGNUM_PRE_LEFT
        CMP DL,[BX+SI]
        JNB SUB_BIGNUM_PRE_LEFT
        MOV DL,'-'
        PUTC
        PUSH OFFSET NUM3
        PUSH OFFSET NUM1
        CALL MOV_BIGNUM
        PUSH OFFSET NUM1
        PUSH OFFSET NUM2
        CALL MOV_BIGNUM
        PUSH OFFSET NUM2
        PUSH OFFSET NUM3
        CALL MOV_BIGNUM

    SUB_BIGNUM_PRE_LEFT:
    ;NUM3清零
    MOV CX,300
    MOV BX,OFFSET NUM3
    SUB_BIGNUM_INI_LOOP:
        MOV BYTE PTR [BX],0
        INC BX
        LOOP SUB_BIGNUM_INI_LOOP
    ;作减法
    MOV CX,299
    SUB SI,SI 
    SUB_BIGNUM_SUB_LOOP:
        MOV BX,OFFSET NUM1
        MOV AL,[BX+SI]
        MOV BX,OFFSET NUM3
        ADD [BX+SI],AL
        MOV BX,OFFSET NUM2
        MOV AL,[BX+SI]
        MOV BX,OFFSET NUM3
        SUB [BX+SI],AL
        
        CMP BYTE PTR [BX+SI],10
        JNA SUB_BIGNUM_SUB_LOOP_LEFT
        ;不够减则借位，加10
        ADD BYTE PTR [BX+SI],10
        DEC BYTE PTR [BX+SI+1]

        SUB_BIGNUM_SUB_LOOP_LEFT:
            INC SI
            LOOP SUB_BIGNUM_SUB_LOOP

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
SUB_BIGNUM ENDP
FUNC1 PROC
    PUSH DX

    MOV DX,OFFSET NUM1_INPUT_INFO
    PUTS
    PUSH OFFSET NUM1    ;读入NUM1
    CALL READ_BIGNUM

    MOV DX,OFFSET NUM2_INPUT_INFO
    PUTS
    PUSH OFFSET NUM2    ;读入NUM2
    CALL READ_BIGNUM

    PUSH OFFSET NUM1    ;NUM1加NUM2得到NUM3
    PUSH OFFSET NUM2
    PUSH OFFSET NUM3
    CALL ADD_BIGNUM   

    MOV DX,OFFSET RESULT_INFO
    PUTS
    PUSH OFFSET NUM3    ;输出NUM3
    CALL PRINT_BIGNUM 

    ENDL
    MOV DX,OFFSET RETURN_INFO
    PUTS
    FUNC1_LOOP:
        MOV AH,07H
        INT 21H
        CMP AL,27
        JE FUNC1_LEFT
        JMP FUNC1_LOOP
    
    FUNC1_LEFT:
        POP DX
        RET
FUNC1 ENDP
FUNC2 PROC
    PUSH DX

    MOV DX,OFFSET NUM1_INPUT_INFO
    PUTS
    PUSH OFFSET NUM1    ;读入NUM1
    CALL READ_BIGNUM

    MOV DX,OFFSET NUM2_INPUT_INFO
    PUTS
    PUSH OFFSET NUM2    ;读入NUM2
    CALL READ_BIGNUM

    MOV DX,OFFSET RESULT_INFO
    PUTS
    CALL SUB_BIGNUM

    PUSH OFFSET NUM3    ;输出NUM3
    CALL PRINT_BIGNUM 

    ENDL
    MOV DX,OFFSET RETURN_INFO
    PUTS
    FUNC2_LOOP:
        MOV AH,07H
        INT 21H
        CMP AL,27
        JE FUNC2_LEFT
        JMP FUNC2_LOOP
    
    FUNC2_LEFT:
        POP DX
        RET
FUNC2 ENDP
MAIN:           ;主函数 
    INIT
    MAIN_LOOP:
        CLEAR
        MOV DX,OFFSET MENU_STR  ;输出菜单
        PUTS
        MOV AH,07H
        INT 21H
        CMP AL,'1'      ;增加元素
        JNE OPT2
        CLEAR
        CALL FUNC1

        OPT2:
        CMP AL,'2'      ;增加元素
        JNE OPT3
        CLEAR
        CALL FUNC2

        OPT3:
        CMP AL,'3'      ;退出程序
        JE MAIN_LEFT
        JMP MAIN_LOOP
    MAIN_LEFT:
        EXIT
CODE ENDS

END MAIN
