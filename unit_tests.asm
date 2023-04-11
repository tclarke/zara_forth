;========================================================
; unit_tests.asm
;
; Collects and executes all unit tests.
;========================================================

    DEVICE ZXSPECTRUM48

    include "unit_tests.inc"

    include "parsing.asm"

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

test_str1:  byte     " 1 22 +\n"
UT_SkipWhitespace:
    ld      hl, test_str1
    call    parsing.skip_whitespace
    TEST_MEMORY_BYTE hl, '1'
    TC_END

    ENDMODULE
