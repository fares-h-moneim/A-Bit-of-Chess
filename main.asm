extrn DrawRect:far
extrn DrawPieceXY:far
extrn ChangeBackGround:far
extrn intializeboard:far
extrn getlegalmoves:far
extrn Menu:far
extrn Menu2:far
extrn Reset:far
extrn AnimateMove:far
extrn ResetDraw:far
extrn animeEndx:byte
extrn animeEndy:byte
extrn playgame:byte
extrn exitprog:byte
extrn squaredguarded:byte
extrn squaredguarded:byte
extrn startchat:byte
extrn checkking:far
extrn Drawtimeloop:far
extrn DrawDeadPiece:far
extrn WriteRecievedLetter:far
extrn WriteSentLetter:far
extrn GameEndAn:far
extrn chating:far
public GridArray
public GridArrayType
public GridArraytime
public startx
public starty
public Color
public currentselectedx
public currentselectedx1
public currentselectedy
public currentselectedy1
public lockedx
public lockedx1
public lockedy
public lockedy1
public legalmovesx
public legalmovesy
public teamplaying
public teamwon
public kingx
public kingy
public receiverchar
public senderchar
public teamplayingbuffer
.286
.Model small
.Stack 512
.Data
    ;////////////////////////////////
    ;now an array that has each piece location x,y and black and white
    
    ;here we are rook1 knight2 bish3 queen4 king5 pawn6
    GridArray         db 1,2,3,4,5,3,2,1,6,6,6,6,6,6,6,6
                      db 32 dup(0)
                      db 6,6,6,6,6,6,6,6,1,2,3,4,5,3,2,1
    GridArrayType     db 16 dup(1)
                      db 32 dup(8)
                      db 16 dup(0)
    GridArraytime     db 64 dup(0)
    lasttime          db 0
    lastimem          db 0
    ; user input "the moving greenish rect"
    currentselectedx  db 0
    currentselectedx1 db 0
    currentselectedy  db 0
    currentselectedy1 db 0
    gamend            db 0
    teamwon           db 0
    ; the locked in one
    lockedx           db ?
    lockedx1          db ?
    lockedy           db ?
    lockedy1          db ?
    alreadychoose     db 0
    alreadychoose1    db 0
    startx            db ?
    starty            db ?
    legalmovesx       db 60 dup(8)
    legalmovesy       db 60 dup(8)
    teamplaying       db 0
    Color             db 0
    kingx             db 4,4
    kingy             db 7,0
    receiverchar      db 0
    senderchar        db 0
    teamplayingbuffer db 0
    ismymove          db 0
    letterRecieved    db 0
    ;this variable is for the queen moves to make it more efficent
    

.Code
   





    ;sends the data in senderchar
SendData PROC
                          mov   dx , 3FDH                     ; Line Status Register
    AGAIN:                
                          In    al , dx                       ;Read Line Status
                          AND   al , 00100000b
                          JZ    AGAIN
                          mov   dx , 3F8H
                          mov   al,senderchar
                          out   dx , al
                          cmp   senderchar,8
                          jz    handshake
                          mov   receiverchar,9
    waitingforconfirm:    
                          call  ReceiveData
                          cmp   receiverchar,8
                          jnz   waitingforconfirm
                        
    handshake:            


                          ret
SendData ENDP

    ;recieves the data in receiverchar
ReceiveData PROC
                          mov   dx , 3FDH                     ; Line Status Register
                          in    al , dx
                          AND   al , 1
                          JZ    RDE

    ;If Ready read the VALUE in Receive data register
                          mov   dx , 03F8H
                          in    al , dx
                          mov   receiverchar , al
                          cmp   receiverchar,8
                          jz    RDE
                          mov   senderchar,8
                          call  SendData
    RDE:                  

                          ret
ReceiveData ENDP
    ;if al = 0 then nothing to recieve


    
unMarkLegalmoves PROC

                          mov   al,teamplaying
                          mov   ah,0
                          mov   si,ax
                          mov   bx,0
                          cmp   teamplaying,0
                          jz    unmarklegalisw
                          mov   bx,30
    unmarklegalisw:       

                          cmp   alreadychoose[si],1
                          jnz   umlm1
                          ret

    umlm1:                cmp   legalmovesx[bx],8
                          jnz   umlm4
                          ret
    umlm4:                push  bx
                          mov   al,legalmovesx[bx]
                          mov   ah,legalmovesy[bx]
                          mov   startx,al
                          mov   starty,ah
                          call  DrawRect
                          call  DrawPieceXY
                          pop   bx
                          inc   bx
                          cmp   legalmovesx[bx],8
                          jnz   umlm1
                          ret
unMarkLegalmoves ENDP
    ;Receives a move will probably need to check before


MovePiece PROC
    ;will compare here the piece with its place in the time array thus if its 0 then can move else wont
                          mov   al,teamplaying
                          mov   ah,0
                          mov   si,ax
    ; checking if the piece timer is free
                          mov   ah,0
                          mov   al,lockedy[si]
                          mov   bx,8
                          mul   bx
                          cmp   ismymove,1
                          jz    movepieceislegalyes
                          add   al,lockedx[si]
                          mov   bx,ax
                          cmp   GridArraytime[bx],0
                          jz    mptimercheck
                          ret
    mptimercheck:         
                          mov   bx,0
                          cmp   teamplaying,0
                          jz    movepieceisw
                          mov   bx,30
    movepieceisw:         mov   al,currentselectedx[si]
                          mov   ah,currentselectedy[si]
    movepieceislegal:                                         ;checking is the move is legal if no such move then it isnt "array ends with 8"
                          cmp   legalmovesx[bx],8
                          jnz   movepieceislegalmaybe
                
                          ret
    movepieceislegalmaybe:cmp   legalmovesx[bx],al
                          jnz   movepieceisnotlegal
                          cmp   legalmovesy[bx],ah
                          jnz   movepieceisnotlegal
                          jmp   movepieceislegalyes
    movepieceisnotlegal:  inc   bx
                          jmp   movepieceislegal

    movepieceislegalyes:                                      ;animation
                          pusha
                          mov   al,lockedx[si]
                          mov   startx,al
                          mov   al,lockedy[si]
                          mov   starty,al
                          mov   al,currentselectedx[si]
                          mov   animeEndx,al
                          mov   al,currentselectedy[si]
                          mov   animeEndy,al
                          call  AnimateMove
                          popa
    ;animation end
    ;SendMove Start
                          cmp   ismymove,1
                          jz    notmymove
                          pusha
                          mov   al,lockedx[si]
                          mov   senderchar,al
                          call  SendData
                          popa
                          pusha
                          mov   al,lockedy[si]
                          mov   senderchar,al
                          call  SendData
                          popa
                          pusha
                          mov   al,currentselectedx[si]
                          mov   senderchar,al
                          call  SendData
                          popa
                          pusha
                          mov   al,currentselectedy[si]
                          mov   senderchar,al
                          call  SendData
                          popa
    notmymove:            
    ;SendMove End
                          mov   ah,0
                          mov   al,lockedy[si]
                          mov   bx,8
                          mul   bx
                          add   al,lockedx[si]
                          mov   bx,ax
                          mov   cl,GridArray[bx]
                          mov   GridArray[bx],0
                          mov   GridArrayType[bx],8
                          
    ;if the eaten piece was a king
                          mov   al,currentselectedy[si]
                          mov   bx,8
                          mul   bx
                          add   al,currentselectedx[si]
                          mov   bx,ax
                          push  cx
    ;drawing the deadpiece on the side
                          mov   cl,GridArray[bx]
                          mov   ch,GridArrayType[bx]
                          pusha
                          call  DrawDeadPiece
                          popa
    ;if the eaten piece was a king
                          cmp   cl,5
                          jnz   mpnotking
                          mov   gamend,1
                          mov   al,teamplaying
                          mov   teamwon,al
                         
    mpnotking:            
                          pop   cx
                          cmp   cl,6
                          jnz   movepiecenotpawn

    ;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;checking if a pawn reach the end of the board
                          cmp   currentselectedy[si],7
                          jnz   movepiecemaybenormal
                          mov   cl,4
    movepiecemaybenormal: cmp   currentselectedy[si],0
                          jnz   movepiecenotpawn
                          mov   cl,4
    ;the pawn queen check ends
    movepiecenotpawn:                                         ;the pawn queen check ends
    ;checking if the king is moving to update its position
                          cmp   cl,5
                          jnz   movepiecenotking
                          mov   dl,currentselectedx[si]
                          mov   kingx[si],dl
                          mov   dl,currentselectedy[si]
                          mov   kingy[si],dl
    movepiecenotking:     
    ;;;;
                          mov   GridArray[bx],cl
                          mov   al,teamplaying
                          mov   GridArrayType[bx],al
                          push  bx
                          call  checkking
                          pop   bx
                          mov   GridArray[bx],cl
                          mov   al,teamplaying
                          mov   GridArrayType[bx],al
                          mov   GridArraytime[bx],3           ;setting a 3 second timer    ;3 may be changed if the bonus is implemented
                          
                          mov   al,lockedx[si]
                          mov   ah,lockedy[si]
                          mov   startx,al
                          mov   starty,ah
                          call  DrawRect
                          mov   al,currentselectedx[si]
                          mov   ah,currentselectedy[si]
                          mov   startx,al
                          mov   starty,ah
                          Call  DrawRect
                          mov   al,currentselectedx[si]
                          mov   ah,currentselectedy[si]
                          mov   startx,al
                          mov   starty,ah
                          call  DrawPieceXY
                          ret
MovePiece ENDP


    ;description
RecieveNonMove PROC
                          cmp   letterRecieved,1
                          jz    Rnmcontinue
                          ret
    Rnmcontinue:          mov   letterRecieved,0
                          cmp   receiverchar,27
                          jnz   notgameend
                          mov   gamend,1
                          mov   teamwon,3
                          ret
    
    notgameend:           call  WriteRecievedLetter


                          ret
RecieveNonMove ENDP



    ;description
TimeControl PROC
    ;to check if it has been a second from last decrement
                          mov   ah,2ch
                          int   21h
                          cmp   dh,lasttime
                          ja    samemin                       ;if a minute passed we add 60 to the seconds
                          add   dh,60
    samemin:              
                          sub   dh,lasttime
                          cmp   dh,1
                          jz    tnend
                          jmp   tend
    tnend:                cmp   dl,lastimem
                          ja    sames
                          add   dl,100
    sames:                
                          sub   dl,lastimem
                          cmp   dl,40
                          ja    tend

                          mov   bx,0
                       
    tc:                   cmp   GridArraytime[bx],0
                          jz    tcend
                          dec   GridArraytime[bx]
                          cmp   GridArraytime[bx],0
                          jnz   tcend
                          pusha
                          mov   cl,8
                          mov   ax,bx
                          div   cl
                          mov   startx,ah
                          mov   starty,al
                          call  DrawRect
                          call  DrawPieceXY
    tcnotwhite:           popa
   
                          
    ;draw the new time if any
    tcend:                inc   bx
                          cmp   bx,64
                          jnz   tc

    ;this is the last time of decrement
                          int   21h
                          mov   lasttime,dh
                          call  MarkLegalmoves
                          mov   al,teamplaying
                          mov   ah,0
                          mov   bp,ax
                          mov   ah,ds:currentselectedx[bp]
                          mov   al,ds:currentselectedy[bp]
                          mov   startx,ah
                          mov   starty,al
                          mov   Color,0eh
                          cmp   teamplaying,1
                          jnz   colorisco
                          mov   Color,09h
    colorisco:            
                          call  ChangeBackGround
    tend:                 
                          ret
TimeControl ENDP
MarkLegalmoves PROC

                          
                         
    mlm0:                 mov   al,teamplaying
                          mov   ah,0
                          mov   si,ax
                          cmp   alreadychoose[si],0
                          jnz   mlmm
                          ret
    mlmm:                 mov   bx,0
                          cmp   teamplaying,0
                          jz    marklegalisw
                          mov   bx,30
    marklegalisw:         
    mlm3:                 cmp   legalmovesx[bx],8
                          jnz   mlm4
                          ret
    mlm4:                 
    
                          mov   al,currentselectedx[si]
                          mov   ah,currentselectedy[si]
                          cmp   ah,legalmovesy[bx]
                          jnz   mlmc
                          cmp   al,legalmovesx[bx]
                          jz    mlm2
    mlmc:                 mov   al,legalmovesy[bx]
                          mov   cl,8
                          mul   cl
                          add   al,legalmovesx[bx]
                          mov   ah,0
                          mov   bp,ax
                          cmp   ds:GridArray[bp],0
                          jnz   mlm1
    ;if no enemy color green
                          mov   al,legalmovesx[bx]
                          mov   startx,al
                          mov   al,legalmovesy[bx]
                          mov   starty,al
                          mov   Color,0Ah
                          call  ChangeBackGround
                          jmp   mlm2

    ;red color here
    mlm1:                 mov   al,legalmovesx[bx]
                          mov   startx,al
                          mov   al,legalmovesy[bx]
                          mov   starty,al
                          mov   Color,0Ch
                          call  ChangeBackGround              ;color red
    

    mlm2:                 inc   bx
                          cmp   legalmovesx[bx],8
                          jnz   mlm3


                          ret
MarkLegalmoves ENDP
    ;hena procedures////////////////////////////
ReceiveMove PROC
                          cmp   teamplaying,0
                          jz    rmw
                          mov   si,0
                          jmp   rmset
    rmw:                  
                          mov   si,1
    rmset:                
                          pusha
                          call  ReceiveData
                          cmp   al,0
                          jnz   ryes
                          popa
                          ret
                          

    ryes:                 cmp   receiverchar,15
                          jb    rnletter
                          mov   letterRecieved,1
                          popa
                          ret


    rnletter:             mov   al,receiverchar
                          mov   lockedx[si],al
                          popa
                          pusha
    ryes2:                mov   al,1
                          call  ReceiveData
                          cmp   al,0
                          jz    ryes2
                          mov   al,receiverchar
                          mov   lockedy[si],al
                          popa
                          pusha
    ryes3:                mov   al,1
                          call  ReceiveData
                          cmp   al,0
                          jz    ryes3
                          mov   al,receiverchar
                          mov   currentselectedx[si],al
                          popa
                          pusha
    ryes4:                mov   al,1
                          call  ReceiveData
                          cmp   al,0
                          jz    ryes4
                          mov   al,receiverchar
                          mov   currentselectedy[si],al
                          popa
                          
                          mov   ax,si
                          mov   teamplaying,al
                          mov   ismymove,1
                          call  MovePiece
                          mov   ismymove,0
                          mov   al,teamplayingbuffer
                          mov   teamplaying,al
                          mov   ah,0
                          mov   si,ax
                          cmp   alreadychoose[si],0
                          jz    rmend
                          mov   ah,0
                          mov   al,lockedy[si]
                          mov   bx,8
                          mul   bx
                          add   al,lockedx[si]
                          mov   bx,ax
                          mov   al,teamplaying
                          cmp   GridArrayType[bx],al
                          jz    piecewasnteaten
                          mov   alreadychoose[si],0
                          call  unMarkLegalmoves
                          jmp   rmend
    piecewasnteaten:      
                          mov   alreadychoose[si],0
                          call  unMarkLegalmoves
                          mov   alreadychoose[si],1
                          call  getlegalmoves
                          call  MarkLegalmoves
    rmend:                mov   al,currentselectedx[si]
                          mov   ah,currentselectedy[si]
                          mov   startx,al
                          mov   starty,ah
                          Call  DrawRect
                          call  DrawPieceXY
                          mov   Color,0eh
                          cmp   teamplaying,1
                          jnz   colorisco2
                          mov   Color,09h
    colorisco2:           call  ChangeBackGround
                          ret
ReceiveMove ENDP
    ;moving the user rectangle
Userinput PROC
                          cmp   ah,48h
                          jnz   notw
                          cmp   currentselectedy,0
                          jz    notw
                          mov   bl, currentselectedx
                          mov   startx, bl
                          mov   bl, currentselectedy
                          mov   starty, bl
                          call  DrawRect
                          call  DrawPieceXY
                          sub   currentselectedy,1
                          jmp   movedthecurser
    notw:                 cmp   ah,50h
                          jnz   nots
                          cmp   currentselectedy,7
                          jz    nots
                          mov   bl, currentselectedx
                          mov   startx, bl
                          mov   bl, currentselectedy
                          mov   starty, bl
                          call  DrawRect
                          call  DrawPieceXY
                          add   currentselectedy,1
                          jmp   movedthecurser
    nots:                 cmp   ah,4dh
                          jnz   notd
                          cmp   currentselectedx,7
                          jz    notd
                          mov   bl, currentselectedx
                          mov   startx, bl
                          mov   bl, currentselectedy
                          mov   starty, bl
                          call  DrawRect
                          call  DrawPieceXY
                          add   currentselectedx,1
                          jmp   movedthecurser
    notd:                 cmp   ah,4bh
                          jnz   nota
                          cmp   currentselectedx,0
                          jz    nota
                          mov   bl, currentselectedx
                          mov   startx, bl
                          mov   bl, currentselectedy
                          mov   starty, bl
                          call  DrawRect
                          call  DrawPieceXY
                          sub   currentselectedx,1
                          jmp   movedthecurser
    nota:                 cmp   al,13                         ;u should check it not being equal to currently to try a move
                          jz    userinputjmp
                          jmp   notaninput
    userinputjmp:         cmp   alreadychoose,0
                          jnz   uimovepiece
                          mov   ah,0
                          mov   al,currentselectedy
                          mov   bx,8
                          mul   bx
                          add   al,currentselectedx
                          mov   bx,ax
                          mov   cl,GridArrayType[bx]
                          cmp   cl,0
                          jz    notaninputout
                          jmp   notaninput
    notaninputout:        mov   ah,currentselectedx
                          mov   alreadychoose, 1
                          mov   lockedx,ah
                          mov   ah,currentselectedy
                          mov   lockedy,ah
                          call  getlegalmoves
                          cmp   legalmovesx[0],8
                          jnz   notaninput
                          mov   alreadychoose,0
                          jmp   notaninput
    uimovepiece:          mov   bl, lockedx
                          mov   startx, bl
                          mov   bh, lockedy
                          mov   starty, bh
                          call  DrawRect
                          call  DrawPieceXY
                          call  MovePiece
                          mov   alreadychoose,0
                          call  unMarkLegalmoves
    ;hena yogad move piece things

              
    movedthecurser:       mov   al,currentselectedx
                          mov   startx,al
                          mov   al,currentselectedy
                          mov   starty,al
                          mov   Color,0Eh
                          call  DrawRect
                          call  DrawPieceXY
                          call  ChangeBackGround
    notaninput:           ret
Userinput ENDP
    ;description
Userinput1 PROC
                          cmp   ah,48h
                          jnz   notup
                          cmp   currentselectedy1,0
                          jz    notup
                    
                          mov   bl, currentselectedx1
                          mov   startx, bl
                          mov   bl, currentselectedy1
                          mov   starty, bl
                          call  DrawRect
                          call  DrawPieceXY
                          sub   currentselectedy1,1
                          jmp   movedthecurser1
    notup:                cmp   ah,50h
                          jnz   notdown
                          cmp   currentselectedy1,7
                          jz    notdown
                         
                          mov   bl, currentselectedx1
                          mov   startx, bl
                          mov   bl, currentselectedy1
                          mov   starty, bl
                          call  DrawRect
                          call  DrawPieceXY
                          add   currentselectedy1,1
                          jmp   movedthecurser1
    notdown:              cmp   ah,4dh
                          jnz   notright
                          cmp   currentselectedx1,7
                          jz    notright
                    
                          mov   bl, currentselectedx1
                          mov   startx, bl
                          mov   bl, currentselectedy1
                          mov   starty, bl
                          call  DrawRect
                          call  DrawPieceXY
                          add   currentselectedx1,1
                          jmp   movedthecurser1
    notright:             cmp   ah,4bh
                          jnz   notleft
                          cmp   currentselectedx1,0
                          jz    notleft
                   
                          mov   bl, currentselectedx1
                          mov   startx, bl
                          mov   bl, currentselectedy1
                          mov   starty, bl
                          call  DrawRect
                          call  DrawPieceXY
                          sub   currentselectedx1,1
                          jmp   movedthecurser1
    notleft:              cmp   al,13                         ;u should check it not being equal to currently to try a move
                          jz    user2jmp
                          jmp   notaninput1
    user2jmp:             cmp   alreadychoose1,0
                          jnz   uimovepiece1
                     
                          mov   ah,0
                          mov   al,currentselectedy1
                          mov   bx,8
                          mul   bx
                          add   al,currentselectedx1
                          mov   bx,ax
                          mov   cl,GridArrayType[bx]
                          cmp   cl,1
                          jz    notaninput1out
                          jmp   notaninput1
    notaninput1out:       mov   ah,currentselectedx1
                          mov   alreadychoose1, 1
                          mov   lockedx1,ah
                          mov   ah,currentselectedy1
                          mov   lockedy1,ah
                          call  getlegalmoves
                          cmp   legalmovesx[1eh],8
                          jnz   notaninput1
                          mov   alreadychoose1,0
                          jmp   notaninput1
    uimovepiece1:         mov   bl, lockedx1
                          mov   startx, bl
                          mov   bh, lockedy1
                          mov   starty, bh
                          call  DrawRect
                          call  DrawPieceXY
                          call  MovePiece
                          mov   alreadychoose1,0
                          call  unMarkLegalmoves

    movedthecurser1:      mov   al,currentselectedx1
                          mov   startx,al
                          mov   al,currentselectedy1
                          mov   starty,al
                          mov   Color,09h
                          call  DrawRect
                          call  DrawPieceXY
                          call  ChangeBackGround
    notaninput1:          ret
Userinput1 ENDP

MAIN PROC FAR

                          MOV   AX , @DATA
                          MOV   DS , AX
                          mov   dx,3fbh                       ; Line Control Register
                          mov   al,10000000b                  ;Set Divisor Latch Access Bit
                          out   dx,al                         ;Out it
    ;Set LSB byte of the Baud Rate Divisor Latch register.
                          mov   dx,3f8h
                          mov   al,0ch
                          out   dx,al

    ;Set MSB byte of the Baud Rate Divisor Latch register.
                          mov   dx,3f9h
                          mov   al,00h
                          out   dx,al

    ;Set port configuration
                          mov   dx,3fbh
                          mov   al,00011011b
                          out   dx,al
                          call  Menu
                          mov   al,0
    nogame:               cmp   al,27
                          jnz   notaborted
                          mov   senderchar,al
                          call  SendData
    notaborted:           mov   gamend,0
                          mov   ah,0
                          mov   al,03h
                          int   10h
                          mov   alreadychoose,0
                          mov   alreadychoose1,0
                          mov   currentselectedx,0
                          mov   currentselectedx1,0
                          mov   currentselectedy,0
                          mov   currentselectedy1,0
                          call  Reset
                          call  ResetDraw
    returntomen:          call  Menu2
                          cmp   startchat,1
                          jnz   notchat
                          call  chating
                          jmp   returntomen

    notchat:              cmp   exitprog,1
                          jnz   notexit
                          jmp   exitprogram
    notexit:              
                          mov   al,playgame
                          mov   teamplaying,al
                          mov   teamplayingbuffer,al
                          call  intializeboard
                          mov   startx,0
                          mov   starty,0
                          mov   Color,0eh
                          cmp   teamplaying,1
                          jnz   colorisco1
                          mov   Color,09h
    colorisco1:           
                          call  ChangeBackGround
                          mov   ah,2ch
                          int   21h

                          mov   lasttime,dh
                          mov   lastimem,dl

    noinput:              mov   letterRecieved,0
                          call  ReceiveMove
                          cmp   gamend,1
                          jz    egl1
                          cmp   letterRecieved,1
                          jnz   noletterec
                          call  RecieveNonMove
                          cmp   gamend,1
                          jz    egl1
    noletterec:           call  TimeControl
                          call  Drawtimeloop
                          mov   ah,1
                          int   16h
                          jz    noinput
                          mov   ah,0
                          int   16h
                          cmp   al,27
                          jnz   yesgame
                          jmp   nogame
    yesgame:              pusha
    ;here we send the letter if we are not moving
                          cmp   al,32
                          jb    itsaletter
                          mov   senderchar,al
                          call  WriteSentLetter
                          call  sendData
    itsaletter:           popa
                          cmp   teamplaying,0
                          jnz   itsblack
                          call  Userinput
                          jmp   playend
    itsblack:             
                          call  Userinput1
    playend:              
                          call  MarkLegalmoves
                          cmp   gamend,1
                          jz    egl1
                          jmp   noinput
    egl1:                 call  GameEndAn
    endgameloop:          mov   ah,0
                          int   16h
                          cmp   al,27
                          jnz   endgameloop
                          mov   al,0
                          jmp   nogame
   
                          
                   
                                  
    exitprogram:          mov   ah, 4ch
                          mov   al, 01h
                          int   21h
                          HLT
MAIN ENDP
END MAIN