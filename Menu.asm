extrn receiverchar:byte
extrn senderchar:byte
public Menu
public Menu2
public playgame
public exitprog
public name1
public name2
public sizename1
public sizename2
public startchat
.model small
.data
    mess1      db "Please enter your name: ",'$'
    user1      db 16
    sizename1 db ?
    name1 db 17 DUP('$')
    Error      DB 'Error! re-enter your name: ','$'
    Enter1      db "Press Enter key to continue",'$'
    Chat       db "To start Chatting press F1",'$'
    game       db "To start the game press F2",'$'
    endprogram db "To end the program press ESC",'$'
    gameinv    db ' invited you to a game$'
    chatinv  db ' invited you to a chat$'
    dash       db 80 DUP(196),'$'
    R          db 3
    C          db 3
    playgame db 0
    exitprog db 0
    startchat db 0
    wasinvited db 0
    wascinvited db 0
    wanttoplay db 0
    wanttochat db 0
    name2 db 17 dup("$")
    sizename2 db ?


.code

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

SendName PROC
    mov bx,0
   namesend: mov al,name1[bx]
    mov senderchar,al
    call SendData
    inc bx
    cmp bl,user1[1]
    jnz namesend
    mov al, sizename1
    mov senderchar,al
    call SendData 
    mov senderchar,'$'
    call SendData
    ret
SendName ENDP

ReceiveName PROC
rnloop:mov receiverchar,0
call ReceiveData
    cmp receiverchar,0
    jz rnloop
    cmp receiverchar,'$'
    jnz rncont
    dec bx
    mov al, name2[bx]
    mov sizename2, al
    mov name2[bx], "$"
    jmp rnend
    rncont: mov al,receiverchar
    mov name2[bx],al
    inc bx
   jmp rnloop
rnend:
    ret
ReceiveName ENDP



CLEAR PROC
             MOV  AH,06
             MOV  AL,00
             MOV  BH,07
             MOV  CH,00
             MOV  CL,00
             MOV  DH,24
             MOV  DL,79
             INT  10H
             RET
CLEAR ENDP

PRINT PROC
             MOV  AH,09
             INT  21H
             RET
PRINT ENDP

CURSOR PROC
             MOV  AH,02
             MOV  bh,00
             INT  10H
             RET
CURSOR ENDP

INPUT PROC
             MOV  AH,0AH
             INT  21H
             RET
INPUT ENDP

VALIDATE PROC
    val:     
             CMP  user1 + 2,122
             JNC  printa
             CMP  user1 + 2,65
             JC   printa
    return:  RET
    printa:  
             INC  R
             MOV  DH,R
             MOV  DL,C
             CALL CURSOR
             MOV  DX,OFFSET Error
             CALL PRINT
             mov  dx,offset user1
             CALL INPUT
             jmp  val
VALIDATE ENDP



Menu PROC far
             CALL CLEAR
             MOV  DH,19
             MOV  DL,2
             CALL CURSOR
             mov  dx,offset Enter1
             CALL PRINT
             MOV  DH,R
             MOV  DL,C
             CALL CURSOR
             mov  dx,offset mess1
             CALL PRINT
             
             MOV  DX,offset user1
             CALL INPUT
             CALL VALIDATE



             ;sending the names to each other
call ReceiveData
cmp al,0
jz sndname
mov al,receiverchar
mov name2,al
mov bx,1
call ReceiveName
sndname:call SendName
recievenameloop: cmp name2,'$'
jnz alreadyrecieved
mov bx,0
call ReceiveName
jmp recievenameloop
alreadyrecieved:
;;;;;;;;;;;;;;;;;;;;;;;;;


             ret
            
Menu ENDP


Menu2 PROC far

             mov wasinvited,0
             mov playgame,0
             mov wascinvited,0
             mov startchat,0
             CALL CLEAR
             MOV  R,7
             MOV  C,20
             MOV  DH,R
             MOV  DL,C
             CALL CURSOR
             MOV  DX,offset Chat
             call PRINT
             INC  R
             MOV  DH,R
             MOV  DL,C
             CALL CURSOR
             Mov  dx,offset game
             CALL PRINT
             INC  R
             MOV  DH,R
             MOV  DL,C
             CALL CURSOR
             MOV  dx,offset endprogram
             CALL PRINT
             MOV  DH ,20
             MOV  DL,0
             CALL CURSOR
             MOV  DX,offset dash
             CALL PRINT
 minputloop: mov receiverchar,0
             call ReceiveData
             cmp receiverchar,1
             jnz noinvitesent
             mov wasinvited,1
             mov dx,offset name2
             ;fix coordinates
             call PRINT
             mov dx,offset gameinv
             call PRINT
noinvitesent: cmp receiverchar,2
            jnz dontstartgyet
            mov playgame,0
            call CLEAR
            ret
 dontstartgyet:cmp receiverchar,3
 jnz nochatinvs
mov wascinvited,1
mov dx,offset name2

call PRINT
mov dx,offset chatinv
call PRINT
 nochatinvs:cmp receiverchar,4
 jnz dontstartcyet
 mov startchat,1
            call CLEAR
            ret
    dontstartcyet:         mov ah,1
             int   16h
             jz    minputloop
             mov   ah,0
             int   16h
             cmp al,27
             jnz dontexit
             mov exitprog,1
             call CLEAR
             ret
dontexit:    cmp ah,59
jnz maybegame
mov senderchar,3
mov wanttochat,1
mov al,wascinvited
             cmp al,wanttochat
             jnz sendinginvc
             mov senderchar,4
             call SendData
             mov startchat,1
             call CLEAR
             ret
sendinginvc: call SendData

maybegame:   cmp ah,60
             jz cont12
             jmp minputloop
         cont12:    mov senderchar,1
             mov wanttoplay,1
             mov al,wasinvited
             cmp al,wanttoplay
             jnz sendinginv
             mov senderchar,2
             call SendData
             mov playgame,1
             call CLEAR
             ret
sendinginv:  call SendData
         jmp minputloop

Menu2 ENDP

END