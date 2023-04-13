;=======================================
; parsing.asm
;
; Parsing and tokenization routines
;=======================================

    MODULE  parsing

WHITESPACE  =       20h     ; SPACE
BUFFER_LEN  =       255     ; Maximum buffer length

; Input buffer and current length.
; These are WORDs so we can treat them as cells for >IN, etc.
; But we can always read and write ib_len+1 and parse_idx+1 for faster access
; Since the high byte will always be 0 as the maximum buffer length is 255
ib_len:       WORD      0
parse_idx:    WORD      0
input_buffer: BLOCK     BUFFER_LEN

;
; Find the next whitespace character from the current address through the EOB
;
; @param hl  - Address of the first character to check
; @param bc  - Remaining byte count in the buffer
;
; @return hl - The address of the next whitespace character or invalid if none found.
; @return bc - Remainind byte count in the buffer
;
find_whitespace:
    ld      a, WHITESPACE
1:  cpi                 ; this always incs hl and decs bc
    jr      z, 2F       ; character is whitespace
    ret     po          ; character isn't whitespace and we've hit the EOB
    jr      1B          ; keep searching
2:  dec     hl          ; we want to point at the first whitespace character so undo the cpi inc
    inc     c
    ret
    
;
; Skip all whitespace from the current address.
;
; @param hl  - Address of the first character to check
; @param bc  - Remaining byte count in the buffer
;
; @return hl - Address of the next non-whitespace character in the buffer or EOB + 1 if none found
; @return bc - Remainind byte count in the buffer
;
skip_whitespace:
    ld      a, WHITESPACE
1:  cpi
    jr      nz, 2F      ; character is not whitespace
    ret     po          ; character is whitespace and we've hit EOB
    jr      1B          ; continue
2:  dec     hl
    inc     c
    ret

;
; Parse the input buffer for a name.
;
; This will update parse_idx
;
; @return hl - The address of the start of the name
; @return a  - The length of the name
;
parse_name:
    di                  ; disable interrupts for this routine since they can update the buffer
    ; adjust hl bc to account for the parse_idx
    ld      hl, input_buffer
    ld      de, (parse_idx)
    add     hl, de
    ld      a, (ib_len)
    sub     e
    ld      c, a
    ld      b, 0h

    call    skip_whitespace
    push    hl          ; store this so we can return it later

    ld      d, c        ; store this so we can calculate the length
    call    find_whitespace

    ld      a, (ib_len)
    sub     c               ; buf len - remaining will be the new parse_idx
    jr      c, 1F           ; reached end of buffer so c > a
    inc     a               ; need to include 1 more since we already checked for a whitespace char
    ld      (parse_idx), a

    ; calculate the size of the token
    ld      a, d
    sub     c
    pop     hl
    ei
    ret
1:  ld      a, (ib_len)
    ld      (parse_idx), a
    ld      a, 0
    pop     hl
    ei
    ret

    ENDMODULE
