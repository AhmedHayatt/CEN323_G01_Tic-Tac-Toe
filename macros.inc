 ;TIC-TAC-TAE
.model small

.data
board db '1','2','3','4','5','6','7','8','9' 

.code

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
    push bx
    push si
    
endm

IS_EMPTY Macro pos,is_valid
    
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
    
    mov is_valid.1
    jmp done
    
    not_free:
    mov is_valid,0
    
    done:
    pop si
    pop bx
    pop ax
    
endm
