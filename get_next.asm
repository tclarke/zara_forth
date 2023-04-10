;=======================================
; get_next.asm
;
; Tokenization routines
;=======================================

    MODULE  io

TOKEN_NONE  BYTE     0
TOKEN_NUM   BYTE     1
TOKEN_STR   BYTE     2
TOKEN_NL    BYTE     3

; Parse the next token from a specified buffer
; Only SPACE is allowed for whitespace
;
; @param HL  - Address of the buffer
;
; @return HL - Address of the first byte of the token
; @return A  - The token type parsed
; @return DE - The length of the token
;
get_next:

; Skip initial whitespace
    ld          A, ' '
    ld          hl, ix
    ld          bc, 255     ; maximum token length
    cpir
    jp          z, .check_char
    ; handle error
    ld          a, TOKEN_NONE
    ld          d, 0
    ret

; Check for a number
.check_char:
    push        hl

    ld          a, '1'

; Scan looking for whitespace, changing token type if a non-number is encountered

    ret

    ENDMODULE