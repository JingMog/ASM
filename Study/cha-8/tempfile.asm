.386
.model flat, stdcall

include windows.inc
include kernel32.inc
includelib kernel32.lib

.data
    szText db 'Hello World!', 0

;�������� DWORD ���͵ı���, �ֱ����������������ַ�������
.data?
    hOut dd ?
    len  dd ?

.code
start:
    ; ��ȡ����̨����豸�ľ��, �䷵��ֵ����� eax �Ĵ���
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    ; �ѻ�ȡ���ľ�������� hOut 
    mov hOut, eax
    ; ͨ�� lstrlen ������ȡ�ַ�������, ����ֵ�� eax                        
    invoke lstrlen, addr szText      
    ; �ѻ�ȡ�����ַ������ȸ����� len      
    mov len, eax
    ; ���������̨, �����ֱ���: ������ַ�����ַ���ַ�������; ����������ָ�����ò���                           
    invoke WriteFile, hOut, addr szText, len, NULL, NULL
    ret
end start
