;������μĴ����ʹ���ι�������
;�����ݶμĴ��������ݶι�������
;����Ĺ�����û���κ�ʵ�ʲ������൱�ڸ������Լ���ע��
;�൱�ڼ�ʹ��д��һ��Ҳû�й�ϵ

assume cs:code, ds:data


; ���ݶο�ʼ
data segment
	;�����ַ���
	;����ӡ�ַ���Ҫ��β���� $ ����ַ����Ľ���λ��
	;���ַ�����hello��һ����ǣ�����֮��ʹ��
	hello db 'Hello world!$'
	dname db 'My name is JsingMog.$'

;���ݶν���
data ends


;����ο�ʼ
code segment
;ָ��ִ�е���ʼ���൱��Main()�������
start:
	;������Բ����Զ������ݶμĴ���ָ���������ݶ�
	;�����ݶμĴ���ָ�����ݶ�
	mov ax, data
	mov ds,ax
	
	;��ӡ�ַ����Ĳ���
	;DS:DX=����ַ�����ַ�����ƫ�Ƶ�ַ����dx�Ĵ���
	;�ַ����������ݶ���ʼ�����ģ�����ƫ�Ƶ�ַ��0H
	;offset hello���ҵ����Ϊhello�����ݶ��ַ����ı����ַ
	;������Я��mov dx,0H
	
	mov dx, offset hello
	;��ӡ�ַ�����ah=9H�����ӡ
	mov aH,9H
	int 21H
	
	mov dx, offset dname
	;��ӡ�ַ�����ah=9H�����ӡ
	mov aH,9H
	int 21H
	
	;�����˳�����
	mov ah, 4CH
	int 21H


code ends


end start
