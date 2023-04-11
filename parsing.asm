;=======================================
; parsing.asm
;
; Parsing and tokenization routines
;=======================================

    MODULE  parsing

WHITESPACE: equ     ' '
BUFFER_LEN: equ     255

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

    ENDMODULE