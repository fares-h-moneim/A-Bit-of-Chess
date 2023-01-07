.286
extrn senderchar:byte
extrn receiverchar:byte
extrn name1:byte
extrn name2:byte
extrn sizename1:byte
extrn sizename2:byte
public chating
.model small
.data

    sendercursorx   db 0
    sendercursory   db 1
    receivercursorx db 0
    receivercursory db 14
    colon db ": $", 0
.code
scrolling MACRO start, end
                   pusha
                   mov       ax, 0601h
                   mov       bh, 7
                   mov       cx, start
                   mov       dx, end                ; return cursor to sender screen
                   int       10h
                   popa
ENDM      scrolling


chating PROC FAR
                          mov       ax,0003h
                          int       10h

                          mov receivercursorx, 0
                          mov receivercursory, 14
                          mov sendercursorx, 0
                            mov sendercursory, 1

                          mov ah,2
                          mov dx,0h 
                          mov bx, 0
                          int 10h

                          mov ah, 9
                          mov dx, offset name1
                          int 21h


                          mov ah,2
                          mov dx,0h 
                          mov bx, 0
                          add dl, sizename1
                          int 10h
                          inc dl

                          mov ah, 9
                          mov dx, offset colon
                          int 21h

                          mov ah,2
                          mov dx,0D00h 
                          mov bx, 0
                          int 10h

                          mov ah, 9
                          mov dx, offset name2
                          int 21h

                          mov ah,2
                          mov dx,0D00h
                          mov bx, 0
                          add dl, sizename2
                          int 10h
                           
                          inc dl 

                          mov ah, 9
                          mov dx, offset colon
                          int 21h

                   mov       dl, 0
                   mov       dh, 12
                   mov       bx, 0

    drawLine:      cmp       dl, 80
                   jz        endline
                   mov       ah, 2
                   int       10h
                   mov       ah,2
                   push      dx
                   mov       dl, 196
                   int       21h
                   pop       dx
                   inc       dl
                   loop      drawLine
                   mov       ax,0003h
                   int       10h
    endline:       
                   mov       dl, 0
                   mov       dh, 1
                   mov       ah, 2
                   int       10h

    Prog:          cmp       sendercursory, 12
                   jnz       scrool
                   scrolling 0100h, 0B50h
                   mov       sendercursory,0Bh
                   mov       sendercursorx, 0
                   mov       dl, sendercursorx
                   mov       dh, sendercursory
                   mov       ah, 2
                   int       10h

    scrool:        
                   cmp       receivercursory, 25
                   jnz       scroll2
                   scrolling 0E00h, 1950h           ;start x=1, start y=1, end x=79, end y=24
                   mov       receivercursory,24
                   mov       receivercursorx, 0
                   mov       dl, receivercursorx
                   mov       dh, receivercursory
                   mov       ah, 2
                   int       10h

    scroll2:                                        ;Check that Data Ready
                   mov       dx , 3FDH              ; Line Status Register
                   in        al , dx
                   AND       al , 1
                   JZ        CHK

    ;If Ready read the VALUE in Receive data register
                   mov       dx , 03F8H
                   in        al , dx
                   mov       receiverchar , al
                   cmp       receiverchar, 27
                   jnz       lbl
                   jmp       endddd
    lbl:           cmp       receiverchar, 10d
                   jnz       cont2
                   cmp       receivercursorx, 79
                   jz        esmlabelgdeed
                   jnz       labeltalet
    esmlabelgdeed: cmp       receivercursory, 24
                   jz        labeltany
                   jnz       labeltalet
    labeltany:     jmp       labeltalet
    labeltalet:    mov       receivercursorx, 0
                   inc       receivercursory
                   jmp       Prog

    cont2:         mov       receiverchar, al
    ; return cursor to sender screen
                   mov       dl, receivercursorx
                   mov       dh, receivercursory
                   mov       ah, 2
                   int       10h
                   inc       receivercursorx
                   cmp       receivercursorx, 79
                   jnz       newLine
                   mov       receivercursorx, 0
                   inc       receivercursory
    newline:       
                   mov       ah,2
                   mov       dl,receiverchar
                   int       21h

    CHK:           mov       ah,1
                   int       16h
                   jnz       prg
                   jmp       Prog
    prg:           
                   mov       ah, 0
                   int       16h
                   cmp       al, 0DH
                   jnz       cont
                   mov       sendercursorx, 0
                   inc       sendercursory

                   mov       dl, 0
                   mov       dh, sendercursory
                   mov       ah, 2
                   int       10h
                   mov       dx, 3FDH
                   mov       senderchar, 10d
                   jmp       AGAIN

                   cmp       senderchar, 27
                   jnz       lbl2
                   jmp       endddd
    lbl2:          cmp       senderchar, 10d
                   jnz       cont
                   cmp       sendercursorx, 79
                   jz        esmlabelgdeed2
                   jnz       labeltalet2
    esmlabelgdeed2:cmp       sendercursory, 11
                   jz        labeltany2
                   jnz       labeltalet2
    labeltany2:    jmp       labeltalet2
    labeltalet2:   mov       sendercursorx, 0
                   inc       sendercursory
                   jmp       Prog

    cont:          mov       senderchar, al
    ; return cursor to sender screen
                   mov       dl, sendercursorx
                   mov       dh, sendercursory
                   mov       ah, 2
                   int       10h
                   inc       sendercursorx
                   cmp       sendercursorx, 79
                   jnz       newLine2
                   mov       sendercursorx, 0
                   inc       sendercursory
    ;inc       sendercursory
    newline2:      
                   mov       ah,2
                   mov       dl,senderchar
                   int       21h

    ;Check that Transmitter Holding Register is Empty
                   mov       dx , 3FDH              ; Line Status Register
    AGAIN:         
                   In        al , dx                ;Read Line Status
                   AND       al , 00100000b
                   JZ        AGAIN
                   cmp       senderchar, 27
                   jz        endddd
    ;If empty put the VALUE in Transmit data register
                   mov       dx , 3F8H              ; Transmit data register
                   mov       al,senderchar
                   out       dx , al
                   jmp       Prog



    endddd:        
                   ret


chating ENDP
END 