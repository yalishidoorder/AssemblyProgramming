main:
PUSH BP              ; 保存基址指针
MOV BP, SP           ; 设置新的基址指针
SUB SP, 04           ; 为局部变量分配空间(ascii占1字节，i占2字节，对齐到4字节)

; 初始化局部变量
MOV BYTE [BP-1], 61h ; ascii = 'a' (ASCII 61h)
MOV WORD [BP-3], 1   ; i = 1

; 循环开始
loop_start:
; 条件判断: i <= 26
CMP WORD [BP-3], 26
JG loop_end

; printf("%c ", ascii)
PUSH WORD [BP-1]     ; 压参: ascii字符 (注意: 实际是压入AX，这里简化)
CALL printf          ; 调用printf函数
ADD SP, 2            ; 清理栈

; ascii++
INC BYTE [BP-1]

; if (i % 13 == 0)
MOV AX, [BP-3]       ; AX = i
MOV BL, 13
DIV BL               ; AH = i % 13
CMP AH, 0
JNZ skip_newline

; printf("\n")
PUSH 0A0Dh           ; 压参: 换行符(0Dh=回车, 0Ah=换行)
CALL printf          ; 调用printf函数
ADD SP, 2            ; 清理栈

skip_newline:
; i++
INC WORD [BP-3]
JMP loop_start

; 循环结束
loop_end:
; return 0;
XOR AX, AX           ; AX = 0

; 函数结尾
MOV SP, BP
POP BP
RET