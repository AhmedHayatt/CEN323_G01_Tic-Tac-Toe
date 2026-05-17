; ==============================================================================
; PROJECT: TIC-TAC-TOE 
; ==============================================================================
include 'macros.inc'


.model small
.stack 100h

; ---------------------------------------------------------
; DATA SEGMENT
; ---------------------------------------------------------
.data
    board db '1','2','3','4','5','6','7','8','9' 
    current_player db 1  
    is_valid db 0        
    win_flag db 0        
    draw_flag db 0
    current_move db 0
    
    p1_score dw 0
    p2_score dw 0
    
    inst_title  db 10, 13, '       ===================================================='
                db 10, 13, '               INSTRUCTIONS (IF U DONT KNOW HOW TO PLAY)     '
                db 10, 13, '       ====================================================$'     
                
  inst_1      db 10, 13, 10, 13, '  1. The game is played on a 3x3 grid.$'
    inst_2      db 10, 13, '  2. Player 1 is X, Player 2 is O.$'
    inst_3      db 10, 13, '  3. Players take turns selecting 1-9.$'
    inst_4      db 10, 13, '  4. First to get 3 in a row wins.$'
    inst_any    db 10, 13, 10, 13, 'Press any key to enter menu...$'
    
    get_name1   db 10, 13, ' Enter Player 1 Name: $'
    get_name2   db 10, 13, 10, 13, ' Enter Player 2 Name: $'
    
    p1_name label byte
    p1_max  db 15
    p1_len  db ?
    p1_buf  db 16 dup('$')
    
    p2_name label byte
    p2_max  db 15
    p2_len  db ?
    p2_buf  db 16 dup('$')
    
    grid_ui db 10, 13, '           |       |       '
            db 10, 13, '           |       |       '  
            db 10, 13, '   --------+-------+-------'
            db 10, 13, '           |       |       '
            db 10, 13, '           |       |       '  
            db 10, 13, '   --------+-------+-------'
            db 10, 13, '           |       |       '
            db 10, 13, '           |       |       $' 
    
    menu_title  db 10, 13, '       ============================='
                db 10, 13, '          TIC-TAC-TOE               '
                db 10, 13, '       =============================$'
    menu_opt1   db 10, 13, 10, 13, '        1. Start New game$'
    menu_opt2   db 10, 13, '        2. View Scores$'
    menu_opt3   db 10, 13, '        3. Exit$'
    menu_prompt db 10, 13, 10, 13, 'Select an option: $'
    
    score_title db 10, 13, '       ============================='
                db 10, 13, '             SCORES BOARD       '
                db 10, 13, '       =============================$'
                
    newline  db 10, 13, 10, 13, ' $'
    turn_x   db ' (X) - Enter position: $'
    turn_o   db ' (O) - Enter position: $'
    score_x  db ' (X) Wins: $'
    score_o  db ' (O) Wins: $'
    msg_draw db 10, 13, 10, 13, ' IT IS A DRAW! $'
    msg_inv  db 10, 13, ' Invalid move! Try again.$'
    

    win_dec     db '  =======================================$'
    big_win_msg db ' WINS!!! ', 1, '$'  
    prompt_menu db '  Press any key to visit menu...$' 
    
    
;=========================================
;MAIN CODE
;=========================================
     
    
    .code
main proc
    mov ax, @data
    mov ds, ax

    call DrawInstructions
    READ_CHAR

Menu_Start:
    call DrawMainMenu
    READ_CHAR
    
    cmp al, '1'
    je Setup_New_Game
    cmp al, '2'
    je Show_Scores   
    cmp al, '3'
    je Exit_Game
    jmp Menu_Start  

Setup_New_Game:
    call GetPlayerNames
    mov p1_score, 0     
    mov p2_score, 0

Start_Round:
    call ResetBoard
    mov current_player, 1
    mov win_flag, 0
    mov draw_flag, 0

Game_Loop:
    call DrawBoard
    
    PRINT_STR newline
    cmp current_player, 1
    je P1_Turn
    PRINT_STR p2_buf    
    PRINT_STR turn_o
    jmp Get_Input
P1_Turn:
    PRINT_STR p1_buf    
    PRINT_STR turn_x

Get_Input:
    READ_CHAR
    mov current_move, al
    
    cmp al, '1'
    jb Invalid_Move   
    cmp al, '9'
    ja Invalid_Move   
    
    IS_EMPTY current_move, is_valid
    cmp is_valid, 1
    jne Invalid_Move
    
    cmp current_player, 1
    je P1_Update
    UPDATE_CELL current_move, 'O'
    jmp Check_State
P1_Update:
    UPDATE_CELL current_move, 'X'

Check_State:
    check_winner win_flag
    cmp win_flag, 1
    je Winner_Found
    
    check_draw draw_flag
    cmp draw_flag, 1
    je Draw_Found
    
    cmp current_player, 1
    je Set_P2
    mov current_player, 1
    jmp Game_Loop
Set_P2:
    mov current_player, 2
    jmp Game_Loop

Invalid_Move:
    PRINT_STR msg_inv
    READ_CHAR
    jmp Game_Loop

Winner_Found:
    cmp current_player, 1
    je P1_Wins_Score
    inc p2_score
    jmp Show_Win_Screen
P1_Wins_Score:
    inc p1_score       
Show_Win_Screen:
    call DrawWinScreen
    jmp Menu_Start

Draw_Found:
    call DrawBoard
    PRINT_STR msg_draw
    PRINT_STR newline
    PRINT_STR prompt_menu
    READ_CHAR
    jmp Menu_Start   

Show_Scores:
    call DrawScoreScreen
    jmp Menu_Start

Exit_Game:
    mov ah, 4ch
    int 21h
main endp  

;==============================================
;procedures and ui   
;===============================================

DrawInstructions proc
    push ax
    push dx
    mov ah, 06h
    mov al, 00h    
    mov bh, 0E1h   
    mov cx, 0000h  
    mov dx, 184Fh  
    int 10h
    mov ah, 02h
    mov bh, 0
    mov dx, 0000h
    int 10h

    PRINT_STR inst_title
    PRINT_STR inst_1
    PRINT_STR inst_2
    PRINT_STR inst_3
    PRINT_STR inst_4
    PRINT_STR inst_any
    pop dx
    pop ax
    ret
DrawInstructions endp

GetPlayerNames proc
    push ax
    push bx
    push dx
    
    mov ah, 06h
    mov al, 00h    
    mov bh, 0E1h   
    mov cx, 0000h  
    mov dx, 184Fh  
    int 10h
    mov ah, 02h
    mov bh, 0
    mov dx, 0000h
    int 10h
    
    PRINT_STR get_name1
    lea dx, p1_name
    mov ah, 0Ah
    int 21h
    xor bx, bx
    mov bl, p1_len
    mov p1_buf[bx], '$'
    
    PRINT_STR get_name2
    lea dx, p2_name
    mov ah, 0Ah
    int 21h
    xor bx, bx
    mov bl, p2_len
    mov p2_buf[bx], '$'
    
    pop dx
    pop bx
    pop ax
    ret
GetPlayerNames endp

DrawMainMenu proc
    push ax
    push dx
    mov ah, 06h
    mov al, 00h    
    mov bh, 0E1h   
    mov cx, 0000h  
    mov dx, 184Fh  
    int 10h
    mov ah, 02h
    mov bh, 0
    mov dx, 0000h
    int 10h
  PRINT_STR menu_title
    PRINT_STR menu_opt1
    PRINT_STR menu_opt2
    PRINT_STR menu_opt3
    PRINT_STR menu_prompt
    pop dx
    pop ax
    ret
DrawMainMenu endp

DrawWinScreen proc
    push ax
    push dx

    ; Clear Screen
    mov ah, 06h
    mov al, 00h
    mov bh, 0E1h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h

    mov ah, 02h
    mov bh, 0
    mov dh, 9
    mov dl, 15
    int 10h
    PRINT_STR win_dec

    mov ah, 02h
    mov bh, 0
    mov dh, 11
    mov dl, 20
    int 10h
    
    cmp current_player, 1
    je Print_P1_W
    PRINT_STR p2_buf
    jmp Print_W_Msg
Print_P1_W:
    PRINT_STR p1_buf

Print_W_Msg:
    PRINT_STR big_win_msg

    mov ah, 02h
    mov bh, 0
    mov dh, 13
    mov dl, 15
    int 10h
    PRINT_STR win_dec

    mov ah, 02h
    mov bh, 0
    mov dh, 17
    mov dl, 20
    int 10h
    PRINT_STR prompt_menu

    ; Wait for any key press
    READ_CHAR

    pop dx
    pop ax
    ret
DrawWinScreen endp

DrawScoreScreen proc
    push ax
    push dx
    mov ah, 06h
    mov al, 00h    
    mov bh, 0E1h  
    mov cx, 0000h  
    mov dx, 184Fh  
    int 10h
    mov ah, 02h
    mov bh, 0
    mov dx, 0000h
    int 10h

    PRINT_STR score_title
    

    PRINT_STR newline
    PRINT_STR p1_buf
    PRINT_STR score_x
    push p1_score
    call PrintNumber
    
 
    PRINT_STR newline
    PRINT_STR p2_buf
    PRINT_STR score_o
    push p2_score
    call PrintNumber
    
    PRINT_STR newline
    PRINT_STR prompt_menu
    READ_CHAR
    pop dx
    pop ax
    ret
DrawScoreScreen endp

PrintNumber proc
    push bp             
    mov bp, sp          
    sub sp, 2           
    
    push ax             
    push bx
    push cx
    push dx

    mov word ptr [bp-2], 10 
    mov ax, [bp+4]          
    
    mov dx, 0
    mov bx, [bp-2]          
    div bx                  
    
    push dx                 
    mov dl, al
    add dl, '0'
    mov ah, 02h
    int 21h     
    
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h     
    
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp              
    pop bp                  
    ret 2                   
PrintNumber endp

DrawBoard proc
    push ax
    push bx
    push cx
    push dx
    push si

    mov ah, 06h
    mov al, 00h
    mov bh, 0E1h   
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    mov ah, 02h
    mov bh, 0
    mov dx, 0000h
    int 10h

    PRINT_STR grid_ui

    mov dh, 2      
    mov si, 0      
    
    mov cx, 3      
Row_Loop:
    push cx        
    mov dl, 7      
    
    mov cx, 3      
Col_Loop:
    call PaintSingleCell
    add dl, 8      
    inc si         
    loop Col_Loop  

    pop cx         
    add dh, 3      
    loop Row_Loop  

    mov ah, 02h
    mov bh, 0
    mov dh, 11       
    mov dl, 0        
    int 10h

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
DrawBoard endp

PaintSingleCell proc
    push ax
    push bx
    push cx
    mov ah, 02h
    mov bh, 0
    int 10h
    mov al, board[si]
    
    mov bl, 0E1h     
    cmp al, 'X'
    jne chk_o
    mov bl, 0E1h     
    jmp do_print
chk_o:
    cmp al, 'O'
    jne do_print
    mov bl, 0E4h     
    
do_print:
    mov ah, 09h
    mov bh, 0
    mov cx, 1
    int 10h
    
    pop cx
    pop bx
    pop ax
    ret
PaintSingleCell endp

ResetBoard proc
    push cx
    push si
    mov cx, 9
    mov si, 0
    mov al, '1'
Reset_Loop:
    mov board[si], al
    inc al
    inc si
    loop Reset_Loop
    pop si
    pop cx
    ret
ResetBoard endp

end main

