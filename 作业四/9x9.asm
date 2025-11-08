.model small
.stack 100h

.data 
output_prompt   db 0dh, 0ah, 'The 9mul9 table:', 0dh, 0ah, '$'
multiply_sign   db '*$'           
equal_sign      db '=$'          
double_space    db '  $'          ; 空格
newline         db 0dh, 0ah, '$'  ; 回车换行
res_str         db 4 dup('$')     ; 存储结果字符串

.code
main proc
    mov ax, @data
    mov ds, ax

    call output_9x9table ; 调用函数

    ; 程序结束
    mov ah, 4ch
    int 21h

output_9x9table proc
    mov ch, 9       ; 外层循环9层

    outer_loop:
        mov cl, 1       ; 内层循环从1开始
        push cx

        inner_loop:
            mov bh, ch
            mov bl, cl

            ; 转换成字符
            add bh, '0'
            add bl, '0'

            ; row
            mov dl, bh   
            mov ah, 02h
            int 21h

            ; 乘号
            mov dx, offset multiply_sign
            mov ah, 09h
            int 21h

            ; col
            mov dl, bl
            mov ah, 02h
            int 21h

            ; 等号
            lea dx, equal_sign
            mov ah, 09h
            int 21h

            mov al, ch
            mul cl          ; 计算乘积

            ; 处理两位数结果
            mov bl, 10
            div bl              ; AL = 商(十位), AH = 余数(个位)
            mov dh, ah
    
            ; 显示十位数（如果有）
            cmp al, 0
            je  display_unit
            mov dl, al
            add dl, '0'
            mov ah, 02h
            int 21h
    
            display_unit:
                ; 显示个位数
                mov dl, dh
                add dl, '0'
                mov ah, 02h
                int 21h

            ; 空格
            lea dx, double_space
            mov ah, 09h
            int 21h

            inc cl
            cmp ch, cl
            jnb inner_loop

        ; 换行
        mov dx, offset newline
        mov ah, 09h
        int 21h
    
        pop cx                ; 恢复外层循环计数器
        dec ch
        jnz outer_loop        ; 外层循环

    ret

output_9x9table endp

main endp
end main
