;=========================================
; dictionary.asm
;
; Routines to manage the forth dictionary
;=========================================

        MODULE  dictionary

ENTRY_IMPL:     equ     0   ; (word) Pointer to the implementation (execution address)
ENTRY_WLEN:     equ     2   ; (byte) Length of the defined word
ENTRY_WORD:     equ     3   ; (var bytes) Start of the word

DICT_LENGTH:    equ     256 ; Maximum dictionary size
dict:           BLOCK   DICT_LENGTH, 00h

    MACRO   NEXT_ENTRY
        ld      hl, ix
        ld      b, 0
        ld      c, (ix+ENTRY_WLEN)
        add     hl, bc
        ld      bc, ENTRY_WORD
        add     hl, bc
        ld      ix, hl
    ENDM

;
; Compare two strings for strict equality.
;
; @param hl - Addr of the first string
; @param de - Addr of the second string
; @param a  - Length of the first string
; @param b  - Length of the second string
;
; @return z - set if equal, clear if not
;
strcmp:
        cp      b       ; which length is smaller
        jp      p, 1F   ; a >= b
        ld      b, a    ; a < b
1:      ld      a, (de)
        cp      (hl)
        ret     nz      ; nz indicating not equal
        inc     hl
        inc     de
        djnz    1B
        cp      a       ; set z indicating equal
        ret

;
; Locate a word in the dictionary
;
; @param ix  - Address of the dictionary
; @param hl  - The string to match
; @param bc  - The string length
;
; @return hl - The address of the word's implementation or 0000h if it isn't found
; @return f  - z set if word found else z clear
;
find_word:
        ld      b, 00h
1:      push    hl     ; save these since .strcmp will change them
        push    bc

        ld      de, ix
        .3 inc de
        ld      a, (ix+ENTRY_WLEN)
        or      a       ; equiv to cp 0
        jr      z, 3F   ; end of list
        ld      b, c
        ld      c, 00h
        call    strcmp
        jr      z, 2F   ; found the word

        ; go to the next entry
        NEXT_ENTRY

        ; restore the saved vars and continue the search
        pop     bc
        pop     hl
        jp      1B 

2:      .4 inc  sp      ; drop bc and hl
        ld      hl, (ix+ENTRY_IMPL)
        ret             ; z is already set

3:      .4 inc  sp      ; drop bc and hl
        ld      hl, 00h
        or      1       ; clear z
        ret


;
; Insert a word into the dictionary.
; This does not do bounds checking.
;
; @param ix  - Address of the dictionary
; @param hl  - The string to add
; @param bc  - The string length
; @param de  - The address of the word's implementation
;
insert_word:
        exx             ; save the data to insert so we can use those registers
1:      ld      a, (ix+ENTRY_WLEN)
        or      a       ; equiv to cp 0
        jr      z, 2F   ; end of list
        NEXT_ENTRY
        jp      1B
        
2:      exx             ; restore the entry info
        ld      (ix+ENTRY_IMPL), de
        ld      (ix+ENTRY_WLEN), c
        ld      de, ix
        .3 inc  de
        ldir

        ret

        ENDMODULE
