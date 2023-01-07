.286
extrn GridArray:byte
extrn GridArrayType:byte
extrn currentselectedx:byte
extrn currentselectedx1:byte
extrn currentselectedy:byte
extrn currentselectedy1:byte
extrn lockedx:byte
extrn lockedx1:byte
extrn lockedy:byte
extrn lockedy1:byte
extrn startx:byte
extrn starty:byte
extrn legalmovesx:byte
extrn legalmovesy:byte
extrn teamplaying:byte
extrn kingx:byte
extrn kingy:byte
extrn GridArraytime:byte
extrn name1:byte
extrn name2:byte
extrn teamplayingbuffer:byte
extrn clearstatusbar:far
public getlegalmoves
public squaredguarded
public checkking
public squaredguarded
public Reset

.model small
.data
isforqueen        db 0
squaredguarded db 0
chkmate db 'Check for ','$'
chkmateboth db 'Check for both','$'
GridArrayr         db 1,2,3,4,5,3,2,1,6,6,6,6,6,6,6,6
                      db 32 dup(0)
                      db 6,6,6,6,6,6,6,6,1,2,3,4,5,3,2,1
    GridArrayTyper     db 16 dup(1)
                      db 32 dup(8)
                      db 16 dup(0)
    GridArraytimer     db 64 dup(0)



.code

Queenlegalmoves PROC
                          mov   isforqueen,1
                          call  rooklegalmoves
                          call  bishoplegalmoves
                          ret
Queenlegalmoves ENDP
Kinglegalmoves PROC
                          mov   al,teamplaying
                          mov   ah,0
                          mov   bp,ax
                          mov   si,0
                          cmp   teamplaying,0
                          jz    kingiswhite
                          mov   si,30
    kingiswhite:          mov   al,ds:lockedy[bp]
                        
                          dec   al
                          mov   bl,8
                          mul   bl
                          add   al,ds:lockedx[bp]
                          mov   bx,ax
                          mov   dl,teamplaying
                          cmp   bh,0
                          jz    kingisokay
                          mov   bh,0
                          jmp   kinglm12
                          


    kingisokay:           cmp   GridArrayType[bx],dl
                          jz    kinglm10
                          mov   al,ds:lockedx[bp]
                          mov   ah,ds:lockedy[bp]
                          cmp   ah,0
                          jz    kinglm10
                          dec   ah
                          mov   legalmovesx[si],al
                          mov   legalmovesy[si],ah
                          inc   si


    kinglm10:             dec   bx
                          cmp   GridArrayType[bx],dl
                          jz    kinglm11
                          mov   al,ds:lockedx[bp]
                          mov   ah,ds:lockedy[bp]
                          cmp   ah,0
                          jz    kinglm11
                          cmp   al,0
                          jz    kinglm11
                          dec   ah
                          dec   al
                          mov   legalmovesx[si],al
                          mov   legalmovesy[si],ah
                          inc   si


    kinglm11:             add   bx,2
                          cmp   GridArrayType[bx],dl
                          jz    kinglm12
                          mov   al,ds:lockedx[bp]
                          mov   ah,ds:lockedy[bp]
                          cmp   ah,0
                          jz    kinglm12
                          cmp   al,7
                          jz    kinglm12
                          dec   ah
                          inc   al
                          mov   legalmovesx[si],al
                          mov   legalmovesy[si],ah
                          inc   si


    kinglm12:             mov   ah,0
                          mov   al,ds:lockedy[bp]
                          mov   bx,8
                          mul   bl
                          add   al,ds:lockedx[bp]
                          mov   bx,ax
                          dec   bx
                          cmp   GridArrayType[bx],dl
                          jz    kinglm13
                          mov   al,ds:lockedx[bp]
                          mov   ah,ds:lockedy[bp]
                          cmp   al,0
                          jz    kinglm13
                          dec   al
                          mov   legalmovesx[si],al
                          mov   legalmovesy[si],ah
                          inc   si

    kinglm13:             add   bx,2
                          
                          cmp   GridArrayType[bx],dl
                          jz    kinglm14
                          mov   al,ds:lockedx[bp]
                          mov   ah,ds:lockedy[bp]
                          cmp   al,7
                          jz    kinglm14
                          inc   al
                          mov   legalmovesx[si],al
                          mov   legalmovesy[si],ah
                          inc   si



    kinglm14:             add   bx,6
                         
                          cmp   GridArrayType[bx],dl
                          jz    kinglm15
                          mov   al,ds:lockedx[bp]
                          mov   ah,ds:lockedy[bp]
                          cmp   ah,7
                          jz    kinglm15
                          cmp   al,0
                          jz    kinglm15
                          inc   ah
                          dec   al
                          mov   legalmovesx[si],al
                          mov   legalmovesy[si],ah
                          inc   si


    kinglm15:             add   bx,1
                      
                          cmp   GridArrayType[bx],dl
                          jz    kinglm16
                          mov   al,ds:lockedx[bp]
                          mov   ah,ds:lockedy[bp]
                          cmp   ah,7
                          jz    kinglm16
                          inc   ah
                          mov   legalmovesx[si],al
                          mov   legalmovesy[si],ah
                          inc   si


    kinglm16:             add   bx,1
                        
                          cmp   GridArrayType[bx],dl
                          jz    kinglme
                          mov   al,ds:lockedx[bp]
                          mov   ah,ds:lockedy[bp]
                          cmp   ah,7
                          jz    kinglme
                          cmp   al,7
                          jz    kinglme
                          inc   ah
                          inc   al
                          mov   legalmovesx[si],al
                          mov   legalmovesy[si],ah
                          inc   si

    kinglme:              mov   legalmovesx[si],8
                          mov   legalmovesy[si],8
       
                          ret
Kinglegalmoves ENDP
isguarded PROC
                          pusha
                          mov       squaredguarded,0
                          mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       cl,GridArrayType[bx]
                          mov       al,starty
                          mov       ah,startx
                          cmp       starty,0
                          jz        isguarded1end
    isguarded1:           sub       bx,8
                          dec       al                             ;this is for the above direction
                          cmp       GridArrayType[bx],cl           ;if we found a rook or a queen then no
                          jz        isguarded1end

                          cmp       GridArray[bx],1
                          jnz       isguarded10
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded10:          cmp       GridArray[bx],4
                          jnz       isguarded11
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded11:          cmp       GridArray[bx],5
                          jnz       isguarded12
                          mov       dl,al
                          add       dl,1
                          cmp       dl,starty
                          jnz       isguarded12
                          mov       squaredguarded,1
                          popa
                          ret
    isguarded12:          cmp       GridArray[bx],0
                          jnz       isguarded1end
                          cmp       al,0
                          jz        isguarded1end
                          jmp       isguarded1
    isguarded1end:                                                 ;now checking down
                          mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       al,starty
                          mov       ah,startx
                          cmp       starty,7
                          jz        isguarded2end
    isguarded2:           add       bx,8
                          inc       al
                          cmp       GridArrayType[bx],cl           ;if we found a rook or a queen then no
                          jz        isguarded2end

                          cmp       GridArray[bx],1
                          jnz       isguarded20
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded20:          cmp       GridArray[bx],4
                          jnz       isguarded21
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded21:          cmp       GridArray[bx],5
                          jnz       isguarded22
                          mov       dl,al
                          sub       dl,1
                          cmp       dl,starty
                          jnz       isguarded22
                          mov       squaredguarded,1
                          popa
                          ret
    isguarded22:          cmp       GridArray[bx],0
                          jnz       isguarded2end
                          cmp       al,7
                          jz        isguarded2end
                          jmp       isguarded2
    isguarded2end:                                                 ;now the right
                          mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       al,starty
                          mov       ah,startx

    ;right starts here
                          cmp       ah,7
                          jz        isguarded3end
    isguarded3:           add       bx,1
                          inc       ah
                          cmp       GridArrayType[bx],cl
                          jz        isguarded3end

                          cmp       GridArray[bx],1
                          jnz       isguarded30
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded30:          cmp       GridArray[bx],4
                          jnz       isguarded31
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded31:          cmp       GridArray[bx],5
                          jnz       isguarded32
                          mov       dl,ah
                          sub       dl,1
                          cmp       dl,startx
                          jnz       isguarded32
                          mov       squaredguarded,1
                          popa
                          ret
    isguarded32:          cmp       GridArray[bx],0
                          jz        isguarded3end
                          cmp       ah,7
                          jz        isguarded3end
                          jmp       isguarded3
    isguarded3end:        
                          mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       al,starty
                          mov       ah,startx

                          cmp       ah,0
                          jz        isguarded4end
    isguarded4:           sub       bx,1
                          dec       ah
                          cmp       GridArrayType[bx],cl
                          jz        isguarded4end

                          cmp       GridArray[bx],1
                          jnz       isguarded40
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded40:          cmp       GridArray[bx],4
                          jnz       isguarded41
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded41:          cmp       GridArray[bx],5
                          jnz       isguarded42
                          mov       dl,ah
                          add       dl,1
                          cmp       dl,startx
                          jnz       isguarded42
                          mov       squaredguarded,1
                          popa
                          ret
    isguarded42:          cmp       GridArray[bx],0
                          jnz       isguarded4end
                          cmp       ah,0
                          jz        isguarded4end
                          jmp       isguarded4
    isguarded4end:                                                 ;4 inclinded directions start here then the knight since its a special case
    ;now starting with the up right direction
                          mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       al,starty
                          mov       ah,startx
                          cmp       ah,7
                          jz        isguarded5end
                          cmp       al,0
                          jz        isguarded5end

    isguarded5:           inc       ah
                          dec       al
                          sub       bx,7
                          cmp       GridArrayType[bx],cl
                          jz        isguarded5end

                          cmp       GridArray[bx],3
                          jnz       isguarded50
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded50:          cmp       GridArray[bx],4
                          jnz       isguarded51
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded51:          cmp       GridArray[bx],5
                          jnz       isguarded52
                          mov       dl,ah
                          sub       dl,1
                          cmp       dl,startx
                          jnz       isguarded52
                          mov       dl,al
                          add       dl,1
                          cmp       dl,starty
                          jnz       isguarded52
                          mov       squaredguarded,1
                          popa
                          ret
    isguarded52:          
    isguarded53:          cmp       GridArray[bx],0
                          jnz       isguarded5end
                          cmp       ah,7
                          jz        isguarded5end
                          cmp       al,0
                          jz        isguarded5end
                          jmp       isguarded5
    isguarded5end:        
    ; right down
                          mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       al,starty
                          mov       ah,startx
                          cmp       ah,7
                          jz        isguarded6end
                          cmp       al,7
                          jz        isguarded6end
   
    isguarded6:           inc       ah
                          inc       al
                          add       bx,9
                          cmp       GridArrayType[bx],cl
                          jz        isguarded6end

                          cmp       GridArray[bx],3
                          jnz       isguarded60
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded60:          cmp       GridArray[bx],4
                          jnz       isguarded61
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded61:          cmp       GridArray[bx],5
                          jnz       isguarded62
                          mov       dl,ah
                          sub       dl,1
                          cmp       dl,startx
                          jnz       isguarded62
                          mov       dl,al
                          sub       dl,1
                          cmp       dl,starty
                          jnz       isguarded62
                          mov       squaredguarded,1
                          popa
                          ret
    isguarded62:          
    
    
    isguarded63:          cmp       GridArray[bx],0
                          jnz       isguarded6end
                          cmp       ah,7
                          jz        isguarded6end
                          cmp       al,7
                          jz        isguarded6end
                          jmp       isguarded6
    isguarded6end:                                                 ;left down

                          mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       al,starty
                          mov       ah,startx
                          cmp       ah,0
                          jz        isguarded7end
                          cmp       al,7
                          jz        isguarded7end
    isguarded7:           dec      ah
                          inc       al
                          add       bx,7
                          cmp       GridArrayType[bx],cl
                          jz        isguarded7end

                          cmp       GridArray[bx],3
                          jnz       isguarded70
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded70:          cmp       GridArray[bx],4
                          jnz       isguarded71
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded71:          cmp       GridArray[bx],5
                          jnz       isguarded72
                          mov       dl,ah
                          sub       dl,1
                          cmp       dl,startx
                          jnz       isguarded72
                          mov       dl,al
                          sub       dl,1
                          cmp       dl,starty
                          jnz       isguarded72
                          mov       squaredguarded,1
                          popa
                          ret
    isguarded72:          
    isguarded73:          cmp       GridArray[bx],0
                          jnz       isguarded7end
                          cmp       ah,0
                          jz        isguarded7end
                          cmp       al,7
                          jz        isguarded7end
                          jmp       isguarded7
    isguarded7end:  
    ;left up    

    mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       al,starty
                          mov       ah,startx
                          cmp       ah,0
                          jz        isguarded8end
                          cmp       al,0
                          jz        isguarded8end
    isguarded8:           dec       ah
                          dec       al
                          sub      bx,9
                          cmp       GridArrayType[bx],cl
                          jz        isguarded8end

                          cmp       GridArray[bx],3
                          jnz       isguarded80
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded80:          cmp       GridArray[bx],4
                          jnz       isguarded81
                          mov       squaredguarded,1
                          popa
                          ret

    isguarded81:          cmp       GridArray[bx],5
                          jnz       isguarded82
                          mov       dl,ah
                          add       dl,1
                          cmp       dl,startx
                          jnz       isguarded82
                          mov       dl,al
                          add       dl,1
                          cmp       dl,starty
                          jnz       isguarded82
                          mov       squaredguarded,1
                          popa
                          ret
    isguarded82:          
    isguarded83:          cmp       GridArray[bx],0
                          jnz       isguarded8end
                          cmp       ah,0
                          jz        isguarded8end
                          cmp       al,0
                          jz        isguarded8end
                          jmp       isguarded8
    isguarded8end:  ;the knight
                          mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       al,starty
                          mov       ah,startx
                          mov dx,bx
                          ;hena we check if a knight is in a location 2 up and 1 left
                          cmp al,2  ;if al is less than 2 then it cant be
                          jb isguarded92
                          cmp ah,0   ;cant be left if ah is 0
                          jz isguarded91
                          mov bx,dx
                          sub bx,17
                          cmp GridArray[bx],2
                          jnz isguarded91
                          cmp GridArrayType[bx],cl
                          jz isguarded91
                          mov       squaredguarded,1
                          popa
                          ret
                       isguarded91:
                       mov bx,dx
                       sub bx,15
                         cmp ah,7    ;cant be right if ah is 7
                          jz isguarded92
                          cmp GridArray[bx],2
                          jnz isguarded92
                          cmp GridArrayType[bx],cl
                          jz isguarded92
                          mov       squaredguarded,1
                          popa
                          ret


isguarded92:
 mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       al,starty
                          mov       ah,startx
                          mov dx,bx
                          ;hena we check if a knight is in a location 2 down and 1 left
                          cmp al,5 ;if al is more than 5 then it cant be
                          ja isguarded94
                          cmp ah,0   ;cant be left if ah is 0
                          jz isguarded93
                          mov bx,dx
                          add bx,15
                          cmp GridArray[bx],2
                          jnz isguarded93
                          cmp GridArrayType[bx],cl
                          jz isguarded93
                          mov       squaredguarded,1
                          popa
                          ret
                       isguarded93: 
                       mov bx,dx
                       add bx,17
                        cmp ah,7    ;cant be right if ah is 7
                          jz isguarded94
                          cmp GridArray[bx],2
                          jnz isguarded94
                          cmp GridArrayType[bx],cl
                          jz isguarded94
                          mov       squaredguarded,1
                          popa
                          ret

isguarded94:
                          mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       al,starty
                          mov       ah,startx
                          mov dx,bx
                        cmp ah,2        ;two left 1 up
                        jb isguarded96
                        cmp al,0
                        jz isguarded95
                        sub bx,10
                        cmp GridArray[bx],2
                        jnz isguarded95
                        cmp GridArrayType[bx],cl
                        jz isguarded95
                        mov       squaredguarded,1
                        popa
                        ret

    isguarded95:        mov bx,dx  ;2 left 1 down
                        add bx,6
                        cmp al,7
                        jz isguarded96
                        cmp GridArray[bx],2
                        jnz isguarded96
                        cmp GridArrayType[bx],cl
                        jz isguarded96
                        mov       squaredguarded,1
                        popa
                        ret
    isguarded96:   ;2right 1 up
    mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       al,starty
                          mov       ah,startx
                          mov dx,bx
                        cmp ah,5        
                        ja isguarded98
                        cmp al,0
                        jz isguarded97
                        sub bx,6
                        cmp GridArray[bx],2
                        jnz isguarded97
                        cmp GridArrayType[bx],cl
                        jz isguarded97
                        mov       squaredguarded,1
                        popa
                        ret

    isguarded97:        mov bx,dx  ;2 right 1 down
                        add bx,10
                        cmp al,7
                        jz isguarded98
                        cmp GridArray[bx],2
                        jnz isguarded98
                        cmp GridArrayType[bx],cl
                        jz isguarded98
                        mov       squaredguarded,1
                        popa
                        ret
    isguarded98:          mov       ah,0
                          mov       al,starty
                          mov       bx,8
                          mul       bl
                          add       al,startx
                          mov       bx,ax
                          mov       al,starty
                          mov       ah,startx
                          cmp cl,0
                          jnz isguarded101
                          ;checking for pawns attacking the king
                          cmp al,0
                          jnz isguarded102
popa 
                        ret
                       
 isguarded102:         sub bx,9  
 cmp ah,0
 jz isguarded103
 cmp GridArray[bx],6
 jnz isguarded103
 cmp GridArrayType[bx],cl
 jz isguarded103
mov       squaredguarded,1
                        popa
                        ret

 isguarded103: cmp ah,7
 jz isguardedend
 add bx,2
cmp GridArray[bx],6
 jnz isguardedend
 cmp GridArrayType[bx],cl
 jz isguardedend
mov       squaredguarded,1
 popa
 ret                     
 isguarded101:
        cmp al,7
        jnz isguarded104
        popa 
        ret
                        
 isguarded104:         add bx,7
  cmp ah,0
 jz isguarded105
 cmp GridArray[bx],6
 jnz isguarded105
 cmp GridArrayType[bx],cl
 jz isguarded105
mov       squaredguarded,1
                        popa
                        ret

 isguarded105: cmp ah,7
 jz isguardedend
 add bx,2
cmp GridArray[bx],6
 jnz isguardedend
 cmp GridArrayType[bx],cl
 jz isguardedend
mov       squaredguarded,1
 popa
 ret

  isguardedend:           popa
                          ret
isguarded ENDP
wpawnlegalmoves PROC
    ;jmp far m3 compare
    ; white pawn
                          cmp   teamplaying,0
                          jz    wpawn
                          ret
    wpawn:                mov   si,0
                          mov   al,lockedy
                          mov   ah,0
                          dec   al
                          mov   bx,8
                          mul   bx
                          add   al,lockedx
                          cmp   lockedy,0
                          jnz   wpawnlegalmovesendl
                          jmp   wpawnlegalmovesend
    wpawnlegalmovesendl:  mov   bx,ax
                          cmp   GridArray[bx],0
                          jnz   wpawnlegalmoves0
                          mov   al,lockedx
                          mov   legalmovesx[si],al
                          mov   al,lockedy
                          dec   al
                          mov   legalmovesy[si],al
                          inc   si
    wpawnlegalmoves0:     dec   bx
                          cmp   GridArrayType[bx],1
                          jnz   wpawnlegalmoves1
                          mov   al,lockedx
                          cmp   al,0
                          jz    wpawnlegalmoves1
                          dec   al
                          mov   legalmovesx[si],al
                          mov   al,lockedy
                          dec   al
                          mov   legalmovesy[si],al
                          inc   si
    wpawnlegalmoves1:     
                          add   bx,2
                          cmp   GridArrayType[bx],1
                          jnz   wpawnlegalmoves2
                          mov   al,lockedx
                          cmp   al,7
                          jz    wpawnlegalmoves2
                          inc   al
                          mov   legalmovesx[si],al
                          mov   al,lockedy
                          dec   al
                          mov   legalmovesy[si],al
                          inc   si
    wpawnlegalmoves2:     cmp   lockedy,6
                          jnz   wpawnlegalmovesend
                          sub   bx,9
                          cmp   GridArrayType[bx],8
                          jnz   wpawnlegalmovesend
                          mov   al,lockedx
                          mov   legalmovesx[si],al
                          mov   al,lockedy
                          dec   al
                          dec   al
                          mov   legalmovesy[si],al
                          inc   si

    wpawnlegalmovesend:   mov   legalmovesx[si],8
                          mov   legalmovesy[si],8
                          ret
wpawnlegalmoves ENDP

bpawnlegalmoves PROC
    ;jmp far m3 compare
    ; white pawn
                          cmp   teamplaying,1
                          jz    bpawn
                          ret
    bpawn:                
                          mov   si,30
                          mov   al,lockedy1
                          mov   ah,0
                          inc   al
                          mov   bx,8
                          mul   bx
                          add   al,lockedx1
                          cmp   lockedy1,7
                          jnz   bpawnlegalmovesendl
                          jmp   bpawnlegalmovesend
    bpawnlegalmovesendl:  mov   bx,ax
                          cmp   GridArray[bx],0
                          jnz   bpawnlegalmoves0
                          mov   al,lockedx1
                          mov   legalmovesx[si],al
                          mov   al,lockedy1
                          inc   al
                          mov   legalmovesy[si],al
                          inc   si
    bpawnlegalmoves0:     dec   bx
                          cmp   GridArrayType[bx],0
                          jnz   bpawnlegalmoves1
                          mov   al,lockedx1
                          cmp   al,0
                          jz    bpawnlegalmoves1
                          dec   al
                          mov   legalmovesx[si],al
                          mov   al,lockedy1
                          inc   al
                          mov   legalmovesy[si],al
                          inc   si
    bpawnlegalmoves1:     
                          add   bx,2
                          cmp   GridArrayType[bx],0
                          jnz   bpawnlegalmoves2
                          mov   al,lockedx1
                          cmp   al,7
                          jz    bpawnlegalmoves2
                          inc   al
                          mov   legalmovesx[si],al
                          mov   al,lockedy1
                          inc   al
                          mov   legalmovesy[si],al
                          inc   si
    bpawnlegalmoves2:     cmp   lockedy1,1
                          jnz   bpawnlegalmovesend
                          add   bx,7
                          cmp   GridArrayType[bx],8
                          jnz   bpawnlegalmovesend
                          mov   al,lockedx1
                          mov   legalmovesx[si],al
                          mov   al,lockedy1
                          inc   al
                          inc   al
                          mov   legalmovesy[si],al
                          inc   si

    bpawnlegalmovesend:   mov   legalmovesx[si],8
                          mov   legalmovesy[si],8
                          ret
bpawnlegalmoves ENDP

bishoplegalmoves PROC
    ;works on white only for now
    ;no we make a copy of the code for ze black
                          mov   al,teamplaying
                          mov   ah,0
                          mov   bp,ax
                          cmp   isforqueen,1
                          jz    bishopisqueen
                          mov   si,0
                          cmp   teamplaying,0
                          jz    bishiswhite
                          mov   si,30
    bishiswhite:          
                         
                           
    bishopisqueen:        mov   ah,0
                          mov   ch, 0
                          mov   cl, ds:lockedx[bp]
                          cmp   cx, 0
                          jz    loopwhitebishop1end
                          mov   dh, 0
                          mov   dl, ds:lockedy[bp]
                          cmp   dx, 0
                          jz    loopwhitebishop1end
    loopwhitebishop10:    mov   ah, 0                      ;moving diagonal up left
                          sub   cx, 1
                          sub   dx, 1
                          mov   al, dl
                          push  dx
                          mov   bx, 8                      ;calculating index in GridArray
                          mul   bx
                          pop   dx
                          add   al, cl
                          mov   bx, ax
                          cmp   GridArray[bx], 0
                          jnz   loopwhitebishop11
                          mov   legalmovesx[si], cl        ;saving legal move
                          mov   legalmovesy[si], dl
                          inc   si
                          jmp   loopwhitebishop13
    loopwhitebishop11:    mov   al,teamplaying
                          cmp   GridArrayType[bx], al
                          jz    loopwhitebishop12          ;checking if piece is enemy
                          mov   legalmovesx[si], cl        ;Piece can be eaten
                          mov   legalmovesy[si], dl
                          inc   si
    loopwhitebishop12:    jmp   loopwhitebishop1end
    loopwhitebishop13:    add   cx, 1
                          cmp   cx, 0
                          jz    loopwhitebishop1end
                          cmp   dx, 0
                          jz    loopwhitebishop1end
                          loop  loopwhitebishop10
    loopwhitebishop1end:  mov   ah, 0
                          mov   ch, 0
                          mov   cl, ds:lockedx[bp]
                          mov   dh, 0
                          mov   dl, ds:lockedy[bp]
                          cmp   cx, 7
                          jz    loopwhitebishop2end
                          cmp   dx, 0
                          jz    loopwhitebishop2end
    loopwhitebishop20:    mov   ah, 0                      ;moving diagonal up left
                          add   cx, 1
                          sub   dx, 1
                          mov   al, dl
                          push  dx
                          mov   bx, 8                      ;calculating index in GridArray
                          mul   bx
                          pop   dx
                          add   al, cl
                          mov   bx, ax
                          cmp   GridArray[bx], 0
                          jnz   loopwhitebishop21
                          mov   legalmovesx[si], cl        ;saving legal move
                          mov   legalmovesy[si], dl
                          inc   si
                          jmp   loopwhitebishop23
    loopwhitebishop21:    mov   al,teamplaying
                          cmp   GridArrayType[bx], al
                          jz    loopwhitebishop22          ;checking if piece is enemy
                          mov   legalmovesx[si], cl        ;Piece can be eaten
                          mov   legalmovesy[si], dl
                          inc   si
    loopwhitebishop22:    jmp   loopwhitebishop2end
    loopwhitebishop23:    add   cx, 1
                          cmp   cx, 8
                          jz    loopwhitebishop2end        ;sub       cx, 1
                          cmp   dx, 0
                          jz    loopwhitebishop2end
                          loop  loopwhitebishop20          ;moving diagonal up right

    loopwhitebishop2end:  mov   ah, 0
                          mov   ch, 0
                          mov   cl, ds:lockedx[bp]
                          mov   dh, 0
                          mov   dl, ds:lockedy[bp]
                          cmp   cx, 0
                          jz    loopwhitebishop3end
                          cmp   dx, 7
                          jz    loopwhitebishop3end

    loopwhitebishop30:    mov   ah, 0                      ;moving diagonal up left
                          add   dx, 1
                          sub   cx, 1
                          mov   al, dl
                          push  dx
                          mov   bx, 8                      ;calculating index in GridArray
                          mul   bx
                          pop   dx
                          add   al, cl
                          mov   bx, ax
                          cmp   GridArray[bx], 0
                          jnz   loopwhitebishop31
                          mov   legalmovesx[si], cl        ;saving legal move
                          mov   legalmovesy[si], dl
                          inc   si
                          jmp   loopwhitebishop33
    loopwhitebishop31:    mov   al,teamplaying
                          cmp   GridArrayType[bx], al
                          jz    loopwhitebishop32          ;checking if piece is enemy
                          mov   legalmovesx[si], cl        ;Piece can be eaten
                          mov   legalmovesy[si], dl
                          inc   si
    loopwhitebishop32:    jmp   loopwhitebishop3end
    loopwhitebishop33:    add   cx, 1
                          cmp   cx, 0
                          jz    loopwhitebishop3end        ;sub       cx, 1
                          cmp   dx, 7
                          jz    loopwhitebishop3end
                          loop  loopwhitebishop30          ;moving diagonal up right

    loopwhitebishop3end:  mov   ah, 0
                          mov   ch, 0
                          mov   cl, ds:lockedx[bp]
                          mov   dh, 0
                          mov   dl, ds:lockedy[bp]
                          cmp   cx, 7
                          jz    loopwhitebishop4end
                          cmp   dx, 7
                          jz    loopwhitebishop4end

    loopwhitebishop40:    mov   ah, 0                      ;moving diagonal up left
                          add   dx, 1
                          add   cx, 1
                          mov   al, dl
                          push  dx
                          mov   bx, 8                      ;calculating index in GridArray
                          mul   bx
                          pop   dx
                          add   al, cl
                          mov   bx, ax
                          cmp   GridArray[bx], 0
                          jnz   loopwhitebishop41
                          mov   legalmovesx[si], cl        ;saving legal move
                          mov   legalmovesy[si], dl
                          inc   si
                          jmp   loopwhitebishop43
    loopwhitebishop41:    mov   al,teamplaying
                          cmp   GridArrayType[bx],al
                          jz    loopwhitebishop42          ;checking if piece is enemy
                          mov   legalmovesx[si], cl        ;Piece can be eaten
                          mov   legalmovesy[si], dl
                          inc   si
    loopwhitebishop42:    jmp   loopwhitebishop4end
    loopwhitebishop43:    add   cx, 1
                          cmp   cx, 8
                          jz    loopwhitebishop4end        ;sub       cx, 1
                          cmp   dx, 7
                          jz    loopwhitebishop4end        ;sub       cx, 1
                          loop  loopwhitebishop40          ;moving diagonal up right

    loopwhitebishop4end:  
    
    ;moving diagonal up right
    mamaend:              mov   legalmovesx[si],8
                          mov   legalmovesy[si],8
                          ret

bishoplegalmoves ENDP

rooklegalmoves PROC
    ;works on white only for now
    ;no we make a copy of the code for ze black
                          
                          mov   al,teamplaying
                          mov   ah,0
                          mov   bp,ax
                          mov   si,0
                          cmp   teamplaying,0
                          jz    rookiswhite
                          mov   si,30
    rookiswhite:          mov   ch,0
                          mov   ah,0
                          mov   cl,ds:lockedx[bp]
                          cmp   cx, 0                      ;cx is x
                          jz    loopwhiterook1end
    loopwhiterook10:      mov   ah,0
                          sub   cx,1
                          mov   al,ds:lockedy[bp]
                          mov   bx,8
                          mul   bx
                          add   al,cl
                          mov   bx,ax
                          cmp   GridArray[bx],0
                          jnz   loopwhiterook11
                          mov   legalmovesx[si],cl
                          mov   al,ds:lockedy[bp]
                          mov   legalmovesy[si],al
                          inc   si
                          jmp   loopwhiterook13
    loopwhiterook11:      mov   al,teamplaying
                          cmp   GridArrayType[bx],al
                          jz    loopwhiterook12
                          mov   legalmovesx[si],cl
                          mov   al,ds:lockedy[bp]
                          mov   legalmovesy[si],al
                          inc   si
    loopwhiterook12:      jmp   loopwhiterook1end
    loopwhiterook13:      add   cx,1
                          loop  loopwhiterook10
    loopwhiterook1end:    mov   ch,0
                          mov   ah,0
                          mov   cl,ds:lockedx[bp]
                          cmp   cx, 7                      ;cx is x
                          jz    loopwhiterook2end
                          add   cl,1
    loopwhiterook20:      mov   ah,0
                          mov   al,ds:lockedy[bp]
                          mov   bx,8
                          mul   bx
                          add   al,cl
                          mov   bx,ax
                          cmp   GridArray[bx],0
                          jnz   loopwhiterook21
                          mov   legalmovesx[si],cl
                          mov   al,ds:lockedy[bp]
                          mov   legalmovesy[si],al
                          inc   si
                          jmp   loopwhiterook23
    loopwhiterook21:      mov   al,teamplaying
                          cmp   GridArrayType[bx],al
                          jz    loopwhiterook22
                          mov   legalmovesx[si],cl
                          mov   al,ds:lockedy[bp]
                          mov   legalmovesy[si],al
                          
    
                          inc   si
    loopwhiterook22:      jmp   loopwhiterook2end
    loopwhiterook23:      inc   cl
                          cmp   cl,8
                          jnz   loopwhiterook20
    loopwhiterook2end:    mov   ch,0
                          mov   ah,0
                          mov   cl,ds:lockedy[bp]          ;cx is y
                          cmp   cx, 0
                          jz    loopwhiterook3end
    loopwhiterook30:      mov   ah,0
                          sub   cx,1
                          mov   al,cl
                          mov   bx,8
                          mul   bx
                          add   al,ds:lockedx[bp]
                          mov   bx,ax
                          cmp   GridArray[bx],0
                          jnz   loopwhiterook31
                          mov   legalmovesy[si],cl
                          mov   al,ds:lockedx[bp]
                          mov   legalmovesx[si],al
                          inc   si
                          jmp   loopwhiterook33
    loopwhiterook31:      mov   al,teamplaying
                          cmp   GridArrayType[bx],al
                          jz    loopwhiterook32
                          mov   legalmovesy[si],cl
                          mov   al,ds:lockedx[bp]
                          mov   legalmovesx[si],al
                          inc   si
    loopwhiterook32:      jmp   loopwhiterook3end
    loopwhiterook33:      add   cx,1
                          loop  loopwhiterook30
    loopwhiterook3end:    mov   ch,0
                          mov   ah,0
                          mov   cl,ds:lockedy[bp]
                          cmp   cx, 7
                          jz    loopwhiterook4end
                          add   cl,1
    loopwhiterook40:      mov   ah,0
                          mov   al,cl
                          mov   bx,8
                          mul   bx
                          add   al,ds:lockedx[bp]
                          mov   bx,ax
                          cmp   GridArray[bx],0
                          jnz   loopwhiterook41
                          mov   legalmovesy[si],cl
                          mov   al,ds:lockedx[bp]
                          mov   legalmovesx[si],al
                          inc   si
                          jmp   loopwhiterook43
    loopwhiterook41:      mov   al,teamplaying
                          cmp   GridArrayType[bx],al
                          jz    loopwhiterook42
                          mov   legalmovesy[si],cl
                          mov   al,ds:lockedx[bp]
                          mov   legalmovesx[si],al
                          inc   si
    loopwhiterook42:      jmp   loopwhiterook4end
    loopwhiterook43:      inc   cl
                          cmp   cl,8
                          jnz   loopwhiterook40
    loopwhiterook4end:    mov   legalmovesx[si],8
                          mov   legalmovesy[si],8
                          ret
rooklegalmoves ENDP

checkking PROC far
    pusha
mov al,kingx[0]
 mov ah,kingy[0]
 mov startx,al
 mov starty,ah
call isguarded
cmp squaredguarded,0
jz MPboth
mov al,kingx[1]
 mov ah,kingy[1]
 mov startx,al
 mov starty,ah
 call isguarded
 cmp squaredguarded,0
 jz MPboth
 call clearstatusbar
 mov ah,9
 mov dx, offset chkmateboth
int 21h
popa
ret
MPboth:call clearstatusbar
mov al,kingx[0]
 mov ah,kingy[0]
 mov startx,al
 mov starty,ah
 call isguarded
 cmp squaredguarded,0
 jz mpcheckmate
 mov ah,9
 mov dx, offset chkmate
 
 int 21h
 cmp teamplayingbuffer,0
 jz iamwhite  
 ;name1 is black and white is checked
mov dx,offset name2
jmp imwhite1
 iamwhite:
 mov dx,offset name1
 imwhite1: int 21H
popa
ret
 mpcheckmate:mov al,kingx[1]
 mov ah,kingy[1]
 mov startx,al
 mov starty,ah
 call isguarded
 cmp squaredguarded,0
 jz mpcheckmate2
 mov ah,9
mov dx, offset chkmate
int 21h
cmp teamplayingbuffer,1
 jz iamblack 
 ;name1 is white and black is checked
mov dx,offset name2
jmp imblack1
 iamblack:
 mov dx,offset name1
 imblack1: int 21H
 mpcheckmate2:

 popa
    ret
checkking ENDP

Knightlegalmoves PROC
                          mov       al,teamplaying
                          mov       ah,0
                          mov       bp,ax
                          mov       si,0
                          cmp       teamplaying,0
                          jz        knightiswhite
                          mov       si,30
    knightiswhite:        mov       ah,ds:lockedx[bp]
                          mov       al,ds:lockedy[bp]
    ;2 up and 1 left
                          cmp       al,2
                          jb        knightiswhite2
                          cmp       ah,0
                          jz        knightiswhite1
                          mov       bl,8
    

                          sub       al,2
                          dec       ah
                          mov       cx,ax
                          mul       bl
                          add       al,ch
                          mov       ah,0
                          mov       bx,ax
                          mov       ax,cx
                          mov       dl,teamplaying
                          cmp       GridArrayType[bx],dl
                          jz        knightiswhite1
                          mov       legalmovesx[si],ah
                          mov       legalmovesy[si],al
                          inc       si
                          
    


    ;
    knightiswhite1:       mov       ah,ds:lockedx[bp]
                          mov       al,ds:lockedy[bp]
    ;2 up and 1 right
                          cmp       ah,7
                          jz        knightiswhite2
                          mov       bl,8

                          sub       al,2
                          inc       ah
                          mov       cx,ax
                          mul       bl
                          add       al,ch
                          mov       ah,0
                          mov       bx,ax
                          mov       ax,cx
                          mov       dl,teamplaying
                          cmp       GridArrayType[bx],dl
                          jz        knightiswhite2
                          mov       legalmovesx[si],ah
                          mov       legalmovesy[si],al
                          inc       si
    ;
                         

    
    knightiswhite2:       mov       ah,ds:lockedx[bp]
                          mov       al,ds:lockedy[bp]
    ;2left and 1 up
                          cmp       ah,2
                          jb        knightiswhite4
                          cmp       al,0
                          jz        knightiswhite3
                          mov       bl,8
                          sub       ah,2
                          dec       al
                          mov       cx,ax
                          mul       bl
                          add       al,ch
                          mov       ah,0
                          mov       bx,ax
                          mov       ax,cx
                          mov       dl,teamplaying
                          cmp       GridArrayType[bx],dl
                          jz        knightiswhite3
                          mov       legalmovesx[si],ah
                          mov       legalmovesy[si],al
                          inc       si

                          

    ;
    knightiswhite3:       mov       ah,ds:lockedx[bp]
                          mov       al,ds:lockedy[bp]
    ;2left and 1 down
                          cmp       al,7
                          jz        knightiswhite4
                          mov       bl,8
                          sub       ah,2
                          inc       al
                          mov       cx,ax
                          mul       bl
                          add       al,ch
                          mov       ah,0
                          mov       bx,ax
                          mov       ax,cx
                          mov       dl,teamplaying
                          cmp       GridArrayType[bx],dl
                          jz        knightiswhite4
                          mov       legalmovesx[si],ah
                          mov       legalmovesy[si],al
                          inc       si

                          
    ;

    knightiswhite4:       mov       ah,ds:lockedx[bp]
                          mov       al,ds:lockedy[bp]
    ;2down 1 left
                          cmp       al,5
                          ja        knightiswhite6
                          cmp       ah,0
                          jz        knightiswhite5
                          mov       bl,8
                          add       al,2
                          dec       ah
                          mov       cx,ax
                          mul       bl
                          add       al,ch
                          mov       ah,0
                          mov       bx,ax
                          mov       ax,cx
                          mov       dl,teamplaying
                          cmp       GridArrayType[bx],dl
                          jz        knightiswhite5
                          mov       legalmovesx[si],ah
                          mov       legalmovesy[si],al
                          inc       si

                          

    ;

    knightiswhite5:       mov       ah,ds:lockedx[bp]
                          mov       al,ds:lockedy[bp]
    ;2 down 1 right
                          cmp       ah,7
                          jz        knightiswhite6
                          mov       bl,8
                          add       al,2
                          inc       ah
                          mov       cx,ax
                          mul       bl
                          add       al,ch
                          mov       ah,0
                          mov       bx,ax
                          mov       ax,cx
                          mov       dl,teamplaying
                          cmp       GridArrayType[bx],dl
                          jz        knightiswhite6
                          mov       legalmovesx[si],ah
                          mov       legalmovesy[si],al
                          inc       si

                          
    ;

    knightiswhite6:       mov       ah,ds:lockedx[bp]
                          mov       al,ds:lockedy[bp]
    ;2right 1 up
                          cmp       ah,5
                          ja        knightiswhite8
                          cmp       al,0
                          jz        knightiswhite7
                          mov       bl,8
                          add       ah,2
                          dec       al
                          mov       cx,ax
                          mul       bl
                          add       al,ch
                          mov       ah,0
                          mov       bx,ax
                          mov       ax,cx
                          mov       dl,teamplaying
                          cmp       GridArrayType[bx],dl
                          jz        knightiswhite7
                          mov       legalmovesx[si],ah
                          mov       legalmovesy[si],al
                          inc       si

                          
    ;
                        


    knightiswhite7:       mov       ah,ds:lockedx[bp]
                          mov       al,ds:lockedy[bp]
    ;2right 1 down
                          cmp       al,7
                          jz        knightiswhite8
                          mov       bl,8
                          add       ah,2
                          inc       al
                          mov       cx,ax
                          mul       bl
                          add       al,ch
                          mov       ah,0
                          mov       bx,ax
                          mov       ax,cx
                          mov       dl,teamplaying
                          cmp       GridArrayType[bx],dl
                          jz        knightiswhite8
                          mov       legalmovesx[si],ah
                          mov       legalmovesy[si],al
                          inc       si

                          

    ;


    knightiswhite8:       
                          mov       legalmovesx[si],8
                          mov       legalmovesy[si],8
                          ret
Knightlegalmoves ENDP
getlegalmoves PROC  far                                       ;checks if the move from lockedx,lockedy to get all legal moves
                         
                          mov   al,teamplaying
                          mov   ah,0
                          mov   si,ax
                          mov   ah,0
                          mov   al,lockedy[si]
                          mov   bx,8
                          mul   bx
                          add   al,lockedx[si]
                          mov   bx,ax
                          mov   cl,GridArray[bx]
    ;determining what type of piece that want to move
    ;and what team
    ;blackteam
                          cmp   cl,1                       ;a rook
                          jnz   islegalxy1
   
                          call  rooklegalmoves
    
                          jmp   islegalxyend
    islegalxy1:           cmp   cl,2
                          jnz   islegalxy2
                          call  Knightlegalmoves
                          
    ;;;;;;;;;;;;;;;;;
                          jmp   islegalxyend
    islegalxy2:           cmp   cl,3
                          jnz   islegalxy3
                          mov   isforqueen,0
                          call  bishoplegalmoves
    ;;;;;;;;;;;;;;;;;
                          jmp   islegalxyend
    islegalxy3:           cmp   cl,4
                          jnz   islegalxy4
    ;;;;;;;;;;;;;;;
                          call  Queenlegalmoves
                          jmp   islegalxyend
    islegalxy4:           cmp   cl,5
                          jnz   islegalxy5
                          call  Kinglegalmoves
    ;;;;;;;;;;;;
                          jmp   islegalxyend
    islegalxy5:           cmp   cl,6
                          jnz   islegalxyend
                          call  wpawnlegalmoves
                          call  bpawnlegalmoves
    islegalxyend:         ret
getlegalmoves ENDP

;description
Reset PROC far
    mov kingx[0],4
    mov kingx[1],4
    mov kingy[0],7
    mov kingy[1],0
    
    mov bx,0
    resetloop:
mov al,GridArrayr[bx]
mov GridArray[bx],al
mov al,GridArrayTyper[bx]
mov GridArrayType[bx],al
mov al,GridArraytimer[bx]
mov GridArraytime[bx],al
    inc bx
    cmp bx,64
    jnz resetloop
    ret
Reset ENDP
end