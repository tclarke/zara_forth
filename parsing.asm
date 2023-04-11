;=======================================
; parsing.asm
;
; Parsing and tokenization routines
;=======================================

    MODULE  parsing

WHITESPACE  =       20h     ; SPACE
NULL        =       0       ; NULL
BUFFER_LEN  =       255

;
; Skip whitespace
;
; @param hl  - Address of the buffer
;
; @return hl - Address of the first byte of the token
;
skip_whitespace:
    ld          a, WHITESPACE
    ld          bc, BUFFER_LEN
    cpir
    ret

;
; Compare two NULL terminated strings.
;
; @param hl  - The address of the first string
; @param de  - The address of the second string
; @return z  - clear if the strings are equal, set if they are not
; @return hl - The pointer to the last compared character in string 1
; @return de - The pointer to the last compared character in string 2
;
strcmp:
    ld      a, (hl)     ; load the next character of the first string
    ld      b, a
    ld      a, (de)     ; load the next charater of the second string
    cp      b
    ret     nz          ; return if strings are not equal
    cp      NULL
    ret     z           ; return if NULL..since we know both strings are equal at
                        ; this point, this indicates they are both at the end of the string
    inc     hl          ; move to the next characters
    inc     de
    jr      strcmp

    ENDMODULE