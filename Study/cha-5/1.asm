
;----------------------�궨��--------------------
;               ����
;��������
;���ܣ�������з�
ENDL MACRO
    PUSH DX
    MOV DL,0AH
    PUTC
    POP DX
ENDM

;               ����ո�
;��������
;���ܣ�����ո�
SPACE MACRO
    PUSH DX
    MOV DL,' '
    PUTC
    POP DX
ENDM

;               �Ӽ��̶���һ���ַ�
;��������
;���ܣ��ַ���ŵ�AL��
GETC MACRO        
    MOV AH,01H
    INT 21H
ENDM

;               �Ӽ��̶���һ���ַ���
;��������
;���ܣ��ַ���ŵ�AL��
GETS MACRO   
    PUSH AX       
    MOV AH,0AH
    INT 21H
    POP AX
ENDM

;               ���һ���ַ�����ʾ��
;������DL��Ŵ�����ַ�
;���ܣ����DL�е��ַ�
PUTC MACRO    
    PUSH AX      
    MOV AH,02H
    INT 21H
    POP AX
ENDM

;               ���һ���ַ�������ʾ��
;������DS:DXΪ�ַ�����ַ
;���ܣ�
PUTS MACRO    
    PUSH AX      
    MOV AH,09H
    INT 21H
    POP AX
ENDM

;               ��������
;��������
;���ܣ������ж�
EXIT MACRO          
    MOV AH,4CH
    INT 21H
ENDM

;               �ε�ַ��ʼ��
;��������
;���ܣ���ʼ��DS,SS,ES
INIT MACRO
    MOV AX,DATA     ;��ʼ��DS
    MOV DS,AX
    MOV AX,ST       ;��ʼ��SS
    MOV SS,AX
    MOV SP,0F000H      ;��ʼ��SP��0F000HΪջ��
    MOV AX,0B800H   ;��ʼ��ESΪ�Դ�ε�ַ
    MOV ES,AX
ENDM

;               ����
;��������
;����������ʾ��
CLEAR MACRO
    PUSH AX    
    PUSH BX
    PUSH CX
    PUSH DX

    ;����
    MOV AH,06H 
    MOV AL,0    
    mov CH,0   ;���Ͻǵ��к�
    mov CL,0   ;���Ͻǵ��к�
    mov DH,25  ;���½ǵ��к�
    mov DL,80  ;���½ǵ��к�
    mov BH,17H ;����Ϊ���װ���
    INT 10H     
    ;������õ����Ͻ�
    MOV AH,02H          
    MOV BH,0            ;ҳ�ţ�һ������Ϊ0
    MOV DH,0            ;�к�
    MOV DL,0            ;�к�
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

ST SEGMENT          ;60KB��ջ��
    DB 0F000H DUP (0)
ST ENDS

CODE SEGMENT
ASSUME DS:DATA,SS:ST,CS:CODE
;--------------------------------�ӳ���--------------------
;                      ʮ������ʽ��ӡ����
;���������PUSH����ӡ������ΪΨһ����
;�����������
;˵��������ӡ����С��65535
PRINT_NUM_DEC PROC
    PUSH AX
    PUSH BX
    PUSH DX
    PUSH BP
    
    ;��ʼ������
    MOV BP,SP
    MOV AX,[BP+10]

    SUB DX,DX
    MOV BX,10
    DIV BX
    CMP AX,0
    JE PRINT_REMAIN
    PUSH AX
    CALL PRINT_NUM_DEC    ;�ȵݹ������
    
    PRINT_REMAIN:
        ADD DL,'0'
        PUTC         ;���������

    POP BP
    POP DX
    POP BX
    POP AX
    RET 2
PRINT_NUM_DEC ENDP
;---------------------------����ģ��-------------------------
;               �������
;������POS:������ƫ��λ��
;���ܣ�����������Ĵ������뵽��DS:POS��ʼ�����ݶ���
READ_BIGNUM PROC
READ_BIGNUM_INI:
    PUSH BP             ;��Ϊ�õ�BP����Ҫ������ָ�
    MOV BP,SP           ;BP��ջ��ָ��
    ADD BP,4            ;BP�����ո��ݴ��BP�Լ�call��ѹջ��IP��ָ��POS����
    PUSH BX             ;��Ϊ�õ�BX��CX,������Ҫ����ͻָ�
    PUSH CX
    MOV BX,[BP]         ;BX��POS
    MOV CX,0            ;CX��¼������ַ�����

    PUSH BX
    PUSH CX
    MOV CX,300
    READ_BIGNUM_INI_LOOP:
        MOV BYTE PTR [BX],0
        INC BX
        LOOP READ_BIGNUM_INI_LOOP
    POP CX
    POP BX

READ_BIGNUM_READ:       ;�������������ַ���ֱ���س�Ϊֹ
    GETC
    CMP AL,0DH          ;��س��Ƚ�
    JE READ_BIGNUM_FORM ;�����˻س�����ֹ����ѭ��
    INC CX              ;�����ַ�������һ
    SUB AL,'0'          ;��ȥ0ת��Ϊ��
    PUSH AX             ;����AX PUSH��ȥ����ʱ��ֻȡAL����
    JMP READ_BIGNUM_READ ;���������ַ�

READ_BIGNUM_FORM:        ;�ӵ�λ����λ���δ��ÿһλ
    POP AX
    MOV [BX],AL         ;������λ
    INC BX              ;������һ��λ
    LOOP READ_BIGNUM_FORM
    
READ_BIGNUM_END:
    POP CX              ;�Ĵ���ֵ�Ļָ�
    POP BX              
    POP BP
    RET 2               ;����һ������
READ_BIGNUM ENDP

;               �������
;������POS:������ƫ��λ��
;���ܣ���ʾDS:POS�Ĵ���
PRINT_BIGNUM PROC
PRINT_BIGNUM_INI:
    PUSH BP             ;��Ϊ�õ�BP����Ҫ������ָ�
    MOV BP,SP           ;BP��ջ��ָ��
    ADD BP,4            ;BP�����ո��ݴ��BP�Լ�call��ѹջ��IP��ָ��POS����
    PUSH BX             ;��Ϊ�õ�BX��CX,������Ҫ����ͻָ�
    PUSH CX
    MOV BX,[BP]         ;BX��POS
    MOV CX,300          ;CX��¼��������Чλ��

ADD BX,299                  ;���ű���
PRINT_BIGNUM_SKIP_ZERO:     ;����ǰ����
    CMP CX,0
    JE PRINT_BIGNUM_SKIP_ZERO_LEFT
    CMP BYTE PTR [BX],0
    JNE PRINT_BIGNUM_PRINT  ;��ǰλ��0���������׶�
    DEC BX                  ;����BXǰ��
    DEC CX                  ;��Чλ����һ
    JMP PRINT_BIGNUM_SKIP_ZERO  ;��������ǰ����

PRINT_BIGNUM_SKIP_ZERO_LEFT:
    ;���У�ȫΪ0
    CMP CX,0
    JNE PRINT_BIGNUM_PRINT
    PUSH DX
    MOV DL,'0'
    PUTC
    POP DX
    JMP PRINT_BIGNUM_END

PRINT_BIGNUM_PRINT:        ;���ʣ�����Ч��λ
    MOV DL,[BX]            ;ȡ����λ
    ADD DL,'0'             ;��ת��Ϊ�ַ�
    PUTC
    DEC BX
    LOOP PRINT_BIGNUM_PRINT
    
PRINT_BIGNUM_END:
    POP CX              ;�Ĵ���ֵ�Ļָ�
    POP BX              
    POP BP
    RET 2               ;����һ������
PRINT_BIGNUM ENDP

;               ��������
;������POS1:����1��ƫ�Ƶ�ַ POS2������2��ƫ�Ƶ�ַ
;���ܣ�������2���������1
MOV_BIGNUM PROC
MOV_BIGNUM_INI:
    PUSH BP             ;��Ϊ�õ�BP����Ҫ������ָ�
    MOV BP,SP           ;BP��ջ��ָ��
    ADD BP,4            ;BP�����ո��ݴ��BP�Լ�call��ѹջ��IP��ָ��POS2����
    PUSH BX             ;��Ϊ�õ�BX��CX,������Ҫ����ͻָ�
    PUSH CX
    PUSH SI

    MOV BX,[BP+2]       ;BX��POS1
    MOV SI,[BP]         ;SI��POS2

MOV CX,300              ;����300���ֽڵ�Ԫ
MOV_BIGNUM_MOV:
    MOV AX,[SI]         ;��AXΪ�н���д���
    MOV [BX],AX
    INC BX              ;������һ����λ
    INC SI
    LOOP MOV_BIGNUM_MOV

MOV_BIGNUM_END:
    POP SI              ;�Ĵ���ֵ�Ļָ�
    POP CX              
    POP BX              
    POP BP
    RET 4               ;������������
MOV_BIGNUM ENDP

;               �������
;������POS1:����1��ƫ�Ƶ�ַ POS2������2��ƫ�Ƶ�ַ POS3:���������ƫ�Ƶ�ַ
;���ܣ�����1�����2��Ӳ��������ŵ�DS:POS3��
ADD_BIGNUM PROC
ADD_BIGNUM_INI:
    PUSH BP             ;��Ϊ�õ�BP����Ҫ������ָ�
    MOV BP,SP           ;BP��ջ��ָ��
    ADD BP,4            ;BP�����ո��ݴ��BP�Լ�call��ѹջ��IP��ָ��POS3����
    PUSH BX             ;��Ϊ�õ�BX��CX,������Ҫ����ͻָ�
    PUSH CX
    PUSH SI
    PUSH DI

    MOV BX,[BP+4]         ;BX��POS1
    MOV SI,[BP+2]         ;SI��POS2
    MOV DI,[BP]           ;DI��POS3

MOV CX,300          ;����NUM3��300����λ
PUSH DI             ;����POS3
ADD_BIGNUM_CLEAR:
    MOV BYTE PTR [DI],0      ;��λ����
    INC DI          ;������һ����λ
    LOOP ADD_BIGNUM_CLEAR
POP DI              ;�ָ�DIΪPOS3

MOV CX,299          ;����ǰ299λ���
ADD_BIGNUM_ADD:
    MOV AL,[BX]
    ADD AL,[SI]     ;ALΪNUM1��NUM2�ĵ�ǰ��λ��
    ADD [DI],AL       ;�ӵ�NUM3����λ��ȥ
    ;���ǽ�λ
    CMP BYTE PTR [DI],9
    JNA ADD_BIGNUM_ADD_NEXT ;С�ڵ���9ֱ�ӽ�����һ����λ
    SUB BYTE PTR [DI],10               ;�������λ��λ
    INC BYTE PTR [DI+1]
    ADD_BIGNUM_ADD_NEXT:
    INC BX          ;������һ����λ
    INC SI
    INC DI
    LOOP ADD_BIGNUM_ADD

ADD_BIGNUM_END:
    POP DI
    POP SI
    POP CX              ;�Ĵ���ֵ�Ļָ�
    POP BX              
    POP BP
    RET 6               ;������������
ADD_BIGNUM ENDP

;�������
;��������
;���ܣ�����1�����2��Ӳ��������ŵ�DS:POS3��
;-------------------------------------------------------------------
SUB_BIGNUM PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    ;Ԥ����:��NUM1С��NUM2ʱ������NUM1��NUM2,���������
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
    ;NUM3����
    MOV CX,300
    MOV BX,OFFSET NUM3
    SUB_BIGNUM_INI_LOOP:
        MOV BYTE PTR [BX],0
        INC BX
        LOOP SUB_BIGNUM_INI_LOOP
    ;������
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
        ;���������λ����10
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
    PUSH OFFSET NUM1    ;����NUM1
    CALL READ_BIGNUM

    MOV DX,OFFSET NUM2_INPUT_INFO
    PUTS
    PUSH OFFSET NUM2    ;����NUM2
    CALL READ_BIGNUM

    PUSH OFFSET NUM1    ;NUM1��NUM2�õ�NUM3
    PUSH OFFSET NUM2
    PUSH OFFSET NUM3
    CALL ADD_BIGNUM   

    MOV DX,OFFSET RESULT_INFO
    PUTS
    PUSH OFFSET NUM3    ;���NUM3
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
    PUSH OFFSET NUM1    ;����NUM1
    CALL READ_BIGNUM

    MOV DX,OFFSET NUM2_INPUT_INFO
    PUTS
    PUSH OFFSET NUM2    ;����NUM2
    CALL READ_BIGNUM

    MOV DX,OFFSET RESULT_INFO
    PUTS
    CALL SUB_BIGNUM

    PUSH OFFSET NUM3    ;���NUM3
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
MAIN:           ;������ 
    INIT
    MAIN_LOOP:
        CLEAR
        MOV DX,OFFSET MENU_STR  ;����˵�
        PUTS
        MOV AH,07H
        INT 21H
        CMP AL,'1'      ;����Ԫ��
        JNE OPT2
        CLEAR
        CALL FUNC1

        OPT2:
        CMP AL,'2'      ;����Ԫ��
        JNE OPT3
        CLEAR
        CALL FUNC2

        OPT3:
        CMP AL,'3'      ;�˳�����
        JE MAIN_LEFT
        JMP MAIN_LOOP
    MAIN_LEFT:
        EXIT
CODE ENDS

END MAIN
