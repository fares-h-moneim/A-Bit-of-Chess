.286
extrn startx:byte
extrn starty:byte
extrn Color:byte
extrn GridArray:byte
extrn GridArrayType:byte
extrn GridArraytime:byte
extrn teamwon:byte
extrn name1:byte
extrn name2:byte
extrn sizename1:byte
extrn sizename2:byte
extrn receiverchar:byte
extrn senderchar:byte
public WriteRecievedLetter
public WriteSentLetter
public clearstatusbar
public DrawRect
public DrawPieceXY
public DrawBoard
public ChangeBackGround
public intializeboard
public Drawtimeloop
public DrawDeadPiece
public GameEndAn
public animeEndx
public animeEndy
public AnimateMove
public ResetDraw

.model small
.data
    boardFilename     DB  'boards.bin', 0
    ;Rook Knight Bishop Queen King Bishop Knight Rook
    ;Pawn Pawn   Pawn   Pawn  Pawn Pawn   Pawn   Pawn
    bKnightFilename   DB  'bKnight.bin',0
    bRookFilename     DB  'bRook.bin',0
    bPawnFilename     DB  'bPawn.bin',0
    bBishopFilename   DB  'bBishop.bin',0
    bQueenFilename    DB  'bQueen.bin',0
    bKingFilename     DB  'bKing.bin',0

    wKnightFilename   DB  'wKnight.bin',0
    wRookFilename     DB  'wRook.bin',0
    wPawnFilename     DB  'wPawn.bin',0
    wBishopFilename   DB  'wBishop.bin',0
    wQueenFilename    DB  'wQueen.bin',0
    wKingFilename     DB  'wKing.bin',0
    threeFilename db '1.bin',0
    twoFilename db '2.bin',0
    oneFilename db '3.bin',0
    boardFilehandle   DW  ?
    WhiteFileHandles  DW  6 dup(?)
    BlackFileHandles  DW  6 dup(?)
    threeFileHandle dw ?
    twoFileHandle dw ?
    oneFileHandle dw ?
    receiverx db 0
    senderx db 0
    ;bl = 0 rook
    ;bl = 1 Knight
    ;bl = 2 Bishop
    ;bl = 3 Queen
    ;bl = 4 King
    ;bl = 5 Pawn
    boardWidth        EQU 320
    boardHeight       EQU 165
    boardData         DB  boardHeight*boardWidth dup(0)
    ;pieces data goes here/////////
    ;White//////////////////////
    wRookData         DB  20*20 dup(0)
    wKnightData       DB  20*20 dup(0)
    wBishopData       DB  20*20 dup(0)
    wQueenData        DB  20*20 dup(0)
    wKingData         DB  20*20 dup(0)
    wPawnData         DB  20*20 dup(0)
    ;Black/////////////////////
    bRookData         DB  20*20 dup(0)
    bKnightData       DB  20*20 dup(0)
    bBishopData       DB  20*20 dup(0)
    bQueenData        DB  20*20 dup(0)
    bKingData         DB  20*20 dup(0)
    bPawnData         DB  20*20 dup(0)
    threedata db 20*20 dup(0)
    twodata db 20*20 dup(0)
    onedata db 20*20 dup(0)
    ;animation vars
    AnimationReplaced db 20*20 dup(0)
    animey dw 0
    animex dw 0
    animeEndx db 0
    animeEndy db 0
    animeyl dw 0
    animexl dw 0
;end of anime vars
    deadlocyw db 0
    deadlocxw db 9
    deadlocyb db 0
    deadlocxb db 11
    Endx dw 0
    Endy dw 0
    GameWonw db 'White team won Press ESC return to menu$'
   GameWonb db 'Black team won Press ESC return to menu$'
   Gameexited db 'User Exited Press ESC return to menu$'
   loadedbefore db 0
   Receivedx db 0
   Sentx db 0
    bKnightWidth      EQU 20
    bKnightHeight     EQU 20
    centeringx        equ 20
    centeringy        equ 12
    centeringboardx   equ 0
    centeringboardy   equ 10
    colon db ": $"
   
    .code
    DrawRect PROC far
                          pusha
    ;Draws a rectangle at startx and starty
                          mov       ah,0
                          mov       al, startx
                          mov       cx, 20
                          mul       cx
                          add       ax, centeringx
                          mov       cx, ax
                          add       ax, 20
                          mov       Endx, AX
                          mov       ah,0
                          mov       al, starty
                          mov       dx, 20
                          mul       dx
                          add       ax, centeringy
                          mov       dx, ax
                          add       ax, 20
                          mov       Endy, ax
              
                          mov       al, startx
                          add       al, starty
                          mov       bl, 2
                          div       bl
                          cmp       ah, 0
                          jnz       brown
                          mov       al, 1eh
                          jmp       x
              
    brown:                mov       AL , 06h
              
    x:                    MOV       AH,0ch
	
    ; Drawing loop
    drawLoop1:            
                          INT       10h
                          INC       CX
    ;5lsna
                          CMP       CX,Endx
                          JNE       drawLoop1
    ;tani
                          mov       cx, Endx
                          sub       cx, 20
                          INC       DX

    ;5lsna elhamdllah
                          CMP       DX , Endy
                          JNE       drawLoop1
                          popa
                          ret
DrawRect ENDP

clearstatusbar PROC far
    pusha
mov ax,0200h
mov dx,0
int 10h
mov cx,40
mov ah,2 
mov dl,0
clearstatus:
int 21h
loop clearstatus
mov ah,2
mov dx,0
int 10h
popa
    ret
clearstatusbar ENDP
;announce the end
GameEndAn PROC far
    call clearstatusbar
    cmp teamwon,3
    jz GameAborted
    cmp teamwon,0
    jnz anBlack
mov ah,9
mov dx, offset GameWonw
int 21h
ret
anBlack:
mov ah,9
mov dx, offset GameWonb
int 21h
    ret
GameAborted:
mov ah,9
mov dx, offset Gameexited
int 21h
ret

GameEndAn ENDP

clearsenderbar PROC far
    pusha
mov ax,0200h
mov dh, 16h
mov dl, 0
mov bx, 0
int 10h
mov ch, 0
mov cl,40
mov ah,2 
mov dl,0
clearsender:
int 21h
loop clearsender
mov ah,2
                          mov dx,1600h ;25 y 0 x
                          mov bx, 0
                          int 10h

                          mov ah, 9
                          mov dx, offset name1
                          int 21h


                          mov ah,2
                          mov dx,1600h ;25 y 0 x
                          mov bx, 0
                          add dl, sizename1
                          int 10h
                          inc dl
                          mov senderx, dl

                          mov ah, 9
                          mov dx, offset colon
                          int 21h
popa
    ret
clearsenderbar ENDP

clearreceiverbar PROC far
    pusha
mov ax,0200h
mov dh, 17h
mov dl, 0
mov bx, 0
int 10h
mov ch, 0
mov cl,40
mov ah,2 
mov dl,0
clearreceiver:
int 21h
loop clearreceiver
 mov ah,2
                          mov dx,1700h ;25 y 0 x
                          mov bx, 0
                          int 10h

                          mov ah, 9
                          mov dx, offset name2
                          int 21h

                          mov ah,2
                          mov dx,1700h ;25 y 0 x
                          mov bx, 0
                          add dl, sizename2
                          int 10h
                           
                          inc dl 
                          mov receiverx, dl

                          mov ah, 9
                          mov dx, offset colon
                          int 21h
popa
    ret
clearreceiverbar ENDP

WriteRecievedLetter PROC far
    cmp receiverx, 40
    jnz receive
    call clearreceiverbar
receive:
    mov ah,2
    mov dh,17h ;25 y 0 x
    mov dl, receiverx
    mov bx, 0
    int 10h
    mov ah,2 
    mov dl,receiverchar
    int 21h 
    inc receiverx
    

    ret
WriteRecievedLetter ENDP
;description
WriteSentLetter PROC FAR
    cmp senderx, 40
    jnz write
    call clearsenderbar
write:    mov ah,2
    mov dh,16h ;25 y 0 x
    mov dl, senderx
    mov bx, 0
    int 10h
    mov ah,2 
    mov dl,senderchar
    int 21h 
    inc senderx
    ret
WriteSentLetter ENDP



DrawBoard PROC
                          MOV       CX,centeringboardx
                          MOV       DX,centeringboardy
                          MOV       AH,0ch
	
    ; Drawing loop
    drawLoop:             
                          MOV       AL,[BX]
                          cmp       Al, 00
                          mov       AL,1eh
                          jnz       jumplol
                          mov       al, 06h
    jumplol:              
                          INT       10h
                          INC       CX
                          INC       BX
                          CMP       CX,boardWidth + centeringboardx
                          JNE       drawLoop
	
                          MOV       CX , centeringboardx
                          INC       DX
                          CMP       DX , boardHeight+centeringboardy
                          JNE       drawLoop

                          mov       startx, 0
                          mov       starty, 0
    LoopRect:             cmp       startx, 8
                          jz        newRow
                          
                          call      DrawRect
                          inc       startx
                          jmp       LoopRect

    newRow:               mov       al, startx
                          add       al, starty
                          cmp       al, 15
                          jz        endooo
                          mov       al,0h
                          mov       startx, al
                          inc       starty
                          jmp       LoopRect

    endooo:               

                          ret
DrawBoard ENDP
OpenPiece MACRO FileName, color, piece
                          LEA       DX, FileName
                          mov       bh, color
                          mov       bl, piece
                          call      OpenFile
                          mov       bh, color
                          mov       bl, piece
                          call      ReadDataPieces
                   

ENDM
   
    ;Drawing the Boarder for the Cell
OpenFile PROC
                          pusha
    ; Open file

                          MOV       AH, 3Dh
                          MOV       AL, 0                          ; read only
                          INT       21h
    ;bh = 0 then its board
    ;bh = 1 then its white
    ;bh = 2 then its black
    ;bl = 0 rook
    ;bl = 1 Knight
    ;bl = 2 Bishop
    ;bl = 3 Queen
    ;bl = 4 King
    ;bl = 5 Pawn

                          cmp       bh,0
                          jnz       notboard
                          MOV       [boardFilehandle], AX
                          popa
                          RET
    notboard:             
                          cmp       bh,1
                          jnz       notwhite
                          mov       bh,0
                          push      ax
                          mov       al,2
                          mul       bl
                          mov       bl,al
                          pop       ax
                          mov       [WhiteFileHandles][bx],AX
                          popa
                          RET
    notwhite:             
                          mov       bh,0
                          push      ax
                          mov       al,2
                          mul       bl
                          mov       bl,al
                          pop       ax
                          mov       [BlackFileHandles][bx],AX
                          popa
                          ret

OpenFile ENDP

ReadData PROC 

                          MOV       AH,3Fh
                          MOV       BX, [boardFilehandle]
                          MOV       CX,boardWidth*boardHeight      ; number of bytes to read
                          LEA       DX, boardData
                          INT       21h
                          RET
ReadData ENDP


ReadDataPieces PROC 
                          pusha
    ;bh = 1 then its white
    ;bh = 2 then its black
    ;bl = 0 rook
    ;bl = 1 Knight
    ;bl = 2 Bishop
    ;bl = 3 Queen
    ;bl = 4 King
    ;bl = 5 Pawn
    ;----------------------------------
                          cmp       bh,1
                          jnz       notwhite1
                          mov       bh,0
                          mov       si, bx
                          mov       ax, 400
                          MUL       BX
                          push      ax
                          mov       ax,2
                          mul       si
                          mov       si,ax
                          MOV       BX, [WhiteFileHandles][si]
                          mov       cx, 400
                          mov       DX, offset wRookData
                          pop       ax
                          add       dx,ax
                          mov       ah, 3Fh
                          mov       al,0
                          int       21h
                          popa
                          ret

    notwhite1:            
                          mov       bh,0
                          mov       si, bx
                          mov       ax, 400
                          MUL       BX
                          push      ax
                          mov       ax,2
                          mul       si
                          mov       si,ax
                          MOV       BX, [BlackFileHandles][si]
                          mov       cx, 400
                          mov       DX, offset bRookData
                          pop       ax
                          add       dx,ax
                          mov       ah, 3Fh
                          mov       al,0
                          int       21h
                          popa
                          ret
ReadDataPieces ENDP
    ;a function that moves a piece from lockedxy coordinated to currentselected
    
;here are animating functions
DrawAnimatedPiece PROC                 
                          
;first we store the 20*20space to call later
                          mov       cx, animex
                          mov       dx, animey
                          mov bx,0
            DASloop:    push bx
                        mov ah,0dh
                        mov bh,0
                        int 10h
                        pop bx
                        mov AnimationReplaced[bx],al
                        INC       CX
                        INC       BX
                        mov ax,animex
                        add ax,20
                        CMP       CX, ax
                        JNE       DASloop
                        sub       cx,20
                        INC       DX
                        mov ax,animey
                        add ax,20
                        CMP       DX , ax
                        JNE       DASloop
           
                          pop       cx
                          pop       bx
                          push      cx
                          mov       cx, animex
                          mov       dx, animey
    ; Drawing loop
    DAPloop:              mov       AH, 0Ch
                          MOV       AL,[BX]
                          cmp       al,01h
                          jz        DAPink
                          INT       10h
    DAPink:               INC       CX
                          INC       BX
                          mov ax,animex
                          add ax,20
                          CMP       CX, ax
                          JNE       DAPloop
                          sub       cx,20
                          INC       DX
                          mov ax,animey
                          add ax,20
                          CMP       DX , ax
                          JNE       DAPloop
    ret
DrawAnimatedPiece ENDP
RevertAnimation PROC
                          mov       cx, animex
                          mov       dx, animey
                         mov bx,0
    DAPloop1:              mov       AH, 0Ch
                          MOV       AL,AnimationReplaced[bx]
                          cmp       al,01h
                          jz        DAPink1
                          INT       10h
    DAPink1:               INC       CX
                          INC       BX
                          mov ax,animex
                          add ax,20
                          CMP       CX, ax
                          JNE       DAPloop1
                          sub       cx,20
                          INC       DX
                          mov ax,animey
                          add ax,20
                          CMP       DX , ax
                          JNE       DAPloop1
    ret
RevertAnimation ENDP
;inputs are startx and starty which are the start position of the piece  and animeEndx animeEndy
AnimateMove PROC  far
                        ;calculating start coordinates
                          mov       ah,0
                          mov       al, startx
                          mov       cx, 20
                          mul       cx
                          add       ax, centeringx
                          mov       animex, ax
                          mov       ah,0
                          mov       al, starty
                          mov       dx, 20
                          mul       dx
                          add       ax, centeringy
                          mov       animey, ax 
                         ;calculating the end of animation
                          mov       ah,0
                          mov       al, animeEndx
                          mov       cx, 20
                          mul       cx
                          add       ax, centeringx
                          mov       animexl, ax
                          mov       ah,0
                          mov       al, animeEndy
                          mov       dx, 20
                          mul       dx
                          add       ax, centeringy
                          mov       animeyl, ax  
                          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                          mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bx
                          add       al,startx
                          mov       bx,ax
                          mov       cl,GridArray[bx]
                          mov       ch,GridArrayType[bx]
                          cmp       cl,1
                          jnz       lxy1
                          push      offset wRookData
                          cmp       ch,0
                          jz        lxy00
                          pop ax
                          push      offset bRookData      
    lxy00:               
                          jmp       lxy55
    lxy1:                cmp       cl,2
                          jnz       lxy2
                          push      offset wKnightData
                          cmp       ch,0
                          jz        lxy11   
                          pop ax   
                          push      offset bKnightData             
    lxy11:               
                          jmp       lxy55
    lxy2:                cmp       cl,3
                          jnz       lxy3
                          push      offset wBishopData
                          cmp       ch,0
                          jz        lxy22 
                          pop ax
                          push      offset bBishopData
    lxy22:               
                          jmp       lxy55
    lxy3:                cmp       cl,4
                          jnz       lxy4
                          push      offset wQueenData
                          cmp       ch,0
                          jz        lxy33
                          pop ax
                          push      offset bQueenData
    lxy33:               
                          jmp       lxy55
    lxy4:                cmp       cl,5
                          jnz       lxy5
                          push      offset wKingData
                          cmp       ch,0
                          jz        lxy44
                          pop ax
                          push      offset bKingData
    lxy44:              
                          jmp       lxy55
    lxy5:                cmp       cl,6
                          jnz       lxy55
                          push      offset wPawnData
                          cmp       ch,0
                          jz        lxy55
                          pop ax
                          push      offset bPawnData
    lxy55:
                          ;;;;;;;;;;;;;;;;;  
                          pop dx   
                                  
            ;if both are higher than the end then we stop using the cx as a flag
            Animationloop: mov cx,0
            mov bx,animexl
            cmp bx,animex
            jz Animenox
            cmp bx,animex
            ja animeincx
            dec animex
            jmp Animexend
    animeincx:inc animex
    Animexend:    mov cx,1
            Animenox:mov bx,animeyl
            cmp bx,animey
            jz Animenoy
            cmp bx,animey
            ja animeincy
            dec animey
            jmp Animeyend
    animeincy:    inc animey
    Animeyend:    mov cx,1
            Animenoy:
            pusha
            push dx
            call DrawAnimatedPiece
            call RevertAnimation
            popa  
            cmp cx,0           
            jnz Animationloop 

            ret
AnimateMove ENDP
;end of animating functions







DrawPiece PROC far
    ; BL contains index at the current drawn pixel
                          pop       ax
                          pop       cx
                          pop       bx
                          push      cx
                          push      ax
                          pusha
                          mov       ah,0
                          mov       al, startx
                          mov       cx, 20
                          mul       cx
                          add       ax, centeringx
                          mov       cx, ax

                          mov       ah,0
                          mov       al, starty
                          mov       dx, 20
                          mul       dx
                          add       ax, centeringy
                          mov       dx, ax
                          MOV       AH,0ch
	
    ; Drawing loop
    drawLoop10:           
                          mov       AH, 0Ch
                          MOV       AL,[BX]
                          cmp       al,01h
                          jz        pink
                          INT       10h
    pink:                 INC       CX
                          INC       BX
    ;tslee7
                          push      bx
                          mov       ah,0
                          mov       bl,0
                          mov       al, startx
                          mov       bl, 20
                          mul       bl
                          add       ax, 20
                          add       ax, centeringx
    ;end
                          pop       bx
                          CMP       CX, ax
                          JNE       drawLoop10
                          sub       cx,20
                          INC       DX
                          push      bx
                          mov       ah,0
                          mov       bl,0
                          mov       al, starty
                          mov       bl,20
                          mul       bl
                          add       ax,20
                          add       ax, centeringy
                          pop       bx
                          CMP       DX , ax
                          JNE       drawLoop10
                          popa
                          ret
DrawPiece ENDP

DrawPieceXY PROC far
                          pusha
                          mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bx
                          add       al,startx
                          mov       bx,ax
                          mov       cl,GridArray[bx]
                          mov       ch,GridArrayType[bx]
                          cmp       cl,1
                          jnz       dpxy1
                          push      offset wRookData
                          cmp       ch,0
                          jz        dpxy00
                          pop       ax
                          push      offset bRookData
    dpxy00:               call      DrawPiece
                          jmp       dpxyend
    dpxy1:                cmp       cl,2
                          jnz       dpxy2
                          push      offset wKnightData
                          cmp       ch,0
                          jz        dpxy11
                          pop       ax
                          push      offset bKnightData
    dpxy11:               call      DrawPiece
                          jmp       dpxyend
    dpxy2:                cmp       cl,3
                          jnz       dpxy3
                          push      offset wBishopData
                          cmp       ch,0
                          jz        dpxy22
                          pop       ax
                          push      offset bBishopData
    dpxy22:               call      DrawPiece
                          jmp       dpxyend
    dpxy3:                cmp       cl,4
                          jnz       dpxy4
                          push      offset wQueenData
                          cmp       ch,0
                          jz        dpxy33
                          pop       ax
                          push      offset bQueenData
    dpxy33:               call      DrawPiece
                          jmp       dpxyend
    dpxy4:                cmp       cl,5
                          jnz       dpxy5

                          push      offset wKingData
                          cmp       ch,0
                          jz        dpxy44
                          pop       ax
                          push      offset bKingData
    dpxy44:               call      DrawPiece
                          jmp       dpxyend
    dpxy5:                cmp       cl,6
                          jnz       dpxyend
                          push      offset wPawnData
                          cmp       ch,0
                          jz        dpxy55
                          pop       ax
                          push      offset bPawnData
    dpxy55:               call      DrawPiece
    dpxyend:              
                          popa
                          ret
DrawPieceXY ENDP
;description
;description
DrawDeadPiece PROC  far
    ; ch=team
    ;cl=piece
    cmp ch,8
    jnz ddp3
ret
    ddp3:cmp ch,0
    jnz ddp1  ;white
    mov al,deadlocxw
    mov startx,al
    mov al,deadlocyw
    mov starty,al
    inc deadlocyw
    cmp deadlocyw,8
    jnz ddp1
    inc deadlocxw
    mov deadlocyw,0
    ddp1:cmp ch,1   ;black
    jnz ddp2
    mov al,deadlocxb
    mov startx,al
    mov al,deadlocyb
    mov starty,al
    inc deadlocyb
    cmp deadlocyb,8
    jnz ddp2
    inc deadlocxb
    mov deadlocyb,0
    


    ddp2:
                          cmp       cl,1
                          jnz       dpxy16
                          push      offset wRookData
                          cmp       ch,0
                          jz        dpxy001
                          pop       ax
                          push      offset bRookData
    dpxy001:               call      DrawPiece
                          jmp       dpxyend1
    dpxy16:                cmp       cl,2
                          jnz       dpxy21
                          push      offset wKnightData
                          cmp       ch,0
                          jz        dpxy111
                          pop       ax
                          push      offset bKnightData
    dpxy111:               call      DrawPiece
                          jmp       dpxyend1
    dpxy21:                cmp       cl,3
                          jnz       dpxy31
                          push      offset wBishopData
                          cmp       ch,0
                          jz        dpxy221
                          pop       ax
                          push      offset bBishopData
    dpxy221:               call      DrawPiece
                          jmp       dpxyend1
    dpxy31:                cmp       cl,4
                          jnz       dpxy41
                          push      offset wQueenData
                          cmp       ch,0
                          jz        dpxy331
                          pop       ax
                          push      offset bQueenData
    dpxy331:               call      DrawPiece
                          jmp       dpxyend1
    dpxy41:                cmp       cl,5
                          jnz       dpxy51
                          push      offset wKingData
                          cmp       ch,0
                          jz        dpxy441
                          pop       ax
                          push      offset bKingData
    dpxy441:               call      DrawPiece
                          jmp       dpxyend1
    dpxy51:                cmp       cl,6
                          jnz       dpxyend1
                          push      offset wPawnData
                          cmp       ch,0
                          jz        dpxy551
                          pop       ax
                          push      offset bPawnData
    dpxy551:               call      DrawPiece
    dpxyend1:              

    ret
DrawDeadPiece ENDP


ChangeBackGround PROC far
                          pusha
                          mov       ah,0
                          mov       al, startx
                          mov       cx, 20
                          mul       cx
                          add       ax, centeringx
                          mov       cx, ax
                          mov       ah,0
                          mov       al, starty
                          mov       dx, 20
                          mul       dx
                          add       ax, centeringy
                          mov       dx, ax

              

    formodyloop:          
                          mov       bh, 00
                          mov       ah, 0dh
                          int       10h
    ;al has color

                          cmp       al, 1eh
                          jz        changecolor                    ;change if its not white
                          cmp       al, 06h
                          jz        changecolor                    ;change if its not brown
                          jmp       dontchangecolor

    changecolor:          
                          mov       al, Color
                          mov       ah, 0ch
                          int       10h
    ;----------------------------------
    dontchangecolor:      
                          mov       ah,0
                          mov       al, startx
                          mov       bl, 20
                          mul       bl
                          add       ax, centeringx
                          add       ax,20
                          mov       bx, ax

                          dec       bx
                          cmp       cx, bx
                          jz        increasedx
                          INC       CX
                          jmp       formodyloop

    increasedx:           
                          mov       ah,0
                          mov       al, startx
                          mov       cl, 20
                          mul       cl
                          add       ax, centeringx
                          mov       cx, ax
                          inc       dx
                          mov       ah,0
                          mov       al, starty
                          mov       bl, 20
                          mul       bl
                          add       ax, centeringy
                          add       ax,20
                          mov       bx, ax
                          cmp       dx, bx
                          jne       formodyloop
                          popa
                          ret

ChangeBackGround ENDP

;description
Drawtimeloop PROC far
    mov bx,0
    mov ax,0
dtloop1:mov dl,GridArraytime[bx]
        mov startx,al
        mov starty,ah 
        pusha
        call Drawtime
        popa
        inc al
        cmp al,8
        jnz dtloop2
        inc ah
        mov al,0
dtloop2:inc bx
        cmp bx,64
        jnz dtloop1
    ret
Drawtimeloop ENDP



Drawtime PROC   ;draws depending on the time its given

    cmp dl,3
    jnz dt1

push offset threedata
call DrawPiece

    ret
    dt1:cmp dl,2
    jnz dt2
    push offset twodata
call DrawPiece

    ret
    dt2:cmp dl,1
    jnz dt3
    push offset onedata
call DrawPiece

    dt3:
    ret
Drawtime ENDP


intializeboard PROC far
    ;mov ax,4f02h
    ;mov bx,101h
                        MOV       AH, 0
                         MOV       AL, 13h
                          INT       10h
                          mov   cx,0                       ;Column
                          mov   dx,10                      ;Row
                          mov   al,0fh                     ;Pixel color
                          mov   ah,0ch                     ;Draw Pixel Command
    back:                 int   10h
                          inc   cx
                          cmp   cx,180
                          jnz   back

    ;drawing the board
                          LEA       DX, boardFilename              ;This has
                          mov       bh,0
                          CALL      OpenFile
                          CALL      ReadData
                          LEA       BX , boardData
                          call      DrawBoard
                          mov       startx, 0
                          mov       starty, 0
                          
;oprning and reading timedrawings
cmp loadedbefore,0
jz dontload2
jmp dontload
dontload2:mov loadedbefore,1
   MOV AH, 3Dh
    MOV AL, 0 
    LEA DX, threeFilename
    INT 21h
    MOV [threeFileHandle], AX
    MOV AH,3Fh
    MOV BX, [threeFileHandle]
   MOV CX,400 
    LEA DX, threedata
    INT 21h  
    MOV AH, 3Eh
	MOV BX, [threeFilehandle]
	INT 21h
   MOV AH, 3Dh
    MOV AL, 0 
    LEA DX, twoFilename
    INT 21h
    MOV [twoFileHandle], AX
   MOV AH, 3Dh
   MOV AL, 0 
    LEA DX, oneFilename
   INT 21h
  MOV [oneFileHandle], AX
    MOV AH,3Fh
    MOV BX, [twoFilehandle]
    MOV CX,400 
    LEA DX, twodata
    INT 21h
    MOV AH,3Fh
   MOV BX, [oneFilehandle]
    MOV CX,400 
  LEA DX, onedata
   INT 21h


    ;opening&reading pieces data
                          OpenPiece bRookFilename,  2, 0
                          OpenPiece bKnightFilename, 2, 1
                          OpenPiece bBishopFilename, 2, 2
                          OpenPiece bQueenFilename, 2, 3
                          OpenPiece bKingFilename, 2, 4
                          OpenPiece bPawnFilename, 2, 5
                          OpenPiece wBishopFilename, 1, 2
                          OpenPiece wPawnFilename, 1, 5
                          OpenPiece wRookFilename, 1, 0
                          OpenPiece wKnightFilename, 1, 1
                          OpenPiece wQueenFilename, 1, 3
                          OpenPiece wKingFilename, 1, 4
    ;drawing blackpieces at their start position
    ;DRAWPIECE MOVE STARTX, MOV STARTY, MOV DATA TO BX 
           dontload:               Mov       startx, 0
                          Mov       Starty, 0
                          push      offset bRookData
                          Call      DrawPiece
                       
                          Mov       startx, 1
                          Mov       Starty, 0
                          push      offset bKnightData
                          Call      DrawPiece

                          Mov       startx, 2
                          Mov       Starty, 0
                          push      offset bBishopData
                          Call      DrawPiece

                          Mov       startx, 3
                          Mov       Starty, 0
                          push      offset bQueenData
                          Call      DrawPiece

                          Mov       startx, 4
                          Mov       Starty, 0
                          push      offset bKingData
                          Call      DrawPiece

                          Mov       startx, 5
                          Mov       Starty, 0
                          push      offset bBishopData
                          Call      DrawPiece

                          Mov       startx, 6
                          Mov       Starty, 0
                          push      offset bKnightData
                          Call      DrawPiece

                          Mov       startx, 7
                          Mov       Starty, 0
                          push      offset bRookData
                          Call      DrawPiece

                          Mov       startx, 0
                          Mov       Starty, 1
                          push      offset bPawnData
                          Call      DrawPiece

                          Mov       startx, 1
                          Mov       Starty, 1
                          push      offset bPawnData
                          Call      DrawPiece

                          Mov       startx, 2
                          Mov       Starty, 1
                          push      offset bPawnData
                          Call      DrawPiece

                          Mov       startx, 3
                          Mov       Starty, 1
                          push      offset bPawnData
                          Call      DrawPiece

                          Mov       startx, 4
                          Mov       Starty, 1
                          push      offset bPawnData
                          Call      DrawPiece

                          Mov       startx, 5
                          Mov       Starty, 1
                          push      offset bPawnData
                          Call      DrawPiece

                          Mov       startx, 6
                          Mov       Starty, 1
                          push      offset bPawnData
                          Call      DrawPiece

                          Mov       startx, 7
                          Mov       Starty, 1
                          push      offset bPawnData
                          Call      DrawPiece

                          Mov       startx, 0
                          Mov       Starty, 7
                          push      offset wRookData
                          Call      DrawPiece

                          Mov       startx, 1
                          Mov       Starty, 7
                          push      offset wKnightData
                          Call      DrawPiece

                          Mov       startx, 2
                          Mov       Starty, 7
                          push      offset wBishopData
                          Call      DrawPiece

                          Mov       startx, 3
                          Mov       Starty, 7
                          push      offset wQueenData
                          Call      DrawPiece

                          Mov       startx, 4
                          Mov       Starty, 7
                          push      offset wKingData
                          Call      DrawPiece

                          Mov       startx, 5
                          Mov       Starty, 7
                          push      offset wBishopData
                          Call      DrawPiece

                          Mov       startx, 6
                          Mov       Starty, 7
                          push      offset wKnightData
                          Call      DrawPiece

                          Mov       startx, 7
                          Mov       Starty, 7
                          push      offset wRookData
                          Call      DrawPiece

                          Mov       startx, 0
                          Mov       Starty, 6
                          push      offset wPawnData
                          Call      DrawPiece

                          Mov       startx, 1
                          Mov       Starty, 6
                          push      offset wPawnData
                          Call      DrawPiece

                          Mov       startx, 2
                          Mov       Starty, 6
                          push      offset wPawnData
                          Call      DrawPiece

                          Mov       startx, 3
                          Mov       Starty, 6
                          push      offset wPawnData
                          Call      DrawPiece

                          Mov       startx, 4
                          Mov       Starty, 6
                          push      offset wPawnData
                          Call      DrawPiece

                          Mov       startx, 5
                          Mov       Starty, 6
                          push      offset wPawnData
                          Call      DrawPiece

                          Mov       startx, 6
                          Mov       Starty, 6
                          push      offset wPawnData
                          Call      DrawPiece

                          Mov       startx, 7
                          Mov       Starty, 6
                          push      offset wPawnData
                          Call      DrawPiece

                          ;moving cursor to write name for inline
                          mov ah,2
                          mov dx,1600h ;25 y 0 x
                          mov bx, 0
                          int 10h

                          mov ah, 9
                          mov dx, offset name1
                          int 21h


                          mov ah,2
                          mov dx,1600h ;25 y 0 x
                          mov bx, 0
                          add dl, sizename1
                          int 10h
                          inc dl
                          mov senderx, dl

                          mov ah, 9
                          mov dx, offset colon
                          int 21h

                          mov ah,2
                          mov dx,1700h ;25 y 0 x
                          mov bx, 0
                          int 10h

                          mov ah, 9
                          mov dx, offset name2
                          int 21h

                          mov ah,2
                          mov dx,1700h ;25 y 0 x
                          mov bx, 0
                          add dl, sizename2
                          int 10h
                           
                          inc dl 
                          mov receiverx, dl

                          mov ah, 9
                          mov dx, offset colon
                          int 21h

                          
    ret
intializeboard ENDP
;description
ResetDraw PROC far
   mov deadlocyw,0
   mov deadlocxw,9
   mov deadlocyb,0
   mov deadlocxb,11
    ret
ResetDraw ENDP
end