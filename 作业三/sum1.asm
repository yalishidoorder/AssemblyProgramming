; == 结果保存在寄存器中 ==
.model small
.stack 100h

.data
input_prompt   db 0Dh,0Ah, 'Please enter a number(1-100)',0Dh,0Ah,'$'
output_prompt  db 0Dh,0Ah, 'sum:',0Dh,0Ah,'$'

input_buffer   db 5
               db ?         ; 实际输入字符数
               db 5 dup(?)  ; 存储输入字符串
res_str        db 5 dup('$'); 存储结果字符串

.code
main proc
    mov ax, @data
    mov ds, ax

    ; 显示输入提示
    lea dx, input_prompt
    mov ah, 09h
    int 21h

    ; 读取输入字符串
    mov ah, 0Ah
    lea dx, input_buffer
    int 21h

    ; 将输入的字符串转换为数字
    call str2num

    mov cx, 0
    ; 累加循环
    add_loop:
        add cx, ax
        inc ax
        ; 循环判断条件
        cmp ax, 101
        jb  add_loop
    
    ; 将累加结果转换为字符串
    mov ax, cx          
    call num2str

    ; 显示输出提示
    lea dx, output_prompt  
    mov ah, 09h
    int 21h

    ; 输出结果
    mov dx, offset res_str
    mov ah, 09h
    int 21h

    mov ah, 4Ch
    int 21h

; 子程序：将10进制字符串转换为数值
; 输入：buffer中的字符串
; 输出：AX = 数值
str2num proc
    push bx
    push cx
    push si
    
    mov si, offset input_buffer + 2  ; 指向字符串开始
    mov cl, [input_buffer + 1]       ; 获取字符串长度
    mov ch, 0
    mov ax, 0                        ; 初始化结果为0
    
convert_loop:
    mov bl, [si]                     ; 获取当前字符
    sub bl, '0'                      ; 转换为数字
    mov bh, 0
    
    ; ax = ax * 10 + bx
    push bx
    mov bx, 10
    mul bx                           ; dx:ax = ax * 10
    pop bx
    add ax, bx                       ; 加上当前数字
    
    inc si                           ; 指向下一个字符
    loop convert_loop
    
    pop si
    pop cx
    pop bx
    ret
str2num endp

; 子程序：将累加结果转换为字符串
; 输入：AX = 数值
; 输出：res_str中的字符串
num2str proc
    push bx
    push cx
    push dx
    push si
    
    mov si, offset res_str + 4       ; 指向字符串末尾
    mov byte ptr [si], '$'           ; 设置字符串结束符
    mov bx, 10                       ; 除数
    
    ; 处理特殊情况：如果数字为0
    cmp ax, 0
    jne convert_num
    dec si
    mov byte ptr [si], '0'
    jmp done_convert
    
convert_num:
    mov cx, ax                       ; 保存原始值
    
convert_loop2:
    dec si                           ; 向前移动指针
    mov dx, 0                        ; 清零dx，准备除法
    div bx                           ; ax = 商, dx = 余数
    
    add dl, '0'                      ; 将余数转换为ASCII字符
    mov [si], dl                     ; 存储字符
    
    cmp ax, 0                        ; 检查商是否为0
    jne convert_loop2
    
    ; 如果字符串没有从res_str开始，需要移动字符串
    mov ax, si
    cmp ax, offset res_str
    je done_convert
    
    ; 移动字符串到res_str开始位置
    mov di, offset res_str
    mov si, ax
    
move_string:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    cmp al, '$'
    jne move_string
    
done_convert:
    pop si
    pop dx
    pop cx
    pop bx
    ret
num2str endp

main endp
end main