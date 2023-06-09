;========================================================
; unit_tests.asm
;
; Collects and executes all unit tests.
;========================================================

    DEVICE ZXSPECTRUM48

    include "unit_tests.inc"

    include "parsing.asm"
    include "dictionary.asm"

test_str1:  byte    "123 45 -\N"     ; bog standard input string
len1:       equ     9
test_str2:  byte    " 1 22 +\N"      ; starts with a space
len2:       equ     10
test_str3:  byte    "1 22 +"         ; doesn't end in a newline
len3:       equ     6
test_str4:  byte    "1 21  +\N"      ; 2 spaces in a row
len4:       equ     8
test_str5:  byte    "1234\n"         ; no whitespace
len5:       equ     5

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

    MODULE TestSuite_Parsing     ; Tests parsing
; TODO: UT_FindWhitespace and UT_SkipWhitespace should have
; ASSERT HL == test_str1+3
; tests, but I keep getting "test_str1 label not found".
UT_FindWhitespace:
    ld      hl, test_str1
    ld      bc, len1
    call    parsing.find_whitespace
    nop ; ASSERTION BC == 6

    ld      hl, test_str2
    ld      bc, len2
    call    parsing.find_whitespace
    nop ; ASSERTION BC == 10

    ld      hl, test_str5
    ld      bc, len5
    call    parsing.find_whitespace
    nop ; ASSERTION BC == 0

    TC_END

UT_SkipWhitespace:
    ld      hl, test_str2
    ld      bc, len2
    call    parsing.skip_whitespace
    nop ; ASSERTION BC == 9

    ld      hl, test_str4
    ld      bc, 4           ; set the index at the double whitespace
    add     hl, bc
    ld      a, len4
    sub     c
    ld      c, a
    call    parsing.skip_whitespace
    nop ; ASSERTION BC == 2

    TC_END

    MACRO   SETUP_PARSENAME  str?, n?
    ld      hl, str?
    ld      de, parsing.input_buffer
    ld      bc, n?
    ldir
    ld      a, 0
    ld      (parsing.parse_idx), a
    ld      a, n?
    ld      (parsing.ib_len), a
    ENDM

UT_ParseName:
    SETUP_PARSENAME test_str1, len1
    call   parsing.parse_name
    nop ; ASSERTION A == 3
    TEST_MEMORY_WORD    parsing.parse_idx, 4
    call   parsing.parse_name
    nop ; ASSERTION A == 2
    TEST_MEMORY_WORD    parsing.parse_idx, 7

    SETUP_PARSENAME test_str2, len2
    call   parsing.parse_name
    nop ; ASSERTION A == 1
    TEST_MEMORY_WORD    parsing.parse_idx, 3
    call   parsing.parse_name
    nop ; ASSERTION A == 2
    TEST_MEMORY_WORD    parsing.parse_idx, 6

    SETUP_PARSENAME test_str3, len3
    call   parsing.parse_name
    nop ; ASSERTION A == 1
    TEST_MEMORY_WORD    parsing.parse_idx, 2
    call   parsing.parse_name
    nop ; ASSERTION A == 2
    TEST_MEMORY_WORD    parsing.parse_idx, 5
    call   parsing.parse_name
    nop ; ASSERTION A == 1
    TEST_MEMORY_WORD    parsing.parse_idx, 7
    call   parsing.parse_name
    nop ; ASSERTION A == 0
    TEST_MEMORY_WORD    parsing.parse_idx, len3

    TC_END

    ENDMODULE

    MODULE TestSuit_Dictionary

UT_Strcmp:
    ld      hl, test_str1
    ld      a, len1
    ld      de, test_str1
    ld      b, len1
    call    dictionary.strcmp
    TEST_FLAG_Z

    ld      hl, test_str3
    ld      a, len3
    ld      de, test_str4
    ld      b, len4
    call    dictionary.strcmp
    TEST_FLAG_NZ

    ld      hl, test_str4
    ld      a, len4
    ld      de, test_str1
    ld      b, len3
    call    dictionary.strcmp
    TEST_FLAG_NZ

    TC_END

test_dict:
w1: WORD    0001h
    BYTE    4
    BYTE    "word"
w2: WORD    0002h
    BYTE    1
    BYTE    "+"
w3: WORD    0003h
    BYTE    2
    BYTE    "zz"
el: WORD    0000h
    BYTE    0

    MACRO   INIT_FINDWORD   word?
    ld      ix, test_dict
    ld      hl, word?+2
    ld      b, 00h
    ld      c, (hl)
    inc     hl
    ENDM

    MACRO   INIT_INSERTWORD word?
    ld      ix, dictionary.dict
    ld      hl, word?
    ld      de, (hl)
    .2 inc  hl
    ld      b, 00h
    ld      c, (hl)
    inc     hl
    ENDM

UT_FindWord:
    INIT_FINDWORD w1
    call    dictionary.find_word
    TEST_FLAG_Z
    nop ; ASSERTION hl == 1

    INIT_FINDWORD w2
    call    dictionary.find_word
    TEST_FLAG_Z
    nop ; ASSERTION hl == 2

    INIT_FINDWORD w3
    call    dictionary.find_word
    TEST_FLAG_Z
    nop ; ASSERTION hl == 3

    ld      ix, test_dict
    ld      hl, test_str1
    ld      bc, len1
    call    dictionary.find_word
    TEST_FLAG_NZ
    nop ; ASSERTION hl == 0

    TC_END

UT_InsertWord:
    INIT_INSERTWORD w3
    call    dictionary.insert_word

    INIT_INSERTWORD w2
    call    dictionary.insert_word

    INIT_INSERTWORD w1
    call    dictionary.insert_word

    INIT_INSERTWORD w1
    call dictionary.find_word
    TEST_FLAG_Z
    nop ; ASSERTION hl == 1

    INIT_INSERTWORD w2
    call dictionary.find_word
    TEST_FLAG_Z
    nop ; ASSERTION hl == 2

    INIT_INSERTWORD w3
    call dictionary.find_word
    TEST_FLAG_Z
    nop ; ASSERTION hl == 3

    TC_END

    ENDMODULE
