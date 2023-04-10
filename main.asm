;===========================================================================
; main.asm
;===========================================================================

    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM48


    ORG 0x4000
    defs 0x6000 - $    ; move after screen area
screen_top: defb    0   ; WPMEMx


;===========================================================================
; Persistent watchpoint.
; Change WPMEMx (remove the 'x' from WPMEMx) below to activate.
; If you do so the program will hit a breakpoint when it tries to
; write to the first byte of the 3rd line.
; When program breaks in the fill_memory sub routine please hover over hl
; to see that it contains 0x5804 or COLOR_SCREEN+64.
;===========================================================================

; WPMEMx 0x5840, 1, w


;===========================================================================
; Include modules
;===========================================================================
    include "utilities.asm"
    include "unit_tests.asm"


;===========================================================================
; main routine - the code execution starts here.
; Sets up the new interrupt routine, the memory
; banks and jumps to the start loop.
;===========================================================================


 defs 0x8000 - $
 ORG $8000

main:
    ; Disable interrupts
    di
    ld sp,stack_top

    ; CLS
    ;call clear_screen
    ;call clear_backg

    ; Init
    ;ld hl,fill_colors
    ;ld (fill_colors_ptr),hl
    ;ld de,COLOR_SCREEN

    ld hl, 0

    ; Enable interrupts
    im 1
    ei

main_loop:
    ; fill line with color
    ;ld hl,(fill_colors_ptr)
    ;ld a,(hl)
    ;call fill_bckg_line

    ; break
    push de
    ld de,PAUSE_TIME
    call pause
    pop de

    ; Alternatively wait on vertical interrupt
    ;halt

    inc hl

    ; next line
    ;call inc_fill_colors_ptr

    jr main_loop


;===========================================================================
; Stack.
;===========================================================================


; Stack: this area is reserved for the stack
STACK_SIZE: equ 100    ; in words


; Reserve stack space
    defw 0  ; WPMEM, 2
stack_bottom:
    defs    STACK_SIZE*2, 0
stack_top:
    ;defw 0
    defw 0  ; WPMEM, 2



    SAVESNA "zara_forth.sna", main
