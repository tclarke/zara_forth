;=========================================
; dictionary.asm
;
; Routines to manage the forth dictionary
;=========================================

        MODULE  dictionary

ENTRY_IMPL:     equ     0   ; Pointer to the implementation (execution address)
ENTRY_WLEN:     equ     2   ; Length of the defined word
ENTRY_WORD:     equ     3   ; Start of the word

DICT_LENGTH:    equ     256 ; Maximum dictionary size
dict:           BLOCK   DICT_LENGTH, 00h

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
        xor     a       ; set z indicating equal
        ret

;
; Locate a word in the dictionary
;
; @param hl  - The string to match
; @param bc  - The string length
;
; @return hl - The address of the word's implementation or 0000h if it isn't found
;
find_word:
        ld      ix, dict ; the head of the list

        push    hl     ; save these since .strcmp will change them
        push    bc
        ld      de, (ix+ENTRY_WORD)
        ld      a, (ix+ENTRY_WLEN)

        ret

;
; Insert a word into the dictionary
;
; @param hl  - The string to add
; @param bc  - The string length
; @param de  - The address of the word's implementation
;
insert_word:
        ret

        ENDMODULE
