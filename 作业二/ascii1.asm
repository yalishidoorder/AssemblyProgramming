.model small
.stack 100h

.data
newline db 0Dh, 0Ah, '$'  ; 回车换行
space db ' $'             ; 空格

.code
main proc
    mov ax, @data
    mov ds, ax
    
    mov ch, 2             ; 外层循环：2行
    mov bl, 'a'           ; 起始字符 'a'
    
outer_loop:
    mov cl, 13            ; 内层循环：每行13个字符
    push cx               ; 保存外层循环计数器
    
inner_loop:
    ; 显示当前字符
    mov dl, bl
    mov ah, 02h
    int 21h
    
    ; 显示空格
    mov dx, offset space
    mov ah, 09h
    int 21h
    
    inc bl                ; 下一个字符
    loop inner_loop       ; 内层循环
    
    ; 换行
    mov dx, offset newline
    mov ah, 09h
    int 21h
    
    pop cx                ; 恢复外层循环计数器
    dec ch
    jnz outer_loop        ; 外层循环
    
    ; 程序退出
    mov ah, 4Ch
    int 21h
    
main endp
end main
