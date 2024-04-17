; CS 274 Spring 24 - IPA 3: 
; Author: Mia Sideris
; Goal: Implement a program in TASM that will display card values obtained from a standard deck of 52 cards
.model small
.stack 100h

.data
    cards db 52 dup (0)
    card_rep db 13 dup ('$')
    suits db 'Hearts', 'Diamonds', 'Clubs', 'Spades', '$' ; Suits in a deck
    numbers db 'Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', '$' ; Numbers in a deck
    
    player_bets db "Player bet: $5", 13, 10, '$'
    player_wins db "Player wins: $10", 13, 10, '$'

.code
    main proc
        mov ax, @data
        mov ds, ax
        call generate_deck
        mov cx, 52 ; Start loop at 52
        mov si, 0 ; Start at index of 0
    display_cards_loop:
        mov al, [cards + si] ; Get card values from array
        call get_card_representation
        lea dx, card_rep ; Load in string representations
        ; Print to display
        mov ah, 09h
        int 21h

        add si, 1
        loop display_cards_loop

        lea dx, player_bets
        call print_string

        lea dx, player_wins
        call print_string

    ; Terminate program
        mov ah, 4Ch
        int 21h

    main endp

    generate_deck proc
        mov cx, 52 ; Start loop at 52
        mov di, 0 ; Start at index of 0
    generate_deck_loop:
        mov [cards + di], cl ; Keep storing current card value
        inc di ; Go to next memory location
        loop generate_deck_loop
        ret
    generate_deck endp

get_card_representation proc
    push ax ; Push old card to end of stack
    mov dl, bl ; Copy current card to dl   
    mov ah, 0 ; Clear ah        
    mov cx, 13 ; Divide by 13, each suit has 13 cards 
    div cx 
    add bx, dx ; Point to correct suit    
    mov al, [suits + bx] ; Get suit
    mov [card_rep + 7], al ; Replace suit from before
    pop ax ; Pop new card to the top of stack
    ret
get_card_representation endp

    print_string proc
    ; Push values in ax, dx to end of stack
        push ax
        push dx
    ; Print
        mov ah, 09h
        int 21h
    ; Pop values to start of stack
        pop dx
        pop ax
        ret
    print_string endp

end main
