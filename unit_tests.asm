;========================================================
; unit_tests.asm
;
; Collects and executes all unit tests.
;========================================================

    DEVICE ZXSPECTRUM48

    include "unit_tests.inc"

    include "get_next.asm"

; Initialization routine called before all unit tests are
; started.
    UNITTEST_INITIALIZE
    ; Do your initialization here ...
    ; ...
    ; ...
    ; For this simple example we don't need any special initialization.
    ; So we simply return.
    ; Please note: the stack pointer does not need to be setup explicitly
    ; for the unit tests.
    ret

    MODULE TestSuite_IO     ; Tests for I/O and parsing

test_str1:  byte     "1 22 +\n"
UT_GetNext:
    push    ix

    ld      ix, test_str1   ; Beginning of the input buffer to IX
    call    io.get_next     ; Returns token type in A and length in DE
    nop                     ; ASSERTION A == 1
    nop                     ; ASSERTION DE == 1
    TEST_STRING (ix), "1", 1

    add     ix, de          ; Move to the next token. The whitespace should be handled by get_next
    call    io.get_next
    nop                     ; ASSERTION A == 1
    nop                     ; ASSERTION DE == 2
    TEST_STRING (ix), "22", 1

    add     ix, de
    call    io.get_next
    nop                     ; ASSERTION A == 2
    nop                     ; ASSERTION DE == 1
    TEST_STRING (ix), "+", 1

    add     ix, de
    call    io.get_next
    nop                     ; ASSERTION A == 3
    nop                     ; ASSERTION DE == 0

    pop     ix

    TC_END

    ENDMODULE
    SAVESNA "zara_forth_ut.sna", UNITTEST_START