.model small
.stack 100h

.data
    menu_msg      db 0Dh, 0Ah, 'Select conversion:', 0Dh, 0Ah
                  db '1. Hex to Dec', 0Dh, 0Ah
                  db '2. Dec to Hex', 0Dh, 0Ah
                  db '$'
    prompt_hex    db 0Dh, 0Ah, 'Please input a Hex number:', 0Dh, 0Ah, '$'
    prompt_dec    db 0Dh, 0Ah, 'Please input a Dec number:', 0Dh, 0Ah, '$'
    result_dec    db 0Dh, 0Ah, 'The Dec number:', 0Dh, 0Ah, '$'
    result_hex    db 0Dh, 0Ah, 'The Hex number:', 0Dh, 0Ah, '$'
    newline       db 0Dh, 0Ah, '$'
    buffer        db 4, ?, 4 dup(?)   ; 输入缓冲区，最大3个字符
    num           dw ?                ; 存储转换后的数字
    dec_str       db 4 dup('$')       ; 存储10进制字符串
    hex_str       db 3 dup('$')       ; 存储16进制字符串

.code
start:
    mov ax, @data
    mov ds, ax

menu:
    ; 显示菜单
    mov ah, 09h
    mov dx, offset menu_msg
    int 21h

    ; 读取用户选择
    mov ah, 01h
    int 21h

    ; 根据选择跳转
    cmp al, '1'
    je hex_to_dec
    cmp al, '2'
    je dec_to_hex
    jmp menu        ; 输入无效，重新显示菜单

hex_to_dec:
    ; 显示输入16进制数的提示
    mov ah, 09h
    mov dx, offset prompt_hex
    int 21h

    ; 读取输入字符串
    mov ah, 0Ah
    mov dx, offset buffer
    int 21h

    ; 转换16进制字符串为数字
    call hex2num

    ; 转换数字为10进制字符串
    call num2dec

    ; 显示结果
    mov ah, 09h
    mov dx, offset result_dec
    int 21h
    mov dx, offset dec_str
    int 21h
    mov dx, offset newline
    int 21h

    jmp exit

dec_to_hex:
    ; 显示输入10进制数的提示
    mov ah, 09h
    mov dx, offset prompt_dec
    int 21h

    ; 读取输入字符串
    mov ah, 0Ah
    mov dx, offset buffer
    int 21h

    ; 转换10进制字符串为数字
    call dec2num

    ; 转换数字为16进制字符串
    call num2hex

    ; 显示结果
    mov ah, 09h
    mov dx, offset result_hex
    int 21h
    mov dx, offset hex_str
    int 21h
    mov dx, offset newline
    int 21h

    jmp exit

exit:
    ; 退出程序
    mov ah, 4Ch
    int 21h

; 将16进制字符串转换为数字
hex2num proc
    mov si, offset buffer + 2   ; 指向输入字符串
    mov cl, [buffer + 1]        ; 获取实际长度
    mov ch, 0
    mov ax, 0                   ; 初始化结果为0
    jcxz hex_done               ; 如果长度为0，直接返回

hex_loop:
    mov dl, [si]                ; 取一个字符
    cmp dl, '0'
    jb hex_next                 ; 非数字字符跳过
    cmp dl, '9'
    jbe hex_digit               ; 数字0-9
    cmp dl, 'A'
    jb hex_next                 ; 非字母字符跳过
    cmp dl, 'F'
    jbe hex_upper               ; 大写字母A-F
    cmp dl, 'a'
    jb hex_next                 ; 非字母字符跳过
    cmp dl, 'f'
    jbe hex_lower               ; 小写字母a-f
    jmp hex_next

hex_digit:
    sub dl, '0'                 ; 转换为数字
    jmp hex_add

hex_upper:
    sub dl, 'A' - 10            ; 转换为数字10-15
    jmp hex_add

hex_lower:
    sub dl, 'a' - 10            ; 转换为数字10-15

hex_add:
    mov bl, dl
    mov bh, 0
    mov dx, 16
    mul dx                      ; ax = ax * 16
    add ax, bx                  ; 加上当前数字
hex_next:
    inc si
    loop hex_loop

hex_done:
    mov num, ax                 ; 保存结果
    ret
hex2num endp

; 将10进制字符串转换为数字
dec2num proc
    mov si, offset buffer + 2
    mov cl, [buffer + 1]
    mov ch, 0
    mov ax, 0                   ; 初始化结果为0
    jcxz dec_done               ; 如果长度为0，直接返回

dec_loop:
    mov dl, [si]
    cmp dl, '0'
    jb dec_next                 ; 非数字字符跳过
    cmp dl, '9'
    ja dec_next                 ; 非数字字符跳过
    sub dl, '0'                 ; 转换为数字
    mov bl, dl
    mov bh, 0
    mov dx, 10
    mul dx                      ; ax = ax * 10
    add ax, bx                  ; 加上当前数字
dec_next:
    inc si
    loop dec_loop

dec_done:
    mov num, ax                 ; 保存结果
    ret
dec2num endp

; 将数字转换为10进制字符串
num2dec proc
    mov ax, num
    mov cx, 0                   ; 计数器清零
    mov bx, 10                  ; 基数为10

    ; 处理0的情况
    cmp ax, 0
    jne div_loop
    mov dec_str, '0'
    mov dec_str+1, '$'
    jmp dec_ret

div_loop:
    mov dx, 0
    div bx                      ; dx:ax / 10 -> ax商, dx余数
    add dl, '0'                 ; 转换为ASCII
    push dx                     ; 保存余数
    inc cx
    cmp ax, 0
    jne div_loop

    ; 将数字弹出到字符串
    mov di, offset dec_str
store_dec:
    pop dx
    mov [di], dl
    inc di
    loop store_dec
    mov byte ptr [di], '$'      ; 字符串结束符

dec_ret:
    ret
num2dec endp

; 将数字转换为16进制字符串
num2hex proc
    mov ax, num
    mov cx, 0                   ; 计数器清零
    mov bx, 16                  ; 基数为16

    ; 处理0的情况
    cmp ax, 0
    jne hex_div_loop
    mov hex_str, '0'
    mov hex_str+1, '$'
    jmp hex_ret

hex_div_loop:
    mov dx, 0
    div bx                      ; dx:ax / 16 -> ax商, dx余数
    cmp dl, 10
    jb hex_digit                ; 小于10跳转
    add dl, 'A' - 10            ; 10-15转换为A-F
    jmp hex_push

hex_digit:
    add dl, '0'                 ; 0-9转换为ASCII
hex_push:
    push dx                     ; 保存余数
    inc cx
    cmp ax, 0
    jne hex_div_loop

    ; 将数字弹出到字符串
    mov di, offset hex_str
store_hex:
    pop dx
    mov [di], dl
    inc di
    loop store_hex
    mov byte ptr [di], '$'      ; 字符串结束符

hex_ret:
    ret
num2hex endp

end start