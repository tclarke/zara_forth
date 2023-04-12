;=======================================
; parsing.asm
;
; Parsing and tokenization routines
;=======================================

    MODULE  parsing

WHITESPACE  =       20h     ; SPACE
NULL        =       0       ; NULL
BUFFER_LEN  =       255     ; Maximum buffer length

; Input buffer and current length
ib_len:       BYTE      0
input_buffer: BLOCK     BUFFER_LEN

; Parse area, >IN, and current length
; Double buffer to minimize dropped input characters
pa_idx:       BYTE      0
pa_len:       BYTE      0
parse_area:   BLOCK     BUFFER_LEN

;
; Skip whitespace
;
; @param hl  - Address of the buffer
; @param c   - Maximum length of the buffer.
; @return hl - Address of the first byte of the token
; @return z  - Clear if whitespace was found, set otherwise
;
skip_whitespace:
    ld          b, 0            ; cpir uses the 16-bit bc but we're only allowing 8-bit lengths
    ld          a, WHITESPACE
    cpir
    ld          a, c
    cp          0               ; Check if we hit the end of the buffer so z is set correctly
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

;
; Checks to see if the character is a digit or not.
;
; @param a  - The character byte to check
; @return z - clear if the character is a digit, set otherwise
;
isdigit:
    sub     '0'
    jp      s, 1F       ; if a was < the 0 ascii code then we aren't a digit
    sub     10
    jp      ns, 1F      ; if a was > the 9 ascii code then we aren't a digit
    ld      a, 0
    cp      1           ; clear the Z flag
    ret
1   ld      a, 1
    cp      1           ; set the Z flag
    ret

;
; Macro to copy the input buffer to the parse area
; Clobbers hl, de, and bc
    MACRO .COPY2PARSE
    ld      hl, input_buffer
    ld      de, parse_area
    ld      bc, ib_len
    ldir
    ENDM

;
; Locate the start and end of a token.
;
tokenize:
    ld      hl, parse_area
    ld      bc, pa_idx
    add     hl, bc

    ENDMODULE