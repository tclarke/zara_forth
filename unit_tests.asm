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

test_str1:  byte     " 1 22 +\N\0"
UT_SkipWhitespace:
    ld      hl, test_str1
    call    parsing.skip_whitespace
    TEST_MEMORY_BYTE hl, '1'
    TC_END

test_str2:  byte     " 1 22 +\0"
test_str3:  byte     " 1 21 +\N\0"
UT_StrCmp:
    ld      hl, test_str1
    ld      de, test_str1
    call    parsing.strcmp
    TEST_FLAG_Z
    TEST_MEMORY_BYTE hl, 0
    TEST_MEMORY_BYTE de, 0

    ld      hl, test_str1
    ld      de, test_str2
    call    parsing.strcmp
    TEST_FLAG_NZ
    TEST_MEMORY_BYTE hl, 0ah  ; NL
    TEST_MEMORY_BYTE de, 0

    ld      hl, test_str1
    ld      de, test_str3
    call    parsing.strcmp
    TEST_FLAG_NZ
    TEST_MEMORY_BYTE hl, 32h  ; '2'
    TEST_MEMORY_BYTE de, 31h  ; '1'
    TC_END

UT_IsDigit:
    ld      a, '0'
    call parsing.isdigit
    TEST_FLAG_NZ

    ld      a, '5'
    call parsing.isdigit
    TEST_FLAG_NZ

    ld      a, '9'
    call parsing.isdigit
    TEST_FLAG_NZ

    ld      a, '/'
    call parsing.isdigit
    TEST_FLAG_Z

    ld      a, ':'
    call parsing.isdigit
    TEST_FLAG_Z
    TC_END

    ENDMODULE
