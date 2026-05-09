 ;TIC-TAC-TAE


UPDATE_CELL Macro pos,sign
    push ax
    push bx
    push si
    
    mov al,pos
    sub al,48
    dec al
    
    xor ah,ah
    mov si,ax
    
    lea bx,board
    mov al,sign
    mov [bx+si],al
    
    pop si
    pop bx
    pop si
    
endm

IS_EMPTY Macro pos,is_valid 
    local not_free,done
    
    push ax
    push bx
    push si
    
    mov al,pos
    sub al,48
    dec al
    xor ah,ah
    mov si,ax
    
    lea bx,board
    mov al,[bx+si]
    
    cmp al,'X'
    je Not_free
    cmp al,'O'
    je not_free
    
    mov is_valid,1
    jmp done
    
    not_free:
    mov is_valid,0
    
    done:
    pop si
    pop bx
    pop ax
    
endm 

check_Line macro p1, p2, p3, win_flag 
    local no_win, winner_found, end_check,continue_check
    push ax
    push bx
    push si

    lea bx, board
    
    
    mov si, p1
    mov al, [bx+si]
    
    
    cmp al, 'X'
    je continue_check
    cmp al, 'O'
    je continue_check
    jmp no_win

continue_check:
    
    mov si, p2
    cmp al, [bx+si]
    jne no_win
    
    
    mov si, p3
    cmp al, [bx+si]
    jne no_win

winner_found:
    mov win_flag, 1
    jmp end_check

no_win:
    mov win_flag, 0

end_check:
    pop si
    pop bx
    pop ax
endm

;3 rows, 3 columns,2 diagonals

check_winner macro final_flag 
    local win
    
    ;rows
    
    check_line 0,1,2,final_flag
    cmp final_flag,1
    je win
    
    check_line 3,4,5,final_flag
    cmp final_flag,1
    je win
    
    check_line 6,7,8,final_flag
    cmp final_flag,1
    je win
          
    ;columns
    
    check_line 0,3,6,final_flag
    cmp final_flag,1
    je win
    
    check_line 1,4,7,final_flag
    cmp final_flag,1
    je win
    
    check_line 2,5,8,final_flag
    cmp final_flag,1
    je win
    
    ;diagonals
    
    check_line 0,4,8,final_flag
    cmp final_flag,1
    je win
    
    win:
endm


check_draw macro draw_flag
    local check_loop,is_draw,not_draw
    push cx
    push si
    
    mov cx,9
    mov si,0
    
    check_loop:
    
    mov al,board[si]
    cmp al,'X'
    je next_cell
    cmp al, 'O'
    je next_cell
    
    jmp not_draw
    
    next_cell:
    inc si
    loop check_loop
    
    mov draw_flag,1
    jmp finish_draw
    
    not_draw:
    mov draw_flag,0
    
    finish_draw:
    pop si
    pop cx
    
endm

    
    

    
